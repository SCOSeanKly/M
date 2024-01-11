//
//  ContentViewModel.swift
//  M
//
//  Created by Sean Kelly on 03/11/2023.
//

import SwiftUI

class ContentViewModel: ObservableObject {
    @Published var items: [Item] = [
        
      
        
        
        //MARK: Mockup 1
        .init(imageName: "iP15PM_Front",
              screenReflectionName: "iP15PM_Front_screen",
              shadowName: "",
              color: .red,
              alertTextColor: .white,
              title: "Single Front View",
              subTitle: "Forward-facing upright perspective of the iPhone 15 Pro Max in natural titanium",
              
              // MARK: 1st mockup image
              degrees: 0,
              degrees2: 0,
              x: 0,
              y: 0,
              z: 0,
              anchor: .bottomLeading,
              perspective: 1.2,
              perspective2: 0,
              x2: 0,
              y2: 0,
              z2: 0,
              anchor2: .bottomLeading,
              scale: 1,
              offX: 0.5,
              offY: 0,
              rotationEffect: 0,
              width: 173.0 * 2,
              height: 373.4 * 2,
              cornerRadius: 40,
              notch: "notch_set1_",
              reflectionOffset: -247,
              
              // MARK: 2nd mockup image
              degrees_b: 0,
              degrees2_b: 0,
              x_b: 0,
              y_b: 0,
              z_b: 0,
              anchor_b: .bottomLeading,
              perspective_b: 1,
              perspective2_b: 0,
              x2_b: 0,
              y2_b: 0,
              z2_b: 0,
              offX_b: 10000,
              offY_b: 0,
              anchor2_b: .bottomLeading,
              scale_b: 1,
              rotationEffect_b: 0,
              width_b: 173,
              height_b: 373,
              cornerRadius_b: 40),
        
        //MARK: Mockup 2
        .init(imageName: "iP15CryptoMatte",
              screenReflectionName: "iP15_3DLeft_screen",
              shadowName: "",
              color: .white,
              alertTextColor: .black,
              title: "Front & Back CryptoMatte",
              subTitle: "iPhone 15 in Crypto Matte",
              
              // MARK: 1st mockup image
              degrees: -37.1,
              degrees2: 0,
              x: 1,
              y: 1.0,
              z: 0,
              anchor: .leading,
              perspective: -0.09,
              perspective2: 0.0,
              x2: 0,
              y2: 0,
              z2: 0,
              anchor2: .bottomLeading,
              scale: 1.0,
              offX: 132.0,
              offY: 49.0,
              rotationEffect: -5.45,
              width: 155.0 * 2,
              height: 406.0 * 2,
              cornerRadius: 43,
              notch: "",
              reflectionOffset: 10000,
              
              // MARK: 2nd mockup image
              degrees_b: 0,
              degrees2_b: 0,
              x_b: 0,
              y_b: 0,
              z_b: 0,
              anchor_b: .bottomLeading,
              perspective_b: 1,
              perspective2_b: 0,
              x2_b: 0,
              y2_b: 0,
              z2_b: 0,
              offX_b: 10000,
              offY_b: 0,
              anchor2_b: .bottomLeading,
              scale_b: 1,
              rotationEffect_b: 0,
              width_b: 173,
              height_b: 373,
              cornerRadius_b: 40),
        
        //MARK: Mockup 2
        .init(imageName: "iP15_3DLeft",
              screenReflectionName: "iP15_3DLeft_screen",
              shadowName: "",
              color: .gray,
              alertTextColor: .white,
              title: "Front & Back 3D Left",
              subTitle: "iPhone 15 front and back 3D view",
              
              // MARK: 1st mockup image
              degrees: -37.1,
              degrees2: 0,
              x: 1,
              y: 1.0,
              z: 0,
              anchor: .leading,
              perspective: -0.09,
              perspective2: 0.0,
              x2: 0,
              y2: 0,
              z2: 0,
              anchor2: .bottomLeading,
              scale: 1.0,
              offX: 131.5,
              offY: 51.0,
              rotationEffect: -5.70,
              width: 155.9 * 2,
              height: 406.0 * 2,
              cornerRadius: 43,
              notch: "",
              reflectionOffset: 10000,
              
              // MARK: 2nd mockup image
              degrees_b: 0,
              degrees2_b: 0,
              x_b: 0,
              y_b: 0,
              z_b: 0,
              anchor_b: .bottomLeading,
              perspective_b: 1,
              perspective2_b: 0,
              x2_b: 0,
              y2_b: 0,
              z2_b: 0,
              offX_b: 10000,
              offY_b: 0,
              anchor2_b: .bottomLeading,
              scale_b: 1,
              rotationEffect_b: 0,
              width_b: 173,
              height_b: 373,
              cornerRadius_b: 40),
        //MARK: Dual iP15 PM
        .init(imageName: "Dual_iP15PM_Front",
              screenReflectionName: "Dual_iP15PM_Front_screen",
              shadowName: "",
              color: .black,
              alertTextColor: .white,
              title: "Dual Front View",
              subTitle: "Dual forward-facing upright perspective of the iPhone 15 Pro Max in natural titanium",
              
              // MARK: 1st mockup image
              degrees: 0,
              degrees2: 0,
              x: 0,
              y: 0,
              z: 0,
              anchor: .bottomLeading,
              perspective: 1.2,
              perspective2: 0,
              x2: 0,
              y2: 0,
              z2: 0,
              anchor2: .bottomLeading,
              scale: 1,
              offX: -214,
              offY: 0,
              rotationEffect: 0,
              width: 173.0 * 2,
              height: 373.4 * 2,
              cornerRadius: 40,
              notch: "notch_set6_",
              reflectionOffset: -247,
              
              // MARK: 2nd mockup image
              degrees_b: 0,
              degrees2_b: 0,
              x_b: 0,
              y_b: 0,
              z_b: 0,
              anchor_b: .bottomLeading,
              perspective_b: 1,
              perspective2_b: 0,
              x2_b: 0,
              y2_b: 0,
              z2_b: 0,
              offX_b: 203,
              offY_b: 0,
              anchor2_b: .bottomLeading,
              scale_b: 1,
              rotationEffect_b: 0,
              width_b: 173,
              height_b: 373,
              cornerRadius_b: 40),
        //MARK: Mockup 2
        .init(imageName: "iP15PM_3DLeft_Upright",
              screenReflectionName: "iP15PM_3DLeft_Upright_screen",
              shadowName: "",
              color: .teal,
              alertTextColor: .white,
              title: "3D Lateral View",
              subTitle: "Three-dimensional side view of the iPhone 15 Pro Max in natural titanium",
              
              // MARK: 1st mockup image
              degrees: -43.0,
              degrees2: 0,
              x: 1,
              y: 1.4,
              z: 0,
              anchor: .bottomLeading,
              perspective: -0.15,
              perspective2: 0.0,
              x2: 0,
              y2: 0,
              z2: 0,
              anchor2: .bottomLeading,
              scale: 1.0,
              offX: 50.9 * 2,
              offY: -38.5 * 2,
              rotationEffect: -5.25,
              width: 172.4 * 2,
              height: 430.0 * 2,
              cornerRadius: 42,
              notch: "notch_set2_",
              reflectionOffset: -220,
              
              // MARK: 2nd mockup image
              degrees_b: 0,
              degrees2_b: 0,
              x_b: 0,
              y_b: 0,
              z_b: 0,
              anchor_b: .bottomLeading,
              perspective_b: 1,
              perspective2_b: 0,
              x2_b: 0,
              y2_b: 0,
              z2_b: 0,
              offX_b: 10000,
              offY_b: 0,
              anchor2_b: .bottomLeading,
              scale_b: 1,
              rotationEffect_b: 0,
              width_b: 173,
              height_b: 373,
              cornerRadius_b: 40),
        //MARK: Dual 3D iP15 PM
        .init(imageName: "iP15PM_Twin3D",
              screenReflectionName: "Dual_iP15PM_3DLeft_screen",
              shadowName: "",
              color: .indigo,
              alertTextColor: .white,
              title: "Dual 3D Lateral View",
              subTitle: "Dual three-dimensional side view of the iPhone 15 Pro Max in natural titanium",
              
              // MARK: 1st mockup image
              degrees: -43.0,
              degrees2: 0,
              x: 1,
              y: 1.4,
              z: 0,
              anchor: .bottomLeading,
              perspective: -0.15,
              perspective2: 0.0,
              x2: 0,
              y2: 0,
              z2: 0,
              anchor2: .bottomLeading,
              scale: 1.0,
              offX: -87.5,
              offY: -37,
              rotationEffect: -5.15,
              width: 172.4 * 2,
              height: 430.0 * 2,
              cornerRadius: 42,
              notch: "notch_set7_",
              reflectionOffset: 10000,
              
              // MARK: 2nd mockup image
              degrees_b: -43,
              degrees2_b: 0,
              x_b: -1,
              y_b: 1.4,
              z_b: 0,
              anchor_b: .bottomTrailing,
              perspective_b: 0.15,
              perspective2_b: 0,
              x2_b: 0,
              y2_b: 0,
              z2_b: 0,
              offX_b: 75.5,
              offY_b: -176,
              anchor2_b: .bottomTrailing,
              scale_b: 1,
              rotationEffect_b: 5.15,
              width_b: 172.4 * 2,
              height_b: 430.0 * 2,
              cornerRadius_b: 40),
        //MARK: Mockup 3
        .init(imageName: "iP15PM_Front_shadowLeft",
              screenReflectionName: "iP15PM_Front_screen",
              shadowName: "",
              color: .blue,
              alertTextColor: .white,
              title: "Front View + M",
              subTitle: "Forward-facing perspective of the iPhone 15 Pro Max in natural titanium with M case",
              
              // MARK: 1st mockup image
              degrees: 0,
              degrees2: 0,
              x: 0,
              y: 0,
              z: 0,
              anchor: .bottomLeading,
              perspective: 1.2,
              perspective2: 0,
              x2: 0,
              y2: 0,
              z2: 0,
              anchor2: .bottomLeading,
              scale: 1,
              offX: 0.5,
              offY: 0,
              rotationEffect: 0,
              width: 173.0 * 2,
              height: 373.4 * 2,
              cornerRadius: 40,
              notch: "notch_set3_",
              reflectionOffset: 10000,
              
              // MARK: 2nd mockup image
              degrees_b: 0,
              degrees2_b: 0,
              x_b: 0,
              y_b: 0,
              z_b: 0,
              anchor_b: .bottomLeading,
              perspective_b: 1,
              perspective2_b: 0,
              x2_b: 0,
              y2_b: 0,
              z2_b: 0,
              offX_b: 10000,
              offY_b: 0,
              anchor2_b: .bottomLeading,
              scale_b: 1,
              rotationEffect_b: 0,
              width_b: 173,
              height_b: 373,
              cornerRadius_b: 40),
        //MARK: Mockup 4
        .init(imageName: "iP15PM_3DLeft",
              screenReflectionName: "iP15PM_3DLeft_screen",
              shadowName: "",
              color: .yellow,
              alertTextColor: .white,
              title: "3D Left View",
              subTitle: "Horizontal 3D view of the iPhone 15 Pro Max in natural titanium",
              
              // MARK: 1st mockup image
              degrees: -56.5,
              degrees2: 0,
              x: 0.63,
              y: 0.10,
              z: 0.55,
              anchor: .bottomLeading,
              perspective: -0.175,
              perspective2: 1.0,
              x2: 0,
              y2: 0,
              z2: 0,
              anchor2: .bottomLeading,
              scale: 1.26,
              offX: 121.5 * 2,
              offY: -68.45 * 2,
              rotationEffect: -0.64,
              width: 157.9 * 2,
              height: 390.2 * 2,
              cornerRadius: 50,
              notch: "notch_set4_",
              reflectionOffset: 10000,
              
              // MARK: 2nd mockup image
              degrees_b: 0,
              degrees2_b: 0,
              x_b: 0,
              y_b: 0,
              z_b: 0,
              anchor_b: .bottomLeading,
              perspective_b: 1,
              perspective2_b: 0,
              x2_b: 0,
              y2_b: 0,
              z2_b: 0,
              offX_b: 10000,
              offY_b: 0,
              anchor2_b: .bottomLeading,
              scale_b: 1,
              rotationEffect_b: 0,
              width_b: 173,
              height_b: 373,
              cornerRadius_b: 40),
        //MARK: Mockup 5
        .init(imageName: "iP15PM_3DUpright",
              screenReflectionName: "iP15PM_3DUpright_screen",
              shadowName: "",
              color: .green,
              alertTextColor: .white,
              title: "3D Upright View",
              subTitle: "Three-dimensional standing view of the iPhone 15 Pro Max in natural titanium",
              
              // MARK: 1st mockup image
              degrees: 8.0,
              degrees2: -8.0,
              x: 0.0,
              y: 1.0,
              z: 0,
              anchor: .topTrailing,
              perspective: 2.0,
              perspective2: 1.5,
              x2: 0.0,
              y2: 1.0,
              z2: 0,
              anchor2: .leading,
              scale: 1,
              offX: 8.1 * 2,
              offY: -8.54 * 2,
              rotationEffect: 0.22,
              width: 108.85 * 2,
              height: 322.95 * 2,
              cornerRadius: 25,
              notch: "notch_set5_",
              reflectionOffset: 10000,
              
              // MARK: 2nd mockup image
              degrees_b: 0,
              degrees2_b: 0,
              x_b: 0,
              y_b: 0,
              z_b: 0,
              anchor_b: .bottomLeading,
              perspective_b: 1,
              perspective2_b: 0,
              x2_b: 0,
              y2_b: 0,
              z2_b: 0,
              offX_b: 10000,
              offY_b: 0,
              anchor2_b: .bottomLeading,
              scale_b: 1,
              rotationEffect_b: 0,
              width_b: 173,
              height_b: 373,
              cornerRadius_b: 40),
        //MARK: Mockup 6 iPX
        .init(imageName: "iPX_Front",
              screenReflectionName: "iP15PM_Front_screen",
              shadowName: "",
              color: .mint,
              alertTextColor: .white,
              title: "X Front View",
              subTitle: "Forward-facing perspective of the iPhone X in space grey",
              
              // MARK: 1st mockup image
              degrees: 0,
              degrees2: 0,
              x: 0,
              y: 0,
              z: 0,
              anchor: .bottomLeading,
              perspective: 1.2,
              perspective2: 0,
              x2: 0,
              y2: 0,
              z2: 0,
              anchor2: .bottomLeading,
              scale: 1,
              offX: 0.5,
              offY: 0,
              rotationEffect: 0,
              width: 173.0 * 2,
              height: 373.4 * 2,
              cornerRadius: 40,
              notch: "notch_set1_",
              reflectionOffset: -247,
              
              // MARK: 2nd mockup image
              degrees_b: 0,
              degrees2_b: 0,
              x_b: 0,
              y_b: 0,
              z_b: 0,
              anchor_b: .bottomLeading,
              perspective_b: 1,
              perspective2_b: 0,
              x2_b: 0,
              y2_b: 0,
              z2_b: 0,
              offX_b: 10000,
              offY_b: 0,
              anchor2_b: .bottomLeading,
              scale_b: 1,
              rotationEffect_b: 0,
              width_b: 173,
              height_b: 373,
              cornerRadius_b: 40),
        //MARK: Dual iPX
        .init(imageName: "iPX_Front_Dual",
              screenReflectionName: "Dual_iP15PM_Front_screen",
              shadowName: "",
              color: .cyan,
              alertTextColor: .white,
              title: "Dual iPhone X",
              subTitle: "Forward-facing perspective of the X in space grey",
              
              // MARK: 1st mockup image
              degrees: 0,
              degrees2: 0,
              x: 0,
              y: 0,
              z: 0,
              anchor: .bottomLeading,
              perspective: 1.2,
              perspective2: 0,
              x2: 0,
              y2: 0,
              z2: 0,
              anchor2: .bottomLeading,
              scale: 1,
              offX: -214,
              offY: 0,
              rotationEffect: 0,
              width: 173.0 * 2,
              height: 373.4 * 2,
              cornerRadius: 40,
              notch: "notch_set6_",
              reflectionOffset: -247,
              
              // MARK: 2nd mockup image
              degrees_b: 0,
              degrees2_b: 0,
              x_b: 0,
              y_b: 0,
              z_b: 0,
              anchor_b: .bottomLeading,
              perspective_b: 1,
              perspective2_b: 0,
              x2_b: 0,
              y2_b: 0,
              z2_b: 0,
              offX_b: 203,
              offY_b: 0,
              anchor2_b: .bottomLeading,
              scale_b: 1,
              rotationEffect_b: 0,
              width_b: 173,
              height_b: 373,
              cornerRadius_b: 40),
        
        
        //MARK: Mockup 6 - Apple Watch Ultra2
        .init(imageName: "appleWatchUltra2",
              screenReflectionName: "appleWatchUltraScreen",
              shadowName: "",
              color: .gray,
              alertTextColor: .white,
              title: "Watch Ultra",
              subTitle: "Forward-facing perspective of the Apple Watch Ultra with a alpine loop",
              
              // MARK: 1st mockup image
              degrees: 0,
              degrees2: 0,
              x: 0,
              y: 0,
              z: 0,
              anchor: .bottomLeading,
              perspective: 1.2,
              perspective2: 0,
              x2: 0,
              y2: 0,
              z2: 0,
              anchor2: .bottomLeading,
              scale: 1,
              offX: -0.055,
              offY: 6.3,
              rotationEffect: 0,
              width: 174.5 * 2,
              height: 215.1 * 2,
              cornerRadius: 80,
              notch: "",
              reflectionOffset: 10000,
              
              // MARK: 2nd mockup image
              degrees_b: 0,
              degrees2_b: 0,
              x_b: 0,
              y_b: 0,
              z_b: 0,
              anchor_b: .bottomLeading,
              perspective_b: 1,
              perspective2_b: 0,
              x2_b: 0,
              y2_b: 0,
              z2_b: 0,
              offX_b: 10000,
              offY_b: 0,
              anchor2_b: .bottomLeading,
              scale_b: 1,
              rotationEffect_b: 0,
              width_b: 173,
              height_b: 373,
              cornerRadius_b: 40)
        /*
        //MARK: Mockup 6 - Apple Watch Ultra
        .init(imageName: "appleWatchUltra",
              screenReflectionName: "appleWatchUltraScreen",
              shadowName: "",
              color: .brown,
              alertTextColor: .white,
              title: "Watch Ultra",
              subTitle: "Forward-facing perspective of the Apple Watch Ultra with a ocean band",
              
              // MARK: 1st mockup image
              degrees: 0,
              degrees2: 0,
              x: 0,
              y: 0,
              z: 0,
              anchor: .bottomLeading,
              perspective: 1.2,
              perspective2: 0,
              x2: 0,
              y2: 0,
              z2: 0,
              anchor2: .bottomLeading,
              scale: 1,
              offX: -0.055,
              offY: 6.3,
              rotationEffect: 0,
              width: 174.5 * 2,
              height: 215.1 * 2,
              cornerRadius: 80,
              notch: "",
              reflectionOffset: 10000,
              
              // MARK: 2nd mockup image
              degrees_b: 0,
              degrees2_b: 0,
              x_b: 0,
              y_b: 0,
              z_b: 0,
              anchor_b: .bottomLeading,
              perspective_b: 1,
              perspective2_b: 0,
              x2_b: 0,
              y2_b: 0,
              z2_b: 0,
              offX_b: 10000,
              offY_b: 0,
              anchor2_b: .bottomLeading,
              scale_b: 1,
              rotationEffect_b: 0,
              width_b: 173,
              height_b: 373,
              cornerRadius_b: 40)
       
    
        //MARK: Mockup 7 - iPad Pro
        .init(imageName: "iPad",
              screenReflectionName: "iPadScreen",
              shadowName: "",
              color: .purple,
              alertTextColor: .white,
              title: "iPad Pro Front View",
              subTitle: "Forward-facing perspective of the iPad Pro in Silver",
              
              // MARK: 1st mockup image
              degrees: 0,
              degrees2: 0,
              x: 0,
              y: 0,
              z: 0,
              anchor: .bottomLeading,
              perspective: 1.2,
              perspective2: 0,
              x2: 0,
              y2: 0,
              z2: 0,
              anchor2: .bottomLeading,
              scale: 1,
              offX: -0.055,
              offY: -2,
              rotationEffect: 0,
              width: 247.0 * 2,
              height: 353.0 * 2,
              cornerRadius: 10,
              notch: "",
              reflectionOffset: -267,
              
              // MARK: 2nd mockup image
              degrees_b: 0,
              degrees2_b: 0,
              x_b: 0,
              y_b: 0,
              z_b: 0,
              anchor_b: .bottomLeading,
              perspective_b: 1,
              perspective2_b: 0,
              x2_b: 0,
              y2_b: 0,
              z2_b: 0,
              offX_b: 10000,
              offY_b: 0,
              anchor2_b: .bottomLeading,
              scale_b: 1,
              rotationEffect_b: 0,
              width_b: 173,
              height_b: 373,
              cornerRadius_b: 40)
         */
    ]
    
    @Published var importedBackground: UIImage? = nil
    @Published var importedImage1: UIImage? = nil
    @Published var importedImage2: UIImage? = nil
    @Published var showImagePickerSheet1: Bool = false
    @Published var showImagePickerSheet2: Bool = false
    @Published var showBgPickerSheet: Bool = false
    @Published var importedLogo: UIImage? = nil
    @Published var showLogoPickerSheet: Bool = false
    
    @Published var importedOverlay: UIImage? = nil
    @Published var showOverlayPickerSheet: Bool = false
    
}

