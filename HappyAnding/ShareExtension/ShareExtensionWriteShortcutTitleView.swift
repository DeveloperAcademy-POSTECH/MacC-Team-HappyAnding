//
//  ShareExtensionWriteShortcutTitleView.swift
//  ShareExtension
//
//  Created by HanGyeongjun on 2022/11/22.
//

import SwiftUI

struct ShareExtensionWriteShortcutTitleView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var isWriting: Bool
    
    @State var shareExtensionLink: String
    @State var isShowingIconModal = false
    @State var isNameValid = false
    @State var isLinkValid = false
    @State var shortcut = Shortcuts(sfSymbol: "",
                                    color: "",
                                    title: "",
                                    subtitle: "",
                                    description: "",
                                    category: [String](),
                                    requiredApp: [String](),
                                    numberOfLike: 0,
                                    numberOfDownload: 0,
                                    author: "",
                                    shortcutRequirements: "",
                                    downloadLink: [""],
                                    curationIDs: [String]())
    
    let isEdit: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                
                ProgressView(value: 0.33, total: 1)
                    .padding(.bottom, 36)
                
                Button(action: {
                    isShowingIconModal = true
                }, label: {
                    if shortcut.sfSymbol.isEmpty {
                        ZStack(alignment: .center) {
                            Rectangle()
                                .fill(Color.Gray1)
                                .cornerRadius(12.35)
                                .frame(width: 84, height: 84)
                            
                            Image(systemName: "plus")
                                .font(.system(size: 24))
                                .frame(width: 84, height: 84)
                                .foregroundColor(.Gray5)
                        }
                        
                    } else {
                        ZStack(alignment: .center) {
                            Rectangle()
                                .fill(Color.fetchGradient(color: shortcut.color))
                                .cornerRadius(12.35)
                                .frame(width: 84, height: 84)
                            
                            Image(systemName: shortcut.sfSymbol)
                                .font(.system(size: 32))
                                .frame(width: 84, height: 84)
                                .foregroundColor(.Text_icon)
                        }
                    }
                })
                .padding(.bottom, 30)
                .sheet(isPresented: $isShowingIconModal) {
                    IconModalView(isShowingIconModal: $isShowingIconModal,
                                  iconColor: $shortcut.color,
                                  iconSymbol: $shortcut.sfSymbol)
                }
                
                ValidationCheckTextField(textType: .mandatory,
                                         isMultipleLines: false,
                                         title: "단축어 이름",
                                         placeholder: "단축어 이름을 입력하세요",
                                         lengthLimit: 20,
                                         isDownloadLinkTextField: false,
                                         content: $shortcut.title,
                                         isValid: $isNameValid
                )
                
                ValidationCheckTextField(textType: .mandatory,
                                         isMultipleLines: false,
                                         title: "단축어 링크",
                                         placeholder: "단축어 링크를 추가하세요",
                                         lengthLimit: 100,
                                         isDownloadLinkTextField: true   ,
                                         content: $shortcut.downloadLink[0],
                                         isValid: $isLinkValid
                )
                
                Spacer()
                
                NavigationLink(value: 1) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundColor(!shortcut.color.isEmpty && !shortcut.sfSymbol.isEmpty && isNameValid && isLinkValid ? .Primary : .Primary .opacity(0.13) )
                            .frame(maxWidth: .infinity, maxHeight: 52)
                        
                        Text("다음")
                            .foregroundColor(!shortcut.color.isEmpty && !shortcut.sfSymbol.isEmpty && isNameValid && isLinkValid ? .Text_Button : .Text_Button_Disable )
                            .Body1()
                    }
                }
                .disabled(shortcut.color.isEmpty || shortcut.sfSymbol.isEmpty || !isNameValid || !isLinkValid)
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
            .onAppear {
                shortcut.downloadLink[0] = shareExtensionLink
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .background(Color.Background)
            .navigationTitle(isEdit ? "단축어 편집" : "단축어 등록")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Int.self) { value in
                WriteShortcutdescriptionView(shortcut: $shortcut,
                                             isWriting: $isWriting,
                                             isEdit: isEdit)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("닫기")
                            .foregroundColor(.Gray5)
                    }
                }
            }
        }
    }
}