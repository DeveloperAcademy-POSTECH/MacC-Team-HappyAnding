//
//  WriteShortcutTagView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import SwiftUI

struct WriteShortcutTagView: View {
    
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    @EnvironmentObject var writeShortcutNavigation: WriteShortcutNavigation
    
    @Binding var isWriting: Bool
    @Binding var shortcut: Shortcuts
    
    @State var isShowingCategoryModal = false
    @State var isRequirementValid = false
    
    @State var existingCategory: [String] = []
    @State var newCategory: [String] = []
    
    let isEdit: Bool
    
    var body: some View {
        VStack {
            ProgressView(value: 1, total: 1)
                .padding(.bottom, 36)
            
            HStack {
                Text("카테고리")
                    .Headline()
                    .padding(.leading, 16)
                    .foregroundColor(.Gray5)
                Text("최대 3개 선택")
                    .Footnote()
                    .foregroundColor(.Gray3)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            categoryList(isShowingCategoryModal: $isShowingCategoryModal, selectedCategories: $shortcut.category)
                .padding(.bottom, 32)
            
            HStack {
                Text("단축어 사용에 필요한 앱")
                    .Headline()
                    .padding(.leading, 16)
                    .foregroundColor(.Gray5)
                Text("(선택입력)")
                    .Footnote()
                    .foregroundColor(.Gray3)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            relatedAppList(relatedApps: $shortcut.requiredApp)
                .padding(.bottom, 32)
            
            ValidationCheckTextField(textType: .optional,
                                     isMultipleLines: true,
                                     title: "단축어 사용을 위한 요구사항",
                                     placeholder: "단축어를 사용하기 위해서 필수적으로 요구되는 내용이 있다면, 작성해주세요",
                                     lengthLimit: 100,
                                     isDownloadLinkTextField: false,
                                     content: $shortcut.shortcutRequirements,
                                     isValid: $isRequirementValid
            )
            
            Spacer()
            
            Button(action: {
                if let index = shortcutsZipViewModel.allShortcuts.firstIndex(where: {$0.id == shortcut.id}) {
                    shortcutsZipViewModel.allShortcuts[index] = shortcut
                }
                
                shortcut.author = shortcutsZipViewModel.currentUser()
                if isEdit {
                    //뷰모델의 카테고리별 단축어 목록에서 정보 수정
                    newCategory = shortcut.category
                    existingCategory.forEach { category in
                        if !shortcut.category.contains(category) {
                            newCategory.removeAll(where: { $0 == category })
                            shortcutsZipViewModel.shortcutsInCategory[Category(rawValue: category)!.index].removeAll(where: { $0.id == shortcut.id })
                        } else {
                            newCategory.removeAll(where: { $0 == category })
                            if let index = shortcutsZipViewModel.shortcutsInCategory[Category(rawValue: category)!.index].firstIndex(where: { $0.id == shortcut.id}) {
                                shortcutsZipViewModel.shortcutsInCategory[Category(rawValue: category)!.index][index] = shortcut
                            }
                        }
                    }
                    newCategory.forEach { category in
                        if !shortcutsZipViewModel.isFirstFetchInCategory[Category(rawValue: category)!.index] {
                            shortcutsZipViewModel.shortcutsInCategory[Category(rawValue: category)!.index].insert(shortcut, at: 0)
                        }
                    }
                    
                    //서버 데이터 변경
                    shortcutsZipViewModel.setData(model: shortcut)
                    //TODO: 셀정보에 변경사항이 있을 경우에만 함수를 호출하도록 변경 필요
                    shortcutsZipViewModel.updateShortcutInCuration(
                        shortcutCell: ShortcutCellModel(
                            id: shortcut.id,
                            sfSymbol: shortcut.sfSymbol,
                            color: shortcut.color,
                            title: shortcut.title,
                            subtitle: shortcut.subtitle,
                            downloadLink: shortcut.downloadLink.last!
                        ),
                        curationIDs: shortcut.curationIDs
                    )
                } else {
                    //새로운 단축어 생성 및 저장
                    // 뷰모델에 추가
                    shortcutsZipViewModel.shortcutsMadeByUser.insert(shortcut, at: 0)
                    
                    // 서버에 추가
                    shortcutsZipViewModel.setData(model: shortcut)
                }
                
                
                isWriting.toggle()
            
                writeShortcutNavigation.navigationPath = .init()
                
            }, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(!shortcut.category.isEmpty && isRequirementValid ? .Primary : .Primary .opacity(0.13) )
                        .frame(maxWidth: .infinity, maxHeight: 52)
                    
                    Text("완료")
                        .foregroundColor(!shortcut.category.isEmpty && isRequirementValid ? .Text_Button : .Text_Button_Disable )
                        .Body1()
                }
            })
            .disabled(shortcut.category.isEmpty || !isRequirementValid)
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .onAppear() {
            existingCategory = shortcut.category
        }
        .navigationTitle(isEdit ? "단축어 편집" :"단축어 등록")
        .ignoresSafeArea(.keyboard)
        .background(Color.Background)
    }
    
    struct categoryList: View {
        @Binding var isShowingCategoryModal: Bool
        @Binding var selectedCategories: [String]
        
        var body: some View {
            ScrollView(.horizontal) {
                HStack(spacing: 8) {
                    ForEach(selectedCategories, id:\.self) { item in
                        CategoryTag(item: item, items: $selectedCategories)
                    }
                    
                    Button(action: {
                        isShowingCategoryModal = true
                    }, label: {
                        HStack {
                            Image(systemName: "plus")
                            Text("카테고리 추가")
                        }
                    })
                    .modifier(CellModifier(foregroundColor: Color.Gray3))
                    .sheet(isPresented: $isShowingCategoryModal) {
                        CategoryModalView(isShowingCategoryModal: $isShowingCategoryModal, selectedCategories: $selectedCategories)
                            .presentationDetents([.fraction(0.7)])
                            .presentationDragIndicator(.visible)
                    }
                }
            }
            .padding(.leading, 16)
        }
    }
    
    struct relatedAppList: View {
        @Binding var relatedApps: [String]
        
        @FocusState private var isFocused: Bool
        @State var isTextFieldShowing = false
        @State var relatedApp = ""
        
        var body: some View {
            ScrollView(.horizontal) {
                HStack(spacing: 8) {
                    ForEach(relatedApps, id:\.self) { item in
                        RelatedAppTag(item: item, items: $relatedApps)
                    }
                    
                    if isTextFieldShowing {
                        TextField("", text: $relatedApp)
                            .disableAutocorrection(true)
                            .textInputAutocapitalization(.never)
                            .modifier(ClearButton(text: $relatedApp))
                            .focused($isFocused)
                            .onAppear {
                                isFocused = true
                            }
                            .onChange(of: isFocused) { _ in
                                if !isFocused {
                                    if !relatedApp.isEmpty {
                                        relatedApps.append(relatedApp)
                                        relatedApp = ""
                                    }
                                    isTextFieldShowing = false
                                }
                            }
                            .modifier(CellModifier(foregroundColor: Color.Gray4))
                    }
                    
                    Button(action: {
                        isTextFieldShowing = true
                        isFocused = true
                    }, label: {
                        HStack {
                            Image(systemName: "plus")
                            Text("앱 추가")
                        }
                    })
                    .modifier(CellModifier(foregroundColor: Color.Gray3))
                }
            }
            .padding(.leading, 16)
        }
    }
    
    struct CategoryTag: View {
        var item: String
        @Binding var items: [String]
        
        var body: some View {
            HStack {
                Text(Category.withLabel(item)!.translateName())
                
                Button(action: {
                    items.removeAll { $0 == item }
                }, label: {
                    Image(systemName: "xmark")
                })
            }
            .modifier(CellModifier(foregroundColor: Color.Category_Pick_Text,
                                   backgroundColor: Color.Tag_Pick_Background,
                                   strokeColor: Color.Primary))
        }
    }
    
    struct RelatedAppTag: View {
        var item: String
        @Binding var items: [String]
        
        var body: some View {
            HStack {
                Button(action: {
                    //TODO: 탭 되었을 때 수정 로직 추가
                }, label: {
                    Text(item)
                })
                
                Button(action: {
                    items.removeAll { $0 == item }
                }, label: {
                    Image(systemName: "xmark")
                })
            }
            .modifier(CellModifier(foregroundColor: Color.Category_Pick_Text,
                                   backgroundColor: Color.Tag_Pick_Background,
                                   strokeColor: Color.Primary))
        }
    }
    
    struct CellModifier: ViewModifier {
        @State var foregroundColor: Color
        @State var backgroundColor = Color.clear
        @State var strokeColor = Color.Gray4
        
        public func body(content: Content) -> some View {
            content
                .Body2()
                .foregroundColor(foregroundColor)
                .frame(height: 46)
                .padding(.horizontal)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill( backgroundColor )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .strokeBorder(strokeColor, lineWidth: 1))
                )
        }
    }
    
    struct ClearButton: ViewModifier {
        @Binding var text: String
        
        public func body(content: Content) -> some View {
            HStack {
                content
                Button(action: {
                    self.text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .Body2()
                        .foregroundColor(.Gray4)
                }
            }
        }
    }
}
/*
struct WriteShortcutTagView_Previews: PreviewProvider {
    static var previews: some View {
        WriteShortcutTagView(isWriting: .constant(true), isEdit: false)
    }
}
*/
