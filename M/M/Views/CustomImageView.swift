//
//  CustomImageView.swift
//  M
//
//  Created by Sean Kelly on 03/11/2023.
//

import SwiftUI


struct CustomImageView: View {
    var item: Item
    @Binding var importedBackground: UIImage?
    @Binding var importedImage1: UIImage?
    @Binding var importedImage2: UIImage?
    @Binding var importedLogo: UIImage?
    @StateObject var obj: Object
    
    
    var body: some View {
        
        ZStack {
            BackgroundView(obj: obj, importedBackground: $importedBackground, item: item)
               
            MockupLayersView(obj: obj, importedImage1: $importedImage1, importedImage2: $importedImage2, item: item)
            
            LogoView(obj: obj, importedLogo: $importedLogo)
        }
        .frame(width: obj.appearance.frameWidth, height: obj.appearance.frameHeight)
        .overlay{
            GridOverlay()
                .opacity(obj.appearance.showGrid ? 1 : 0)
        }
        .clipped()
    }
}


struct BackgroundView: View {
    @StateObject var obj: Object
    @Binding var importedBackground: UIImage?
    var item: Item
    
    var body: some View {
        if obj.appearance.showBackground {
            if importedBackground == nil {
                //Initial background colour
                ZStack {
                    //Initial colour background
                    RoundedRectangle(cornerRadius: 0)
                        .fill(item.color.gradient)
                    
                    //User selected background colour
                    RoundedRectangle(cornerRadius: 0)
                        .fill(obj.appearance.backgroundColour.gradient)
                        .if(obj.appearance.backgroundColourOrGradient) { view in
                            view.fill(obj.appearance.backgroundColour)
                        }
                }
                .hueRotation(Angle(degrees: obj.appearance.hue))
                .saturation(obj.appearance.saturation)
                .contrast(obj.appearance.wallContrast)
                .brightness(obj.appearance.wallBrightness)
            }
            
            //User imported background
            if let importedBackground = importedBackground {
                Image(uiImage: importedBackground)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: obj.appearance.frameWidth, height: obj.appearance.frameWidth)
                    .offset(y: obj.appearance.backgroundOffsetY)
                    .hueRotation(Angle(degrees: obj.appearance.hue))
                    .saturation(obj.appearance.saturation)
                    .contrast(obj.appearance.wallContrast)
                    .brightness(obj.appearance.wallBrightness)
//                    .overlay{
//                        HexagonGrid(rows: 34, columns: 10)
//                            .offset(x: -17.5, y: 350)
//                            .scaleEffect(2.75)
//                             
//                    }
            }
            
            //Blur overlay - disabled until blur value is > 0.01
            RoundedRectangle(cornerRadius: 0)
                .foregroundColor(.clear)
                .background {
                    TransparentBlurView(removeAllFilters: true)
                        .blur(radius: obj.appearance.blur, opaque: true)
                }
                .clipShape(Rectangle())
                .opacity(obj.appearance.blur > 0.01 ? 1 : 0)
        }
    }
}

struct MockupLayersView: View {
    @StateObject var obj: Object
    @Binding var importedImage1: UIImage?
    @Binding var importedImage2: UIImage?
    var item: Item
    
    var body: some View {
        ZStack {
            
            // Black screen when no screenshot image 1 is imported
            RoundedRectangle(cornerRadius: 0)
                .foregroundColor(.black)
                .clipShape(Rectangle())
                .frame(width: item.width, height: item.height)
                .applyImageTransformsImage1(item)
                .if(obj.appearance.showShadow) { view in
                    view.shadow(color: obj.appearance.shadowColor.opacity(obj.appearance.shadowOpacity), radius: obj.appearance.shadowRadius, x: obj.appearance.shadowOffsetX, y: obj.appearance.shadowOffsetY)
                }
            
            //Screenshot image 1
            if let importedImage1 = importedImage1 {
                Image(uiImage: importedImage1)
                    .resizable()
                    .if(obj.appearance.screenshotFitFill) { view in
                        view.aspectRatio(contentMode: .fill)
                    }
                    .frame(width: item.width, height: item.height)
                    .applyImageTransformsImage1(item)
            }
            
            // Black screen when no screenshot image 2 is imported
            RoundedRectangle(cornerRadius: 0)
                .foregroundColor(.black)
                .clipShape(Rectangle())
                .frame(width: item.width, height: item.height)
                .applyImageTransformsImage2(item)
                .if(obj.appearance.showShadow) { view in
                    view.shadow(color: obj.appearance.shadowColor.opacity(obj.appearance.shadowOpacity), radius: obj.appearance.shadowRadius, x: obj.appearance.shadowOffsetX, y: obj.appearance.shadowOffsetY)
                }
            
            //Screenshot image 2
            if let importedImage2 = importedImage2 {
                Image(uiImage: importedImage2)
                    .resizable()
                    .if(obj.appearance.screenshotFitFill) { view in
                        view.aspectRatio(contentMode: .fill)
                    }
                    .frame(width: item.width, height: item.height)
                    .applyImageTransformsImage2(item)
            }
            
            //Mockup image
            Image(item.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .colorMultiply(obj.appearance.colorMultiply)
            
            //Notch iumage
            Image(item.notch + obj.appearance.selectedNotch)
                .resizable()
                .aspectRatio(contentMode: .fill)
            
            //Screen reflection image
            if obj.appearance.selectedScreenReflection != "None" {
                ZStack {
                    Image(item.screenReflectionName + obj.appearance.selectedScreenReflection)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                    
                    Image(item.screenReflectionName + obj.appearance.selectedScreenReflection)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
                .opacity(obj.appearance.screenReflectionOpacity)
            }
        }   //Ground reflection of mockup layers
        .if(obj.appearance.showGroundReflection) { view in
            view.reflection(offsetY: item.reflectionOffset, obj: obj)
              
        }
        .rotationEffect(.degrees(obj.appearance.rotate))
        .scaleEffect(obj.appearance.scale, anchor: .center)
        .offset(x: obj.appearance.offsetX, y: obj.appearance.offsetY)
    }
}

struct LogoView: View {
    @StateObject var obj: Object
    @Binding var importedLogo: UIImage?
    
    var body: some View {
        if obj.appearance.showLogo {
            if let importedLogo = importedLogo {
                Image(uiImage: importedLogo)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .cornerRadius(obj.appearance.logoCornerRadius)
                    .scaleEffect(obj.appearance.logoScale)
                    .rotationEffect(.degrees(obj.appearance.logoRotate))
                    .offset(x: obj.appearance.logoOffsetX, y: obj.appearance.logoOffsetY)
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 4)
            }
        }
    }
}

extension View {
    func applyImageTransformsImage1(_ item: Item) -> some View {
        self
            .cornerRadius(item.cornerRadius)
            .rotation3DEffect(.degrees(item.degrees), axis: (x: item.x, y: item.y, z: item.z), anchor: item.anchor, anchorZ: 0, perspective: item.perspective)
            .rotation3DEffect(.degrees(item.degrees2), axis: (x: item.x2, y: item.y2, z: item.z2), anchor: item.anchor2, anchorZ: 0, perspective: item.perspective2)
            .offset(x: item.offX, y: item.offY)
            .scaleEffect(item.scale)
            .rotationEffect(.degrees(item.rotationEffect))
    }
}

extension View {
    func applyImageTransformsImage2(_ item: Item) -> some View {
        self
            .cornerRadius(item.cornerRadius_b)
            .rotation3DEffect(.degrees(item.degrees_b), axis: (x: item.x_b, y: item.y_b, z: item.z_b), anchor: item.anchor_b, anchorZ: 0, perspective: item.perspective_b)
            .rotation3DEffect(.degrees(item.degrees2_b), axis: (x: item.x2_b, y: item.y2_b, z: item.z2_b), anchor: item.anchor2_b, anchorZ: 0, perspective: item.perspective2_b)
            .offset(x: item.offX_b, y: item.offY_b)
            .scaleEffect(item.scale_b)
            .rotationEffect(.degrees(item.rotationEffect_b))
    }
}
