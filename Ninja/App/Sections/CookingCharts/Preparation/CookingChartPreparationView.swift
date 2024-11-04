//
//  CookingChartPreparationView.swift
//  Ninja
//
//  Created by Richard Jacobson on 1/30/23.
//

import UIKit

class CookingChartPreparationView: BaseXIBView {
        
    @IBOutlet var pageIndicator: PageIndicator!
    @IBOutlet var mainStack: UIStackView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var startCookingButton: UIButton!
    @IBOutlet weak var titleLabelTopConstraint: NSLayoutConstraint!
    var theme: () -> ColorTheme = { ColorThemeManager.shared.theme }
    
    override func setupViews() {
        super.setupViews()
        pageIndicator.pageTitleLabel.text = "COOKING CHARTS"
        
        mainStack.spacing = 32
        
        startCookingButton.setTitle("Use This Chart".uppercased(), for: .normal)
        
    }
    
    override func refreshStyling() {
        super.refreshStyling()
        titleLabel.setStyle(.cookingChartTitleLabel)
        infoLabel.setStyle(.cookingChartSubitleLabel)
        startCookingButton.setStyle(.primaryButton)
    }
    
    func setupViewsForExplore() {
        pageIndicator.isHidden = true
        titleLabelTopConstraint.constant = 24
    }
    
    func populate(with chartData: CookingCharts) {
        titleLabel.text = chartData.title
        infoLabel.text = "Here are the indications of Ninja culinary team to ensure the success of your cooking session"
        
        let useGenericTemp = chartData.genericTemp != nil

        let prepItem = ItemStack(imageName: IconAssetLibrary.ico_chef_hat.rawValue, stepName: "Preparation".uppercased(), stepDetail: chartData.prep)
        
        let tempItem = ItemStack(imageName: IconAssetLibrary.ico_grill.rawValue, stepName: "Grill Temperature".uppercased(), stepDetail: useGenericTemp ? chartData.genericTemp?.rawValue ?? "" : String(chartData.fahrenheitTemp ?? 0) + "°F")

        let timeItem = ItemStack(imageName: IconAssetLibrary.ico_timer.rawValue, stepName: "Cook Time".uppercased(), stepDetail: chartData.time.convertSecondsToHourMinuteString())
        let noteItem = ItemStack(imageName: IconAssetLibrary.ico_multiple_pages.rawValue, stepName: "Notes".uppercased(), stepDetail: chartData.notes ?? "")
        
        let chartAdjustmentView = ChartAdjustmentView()

        mainStack.addArrangedSubview(prepItem)
        mainStack.addArrangedSubview(tempItem)
        mainStack.addArrangedSubview(timeItem)
        mainStack.addArrangedSubview(noteItem)
        mainStack.addArrangedSubview(chartAdjustmentView)
    }
}

extension CookingChartPreparationView {
    private class ItemStack: BaseView {
        
        @UsesAutoLayout private var icon = UIImageView()
        @UsesAutoLayout private var nameStack = UIStackView()
        @UsesAutoLayout private var itemNameLabel = UILabel()
        @UsesAutoLayout private var itemDetailLabel = UILabel()
        @UsesAutoLayout private var stack = UIStackView()
                
        init(imageName: String, stepName: String, stepDetail: String) {
            super.init(frame: .zero)
            itemNameLabel.text = stepName.uppercased()
            itemDetailLabel.text = stepDetail
            icon.image = UIImage(namedCache: imageName)?.tint(color: ColorThemeManager.shared.theme.primaryAccentColor)
        }
        required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
        
        override func setupViews() {
            icon.contentMode = .scaleAspectFit
            
            nameStack.addArrangedSubview(icon)
            nameStack.addArrangedSubview(itemNameLabel)
            nameStack.addArrangedSubview(UIView())
            nameStack.spacing = 8
            nameStack.alignment = .center
            
            stack.axis = .vertical
            stack.spacing = 12
            stack.addArrangedSubview(nameStack)
            stack.addArrangedSubview(itemDetailLabel)
            
        }
        
        override func setupConstraints() {
            addSubview(stack)
            NSLayoutConstraint.activate(stack.constraintsForAnchoringTo(boundsOf: self))
            NSLayoutConstraint.activate([icon.widthAnchor.constraint(equalToConstant: 24), icon.heightAnchor.constraint(equalToConstant: 24)])
        }
        
        override func refreshStyling() {
            backgroundColor = .clear
            
            icon.tintColor = ColorThemeManager.shared.theme.primaryAccentColor
            itemNameLabel.setStyle(.cookingChartItemTitleLabel)
            itemDetailLabel.setStyle(.cookingChartItemDetailLabel)
        }
    }
    
    class ChartAdjustmentView: BaseView {
        
        @UsesAutoLayout var titleLabel = UILabel()
        @UsesAutoLayout var detailLabel = UILabel()
        
        override func setupViews() {
            super.setupViews()
            layer.cornerRadius = 12
            
            titleLabel.text = "Chart Adjustments"
            detailLabel.text = "Times listed in these charts are based on the quantities defined. Please adjust time based on your own quantity of food."
            detailLabel.numberOfLines = 0
        }
        
        override func setupConstraints() {
            addSubview(titleLabel)
            addSubview(detailLabel)
            
            NSLayoutConstraint.activate([
                
                titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
                
                detailLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
                detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
                detailLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
                detailLabel.heightAnchor.constraint(equalToConstant: 48),
                
                self.heightAnchor.constraint(equalToConstant: 120),
            ])
        }
        
        override func refreshStyling() {
            backgroundColor = ColorThemeManager.shared.theme.tertiaryAccentColor
            titleLabel.setStyle(.callToActionTitle)
            detailLabel.setStyle(.cookPickerDetailLabel)
        }
    }
}
