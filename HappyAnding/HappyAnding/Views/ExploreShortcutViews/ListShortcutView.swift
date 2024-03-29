//
//  ListShortcutView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/20.
//

import SwiftUI

/// - parameters:
/// sectionType: 다운로드 순위에서 접근할 시, .download를, 사랑받는 앱에서 접근시 .popular를 넣어주세요.
struct ListShortcutView: View {
    
    @StateObject var viewModel: ListShortcutViewModel
    
    var body: some View {
        if viewModel.shortcuts.count == 0 {
            Text("아직 \(viewModel.sectionType.title)가 없어요")
                .shortcutsZipBody2()
                .foregroundStyle(Color.gray4)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
                .background(Color.shortcutsZipBackground.ignoresSafeArea(.all, edges: .all))
                .navigationTitle(viewModel.sectionType.title)
                .navigationBarTitleDisplayMode(.inline)
        } else {
            ScrollView {
                LazyVStack(spacing: 0) {
                    
                    //TODO: 무한 스크롤을 위한 업데이트 함수 필요
                    makeShortcutCellList(viewModel.shortcuts)
                    
                }
                .padding(.top, 16)
                .padding(.bottom, 44)
            }
            .listRowBackground(Color.shortcutsZipBackground)
            .listStyle(.plain)
            .background(Color.shortcutsZipBackground.ignoresSafeArea(.all, edges: .all))
            .scrollContentBackground(.hidden)
            .navigationTitle(viewModel.sectionType.title)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackground ({ Color.shortcutsZipBackground })
        }
    }
    
    @ViewBuilder
    private func makeShortcutCellList(_ shortcuts: [Shortcuts]) -> some View {
        ForEach(shortcuts.indices, id: \.self) { index in
            let shortcut = shortcuts[index]
            ShortcutCell(shortcut: shortcut,
                         rankNumber: (viewModel.sectionType == .download) ? index : nil,
                         navigationParentView: .shortcuts)
            .navigationLinkRouter(data: shortcut)
        }
    }
}
