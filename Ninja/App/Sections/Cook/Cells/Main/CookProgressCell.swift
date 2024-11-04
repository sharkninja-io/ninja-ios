//
//  CookProgressCell.swift
//  Ninja
//
//  Created by Martin Burch on 2/24/23.
//

import UIKit

class CookProgressCell : CookControlsViewCell {
    
    enum CookInfo: String {
        case UntilComplete = "Until Complete"
        case CurrentTemp = "Current Temp"
        case Unplugged = "Unplugged"
        case NotSet = "Not Set"
        case CantRead = "Can't Read Temp"
        case Unset = "---"
        case None = " "
    }
    
    private var highlightTextColor: UIColor = .white
    private var skipPreheatColor: UIColor = .white
    private var units: String = ""
    var currentProbeIndex: Int = 0
    
    override func connectData(data: CookItem) {
        super.connectData(data: data)
        
        if let data = data as? CookCellItem<GrillState> {
            data.unitsSubject.receive(on: DispatchQueue.main).sink { [weak self] units in
                self?.units = units ?? ""
            }.store(in: &disposables)
            data.currentValueSubject.receive(on: DispatchQueue.main).sink { [weak self] grillState in
                guard let self = self else { return }
                if let grillState = grillState {
                    switch grillState.cookType {
                    case .ProbeSingle, .ProbeDouble:
                        self.setProbeProgressDial(state: grillState)
                    default: // Timed, NotSet, Unknown
                        self.setCookProgressDial(state: grillState)
                    }
                    self.skipPreheatButton.isHidden = !CookDisplayValues.isSkipState(state: grillState.state)
                    self.setSkipTitle(state: grillState.state)
                }
            }.store(in: &disposables)
            
            skipPreheatButton.removeEvent()
            skipPreheatButton.onEvent { control in
                data.onClick?(control, nil)
            }
        }
    }
    
    func setProbeProgressDial(state: GrillState) {
        let probes = MonitorControlViewModel.shared.availableThermometersSubject.value // TODO: - HACKY!!!
        if let selectedProbe = probes.first(where: { $0.isSelected })?.grillThermometer {
                self.progressDial.hideTrack = false
                self.progressDial.showHole = false
                self.setStateColors(state: selectedProbe.state)
            switch selectedProbe.state {
            case .AddFood:
                self.cookStateLabel.text = ""
                self.progressLabel.text = CookDisplayValues.getCalculatedStateDisplayName(state: selectedProbe.state)
                self.setCookInfo(info: .None)
                self.progressDial.showHole = true
            case .Cooking:
                if isConnected(state: state) {
                    self.cookStateLabel.text = CookDisplayValues.getCalculatedStateDisplayName(state: .Cooking).uppercased()
                    self.progressLabel.text = CookDisplayValues.getTemperatureDisplayString(temp: Int(selectedProbe.currentTemp), units: self.units, isThermometer: true)
                    self.setCookInfo(info: .CurrentTemp)
                    self.progressDial.current = CGFloat(selectedProbe.cookProgress)
                } else {
                    self.cookStateLabel.text = "OFFLINE".uppercased()
                    self.progressLabel.text = "--"
                    self.setCookInfo(info: .CantRead)
                    self.progressDial.hideTrack = true
                }
            case .FlipFood:
                self.cookStateLabel.text = ""
                self.progressLabel.text = CookDisplayValues.getCalculatedStateDisplayName(state: selectedProbe.state)
                self.setCookInfo(info: .None)
                self.progressDial.current = CGFloat(selectedProbe.cookProgress)
            case .Resting, .GetFood:
                self.setStateColors(state: .Resting)
                self.cookStateLabel.text = CookDisplayValues.getCalculatedStateDisplayName(state: .Resting).uppercased()
                self.setCookInfo(info: isConnected(state: state) ? .None : .CantRead)
                if selectedProbe.pluggedIn, selectedProbe.active, isConnected(state: state) {
                    self.progressLabel.text = CookDisplayValues.getTemperatureDisplayString(temp: Int(selectedProbe.currentTemp), units: self.units, isThermometer: true)
                    self.progressDial.current = CGFloat(selectedProbe.restingProgress)
                } else {
                    self.progressLabel.text = CookDisplayValues.getTimeDisplayString(seconds: Int(selectedProbe.restingTimeCompleted), units: .Minutes)
                    self.progressDial.current = CGFloat(selectedProbe.restingProgress)
                }
            case .Done:
                self.cookStateLabel.text = CookDisplayValues.getCalculatedStateDisplayName(state: .Done).uppercased()
                self.progressLabel.text = "DONE".uppercased()
                self.progressDial.current = 100
                self.setCookInfo(info: .None)
            case .ProbeNotSet:
                if !selectedProbe.active && CookDisplayValues.isNotSetState(state: state.state) {
                    self.setStateColors(state: .Cooking)
                    self.cookStateLabel.text = " "
                    self.progressLabel.text = selectedProbe.currentTemp == 0 ? "--" : CookDisplayValues.getTemperatureDisplayString(temp: Int(selectedProbe.currentTemp), units: self.units, isThermometer: true)
                    self.progressDial.hideTrack = true
                    self.setCookInfo(info: .NotSet)
                } else {
                    setCookProgressDial(state: state)
                }
            case .PlugInProbe1, .PlugInProbe2:
                self.cookStateLabel.text = CookDisplayValues.getCalculatedStateDisplayName(state: selectedProbe.state).uppercased()
                self.progressLabel.text = "--"
                self.progressDial.hideTrack = true
                self.setCookInfo(info: .Unplugged)
            default:
                setCookProgressDial(state: state)
            }
        } else {
            setCookProgressDial(state: state)
        }
    }
    
    func setCookProgressDial(state: GrillState) {
        self.progressDial.hideTrack = false
        self.progressDial.showHole = false
        setStateColors(state: state.state)
        switch state.state {
        case .Igniting:
            self.cookStateLabel.text = CookDisplayValues.getCalculatedStateDisplayName(state: .Igniting).uppercased()
            self.progressLabel.text = "\(state.ignitionProgress)%"
            self.progressDial.current = CGFloat(state.ignitionProgress)
            self.setCookInfo(info: .None)
        case .Preheating:
            self.cookStateLabel.text = CookDisplayValues.getCalculatedStateDisplayName(state: .Preheating).uppercased()
            self.progressLabel.text = "\(state.preheatProgress)%"
            self.progressDial.current = CGFloat(state.preheatProgress)
            self.setCookInfo(info: .None)
        case .AddFood:
            self.cookStateLabel.text = ""
            self.progressLabel.text = CookDisplayValues.getCalculatedStateDisplayName(state: state.state)
            self.progressDial.showHole = true
            self.setCookInfo(info: .None)
        case .Cooking:
            self.cookStateLabel.text = CookDisplayValues.getCalculatedStateDisplayName(state: .Cooking).uppercased()
            self.progressLabel.text = CookDisplayValues.getTimeDisplayString(
                seconds: Int(state.oven.timeLeft),
                units: state.oven.timeLeft < 3600 ? .Minutes : .Hours)
            self.setCookInfo(info: .UntilComplete)
            self.progressDial.current = CGFloat(state.cookProgress)
        case .FlipFood:
            self.cookStateLabel.text = ""
            self.progressLabel.text = CookDisplayValues.getCalculatedStateDisplayName(state: state.state)
            self.setCookInfo(info: .None)
            self.progressDial.current = CGFloat(state.cookProgress)
        case .Resting:
            self.cookStateLabel.text = CookDisplayValues.getCalculatedStateDisplayName(state: .Resting).uppercased()
            self.progressLabel.text = CookDisplayValues.getTimeDisplayString(seconds: Int(state.restingTimeCompleted), units: .Minutes)
            self.progressDial.current = CGFloat(state.restingProgress)
            self.setCookInfo(info: .None)
        case .Done, .GetFood:
            self.cookStateLabel.text = CookDisplayValues.getCalculatedStateDisplayName(state: .Done).uppercased()
            self.progressLabel.text = "Done".uppercased()
            self.progressDial.current = 100
            self.setCookInfo(info: .None)
        case .PlugInProbe1, .PlugInProbe2:
            self.cookStateLabel.text = CookDisplayValues.getCalculatedStateDisplayName(state: state.state).uppercased()
            self.progressLabel.text = "--"
            self.progressDial.current = 0
            self.setCookInfo(info: .Unplugged)
            self.progressDial.hideTrack = true
        case .LidOpenBeforeCook, .LidOpenDuringCook:
            self.cookStateLabel.text = ""
            self.progressLabel.text = CookDisplayValues.getCalculatedStateDisplayName(state: state.state)
            self.progressDial.showHole = true
            self.setCookInfo(info: .None)
        default:
            self.cookStateLabel.text = CookDisplayValues.getCalculatedStateDisplayName(state: state.state).uppercased()
            self.progressLabel.text = "--"
            self.progressDial.current = 0
            self.setCookInfo(info: .None)
        }
    }
    
    func setStateColors(state: CalculatedState) {
        let labelColors = MonitorControlColors.getColorSet(state: state).labelColors
        if !self.cookStateLabel.bounds.isEmpty {
            self.highlightTextColor = UIColor.getGradientAsColor(rect: self.cookStateLabel.bounds, colors: labelColors) ?? .white
        }
        self.skipPreheatColor = UIColor.getGradientAsColor(rect: self.skipPreheatButton.bounds, colors: labelColors) ?? .white
        self.setProgressTrackColor(color: MonitorControlColors.getColorSet(state: state).background)
        switch state {
        case .AddFood, .LidOpenBeforeCook, .LidOpenDuringCook:
            self.setProgessGradientLayer(layer: MonitorControlColors.getGradient(state: state, type: .axial, start: CGPoint(x: 0, y: 0.5), end: CGPoint(x: 1, y: 0.5)))
        default:
            self.setProgessGradientLayer(layer: MonitorControlColors.getGradient(state: state, type: .conic, start: CGPoint(x: 0.5, y: 0.5), end: CGPoint(x: 0.5, y: 0)))
        }
        self.cookStateLabel.setStyle(.cookProgressStateLabel(textColor: highlightTextColor))
    }
    
    func setCookInfo(info: CookInfo) {
        infoLabel.text = info.rawValue
        labelStack.setNeedsLayout()
    }
    
    func setProgessGradientLayer(layer: CAGradientLayer) {
        progressDial.valueTrackGradientLayer = layer
    }
    
    func setProgressTrackColor(color: UIColor) {
        progressDial.trackColor = color
    }
    
    func setSkipTitle(state: CalculatedState) {
        switch state {
        case .Preheating:
            self.skipPreheatButton.setTitle("SKIP PREHEAT".uppercased(), for: .normal)
        case .Igniting:
            self.skipPreheatButton.setTitle("SKIP IGNITION".uppercased(), for: .normal)
        default:
            self.skipPreheatButton.isHidden = true
        }
    }
    
    private func isConnected(state: GrillState) -> Bool {
        return SelectApplianceViewModel.shared.isDeviceConnected(state: state)
    }
    
    @UsesAutoLayout var progressDial: ProgressDial = {
        let dial = ProgressDial()
        dial.minimum = 0
        dial.maximum = 100
        dial.current = 0
        dial.originRotationAngle = -90
        dial.startValueAngle = 10
        dial.endValueAngle = 350
        dial.trackColor = MonitorControlColors.resting.background
        dial.valueTrackGradientLayer = MonitorControlColors.getGradient(state: .Cooking)
        dial.trackWidth = 23
        return dial
    }()
    
    @UsesAutoLayout var labelStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fillProportionally
        stack.spacing = 4
        return stack
    }()
    
    @UsesAutoLayout var progressLabel: UILabel = {
        let label = UILabel()
        label.text = "---" // TODO: TESTING
        return label
    }()
    
    @UsesAutoLayout var infoLabel: UILabel = {
        let label = UILabel()
        label.text = "---"
        return label
    }()
    
    @UsesAutoLayout var cookStateLabel: UILabel = {
        let label = UILabel()
        label.text = "CALCULATING".uppercased() // __________
        return label
    }()
    
    @UsesAutoLayout var progressContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    @UsesAutoLayout var skipPreheatButton: UIButton = {
        let button = UIButton()
        button.setTitle("SKIP PREHEAT".uppercased(), for: .normal)
        return button
    }()
    
    @UsesAutoLayout var containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fillProportionally
        stack.spacing = 24
        return stack
    }()
    
    override func setupViews() {
        super.setupViews()
        
        self.hideShadow()
        self.shadowContainer.backgroundColor = .clear
        self.backgroundColor = .clear
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        labelStack.addArrangedSubview(progressLabel)
        labelStack.addArrangedSubview(infoLabel)
        labelStack.addArrangedSubview(cookStateLabel)
        
        progressContainer.addSubview(progressDial)
        progressContainer.addSubview(labelStack)
        
        containerStackView.addArrangedSubview(progressContainer)
        containerStackView.addArrangedSubview(skipPreheatButton)
        
        shadowContainer.addSubview(containerStackView)
        
        print(shadowContainer.frame)
        
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: shadowContainer.topAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: shadowContainer.bottomAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: shadowContainer.leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: shadowContainer.trailingAnchor),

            progressContainer.widthAnchor.constraint(equalTo: shadowContainer.widthAnchor, multiplier: 0.6),
            progressContainer.heightAnchor.constraint(equalTo: shadowContainer.widthAnchor, multiplier: 0.6),

            progressDial.topAnchor.constraint(equalTo: progressContainer.topAnchor),
            progressDial.bottomAnchor.constraint(equalTo: progressContainer.bottomAnchor),
            progressDial.leadingAnchor.constraint(equalTo: progressContainer.leadingAnchor),
            progressDial.trailingAnchor.constraint(equalTo: progressContainer.trailingAnchor),
            
            labelStack.centerYAnchor.constraint(equalTo: progressDial.centerYAnchor),
            labelStack.centerXAnchor.constraint(equalTo: progressDial.centerXAnchor),

            skipPreheatButton.widthAnchor.constraint(equalTo: progressContainer.widthAnchor),
            skipPreheatButton.heightAnchor.constraint(equalToConstant: 48),

        ])
    }
    
    override func refreshStyling() {
        progressLabel.setStyle(.cookProgressValueLabel)
        infoLabel.setStyle(.cookProgressInfoLabel)
        cookStateLabel.setStyle(.cookProgressStateLabel(textColor: highlightTextColor))
        skipPreheatButton.setStyle(.transparentButton(foregroundColor: skipPreheatColor))
    }
}
