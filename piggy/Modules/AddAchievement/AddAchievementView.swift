//
//  AddAchievementView.swift
//  piggy
//
//  Created by Dason Tiovino on 23/08/24.
//

import SwiftUI

struct AddAchievementView: View {
    @ObservedObject var viewModel: AchievementListViewModelSwiftUI
    @EnvironmentObject var addAchievementWrapper: AddAchievementWrapper
    
    @State var allowanceAmount: String = ""
    @State var achievementTitle: String = ""
    @State private var selectedImage: UIImage? = nil
    @State private var isImagePickerPresented: Bool = false
    @State private var selectedSegment = 0
    
    init() {
        let achievementUseCase = DefaultAchievementListUseCase(
            // Changeable Repository
            repository: DefaultAchievementListRepository()
        )
        
        let stickerUseCase = DefaultAchievementStickerUseCase(
            // Changeable Repository
            repository: DefaultAchievementStickerRepository()
        )
        
        let transactionUseCase = DefaultTransactionListUseCase(
            repository: DefaultTransactionListRepository()
        )
        
        self.viewModel = AchievementListViewModelSwiftUI(
            achievementUseCase: achievementUseCase,
            stickerUseCase: stickerUseCase, 
            transactionUseCase: transactionUseCase
        )
        
    }
    
    var body: some View {
        GeometryReader { geometry in
            let widthPercentage = geometry.size.width / 100
            let heightPercentage = geometry.size.height / 100
            ZStack{
                Button{
                    addAchievementWrapper.isPresented = false
                }label: {
                    Image("CancelButton")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 75, height: 75)
                        .position(CGPoint(x: 75, y:75))
                }
                
                VStack{
                    Text("New Achievement")
                        .font(.largeTitle)
                        .fontWeight(.black)
                    
                    Text("Achievement Title")
                        .font(.title)
                        .fontWeight(.black)
                        .padding(.top)
                    TextField("Get A+ on Math Exam", text: $achievementTitle)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white, lineWidth: 4)
                        )
                        .font(.title)
                        .bold()
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding()
                    
                    Text("Achievement Reward")
                        .font(.title)
                        .fontWeight(.black)
                        .padding(.top)
                    
                    HStack {
                        Button(action: {
                            selectedSegment = 0
                        }) {
                            Text("Allowance")
                                .font(.title)
                                .bold()
                                .foregroundColor(.black)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(selectedSegment == 0 ? .white : .clear)
                                .cornerRadius(10)
                        }
                        Button(action: {
                            selectedSegment = 1
                        }) {
                            Text("Others")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.black)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(selectedSegment == 1 ? .white : .clear)
                                .cornerRadius(10)
                        }
                    }
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .padding()
                    
                    if(selectedSegment == 0){
                        TextField("Rp10.000", text: $allowanceAmount)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.white, lineWidth: 4)
                            )
                            .font(.system(size: 24, weight: .bold, design: .default))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                            .padding()
                    }else {
                        if let selectedImage = selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 300, height: 200)
                                .cornerRadius(20)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.white, lineWidth: 4)
                                )
                                .onTapGesture {
                                    isImagePickerPresented = true
                                }
                        } else {
                            Image(systemName: "photo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.gray)
                                .frame(width: 50, height: 50)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                                .frame(width: 300, height: 200)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(20)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.white, lineWidth: 4)
                                )
                                .onTapGesture {
                                    isImagePickerPresented = true
                                }
                        }
                    }
                    
                    Spacer()
                        .frame(height: heightPercentage * 5)
                    
                    Button{
                        
                        if(selectedSegment == 0){
                            viewModel.addAchievementWithAmount(title: achievementTitle, amount: Int(allowanceAmount) ?? 0)
                        }else{
                            viewModel.addAchievementWithAmount(title: achievementTitle, amount: Int(allowanceAmount) ?? 0)
                        }
                        addAchievementWrapper.isPresented = false
                        
                    }label:{
                        Text("Submit")
                            .font(.title)
                            .bold()
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: widthPercentage * 25, height: 70)
                            .background(Color.purple)
                            .cornerRadius(35)
                            .overlay(
                                RoundedRectangle(cornerRadius: 35)
                                    .stroke(Color.white, lineWidth: 4)
                            )
                    }
                }
            }
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(selectedImage: $selectedImage, isPresented: $isImagePickerPresented)
            }
            .ignoresSafeArea()
            //            .background(.tint2)
        }
    }
}

#Preview {
    AddAchievementView()
}
