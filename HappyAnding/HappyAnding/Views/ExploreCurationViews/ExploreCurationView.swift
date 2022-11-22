//
//  ExploreCurationView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import SwiftUI

struct ExploreCurationView: View {
    
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                
                //앱 큐레이션
                adminCurationsFrameiew(adminCurations: shortcutsZipViewModel.adminCurations)
                    .padding(.top, 20)
                    .padding(.bottom, 32)
                
                //나의 큐레이션
                /*
                UserCurationListView(data: NavigationListCurationType(type: .myCuration,
                                                                      title: "내가 작성한 큐레이션",
                                                                      isAllUser: false,
                                                                      navigationParentView: .curations),
                                     userCurations: $shortcutsZipViewModel.curationsMadeByUser)
                .padding(.bottom, 20)
                */
                
                //땡땡니을 위한 모음집
                CurationListView(data: NavigationListCurationType(type: .personalCuration,
                                                                  title: "",
                                                                  isAllUser: true,
                                                                  navigationParentView: .curations),
                                 userCurations: $shortcutsZipViewModel.userCurations)
                //추천 유저 큐레이션
                CurationListView(data: NavigationListCurationType(type: .userCuration,
                                                                  title: "큐레이션 모아보기",
                                                                  isAllUser: true,
                                                                  navigationParentView: .curations),
                                 userCurations: $shortcutsZipViewModel.userCurations)
            }
            .padding(.bottom, 32)
        }
        .navigationBarTitle(Text("큐레이션 둘러보기"))
        .navigationBarTitleDisplayMode(.large)
        .scrollIndicators(.hidden)
        .background(Color.Background)
    }
}

struct adminCurationsFrameiew: View {
    
    let adminCurations: [Curation]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .bottom) {
                Text("숏컷집 추천 큐레이션")
                    .Title2()
                    .foregroundColor(.Gray5)
                    .onTapGesture { }
                Spacer()
                //추후에 어드민큐레이션에도 더보기 버튼 들어갈 수 있을 것 같아서 추가해놓은 코드입니다.
                //                NavigationLink(destination: 더보기 눌렀을 때 뷰이름 입력) {
                //                    Text("더보기")
                //                        .Footnote()
                //                        .foregroundColor(.Gray4)
                //                }
            }
            .padding(.horizontal, 16)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(adminCurations, id: \.id) { curation in
                        NavigationLink(value: curation) {
                            AdminCurationCell(adminCuration: curation)
                        }
                    }
                }
                .padding(.leading, 16)
                .padding(.trailing, 8)
            }
        }
        .navigationDestination(for: Curation.self) { data in
            ReadAdminCurationView(curation: data)
        }
    }
}

