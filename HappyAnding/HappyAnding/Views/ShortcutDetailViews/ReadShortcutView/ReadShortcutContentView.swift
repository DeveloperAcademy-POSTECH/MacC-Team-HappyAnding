//
//  ReadShortcutContentView.swift
//  HappyAnding
//
//  Created by KiWoong Hong on 2022/10/24.
//

import SwiftUI

struct ReadShortcutContentView: View {
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    
    @Binding var shortcut: Shortcuts
    let profileImage: String = "person.crop.circle"
    
    var body: some View {
            VStack(alignment: .leading) {
                
                ReusableTextView(title: "단축어 설명", contents: shortcut.description, contentsArray: nil)
                    .padding(.bottom, 24)
                    .padding(.top, 16)
                
                categoryView
                    .padding(.bottom, 24)
                
                if !shortcut.requiredApp.isEmpty {
                    ReusableTextView(title: "단축어 사용에 필요한 앱", contents: nil, contentsArray: shortcut.requiredApp)
                        .padding(.bottom, 24)
                }
                
                if !shortcut.shortcutRequirements.isEmpty {
                    ReusableTextView(title: "단축어 사용을 위한 요구사항", contents: shortcut.shortcutRequirements, contentsArray: nil)
                }
                Spacer()
                    .frame(maxHeight: .infinity)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var categoryView: some View {
        VStack(alignment: .leading) {
            Text("카테고리")
                .Body2()
                .foregroundColor(.Gray4)
            
            HStack(spacing: 8) {
                ForEach(shortcut.category, id: \.self) { categoryName in
                    Text(translateName(categoryName))
                        .Body2()
                        .foregroundColor(.Gray5)
                }
            }
        }
    }
    private func translateName(_ categoryName: String) -> String {
        switch categoryName {
        case "education":
            return "교육"
        case "finance":
            return "금융"
        case "business":
            return "비즈니스"
        case "health":
            return "건강 및 피트니스"
        case "lifestyle":
            return "라이프스타일"
        case "weather":
            return "날씨"
        case "photo":
            return "사진 및 비디오"
        case "decoration":
            return "데코레이션/꾸미기"
        case "utility":
            return "유틸리티"
        case "sns":
            return "소셜 네트워킹"
        case "entertainment":
            return "엔터테인먼트"
        case "trip":
            return "여행"
        default:
            return ""
        }
    }
}

private struct ReusableTextView: View {
    
    let title: String
    let contents: String?
    let contentsArray: [String]?
    
    @State var heigth: CGFloat = 10000
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .Body2()
                .foregroundColor(Color.Gray4)
            if let contents {
                Text(contents)
                    .Body2()
                    .foregroundColor(Color.Gray5)
                    .lineLimit(nil)
            }
            if let contentsArray {
                ForEach(contentsArray, id: \.self) {
                    content in
                    Text(content)
                        .Body2()
                        .foregroundColor(Color.Gray5)
                        .lineLimit(nil)
                }
            }
        }
        .background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self,
                                value: geometryProxy.size)
            })
        .onPreferenceChange(SizePreferenceKey.self) { newSize in
            self.heigth = newSize.height
        }
        .frame(height: self.heigth)
    }
}

