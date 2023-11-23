//
//  IndicatorViewConfiguration.swift
//  BluBankTask
//
//  Created by Faraz on 11/23/23.
//

import UIKit

struct IndicatorViewConfiguration: UIContentConfiguration {

    enum AnimationState {
        case start
        case stop
    }

    let state: AnimationState

    func makeContentView() -> UIView & UIContentView {
        let view = IndicatorView(configuration: self)
        let screenWidth = UIScreen.main.bounds.width
        view.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenWidth)
        return view
    }

    func updated(for state: UIConfigurationState) -> Self {
        self
    }
}

