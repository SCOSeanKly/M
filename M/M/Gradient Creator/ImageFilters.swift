//
//  ImageFilters.swift
//  M
//
//  Created by Sean Kelly on 12/03/2024.
//

import SwiftUI

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct ImageFilters: View {
    @State private var inputImage = UIImage(named: "swiftui")!
    // 1 apply Gaussian Blur
    func applyGaussianBlur(to inputImage: UIImage) -> UIImage? {
        guard let cgImage = inputImage.cgImage else { return nil }
        let ciImage = CIImage(cgImage: cgImage)
        
        let filter = CIFilter.gaussianBlur()
        filter.inputImage = ciImage
        filter.radius = 5
        
        guard let outputCIImage = filter.outputImage else { return nil }
        
        let context = CIContext()
        guard let outputCGImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) else { return nil }
        
        return UIImage(cgImage: outputCGImage)
    }
    // 2 Apply Sepia Filter
    func applySepiaFilter(to inputImage: UIImage) -> UIImage? {
        guard let cgImage = inputImage.cgImage else { return nil }
        let ciImage = CIImage(cgImage: cgImage)
        
        let filter = CIFilter.sepiaTone()
        filter.inputImage = ciImage
        filter.intensity = 0.8 // Adjust the intensity as needed
        
        guard let outputCIImage = filter.outputImage else { return nil }
        
        let context = CIContext()
        guard let outputCGImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) else { return nil }
        
        return UIImage(cgImage: outputCGImage)
    }
    // 3 Apply Color Invert Filter
    func applyColorInvertFilter(to inputImage: UIImage) -> UIImage? {
        guard let cgImage = inputImage.cgImage else { return nil }
        let ciImage = CIImage(cgImage: cgImage)
        
        let filter = CIFilter.colorInvert()
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        
        guard let outputCIImage = filter.outputImage else { return nil }
        
        let context = CIContext()
        guard let outputCGImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) else { return nil }
        
        return UIImage(cgImage: outputCGImage)
    }
    // 4 Apply Vignette Effect:
    func applyVignetteEffect(to inputImage: UIImage) -> UIImage? {
        guard let cgImage = inputImage.cgImage else { return nil }
        let ciImage = CIImage(cgImage: cgImage)
        
        let filter = CIFilter.vignette()
        filter.inputImage = ciImage
        filter.radius = 10 // Adjust the radius as needed
        filter.intensity = 5.0 // Adjust the intensity as needed
        
        guard let outputCIImage = filter.outputImage else { return nil }
        
        let context = CIContext()
        guard let outputCGImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) else { return nil }
        
        return UIImage(cgImage: outputCGImage)
    }
    
    
    // View
    var body: some View {
        VStack{
            // Normal image without effect
            HStack {
                Image("p_SKE2060")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100.0, height: 100.0)
                Text(" Normal image without effect")
                    .font(.system(size: 25, weight: .bold))
                    .frame(maxWidth:.infinity)
            }
            // 1 apply Gaussian Blur
            ZStack {
                if let filteredImage = applyGaussianBlur(to: inputImage) {
                    HStack {
                        Image(uiImage: filteredImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                        Text("Gaussian Blur")
                            .font(.system(size: 25, weight: .bold))
                            .frame(maxWidth:.infinity )
                    }
                } else {
                    Text("No Input Image")
                }
            }
            
            // 2 Apply Sepia Filter
            ZStack {
                if let filteredImage = applySepiaFilter(to: inputImage) {
                    HStack {
                        Image(uiImage: filteredImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                        Text("Sepia Filter")
                            .font(.system(size: 25, weight: .bold))
                            .frame(maxWidth:.infinity)
                    }
                } else {
                    Text("No Input Image")
                }
            }
            // 3 Apply Color Invert Filter
            ZStack {
                if let filteredImage = applyColorInvertFilter(to: inputImage) {
                    HStack {
                        Image(uiImage: filteredImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                        Text("Color Invert Filter")
                            .font(.system(size: 25, weight: .bold))
                            .frame(maxWidth:.infinity)
                    }
                } else {
                    Text("No Input Image")
                }
            }
            // 4 Apply Vignette Effect
            ZStack {
                if let filteredImage = applyVignetteEffect(to: inputImage) {
                    HStack {
                        Image(uiImage: filteredImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                        Text("Vignette Effect")
                            .font(.system(size: 25, weight: .bold))
                            .frame(maxWidth:.infinity)
                    }
                } else {
                    Text("No Input Image")
                }
            }
            
            
        } // END Vstack
        .padding(10)
    }
}


#Preview {
    ImageFilters()
}
