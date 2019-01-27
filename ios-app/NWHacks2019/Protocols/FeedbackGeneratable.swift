//
//  FeedbackGeneratable.swift
//  NWHacks2019
//
//  Created by Nathan Tannar on 2019-01-26.
//  Copyright © 2019 Nathan Tannar. All rights reserved.
//

import UIKit

protocol FeedbackGeneratable {

    typealias FeedbackType = UINotificationFeedbackGenerator.FeedbackType

    func generateSelectionFeedback()
    func generateImpactFeedback()
    func generateNotificationFeedback(type: FeedbackType)
}

extension FeedbackGeneratable {

    func generateSelectionFeedback() {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }

    func generateImpactFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
    }

    func generateNotificationFeedback(type: FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
}

