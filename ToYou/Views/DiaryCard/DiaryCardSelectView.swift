//
//  DiaryCardSelectView.swift
//  ToYou
//
//  Created by 김미주 on 9/19/25.
//

import SwiftUI

struct DiaryCardSelectView: View {
    @StateObject private var viewModel = DiaryCardSelectViewModel()
    
    var body: some View {
        ZStack {
            // 배경
            Image(.paperTexture)
                .resizable()
                .aspectRatio(contentMode: .fill)
            
            VStack {
                Spacer().frame(height: 65)
                
                // 상단뷰
                TopGroup
                
                Spacer().frame(height: 24)
                
                VStack(spacing: 53) {
                    // 장문형
                    LongGroup
                    
                    // 단문형
                    ShortGroup
                    
                    // 선택형
                    OptionalGroup
                }
            }
        }
        .foregroundStyle(.black04)
    }
    
    // MARK: - Group
    
    // 상단
    private var TopGroup: some View {
        ZStack(alignment: .topLeading) {
            // TODO: Action
            Button(action: {}) {
                Image(.popUpIcon)
            }
            .padding(.leading, 17)
            
            VStack(spacing: 9) {
                Text("일기카드 생성하기")
                    .font(.SCoreRegular17)
                
                Text("답하고 싶은 질문을 선택해주세요")
                    .font(.SCoreLight12)
                
                Divider()
                    .frame(height: 1)
                    .background(Color(red: 0.58, green: 0.57, blue: 0.57))
            }
            .padding(.horizontal, 36)
        }
    }
    
    // 장문형
    private var LongGroup: some View {
        VStack(alignment: .leading, spacing: 16) {
            makeTitle(text: "장문형")
                .padding(.leading, 30)
            
            ScrollView(.horizontal) {
                LazyHStack(spacing: 16) {
                    ForEach(viewModel.questions.filter { $0.questionType == .long }, id: \.questionId) { question in
                        makeOptionItem(
                            item: question,
                            isSelected: Binding(
                                get: { question.isSelected },
                                set: { _ in viewModel.toggleSelection(for: question) }
                            )
                        )
                    }
                }
                .padding(.horizontal, 30)
            }
        }
    }
    
    // 단문형
    private var ShortGroup: some View {
        VStack(alignment: .leading, spacing: 16) {
            makeTitle(text: "단문형")
                .padding(.leading, 30)
            
            ScrollView(.horizontal) {
                LazyHStack(spacing: 16) {
                    ForEach(viewModel.questions.filter { $0.questionType == .short }, id: \.questionId) { question in
                        makeOptionItem(
                            item: question,
                            isSelected: Binding(
                                get: { question.isSelected },
                                set: { _ in viewModel.toggleSelection(for: question) }
                            )
                        )
                    }
                }
                .padding(.horizontal, 30)
            }
        }
    }
    
    // 선택형
    private var OptionalGroup: some View {
        VStack(alignment: .leading, spacing: 16) {
            makeTitle(text: "선택형")
                .padding(.leading, 30)
            
            ScrollView(.horizontal) {
                LazyHStack(spacing: 16) {
                    ForEach(viewModel.questions.filter { $0.questionType == .optional }, id: \.questionId) { question in
                        makeOptionItem(
                            item: question,
                            isSelected: Binding(
                                get: { question.isSelected },
                                set: { _ in viewModel.toggleSelection(for: question) }
                            )
                        )
                    }
                }
                .padding(.horizontal, 30)
            }
        }
    }
    
    // MARK: - Components
    private func makeTitle(text: String) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .frame(width: 60, height: 24)
                .foregroundStyle(.white)
            
            Text(text)
                .font(.SCoreLight13)
                .padding(.top, 1)
        }
    }
    
    private func makeOptionItem(
        item: Question,
        isSelected: Binding<Bool>
    ) -> some View {
        VStack(spacing: 4.2) {
            Button(action: {
                isSelected.wrappedValue.toggle()
            }) {
                Image(item.isSelected ? .checkBoxChecked : .unchecked)
                    .resizable()
                    .frame(width: 24, height: 24)
            }
            
            Spacer().frame(height: 5.5)
            
            if item.questionType == .optional, !item.answerOption?.isEmpty {
                VStack(spacing: 8.5) {
                    ForEach(item.answerOption, id: \.self) { option in
                        Text(option)
                    }
                }
            }
            
            Text(item.content)
                .font(.SCoreLight13)
                .multilineTextAlignment(.center)
            
            Text("From. \(item.questioner)")
                .font(.SCoreExtraLight11)
        }
        .frame(width: 170)
    }
}

#Preview {
    DiaryCardSelectView()
}
