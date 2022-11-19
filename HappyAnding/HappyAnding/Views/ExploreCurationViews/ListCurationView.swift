//
//  ListCurationView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//
import SwiftUI

enum CurationType: String {
    case myCuration = "내가 작성한 큐레이션"
    case userCuration = "큐레이션 모아보기"
}

/**
 Parameter
 - UserCurations: 화면에서 보여줘야할 큐레이션 리스트를 전달해주세요
 - type:  나의 큐레이션으로 접근하는 경우 .myCuration, 그외의 접근인 경우 .userCuration을 전달해주세요
 - title: curation의 제목이 있는 경우 전달해주세요. 리스트 상단부분에 들어갑니다.  예시) 스마트한 생활의 시작
 */

struct ListCurationView: View {
    
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    @Binding var userCurations: [Curation]
    let data: NavigationListCurationType
    
    var body: some View {
        ScrollView {
            LazyVStack {
                
                ForEach(Array(userCurations.enumerated()), id: \.offset) { index, curation in
                    
                    let data = NavigationReadUserCurationType(userCuration: curation,
                                                              navigationParentView: self.data.navigationParentView)
                    
                    NavigationLink(value: data) {
                        UserCurationCell(curation: curation,
                                         navigationParentView: self.data.navigationParentView)
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.Background)
                        .padding(.top, index == 0 ? 20 : 0 )
                        .padding(.bottom, index == userCurations.count - 1 ? 32 : 0)
                        
                        .onAppear {
                            if userCurations.last == curation && userCurations.count % 10 == 0 {
                                print(userCurations.count)
                                if self.data.isAllUser {
                                    shortcutsZipViewModel.fetchCurationLimit(isAdmin: false) { curations in
                                        userCurations.append(contentsOf: curations)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .scrollIndicators(.hidden)
        .navigationDestination(for: NavigationReadUserCurationType.self) { data in
            ReadUserCurationView(data: data)
        }
        .listStyle(.plain)
        .background(Color.Background.ignoresSafeArea(.all, edges: .all))
        .scrollContentBackground(.hidden)
        .navigationBarTitle(self.data.type.rawValue)
        .navigationBarTitleDisplayMode(.inline)
    }
}

//struct ListCurationView_Previews: PreviewProvider {
//    static var previews: some View {
//        ListCurationView(
//            userCurations: UserCuration.fetchData(number: 10),
//            type: CurationType.userCuration
//        )
//    }
//}
