//
//  SearchView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/11/09.
//

import MessageUI
import SwiftUI

struct SearchView: View {
    @Environment(\.isSearching) private var isSearching: Bool
    @Environment(\.dismissSearch) private var dismissSearch
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    
    @State var keywords: Keyword = Keyword(keyword: [String]())
    @State var isSearched: Bool = false
    @State var searchText: String = ""
    @State var shortcutResults = Set<Shortcuts>()
    
    var body: some View {
        VStack {
            if !isSearched {
                recommendKeyword
                Spacer()
            } else {
                if shortcutResults.count == 0 {
                    proposeView
                } else {
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(shortcutResults.sorted(by: { $0.title < $1.title }), id: \.self) { shortcut in
                                
                                let data = NavigationReadShortcutType(shortcutID: shortcut.id,
                                                                      navigationParentView: .shortcuts)
                                NavigationLink(value: data) {
                                    ShortcutCell(shortcut: shortcut,
                                                 navigationParentView: NavigationParentView.shortcuts)
                                    .listRowInsets(EdgeInsets())
                                    .listRowSeparator(.hidden)
                                }
                            }
                        }
                    }
                }
            }
        }
        .onAppear() {
            self.keywords = shortcutsZipViewModel.keywords
        }
        .searchable(text: $searchText, prompt: "제목 또는 관련앱으로 검색하세요")
        .onSubmit(of: .search, runSearch)
        .onChange(of: searchText) { _ in
            didChangedSearchText()
            if !searchText.isEmpty {
                isSearched = true
            } else if searchText.isEmpty && !isSearching {
                shortcutResults.removeAll()
                isSearched = false
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.Background)
        .navigationBarBackground ({ Color.Background })
    }
    
    private func runSearch() {
        isSearched = true
    }
    
    var recommendKeyword: some View {
        VStack(alignment: .leading) {
            Text("추천 검색어")
                .padding(.leading, 16)
                .padding(.top, 12)
                .Headline()
            
            ScrollView(.horizontal) {
                HStack {
                    ForEach(keywords.keyword, id: \.self) { keyword in
                        Text(keyword)
                            .Body2()
                            .foregroundColor(Color.Gray4)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .strokeBorder(Color.Gray4, lineWidth: 1)
                            )
                            .onTapGesture {
                                searchText = keyword
                                runSearch()
                            }
                    }
                }
                .padding(.leading, 16)
                .padding(.top, 8)
            }
        }
    }
    
    var proposeView: some View {
        VStack(alignment: .center) {
            Text("\'\(searchText)\'의 결과가 없어요.\n원하는 단축어를 제안해보는건 어떠세요?").multilineTextAlignment(.center)
                .Body1()
                .foregroundColor(Color.Gray4)
            
            Link(destination: URL(string: "https://docs.google.com/forms/d/e/1FAIpQLScQc3KeYjDGCE-C2YRU-Hwy2XNy5bt89KVX1OMUzRiySaMX1Q/viewform")!) {
                Text("단축어 제안하기")
                    .padding(.horizontal, 28)
                    .padding(.vertical, 8)
            }
            .buttonStyle(.borderedProminent)
            .padding(16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.Background)
    }
    private func didChangedSearchText() {
        shortcutResults.removeAll()
        
        for data in shortcutsZipViewModel.allShortcuts {
            if data.title.lowercased().contains(searchText.lowercased()) ||
                !data.requiredApp.filter({ $0.lowercased().contains(searchText.lowercased()) }).isEmpty ||
                data.subtitle.lowercased().contains(searchText.lowercased())
            {
                shortcutResults.insert(data)
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
