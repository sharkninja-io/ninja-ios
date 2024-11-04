//
//  ProgressDial.swift
//  Ninja
//
//  Created by Martin Burch on 2/23/23.
//

import UIKit

@IBDesignable
class ProgressDial: UIView {
    
    // MARK: - VALUE VARIABLES
    @IBInspectable
    var minimum: CGFloat = 0 {
        didSet {
            if minimum > maximum { maximum = minimum }
            if minimum > current { current = minimum }

            redrawDialValues()
        }
    }
    @IBInspectable
    var maximum: CGFloat = 100 {
        didSet {
            if maximum < minimum { minimum = maximum }
            if maximum < current { current = maximum }

            redrawDialValues()
        }
    }
    @IBInspectable
    var current: CGFloat = 99 {
        didSet {
            current = snapValue(current)
            
            animateCurrentValue(oldValue: oldValue, newValue: current, duration: animationDuration)
            redrawDialValues()
        }
    }
    @IBInspectable
    var animationDuration: CGFloat = 3
    
    private func animateCurrentValue(oldValue: CGFloat, newValue: CGFloat, duration: CGFloat = 1) {
        let animation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.strokeEnd))
        animation.fromValue = oldValue
        animation.toValue = newValue
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.isRemovedOnCompletion = true

        CATransaction.begin()
        self.valueTrackGradientLayer.add(animation, forKey: #keyPath(CAShapeLayer.strokeEnd))
        CATransaction.commit()
    }
    
    // MARK: - DISPLAY VARIABLES
    /// A value in degrees between 0 and 360
    @IBInspectable
    var startValueAngle: CGFloat = 7 {
        didSet {
            redrawDialValues()
        }
    }
    /// A value in degrees between 0 and 360
    @IBInspectable
    var endValueAngle: CGFloat = 353 {
        didSet {
            redrawDialValues()
        }
    }
    /// Rotate the origin about the center.  0 degrees East, 90 degrees South, 180 degrees West and  270 degrees North
    @IBInspectable
    var originRotationAngle: CGFloat = -90 {
        didSet {
            rotationAngleRadians = (720 + originRotationAngle).toRadians()

            redrawDialValues()
        }
    }

    @IBInspectable
    var trackWidth: CGFloat = 20 {
        didSet {
            layoutSubviews()
        }
    }
    @IBInspectable
    var trackColor: UIColor = UIColor.red {
        didSet {
            trackLayer.strokeColor = trackColor.cgColor
        }
    }
    
    static let defaultGradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [UIColor.green.cgColor, UIColor.blue.cgColor]
        layer.startPoint = CGPoint(x: 0.5, y: 0.5)
        layer.endPoint = CGPoint(x: 0.5, y: 0)
        layer.type = .conic
        return layer
    }()
    
    @IBInspectable
    var valueTrackGradientLayer: CAGradientLayer = defaultGradientLayer {
        willSet {
            valueTrackGradientLayer.removeFromSuperlayer()
        }
        didSet {
            drawDial()
        }
    }
    @IBInspectable
    var clockwiseTrack: Bool = true {
        didSet {
            drawDial()
        }
    }
    
    @IBInspectable
    var hideTrack: Bool = false {
        didSet {
            redrawDialValues()
        }
    }
    
    @IBInspectable
    var showHole: Bool = false {
        didSet {
            redrawDialValues()
        }
    }
    
    var enableHaptic: Bool = true
    
    // MARK: - DRAWING VARIABLES
    private var rotationAngleRadians: CGFloat = 0
    private var radius: CGFloat = 0
    
    private var trackLayer = CAShapeLayer()
    private var valueArcMaskLayer = CAShapeLayer()
    
    // MARK: - LOADING FUNCTIONS
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDial()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupDial()
     }
    
    override func layoutSubviews() {
        drawDial()
    }
    
    private func setupDial() {
        backgroundColor = .clear
        rotationAngleRadians = (720 + originRotationAngle).toRadians()
    }
    
    // MARK: - HELPER FUNCTIONS
    private func snapValue(_ value: CGFloat) -> CGFloat {
        if value < minimum {
            return minimum
        } else if value > maximum {
            return maximum
        } else {
            let remainder = value.truncatingRemainder(dividingBy: 1)
            return (remainder >= 0.5) ? value - remainder + 1 : value - remainder
        }
    }
    
    private func hapticBurst() {
        HapticService.shared()?
            .playPattern(HapticService.shared()?
                .simpleBurst(intensity: 0.4, sharpness: 0.3))
    }
    
    // MARK: - DRAWING FUNCTIONS
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 200, height: 200)
    }
    
    private func getValueStrokePercentage(value: CGFloat) -> CGFloat {
        if hideTrack { return 0 }
        // Display dot when empty
        if maximum == minimum || value == minimum { return 0.001 }
        return (value - minimum) / (maximum - minimum)
    }
    
    private func getAngleForValue(value: CGFloat) -> CGFloat {
        return startValueAngle + (endValueAngle - startValueAngle) / (maximum - minimum) * (value - minimum)
    }
    
    //      270
    //    /      \
    // 180        0 / 360
    //    \      /
    //       90
    private func drawDial() {
        radius = (min(bounds.width, bounds.height) - trackWidth) / 2
        if showHole {
            addFillCircle(frame: bounds)
        } else {
            addTrackLayer(frame: bounds)
            addValueArcLayer(frame: bounds)
        }
    }
    
    private func redrawDialValues() {
        showHole ? addFillCircle(frame: bounds) : addValueArcLayer(frame: bounds)
    }
    
    private func addTrackLayer(frame: CGRect) {
        trackLayer.removeFromSuperlayer()
        let baseCircle = UIBezierPath(
            ovalIn: CGRect(x: frame.width / 2 - radius, y: frame.height / 2 - radius, width: radius * 2, height: radius * 2))
        trackLayer.path = baseCircle.cgPath
        trackLayer.lineWidth = trackWidth
        trackLayer.lineCap = .round
        trackLayer.strokeColor = trackColor.cgColor
        trackLayer.fillColor = UIColor.clear.cgColor
        layer.addSublayer(trackLayer)
    }
    
    private func addValueArcLayer(frame: CGRect) {
        valueTrackGradientLayer.removeFromSuperlayer()
        let endValueAngle = getAngleForValue(value: maximum)
        let valuePath = UIBezierPath(arcCenter: CGPoint(x: frame.width / 2, y: frame.height / 2),
                            radius: radius,
                            startAngle: CGFloat(startValueAngle + originRotationAngle).toRadians(),
                            endAngle: CGFloat(endValueAngle + originRotationAngle).toRadians(),
                            clockwise: clockwiseTrack)
        valueArcMaskLayer.path = valuePath.cgPath
        valueArcMaskLayer.lineWidth = trackWidth
        valueArcMaskLayer.lineCap = .round
        valueArcMaskLayer.strokeColor = UIColor.blue.cgColor
        valueArcMaskLayer.fillColor = UIColor.clear.cgColor
        valueArcMaskLayer.strokeEnd = getValueStrokePercentage(value: current)
        valueTrackGradientLayer.frame = frame
        valueTrackGradientLayer.mask = valueArcMaskLayer
        layer.addSublayer(valueTrackGradientLayer)
    }
    
    private func addFillCircle(frame: CGRect) {
        valueTrackGradientLayer.removeFromSuperlayer()
        valueArcMaskLayer.path = UIBezierPath(
            roundedRect: CGRect(
                origin: CGPoint(x: (frame.width - trackWidth) / 2 - radius, y: (frame.height - trackWidth) / 2 - radius),
                size: CGSize(width: 2.0 * radius + trackWidth, height: 2.0 * radius + trackWidth)), cornerRadius: radius).cgPath
        valueArcMaskLayer.fillColor = UIColor.blue.cgColor
        valueArcMaskLayer.lineWidth = 0
        valueArcMaskLayer.strokeEnd = 1.0
        valueTrackGradientLayer.frame = frame
        valueTrackGradientLayer.mask = valueArcMaskLayer
        layer.addSublayer(valueTrackGradientLayer)
    }
}
