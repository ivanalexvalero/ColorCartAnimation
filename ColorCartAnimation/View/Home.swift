//
//  Home.swift
//  ColorCartAnimation
//
//  Created by Ivan Valero on 24/01/2022.
//

import SwiftUI


struct Home: View {
    
    @State var colors: [ColorGrid] = [
        ColorGrid(hexValue: "#15654B", color: Color("Verde")),
        ColorGrid(hexValue: "#DDA4FF", color: Color("Violeta")),
        ColorGrid(hexValue: "FFD90A", color: Color("Amarillo")),
        ColorGrid(hexValue: "#FE9EC4", color: Color("Rosa")),
        ColorGrid(hexValue: "FB3272", color: Color("Naranja")),
        ColorGrid(hexValue: "¢4460EE", color: Color("Azul")),
    ]
    
    @State var animations: [Bool] = Array(repeating: false, count: 10)
    
    @Namespace var animation
    
    @State var selectedColor: Color = Color("Rosa")
    
    var body: some View {
        
        VStack {
            
            HStack {
                
                Button{
                    
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                }
                .hLeading()
                
                Button {
                    
                } label: {
                    Image("Perfil")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 45, height: 45)
                        .clipShape(Circle())
                }
            }
            .padding([.horizontal,.top])
            .padding(.bottom,5)
            
//            GeometryReader{proxy in
//                let maxY = proxy.frame(in: .global).maxY
//                CreditCard()
//                    .offset(y: animations[0] ? 0 : -maxY)
//            }
            CreditCard()
                .offset(y: animations[0] ? 0 : -420)
            
            .frame(height: 250)
            .zIndex(-1)
            
            HStack{
                Text("Elije tu color")
                    .font(.callout)
                    .fontWeight(.semibold)
                    .hLeading()
                    .offset(x: animations[1] ? 0 : -200)
                
                Button{
                    
                } label: {
                    Text("Ver todos")
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundColor(Color("Rosa"))
                        .underline()
                }
                .offset(x: animations[1] ? 0 : 200)
            }
            .padding()
            
            GeometryReader{proxy in
                
                let size = proxy.size
                
                ZStack{
                    Color.black
                        .clipShape(CustomCorner(corner: [.topLeft,.topRight], radius: 40))
                        .frame(height: animations[2] ? nil : 0)
                        .vBottom()
                    
                    ZStack{
                        ForEach(colors){colorGrid in
                            
                            if !colorGrid.removeFromView {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(colorGrid.color)
                                    .frame(width: 150, height: animations[3] ? 60 : 150)
                                    .matchedGeometryEffect(id: colorGrid.id, in: animation)
                                    .rotationEffect(.init(degrees: colorGrid.rotateCard ? 180 : 0))
                            }
                            
                            
                        }
                    }
                    .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color("BG"))
                                .frame(width: 150, height: animations[3] ? 60 : 150)
                                .opacity(animations[3] ? 0 : 1)
                    )
                    .scaleEffect(animations[3] ? 1 : 2.3)
                }
                .hCenter()
                .vCenter()

                
                ScrollView(.vertical, showsIndicators: false) {
                    
                    let columns = Array(repeating: GridItem(.flexible(), spacing: 15), count: 2)
                    
                    LazyVGrid(columns: columns, spacing: 15){
                        
                        ForEach(colors){colorGrid in
                            
                            GridCardView(colorGrid: colorGrid)
                            
                        }
                    }
                    .padding(.top, 10)
                }
                .padding(.top, 20)
                .zIndex(1)
                .cornerRadius(40)
            }
        }
        .vTop()
        .hCenter()
        .ignoresSafeArea(.container, edges: .bottom)
        .background(Color("BG"))
        .preferredColorScheme(.dark)
        .onAppear(perform: animateScreen)
    }
    
    @ViewBuilder
    func GridCardView(colorGrid: ColorGrid)->some View {
        
        VStack {
            if colorGrid.addToGrid{
                RoundedRectangle(cornerRadius: 10)
                    .fill(colorGrid.color)
                    .frame(width: 150, height: 60)
                    .matchedGeometryEffect(id: colorGrid.id, in: animation)
//                    .opacity(animations[3] ? 0 : 1)
                    .onAppear {
                        if let index = colors.firstIndex(where: { color in
                            return color.id == colorGrid.id
                        }){
                            withAnimation {
                                colors[index].showText = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.11) {
                                withAnimation {
                                    colors[index].removeFromView = true
                                }
                            }
                        }
                    }
                    .onTapGesture {
                        withAnimation {
                            selectedColor = colorGrid.color
                        }
                    }
            
                    
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.clear)
                    .frame(width: 150, height: 60)
            }
            
            Text(colorGrid.hexValue)
                .font(.caption)
                .fontWeight(.light)
                .foregroundColor(.white)
                .hLeading()
                .padding([.horizontal,.top])
                .opacity(colorGrid.showText ? 1 : 0)
        }
        
    }
    
    func animateScreen(){
        // 1
        withAnimation(.interactiveSpring(response: 1.3, dampingFraction: 0.7, blendDuration: 0.7)) {
            animations[0] = true
        }
        
        //2
        withAnimation(.easeOut(duration: 1.5).delay(0.4)){
            animations[1] = true
        }
        
        //3
        withAnimation(.interactiveSpring(response: 1.3, dampingFraction: 0.7, blendDuration: 0.7)){
            animations[2] = true
        }
        
        //4
        withAnimation(.easeOut(duration: 0.7)){
            animations[3] = true
        }
        
        //5
        for index in colors.indices {
            let delay: Double = (0.9 + (Double(index) * 0.1))
            
            let backIndex = ((colors.count - 1) - index)
            
            withAnimation(.easeInOut.delay(delay)){
                colors[backIndex].rotateCard = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation {
                    colors[backIndex].addToGrid = true
                }
            }
        }
    }
    
    
    @ViewBuilder
    func CreditCard()->some View{
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(selectedColor)
            
            VStack{
                HStack{
                    ForEach(1...4, id: \.self){_ in
                        Circle()
                            .fill()
                            .frame(width: 6, height: 6)
                    }
                    Text("2294")
                        .font(.callout)
                        .fontWeight(.semibold)
                }
                .hLeading()
                
                HStack(spacing: -12){
                    Text("Valero, Iván Alexander")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .hLeading()
                    
                    Circle()
                        .stroke(.white,lineWidth: 1)
                        .frame(width: 30, height: 30)
                    
                    Circle()
                        .stroke(.white,lineWidth: 1)
                        .frame(width: 30, height: 30)
                }
                .vBottom()
            }
            .hLeading()
            .vTop()
            .padding(.vertical, 20)
            .padding(.horizontal)
            
            Circle()
                .stroke(Color.white.opacity(0.5),lineWidth: 18)
                .offset(x: 130, y: -120)
        }
        .clipped()
        .padding()
        
    }
    
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}


extension View {
    
    func hLeading() -> some View {
        self
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func hTrailing() -> some View {
        self
            .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    func hCenter() -> some View {
        self
            .frame(maxWidth: .infinity, alignment: .center)
    }
    
    func vCenter() -> some View {
        self
            .frame(maxHeight: .infinity, alignment: .center)
    }
    
    func vTop() -> some View {
        self
            .frame(maxHeight: .infinity, alignment: .top)
    }
    
    func vBottom() -> some View {
        self
            .frame(maxHeight: .infinity, alignment: .bottom)
    }
}
