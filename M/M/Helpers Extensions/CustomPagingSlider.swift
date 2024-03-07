//
//  CustomPagingSlider.swift
//  M
//
//  Created by Sean Kelly on 03/11/2023.
//

import SwiftUI

/// Paging Slider Data Model
struct Item: Identifiable {
    private(set) var id: UUID = .init()
    var imageName: String // Use String for image name
    var screenReflectionName: String
    var shadowName: String
    var color: Color
    var alertTextColor: Color
    var title: String
    var subTitle: String
    
    // 1st Device
    var degrees: CGFloat
    var degrees2: CGFloat
    var x: CGFloat
    var y: CGFloat
    var z: CGFloat
    var anchor: UnitPoint
    var perspective: CGFloat
    var perspective2: CGFloat
    var x2: CGFloat
    var y2: CGFloat
    var z2: CGFloat
    var anchor2: UnitPoint
    var scale: CGFloat
    var offX: CGFloat
    var offY: CGFloat
    var rotationEffect: CGFloat
    var width: CGFloat
    var height: CGFloat
    var cornerRadius: CGFloat
    var notch: String
    var reflectionOffset: CGFloat
    
    // 2nd Device
    var degrees_b: CGFloat
    var degrees2_b: CGFloat
    var x_b: CGFloat
    var y_b: CGFloat
    var z_b: CGFloat
    var anchor_b: UnitPoint
    var perspective_b: CGFloat
    var perspective2_b: CGFloat
    var x2_b: CGFloat
    var y2_b: CGFloat
    var z2_b: CGFloat
    var offX_b: CGFloat
    var offY_b: CGFloat
    var anchor2_b: UnitPoint
    var scale_b: CGFloat
    var rotationEffect_b: CGFloat
    var width_b: CGFloat
    var height_b: CGFloat
    var cornerRadius_b: CGFloat

    // Convenience property to convert imageName to Image
    var image: Image {
        Image(imageName)
    }
}

/// Custom View
struct CustomPagingSlider<Content: View, TitleContent: View, Item: RandomAccessCollection>: View where Item: MutableCollection, Item.Element: Identifiable {
    @Binding var showCoverFlow: Bool
    @Binding var data: Item
    @ViewBuilder var content: (Binding<Item.Element>) -> Content
    @ViewBuilder var titleContent: (Binding<Item.Element>) -> TitleContent
    let itemWidth = UIScreen.main.bounds.width
    
    
    /// View Properties
    @State private var activeID: UUID?
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            //MARK: Coverflow style
            if showCoverFlow {
                CoverFlowView(
                    itemWidth: itemWidth,
                    spacing: 0,
                    rotation: 40,
                    items: $data
                ) { item in
                    VStack(spacing: 0) {
                        titleContent(item)
                            .frame(maxWidth: .infinity)
                        
                        content(item)
                    }
                }
            } else {
                //MARK: Slide style
                ScrollView(.horizontal) {
                    HStack(spacing: 150) {
                        ForEach($data) { item in
                            VStack(spacing: 0) {
                                titleContent(item)
                                    .frame(maxWidth: .infinity)
                                    .visualEffect { content, geometryProxy in
                                        content
                                            .offset(x: scrollOffset(geometryProxy))
                                    }
                                
                                content(item)
                            }
                            .containerRelativeFrame(.horizontal)
                        }
                    }
                    /// Adding Paging
                    .scrollTargetLayout()
                }
            }
            
            //MARK: Scroll position indicators
            PagingControl(numberOfPages: data.count, activePage: activePage) { value in
                /// Updating to current Page
                if let index = value as? Item.Index, data.indices.contains(index) {
                    if let id = data[index].id as? UUID {
                        withAnimation(.snappy(duration: 0.35, extraBounce: 0)) {
                            activeID = id
                        }
                    }
                }
            }
            .disabled(false)
            .scaleEffect(0.6)
            .offset(y: showCoverFlow ? -65 : -20)
        }
        .scrollIndicators(.hidden)
        .scrollTargetBehavior(.viewAligned)
        .scrollPosition(id: $activeID)
    }
    
    var activePage: Int {
        if let index = data.firstIndex(where: { $0.id as? UUID == activeID }) as? Int {
            return index
        }
        
        return 0
    }
    
    func scrollOffset(_ proxy: GeometryProxy) -> CGFloat {
        let minX = proxy.bounds(of: .scrollView)?.minX ?? 0
        
        return -minX * min(0.6, 1.0)
    }
}

/// Paging Control
struct PagingControl: UIViewRepresentable {
    var numberOfPages: Int
    var activePage: Int
    var onPageChange: (Int) -> ()
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(onPageChange: onPageChange)
    }
    
    func makeUIView(context: Context) -> UIPageControl {
        let view = UIPageControl()
        view.currentPage = activePage
        view.numberOfPages = numberOfPages
        view.backgroundStyle = .prominent
        view.currentPageIndicatorTintColor = UIColor(Color.primary)
        view.pageIndicatorTintColor = UIColor.placeholderText
        view.addTarget(context.coordinator, action: #selector(Coordinator.onPageUpdate(control:)), for: .valueChanged)
        return view
    }
    
    func updateUIView(_ uiView: UIPageControl, context: Context) {
        /// Updating Outside Event Changes
        uiView.numberOfPages = numberOfPages
        uiView.currentPage = activePage
    }
    
    class Coordinator: NSObject {
        var onPageChange: (Int) -> ()
        init(onPageChange: @escaping (Int) -> Void) {
            self.onPageChange = onPageChange
        }
        
        @objc
        func onPageUpdate(control: UIPageControl) {
            onPageChange(control.currentPage)
        }
    }
}



