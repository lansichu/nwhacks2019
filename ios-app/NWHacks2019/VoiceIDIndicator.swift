//
//  VoiceIDIndicator.swift
//  NWHacks2019
//
//  Created by Nathan Tannar on 2019-01-26.
//  Copyright © 2019 Nathan Tannar. All rights reserved.
//

import UIKit
import AudioToolbox

final class VoiceIDIndicator: View, FeedbackGeneratable {
    private var displayLink: CADisplayLink?
    private var startTime: CFAbsoluteTime?

    private let waveLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.primaryColor.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.lineWidth = 3
        return layer
    }()

    private let circleLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.white.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.lineWidth = 3
        return layer
    }()

    private let circleMaskLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.lightGrayColor.cgColor
        return layer
    }()

    let activityIndicator = ActivitySpinnerIndicator()

    private var label = UILabel(style: Stylesheet.Labels.description) {
        $0.text = "Voice ID"
        $0.font = UIFont.boldSystemFont(ofSize: 12.5)
        $0.textColor = .lightGrayColor
        $0.adjustsFontSizeToFitWidth = true
        $0.numberOfLines = 1
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        label.textAlignment = .center
        activityIndicator.tintColor = .white
        addSubview(label)
        addSubview(activityIndicator)
        layer.addSublayer(circleLayer)
        circleLayer.addSublayer(circleMaskLayer)
        circleMaskLayer.mask = waveLayer
        layer.cornerRadius = 16
        backgroundColor = .darkGrayColor
        layer.addShadow(to: .bottom(3), opacity: 0.3, radius: 10, color: .shadowColor)
    }

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        label.frame = CGRect(x: 10, y: bounds.height - 30, width: bounds.width - 20, height: 20)
        let size = layer.bounds.insetBy(dx: 25, dy: 25).size
        circleLayer.frame = CGRect(origin: CGPoint(x: 25, y: 10), size: size)
        activityIndicator.frame = CGRect(origin: CGPoint(x: 25, y: 10), size: size)
        let path = UIBezierPath(roundedRect: CGRect(origin: .zero, size: size), cornerRadius: size.width / 2).cgPath
        circleLayer.path = path
        circleMaskLayer.path = path
        waveLayer.frame = circleLayer.bounds
    }

    func startAnimating() {
        activityIndicator.startAnimating()
        circleLayer.isHidden = true
    }

    func stopAnimating() {
        activityIndicator.stopAnimating()
        circleLayer.isHidden = false
    }

    func startDisplayLink() {
        startTime = CFAbsoluteTimeGetCurrent()
        displayLink?.invalidate()
        displayLink = CADisplayLink(target: self, selector:#selector(handleDisplayLink(_:)))
        displayLink?.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
        generateImpactFeedback()
    }

    func stopDisplayLink() {
        displayLink?.invalidate()
        displayLink = nil
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
        let centerY = circleLayer.bounds.height / 2
        let amplitude = CGFloat(25) - abs(fmod(CGFloat(elapsed), 3) - 1.5) * 20

        func f(_ x: Int) -> CGFloat {
            return sin(((CGFloat(x) / circleLayer.bounds.width) + CGFloat(elapsed)) * 4 * .pi) * amplitude + centerY
        }

        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: f(0)))
        for x in stride(from: 0, to: Int(circleLayer.bounds.width + 9), by: 3) {
            path.addLine(to: CGPoint(x: CGFloat(x), y: f(x)))
        }

        return path
    }

    func voiceIdSuccess(completion: @escaping ()->Void) {
        label.text = "Success"
        label.textColor = .green
        generateImpactFeedback()
        AudioServicesPlaySystemSound(1054)
        UIView.animate(withDuration: 0.3, delay: 2, options: [], animations: {
            self.alpha = 0.7
            self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { _ in
            DispatchQueue.main.async {
                self.alpha = 1
                self.transform = .identity
                self.label.textColor = .darkGrayColor
                self.label.text = "Voice ID"
                self.startDisplayLink()
                completion()
            }
        }
    }

    func voiceIdFailed() {
        label.text = "Authorization Error"
        label.textColor = .white
        backgroundColor = .red
        stopDisplayLink()
        UIView.animate(withDuration: 0.3, delay: 2, options: [], animations: {
            self.backgroundColor = .darkGrayColor
        }) { (_) in
            DispatchQueue.main.async {
                self.label.textColor = .darkGrayColor
                self.label.text = "Voice ID"
                self.startDisplayLink()
            }
        }
    }
}
