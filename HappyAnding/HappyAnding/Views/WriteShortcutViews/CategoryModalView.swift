//
//  CategoryModalView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import SwiftUI

struct CategoryModalView: View {
    
    @Binding var isShowingCategoryModal: Bool
    @Binding var selectedCategories: [String]
    
    private let screenHeight = UIScreen.screenHeight
    private let gridLayout = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ZStack {
            Color.shortcutsZipBackground
                .ignoresSafeArea()
            VStack {
                HStack(spacing: 0) {
                    Button {
                        self.isShowingCategoryModal = false
                    } label: {
                        Text(TextLiteral.close)
                            .foregroundStyle(Color.gray5)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 16)
                    }
                    
                    Text(TextLiteral.categoryModalViewTitle)
                        .shortcutsZipHeadline()
                        .frame(maxWidth: .infinity)
                    
                    Spacer()
                        .frame(maxWidth: .infinity)
                }
                
                Spacer()
                    .frame(height: screenHeight * 0.7 * 0.04)
                
                LazyVGrid(columns: gridLayout, spacing: 12) {
                    ForEach(Category.allCases, id: \.self) { item in
                        CategoryButton(item: item, items: $selectedCategories)
                    }
                }
                .padding(.horizontal, 16)
                
                Spacer()
                    .frame(height: screenHeight * 0.7 * 0.04)
                
                Button(action: {
                    isShowingCategoryModal = false
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(!selectedCategories.isEmpty ? Color.shortcutsZipPrimary : Color.shortcutsZipPrimary.opacity(0.13) )
                            .frame(maxWidth: .infinity, maxHeight: 52)
                        
                        Text(TextLiteral.done)
                            .foregroundStyle(!selectedCategories.isEmpty ? Color.textIcon : Color.textButtonDisable)
                            .shortcutsZipBody1()
                    }
                })
                .disabled(selectedCategories.isEmpty)
                .padding(.horizontal, 16)
            }
        }
    }
    
    struct CategoryButton: View {
        let item: Category
        @Binding var items: [String]
        
        var body: some View {
            Button(action: {
                if items.contains(item.category) {
                    items.removeAll { $0 == item.category }
                } else {
                    if items.count < 3 {
                        items.append(item.category)
                    }
                }
            }, label: {
                Text(item.translateName())
                    .shortcutsZipBody2()
                    .tag(item.category)
                    .foregroundStyle(items.contains(item.category) ? Color.categoryPickText : Color.gray3)
                    .frame(maxWidth: .infinity, minHeight: UIScreen.screenHeight * 0.7 * 0.08)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(items.contains(item.category) ? Color.categoryPickFill : .clear)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .strokeBorder(items.contains(item.category) ? Color.shortcutsZipPrimary : Color.gray3, lineWidth: 1)
                            )
                    )
                
            })
        }
    }
}
