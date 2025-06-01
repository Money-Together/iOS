//
//  SafeAreaUtil.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 5/27/25.
//

import Foundation
import UIKit

enum SafeAreaUtil {
    static var topInset: CGFloat {
        getSafeAreaInsets()?.top ?? 0
    }

    static var bottomInset: CGFloat {
        getSafeAreaInsets()?.bottom ?? 0
    }

    private static func getSafeAreaInsets() -> UIEdgeInsets? {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = scene.windows.first else {
            return nil
        }
        return window.safeAreaInsets
    }
}

