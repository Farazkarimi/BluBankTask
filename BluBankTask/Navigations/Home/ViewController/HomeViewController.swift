//
//  HomeViewController.swift
//  BluBankTask
//
//  Created by Faraz on 11/23/23.
//

import UIKit
import Combine

class HomeViewController: UIViewController {

    enum Constant {
        static let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .estimated(80.0))
        static let allItemHeight: CGFloat = 60.0
        static let debounceTime: Int = 200
        static let favoriteHeader = "Favorites"
        static let allHeader = "All"
        static let favoriteItemSize = CGSize(width: 100.0, height: 100.0)
        static let zeroItemSize = NSCollectionLayoutSection(group: .init(layoutSize: .init(widthDimension: .absolute(0), heightDimension: .absolute(0))))
    }

    private enum Section: Int, Hashable, CaseIterable {
        case favorites
        case all
    }

    private enum SectionItem: Equatable, Hashable {
        case favorites(TransferDestinationViewModel)
        case all(TransferDestinationViewModel)
        case indicator
    }

    private let refreshControl = UIRefreshControl()
    @IBOutlet private weak var collectionView: UICollectionView!

    private var dataSource: UICollectionViewDiffableDataSource<Section, SectionItem>?
    private var viewModel: HomeViewModelProtocol
    private var cancellables: Set<AnyCancellable> =  .init()

    init(viewModel: HomeViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        update()
    }

    private func setupCollectionView() {
        dataSource = makeDataSource()
        collectionView.delegate = self
        collectionView.collectionViewLayout = generateLayout()
        collectionView.dataSource = dataSource
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshCollection), for: .valueChanged)
        refreshControl.endRefreshing()
    }

    @objc private func refreshCollection() {

    }
}

extension HomeViewController: UICollectionViewDelegate {
    //MARK: CollectionView Delegates
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(">>>> Selected")
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }
}

extension HomeViewController {
    //MARK: Make Datasource
    private func update(animate: Bool = false) {
        Task {
            var snapshot = NSDiffableDataSourceSnapshot<Section, SectionItem>()
            snapshot.appendSections([Section.all])
            dataSource?.apply(snapshot, animatingDifferences: animate)
        }
    }

    private func makeDataSource() -> UICollectionViewDiffableDataSource<Section, SectionItem> {
        makeCellsRegistration()
        let dataSource: UICollectionViewDiffableDataSource<Section, SectionItem> = UICollectionViewDiffableDataSource(
            collectionView: collectionView,
            cellProvider: { [weak self] (collectionView, indexPath, item) -> UICollectionViewCell? in
                guard let self = self else { return UICollectionViewCell() }
                switch item {
                case let .all(item):
                    return self.makeAllSectionCell(on: collectionView,
                                                   for: indexPath,
                                                   with: AllItemsViewConfiguration(title: item.fullName,
                                                                                   subtitle: item.cardNumber,
                                                                                   imageURL: item.avatar,
                                                                                   isFavorite: item.isFavorite))
                case let .favorites(item):
                    return self.makeFavoritesSectionCell(on: collectionView,
                                                         for: indexPath,
                                                         with: FavoritesViewConfiguration(title: item.fullName,
                                                                                          subtitle: item.cardNumber,
                                                                                          imageURL: item.avatar))
                case .indicator:
                    return self.makeIndicatorSectionCell(on: collectionView,
                                                         for: indexPath,
                                                         with: IndicatorViewConfiguration(state: .start))
                }
            }
        )

        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) -> UICollectionReusableView? in
            guard kind == UICollectionView.elementKindSectionHeader,
                  let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderCollectionReusableView.cellIdentifier, for: indexPath) as? HeaderCollectionReusableView else { return nil }
            if self.dataSource?.numberOfSections(in: self.collectionView) == Section.allCases.count {
                switch indexPath.section {
                case 0:
                    headerView.configHeader(with: Constant.favoriteHeader)
                case 1:
                    headerView.configHeader(with: Constant.allHeader)
                default:
                    break
                }
            } else {
                headerView.configHeader(with: Constant.allHeader)
            }
            return headerView
        }

        return dataSource
    }

    //MARK: Make Cells

    private func makeCellsRegistration() {
        collectionView.register(
            HeaderCollectionReusableView.nib,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HeaderCollectionReusableView.cellIdentifier
        )
        collectionView.registerCellTypeForClass(FavoritesCollectionViewCell.self)
        collectionView.registerCellTypeForClass(AllCollectionViewCell.self)
    }

    private func makeAllSectionCell(on collection: UICollectionView, for indexPath: IndexPath, with config: AllItemsViewConfiguration) -> UICollectionViewCell {
        let cell: AllCollectionViewCell = collectionView.dequeueReusableCellType(indexPath)
        cell.contentConfiguration = config
        config.didTapOnFavorite
            .debounce(for: .milliseconds(Constant.debounceTime),
                      scheduler: RunLoop.main)
            .sink { [weak self] _ in
                guard let self else { return }
            }.store(in: &cancellables)
        return cell
    }

    private func makeFavoritesSectionCell(on collection: UICollectionView, for indexPath: IndexPath, with config: FavoritesViewConfiguration) -> UICollectionViewCell {
        let cell: FavoritesCollectionViewCell = collectionView.dequeueReusableCellType(indexPath)
        cell.contentConfiguration = config
        return cell
    }

    private func makeIndicatorSectionCell(on collection: UICollectionView, for indexPath: IndexPath, with config: IndicatorViewConfiguration) -> UICollectionViewCell {
        let cell: IndicatorCollectionViewCell = collectionView.dequeueReusableCellType(indexPath)
        cell.contentConfiguration = config
        return cell
    }
}

extension HomeViewController {
    //MARK: Create Layout
    private func favoritesCollectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(Constant.favoriteItemSize.width),
                                               heightDimension: .estimated(Constant.favoriteItemSize.height))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        let boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(layoutSize: Constant.headerSize,
                                                        elementKind: UICollectionView.elementKindSectionHeader,
                                                        alignment: .top)
        ]
        section.boundarySupplementaryItems = boundarySupplementaryItems
        section.interGroupSpacing = 8
        return section
    }

    private func allCollectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .absolute(Constant.allItemHeight))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(Constant.allItemHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       repeatingSubitem: item,
                                                       count: 1)
        let section = NSCollectionLayoutSection(group: group)
        let boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(layoutSize: Constant.headerSize,
                                                        elementKind: UICollectionView.elementKindSectionHeader,
                                                        alignment: .top)
        ]
        section.boundarySupplementaryItems = boundarySupplementaryItems
        section.interGroupSpacing = 8
        return section
    }

    private func generateLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex: Int, _) -> NSCollectionLayoutSection? in
            guard let self else {
                return Constant.zeroItemSize
            }
            if self.dataSource?.numberOfSections(in: self.collectionView) == Section.allCases.count {
                switch sectionIndex {
                case Section.favorites.rawValue:
                    return self.favoritesCollectionLayout()
                case Section.all.rawValue:
                    return self.allCollectionLayout()
                default:
                    return Constant.zeroItemSize
                }
            } else {
                return self.allCollectionLayout()
            }
        }
        return layout
    }
}
