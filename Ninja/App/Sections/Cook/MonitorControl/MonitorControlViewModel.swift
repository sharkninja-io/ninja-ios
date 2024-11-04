//
//  MonitorControlViewModel.swift
//  Ninja
//
//  Created by Martin Burch on 2/17/23.
//

import UIKit
import Combine
import GrillCore

typealias GrillTimer = GrillCoreSDK.GrillTimer
typealias CalculatedState = GrillCoreSDK.CalculatedState
typealias GrillThermometer = GrillCoreSDK.GrillThermometer
typealias Doneness = GrillCoreSDK.Doneness

class ExtendedGrillThermometer: Equatable {
    static func == (lhs: ExtendedGrillThermometer, rhs: ExtendedGrillThermometer) -> Bool {
        return lhs.index == rhs.index
    }
    
    var grillThermometer: GrillThermometer?
    var index: Int = -1
    var isSelected: Bool = false
    
    init(grillThermometer: GrillThermometer? = nil, index: Int, isSelected: Bool = false) {
        self.grillThermometer = grillThermometer
        self.index = index
        self.isSelected = isSelected
    }
    
    func setThermometer(thermometer: GrillThermometer) -> ExtendedGrillThermometer {
        self.grillThermometer = thermometer
        return self
    }
}

enum GrillCoreError: Error {
    case updateFailed(message: String)
}

enum MonitorControlModalType {
    case ProbeNotPluggedIn(Int)
    case ThermometerCookNotAvailable(CookMode)
    case ChangeToThermometerCook
    case ChangeToTimedCook
}

class MonitorControlViewModel {
    
    lazy var deviceControlService: DeviceControlService = .shared

    var disposables: Set<AnyCancellable> = []
    
    var thermometerControlsSubject = CurrentValueSubject<[CookItem], Never>([])
    var grillControlsSubject = CurrentValueSubject<[CookItem], Never>([])
    
    var currentlyWorkingSubject = CurrentValueSubject<Bool, Never>(false)
    var modalSubject = PassthroughSubject<MonitorControlModalType, Never>()

    // Grill
    var currentGrillStateSubject = CurrentValueSubject<GrillState?, Never>(nil)
    var currentCalculatedStateSubject = CurrentValueSubject<CalculatedState?, Never>(nil)
    var currentGrillStateExtraSubject = CurrentValueSubject<Any?, Never>(nil)
    var currentCookTypeSubject = CurrentValueSubject<CookType?, Never>(.Timed)
    var currentCookTypeExtraSubject = CurrentValueSubject<Any?, Never>(nil)
    
    var availableCookModesSubject = CurrentValueSubject<[CookMode], Never>([])
    var availableGrillTimesSubject = CurrentValueSubject<[UInt32], Never>([])
    var availableGrillTempsSubject = CurrentValueSubject<[UInt32], Never>([])
    var availableGrillTimesUnitSubject = CurrentValueSubject<String?, Never>(nil)
    var availableGrillTempsUnitSubject = CurrentValueSubject<String?, Never>(nil)

    // Progress
    var currentGrillProgressSubject = CurrentValueSubject<(UInt, CalculatedState)?, Never>(nil)

    // Settings
    var currentCookModeSubject = CurrentValueSubject<CookMode?, Never>(nil)
    var currentCookModeWorkingSubject = CurrentValueSubject<CookMode?, Never>(nil)
    var currentCookModeWorkingExtrasSubject = CurrentValueSubject<Any?, Never>(nil)
    var currentWoodfireSubject = CurrentValueSubject<Bool?, Never>(false)
    var woodfireEnabledSubject = CurrentValueSubject<Bool, Never>(false)
    var currentGrillTimeSubject = CurrentValueSubject<UInt32?, Never>(nil)
    var currentGrillTimeWorkingSubject = CurrentValueSubject<UInt32?, Never>(nil)
    var currentGrillTempSubject = CurrentValueSubject<UInt32?, Never>(nil)
    var currentGrillTempWorkingSubject = CurrentValueSubject<UInt32?, Never>(nil)
    var currentTemperatureUnitsSubject = CurrentValueSubject<String?, Never>(nil)
    
    // Thermometers
    var availableThermometersSubject = CurrentValueSubject<[ExtendedGrillThermometer], Never>([.init(index: 0, isSelected: true), .init(index: 1)])
    
    var availableGenericTempsSubject = CurrentValueSubject<[UInt32], Never>([])
    var availableThermometer0TempsSubject = CurrentValueSubject<[FoodPreset], Never>([])
    var availableThermometer1TempsSubject = CurrentValueSubject<[FoodPreset], Never>([])

    var selectedThermometer0FoodSubject = CurrentValueSubject<Food?, Never>(nil)
    var selectedThermometer0TempSubject = CurrentValueSubject<FoodPreset?, Never>(nil)
    var selectedThermometer0GenericTempSubject = CurrentValueSubject<UInt32?, Never>(nil)
    var selectedThermometer0WorkingFoodSubject = CurrentValueSubject<Food?, Never>(nil)
    var selectedThermometer0WorkingTempSubject = CurrentValueSubject<FoodPreset?, Never>(nil)
    var selectedThermometer0WorkingGenericTempSubject = CurrentValueSubject<UInt32?, Never>(nil)

    var selectedThermometer1FoodSubject = CurrentValueSubject<Food?, Never>(nil)
    var selectedThermometer1TempSubject = CurrentValueSubject<FoodPreset?, Never>(nil)
    var selectedThermometer1GenericTempSubject = CurrentValueSubject<UInt32?, Never>(nil)
    var selectedThermometer1WorkingFoodSubject = CurrentValueSubject<Food?, Never>(nil)
    var selectedThermometer1WorkingTempSubject = CurrentValueSubject<FoodPreset?, Never>(nil)
    var selectedThermometer1WorkingGenericTempSubject = CurrentValueSubject<UInt32?, Never>(nil)

    // VARIABLES
    var cells: [CookCells: CookItem] = [:]
    var selectors: [CookSelectors: CookItem] = [:]
    var progressCell: CookCellItem<GrillState>?
    var cookTypeCell: CookCellItem<CookType>?
    var startingProbe0Temp: UInt = 0
    var startingProbe1Temp: UInt = 0
    var startingGrillTemp: UInt = 0
    
    private static var _instance: MonitorControlViewModel = .init()
    static var shared: MonitorControlViewModel {
        get { _instance }
    }
    
    private init() {
        initCells()
        initSelectors()
        initSubjects()
    }
    
    func getTemperatureUnits(cookMode: CookMode) -> String {
        switch cookMode {
        case .Grill:
            return "TempMode"
        default:
            return "°F"
        }
    }
    
    func isThermometerPluggedIn() -> Bool {
        return availableThermometersSubject.value.first { $0.grillThermometer?.pluggedIn ?? false } != nil
    }
    
    // MARK: - SUBSCRIPTIONS
    private func initSubjects() {
        disposables.removeAll()
        
        let manualTemps = Cook.getFoodPresets(food: .Manual).map { UInt32($0.temp) }
        availableGenericTempsSubject.send(manualTemps)
        availableCookModesSubject.send(Cook.getCookModesUS())
        currentTemperatureUnitsSubject.send(getTemperatureUnits(cookMode: .Unknown)) // TODO: -
        selectedThermometer0FoodSubject.send(.Manual)
        selectedThermometer1FoodSubject.send(.Manual)

        deviceControlService.currentStateSubject.receive(on: DispatchQueue.global(qos: .background)).sink { [weak self] state in
            guard let self = self else { return }
            guard !self.currentlyWorkingSubject.value else { return }
            if let state = state {
                self.currentCookTypeSubject.send(state.cookType)
                self.currentCookModeSubject.send(state.cookMode)
                self.currentWoodfireSubject.send(state.woodFire)
                self.woodfireEnabledSubject.send(CookDisplayValues.isWoodfireEnabled(cookMode: state.cookMode, state: state.state))

                let thermometers = self.availableThermometersSubject.value
                self.availableThermometersSubject.send([
                    thermometers[0].setThermometer(thermometer: state.probe1),
                    thermometers[1].setThermometer(thermometer: state.probe2)
                ])
                
                // Grill Settings
                self.currentTemperatureUnitsSubject.send(self.getTemperatureUnits(cookMode: state.cookMode))
                self.currentGrillTimeSubject.send(UInt32(state.oven.timeSet))
                self.currentGrillTempSubject.send(UInt32(state.oven.desiredTemp))

                // Thermometer Settings
                self.selectedThermometer0FoodSubject.send(state.probe1.food.protein)
                self.selectedThermometer1FoodSubject.send(state.probe2.food.protein)
                self.selectedThermometer0TempSubject.send(Cook.getFoodPresets(food: state.probe1.food.protein).first { $0.presetIndex == state.probe1.food.presetIndex })
                self.selectedThermometer1TempSubject.send(Cook.getFoodPresets(food: state.probe2.food.protein).first { $0.presetIndex == state.probe2.food.presetIndex })
                self.selectedThermometer0GenericTempSubject.send(UInt32(state.probe1.desiredTemp))
                self.selectedThermometer1GenericTempSubject.send(UInt32(state.probe2.desiredTemp))

                if state.cookType == .Timed {
                    if self.isThermometerPluggedIn() && self.thermometerControlsSubject.value.count == 0 {
                        self.thermometerControlsSubject.send([self.cells[.MiniThermometerContainer] ?? CookItem(cell: CookControlsViewCell.self)])
                    } else if !self.isThermometerPluggedIn() && self.thermometerControlsSubject.value.count > 0 {
                        self.thermometerControlsSubject.send([])
                    }
                }
                
                self.currentGrillProgressSubject.send(self.getProgressState(state: state))
                self.currentCalculatedStateSubject.send(state.state)
                self.currentGrillStateSubject.send(state)
                self.currentGrillStateExtraSubject.send(state)
            }
        }.store(in: &disposables)
        currentCalculatedStateSubject.removeDuplicates().receive(on: DispatchQueue.global(qos: .background)).sink { state in
            guard let state = state else { return }
            Logger.Debug("CALCULATED STATE: \(state)")
        }.store(in: &disposables)
        
        currentCookTypeSubject.removeDuplicates().receive(on: DispatchQueue.global(qos: .background)).sink { [weak self] cookType in
            guard let self = self else { return }
            
            self.currentCookTypeExtraSubject.send(cookType)
            switch cookType {
            case .ProbeDouble, .ProbeSingle:
                self.thermometerControlsSubject.send([
                    self.cells[.MiniThermometerContainer] ?? CookItem(cell: CookControlsViewCell.self),
                    self.cells[.ThermometerSummary] ?? CookItem(cell: CookControlsViewCell.self)
                ])
                self.grillControlsSubject.send([
                    self.cells[.Woodfire] ?? CookItem(cell: CookControlsViewCell.self),
                    self.cells[.GrillTemp] ?? CookItem(cell: CookControlsViewCell.self),
                    self.cells[.GrillMode] ?? CookItem(cell: CookControlsViewCell.self)
                ])
            default: // Timed, NotSet, Unknown
                self.thermometerControlsSubject.send([])
                self.grillControlsSubject.send([
                    self.cells[.Woodfire] ?? CookItem(cell: CookControlsViewCell.self),
                    self.cells[.GrillTimeTemp] ?? CookItem(cell: CookControlsViewCell.self),
                    self.cells[.GrillMode] ?? CookItem(cell: CookControlsViewCell.self)
                ])
            }
        }.store(in: &disposables)

        // GRILL
        currentCookModeSubject.removeDuplicates().receive(on: DispatchQueue.global(qos: .background)).sink { [weak self] cookMode in
            if let cookMode = cookMode {
                self?.currentCookModeWorkingSubject.send(cookMode)
            }
        }.store(in: &disposables)
        currentCookModeWorkingSubject.removeDuplicates().receive(on: DispatchQueue.global(qos: .background)).sink { [weak self] cookMode in
            guard let self = self else { return }
            self.currentCookModeWorkingExtrasSubject.send(cookMode)
            
            if let cookMode = cookMode {
                self.availableGrillTimesUnitSubject.send(Cook.getAvailableTimesUnit(cookMode: cookMode))
                self.availableGrillTempsUnitSubject.send(Cook.getAvailableTempsUnit(cookMode: cookMode))
                self.availableGrillTempsSubject.send(Cook.getAvailableTemps(cookMode: cookMode))
                self.availableGrillTimesSubject.send(Cook.getAvailableTimes(cookMode: cookMode))
                
                let duration = self.currentGrillTimeSubject.value ?? 0
                switch cookMode {
                case .Broil:
                    self.currentGrillTimeWorkingSubject.send(duration)
                default:
                    self.currentGrillTimeWorkingSubject.send(duration / 60)
                }
            }
        }.store(in: &disposables)
        currentGrillTempSubject.removeDuplicates().receive(on: DispatchQueue.global(qos: .background)).sink { [weak self] temperature in
            self?.currentGrillTempWorkingSubject.send(temperature)
        }.store(in: &disposables)
        currentGrillTimeSubject.removeDuplicates().receive(on: DispatchQueue.global(qos: .background)).sink { [weak self] time in
            guard let self = self else { return }

            let cookMode = self.currentCookModeSubject.value ?? .NotSet
            switch cookMode {
            case .Broil:
                self.currentGrillTimeWorkingSubject.send(time)
            default:
                self.currentGrillTimeWorkingSubject.send((time ?? 0) / 60)
            }
        }.store(in: &disposables)

        // THERMOMETERS
        selectedThermometer0FoodSubject.removeDuplicates().receive(on: DispatchQueue.global(qos: .background)).sink { [weak self] selectedFood in
            if let selectedFood = selectedFood {
                self?.selectedThermometer0WorkingFoodSubject.send(selectedFood)
                
            }
        }.store(in: &disposables)
        selectedThermometer0WorkingFoodSubject.receive(on: DispatchQueue.global(qos: .background)).sink { [weak self] tempFood in
            if let tempFood = tempFood {
                self?.availableThermometer0TempsSubject.send(Cook.getFoodPresets(food: tempFood))
            }
        }.store(in: &disposables)
        selectedThermometer1FoodSubject.removeDuplicates().receive(on: DispatchQueue.global(qos: .background)).sink { [weak self] selectedFood in
            if let selectedFood = selectedFood {
                self?.selectedThermometer1WorkingFoodSubject.send(selectedFood)
            }
        }.store(in: &disposables)
        selectedThermometer1WorkingFoodSubject.receive(on: DispatchQueue.global(qos: .background)).sink { [weak self] tempFood in
            if let tempFood = tempFood {
                self?.availableThermometer1TempsSubject.send(Cook.getFoodPresets(food: tempFood))
            }
        }.store(in: &disposables)
        selectedThermometer0TempSubject.removeDuplicates(by: { first, second in
            return first?.presetIndex == second?.presetIndex && first?.temp == second?.temp
        }).receive(on: DispatchQueue.global(qos: .background)).sink { [weak self] preset in
            if let preset = preset {
                self?.selectedThermometer0WorkingTempSubject.send(preset)
            }
        }.store(in: &disposables)
        selectedThermometer1TempSubject.removeDuplicates(by: { first, second in
            return first?.presetIndex == second?.presetIndex && first?.temp == second?.temp
        }).receive(on: DispatchQueue.global(qos: .background)).sink { [weak self] preset in
            if let preset = preset {
                self?.selectedThermometer1WorkingTempSubject.send(preset)
            }
        }.store(in: &disposables)
        selectedThermometer0GenericTempSubject.removeDuplicates().receive(on: DispatchQueue.global(qos: .background)).sink { [weak self] temperature in
            if let temperature = temperature {
                self?.selectedThermometer0WorkingGenericTempSubject.send(temperature)
            }
        }.store(in: &disposables)
        selectedThermometer1GenericTempSubject.removeDuplicates().receive(on: DispatchQueue.global(qos: .background)).sink { [weak self] temperature in
            if let temperature = temperature {
                self?.selectedThermometer1WorkingGenericTempSubject.send(temperature)
            }
        }.store(in: &disposables)
    }
    
    // MARK: - CELLS
    private func initCells() {
        progressCell = CookCellItem<GrillState>(
            cell: CookProgressCell.self,
            currentValueSubject: currentGrillStateSubject,
            unitsSubject: currentTemperatureUnitsSubject,
            onClick: { [weak self] control, packet in
                self?.skipPrecook()
            }
        )
        cookTypeCell = CookCellItem<CookType>(
            cell: CookTypeViewCell.self,
            currentValueSubject: currentCookTypeSubject,
            extrasSubject: currentGrillStateExtraSubject,
            onClick: { [weak self] control, identifier in
                guard let self = self else { return }
                if CookDisplayValues.isUpdateState(state: self.currentCalculatedStateSubject.value) {
                    if let cookType = identifier as? CookType {
                        if cookType == .Timed {
                            if self.currentCookTypeSubject.value != .Timed {
                                self.modalSubject.send(.ChangeToTimedCook)
                            }
                        } else if ![CookType.ProbeSingle, CookType.ProbeDouble].contains(self.currentCookTypeSubject.value) {
                            if let cookMode = self.currentCookModeSubject.value,
                                    CookDisplayValues.isDisabledThermometerMode(cookMode: cookMode) {
                                self.modalSubject.send(.ThermometerCookNotAvailable(cookMode))
                            } else {
                                self.modalSubject.send(.ChangeToThermometerCook)
                            }
                        }
                    }
                }
            }
        )
        cells = [
            .Woodfire: CookCellItem<Bool>(
                cell: WoodfireViewCell.self,
                enabledSubject: woodfireEnabledSubject,
                currentValueSubject: currentWoodfireSubject,
                onClick: { [weak self] control, value in
                    if let boolValue = value as? Bool {
                        self?.updateWoodfire(isOn: boolValue)
                    }
                }
            ),
            .GrillTimeTemp: CookCellItem<GrillState>(
                cell: TimeTemperatureViewCell.self,
                currentValueSubject: deviceControlService.currentStateSubject,
                unitsSubject: currentTemperatureUnitsSubject,
                onNavigate: { [weak self] navigationController, viewController in
                    guard let self = self else { return }
                    let viewController = self.getTimeTemperatureSettingsVC(mode: .ModeTimeTemp)
                    navigationController.pushViewController(viewController, animated: true)
                }
            ),
            .GrillTemp: CookCellItem<GrillState>(
                cell: TemperatureViewCell.self,
                currentValueSubject: deviceControlService.currentStateSubject,
                unitsSubject: currentTemperatureUnitsSubject,
                onNavigate: { [weak self] navigationController, viewController in
                    guard let self = self else { return }
                    let viewController = self.getTimeTemperatureSettingsVC(mode: .ModeTemp)
                    navigationController.pushViewController(viewController, animated: true)
                }
            ),
            .GrillMode: CookCellItem<CookMode>(
                cell: GrillModeViewCell.self,
                currentValueSubject: currentCookModeSubject,
                onNavigate: { [weak self] navigationController, viewController in
                    guard let self = self else { return }
                    let settingsMode: TimeTempSettingsViewController.SettingsMode =
                            self.currentCookTypeSubject.value != .Timed ? .ModeTemp : .ModeTimeTemp
                    let viewController = self.getTimeTemperatureSettingsVC(mode: settingsMode)
                    navigationController.pushViewController(viewController, animated: true)
                }
            ),
            .MiniThermometerContainer: CookCellItem<ExtendedGrillThermometer>(
                cell: MiniThermometerContainerCell.self,
                availableValuesSubject: availableThermometersSubject,
                unitsSubject: currentTemperatureUnitsSubject,
                extrasSubject: currentGrillStateExtraSubject
            ),
            .ThermometerSummary: CookCellItem<ExtendedGrillThermometer>(
                cell: ThermometerSummaryViewCell.self,
                availableValuesSubject: availableThermometersSubject,
                unitsSubject: currentTemperatureUnitsSubject,
                onNavigate: { [weak self] navigationController, viewController in
                    guard let self = self else { return }
                    if let thermometer = self.availableThermometersSubject.value.first(where: { $0.isSelected }) {
                        let state = self.currentCalculatedStateSubject.value ?? .Unknown
                        if thermometer.grillThermometer?.pluggedIn == true || CookDisplayValues.isPreheatState(state: state) {
                            let viewController = self.getThermometerSettingsVC(thermometer: thermometer)
                            navigationController.pushViewController(viewController, animated: true)
                        } else {
                            self.modalSubject.send(.ProbeNotPluggedIn(thermometer.index))
                        }
                    }
                }
            ),
        ]
    }
    
    // MARK: - SELECTOR CELLS
    private func initSelectors() {
        selectors = [
            .CookMode: CookCellItem<CookMode>(
                cell: ModeSelectionViewCell.self,
                title: "Cook Mode",
                currentValueSubject: currentCookModeWorkingSubject,
                storeValueSubject: currentCookModeSubject,
                availableValuesSubject: availableCookModesSubject,
                extrasSubject: currentCookTypeExtraSubject
            ),
            .GrillTime: CookCellItem<UInt32>(
                cell: TimePickerViewCell.self,
                title: "Grill Time",
                currentValueSubject: currentGrillTimeWorkingSubject,
                storeValueSubject: currentGrillTimeSubject,
                availableValuesSubject: availableGrillTimesSubject,
                unitsSubject: availableGrillTimesUnitSubject
            ),
            .GrillTemp: CookCellItem<UInt32>(
                cell: TemperaturePickerViewCell.self,
                title: "Grill Temp",
                currentValueSubject: currentGrillTempWorkingSubject,
                storeValueSubject: currentGrillTempSubject,
                availableValuesSubject: availableGrillTempsSubject,
                unitsSubject: availableGrillTempsUnitSubject,
                extrasSubject: currentCookModeWorkingExtrasSubject
            ),
            
            .Thermometer0FoodType: CookCellItem<Food>(
                cell: ProteinSelectionViewCell.self,
                title: "Food Type",
                currentValueSubject: selectedThermometer0WorkingFoodSubject,
                storeValueSubject: selectedThermometer0FoodSubject
            ),
            .Thermometer1FoodType: CookCellItem<Food>(
                cell: ProteinSelectionViewCell.self,
                title: "Food Type",
                currentValueSubject: selectedThermometer1WorkingFoodSubject,
                storeValueSubject: selectedThermometer1FoodSubject
            ),
            .Thermometer0Temp: CookCellItem<FoodPreset>(
                cell: DonenessPickerViewCell.self,
                title: "Thermometer #1 Temp",
                currentValueSubject: selectedThermometer0WorkingTempSubject,
                storeValueSubject: selectedThermometer0TempSubject,
                availableValuesSubject: availableThermometer0TempsSubject,
                unitsSubject: availableGrillTempsUnitSubject
            ),
            .Thermometer1Temp: CookCellItem<FoodPreset>(
                cell: DonenessPickerViewCell.self,
                title: "Thermometer #2 Temp",
                currentValueSubject: selectedThermometer1WorkingTempSubject,
                storeValueSubject: selectedThermometer1TempSubject,
                availableValuesSubject: availableThermometer1TempsSubject,
                unitsSubject: availableGrillTempsUnitSubject
            ),
            .Thermometer0OpenTemp: CookCellItem<UInt32>(
                cell: TemperaturePickerViewCell.self,
                title: "Thermometer #1 Generic Temp",
                identifier: "isThermometer",
                currentValueSubject: selectedThermometer0WorkingGenericTempSubject,
                storeValueSubject: selectedThermometer0GenericTempSubject,
                availableValuesSubject: availableGenericTempsSubject
            ),
            .Thermometer1OpenTemp: CookCellItem<UInt32>(
                cell: TemperaturePickerViewCell.self,
                title: "Thermometer #2 Generic Temp",
                identifier: "isThermometer",
                currentValueSubject: selectedThermometer1WorkingGenericTempSubject,
                storeValueSubject: selectedThermometer1GenericTempSubject,
                availableValuesSubject: availableGenericTempsSubject
            ),
            .HowToPlaceAThermometer: CookCellItem<Any>(
                cell: HowToPlaceThermometerCell.self
            ),
        ]
    }
}

// MARK: GRILL CONTROL
extension MonitorControlViewModel {
    
    func skipPrecook(completion: ((Error?) -> Void)? = nil) {
        Task {
            currentlyWorkingSubject.send(true)
            await Grill.skipPreheat().onSuccess(action:  { _ in
                completion?(nil)
                currentlyWorkingSubject.send(false)
            }).onFailure(action:  { error in
                completion?(error)
                currentlyWorkingSubject.send(false)
            })
        }
    }
    
    func stopCooking(completion: ((Error?) -> Void)? = nil) {
        Task {
            currentlyWorkingSubject.send(true)
            await Grill.stopCook().onSuccess(action: {
                completion?(nil)
                currentlyWorkingSubject.send(false)
            }).onFailure(action: { error in
                completion?(error)
                currentlyWorkingSubject.send(false)
            })
        }
    }
    
    func updateWoodfire(isOn: Bool, completion: ((Error?) -> Void)? = nil) {
        do {
            var currentCook = try Grill.getLastCook()
            currentCook = try currentCook?.setSmoke(smoke: isOn)
            try sendUpdateToGrill(cook: currentCook, completion: completion)
        } catch {
            Logger.Error("ERROR: Setting oven error")
        }
    }
    
    func updateOven(cookType: CookType, cookMode: CookMode, temperature: Int, duration: Int = 0, completion: ((Error?) -> Void)? = nil) {
        do {
            var currentCook = try Grill.getLastCook()
            currentCook = try currentCook?
                .setCookMode(cookMode: cookMode)
                .setTemp(temp: temperature)
            if cookType == .Timed {
                currentCook = try currentCook?.setDuration(time: duration)
            }
            try sendUpdateToGrill(cook: currentCook, completion: completion)
        } catch {
            Logger.Error("ERROR: Setting oven error")
        }
    }
    
    func updateThermometer(index: Int, protein: Food, preset: FoodPreset? = nil, temperature: Int? = nil, completion: ((Error?) -> Void)? = nil) {
        do {
            var currentCook = try Grill.getLastCook()
            if index == 0 {
                currentCook = (protein == .Manual) ?
                    try currentCook?.setProbe0Manual(temp: temperature ?? 0) :
                    try currentCook?.setProbe0Preset(food: protein, presetIndex: Int(preset?.presetIndex ?? 0))
            } else {
                currentCook = (protein == .Manual) ?
                    try currentCook?.setProbe1Manual(temp: temperature ?? 0) :
                    try currentCook?.setProbe1Preset(food: protein, presetIndex: Int(preset?.presetIndex ?? 0))
            }
            try sendUpdateToGrill(cook: currentCook, completion: completion)
        } catch {
            Logger.Error("ERROR: Setting probe \(index) error")
        }
    }
    
    private func sendUpdateToGrill(cook: Cook?, completion: ((Error?) -> Void)? = nil) throws {
        // Completion not in calling thread
        Task {
            do {
                currentlyWorkingSubject.send(true)
                _ = try cook?.sync().onSuccess(action: { result in
                    completion?(nil)
                    currentlyWorkingSubject.send(false)
                }).onFailure(action: { error in
                    completion?(error)
                    currentlyWorkingSubject.send(false)
                })
            } catch {
                completion?(GrillCoreError.updateFailed(message: "Update failed"))
                currentlyWorkingSubject.send(false)
            }
        }
    }
    
}

//MARK: MODALS
extension MonitorControlViewModel {
    
    func getTimeTemperatureSettingsVC(mode: TimeTempSettingsViewController.SettingsMode, cookType: CookType? = nil) -> UIViewController {
        if let cookType = cookType {
            self.currentCookTypeExtraSubject.send(cookType)
        }
        let viewController = TimeTempSettingsViewController()
        viewController.buttonTitle = CookDisplayValues.getModeDisplayName(cookMode: self.currentCookModeSubject.value ?? .NotSet)
        viewController.currentMode = mode
        viewController.timeCookItem = self.selectors[.GrillTime] as? CookCellItem<UInt32>
        viewController.tempCookItem = self.selectors[.GrillTemp] as? CookCellItem<UInt32>
        viewController.modeCookItem = self.selectors[.CookMode] as? CookCellItem<CookMode>
        viewController.theme = { ColorThemeManager.shared.monitorControlTheme }
        let cookType: CookType = (mode == .ModeTimeTemp) ? .Timed : .ProbeSingle
        viewController.onSave = { [weak self] mode, temp, duration in
            self?.updateOven(cookType: cookType, cookMode: mode, temperature: temp, duration: duration)
            viewController.modeCookItem?.storeValueSubject.send(mode)
            viewController.tempCookItem?.storeValueSubject.send(UInt32(temp))
            viewController.timeCookItem?.storeValueSubject.send((mode == .Broil) ? UInt32(duration) : UInt32(duration * 60))
            self?.currentCookTypeExtraSubject.send(self?.currentCookTypeSubject.value)
        }
        viewController.isValueChanged = {
            let mode = viewController.modeCookItem?.currentValueSubject.value
            if mode == .Broil || mode == .Unknown {
                return viewController.modeCookItem?.currentValueSubject.value != viewController.modeCookItem?.storeValueSubject.value
                || viewController.tempCookItem?.currentValueSubject.value != viewController.tempCookItem?.storeValueSubject.value
                || viewController.timeCookItem?.currentValueSubject.value != viewController.timeCookItem?.storeValueSubject.value
            } else {
                return viewController.modeCookItem?.currentValueSubject.value != viewController.modeCookItem?.storeValueSubject.value
                || viewController.tempCookItem?.currentValueSubject.value != viewController.tempCookItem?.storeValueSubject.value
                || (viewController.timeCookItem?.currentValueSubject.value ?? 0) * 60 != (viewController.timeCookItem?.storeValueSubject.value ?? 0)
            }
        }
        viewController.onCancel = { [weak self] in
            viewController.modeCookItem?.currentValueSubject.send(viewController.modeCookItem?.storeValueSubject.value)
            viewController.tempCookItem?.currentValueSubject.send(viewController.tempCookItem?.storeValueSubject.value)
            let mode = viewController.modeCookItem?.currentValueSubject.value
            if mode == .Broil || mode == .Unknown {
                viewController.timeCookItem?.currentValueSubject.send(viewController.timeCookItem?.storeValueSubject.value)
            } else {
                viewController.timeCookItem?.currentValueSubject.send((viewController.timeCookItem?.storeValueSubject.value ?? 0) / 60)
            }
            self?.currentCookTypeExtraSubject.send(self?.currentCookTypeSubject.value)
        }
        return viewController
    }
    
    func getThermometerSettingsVC(thermometer: ExtendedGrillThermometer) -> UIViewController {
        let viewController = ThermometerSettingsViewController()
        viewController.buttonTitle = "Thermometer #\(thermometer.index + 1)"
        viewController.foodCookItem = (thermometer.index == 0) ?
            self.selectors[.Thermometer0FoodType] as? CookCellItem<Food> : self.selectors[.Thermometer1FoodType] as? CookCellItem<Food>
        viewController.tempCookItem = (thermometer.index == 0) ?
            self.selectors[.Thermometer0Temp] as? CookCellItem<FoodPreset> : self.selectors[.Thermometer1Temp] as? CookCellItem<FoodPreset>
        viewController.genericTempCookItem = (thermometer.index == 0) ?
            self.selectors[.Thermometer0OpenTemp] as? CookCellItem<UInt32> : self.selectors[.Thermometer1OpenTemp] as? CookCellItem<UInt32>
        viewController.thermometer = thermometer.grillThermometer
        viewController.howToPlaceItem = self.selectors[.HowToPlaceAThermometer] as? CookCellItem<Any>
        viewController.theme = { ColorThemeManager.shared.monitorControlTheme }
        viewController.onSave = { [weak self] protein, foodPreset, temperature in
            self?.updateThermometer(index: thermometer.index, protein: protein, preset: foodPreset, temperature: temperature)
            viewController.foodCookItem?.storeValueSubject.send(protein)
            viewController.tempCookItem?.storeValueSubject.send(foodPreset)
            viewController.genericTempCookItem?.storeValueSubject.send(UInt32(temperature ?? 0))
        }
        return viewController
    }

    func getProgressState(state: GrillState) -> (UInt, CalculatedState) {
        switch state.cookType {
        case .ProbeSingle, .ProbeDouble:
            return getCurrentProbeState(state: state)
        default:
            return getCurrentCookState(state: state)
        }
    }
    
    func getCurrentCookState(state: GrillState) -> (UInt, CalculatedState) {
        switch state.state {
        case .Igniting:
            return (state.ignitionProgress, state.state)
        case .Preheating, .AddFood:
            return (state.preheatProgress, state.state)
        case .Cooking:
            return (state.cookProgress, state.state)
        case .Resting:
            return (state.restingProgress, state.state)
        default:
            return (0, state.state)
        }
    }
    
    func getCurrentProbeState(state: GrillState) -> (UInt, CalculatedState) {
        let probes = availableThermometersSubject.value
        if let selectedProbe = probes.first(where: { $0.isSelected })?.grillThermometer {
            switch selectedProbe.state {
            case .Cooking:
                return (selectedProbe.cookProgress, selectedProbe.state)
            case .Resting, .GetFood:
                return (selectedProbe.restingProgress, .Resting)
            case .FlipFood, .Done, .PlugInProbe1, .PlugInProbe2:
                return (0, selectedProbe.state)
            default:
                return getCurrentCookState(state: state)
            }
        } else {
            return getCurrentCookState(state: state)
        }
    }
}
