//
//  View+NavigationBar.swift
//  HappyAnding
//
//  Created by 이지원 on 2023/02/24.
//

import SwiftUI

// MARK: - View extension
public extension View {
    func navigationBarBackground<Background: View>(@ViewBuilder _ background: @escaping () -> Background) -> some View {
        modifier(NavigationBarColorModifier(background: background))
    }
}



// MARK: - View Modifier

/**
 네비게이션바 아이템 색상을 변경하기 위한 클래스 입니다.
 맨 처음 뷰가 선언되는 시점에 Theme.navigationBarColors() 를 선언하여 사용해주세요.
 
 - remark:
    - [출처](https://velog.io/@whale/SwiftUI-NavigationBar-Background-%EC%A1%B0%EC%A0%88%ED%95%98%EA%B8%B0)
*/
struct NavigationBarColorModifier<Background>: ViewModifier where Background: View {
    
    let background: () -> Background
    
    public init(@ViewBuilder background: @escaping () -> Background) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.clear
        appearance.shadowColor = .clear
        appearance.largeTitleTextAttributes = [.font : UIFont.shortcutsZipLargeTitle, .foregroundColor: UIColor(.gray5)]
        //back button color 지정
        let backItemAppearance = UIBarButtonItemAppearance()
        backItemAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.clear
        ]
        appearance.backButtonAppearance = backItemAppearance
        
        //indicator color 지정
        let image = UIImage(systemName: "chevron.backward")?
            .withTintColor(UIColor(.gray4), renderingMode: .alwaysOriginal)
        appearance.setBackIndicatorImage(image, transitionMaskImage: image)
        
        let scrollAppearance = UINavigationBarAppearance()
        scrollAppearance.configureWithDefaultBackground()
        scrollAppearance.backgroundColor = UIColor(Color.shortcutsZipWhite)
        scrollAppearance.shadowColor = .clear
        scrollAppearance.largeTitleTextAttributes = [.font : UIFont.shortcutsZipLargeTitle, .foregroundColor: UIColor(.gray5)]
        scrollAppearance.backButtonAppearance = backItemAppearance
        scrollAppearance.setBackIndicatorImage(image, transitionMaskImage: image)
        
        UINavigationBar.appearance().standardAppearance = scrollAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().compactScrollEdgeAppearance = appearance

        self.background = background
    }

    func body(content: Content) -> some View {
        
        ZStack {
            content
            VStack {
                background()
                    .edgesIgnoringSafeArea([.top, .leading, .trailing])
                    .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 0, alignment: .center)

                Spacer() // to move the navigation bar to top
            }
        }
    }
}
