//
//  AppWindow.swift
//  NWHacks2019
//
//  Created by Nathan Tannar on 2019-01-26.
//  Copyright © 2019 Nathan Tannar. All rights reserved.
//

import UIKit

class AppWindow: UIWindow {

    // MARK: - Properties

    var isPrivacyBlurEnabled: Bool = true {
        didSet {
            isPrivacyBlurEnabledDidChange()
        }
    }

    var isVoiceIDIndicatorHidden: Bool = true {
        didSet {
            isVoiceIDIndicatorHiddenDidChange()
        }
    }

    var isActivityIndicatorVisible: Bool = false {
        didSet {
            isActivityIndicatorVisibleDidChange()
        }
    }

    // MARK: - Views

    private lazy var blurView = UIVisualEffectView(style: Stylesheet.VisualEffectView.regular)

    private lazy var activityIndicator: ActivitySpinnerIndicator = {
        let view = ActivitySpinnerIndicator()
        view.tintColor = .white
        view.spinnerInset = UIEdgeInsets(all: 8)
        view.backgroundColor = UIColor.darkGrayColor
        view.isUserInteractionEnabled = false
        view.layer.cornerRadius = 16
        view.layer.addShadow(color: UIColor.lightGrayColor)
        return view
    }()

    private lazy var voiceIdIndicator = VoiceIDIndicator()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        viewDidLoad()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        viewDidLoad()
    }

    func viewDidLoad() {
        backgroundColor = .white
    }

    // MARK: - Methods

    override func layoutSubviews() {
        super.layoutSubviews()
        if isActivityIndicatorVisible {
            activityIndicator.startAnimating()
            bringSubviewToFront(activityIndicator)
        }
        if isPrivacyBlurEnabled {
            bringSubviewToFront(blurView)
            blurView.frame = bounds
        }
        if !isVoiceIDIndicatorHidden {
            bringSubviewToFront(voiceIdIndicator)
        }
    }

    private func isPrivacyBlurEnabledDidChange() {
        if isPrivacyBlurEnabled {
            blurView.alpha = 0
            addSubview(blurView)
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.blurView.alpha = 1
            }
        } else {
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.blurView.alpha = 0
            }) { [weak self] _ in
                self?.blurView.removeFromSuperview()
            }
        }
    }

    private func isActivityIndicatorVisibleDidChange() {
        if isActivityIndicatorVisible {
            activityIndicator.startAnimating()
            activityIndicator.alpha = 0
            addSubview(activityIndicator)
            activityIndicator.anchorCenterToSuperview()
            activityIndicator.anchor(to: CGSize(width: 80, height: 80))
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.activityIndicator.alpha = 1
            }
        } else {
            activityIndicator.stopAnimating()
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.activityIndicator.alpha = 0
            }) { [weak self] _ in
                self?.activityIndicator.removeFromSuperview()
            }
        }
    }

    private func isVoiceIDIndicatorHiddenDidChange() {
        if isVoiceIDIndicatorHidden {
            voiceIdIndicator.stopDisplayLink()
            voiceIdIndicator.removeFromSuperview()
        } else {
            addSubview(voiceIdIndicator)
            voiceIdIndicator.anchorCenterToSuperview()
            voiceIdIndicator.anchor(widthConstant: 125, heightConstant: 125)
            voiceIdIndicator.startDisplayLink()

            voiceIdIndicator.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .curveEaseIn, animations: {
                self.voiceIdIndicator.transform = .identity
            }, completion: nil)
        }
    }

    func prepareVoidId() {
        voiceIdIndicator.startAnimating()
    }

    func voiceIdSuccess() {
        voiceIdIndicator.stopAnimating()
        voiceIdIndicator.voiceIdSuccess {
            self.isVoiceIDIndicatorHidden = true
        }
    }

    func voiceIdFailed() {
        voiceIdIndicator.stopAnimating()
        voiceIdIndicator.voiceIdFailed()
    }
}
