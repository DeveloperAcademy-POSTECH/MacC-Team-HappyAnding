//
//  WriteCurationInfoView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import SwiftUI

struct WriteCurationInfoView: View {
    
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    @EnvironmentObject var writeCurationNavigation: WriteCurationNavigation
    
    @State var isValidTitle = false
    @State var isValidDescription = false
    
    @Binding var curation: Curation
    @Binding var isWriting: Bool
    
    let isEdit: Bool
    @Binding var deletedShortcutCells: [ShortcutCellModel]
    
    private var isIncomplete: Bool {
        !(isValidTitle && isValidDescription)
    }
    
    var body: some View {
        VStack(spacing: 24) {
            ProgressView(value: 2, total: 2)
            
            ValidationCheckTextField(textType: .mandatory,
                                     isMultipleLines: false,
                                     title: "추천 모음집 이름",
                                     placeholder: "추천 모음집의 이름을 입력하세요",
                                     lengthLimit: 20,
                                     isDownloadLinkTextField: false,
                                     content: $curation.title,
                                     isValid: $isValidTitle)
            .padding(.top, 12)
            
            ValidationCheckTextField(textType: .mandatory,
                                     isMultipleLines: true,
                                     title: "추천 모음집 설명",
                                     placeholder: "추천 모음집에 대한 설명을 작성해주세요",
                                     lengthLimit: 40,
                                     isDownloadLinkTextField: false,
                                     inputHeight: 72,
                                     content: Binding(get: {curation.subtitle},
                                                      set: {curation.subtitle = $0}),
                                     isValid: $isValidDescription)
            
            Spacer()
                .frame(maxHeight: .infinity)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    if isEdit {
                        curation.shortcuts.forEach { shortcutCell in
                            deletedShortcutCells.removeAll(where: { $0.id == shortcutCell.id })
                        }
                    }
                    curation.shortcuts = curation.shortcuts.sorted { $0.title < $1.title }
                    curation.author = shortcutsZipViewModel.currentUser()
                    shortcutsZipViewModel.setData(model: curation)
                    shortcutsZipViewModel.updateShortcutCurationID(
                        shortcutCells: curation.shortcuts,
                        curationID: curation.id,
                        isEdit: isEdit,
                        deletedShortcutCells: deletedShortcutCells
                    )
                    if let index = shortcutsZipViewModel.userCurations.firstIndex(where: { $0.id == curation.id }) {
                        shortcutsZipViewModel.userCurations[index] = curation
                    }
                    
                    self.isWriting.toggle()
                    writeCurationNavigation.navigationPath = .init()
                } label: {
                    Text("업로드")
                        .Headline()
                        .foregroundColor(isIncomplete ? .Primary.opacity(0.3) : .Primary)
                }
                .disabled(isIncomplete)
            }
        }
        .background(Color.Background)
        .navigationBarTitle(isEdit ? "추천 모음집 편집" : "추천 모음집 작성")
        .onAppear(perform : UIApplication.shared.hideKeyboard)
    }
}

//struct WriteCurationInfoView_Previews: PreviewProvider {
//    static var previews: some View {
//        WriteCurationInfoView(isWriting: .constant(true),
//                              isEdit: false, navigationParentView: .curations)
//    }
//}
