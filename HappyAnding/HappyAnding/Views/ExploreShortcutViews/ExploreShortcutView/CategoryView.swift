//
//  CategoryView.swift
//  HappyAnding
//
//  Created by KiWoong Hong on 2022/10/22.
//

import SwiftUI

struct CategoryView: View {
    @Binding var shortcuts: [Shortcuts]?
    var body: some View {
        VStack {
            HStack {
                Text("카테고리 모아보기")
                    .Title2()
                    .foregroundColor(Color.Gray5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                NavigationLink(value: 0, label: {
                    Text("더보기")
                        .Footnote()
                        .foregroundColor(Color.Gray4)
                        .padding(.trailing, 16)
                })
                .navigationDestination(for: Int.self, destination: { id in
                    ListCategoryView(shortcuts: $shortcuts)
                })
            }
                
            .padding(.leading, 16)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                ForEach(Array(Category.allCases.enumerated()), id: \.offset) { index, value in
                    if index < 6 {
                        NavigationLink(value: shortcuts) {
                            CategoryCellView(categoryName: value.translateName())
                        }
                        .navigationDestination(for: [Shortcuts].self, destination: { shortcuts in
                            ShortcutsListView(shortcuts: $shortcuts, categoryName: value, sectionType: SectionType.download)
                        })
                        
                    }
                }
                
            }
            
            .padding(.horizontal, 16)
        }
    }
}

struct CategoryCellView: View {
    
    let categoryName: String
    
    var body: some View {
        RoundedRectangle(cornerSize: CGSize(width: 12, height: 12))
            .stroke(Color.Gray1, lineWidth: 1)
            .background(Color.White)
            .cornerRadius(12)
            .frame(maxWidth: .infinity, minHeight:48, maxHeight: 48)
            .overlay {
                Text(categoryName)
                    .Body2()
                    .foregroundColor(Color.Gray5)
            }
    }
}

//struct CategoryView_Previews: PreviewProvider {
//    static var previews: some View {
//        CategoryView()
//    }
//}
