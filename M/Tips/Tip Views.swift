//
//  PhotosTip.swift
//  M
//
//  Created by Sean Kelly on 23/11/2023.
//

import Foundation
import TipKit

struct NewWallpapersSectionTip: Tip {
    var title: Text {
        Text("New Wallpapers Section")
    }
    
    var message: Text? {
        Text("Tap here to view the new wallpapers section")
    }
    
    var image: Image? {
        Image(systemName: "photo.circle")
          
    }
}

struct SaveWallpaperTip: Tip {
    var title: Text {
        Text("Wallpaper Image Quality")
    }
    
    var message: Text? {
        Text("Preview images are low resolution. A full resolution image will be downloaded and saved")
    }
    
    var image: Image? {
        Image(systemName: "info.circle")
          
    }
}


struct GoBackToMockupViewTip: Tip {
    var title: Text {
        Text("Mockup View")
    }
    
    var message: Text? {
        Text("Return to the mockup view by tapping here")
    }
    
    var image: Image? {
        Image(systemName: "info.circle")
          
    }
}

struct ImportOverlayTip: Tip {
    var title: Text {
        Text("Import Overlay")
    }
    
    var message: Text? {
        Text("Tap here to import a transparent PNG image to overlay on the wallpaper image")
    }
    
    var image: Image? {
        Image(systemName: "info.circle")
          
    }
}
