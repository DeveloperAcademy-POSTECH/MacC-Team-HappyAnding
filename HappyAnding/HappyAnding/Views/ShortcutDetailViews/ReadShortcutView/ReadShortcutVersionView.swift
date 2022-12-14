//
//  ReadShortcutVersionView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/11/21.
//

import SwiftUI

struct ReadShortcutVersionView: View {
    
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    @Environment(\.openURL) var openURL
    
    @Binding var shortcut: Shortcuts
    @Binding var isUpdating: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
        if shortcut.updateDescription.count == 1 {
            Text("아직 업데이트된 버전이 없습니다.")
                .Body2()
                .foregroundColor(.Gray4)
                .padding(.top, 16)
            
            Spacer()
                .frame(maxHeight: .infinity)
            
        } else {
                Text("업데이트 내용")
                    .Body2()
                    .foregroundColor(.Gray4)
                ForEach(Array(zip(shortcut.updateDescription, shortcut.updateDescription.indices)), id: \.0) { data, index in
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Ver \(shortcut.updateDescription.count - index).0")
                                .Body2()
                                .foregroundColor(.Gray5)
                            
                            Spacer()
                            Text(shortcut.date[index].getVersionUpdateDateFormat())
                                .Body2()
                                .foregroundColor(.Gray3)
                        }
                        if data != "" {
                            Text(data)
                                .Body2()
                                .foregroundColor(.Gray5)
                        }
                        if index != 0 {
                            Button {
                                if let url = URL(string: shortcut.downloadLink[index]) {
                                    if (shortcutsZipViewModel.userInfo?.downloadedShortcuts.firstIndex(where: { $0.id == shortcut.id })) == nil {
                                        shortcut.numberOfDownload += 1
                                    }
                                    shortcutsZipViewModel.updateNumberOfDownload(shortcut: shortcut, downloadlinkIndex: index)
                                    openURL(url)
                                }
                            } label: {
                                Text("이전 버전 다운로드")
                                    .Body2()
                                    .foregroundColor(.Primary)
                            }
                        }
                        Divider()
                            .foregroundColor(.Gray1)
                        
                    }
                }
                Spacer()
                    .frame(maxHeight: .infinity)
            }
        }
            .padding(.top, 16)
    }
}
