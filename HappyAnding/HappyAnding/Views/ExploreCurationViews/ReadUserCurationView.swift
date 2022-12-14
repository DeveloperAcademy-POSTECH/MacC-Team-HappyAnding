//
//  ReadUserCurationView.swift
//  HappyAnding
//
//  Created by HanGyeongjun on 2022/10/22.
//

import SwiftUI

struct ReadUserCurationView: View {
    
    @Environment(\.presentationMode) var presentation: Binding<PresentationMode>
    
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    @StateObject var writeCurationNavigation = WriteCurationNavigation()
    @State var authorInformation: User? = nil
    
    @State var isWriting = false
    @State var isTappedEditButton = false
    @State var isTappedShareButton = false
    @State var isTappedDeleteButton = false
    @State var data: NavigationReadUserCurationType
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            ZStack(alignment: .bottom) {
                
                GeometryReader { geo in
                    let yOffset = geo.frame(in: .global).minY
                    
                    Color.White
                        .frame(width: geo.size.width, height: 371 + (yOffset > 0 ? yOffset : 0))
                        .offset(y: yOffset > 0 ? -yOffset : 0)
                }
                .frame(minHeight: 371)
                
                VStack {
                    userInformation
                        .padding(.top, 103)
                        .padding(.bottom, 22)
                    
                    UserCurationCell(curation: data.userCuration,
                                     navigationParentView: data.navigationParentView)
                }
            }
            .background(Color.white)
            .padding(.bottom, 12)
            
            VStack(spacing: 0){
                ForEach(self.data.userCuration.shortcuts, id: \.self) { shortcut in
                    let data = NavigationReadShortcutType(shortcutID: shortcut.id,
                                                          navigationParentView: self.data.navigationParentView)
                    
                    NavigationLink(value: data) {
                        ShortcutCell(shortcutCell: shortcut,
                                     navigationParentView: self.data.navigationParentView)
                    }
                }
            }
            .padding(.bottom, 44)
            
        }
        .onChange(of: isWriting) { _ in
            if !isWriting {
                if let updatedCuration = shortcutsZipViewModel.fetchCurationDetail(curationID: data.userCuration.id) {
                    data.userCuration = updatedCuration
                }
            }
        }
        .background(Color.Background.ignoresSafeArea(.all, edges: .all))
        .scrollContentBackground(.hidden)
        .edgesIgnoringSafeArea([.top])
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: readCurationViewButtonByUser())
        .fullScreenCover(isPresented: $isWriting) {
            NavigationStack(path: $writeCurationNavigation.navigationPath) {
                WriteCurationSetView(isWriting: $isWriting,
                                     curation: self.data.userCuration,
                                     isEdit: true)
            }
            .environmentObject(writeCurationNavigation)
        }
        .fullScreenCover(isPresented: $isWriting) {
            NavigationStack(path: $writeCurationNavigation.navigationPath) {
                WriteCurationSetView(isWriting: $isWriting,
                                     curation: self.data.userCuration,
                                     isEdit: true)
            }
            .environmentObject(writeCurationNavigation)
        }
        .alert("??? ??????", isPresented: $isTappedDeleteButton) {
            Button(role: .cancel) {
                self.isTappedDeleteButton.toggle()
            } label: {
                Text("??????")
            }
            
            Button(role: .destructive) {
                shortcutsZipViewModel.deleteData(model: self.data.userCuration)
                shortcutsZipViewModel.curationsMadeByUser = shortcutsZipViewModel.curationsMadeByUser.filter { $0.id != self.data.userCuration.id }
                presentation.wrappedValue.dismiss()
            } label: {
                Text("??????")
            }
        } message: {
            Text("?????? ?????????????????????????")
        }
    }
    
    var userInformation: some View {
        ZStack {
            if let data = NavigationProfile(userInfo: self.authorInformation) {
                NavigationLink(value: data) {
                    HStack {
                        Image(systemName: "person.crop.circle.fill")
                            .font(.system(size: 28, weight: .medium))
                            .frame(width: 28, height: 28)
                            .foregroundColor(.Gray3)
                        
                        Text(authorInformation?.nickname ?? "????????? ?????????")
                            .Headline()
                            .foregroundColor(.Gray4)
                        Spacer()
                    }
                }
                .disabled(authorInformation == nil)
                .padding(.horizontal, 30)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .frame(height: 48)
                        .foregroundColor(.Gray1)
                        .padding(.horizontal, 16)
                )
            }
        }
        .onAppear {
            shortcutsZipViewModel.fetchUser(userID: self.data.userCuration.author,
                                            isCurrentUser: false) { user in
                authorInformation = user
            }
            data.userCuration.shortcuts = data.userCuration.shortcuts.sorted { $0.title < $1.title }
        }
    }
}


extension ReadUserCurationView {
    
    @ViewBuilder
    private func readCurationViewButtonByUser() -> some View {
        if self.data.userCuration.author == shortcutsZipViewModel.currentUser() {
            myCurationMenu
        } else {
            shareButton
        }
    }
    
    private var myCurationMenu: some View {
        Menu(content: {
            Section {
                editButton
                shareButton
                deleteButton
            }
        }, label: {
            Image(systemName: "ellipsis")
                .foregroundColor(.Gray4)
        })
    }
    
    private var editButton: some View {
        Button {
            self.isWriting.toggle()
        } label: {
            Label("??????", systemImage: "square.and.pencil")
        }
    }
    
    private var shareButton: some View {
        Button(action: {
            shareCuration()
        }) {
            Label("??????", systemImage: "square.and.arrow.up")
                .foregroundColor(.Gray4)
                .fontWeight(.medium)
        }
    }
    
    private var deleteButton: some View {
        Button(role: .destructive, action: {
            isTappedDeleteButton.toggle()
        }) {
            Label("??????", systemImage: "trash.fill")
        }
    }
    
    private func shareCuration() {
        guard let deepLink = URL(string: "ShortcutsZip://myPage/CurationDetailView?curationID=\(data.userCuration.id)") else { return }
        
        let activityVC = UIActivityViewController(activityItems: [deepLink], applicationActivities: nil)
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        guard let window = windowScene?.windows.first else { return }
        window.rootViewController?.present(activityVC, animated: true, completion: nil)
    }
}

