//
//  LayerObjectAppearance.swift
//  M
//
//  Created by Sean Kelly on 03/11/2023.
//


import SwiftUI

struct LayerObjectAppearance {
    
    // App Variables
    var showSaveAlert: Bool
    var showSymbolEffect: Bool
    var showSettingsSheet: Bool
    var gearIsAnimating: Bool
    var currentScale: CGFloat
    var isZoomActive: Bool
    var editModeActive: Bool
    var screenWidth: CGFloat
    var settingsSliderFontSize: CGFloat
    var easySettingsMode: Bool
    var showPill: Bool
    var showAppSettings: Bool
    @AppStorage("enableImportTapGestures") var enableImportTapGestures: Bool = false
    var selectedAppearance: AppearanceMode
    var showWallpapersView: Bool
    var imageFormatPNG: Bool
    var showWallpaperButton: Bool
    var showApplicationSettings: Bool
    @AppStorage("showTwoWallpapers") var showTwoWallpapers: Bool = false
    var showPremiumWallpapersOnly: Bool
    var showWidgetsOnly: Bool
    let avatarNames: [String]
    @AppStorage("showAIPromptText") var showAIPromptText: Bool = false
    @AppStorage("showCoverFlow") var showCoverFlow: Bool = false
    @AppStorage("showFullResPreview") var showFullResPreview: Bool = false
    
    enum AppearanceMode {
        case light
        case dark
        case system
    }
    
    var showGradientCreatorView: Bool
    
    // Background Variables
    var backgroundOffsetY: CGFloat
    var backgroundColour: Color
    var blur: CGFloat
    var hue: CGFloat
    var saturation: CGFloat
    var frameWidth: CGFloat
    var frameHeight: CGFloat
    var showBackground: Bool
    var backgroundColourOrGradient: Bool
    var showGrid: Bool
    
    // Mockup Variables
    var showScreenReflection: Bool
    var selectedScreenReflection: String
    var screenReflectionOptions: [String]
    var screenReflectionOpacity: CGFloat
    var colorMultiply: Color
    var offsetX: CGFloat
    var offsetY: CGFloat
    var rotate: CGFloat
    var shadowRadius: CGFloat
    var shadowOffsetX: CGFloat
    var shadowOffsetY: CGFloat
    var showShadow: Bool
    var shadowColor: Color
    var shadowOpacity: CGFloat
    var scale: CGFloat
    var selectedNotch: String
    var notchOptions: [String]
    var showGroundReflection: Bool
    var groundReflectionOffset: CGFloat
    var reflectionOffset: CGFloat
    var screenshotFitFill: Bool
    
    
    // Logo Variables
    var showLogo: Bool
    var logoScale: CGFloat
    var logoCornerRadius: CGFloat
    var logoOffsetX: CGFloat
    var logoOffsetY: CGFloat
    var logoRotate: CGFloat
    
    // Wallpaper Variables
    var wallHue: CGFloat
    var wallSaturation: CGFloat
    var wallBrightness: CGFloat
    var wallContrast: CGFloat
    
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
        self.easySettingsMode = false
        self.showPill = true
        self.showAppSettings = false
        self.enableImportTapGestures = false
        self.selectedAppearance = .system
        self.showWallpapersView = false 
        self.imageFormatPNG = false
        self.showWallpaperButton = false
        self.showApplicationSettings = false
        self.showTwoWallpapers = true
        self.showPremiumWallpapersOnly = false
        self.showWidgetsOnly = false
        self.showGrid = false
        self.avatarNames = ["SeanKly", "timetravelr2025", "ElijahCreative", "patricialeveq", "widgy"]
        self.showGradientCreatorView = false
        
        self.backgroundColour = .clear
        self.backgroundOffsetY = 0
        self.blur = 0
        self.hue = 1
        self.saturation = 1
        self.frameWidth = 1020
        self.frameHeight = 1020
        self.showBackground = true
        self.backgroundColourOrGradient = false
        
        self.showGroundReflection = false
        self.groundReflectionOffset = 0.0
        self.showScreenReflection = true
        self.selectedScreenReflection = "None"
        self.screenReflectionOptions = ["None", "1", "2", "3", "4", "5", "6"]
        self.screenReflectionOpacity = 0.5
        self.colorMultiply = .white
        self.offsetX = 0
        self.offsetY = 0
        self.rotate = 0
        self.shadowRadius = 0
        self.shadowOffsetX = 0
        self.shadowOffsetY = 0
        self.showShadow = false
        self.shadowColor = .black
        self.shadowOpacity = 0
        self.scale = 1
        self.selectedNotch = "None"
        self.notchOptions = ["None", "1", "2", "3"]
        self.reflectionOffset = -247
        self.screenshotFitFill = false
        
        self.showLogo = false
        self.logoScale = 1
        self.logoCornerRadius = 0
        self.logoOffsetX = -360
        self.logoOffsetY = 360
        self.logoRotate = 0
        
        self.wallHue = 0
        self.wallSaturation = 1
        self.wallBrightness = 0
        self.wallContrast = 1
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
        showPill: Bool,
        showAppSettings: Bool,
        enableImportTapGestures: Bool,
        selectedAppearance: AppearanceMode,
        showWallpapersView: Bool,
        imageFormatPNG: Bool,
        showWallpaperButton: Bool,
        showApplicationSettings: Bool,
        showTwoWallpapers: Bool,
        showPremiumWallpapersOnly: Bool,
        showWidgetsOnly: Bool,
        showGrid: Bool,
        avatarNames: [String],
        //        showAIPromptText: Bool,
        //        showCoverFlow: Bool,
        //        showFullResPreview: Bool,
        showGradientCreatorView: Bool,
        backgroundOffsetY: CGFloat,
        backgroundColour: Color,
        pixellate: CGFloat,
        blur: CGFloat,
        hue: CGFloat,
        saturation: CGFloat,
        frameWidth: CGFloat,
        frameHeight: CGFloat,
        showBackground: Bool,
        backgroundColourOrGradient: Bool,
        
        showScreenReflection: Bool,
        selectedScreenReflection: String,
        screenReflectionOptions: [String],
        screenReflectionOpacity: CGFloat,
        screenReflectionFlipHorizontal:Bool,
        colorMultiply: Color,
        offsetX: CGFloat,
        offsetY: CGFloat,
        rotate: CGFloat,
        shadowRadius: CGFloat,
        shadowOffsetX: CGFloat,
        shadowOffsetY: CGFloat,
        showShadow: Bool,
        shadowColor: Color,
        shadowOpacity: CGFloat,
        scale: CGFloat,
        selectedNotch: String,
        notchOptions: [String], // Include notch options here
        showGroundReflection: Bool,
        groundReflectionOffset: CGFloat,
        reflectionOffset: CGFloat,
        screenshotFitFill: Bool,
        landscapeOrientation: Bool,
        showLogo: Bool,
        logoScale: CGFloat,
        logoCornerRadius: CGFloat,
        logoOffsetX: CGFloat,
        logoOffsetY: CGFloat,
        logoRotate: CGFloat,
        
        wallHue: CGFloat,
        wallSaturation: CGFloat,
        wallBrightness: CGFloat,
        wallContrast: CGFloat
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
        self.easySettingsMode = easySettingsMode
        self.showPill = showPill
        self.showAppSettings = showAppSettings
        self.enableImportTapGestures = enableImportTapGestures
        self.selectedAppearance = selectedAppearance
        self.showWallpapersView = showWallpapersView
        self.imageFormatPNG = imageFormatPNG
        self.showWallpaperButton = showWallpaperButton
        self.showApplicationSettings = showApplicationSettings
        self.showTwoWallpapers = showTwoWallpapers
        self.showPremiumWallpapersOnly = showPremiumWallpapersOnly
        self.showWidgetsOnly = showWidgetsOnly
        self.backgroundOffsetY = backgroundOffsetY
        self.backgroundColour = backgroundColour
        self.blur = blur
        self.hue = hue
        self.saturation = saturation
        self.frameWidth = frameWidth
        self.frameHeight = frameHeight
        self.showBackground = showBackground
        self.backgroundColourOrGradient = backgroundColourOrGradient
        self.showGrid = showGrid
        self.avatarNames = avatarNames
        //        self.showAIPromptText = showAIPromptText
        //        self.showCoverFlow = showCoverFlow
        //        self.showFullResPreview = showFullResPreview
        self.showGradientCreatorView = showGradientCreatorView
        
        self.showScreenReflection = showScreenReflection
        self.selectedScreenReflection = selectedScreenReflection
        self.screenReflectionOptions = screenReflectionOptions
        self.screenReflectionOpacity = screenReflectionOpacity
        self.colorMultiply = colorMultiply
        self.offsetX = offsetX
        self.offsetY = offsetY
        self.rotate = rotate
        self.shadowRadius = shadowRadius
        self.shadowOffsetX = shadowOffsetX
        self.shadowOffsetY = shadowOffsetY
        self.showShadow = showShadow
        self.shadowColor = shadowColor
        self.shadowOpacity = shadowOpacity
        self.scale = scale
        self.selectedNotch = selectedNotch
        self.notchOptions = notchOptions
        self.showGroundReflection = showGroundReflection
        self.groundReflectionOffset = groundReflectionOffset
        self.reflectionOffset = reflectionOffset
        self.screenshotFitFill = screenshotFitFill
        self.showLogo = showLogo
        self.logoScale = logoScale
        self.logoCornerRadius = logoCornerRadius
        self.logoOffsetX = logoOffsetX
        self.logoOffsetY = logoOffsetY
        self.logoRotate = logoRotate
        
        self.wallHue = wallHue
        self.wallSaturation = wallSaturation
        self.wallBrightness = wallBrightness
        self.wallContrast = wallContrast
        
    }
}
