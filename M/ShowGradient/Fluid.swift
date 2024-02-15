//
//  fluid.swift
//  ShowWall
//
//  Created by Sean Kelly on 09/10/2023.
//

import SwiftUI

struct fluid: View {
    @State var animate: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            
            Canvas { context, size in
                // The real magic lies in these two filters.
                // This is an approach common with SVG using feGaussianBlur and feColorMatrix
                
                // https://developer.apple.com/documentation/swiftui/graphicscontext/filter/alphathreshold(min:max:color:)?changes=_7_3_5&language=objc
                // Returns a filter that replaces each pixel with alpha components within a range by a constant color, or transparency otherwise.
                context.addFilter(.alphaThreshold(min: 0.5, color: .black))
                
                // Gaussian blur
                context.addFilter(.blur(radius: 15))
                
                // drawLayer creates a new transparency layer that you can draw into
                // the above filters won't work without drawing the swiftui symbols into their single layer added to the main context
                context.drawLayer { ctx in
                    // access the passed in symbols using their .tag() id
                    let circle0 = ctx.resolveSymbol(id: 0)!
                    let circle1 = ctx.resolveSymbol(id: 1)!
                    
                    ctx.draw(circle0, at: CGPoint(x: 131, y: 50))
                    ctx.draw(circle1, at: CGPoint(x: 262, y: 50))
                }
                
            } symbols: {
                // symbols is how you can tell canvas to accept a regular SwiftUI view to work with
                // required to .tag() so you get an id to resolve the symbol inside canvas
                Circle()
                    .fill(.black)
                    .frame(width: 90, height: 90)
                    .offset(x: animate ? 66 : -40)
                    .tag(0)
                
                Circle()
                    .fill(.black)
                    .frame(width: 90, height: 90)
                    .offset(x: animate ? -66 : 40)
                    .tag(1)
            }
            .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: animate)
            .frame(height: 100)
            
            Spacer()
        }
        
        .task {
            animate = true
        }
    }
}


struct RippleView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .rippleEffect(rippleColor: .gray)
        .frame(width: 400, height: 200)
        .padding()
    }
}

struct Ripple: ViewModifier {
    // MARK: Lifecycle
    
    init(rippleColor: Color) {
        self.color = rippleColor
    }
    
    // MARK: Internal
    
    let color: Color
    
    @State private var scale: CGFloat = 0.5
    
    @State private var animationPosition: CGFloat = 0.0
    @State private var x: CGFloat = 0.0
    @State private var y: CGFloat = 0.0
    
    @State private var opacityFraction: CGFloat = 0.0
    
    let timeInterval: TimeInterval = 0.5
    
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            ZStack {
                Rectangle()
                    .foregroundColor(.gray.opacity(0.05))
                Circle()
                    .foregroundColor(color)
                    .opacity(0.2*opacityFraction)
                    .scaleEffect(scale)
                    .offset(x: x, y: y)
                content
            }
            .onTapGesture(perform: { location in
                x = location.x-geometry.size.width/2
                y = location.y-geometry.size.height/2
                opacityFraction = 1.0
                withAnimation(.linear(duration: timeInterval)) {
                    scale = 3.0*(max(geometry.size.height, geometry.size.width)/min(geometry.size.height, geometry.size.width))
                    opacityFraction = 0.0
                    DispatchQueue.main.asyncAfter(deadline: .now() + timeInterval) {
                        scale = 1.0
                        opacityFraction = 0.0
                    }
                }
            })
            .clipped()
        }
    }
}

extension View {
    func rippleEffect(rippleColor: Color = .accentColor.opacity(0.5)) -> some View {
        modifier(Ripple(rippleColor: rippleColor))
    }
}

import SwiftUI

struct rippleDrop: View {
    
    @State var ripple = false
    @State var bigDrop = false
    @State var littleDrop = false
    var dropSpeed = 0.45
    var dropInterval = 2.0
    
    var body: some View {
        ZStack{
            
            Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1))
            
            // Big Water Drop
            Circle()
                .fill(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                .frame(width:10,height:10)
                .offset(x:0, y:bigDrop ? 0 : -420)
                .opacity(bigDrop ? 1 : 0)
                .animation(.linear(duration: dropSpeed).delay(dropInterval).repeatForever(autoreverses: false))
                .onAppear(){
                    bigDrop.toggle()
                }
            
            // Ripple
            ZStack(alignment: .center) {
                Circle()
                    .stroke(lineWidth: ripple ? 0 : 30)
                    .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                    .frame(width:300, height:300)
                    .scaleEffect(ripple ? 1 : 0)
                    .opacity(ripple ? 1: 0)
                    .animation(Animation.easeOut(duration:(dropSpeed + dropInterval)).repeatForever(autoreverses: false).delay(dropSpeed + dropInterval))
                
            }
            .rotation3DEffect(
                .degrees(65),
                axis: (x: 1.0, y: 0.0, z: 0.0),
                anchor: .center,
                anchorZ: 0.0,
                perspective: 1.0
            )
            .onAppear(){
                ripple.toggle()
            }
        }.ignoresSafeArea(.all)
    }
}



