//
//  DialView.swift
//  Ninja
//
//  Created by Martin Burch on 8/18/22.
//

import UIKit

protocol DialViewDelegate: AnyObject {
    func currentValueUpdated(object: DialView, value: CGFloat)
}

@IBDesignable
class DialView: UIControl {
    
    weak var delegate: DialViewDelegate?
    private var tapGesture: UITapGestureRecognizer!
    private var panGesture: UIPanGestureRecognizer!

    // MARK: - VALUE VARIABLES
    @IBInspectable
    var minimum: CGFloat = 100 {
        didSet {
            if minimum > maximum { maximum = minimum }
            if minimum > current { current = minimum }

            redrawDialValues()
        }
    }
    @IBInspectable
    var maximum: CGFloat = 450 {
        didSet {
            if maximum < minimum { minimum = maximum }
            if maximum < current { current = maximum }

            redrawDialValues()
        }
    }
    @IBInspectable
    var step: CGFloat = 10 {
        didSet {
            if current != snapValue(current) { current = snapValue(current) }
        }
    }
    @IBInspectable
    var current: CGFloat = 120 {
        didSet {
            current = snapValue(current)

            redrawDialValues()

            // notify change
            delegate?.currentValueUpdated(object: self, value: current)
            sendActions(for: .valueChanged)
            sendActions(for: .primaryActionTriggered)
        }
    }
    @IBInspectable
    var goal: CGFloat = 150 {
        didSet {
            goal = min(max(goal, minimum), maximum)
            
            redrawDialValues()
        }
    }
    @IBInspectable
    var setValueToGoal: Bool = true {
        didSet {
            redrawDialValues()
        }
    }
    @IBInspectable
    var valueFormat: String = "%.0f" {
        didSet {
            updateLabels()
        }
    }

    // MARK: - DISPLAY VARIABLES
    /// A value in degrees between 0 and 360
    @IBInspectable
    var startValueAngle: CGFloat = 45 {
        didSet {
            redrawDialValues()
        }
    }
    /// A value in degrees between 0 and 360
    @IBInspectable
    var endValueAngle: CGFloat = 315 {
        didSet {
            redrawDialValues()
        }
    }
    /// Rotate the origin about the center.  0 degrees East, 90 degrees South, 180 degrees West and  270 degrees North
    @IBInspectable
    var originRotationAngle: CGFloat = 90 {
        didSet {
            rotationAngleRadians = (720 + originRotationAngle).toRadians()

            redrawDialValues()
        }
    }
    /// Display value points around the track
    @IBInspectable
    var showDialPoints: Bool = true {
        didSet {
            layoutIfNeeded()
        }
    }
    /// Interval of value marks along the tracks
    @IBInspectable
    var dialPointInterval: CGFloat = 50 {
        didSet {
            layoutIfNeeded()
        }
    }
    @IBInspectable
    var lineWidth: CGFloat = 15 {
        didSet {
            layoutIfNeeded()
        }
    }
    @IBInspectable
    var valuePointWidth: CGFloat = 8 {
        didSet {
            setValuePoint(frame: bounds)
        }
    }
    @IBInspectable
    var trackColor: UIColor = UIColor.red {
        didSet {
            if isEnabled { trackLayer.strokeColor = trackColor.cgColor }
        }
    }
    @IBInspectable
    var valueTrackColor: UIColor = UIColor.gray {
        didSet {
            if isEnabled { valueArcLayer.strokeColor = valueTrackColor.cgColor }
        }
    }
    @IBInspectable
    var valuePointFillColor: UIColor = UIColor.white {
        didSet {
            if isEnabled { valuePointLayer.fillColor = valuePointFillColor.cgColor }
        }
    }
    @IBInspectable
    var valuePointStrokeColor: UIColor = UIColor.black {
        didSet {
            if isEnabled { valuePointLayer.strokeColor = valuePointStrokeColor.cgColor }
        }
    }
    @IBInspectable
    var disabledPrimaryColor: UIColor = UIColor.lightGray {
        didSet {
            if !isEnabled { layoutIfNeeded() }
        }
    }
    @IBInspectable
    var disabledSecondaryColor: UIColor = UIColor.gray {
        didSet {
            if !isEnabled { layoutIfNeeded() }
        }
    }
    @IBInspectable
    var disabledTertiaryColor: UIColor = UIColor.darkGray {
        didSet {
            if !isEnabled { layoutIfNeeded() }
        }
    }
    @IBInspectable
    var clockwiseTrack: Bool = true {
        didSet {
            setValueArc(frame: bounds)
        }
    }
    @IBInspectable
    private var clockwiseValues: Bool = true {
        didSet { layoutSubviews() }
    }
    
    override var isEnabled: Bool {
        didSet {
            layoutSubviews()
        }
    }
    var enableTouch: Bool = true {
        didSet {
            setupTouch()
        }
    }
    var enableHaptic: Bool = true
    
    // MARK: - DRAWING VARIABLES
    private var currentValueAngle: CGFloat = 45
    private var goalAngle: CGFloat = 90
    private var rotationAngleRadians: CGFloat = 0
    private var radius: CGFloat = 0
    
    private var trackLayer = CAShapeLayer()
    private var valueArcLayer = CAShapeLayer()
    private var valuePointLayer = CAShapeLayer()
    private var pointLayers: [CAShapeLayer] = []
    
    var valueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = FontFamilyLibrary.gotham_black.asFont(size: 14)
        return label
    }()
    
    // MARK: - LOADING FUNCTIONS
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDial()
        setupTouch()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupDial()
        setupTouch()
     }
    
    override func layoutSubviews() {
        drawDial()
    }
    
    private func setupDial() {
        backgroundColor = .clear
        rotationAngleRadians = (720 + originRotationAngle).toRadians()
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dialGesture))
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.dialGesture))
    }
    
    private func setupTouch() {
        if enableTouch {
            self.addGestureRecognizer(tapGesture)
            self.addGestureRecognizer(panGesture)
        } else {
            self.removeGestureRecognizer(tapGesture)
            self.removeGestureRecognizer(panGesture)
        }
    }
    
    @objc func dialGesture(sender: UITapGestureRecognizer) {
        if isEnabled {
            let translation = sender.location(in: self)
            guard sender.view != nil else { return }
            
            setValueForPoint(point: translation)
        }
    }
    
    // MARK: - HELPER FUNCTIONS
    private func snapValue(_ value: CGFloat) -> CGFloat {
        if value < minimum {
            return minimum
        } else if value > maximum {
            return maximum
        } else {
            let remainder = value.truncatingRemainder(dividingBy: step)
            return (remainder >= step / 2) ? value - remainder + step : value - remainder
        }
    }
    
    private func hapticBurst() {
        HapticService.shared()?
            .playPattern(HapticService.shared()?
                .simpleBurst(intensity: 0.4, sharpness: 0.3))
    }
    
    // MARK: - DRAWING FUNCTIONS
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    private func setValueForPoint(point: CGPoint) {
        // calculate new current value
        let angle = (atan2(Float(bounds.midY - point.y), Float(bounds.midX - point.x))
                     + Float(rotationAngleRadians)) // 0 - 2 * pi  rotated 90 degrees
            .truncatingRemainder(dividingBy: Float(Double.pi * 2))
        let percent = (CGFloat(angle).toDegrees() - startValueAngle) / (endValueAngle - startValueAngle)
        let newValue = (clockwiseValues ? percent : 1 - percent) * (maximum - minimum) + minimum
        // haptic
        if enableHaptic && snapValue(newValue) != current {
            hapticBurst()
        }
        // update current value
        current = newValue
    }
    
    private func getAngleForValue(value: CGFloat) -> CGFloat {
        return startValueAngle + (endValueAngle - startValueAngle) / (maximum - minimum) * (clockwiseValues ? (value - minimum) : (maximum - value))
    }
    
    private func getPointForAngle(angle: CGFloat) -> CGPoint {
        return CGPoint(x: cos(angle.toRadians()) * radius, y: sin(angle.toRadians()) * radius)
    }
    
    //      270
    //    /      \
    // 180        0 / 360
    //    \      /
    //       90
    private func drawDial() {
        recalculateValueAngles()
        radius = min(bounds.width, bounds.height) / 2 - lineWidth
        addTrackLayer(frame: bounds)
        addLabels(frame: bounds)
        addValueArcLayer(frame: bounds)
        addStepPointLayers(frame: bounds)
        addValuePointLayer(frame: bounds)
    }
    
    private func redrawDialValues() {
        recalculateValueAngles()
        // setTrackLayer(frame: bounds)
        updateLabels()
        setValueArc(frame: bounds)
        setStepPoints(frame: bounds)
        setValuePoint(frame: bounds)
    }
    
    private func recalculateValueAngles() {
        currentValueAngle = getAngleForValue(value: current)
        if setValueToGoal {
            goalAngle = currentValueAngle
        } else {
            goalAngle = getAngleForValue(value: goal)
        }
    }
    
    private func addTrackLayer(frame: CGRect) {
        trackLayer.removeFromSuperlayer()
        setTrackLayer(frame: frame)
        trackLayer.lineWidth = lineWidth
        trackLayer.lineCap = .round
        trackLayer.strokeColor = isEnabled ? trackColor.cgColor : disabledSecondaryColor.cgColor
        trackLayer.fillColor = UIColor.clear.cgColor
        layer.addSublayer(trackLayer)
    }
    
    private func setTrackLayer(frame: CGRect) {
        let baseCircle = UIBezierPath(ovalIn:
                                    CGRect(x: frame.width / 2 - radius, y: frame.height / 2 - radius, width: radius * 2, height: radius * 2))
        trackLayer.path = baseCircle.cgPath
    }
    
    private func addValueArcLayer(frame: CGRect) {
        valueArcLayer.removeFromSuperlayer()
        setValueArc(frame: frame)
        valueArcLayer.lineWidth = lineWidth + 2
        valueArcLayer.lineCap = .round
        valueArcLayer.strokeColor = isEnabled ? valueTrackColor.cgColor : disabledPrimaryColor.cgColor
        valueArcLayer.fillColor = UIColor.clear.cgColor
        layer.addSublayer(valueArcLayer)
    }
    
    private func setValueArc(frame: CGRect) {
        let valueArc = UIBezierPath(arcCenter: CGPoint(x: frame.width / 2, y: frame.height / 2),
                                    radius: radius,
                                    startAngle: CGFloat(startValueAngle + originRotationAngle).toRadians(),
                                    endAngle: CGFloat(currentValueAngle + originRotationAngle + 0.01).toRadians(),
                                    clockwise: clockwiseTrack)
        valueArcLayer.path = valueArc.cgPath
    }
    
    private func addStepPointLayers(frame: CGRect) {
        pointLayers.forEach { layer in
            layer.removeFromSuperlayer()
        }
        pointLayers.removeAll()
        // Draw step value marks - set intervals
        if showDialPoints {
            for stepValue in stride(from: minimum, through: maximum, by: dialPointInterval) {
                let newLayer = CAShapeLayer()
                pointLayers.append(newLayer)
                setStepPoint(frame: frame, layer: newLayer, stepValue: stepValue)
                newLayer.lineWidth = lineWidth / 4
                newLayer.lineCap = .round
                layer.addSublayer(newLayer)
            }
        }
    }
    
    private func setStepPoints(frame: CGRect) {
        var index: CGFloat = 0
        for pointLayer in pointLayers {
            setStepPoint(frame: frame, layer: pointLayer, stepValue: minimum + dialPointInterval * index)
            index += 1
        }
    }
    
    private func setStepPoint(frame: CGRect, layer: CAShapeLayer, stepValue: CGFloat) {
        let angle = getAngleForValue(value: stepValue)
        let stepPoint = UIBezierPath(arcCenter: CGPoint(x: frame.width / 2, y: frame.height / 2),
                                     radius: radius,
                                     startAngle: CGFloat(angle + originRotationAngle).toRadians(),
                                     endAngle: CGFloat(angle + originRotationAngle + 0.01).toRadians(),
                                     clockwise: true)
        layer.path = stepPoint.cgPath
        layer.strokeColor = angle < currentValueAngle ? UIColor.black.cgColor : UIColor.white.cgColor
    }
    
    private func addValuePointLayer(frame: CGRect) {
        valuePointLayer.removeFromSuperlayer()
        setValuePoint(frame: frame)
        valuePointLayer.lineWidth = 2
        valuePointLayer.lineCap = .round
        valuePointLayer.strokeColor = isEnabled ? valuePointStrokeColor.cgColor : disabledPrimaryColor.cgColor
        valuePointLayer.fillColor = isEnabled ? valuePointFillColor.cgColor : disabledTertiaryColor.cgColor
        layer.addSublayer(valuePointLayer)
    }
    
    private func setValuePoint(frame: CGRect) {
        let centerPoint = getPointForAngle(angle: goalAngle + originRotationAngle)
        let valuePoint = UIBezierPath(arcCenter: CGPoint(x: frame.width / 2 + centerPoint.x, y: frame.height / 2 + centerPoint.y),
                                     radius: valuePointWidth,
                                     startAngle: 0,
                                     endAngle: CGFloat(Double.pi * 2),
                                     clockwise: true)
        valuePointLayer.path = valuePoint.cgPath
    }
    
    private func addLabels(frame: CGRect) {
        updateLabels()
        
        self.addSubview(valueLabel)
        NSLayoutConstraint.activate([
            valueLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0),
            valueLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0)
        ])
    }
    
    private func updateLabels() {
        valueLabel.text = String(format: valueFormat, Double(current))
    }
}
