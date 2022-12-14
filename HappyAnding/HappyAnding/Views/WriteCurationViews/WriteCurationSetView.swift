//
//  WriteCurationSetView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import SwiftUI

struct WriteCurationSetView: View {
    
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    
    @Binding var isWriting: Bool
    
    @State var shortcutCells = [ShortcutCellModel]()
    @State var isSelected = false
    @State var curation = Curation(title: "",
                                   subtitle: "",
                                   isAdmin: false,
                                   background: "White",
                                   author: "",
                                   shortcuts: [ShortcutCellModel]())
    @State var isTappedQuestionMark: Bool = false
    @State var deletedShortcutCells = [ShortcutCellModel]()
    
    let isEdit: Bool
    
    var body: some View {
        VStack {
            ProgressView(value: 1, total: 2)
                .padding(.bottom, 26)
            
            listHeader
            infomation
            if shortcutCells.isEmpty {
                Spacer()
                Text("아직 선택할 수 있는 단축어가 없어요.\n단축어를 업로드하거나 좋아요를 눌러주세요:)")
                    .Body2()
                    .foregroundColor(.Gray4)
                    .multilineTextAlignment(.center)
                Spacer()
                
            } else {
                shortcutList
            }
        }
        .background(Color.Background)
        .navigationTitle(isEdit ? "추천 모음집 편집" : "추천 모음집 작성")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            self.shortcutCells = shortcutsZipViewModel.fetchShortcutMakeCuration().sorted { $0.title < $1.title }
            if isEdit {
                deletedShortcutCells = curation.shortcuts
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    self.isWriting.toggle()
                } label: {
                    Text("취소")
                        .Body1()
                        .foregroundColor(.Gray4)
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(value: Float(0.0)) {
                    Text("다음")
                        .Headline()
                        .foregroundColor(curation.shortcuts.isEmpty ? .Primary.opacity(0.3) : .Primary)
                }
                .disabled(curation.shortcuts.isEmpty)
            }
        }
        .navigationDestination(for: Float.self) { isEdit in
            WriteCurationInfoView(curation: $curation,
                                  isWriting: self.$isWriting,
                                  isEdit: self.isEdit,
                                  deletedShortcutCells: $deletedShortcutCells)
        }
    }
    
    ///단축어 선택 텍스트 및 카운터
    var listHeader: some View {
        HStack(alignment: .bottom, spacing: 8) {
            Text("단축어 선택")
                .Sb()
                .foregroundColor(.Gray5)
            Text("최대 10개")
                .Footnote()
                .foregroundColor(.Gray3)
            Spacer()
            Text("\(curation.shortcuts.count)개")
                .Body2()
                .foregroundColor(.Primary)
        }
        .padding(.horizontal, 16)
    }
    
    ///내가 작성한, 좋아요를 누른 단축어 목록
    var shortcutList: some View {
        
        ScrollView {
            
            
            
            ForEach(Array(shortcutCells)) { shortcut in
                CheckBoxShortcutCell(
                    isShortcutTapped: curation.shortcuts.contains(shortcut),
                    selectedShortcutCells: $curation.shortcuts,
                    shortcutCell: shortcut
                )
            }
        }
        .frame(maxWidth: .infinity)
        .scrollIndicators(.hidden)
    }
    
    // MARK: - 안내문구
    var infomation: some View {
        Text("추천 모음집을 위한 단축어 목록은 ‘내가 업로드한 단축어'와 ‘좋아요를 누른 단축어'로 구성되어 있습니다.")
            .frame(maxWidth: .infinity, alignment: .leading)
            .Body2()
            .foregroundColor(.Gray5)
            .padding(.all, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(.Gray1)
            )
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
    }
}

struct WriteCurationSetView_Previews: PreviewProvider {
    static var previews: some View {
        WriteCurationSetView(isWriting: .constant(false),
                             isEdit: false)
    }
}
