//
//  Global Constants.swift
//  Mind Master
//
//  Created by Jia Rui Shan on 2019/11/8.
//  Copyright © 2019 Calpha Dev. All rights reserved.
//

import UIKit
import BonMot

let SAVE_PATH = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("save")

let AES_KEY = "MINDMASTER"

struct AppColors {
    
    /// The color used for reaction colors.
    static var reaction = UIColor(named: "AppColors.reaction")!
    
    /// The color used for the disabled reaction color.
    static var reactionLight = UIColor(named: "AppColors.reactionLight")!
    
    /// The color used for the dark reaction color.
    static var reactionDark = UIColor(named: "AppColors.reactionDark")!
    
    /// The memory theme color.
    static var memory = UIColor(named: "AppColors.memory")!
    
    /// The disabled theme color.
    static var mainDisabled = UIColor(named: "AppColors.mainDisabled")!
    
    /// A lighter version of the main tint.
    static var mainLight = UIColor(named: "AppColors.mainLight")!
    
    /// The darker theme color.
    static var mainDark = UIColor(named: "AppColors.mainDark")!
    
    /// A red color used for fatal errors.
    static var fatal = UIColor(red: 230/255, green: 33/255, blue: 15/255, alpha: 1)
    
    /// A orange-yellow color used for warnings.
    static var warning = UIColor(red: 243/255, green: 213/255, blue: 34/255, alpha: 1)
    
    /// A light green color to indicate a passed state.
    static var passed = UIColor(named: "AppColors.passed")!
        
    /// The yellow color for the interest button.
    static var interest = UIColor(red: 254/255, green: 206/255, blue: 56/255, alpha: 1)
        
    /// Placeholder text color.
    static var placeholder = UIColor(named: "AppColors.placeholder")!
    
    /// A light gray color used for border lines.
    static var line = UIColor(named: "AppColors.line")!
    
    /// A dark gray color intended for title labels.
    static var label = UIColor(named: "AppColors.label")!
    
    /// A dark gray color (1/4 darkness) intended to display values.
    static var value = UIColor(named: "AppColors.value")!
    
    /// A medium gray color intended for secondary / supplementary text labels.
    static var prompt = UIColor(named: "AppColors.prompt")!
    
    /// The background color that should be used for most view controllers.
    static var background = UIColor(named: "AppColors.background")!
    
    /// The background color for subviews.
    static var subview = UIColor(named: "AppColors.subview")!
    
    /// The background color for a selected subview.
    static var selected = UIColor(named: "AppColors.selected")!
    
    /// The background color for event previews.
    static var card = UIColor(named: "AppColors.card")!
    
    /// The background color for navigation bars.
    static var navbar = UIColor(named: "AppColors.navbar")!
    
    /// Dark background for scrollviews. In light mode, this is a very light gray.
    static var canvas = UIColor(named: "AppColors.canvas")!
    
    /// Background color for the tabs.
    static var tab = UIColor(named: "AppColors.tab")!
    
    /// Background color for grouped table views.
    static var tableBG = UIColor(named: "AppColors.tableBG")!
    
    /// Plain text color, intended for event and organization descriptions.
    static var plainText = UIColor(named: "AppColors.plainText")!

    /// Bold text color.
    static var boldText = UIColor(named: "AppColors.bold")!
    
    /// Button colors.
    static var control = UIColor(named: "AppColors.control")!
    
    /// A light gray tint used for disabled controls.
    static var disabled = UIColor(named: "AppColors.disabled")!
    
    /// Message header background color.
    static var messageHeader = UIColor(named: "AppColors.messageHeader")!
    
    /// The label color for a dark background.
    static var invertedLabel = UIColor(named: "AppColors.invertedLabel")!
    
    /// Color when the tap area is off for the reaction time challenge.
    static var tapOff = UIColor(named: "AppColors.reaction.off")!
    
    /// Emphasis color for values within messages.
    static var emphasis = UIColor(named: "AppColors.emphasis")!
    
    /// Spinner tint color.
    static var lightControl = UIColor(named: "AppColors.lightControl")!
    
    /// A light gray tint color.
    static var lightGray = UIColor(named: "AppColors.views")!
}


extension UIView {
    func applyMildShadow() {
        self.layer.shadowOpacity = 0.05
        self.layer.shadowOffset.height = 0.5
    }
}

extension StringStyle {
    static let textStyle = StringStyle(
        .font(UIFont.systemFont(ofSize: 16.5)),
        .color(AppColors.label),
        .lineHeightMultiple(1.2),
        .lineBreakMode(.byTruncatingTail)
    )
}

let DISABLED_ALPHA: CGFloat = 0.5
