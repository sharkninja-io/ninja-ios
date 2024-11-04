//
//  CookViewModel.swift
//  Ninja
//
//  Created by Martin Burch on 12/27/22.
//

import UIKit
import Combine
import GrillCore

typealias Cook = GrillCoreSDK.Cook
typealias CookMode = GrillCoreSDK.CookMode
typealias CookType = GrillCoreSDK.CookType
typealias Food = GrillCoreSDK.Food
typealias FoodPreset = GrillCoreSDK.FoodPreset
typealias GrillState = GrillCoreSDK.GrillState

struct PrecookThermometer {
    var isOn: Bool = false
    var food: Food?
    var foodPreset: FoodPreset?
    var temperature: UInt32?
    var pluggedIn: Bool = false
}

class PreCookViewModel {
    
    var disposables: Set<AnyCancellable> = []

    var reviewRequestService: ReviewRequestService = .shared

    var controlsSubject = CurrentValueSubject<[CookItem], Never>([])
    
    var currentlyWorkingSubject = CurrentValueSubject<Bool, Never>(false)

    // Grill
    var selectedCookTypeSubject = CurrentValueSubject<CookType?, Never>(.Timed)
    var selectedCookTypeAnySubject = CurrentValueSubject<Any?, Never>(nil)
    
    var availableCookModesSubject = CurrentValueSubject<[CookMode], Never>([])
    var woodfireEnabledSubject = CurrentValueSubject<Bool, Never>(false)
    var availableGrillTimesSubject = CurrentValueSubject<[UInt32], Never>([])
    var availableGrillTempsSubject = CurrentValueSubject<[UInt32], Never>([])
    var availableGrillTimesUnitSubject = CurrentValueSubject<String?, Never>(nil)
    var availableGrillTempsUnitSubject = CurrentValueSubject<String?, Never>(nil)
    var selectedCookModeSubject = CurrentValueSubject<CookMode?, Never>(nil)
    var selectedCookModeAnySubject = CurrentValueSubject<Any?, Never>(nil)
    var selectedWoodfireSubject = CurrentValueSubject<Bool?, Never>(false)
    var selectedGrillTimeSubject = CurrentValueSubject<UInt32?, Never>(nil)
    var selectedGrillTimeWorkingSubject = CurrentValueSubject<UInt32?, Never>(nil)
    var selectedGrillTempSubject = CurrentValueSubject<UInt32?, Never>(nil)
    var selectedGrillTempWorkingSubject = CurrentValueSubject<UInt32?, Never>(nil)
    var selectedGrillTimeTempSubject = CurrentValueSubject<(String, String)?, Never>(nil)

    // Thermometers
    var availableFoodsSubject = CurrentValueSubject<[Food], Never>([])
    var availableGenericTempsSubject = CurrentValueSubject<[UInt32], Never>([])
    
    var availableThermometer0TempsSubject = CurrentValueSubject<[FoodPreset], Never>([])
    var selectedThermometer0IsOnSubject = CurrentValueSubject<Bool, Never>(false)
    var selectedThermometer0FoodSubject = CurrentValueSubject<Food?, Never>(nil)
    var selectedThermometer0FoodWorkingSubject = CurrentValueSubject<Food?, Never>(nil)
    var selectedThermometer0TempSubject = CurrentValueSubject<FoodPreset?, Never>(nil)
    var selectedThermometer0TempWorkingSubject = CurrentValueSubject<FoodPreset?, Never>(nil)
    var selectedThermometer0GenericTempSubject = CurrentValueSubject<UInt32?, Never>(165)
    var selectedThermometer0GenericTempWorkingSubject = CurrentValueSubject<UInt32?, Never>(nil)
    var thermometer0ValuesSubject = CurrentValueSubject<PrecookThermometer?, Never>(PrecookThermometer())

    var availableThermometer1TempsSubject = CurrentValueSubject<[FoodPreset], Never>([])
    var selectedThermometer1FoodSubject = CurrentValueSubject<Food?, Never>(nil)
    var selectedThermometer1FoodWorkingSubject = CurrentValueSubject<Food?, Never>(nil)
    var selectedThermometer1IsOnSubject = CurrentValueSubject<Bool, Never>(false)
    var selectedThermometer1TempSubject = CurrentValueSubject<FoodPreset?, Never>(nil)
    var selectedThermometer1TempWorkingSubject = CurrentValueSubject<FoodPreset?, Never>(nil)
    var selectedThermometer1GenericTempSubject = CurrentValueSubject<UInt32?, Never>(165)
    var selectedThermometer1GenericTempWorkingSubject = CurrentValueSubject<UInt32?, Never>(nil)
    var thermometer1ValuesSubject = CurrentValueSubject<PrecookThermometer?, Never>(PrecookThermometer())

    // VARIABLES
    var cells: [CookCells: CookItem] = [:]
    var selectors: [CookSelectors: CookItem] = [:]
    
    var cookModeDisplayString: String?

    private static var _instance: PreCookViewModel = .init()
    static var shared: PreCookViewModel {
        get { _instance }
    }
    
    private init() {
        initCells()
        initSelectors()
        initSubjects()

        let manualTemps = Cook.getFoodPresets(food: .Manual).map { UInt32($0.temp) }
        availableGenericTempsSubject.send(manualTemps)
        availableCookModesSubject.send(Cook.getCookModesUS())
        selectedCookTypeSubject.send(.Timed)
        selectedThermometer0FoodSubject.send(.Manual)
        selectedThermometer1FoodSubject.send(.Manual)
        selectedCookModeSubject.send(.Grill)
    }
    
    deinit {
        disposables.removeAll()
    }
    
    private func initSubjects() {
        disposables.removeAll()
        
        selectedCookTypeSubject.receive(on: DispatchQueue.main).sink { [weak self] cookType in
            guard let self = self else { return }
            self.selectedCookTypeAnySubject.send(cookType)

            switch cookType {
            case .Timed:
                self.controlsSubject.send([
                    self.cells[.Woodfire] ?? CookItem(cell: CookControlsViewCell.self),
                    self.cells[.GrillTimeTemp] ?? CookItem(cell: CookControlsViewCell.self)
                ])
            default:
                if [CookMode.Broil, CookMode.Dehydrate].contains(self.selectedCookModeSubject.value) {
                    self.selectedCookModeSubject.send(.Grill)
                }
                self.controlsSubject.send([
                    self.cells[.Woodfire] ?? CookItem(cell: CookControlsViewCell.self),
                    self.cells[.GrillTemp] ?? CookItem(cell: CookControlsViewCell.self),
                    self.cells[.Thermometer0Temp] ?? CookItem(cell: CookControlsViewCell.self),
                    self.cells[.Thermometer1Temp] ?? CookItem(cell: CookControlsViewCell.self)
                ])
            }
        }.store(in: &disposables)
        selectedCookModeSubject.receive(on: DispatchQueue.main).sink { [weak self] cookMode in
            guard let self = self else { return }
            self.selectedCookModeAnySubject.send(cookMode)

            if let cookMode = cookMode {
                self.woodfireEnabledSubject.send(cookMode == .Broil || cookMode == .Smoke ? false : true)
                if cookMode == .Smoke {
                    self.selectedWoodfireSubject.send(true)
                } else {
                    self.selectedWoodfireSubject.send(false)
                }
                self.availableGrillTimesUnitSubject.send(Cook.getAvailableTimesUnit(cookMode: cookMode))
                self.availableGrillTempsUnitSubject.send(Cook.getAvailableTempsUnit(cookMode: cookMode))
                self.availableGrillTempsSubject.send(Cook.getAvailableTemps(cookMode: cookMode))
                self.availableGrillTimesSubject.send(Cook.getAvailableTimes(cookMode: cookMode))
                self.selectedGrillTimeSubject.send(Cook.getDefaultTime(cookMode: cookMode))
                self.selectedGrillTempSubject.send(Cook.getDefaultTemp(cookMode: cookMode))
            }
        }.store(in: &disposables)
        selectedGrillTimeSubject.removeDuplicates().receive(on: DispatchQueue.main).sink { [weak self] time in
            guard let self = self else { return }

            if let time = time {
                self.selectedGrillTimeWorkingSubject.send(time)
                let lastValues = self.selectedGrillTimeTempSubject.value
                let lastUnits = self.availableGrillTimesUnitSubject.value
                self.selectedGrillTimeTempSubject.send((CookDisplayValues.getTimeDisplayString(time: Int(time), units: lastUnits ?? ""), lastValues?.1 ?? ""))
            }
        }.store(in: &disposables)
        selectedGrillTempSubject.receive(on: DispatchQueue.main).sink { [weak self] temp in
            guard let self = self else { return }

            if let temp = temp {
                self.selectedGrillTempWorkingSubject.send(temp)
                let lastValues = self.selectedGrillTimeTempSubject.value
                let lastUnits = self.availableGrillTempsUnitSubject.value
                let mode = self.selectedCookModeSubject.value ?? .Unknown
                self.selectedGrillTimeTempSubject.send((lastValues?.0 ?? "", CookDisplayValues.getTemperatureDisplayString(temp: Int(temp), units: lastUnits ?? "", mode: mode)))
            }
        }.store(in: &disposables)
        
        // THERMOMETERS
        selectedThermometer0IsOnSubject.receive(on: DispatchQueue.main).sink { [weak self] isOn in
            guard let self = self else { return }
            
            var thermometer = self.thermometer0ValuesSubject.value
            thermometer?.isOn = isOn
            self.thermometer0ValuesSubject.send(thermometer)
        }.store(in: &disposables)
        selectedThermometer1IsOnSubject.receive(on: DispatchQueue.main).sink { [weak self] isOn in
            guard let self = self else { return }
            
            var thermometer = self.thermometer1ValuesSubject.value
            thermometer?.isOn = isOn
            self.thermometer1ValuesSubject.send(thermometer)
        }.store(in: &disposables)
        selectedThermometer0FoodSubject.removeDuplicates().receive(on: DispatchQueue.main).sink { [weak self] selectedFood in
            guard let self = self else { return }
            
            if let selectedFood = selectedFood {
                self.selectedThermometer0FoodWorkingSubject.send(selectedFood)
                var thermometer = self.thermometer0ValuesSubject.value
                thermometer?.food = selectedFood
                self.thermometer0ValuesSubject.send(thermometer)
            }
        }.store(in: &disposables)
        selectedThermometer0FoodWorkingSubject.receive(on: DispatchQueue.main).sink { [weak self] tempFood in
            guard let self = self else { return }
            
            if let tempFood = tempFood {
                self.availableThermometer0TempsSubject.send(Cook.getFoodPresets(food: tempFood))
            }
        }.store(in: &disposables)
        selectedThermometer1FoodSubject.removeDuplicates().receive(on: DispatchQueue.main).sink { [weak self] selectedFood in
            guard let self = self else { return }
            
            if let selectedFood = selectedFood {
                self.selectedThermometer1FoodWorkingSubject.send(selectedFood)
                var thermometer = self.thermometer1ValuesSubject.value
                thermometer?.food = selectedFood
                self.thermometer1ValuesSubject.send(thermometer)
             }
        }.store(in: &disposables)
        selectedThermometer1FoodWorkingSubject.receive(on: DispatchQueue.main).sink { [weak self] tempFood in
            guard let self = self else { return }
            
            if let tempFood = tempFood {
                self.availableThermometer1TempsSubject.send(Cook.getFoodPresets(food: tempFood))
            }
        }.store(in: &disposables)
        
        selectedThermometer0TempSubject.removeDuplicates().receive(on: DispatchQueue.main).sink { [weak self] preset in
            guard let self = self else { return }
            
            self.selectedThermometer0TempWorkingSubject.send(preset)
            var thermometer = self.thermometer0ValuesSubject.value
            thermometer?.foodPreset = preset
            self.thermometer0ValuesSubject.send(thermometer)
        }.store(in: &disposables)
        selectedThermometer0GenericTempSubject.removeDuplicates().receive(on: DispatchQueue.main).sink { [weak self] temp in
            guard let self = self else { return }
            
            self.selectedThermometer0GenericTempWorkingSubject.send(temp)
            var thermometer = self.thermometer0ValuesSubject.value
            thermometer?.temperature = temp
            self.thermometer0ValuesSubject.send(thermometer)
        }.store(in: &disposables)
        selectedThermometer1TempSubject.removeDuplicates().receive(on: DispatchQueue.main).sink { [weak self] preset in
            guard let self = self else { return }
            
            self.selectedThermometer1TempWorkingSubject.send(preset)
            var thermometer = self.thermometer1ValuesSubject.value
            thermometer?.foodPreset = preset
            self.thermometer1ValuesSubject.send(thermometer)
        }.store(in: &disposables)
        selectedThermometer1GenericTempSubject.removeDuplicates().receive(on: DispatchQueue.main).sink { [weak self] temp in
            guard let self = self else { return }
            
            self.selectedThermometer1GenericTempWorkingSubject.send(temp)
            var thermometer = self.thermometer1ValuesSubject.value
            thermometer?.temperature = temp
            self.thermometer1ValuesSubject.send(thermometer)
        }.store(in: &disposables)
    }
    
    private func initCells() {
        cells = [
            .Woodfire: CookCellItem<Bool>(
                cell: WoodfireViewCell.self,
                enabledSubject: woodfireEnabledSubject,
                currentValueSubject: selectedWoodfireSubject
            ),
            .GrillTimeTemp: CookCellItem<(String, String)>(
                cell: TimeTemperatureViewCell.self,
                currentValueSubject: selectedGrillTimeTempSubject,
                onNavigate: { [weak self] navigationController, viewController in
                    guard let self = self else { return }
                    let viewController = self.getTimeTemperatureSettingsVC(mode: .TimeTemp)
                    navigationController.pushViewController(viewController, animated: true)
                }
            ),
            .GrillTemp: CookCellItem<(String, String)>(
                cell: TemperatureViewCell.self,
                currentValueSubject: selectedGrillTimeTempSubject,
                onNavigate: { [weak self] navigationController, viewController in
                    guard let self = self else { return }
                    let viewController = self.getTimeTemperatureSettingsVC(mode: .Temp)
                    navigationController.pushViewController(viewController, animated: true)
                }
            ),
            .Thermometer0Temp: CookCellItem<PrecookThermometer>(
                cell: ThermometerViewCell.self,
                title: "Thermometer #1",
                identifier: "1",
                enabledSubject: selectedThermometer0IsOnSubject,
                currentValueSubject: thermometer0ValuesSubject,
                onNavigate: { [weak self] navigationController, viewController in
                    guard let self = self else { return }
                    if self.selectedThermometer0IsOnSubject.value == true {
                        let viewController = self.getThermometerSettings(index: 0)
                        navigationController.pushViewController(viewController, animated: true)
                    }
                }
            ),
            .Thermometer1Temp: CookCellItem<PrecookThermometer>(
                cell: ThermometerViewCell.self,
                title: "Thermometer #2",
                identifier: "2",
                enabledSubject: selectedThermometer1IsOnSubject,
                currentValueSubject: thermometer1ValuesSubject,
                onNavigate: { [weak self] navigationController, viewController in
                    guard let self = self else { return }
                    if self.selectedThermometer1IsOnSubject.value == true {
                        let viewController = self.getThermometerSettings(index: 1)
                        navigationController.pushViewController(viewController, animated: true)
                    }
                }
            ),
        ]
    }
    
    private func getTimeTemperatureSettingsVC(mode: TimeTempSettingsViewController.SettingsMode) -> UIViewController {
        let viewController = TimeTempSettingsViewController()
        viewController.currentCookMode = self.selectedCookModeSubject.value ?? .NotSet
        viewController.buttonTitle = CookDisplayValues.getModeDisplayName(cookMode: self.selectedCookModeSubject.value ?? .NotSet)
        viewController.timeCookItem = mode == .TimeTemp ? self.selectors[.GrillTime] as? CookCellItem<UInt32> : nil
        viewController.tempCookItem = self.selectors[.GrillTemp] as? CookCellItem<UInt32>
        viewController.currentMode = mode
        viewController.onSave = { mode, temperature, duration in
            viewController.tempCookItem?.storeValueSubject.send(UInt32(temperature))
            viewController.timeCookItem?.storeValueSubject.send(UInt32(duration))
        }
        return viewController
    }
    
    private func getThermometerSettings(index: Int) -> UIViewController {
        let viewController = ThermometerSettingsViewController()
        viewController.buttonTitle = "Thermometer #\(index + 1)"
        viewController.foodCookItem = (index == 0) ? self.selectors[.Thermometer0FoodType] as? CookCellItem<Food> : self.selectors[.Thermometer1FoodType] as? CookCellItem<Food>
        viewController.tempCookItem = (index == 0) ? self.selectors[.Thermometer0Temp] as? CookCellItem<FoodPreset> : self.selectors[.Thermometer1Temp] as? CookCellItem<FoodPreset>
        viewController.genericTempCookItem = (index == 0) ? self.selectors[.Thermometer0OpenTemp] as? CookCellItem<UInt32> : self.selectors[.Thermometer1OpenTemp] as? CookCellItem<UInt32>
        viewController.howToPlaceItem = self.selectors[.HowToPlaceAThermometer] as? CookCellItem<Any>
        viewController.onSave = { protein, foodPreset, temperature in
            viewController.foodCookItem?.storeValueSubject.send(protein)
            viewController.tempCookItem?.storeValueSubject.send(foodPreset)
            viewController.genericTempCookItem?.storeValueSubject.send(UInt32(temperature ?? 0))
        }
        return viewController
    }

    private func initSelectors() {
        selectors = [
            .CookType: CookCellItem<CookType>(
                cell: CookTypeViewCell.self,
                currentValueSubject: selectedCookTypeSubject,
                onClick: { [weak self] control, identifier in
                    if let group = control as? ToggleButtonGroup, let cookType = group.selectedButton?.identifier as? CookType {
                        self?.selectedCookTypeSubject.send(cookType)
                    }
                }
            ),
            .CookMode: CookCellItem<CookMode>(
                cell: ModeSelectionViewCell.self,
                title: "Cook Mode",
                currentValueSubject: selectedCookModeSubject,
                availableValuesSubject: availableCookModesSubject,
                extrasSubject: selectedCookTypeAnySubject
            ),
            .GrillTime: CookCellItem<UInt32>(
                cell: TimePickerViewCell.self,
                title: "Grill Time",
                currentValueSubject: selectedGrillTimeWorkingSubject,
                storeValueSubject: selectedGrillTimeSubject,
                availableValuesSubject: availableGrillTimesSubject,
                unitsSubject: availableGrillTimesUnitSubject
            ),
            .GrillTemp: CookCellItem<UInt32>(
                cell: TemperaturePickerViewCell.self,
                title: "Grill Temp",
                currentValueSubject: selectedGrillTempWorkingSubject,
                storeValueSubject: selectedGrillTempSubject,
                availableValuesSubject: availableGrillTempsSubject,
                unitsSubject: availableGrillTempsUnitSubject,
                extrasSubject: selectedCookModeAnySubject
            ),
            .Thermometer0FoodType: CookCellItem<Food>(
                cell: ProteinSelectionViewCell.self,
                title: "Food Type",
                currentValueSubject: selectedThermometer0FoodWorkingSubject,
                storeValueSubject: selectedThermometer0FoodSubject
            ),
            .Thermometer1FoodType: CookCellItem<Food>(
                cell: ProteinSelectionViewCell.self,
                title: "Food Type",
                currentValueSubject: selectedThermometer1FoodWorkingSubject,
                storeValueSubject: selectedThermometer1FoodSubject
            ),
            .Thermometer0Temp: CookCellItem<FoodPreset>(
                cell: DonenessPickerViewCell.self,
                title: "Thermometer #1 Temp",
                currentValueSubject: selectedThermometer0TempWorkingSubject,
                storeValueSubject: selectedThermometer0TempSubject,
                availableValuesSubject: availableThermometer0TempsSubject,
                unitsSubject: availableGrillTempsUnitSubject
            ),
            .Thermometer1Temp: CookCellItem<FoodPreset>(
                cell: DonenessPickerViewCell.self,
                title: "Thermometer #2 Temp",
                currentValueSubject: selectedThermometer1TempWorkingSubject,
                storeValueSubject: selectedThermometer1TempSubject,
                availableValuesSubject: availableThermometer1TempsSubject,
                unitsSubject: availableGrillTempsUnitSubject
            ),
            .Thermometer0OpenTemp: CookCellItem<UInt32>(
                cell: TemperaturePickerViewCell.self,
                title: "Thermometer #1 Generic Temp",
                identifier: "isThermometer",
                currentValueSubject: selectedThermometer0GenericTempWorkingSubject,
                storeValueSubject: selectedThermometer0GenericTempSubject,
                availableValuesSubject: availableGenericTempsSubject
            ),
            .Thermometer1OpenTemp: CookCellItem<UInt32>(
                cell: TemperaturePickerViewCell.self,
                title: "Thermometer #2 Generic Temp",
                identifier: "isThermometer",
                currentValueSubject: selectedThermometer1GenericTempWorkingSubject,
                storeValueSubject: selectedThermometer1GenericTempSubject,
                availableValuesSubject: availableGenericTempsSubject
            ),
            .HowToPlaceAThermometer: CookCellItem<Any>(
                cell: HowToPlaceThermometerCell.self
            ),
        ]
    }
    
    func isValidCook(cookType: CookType?, thermometer1: PrecookThermometer, thermometer2: PrecookThermometer) -> Bool {
        return cookType == .Timed ||
             (thermometer1.isOn && (thermometer1.foodPreset != nil || (thermometer1.food == .Manual))) ||
             (thermometer2.isOn && (thermometer2.foodPreset != nil || (thermometer2.food == .Manual)))
    }
    
    func setProbePluggedIn(index: Int, pluggedIn: Bool) {
        if index == 0 {
            var thermometer = thermometer0ValuesSubject.value
            thermometer?.pluggedIn = pluggedIn
            thermometer0ValuesSubject.send(thermometer)
        } else {
            var thermometer = thermometer1ValuesSubject.value
            thermometer?.pluggedIn = pluggedIn
            thermometer1ValuesSubject.send(thermometer)
        }
    }
    
    func setChartsCook(cookMode: CookMode, temp: UInt32, duration: UInt32, woodfire: Bool) {
        selectedCookTypeSubject.send(.Timed)
        selectedCookModeSubject.send(cookMode)
        selectedThermometer0IsOnSubject.send(false)
        selectedThermometer1IsOnSubject.send(false)
        DispatchQueue.main.async { [weak self] in
            self?.selectedGrillTempSubject.send(UInt32(temp))
            self?.selectedGrillTimeSubject.send(UInt32(duration))
            self?.selectedWoodfireSubject.send(woodfire)
        }
    }
    
    func startCooking(completion: ((Error?) -> Void)? = nil) {
        var newCook: Cook?
        
        do {
            newCook = try Cook.new()
                .setCookMode(cookMode: self.selectedCookModeSubject.value ?? .Grill)
                .setTemp(temp: Int(self.selectedGrillTempSubject.value ?? 2))
                .setSmoke(smoke: self.selectedWoodfireSubject.value ?? false)
            
            // Timed cook setting
            if self.selectedCookTypeSubject.value == .Timed {
                newCook = try newCook?.setDuration(time: Int(self.selectedGrillTimeSubject.value ?? 0))
            } else {
                // Probe 0 settings
                if self.selectedThermometer0IsOnSubject.value {
                    if self.selectedThermometer0FoodSubject.value == .Manual,
                       let temp = self.selectedThermometer0GenericTempSubject.value {
                        newCook = try newCook?.setProbe0Manual(temp: Int(temp))
                    } else {
                        if let food = self.selectedThermometer0FoodSubject.value,
                           let preset = self.selectedThermometer0TempSubject.value {
                            newCook = try newCook?.setProbe0Preset(food: food, presetIndex: Int(preset.presetIndex))
                        }
                    }
                }
                // Probe 1 settings
                if self.selectedThermometer1IsOnSubject.value {
                    if self.selectedThermometer1FoodSubject.value == .Manual,
                       let temp = self.selectedThermometer1GenericTempSubject.value {
                        newCook = try newCook?.setProbe1Manual(temp: Int(temp))
                    } else {
                        if let food = self.selectedThermometer1FoodSubject.value,
                           let preset = self.selectedThermometer1TempSubject.value {
                            newCook = try newCook?.setProbe1Preset(food: food, presetIndex: Int(preset.presetIndex))
                        }
                    }
                }
            }
        } catch {
            Logger.Error("ERROR: Setting Cook Values")
        }

        sendCook(newCook: newCook, completion: completion)
    }
    
    private func sendCook(newCook: Cook?, completion: ((Error?) -> Void)? = nil) {
        Task {
            do {
                currentlyWorkingSubject.send(true)
                _ = try newCook?.sync().onSuccess(action: { result in
                    completion?(nil)
                    currentlyWorkingSubject.send(false)
                    reviewRequestService.incrementDeviceUsageCount()
                }).onFailure(action: { error in
                    completion?(error)
                    currentlyWorkingSubject.send(false)
                })
            } catch {
                Logger.Error("ERROR: Failed sending cook")
                completion?(GrillCoreError.updateFailed(message: "Send cook failed"))
                currentlyWorkingSubject.send(false)
            }
        }
    }
}
