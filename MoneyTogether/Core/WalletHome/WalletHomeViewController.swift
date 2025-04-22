//
//  WalletHomeViewController.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 4/22/25.
//

import Foundation
import UIKit

/// 지갑 홈 뷰
class WalletHomeViewController: UIViewController {
    private let testLabel: UILabel = {
        let label = UILabel()
        label.text = "wallet home 테스트 입니다."
        label.textColor = .black
        label.font = .systemFont(ofSize: 15)
        label.clipsToBounds = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
    }
    
    private func setUI() {
        view.addSubview(testLabel)
        view.backgroundColor = .systemTeal
    }
    
    private func setLayout() {
        testLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            testLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            testLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -150)
        ])
    }
}


#if DEBUG

import SwiftUI

@available(iOS 17, *)
#Preview {
    return WalletHomeViewController()
}

//struct WalletHomeViewControllerRepresentable: UIViewControllerRepresentable {
//    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
//    
//    func makeUIViewController(context: Context) -> some UIViewController {
//        WalletHomeViewController()
//    }
//}
//
//struct WalletHomeViewControllerRepresentable_PreviewProvider: PreviewProvider {
//    static var previews: some View {
//        WalletHomeViewControllerRepresentable()
//            .ignoresSafeArea()
//    }
//}

#endif
