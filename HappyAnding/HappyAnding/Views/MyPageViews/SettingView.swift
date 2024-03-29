//
//  SettingView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import MessageUI
import SwiftUI

import FirebaseAuth

struct SettingView: View {
    @EnvironmentObject var userAuth: UserAuth
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    
    @ObservedObject var webViewModel = WebViewModel()
    
    @AppStorage("signInStatus") var signInStatus = false
    @AppStorage("useWithoutSignIn") var useWithoutSignIn = false
    
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var isTappedEditNicknameButton = false
    @State var isTappedUserGradeButton = false
    @State var isShowingMailView = false
    @State var isTappedLogOutButton = false
    @State var isTappedSignOutButton = false
    @State var isTappedPrivacyButton = false
    
    var body: some View {
        ScrollView() {
            
            // MARK: - 버전 정보
            SettingCell(title: TextLiteral.settingViewVersion)
                .navigationLinkRouter(data: NavigationCheckVersion.first)
            
            // MARK: - 업데이트 소식
            SettingCell(title: "업데이트 소식")
                .navigationLinkRouter(data: NavigationUpdateInfo.first)
            
            if !useWithoutSignIn {
                divider
                
                Button {
                    isTappedEditNicknameButton = true
                } label: {
                    SettingCell(title: "닉네임 수정")
                }
                
                /*
                 // TODO: 알림 기능
                 Text("알림 설정")
                 .padding(.top, 16)
                 .padding(.bottom, 12)
                 
                 //TODO: 화면 연결 필요
                 NavigationLink(destination: EmptyView()) {
                 SettingCell(title: "알림 및 소리")
                 }
                 */
            }
            
            divider
            
            Group {
                //MARK: - 단축어 작성 등급
                Button {
                    isTappedUserGradeButton = true
                } label: {
                    FunctionCell(title: TextLiteral.shortcutGradeTitle)
                }
            }
            
            divider
            
            Group {
                // MARK: - 오픈소스 라이선스
                SettingCell(title: TextLiteral.settingViewOpensourceLicense)
                    .navigationLinkRouter(data: NavigationLisence.first)
                
                
                // MARK: - 개인정보처리방침 모달뷰
                Button {
                    self.isTappedPrivacyButton.toggle()
                } label: {
                    SettingCell(title: TextLiteral.settingViewPrivacyPolicy)
                }
                
                
                // MARK: - 개발팀에 관하여 버튼
                //TODO: Halogen의 꿈. 추후 스프린트 시 완성되면 적용 예정
                //            NavigationLink(destination: AboutTeamView()) {
                //                SettingCell(title: "개발팀에 관하여")
                //            }
                
                
                // MARK: - 개발자에게 연락하기 버튼
                Button(action : {
                    if MFMailComposeViewController.canSendMail() {
                        self.isShowingMailView.toggle()
                    }
                }) {
                    if MFMailComposeViewController.canSendMail() {
                        SettingCell(title: TextLiteral.settingViewContact)
                    }
                    else {
                        SettingCell(title: TextLiteral.settingViewContactMessage)
                            .multilineTextAlignment(.leading)
                    }
                }
            }
            
            divider
            
            Group {
                if useWithoutSignIn {
                    //MARK: - 로그인없이 둘러보기 시 로그인 버튼
                    Button {
                        useWithoutSignIn = false
                    } label: {
                        SettingCell(title: TextLiteral.settingViewLogin)
                    }
                } else {
                    // MARK: - 로그아웃 버튼
                    Button {
                        self.isTappedLogOutButton.toggle()
                    } label: {
                        SettingCell(title: TextLiteral.settingViewLogout)
                    }
                    .alert(TextLiteral.settingViewLogout, isPresented: $isTappedLogOutButton) {
                        Button(role: .cancel) {
                            
                        } label: {
                            Text(TextLiteral.cancel)
                        }
                        
                        Button(role: .destructive) {
                            logOut()
                        } label: {
                            Text(TextLiteral.settingViewLogout)
                        }
                    } message: {
                        Text(TextLiteral.settingViewLogoutMessage)
                    }
                    
                    // MARK: - 회원탈퇴 버튼
                    SettingCell(title: TextLiteral.settingViewWithdrawal)
                        .navigationLinkRouter(data: NavigationWithdrawal.first)
                }
            }
            
            Spacer()
        }
        .sheet(isPresented: $isTappedEditNicknameButton) {
            EditNicknameView()
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $isTappedUserGradeButton) {
            AboutShortcutGradeView()
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $isShowingMailView) {
            MailView(isShowing: self.$isShowingMailView, result: self.$result)
        }
        .sheet(isPresented: self.$isTappedPrivacyButton) {
            ZStack {
                PrivacyPolicyView(viewModel: webViewModel,
                                  isTappedPrivacyButton: $isTappedPrivacyButton,
                                  url: TextLiteral.settingViewPrivacyPolicyURL)
                .environmentObject(webViewModel)
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
                if webViewModel.isLoading {
                    ProgressView()
                }
            }
        }
        
        .padding(.horizontal, 16)
        .background(Color.shortcutsZipBackground)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    var divider: some View {
        Divider()
            .background(Color.gray1)
            .frame(width: UIScreen.screenWidth - 32)
    }
    
    private func logOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            userAuth.signOut()
            self.signInStatus = false
            shortcutsZipViewModel.resetUser()
            UserDefaults.shared.set(false, forKey: "isSignInForShareExtension")
        } catch {
            print(error.localizedDescription)
        }
    }
}
struct SettingCell: View {
    var title: String
    var body: some View {
        HStack {
            Text(title)
            Spacer()
        }
        .shortcutsZipBody1()
        .foregroundStyle(Color.gray4)
        .padding(.horizontal, 12)
        .padding(.vertical, 16)
    }
}

struct FunctionCell: View {
    var title: String
    var tag: String?
    
    var body: some View {
        HStack {
            Text(title)
                .shortcutsZipBody1()
                .foregroundStyle(Color.gray4)
            Spacer()
            if let tag {
                Text(tag)
                    .shortcutsZipBody2()
                    .foregroundStyle(Color.tagText)
                    .frame(height: 20)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(
                        Capsule()
                            .fill( Color.tagBackground )
                            .overlay(
                                Capsule()
                                    .strokeBorder(Color.shortcutsZipPrimary, lineWidth: 1))                        )
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 16)
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
