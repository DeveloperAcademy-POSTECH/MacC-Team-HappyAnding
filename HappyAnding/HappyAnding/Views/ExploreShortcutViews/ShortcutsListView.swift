//
//  ShortcutsListView.swift
//  HappyAnding
//
//  Created by KiWoong Hong on 2022/11/05.
//

import SwiftUI

struct ShortcutsListView: View {
    
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    @Binding var shortcuts:[Shortcuts]
    @State var navigationTitle = ""
    
    @State var isLastShortcut: Bool = false
    
    var categoryName: Category
    let navigationParentView: NavigationParentView
    
    var body: some View {
        ScrollView {
            
            scrollHeader
            
            LazyVStack(spacing: 0) {
                ForEach(Array(shortcuts.enumerated()), id: \.offset) { index, shortcut in
                    let data = NavigationReadShortcutType(shortcut: shortcut,
                                                          shortcutID: shortcut.id,
                                                          navigationParentView: self.navigationParentView)
                    NavigationLink(value: data) {
                        ShortcutCell(shortcut: shortcut,
                                     navigationParentView: self.navigationParentView)
                        
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                        .onAppear {
                            
                        }
                    }
                }
                
                Rectangle()
                    .fill(Color.Background)
                    .frame(height: 44)
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
            }
        }
        .scrollIndicators(.hidden)
        .navigationBarTitle(categoryName.translateName())
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.Background)
        .navigationBarBackground ({ Color.Background })
        .onAppear {
            self.shortcuts = shortcutsZipViewModel.shortcutsInCategory[categoryName.index]
        }
    }
    
    var scrollHeader: some View {
        VStack {
            Text(categoryName.fetchDescription())
        }
        .foregroundColor(.Gray5)
        .Body2()
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            Rectangle()
                .foregroundColor(Color.Gray1)
                .cornerRadius(12)
        )
        .padding(.vertical, 20)
        .padding(.horizontal, 16)
    }
}
