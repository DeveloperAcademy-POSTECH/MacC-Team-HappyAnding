//
//  CustomShareViewController.swift
//  ShareExtension
//
//  Created by HanGyeongjun on 2022/11/19.
//

import UIKit
import SwiftUI
import UniformTypeIdentifiers

import FirebaseCore


class CustomShareViewController: UIViewController {
    
    var shortcut = Shortcuts(sfSymbol: "", color: "", title: "", subtitle: "", description: "", category: [], requiredApp: [], numberOfLike: 0, numberOfDownload: 0, author: "", shortcutRequirements: "", downloadLink: [], curationIDs: [])
    let shareExtensionViewModel = ShareExtensionViewModel()
    
    var itemDone: UIBarButtonItem!
    var itemCancel: UIBarButtonItem!
    
    ///viewdidload
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        NotificationCenter.default.addObserver(self, selector: #selector(enabledDoneButton), name: NSNotification.Name(rawValue: "enabledDoneButton"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(inEnabledDoneButton), name: NSNotification.Name(rawValue: "inEnabledDoneButton"), object: nil)
        
        //로그인 정보 empty 일 때
        if  UserDefaults.shared.string(forKey: "ShareUserInfo") == nil {
            let alert = UIAlertController(title: "로그인을 먼저 진행해주세요", message:
                                            "이 기능은 로그인 후 사용할 수 있는 기능이에요", preferredStyle: .alert)
            let action = UIAlertAction(title: "확인", style: .default) { _ in
                self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        
        pasteUrl { url in
            
            //링크가 적절하지 않을 때
            if !self.shareExtensionViewModel.isLinkValid(content: "\(url)") {
                let alert = UIAlertController(title: "잘못된 접근이에요", message:"해당 링크는 ShortcutsZip으로 공유할 수 없어요", preferredStyle: .alert)
                let action = UIAlertAction(title: "확인", style: .default) { action in
                    self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
                }
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
            
            //익스텐션 뷰 뜸
            self.shareExtensionViewModel.shortcut.downloadLink.append("\(url)")
            let extShortcutsView = UIHostingController(rootView: ShareExtensionWriteShortcutTitleView(shareExtensionViewModel: self.shareExtensionViewModel))
            self.view.addSubview(extShortcutsView.view)
            extShortcutsView.view.translatesAutoresizingMaskIntoConstraints = false
            extShortcutsView.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
            extShortcutsView.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
            extShortcutsView.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
            extShortcutsView.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        }
        setupNavBar()
        self.view.backgroundColor = UIColor.Background
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "enabledDoneButton"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "inEnabledDoneButton"), object: nil)
    }
    
    @objc func enabledDoneButton() {
        itemDone.isEnabled = true
    }
    @objc func inEnabledDoneButton() {
        itemDone.isEnabled = false
    }
    
    func pasteUrl(completionHandler: @escaping ((NSSecureCoding)->())) {
        let extensionItems = extensionContext?.inputItems as! [NSExtensionItem]
        for extensionItem in extensionItems {
            if let itemProviders = extensionItem.attachments {
                for itemProvider in itemProviders {
                    if itemProvider.hasItemConformingToTypeIdentifier(UTType.url.identifier) {
                        itemProvider.loadItem(forTypeIdentifier: UTType.url.identifier, options: nil, completionHandler: { result, error in
                            DispatchQueue.main.async {
                                if let urlStr = result {
                                    completionHandler(urlStr)
                                }
                            }
                        })
                    }
                }
            }
        }
    }
    
    ///Set Navigation Bar
    private func setupNavBar() {
        
        let newNavBarAppearance = customNavBarAppearance()
        navigationController!.navigationBar.scrollEdgeAppearance = newNavBarAppearance
        navigationController!.navigationBar.compactAppearance = newNavBarAppearance
        navigationController!.navigationBar.standardAppearance = newNavBarAppearance
        if #available(iOS 15.0, *) {
            navigationController!.navigationBar.compactScrollEdgeAppearance = newNavBarAppearance
        }
        
        self.navigationItem.title = "단축어 작성"
        
        let cancelButton: UIButton = {
            let button = UIButton()
            button.setTitle("취소", for: .normal)
            button.setTitleColor(UIColor.Gray4, for: .normal)
            button.titleLabel?.font = UIFont.Body1
            button.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
            
            return button
        }()
        itemCancel = UIBarButtonItem(customView: cancelButton)
        self.navigationItem.setLeftBarButton(itemCancel, animated: false)
        
        itemDone = UIBarButtonItem(title: "업로드", style: .plain, target: self, action: #selector(doneAction))
        self.navigationItem.setRightBarButton(itemDone, animated: false)
        
        itemDone.isEnabled = false
    }
    @objc private func cancelAction () {
        let error = NSError(domain: "some.bundle.identifier", code: 0, userInfo: [NSLocalizedDescriptionKey: "An error description"])
        extensionContext?.cancelRequest(withError: error)
    }
    @objc private func doneAction() {
        shareExtensionViewModel.setData()
        extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }
    func dismissAction() {
        extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "keyboardHide"), object: nil)
    }
    
    func customNavBarAppearance() -> UINavigationBarAppearance {
        let customNavBarAppearance = UINavigationBarAppearance()
        
        customNavBarAppearance.configureWithOpaqueBackground()
        customNavBarAppearance.backgroundColor = UIColor.Background
        customNavBarAppearance.shadowColor = .clear
        
        customNavBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.Gray5]
        customNavBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.Gray5]
        
        let barButtonItemAppearance = UIBarButtonItemAppearance(style: .plain)
        barButtonItemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.Primary, .font: UIFont.Headline]
        barButtonItemAppearance.disabled.titleTextAttributes = [.foregroundColor: UIColor.PrimaryOpacity]
        barButtonItemAppearance.highlighted.titleTextAttributes = [.foregroundColor: UIColor.label]
        barButtonItemAppearance.focused.titleTextAttributes = [.foregroundColor: UIColor.Gray5]
        customNavBarAppearance.buttonAppearance = barButtonItemAppearance
        customNavBarAppearance.backButtonAppearance = barButtonItemAppearance
        customNavBarAppearance.doneButtonAppearance = barButtonItemAppearance
        
        return customNavBarAppearance
    }
}

