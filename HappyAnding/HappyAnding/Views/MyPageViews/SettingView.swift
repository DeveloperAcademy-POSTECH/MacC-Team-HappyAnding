//
//  SettingView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import SwiftUI

struct SettingView: View {
    var body: some View {
        VStack(alignment: .leading) {
            //            Text("알림 설정")
            //                .padding(.top, 16)
            //                .padding(.bottom, 12)
            //
            //            //TODO: 화면 연결 필요
            //            NavigationLink(destination: EmptyView()) {
            //                SettingCell(title: "알림 및 소리")
            //            }
            
            SettingCell(title: "버전정보", version: "1.0.0")
            SettingCell(title: "개발자에게 연락하기")
                .onTapGesture {
                    //TODO: 클릭 시 이벤트 연결 필요
                    
                }
            SettingCell(title: "로그아웃")
                .onTapGesture {
                    //TODO: 클릭 시 이벤트 연결 필요
                    print("로그아웃")
                }
            Spacer()
        }
        .padding(.horizontal, 16)
        .background(Color.Background)
        .navigationBarTitleDisplayMode(.inline)
    }
}
struct SettingCell: View {
    var title: String
    var version: String?
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            if let version {Text(version)}
        }
        .Body1()
        .foregroundColor(.Gray4)
        .padding(.horizontal, 12)
        .padding(.vertical, 16)
    }
    
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
