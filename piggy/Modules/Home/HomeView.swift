//
//  HomeView.swift
//  piggy
//
//  Created by Dason Tiovino on 22/08/24.
//

import SwiftUI

struct HomeView: View {
    @State private var isAnimating: Bool = false
    
    var body: some View {
        GeometryReader{ geometry in
            let widthPercentage = geometry.size.width / 100
            let heightPercentage = geometry.size.height / 100
            ZStack{
                Image("HomeBackground")
                    .resizable()
                    .overlay{
                        RoundedRectangle(cornerRadius: 25.0)
                            .fill(.pink)
                            .strokeBorder(Color.white, lineWidth: 20)
                            .overlay{
                                HStack{
                                    RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                                        .strokeBorder(Color.white, lineWidth: 5)
                                        .overlay{
                                            Text("Rp 100.000")
                                                .font(.largeTitle)
                                                .foregroundStyle(.black)
                                        }
                                    Image("Parental")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: widthPercentage * 20)
                                        
                                        
                                }.padding(widthPercentage * 3)
                            }
                            .frame(
                                maxWidth: .infinity,
                                maxHeight: heightPercentage * 30
                            )
                            .position(CGPoint(
                                x: widthPercentage * 50,
                                y: heightPercentage * 15))
                            
                        
                        
                    }
                
                Button{
                    
                }label: {
                    Image("House")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaleEffect(isAnimating ? 1.05 : 1.0)
                        .onAppear{
                            withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                               isAnimating = true
                           }
                        }
                }.frame(
                    width: widthPercentage * 50,
                    height: heightPercentage * 40
                )
                .position(CGPoint(
                    x: widthPercentage * 25,
                    y: heightPercentage * 60)
                )
                
                Button{
                    
                }label: {
                    Image("Bank")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaleEffect(isAnimating ? 1.05 : 1.0)
                        .onAppear{
                            withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                               isAnimating = true
                           }
                        }
                        
                }.frame(
                    width: widthPercentage * 50,
                    height: heightPercentage * 40
                )
                .position(CGPoint(
                    x: widthPercentage * 75,
                    y: heightPercentage * 60)
                )
                
                Image("Mascot")
                    .position(CGPoint(
                        x: widthPercentage * 50,
                        y: heightPercentage * 68)
                    )
                
            }
        }.ignoresSafeArea()
    }
}

#Preview {
    HomeView()
}
