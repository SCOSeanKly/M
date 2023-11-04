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
    @Binding var importedLogo: UIImage?
    @StateObject var obj: Object
    
    
    var body: some View {
        
        ///Background Images and colors
        ZStack {
            if obj.appearance.showBackground {
                
                if importedBackground == nil {
                    //Initial background colour
                    ZStack {
                        RoundedRectangle(cornerRadius: 0)
                            .fill(item.color.gradient)
                        
                        //User background colour
                        RoundedRectangle(cornerRadius: 0)
                            .fill(obj.appearance.backgroundColour.gradient)
                    }
                    .hueRotation(Angle(degrees: obj.appearance.hue))
                    .saturation(obj.appearance.saturation)
                }
                
                //User imported background
                if let importedBackground = importedBackground {
                   
                        Image(uiImage: importedBackground)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: obj.appearance.frameWidth, height: obj.appearance.frameWidth)
                            .offset(y: obj.appearance.backgroundOffsetY)
                            .scaleEffect(1.02, anchor: .center)
                            .hueRotation(Angle(degrees: obj.appearance.hue))
                            .saturation(obj.appearance.saturation)
                            .distortionEffect(
                                .init(
                                    function: .init(library: .default, name: "pixellate"),
                                    arguments: [.float(obj.appearance.pixellate)]
                                ),
                                maxSampleOffset: .zero
                            )
                    
                    //MARK: Average colour - causes app to slow down as if the colour is being constantly checked in the background
                    /*
                    if obj.appearance.showAverageColor {
                       let averageBG = importedBackground.averageColor
                        
                        RoundedRectangle(cornerRadius: 0)
                            .foregroundColor(averageBG.map { Color($0)})
                        
                    }
                     */
                }
                
                //Blur overlay
                RoundedRectangle(cornerRadius: 0)
                    .foregroundColor(.clear)
                    .background {
                        TransparentBlurView(removeAllFilters: true)
                            .blur(radius: obj.appearance.blur, opaque: true)
                    }
                    .clipShape(Rectangle())
            }
            
            ///Mockup Images and screenshot
            ZStack {
                // Black screen when no screenshot is imported
                RoundedRectangle(cornerRadius: 0)
                    .foregroundColor(.black)
                    .clipShape(Rectangle())
                    .frame(width: item.width, height: item.height)
                    .applyImageTransforms(item)
                    .if(obj.appearance.showShadow) { view in
                        view.shadow(color: .black.opacity(obj.appearance.shadowOpacity), radius: obj.appearance.shadowRadius, x: obj.appearance.shadowOffsetX, y: obj.appearance.shadowOffsetY)
                    }
                
                //Screenshot image
                if let importedImage1 = importedImage1 {
                    Image(uiImage: importedImage1)
                        .resizable()
                        .if(obj.appearance.screenshotFitFill) { view in
                            view.aspectRatio(contentMode: .fit)
                        }
                        .frame(width: item.width, height: item.height)
                        .applyImageTransforms(item)
                     
                    
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
                    
                    Image(item.screenReflectionName + obj.appearance.selectedScreenReflection)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
            }   //Ground reflection of mockup layers
            .if(obj.appearance.showGroundReflection) { view in
                view.reflection(offsetY: item.reflectionOffset)
            }
            .rotationEffect(.degrees(obj.appearance.rotate))
            .scaleEffect(obj.appearance.scale, anchor: .center)
            .offset(x: obj.appearance.offsetX, y: obj.appearance.offsetY)
            
            //Imported logo image
            
            if obj.appearance.showLogo {
                if let importedLogo = importedLogo {
                    Image(uiImage: importedLogo)
                        .resizable()
                        .frame(width: 100, height: 100)
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(obj.appearance.logoCornerRadius)
                        .scaleEffect(obj.appearance.logoScale)
                        .rotationEffect(.degrees(obj.appearance.logoRotate))
                        .offset(x: obj.appearance.logoOffsetX, y: obj.appearance.logoOffsetY)
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 4)
                }
            }
            
        }
        .frame(width: obj.appearance.frameWidth, height: obj.appearance.frameHeight)
        .clipped()
    }
}

extension View {
    func applyImageTransforms(_ item: Item) -> some View {
        self
            .cornerRadius(item.cornerRadius)
            .rotation3DEffect(.degrees(item.degrees), axis: (x: item.x, y: item.y, z: item.z), anchor: item.anchor, anchorZ: 0, perspective: item.perspective)
            .rotation3DEffect(.degrees(item.degrees2), axis: (x: item.x2, y: item.y2, z: item.z2), anchor: item.anchor2, anchorZ: 0, perspective: item.perspective2)
            .offset(x: item.offX, y: item.offY)
            .scaleEffect(item.scale)
            .rotationEffect(.degrees(item.rotationEffect))
        
    }
}


