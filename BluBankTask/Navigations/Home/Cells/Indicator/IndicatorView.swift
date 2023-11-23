//
//  IndicatorView.swift
//  BluBankTask
//
//  Created by Faraz on 11/23/23.
//

import UIKit

final class IndicatorView: UIView, UIContentView, Xibbed {

    private var viewConfiguration: IndicatorViewConfiguration? {
        configuration as? IndicatorViewConfiguration
    }

    var configuration: UIContentConfiguration {
        didSet {
            updateConfiguration()
        }
    }
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    init(configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        setup()
    }

    private func setup() {
        xibSetup()
        updateConfiguration()
    }

    required init?(coder: NSCoder) {
        self.configuration = IndicatorViewConfiguration(state: .start)
        super.init(coder: coder)
        setup()
    }


    private func updateConfiguration() {
        guard let configuration = viewConfiguration else { return }
        switch configuration.state {
        case .start:
            activityIndicator.startAnimating()
        case .stop:
            activityIndicator.stopAnimating()
        }
    }
}
