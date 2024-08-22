//
//  AchievementView.swift
//  piggy
//
//  Created by Dason Tiovino on 22/08/24.
//

import SwiftUI

internal struct AchievementView: View {
    
    @ObservedObject var viewModel: AchievementListViewModelSwiftUI
    
    init() {
        let achievementUseCase = DefaultAchievementListUseCase(
            // Changeable Repository
            repository: DefaultAchievementListRepository()
        )
        
        let stickerUseCase = DefaultAchievementStickerUseCase(
            // Changeable Repository
            repository: DefaultAchievementStickerRepository() 
        )
        self.viewModel = AchievementListViewModelSwiftUI(
            achievementUseCase: achievementUseCase,
            stickerUseCase: stickerUseCase
        )
    }
    
    var body: some View {
        VStack{
            Text("Achievement Page")
                .font(.largeTitle)
            Image("AchievementBackground")
                .resizable()
                .overlay{
                    GeometryReader{ geometry in
                        let size = geometry.size
                        let widthPercentage = size.width/100
                        let heightPercentage = size.height/100
                        
                        HStack(){
                            VStack{
//                                // Adding Achievement List
//                                Button{
//                                    viewModel.addItem(params: .init(
//                                        title: "Hello", category: "Category"))
//                                }label: {
//                                    Text("Add")
//                                }
//                                .background(.white)
                                
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(.pink)
                                    .strokeBorder(Color.white, lineWidth: 5)
                                    .overlay{
                                        Text("Sticker")
                                            .font(.largeTitle)
                                            .foregroundStyle(.white)
                                    }
                                    .frame(
                                        maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,
                                        maxHeight: heightPercentage * 10
                                    )
                                
                                Spacer()
                                    .frame(height: heightPercentage * 3)
                                
                                RoundedRectangle(cornerRadius: 25)
                                    .strokeBorder(Color.white, lineWidth: 5)
                                    .overlay{
                                        Image("StickerBackground")
                                            .resizable()
                                            .overlay{
                                                GeometryReader{ geometry in
                                                    ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)){
                                                        
                                                        ForEach($viewModel.sticker){ $sticker in
                                                            if sticker.isShowed {
                                                                DraggableSticker(
                                                                    image: "Mascot",
                                                                    position: $sticker.position
                                                                )
                                                            }else{}
                                                        }
                                                        
                                                        
                                                        RoundedRectangle(cornerRadius: 15)
                                                            .fill(.white)
                                                            .strokeBorder(Color.white, lineWidth: 5)
                                                            .frame(
                                                            maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,
                                                            maxHeight:  heightPercentage * 10
                                                            ).overlay{
                                                                ScrollView(.horizontal){
                                                                    ForEach(viewModel.sticker){ sticker in
                                                                        Button{
                                                                            viewModel.updateStickerShowState(model: sticker)
                                                                        }label:{
                                                                            Image(sticker.image)
                                                                                .resizable()
                                                                                .aspectRatio(contentMode: .fit)
                                                                                .grayscale(sticker.isShowed ? 0 : 1)
                                                                        }
                                                                    }
                                                                }.frame(
                                                                    maxWidth: .infinity,
                                                                    maxHeight: .infinity
                                                                )
                                                            }
                                                            .position(
                                                                CGPoint(
                                                                    x: geometry.size.width/2,
                                                                    y:geometry.size.height - heightPercentage * 10 / 2
                                                                )
                                                            )
                                                    }
                                                }.padding()
                                            }
                                    }
                            }
                            .padding()
                            .padding(.vertical, heightPercentage * 3)
                            .frame(
                                maxWidth: .infinity,
                                maxHeight: .infinity,
                                alignment: Alignment(
                                    horizontal: .leading,
                                    vertical: .top
                                )
                            )
                            
                            Spacer()
                                .frame(width: widthPercentage * 12)
                            
                            VStack{
                                HStack{
                                    Text("Achievement")
                                        .font(.largeTitle)
                                    
                                    Spacer()
                                    Text("August")
                                }
                                .padding()
                                .frame(
                                    height: heightPercentage * 14,
                                    alignment: Alignment(
                                        horizontal: .center,
                                        vertical: .bottom
                                    )
                                ).overlay{
                                    AchievementListOverlay()
                                }
                                
                                Spacer()
                                    .frame(
                                        maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,
                                        maxHeight: heightPercentage * 7
                                    )
                                    .overlay{
                                        AchievementListOverlay()
                                    }
                            
                                ForEach(0..<10, id: \.self){ index in
                                    let resultCount = viewModel.data.count
                                    if resultCount > index {
                                        // Not Empty
                                        let model =  viewModel.data[index]
                                        HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/){
                                            Button{
                                                viewModel.updateItemReadyToClaim(model: model)
                                            }label:{
                                                Image(model.isReadyToClaim ? "CheckboxFilled" : "Checkbox")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: widthPercentage * 2, height: widthPercentage * 2)
                                            }
                                            Text(model.title)
                                            Spacer()
                                            Button{
                                                viewModel.updateItemClaimed(model: model)
                                            }label:{
                                                Image(model.isClaimed ? "GiftOpened" : "Gift")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: widthPercentage * 2, height: widthPercentage * 2)  // Fix the width and height

                                            }
                                        }
                                        .padding(0)
                                        .padding(.horizontal)
                                        .frame(
                                            height: heightPercentage * 7
                                        )
                                        .overlay{
                                            AchievementListOverlay()
                                        }
                                    } else {
                                        // Empty
                                        Spacer()
                                            .frame(
                                                maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,
                                                maxHeight: heightPercentage * 7
                                            )
                                            .overlay{
                                                AchievementListOverlay()
                                            }
                                    }
                                    
                                }
                            }.frame(
                                maxWidth: .infinity,
                                maxHeight: .infinity,
                                alignment: Alignment(
                                    horizontal: .leading,
                                    vertical: .top
                                )
                            )
                            .overlay{
                                Rectangle()
                                    .frame(width: 1)
                                    .position(
                                        x: 0,
                                        y: heightPercentage * 50
                                    )
                            }
                            
                        }
                        .padding(
                            .horizontal,
                            widthPercentage * 2
                        )
                    }
                }
        }.padding()
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
        .onAppear{
            self.viewModel.fetch()
        }
    }
}



#Preview {
    AchievementView()
}
