//
//  PopOverGradientWallView.swift
//  M
//
//  Created by Sean Kelly on 16/02/2024.
//

import SwiftUI

struct PopOverGradientWallView: View {
    var body: some View {
        
        VStack {
            HStack {
                Text("\(Image(systemName: "info.circle")) Info")
                    .font(.headline)
                
                Spacer()
            }
            .padding(.bottom, 15)
            
            List {
                Section(header: Text("Top Right Buttons")) {
                    Text("\(Image(systemName: "chevron.up.chevron.down")) Use the first picker to select a gradient style. Linear, Radial or Angular")
                    Text("\(Image(systemName: "chevron.up.chevron.down")) Use the second picker to select a blend style")
                    Text("\(Image(systemName: "photo.circle.fill")) Tap this button to import an image from photos. Example import a wallpaper so you can add effects as described below")
                    Text("\(Image(systemName: "photo.circle")) Tap this button to import an overlay image from photos. Note that this image isnt affected by any effects")
                }
                Section(header: Text("Adjustment Sliders/Button")) {
                    Text("\(Image(systemName: "camera.filters")) Adjusts the image hue")
                    Text("\(Image(systemName: "camera.filters")) Adjusts the image hue")
                    Text("\(Image(systemName: "drop.halffull")) Adjusts the image saturation")
                    Text("\(Image(systemName: "circle.lefthalf.striped.horizontal")) Adjusts the image contrast")
                    Text("\(Image(systemName: "sun.max")) Adjusts the image brightness")
                    Text("\(Image(systemName: "scribble.variable")) Use the slider to blur the image")
                    Text("\(Image(systemName: "arrow.up.left.and.arrow.down.right")) Adjusts the image scale")
                    Text("\(Image(systemName: "arrow.triangle.2.circlepath")) Adjusts the image rotation")
                    Text("\(Image(systemName: "rectangle.checkered")) Adds a pixelated effect. Use the slider to increase the scale of the pixel")
                    Text("\(Image(systemName: "water.waves")) Adds a wave effect. Use the sliders to adjust the amplitude and frequency")
                    Text("\(Image(systemName: "switch.2")) The Half Blur toggle adds a blur layer on the left siude of the image with a subtle shadow effect")
                }
                Section(header: Text("Colour Picker")) {
                    Text("\(Image(systemName: "eyedropper.halffull")) Use the colour picker to select the colours you would like in the gradient effect")
                    Text("\(Image(systemName: "button.horizontal.top.press")) Tap the Re-Order gradient button to randomize the positions of the current gradient")
                }
                Section(header: Text("Gestures")) {
                    Text("\(Image(systemName: "hand.tap")) Double tap the screen to save the image to photos")
                    Text("\(Image(systemName: "hand.draw")) Slide your finger down on the screen to close the gradient wallpaper creator")
                }
            }
            .font(.footnote)
            .listStyle(.plain)
            
        }
        //  .frame(height: UIScreen.main.bounds.height * 0.5)
        .padding()
    }
}
