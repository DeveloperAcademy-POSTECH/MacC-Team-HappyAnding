//
//  MyPageView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import SwiftUI

struct MyPageView: View {
    
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    
    enum NavigationSettingView: Hashable, Equatable {
        case first
    }
    
    enum NavigationNicknameView: Hashable, Equatable {
        case first
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                
                //MARK: - 사용자 프로필
                
                HStack(spacing: 16) {
                    
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 60, weight: .medium))
                        .frame(width: 60, height: 60)
                        .foregroundColor(.Gray3)
                        .id(333)
                    
                    HStack {
                        Text(shortcutsZipViewModel.userInfo?.nickname ?? "User")
                            .Title1()
                            .foregroundColor(.Gray5)
                        
                        NavigationLink(value: NavigationNicknameView.first) {
                            Image(systemName: "square.and.pencil")
                                .Title2()
                                .foregroundColor(.Gray4)
                        }
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
                .padding(.top, 35)
                
                //TODO: - 각 뷰에 해당하는 단축어 목록 전달하도록 변경 필요
                
                // MARK: - 나의 단축어
                
                MyShortcutCardListView(shortcuts: shortcutsZipViewModel.shortcutsMadeByUser,
                                       navigationParentView: .myPage)
                
                // MARK: - 내가 작성한 큐레이션
                
                UserCurationListView(data: NavigationListCurationType(type: .myCuration,
                                                                      title: "내가 작성한 추천 모음집",
                                                                      isAllUser: false,
                                                                      navigationParentView: .myPage,
                                                                      curation: shortcutsZipViewModel.curationsMadeByUser))
                .frame(maxWidth: .infinity)
                
                // MARK: - 좋아요한 단축어
                
                MyPageShortcutListCell(type: .myLovingShortcut, shortcuts: shortcutsZipViewModel.shortcutsUserLiked)
                
                // MARK: -다운로드한 단축어
                
                MyPageShortcutListCell(type: .myDownloadShortcut, shortcuts: shortcutsZipViewModel.shortcutsUserDownloaded)
                    .padding(.bottom, 44)
            }
        }
        .navigationBarTitle("프로필")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem {
                NavigationLink(value: NavigationSettingView.first) {
                    Image(systemName: "gearshape.fill")
                        .Headline()
                        .foregroundColor(.Gray5)
                }
            }
        }
        .scrollIndicators(.hidden)
        .background(Color.Background)
        .navigationDestination(for: NavigationNicknameView.self) { _ in
            EditNicknameView()
        }
        .navigationDestination(for: NavigationSettingView.self) { _ in
            SettingView()
        }
    }
}

struct MyPageShortcutListCell: View {
    var type: SectionType
    let shortcuts: [Shortcuts]
    
    var data: NavigationListShortcutType {
        NavigationListShortcutType(sectionType: self.type,
                                   shortcuts: self.shortcuts,
                                   navigationParentView: .myPage)
    }
    var body: some View {
        NavigationLink(value: data) {
            HStack() {
                Text(type == .myLovingShortcut ? "좋아요한 단축어" : "다운로드한 단축어")
                    .Title2()
                    .foregroundColor(.Gray5)
                    .padding(.trailing, 9)
                Text("\(shortcuts.count)개")
                    .Body2()
                    .foregroundColor(Color.Tag_Text)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill( Color.Tag_Background )
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .strokeBorder(Color.Primary, lineWidth: 1))
                    )
                Spacer()
                Image(systemName: "chevron.forward")
                    .foregroundColor(.Gray5)
                    .font(Font(UIFont.systemFont(ofSize: 20, weight: .medium)))
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
        }
    }
}
