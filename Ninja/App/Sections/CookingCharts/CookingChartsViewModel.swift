//
//  CookingChartsViewModel.swift
//  Ninja
//
//  Created by Richard Jacobson on 1/30/23.
//

import Foundation
import UIKit
import Combine
import GrillCore


protocol SentCookingChartCommandDelegate: AnyObject {
    func sendCookingChartCommand(cookMode: GrillCoreSDK.CookMode, temp: Int, duration: Int, infuse: Bool)
}

final class CookingChartsViewModel {
    
    
    var disposables = Set<AnyCancellable>()
    var navigateToCook: Bool = false
    
    public var displaySubject = CurrentValueSubject<[CookItem], Never>([CookItem(cell: FoodModeSelectionViewCell.self)])
    
    var selectedFoodCategory: FoodCategories = .beef { didSet { self.reloadRecipesForPreCook() }}
    var selectedCookModeType: GrillCoreSDK.CookMode = .NotSet
    var validFoodCategories: [FoodCategoryItem] = []

    var cookTimeSelectedFilters: [Range<Int>] = []
    var cookModeSelectedFilters: [String] = []
    var foodTypeSelectedFilter: [FoodCategories] = []
    
    var previousCookTimeFilters: [Range<Int>] = []
    var previousCookModeFilters: [String] = []
    var previousFoodTypeFilters: [FoodCategories] = []

    var charts: [CookingCharts] = []
    var filteredCharts: [CookingCharts] = []
    var galleryCharts: [CookingCharts] = []
    
    var hasActiveFilters: Bool {
        return !cookModeSelectedFilters.isEmpty
        || !cookTimeSelectedFilters.isEmpty
        || !foodTypeSelectedFilter.isEmpty
    }
    
    var didLoadFromPrecook = false

    // MARK: Singleton
    private static var _instance: CookingChartsViewModel = .init()
    public static func shared() -> CookingChartsViewModel { return _instance }
    
    // MARK: Delegate
    weak var delegate: SentCookingChartCommandDelegate?

    private init() {
        if let json = Json.readLocalJSONFile(forName: "cooking_charts") {
            parseJSONForCharts(json: json)
        }
    }
    
}

/// Parsing
extension CookingChartsViewModel {
    func parseJSONForCharts(json: Data) {
        do {
            let decodedData = try JSONDecoder().decode([CookingCharts].self,
                                                       from: json)
            charts = decodedData
            
        } catch {
            print("decode error")
        }
    }
}

/// Sorting for precook
extension CookingChartsViewModel {
    func hasCookMode(cookMode: CookMode) -> Bool {
        let mode = Mode.getFromCookMode(cookMode: cookMode)
        return charts.first { $0.mode == mode } != nil
    }
    
    func setCookModeAndValidFoodCategories(cookMode: CookMode) {
        selectedCookModeType = cookMode // set the cook mode the user selected
        setValidFoodCategoriesForMode(cookMode: cookMode)
    }
    
    private func setValidFoodCategoriesForMode(cookMode: CookMode) {
        let categories = getFoodCategoriesWithIcons()
        let mode = Mode.getFromCookMode(cookMode: cookMode)
        let chartGroups = charts.filter { $0.mode == mode }
            .map { $0.group }
            .unique()
        
        validFoodCategories = categories.filter({ category in
            chartGroups.contains(category.title)
        })
    }
    
    private func reloadRecipesForPreCook() {
        sortRecipesForCookModeAndFoodCategory(foodCategory: selectedFoodCategory , selectedCook: selectedCookModeType)
    }
    
    func sortRecipesForCookModeAndFoodCategory(foodCategory: FoodCategories, selectedCook: CookMode) {
        let selectedCookMode = Mode.getFromCookMode(cookMode: selectedCook)
        galleryCharts = charts.filter({
            $0.mode == selectedCookMode && getCategoryFromGroup(group: $0.group) == foodCategory
        })
    }
}
    
/// filtering for explore
extension CookingChartsViewModel {
    func filterChartsForExplore() {
        if cookModeSelectedFilters.isEmpty && cookTimeSelectedFilters.isEmpty && foodTypeSelectedFilter.isEmpty {
            filteredCharts = []
        } else {
            filteredCharts = charts.filter { chart in
                return (cookModeSelectedFilters.isEmpty || cookModeSelectedFilters.contains(chart.mode.rawValue.capitalized))
                && (foodTypeSelectedFilter.isEmpty || foodTypeSelectedFilter.contains(getCategoryFromGroup(group: chart.group)))
                && (cookTimeSelectedFilters.isEmpty || cookTimeSelectedFilters.contains(where: { item in item.contains(chart.time/60) }))
            }
        }
    }
    
}

/// Clearing Filters and Valid Food Categories
extension CookingChartsViewModel {
    func clearAllFilters() {
        cookTimeSelectedFilters.removeAll()
        cookModeSelectedFilters.removeAll()
        foodTypeSelectedFilter.removeAll()
        filteredCharts.removeAll()
        validFoodCategories.removeAll()
    }
}


/// Get/Set Helper Methods
extension CookingChartsViewModel {
    
    func getCategoryFromGroup(group: String) -> FoodCategories {
        return FoodCategories(fromRawValue: group)
    }
    
    func getModeFromString(modeStr: String) -> Mode {
        return Mode.init(fromRawValue: modeStr.lowercased())
    }
    
    func getCookModeFromMode(mode: Mode) -> CookMode {
        switch mode {
        case .airCrisp:
            return .AirCrisp
        case .dehydrate:
            return .Dehydrate
        case .grill:
            return .Grill
        case .smoke:
            return .Smoke
        case .bake:
            return .Bake
        case .roast:
            return .Roast
        case .invalid:
            return .NotSet
        }
    }
    
    func isFoodCategoryNotEmpty(category: FoodCategories) -> Bool {
        return charts.first { category == getCategoryFromGroup(group: $0.group) } != nil
    }
    
    func getFoodCategoriesWithIcons() -> [FoodCategoryItem] {
        return FoodCategories.allCases
            .filter({ isFoodCategoryNotEmpty(category: $0) })
            .map({ item in
                FoodCategoryItem(title: item.rawValue, icon: getIconForCategory(category: item))
            })
    }
    
    func getIconForCategory(category: FoodCategories) -> UIImage {
        switch category {
        case .vegetable:
            return IconAssetLibrary.ico_carrot.asImage()?.tint(color: ColorThemeManager.shared.theme.grey02) ?? UIImage()
        case .beef:
            return IconAssetLibrary.ico_beef2.asImage()?.tint(color: ColorThemeManager.shared.theme.grey02) ?? UIImage()
        case .pork:
            return IconAssetLibrary.ico_pork2.asImage()?.tint(color: ColorThemeManager.shared.theme.grey02) ?? UIImage()
        case .poultry:
            return IconAssetLibrary.ico_poultry2.asImage()?.tint(color: ColorThemeManager.shared.theme.grey02) ?? UIImage()
        case .seafood:
            return IconAssetLibrary.ico_fish2.asImage()?.tint(color: ColorThemeManager.shared.theme.grey02) ?? UIImage()
        case .fruit:
            return IconAssetLibrary.ico_apple.asImage()?.tint(color: ColorThemeManager.shared.theme.grey02) ?? UIImage()
        case .lambVeal:
            return IconAssetLibrary.ico_lambveal.asImage()?.tint(color: ColorThemeManager.shared.theme.grey02) ?? UIImage()
        case .breadCheese:
            return IconAssetLibrary.ico_cheese.asImage()?.tint(color: ColorThemeManager.shared.theme.grey02) ?? UIImage()
        case .other:
            return IconAssetLibrary.ico_more.asImage()?.tint(color: ColorThemeManager.shared.theme.grey02) ?? UIImage()
        }
    }
}

/// Start Cook
extension CookingChartsViewModel {
    
    func startCooking(cookMode: GrillCoreSDK.CookMode, temp: Int, duration: Int, infuse: Bool, completion: ((Error?) -> Void)? = nil) {
        delegate?.sendCookingChartCommand(cookMode: cookMode, temp: temp, duration: duration, infuse: infuse)
        if !didLoadFromPrecook {
            clearAllFilters()
        }
    }
}


/// Models
struct CookingCharts: Codable, Equatable {
    let imageGet: ImageGet?
    let group, title: String
    let mode: Mode
    let image: String?
    let prep: String
    let fahrenheitTemp: Int?
    let genericTemp: GenericTemp?
    let time: Int
    let notes: String?

    enum CodingKeys: String, CodingKey {
        case imageGet = "image get"
        case group, title, mode, image, prep, fahrenheitTemp, genericTemp, time, notes
    }
    
    static func == (lhs: CookingCharts, rhs: CookingCharts) -> Bool {
        if lhs.title == rhs.title && lhs.group == rhs.group && lhs.mode == rhs.mode && lhs.time == rhs.time {
             return true
         } else {
             return false
         }
     }
}

enum GenericTemp: String, Codable {
    case hi = "HI"
    case lo = "LO"
    case med = "MED"
}

enum ImageGet: String, Codable {
    case t = "T"
}

enum Temp: String, Codable {
    case hi = "HI"
    case lo = "LO"
    case med = "MED"
    case null = "null"
}

enum Mode: String, Codable {
    case airCrisp = "air crisp"
    case dehydrate = "dehydrate"
    case grill = "grill"
    case smoke = "smoke"
    case bake = "bake"
    case roast = "roast"
    case invalid = ""
    
    
    init(fromRawValue: String) {
        self = Mode(rawValue: fromRawValue) ?? .invalid
    }
    
    static func getFromCookMode(cookMode: CookMode) -> Mode {
        switch cookMode {
        case .AirCrisp:
            return .airCrisp
        case .Dehydrate:
            return .dehydrate
        case .Grill:
            return .grill
        case .Smoke:
            return .smoke
        default:
            return .invalid
        }
    }
}
enum FoodCategories: String, CaseIterable {
    case poultry = "Poultry"
    case beef = "Beef"
    case pork = "Pork"
    case seafood = "Seafood"
    case breadCheese = "Bread/Cheese"
    case fruit = "Fruit"
    case lambVeal = "Lamb/Veal"
    case vegetable = "Vegetable"
    case other = "Other"

    init(fromRawValue: String) {
        self = FoodCategories(rawValue: fromRawValue) ?? .other
    }
}
