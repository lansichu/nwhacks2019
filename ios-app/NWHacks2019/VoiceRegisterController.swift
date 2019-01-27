//
//  VoiceRegisterController.swift
//  NWHacks2019
//
//  Created by Nathan Tannar on 2019-01-26.
//  Copyright © 2019 Nathan Tannar. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import AVFoundation
import Accelerate
import SwiftKeychainWrapper

final class VoiceRegiserView: View {
    private enum AnimationKey: String {
        case opacity, lineWidth, transform, fade
        case transformY = "transform.y"
    }

    let label = UILabel(style: Stylesheet.Labels.subtitle) {
        $0.textColor = .white
        $0.numberOfLines = 0
        $0.text = "Say:\n\"My voice is stronger than passwords\""
    }

    let recordButton = Button(style: Stylesheet.AnimatedButtons.primary) {
        $0.titleLabel.font = Stylesheet.Fonts.subtitleFont
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("Start Recording", for: .normal)
        $0.setBackgroundColor(.grayColor, for: .normal)
        $0.setBackgroundColor(UIColor.grayColor.withAlphaComponent(0.3), for: .disabled)
        $0.roundingMethod = .partial(radius: 8)
    }

    let continueButton = Button(style: Stylesheet.AnimatedButtons.primary) {
        $0.titleLabel.font = Stylesheet.Fonts.subtitleFont
        $0.setTitleColor(.darkGrayColor, for: .normal)
        $0.setTitle("Continue", for: .normal)
        $0.setBackgroundColor(.lightGrayColor, for: .normal)
        $0.setBackgroundColor(UIColor.lightGrayColor.withAlphaComponent(0.3), for: .disabled)
        $0.roundingMethod = .partial(radius: 8)
    }

    let skipButton = Button(style: Stylesheet.AnimatedButtons.secondary) {
        $0.setTitle("Skip Demo", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.setBackgroundColor(.white, for: .normal)
        $0.roundingMethod = .partial(radius: 4)
    }

    private var displayLink: CADisplayLink?
    private var startTime: CFAbsoluteTime?

    private let waveLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.white.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.lineWidth = 4
        return layer
    }()

    let errorLabel = UILabel(style: Stylesheet.Labels.description) {
        $0.textColor = .red
    }

    var isAnimating = false

    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundColor = UIColor.blackColor.lighter()
        addSubviews(continueButton, recordButton, errorLabel, label, skipButton)

        layer.addSublayer(waveLayer)

        skipButton.anchor(topAnchor, left: leftAnchor, topConstant: 0, leftConstant: 12, widthConstant: 100, heightConstant: 30)

        label.anchor(topAnchor, left: leftAnchor, right: rightAnchor, topConstant: 50, leftConstant: 20, rightConstant: 20)

        recordButton.anchor(bottom: bottomAnchor, bottomConstant: 100, widthConstant: 200, heightConstant: 60)
        recordButton.anchorCenterXToSuperview()

        continueButton.anchor(bottom: bottomAnchor, bottomConstant: 100, widthConstant: 200, heightConstant: 60)
        continueButton.anchorCenterXToSuperview()

        errorLabel.anchor(continueButton.bottomAnchor, topConstant: 12)
        errorLabel.anchorCenterXToSuperview()
    }

    func startDisplayLink() {
        startTime = CFAbsoluteTimeGetCurrent()
        displayLink?.invalidate()
        displayLink = CADisplayLink(target: self, selector:#selector(handleDisplayLink(_:)))
        displayLink?.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
    }

    func stopDisplayLink() {
        displayLink?.invalidate()
        displayLink = nil
        waveLayer.path = nil
    }

    /// Handle the display link timer.
    ///
    /// - Parameter displayLink: The display link.

    @objc func handleDisplayLink(_ displayLink: CADisplayLink) {
        let elapsed = CFAbsoluteTimeGetCurrent() - startTime!
        waveLayer.path = wave(at: elapsed).cgPath
    }

    /// Create the wave at a given elapsed time.
    ///
    /// You should customize this as you see fit.
    ///
    /// - Parameter elapsed: How many seconds have elapsed.
    /// - Returns: The `UIBezierPath` for a particular point of time.

    private func wave(at elapsed: Double) -> UIBezierPath {
        let centerY = bounds.height / 2
        let amplitude = 30 - abs(fmod(CGFloat(elapsed), 3) - 1.5) * 20

        func f(_ x: Int) -> CGFloat {
            return sin(((CGFloat(x) / bounds.width) + CGFloat(elapsed)) * 4 * .pi) * amplitude + centerY
        }

        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: f(0)))
        for x in stride(from: 0, to: Int(bounds.width + 9), by: 3) {
            path.addLine(to: CGPoint(x: CGFloat(x), y: f(x)))
        }

        return path
    }
}

final class VoiceRegisterController: ViewModelController<VoiceRegisterVM, VoiceRegiserView> {

    override func bindToViewModel() {
        super.bindToViewModel()

        rootView.errorLabel.text = KeychainWrapper.standard.string(forKey: "id")

        viewModel.requestMicAccess().subscribe().disposed(by: disposeBag)

        rootView.recordButton.rx.controlEvent(.touchUpInside)
            .asObservable()
            .subscribe { [weak self] _ in
                self?.viewModel.toggleRecording()
        }.disposed(by: disposeBag)

        rootView.continueButton.rx.controlEvent(.touchUpInside)
            .debounce(0.3, scheduler: MainScheduler.instance)
            .asObservable()
            .subscribe { [weak self] _ in
                self?.viewModel.next(sample: true)
        }.disposed(by: disposeBag)

        rootView.continueButton.rx.controlEvent(.touchDragExit)
            .debounce(0.3, scheduler: MainScheduler.instance)
            .asObservable()
            .subscribe { [weak self] _ in
                self?.viewModel.next(sample: false)
        }.disposed(by: disposeBag)

        viewModel.state.subscribeOn(MainScheduler.instance)
            .subscribe { [weak self] state in
                switch state {
                case .next(let recordingState):
                    DispatchQueue.main.async { [weak self] in
                        self?.stateDidChange(recordingState)
                    }
                case .completed, .error:
                    break
                }
        }.disposed(by: disposeBag)

        viewModel.enrollmentsRemain
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { (value) in
                DispatchQueue.main.async {
                    if value == 3 {
                        self.rootView.label.text = "Say:\n\"My voice is stronger than passwords\""
                    } else if value == 2 {
                        self.rootView.label.text = "Say:\n\"My voice is stronger than passwords\"\nagain"
                    } else if value == 1 {
                        self.rootView.label.text = "Say:\n\"My voice is stronger than passwords\"\none more time"
                    }
                }
        }).disposed(by: disposeBag)

        rootView.skipButton.rx.controlEvent(.touchUpInside)
            .asObservable()
            .subscribe { [weak self] _ in
                self?.viewModel.skip()
        }.disposed(by: disposeBag)
    }

    private func stateDidChange(_ state: VoiceRegisterVM.State) {
        switch state {
        case .recording:
            rootView.recordButton.setTitle("Done", for: .normal)
            rootView.recordButton.setBackgroundColor(.red, for: .normal)
            rootView.recordButton
                .setBackgroundColor(UIColor.red.darker(), for: .highlighted)
            rootView.startDisplayLink()
            UIView.animate(withDuration: 0.5) {
                self.rootView.continueButton.alpha = 0
                self.rootView.recordButton.transform = .identity
            }
        case .sampled:
            rootView.stopDisplayLink()
            viewModel.playSample()
            rootView.continueButton.alpha = 0
            UIView.animate(withDuration: 0.5) {
                self.rootView.continueButton.alpha = 1
                self.rootView.recordButton.transform = CGAffineTransform(translationX: 0, y: -70)
            }
            fallthrough
        case .ready, .sampled:
            rootView.recordButton.isEnabled = true
            rootView.recordButton.setTitle("Record", for: .normal)
            rootView.recordButton.setBackgroundColor(.grayColor, for: .normal)
            rootView.recordButton
                .setBackgroundColor(UIColor.grayColor.darker(), for: .highlighted)

        case .failed(let error):
            rootView.errorLabel.text = error.localizedDescription

        case .waiting:
            rootView.recordButton.isEnabled = false
        }
    }
}
