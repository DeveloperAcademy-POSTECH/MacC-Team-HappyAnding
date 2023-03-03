//
//  ExploreCurationView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import SwiftUI

struct ExploreCurationView: View {
    
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    
    @AppStorage("useWithoutSignIn") var useWithoutSignIn = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                
                //앱 큐레이션
                adminCurationsFrameView(adminCurations: shortcutsZipViewModel.adminCurations)
                
                //사용자를 위한 모음집
                if !useWithoutSignIn {
                    CurationListView(data: NavigationListCurationType(type: .personalCuration,
                                                                      title: "",
                                                                      isAllUser: false,
                                                                      navigationParentView: .curations,
                                                                      curation: shortcutsZipViewModel.personalCurations))
                }
                
                //추천 유저 큐레이션
                CurationListView(data: NavigationListCurationType(type: .userCuration,
                                                                  title: TextLiteral.exploreCurationViewUserCurations,
                                                                  isAllUser: true,
                                                                  navigationParentView: .curations,
                                                                  curation: shortcutsZipViewModel.userCurations))
            }
            .padding(.top, 20)
            .padding(.bottom, 44)
            .onChange(of: shortcutsZipViewModel.userCurations) { _ in
                shortcutsZipViewModel.refreshPersonalCurations()
            }
        }
        .navigationBarTitle(Text(TextLiteral.exploreCurationViewTitle))
        .navigationBarTitleDisplayMode(.large)
        .scrollIndicators(.hidden)
        .background(Color.shortcutsZipBackground)
    }
}

struct adminCurationsFrameView: View {
    
    let adminCurations: [Curation]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .bottom) {
                SubtitleTextView(text: TextLiteral.exploreCurationViewAdminCurations)
                    .id(222)
                
                Spacer()
                //추후에 어드민큐레이션에도 더보기 버튼 들어갈 수 있을 것 같아서 추가해놓은 코드입니다.
                //                NavigationLink(destination: 더보기 눌렀을 때 뷰이름 입력) {
                //                    Text("더보기")
                //                        .Footnote()
                //                        .foregroundColor(.gray4)
                //                }
            }
            .padding(.horizontal, 16)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(adminCurations, id: \.id) { curation in
                        AdminCurationCell(adminCuration: curation)
                            .navigationLinkRouter(data: curation)
                    }
                }
                .padding(.leading, 16)
                .padding(.trailing, 8)
            }
        }
    }
}

