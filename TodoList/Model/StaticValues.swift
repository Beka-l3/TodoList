//
//  StaticValues.swift
//  TodoList
//
//  Created by Bekzhan Talgat on 01.10.2022.
//

import Foundation
import UIKit


protocol ThemeColors {
    var backIosPrimary: UIColor {get}
    var backPrimary: UIColor {get}
    var backSecondary: UIColor {get}
    var backElevated: UIColor {get}
    
    var supportSeparator: UIColor {get}
    var supportOverlay: UIColor {get}
    var supportNavBarBlur: UIColor {get}
    
    var red: UIColor {get}
    var green: UIColor {get}
    var blue: UIColor {get}
    var gray: UIColor {get}
    var grayLight: UIColor {get}
    var white: UIColor {get}
    
    var labelPrimary: UIColor {get}
    var labelSecondary: UIColor {get}
    var labelTertiary: UIColor {get}
    var labelDisable: UIColor {get}
}

extension ThemeColors {
    var backIosPrimary: UIColor { UIColor(red: 0, green: 0, blue: 0, alpha: 1) }
    var backPrimary: UIColor { UIColor(red: 0.09, green: 0.09, blue: 0.09, alpha: 1) }
    var backSecondary: UIColor { UIColor(red: 0.14, green: 0.14, blue: 0.16, alpha: 1) }
    var backElevated: UIColor { UIColor(red: 0.23, green: 0.23, blue: 0.25, alpha: 1) }
    
    var supportSeparator: UIColor { UIColor(red: 1, green: 1, blue: 1, alpha: 0.2) }
    var supportOverlay: UIColor { UIColor(red: 0, green: 0, blue: 0, alpha: 0.32) }
    var supportNavBarBlur: UIColor { UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.9) }
    
    var red: UIColor { UIColor(red: 1, green: 0.27, blue: 0.23, alpha: 1) }
    var green: UIColor { UIColor(red: 0.2, green: 0.84, blue: 0.29, alpha: 1) }
    var blue: UIColor { UIColor(red: 0.04, green: 0.52, blue: 1, alpha: 1) }
    var gray: UIColor { UIColor(red: 0.56, green: 0.56, blue: 0.58, alpha: 1) }
    var grayLight: UIColor { UIColor(red: 0.28, green: 0.28, blue: 0.29, alpha: 1) }
    var white: UIColor { UIColor(red: 1, green: 1, blue: 1, alpha: 1) }
    
    var labelPrimary: UIColor { UIColor(red: 1, green: 1, blue: 1, alpha: 1) }
    var labelSecondary: UIColor { UIColor(red: 1, green: 1, blue: 1, alpha: 0.6) }
    var labelTertiary: UIColor { UIColor(red: 1, green: 1, blue: 1, alpha: 0.4) }
    var labelDisable: UIColor { UIColor(red: 1, green: 1, blue: 1, alpha: 0.15) }
}

struct WhiteTheme: ThemeColors {
    var backIosPrimary = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1)
    var backPrimary = UIColor(red: 0.97, green: 0.97, blue: 0.95, alpha: 1)
    var backSecondary = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    var backElevated = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    
    var supportSeparator = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
    var supportOverlay = UIColor(red: 0, green: 0, blue: 0, alpha: 0.06)
    var supportNavBarBlur = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 0.8)
    
    var red = UIColor(red: 1, green: 0.27, blue: 0.23, alpha: 1)
    var green = UIColor(red: 0.2, green: 0.84, blue: 0.29, alpha: 1)
    var blue = UIColor(red: 0.04, green: 0.52, blue: 1, alpha: 1)
    var gray = UIColor(red: 0.56, green: 0.56, blue: 0.58, alpha: 1)
    var grayLight = UIColor(red: 0.28, green: 0.28, blue: 0.29, alpha: 1)
    var white = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    
    var labelPrimary = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    var labelSecondary = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
    var labelTertiary = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
    var labelDisable = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15)
}


protocol Fonts {
    var largeTitle: UIFont {get}
    var title: UIFont {get}
    var headline: UIFont {get}
    var body: UIFont {get}
    var bodyBold: UIFont {get}
    var subhead: UIFont {get}
    var subheadBold: UIFont {get}
    var footnote: UIFont {get}
}

extension Fonts {
    var largeTitle: UIFont { UIFont.boldSystemFont(ofSize: 38) }
    var title: UIFont { UIFont.boldSystemFont(ofSize: 20) }
    var headline: UIFont { UIFont.boldSystemFont(ofSize: 17) }
    var body: UIFont { UIFont.systemFont(ofSize: 17) }
    var bodyBold: UIFont { UIFont.boldSystemFont(ofSize: 17) }
    var subhead: UIFont { UIFont.systemFont(ofSize: 15) }
    var subheadBold: UIFont { UIFont.boldSystemFont(ofSize: 15) }
    var footnote: UIFont { UIFont.boldSystemFont(ofSize: 13) }
}

struct FontSizeLarge: Fonts {
    var largeTitle = UIFont.boldSystemFont(ofSize: 46)
    var title = UIFont.boldSystemFont(ofSize: 24)
    var headline = UIFont.boldSystemFont(ofSize: 22)
    var body = UIFont.systemFont(ofSize: 22)
    var subhead = UIFont.systemFont(ofSize: 20)
    var subheadBold = UIFont.boldSystemFont(ofSize: 20)
    var footnote = UIFont.boldSystemFont(ofSize: 18)
}
