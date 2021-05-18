//
//  Global Constants.swift
//  Mind Master
//
//  Created by Jia Rui Shan on 2019/11/8.
//  Copyright © 2019 Calpha Dev. All rights reserved.
//

import UIKit
import BonMot
import Down

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
    
    /// Color dodge track color.
    static var trackColor = UIColor(named: "AppColors.track")!
    
    /// The disabled theme color.
    static var mainDisabled = UIColor(named: "AppColors.mainDisabled")!
    
    /// A lighter version of the main tint.
    static var mainLight = UIColor(named: "AppColors.mainLight")!
    
    /// The darker theme color.
    static var mainDark = UIColor(named: "AppColors.mainDark")!
        
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
    
    /// Wrong answer.
    static var fatal = UIColor(named: "AppColors.fatal")!
    
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
    
    /// Hyperlink color.
    static var link = UIColor(named: "AppColors.link")!
    
    /// Spatial memory theme color.
    static var spatial = UIColor(named: "AppColors.spatial")!
    
    /// Spatial memory theme color for selection.
    static var spatialLight = UIColor(named: "AppColors.spatialLight")!
    
    /// Connect-the-dots line color.
    static var connection = UIColor(named: "AppColors.connection")!
    
    /// Color for incorrect answers.
    static var incorrect = UIColor(named: "AppColors.incorrect")!
    
    /// Color for incorrect answers.
    static var correct = UIColor(named: "AppColors.correct")!
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
        .lineHeightMultiple(1.15),
        .lineBreakMode(.byTruncatingTail)
    )
}

extension CGPoint {
    func distance(to other: CGPoint) -> CGFloat {
        return sqrt((x - other.x) * (x - other.x) + (y - other.y) * (y - other.y))
    }
}

enum RecallType: Int {
    case digits = 0, letters, alphaNumerical, colors, monochrome, size
}

let DISABLED_ALPHA: CGFloat = 0.5


/// Style for Markdown.
let PLAIN_STYLE =  """
    body {
        font-family: -apple-system;
        font-size: 17px;
        line-height: 1.5;
        letter-spacing: 1.5%;
        color: #525252;
        margin-bottom: 12px;
    }

    li {
        margin-bottom: 8px;
    }

    strong, em {
        color: #494949;
    }

    a {
        text-decoration: none;
    }


    h1, h2, h3, h4, h5, h6 {
        font-family: -apple-system;
        font-weight: 600;
        letter-spacing: 1.5%;
        color: rgb(70, 70, 70);
        line-height: 1.4;
    }

    h1 {
        font-size: 23px;
        margin-bottom: 14px;
    }

    h2 {
        font-size: 22px;
        margin-bottom: 13.5px;
    }

    h3 {
        font-size: 21px;
        margin-bottom: 13px;
    }

    h4 {
        font-size: 20px;
        margin-bottom: 12.5px;
    }

    h5 {
        font-size: 19px;
        margin-bottom: 12px;
    }
    h6 {
        margin-bottom: 11px;
        font-size: 18px;
    }

    a {
        color: rgb(104, 165, 245);
    }
"""

let PLAIN_DARK = PLAIN_STYLE.replacingOccurrences(of: "#525252", with: "#C9C9C9").replacingOccurrences(of: "#494949", with: "#D7D7D7")

fileprivate let standardAttributes: [NSAttributedString.Key : Any] = {
    let pStyle = NSMutableParagraphStyle()
    pStyle.lineSpacing = 5.0
    pStyle.paragraphSpacing = 12.0
    
    return [
        NSAttributedString.Key.paragraphStyle: pStyle,
        NSAttributedString.Key.foregroundColor: UIColor.darkGray,
        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.5),
        NSAttributedString.Key.kern: 0.2
    ]
}()

extension String {
    /// Email verification method.
    func isValidEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }
    
    /// Markdown-formatted text.
    func attributedText(style: String = PLAIN_STYLE) -> NSAttributedString {
        if isEmpty { return NSAttributedString() }
        if let d = try? Down(markdownString: self).toAttributedString(.default, stylesheet: style) {
            if d.string.isEmpty {
                return NSAttributedString(string: self, attributes: standardAttributes)
            }
            return d.attributedSubstring(from: NSMakeRange(0, d.length - 1))
        } else {
            print("WARNING: markdown failed")
            return NSAttributedString(string: self, attributes: standardAttributes)
        }
    }
}

extension NSLayoutConstraint {
    
    /// Modify the priority of the constraint and return itself.
    func withPriority(_ priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
}
