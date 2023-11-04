//
//  LayerObjectAppearance.swift
//  M
//
//  Created by Sean Kelly on 03/11/2023.
//

import SwiftUI

struct LayerObjectAppearance {
    // Global Variables
    var showSaveAlert: Bool
    var showSymbolEffect: Bool
    var showSettingsSheet: Bool
    var gearIsAnimating: Bool
    var currentScale: CGFloat
    var isZoomActive: Bool
    var editModeActive: Bool
    var screenWidth: CGFloat
    var settingsSliderFontSize: CGFloat
    var showAverageColor: Bool
    var easySettingsMode: Bool
    
    /*
    var stretchContent: Bool// = false
    var importedBackground: UIImage?// = nil
    var importedImage1: UIImage?// = nil
    var showImagePickerSheet1: Bool// = false
    var showBgPickerSheet: Bool// = false
    var importedLogo: UIImage?// = nil
    var showLogoPickerSheet: Bool// = false
     */
    
    // Background Variables
    var backgroundOffsetY: CGFloat
    var backgroundColour: Color
    var pixellate: CGFloat = 1
    var blur: CGFloat
    var hue: CGFloat
    var saturation: CGFloat
    var frameWidth: CGFloat
    var frameHeight: CGFloat
    var showBackground: Bool
    
    // Mockup Variables
    var showScreenReflection: Bool
    var selectedScreenReflection: String
    var screenReflectionOptions: [String]
    var colorMultiply: Color
    var offsetX: CGFloat
    var offsetY: CGFloat
    var rotate: CGFloat
    var shadowRadius: CGFloat
    var shadowOffsetX: CGFloat
    var shadowOffsetY: CGFloat
    var showShadow: Bool
    var shadowOpacity: CGFloat
    var scale: CGFloat
    var selectedNotch: String
    var notchOptions: [String]
    var showGroundReflection: Bool
    var reflectionOffset: CGFloat
    var screenshotFitFill: Bool
    
    // Logo Variables
    var showLogo: Bool
    var logoScale: CGFloat
    var logoCornerRadius: CGFloat
    var logoOffsetX: CGFloat
    var logoOffsetY: CGFloat
    var logoRotate: CGFloat
    
    init() {
        self.showSaveAlert = false
        self.showSymbolEffect = false
        self.showSettingsSheet = false
        self.gearIsAnimating = false
        self.currentScale = 1.0
        self.isZoomActive = false
        self.editModeActive = false
        self.screenWidth = UIScreen.main.bounds.width * 0.001525
        self.settingsSliderFontSize = 12.5
        self.showAverageColor = false
        self.easySettingsMode = false
        
        /*
        self.stretchContent = false
        self.importedBackground = nil
        self.importedImage1 = nil
        self.showImagePickerSheet1  = false
        self.showBgPickerSheet  = false
        self.importedLogo = nil
        self.showLogoPickerSheet = false
         */
        
        self.backgroundColour = .clear
        self.backgroundOffsetY = 0
        self.pixellate = 1
        self.blur = 0
        self.hue = 1
        self.saturation = 1
        self.frameWidth = 1020
        self.frameHeight = 1020
        self.showBackground = true
        self.showGroundReflection = false
        self.showScreenReflection = true
        self.selectedScreenReflection = "None"
        self.screenReflectionOptions = ["None", "1", "2", "3", "4", "5"]
        self.colorMultiply = .white
        self.offsetX = 0
        self.offsetY = 0
        self.rotate = 0
        self.shadowRadius = 5
        self.shadowOffsetX = 0
        self.shadowOffsetY = 0
        self.showShadow = false
        self.shadowOpacity = 0.2
        self.scale = 1
        self.selectedNotch = "None"
        self.notchOptions = ["None", "1", "2", "3"]
        self.reflectionOffset = -247
        self.screenshotFitFill = false
        self.showLogo = true
        self.logoScale = 1
        self.logoCornerRadius = 0
        self.logoOffsetX = -360
        self.logoOffsetY = 360
        self.logoRotate = 0
    }
    
    init(
        showSaveAlert: Bool,
        showSymbolEffect: Bool,
        showSettingsSheet: Bool,
        gearIsAnimating: Bool,
        currentScale: CGFloat,
        isZoomActive: Bool,
        editModeActive: Bool,
        screenWidth: CGFloat,
        settingsSliderFontSize: CGFloat,
        showAverageColor: Bool,
        easySettingsMode: Bool,
        
        /*
        stretchContent: Bool,
        importedBackground: UIImage?,
        importedImage1: UIImage?,
        showImagePickerSheet1: Bool,
        showBgPickerSheet: Bool,
        importedLogo: UIImage?,
        showLogoPickerSheet: Bool,
         */
        
        backgroundOffsetY: CGFloat,
        backgroundColour: Color,
        pixellate: CGFloat,
        blur: CGFloat,
        hue: CGFloat,
        saturation: CGFloat,
        frameWidth: CGFloat,
        frameHeight: CGFloat,
        showBackground: Bool,
        showScreenReflection: Bool,
        selectedScreenReflection: String,
        screenReflectionOptions: [String],
        colorMultiply: Color,
        offsetX: CGFloat,
        offsetY: CGFloat,
        rotate: CGFloat,
        shadowRadius: CGFloat,
        shadowOffsetX: CGFloat,
        shadowOffsetY: CGFloat,
        showShadow: Bool,
        shadowOpacity: CGFloat,
        scale: CGFloat,
        selectedNotch: String,
        notchOptions: [String], // Include notch options here
        showGroundReflection: Bool,
        reflectionOffset: CGFloat,
        screenshotFitFill: Bool,
        landscapeOrientation: Bool,
        showLogo: Bool,
        logoScale: CGFloat,
        logoCornerRadius: CGFloat,
        logoOffsetX: CGFloat,
        logoOffsetY: CGFloat,
        logoRotate: CGFloat
    ) {
        self.showSaveAlert = showSaveAlert
        self.showSymbolEffect = showSymbolEffect
        self.showSettingsSheet = showSettingsSheet
        self.gearIsAnimating = gearIsAnimating
        self.currentScale = currentScale
        self.isZoomActive = isZoomActive
        self.editModeActive = editModeActive
        self.screenWidth = screenWidth
        self.settingsSliderFontSize = settingsSliderFontSize
        self.showAverageColor = showAverageColor
        self.easySettingsMode = easySettingsMode
        
        /*
        self.stretchContent = stretchContent
        self.importedBackground = importedBackground
        self.importedImage1 = importedImage1
        self.showImagePickerSheet1 = showImagePickerSheet1
        self.showBgPickerSheet = showBgPickerSheet
        self.importedLogo = importedLogo
        self.showLogoPickerSheet = showLogoPickerSheet
         */
        
        self.backgroundOffsetY = backgroundOffsetY
        self.backgroundColour = backgroundColour
        self.pixellate = pixellate
        self.blur = blur
        self.hue = hue
        self.saturation = saturation
        self.frameWidth = frameWidth
        self.frameHeight = frameHeight
        self.showBackground = showBackground
        self.showScreenReflection = showScreenReflection
        self.selectedScreenReflection = selectedScreenReflection
        self.screenReflectionOptions = screenReflectionOptions
        self.colorMultiply = colorMultiply
        self.offsetX = offsetX
        self.offsetY = offsetY
        self.rotate = rotate
        self.shadowRadius = shadowRadius
        self.shadowOffsetX = shadowOffsetX
        self.shadowOffsetY = shadowOffsetY
        self.showShadow = showShadow
        self.shadowOpacity = shadowOpacity
        self.scale = scale
        self.selectedNotch = selectedNotch
        self.notchOptions = notchOptions
        self.showGroundReflection = showGroundReflection
        self.reflectionOffset = reflectionOffset
        self.screenshotFitFill = screenshotFitFill
        self.showLogo = showLogo
        self.logoScale = logoScale
        self.logoCornerRadius = logoCornerRadius
        self.logoOffsetX = logoOffsetX
        self.logoOffsetY = logoOffsetY
        self.logoRotate = logoRotate
        
    }
}



