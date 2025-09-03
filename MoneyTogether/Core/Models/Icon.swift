//
//  Icon.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 9/3/25.
//

import Foundation
import UIKit
import SwiftUI

/// 아이콘
/// - uuid, 이미지 이름, uikit image, swiftUI image
struct Icon: Identifiable, Equatable {
    let id: UUID
    var name: String
    var image: Image?        // SwiftUI용 image
    var uiImage: UIImage?    // UIKit용 image
    
    init(name: String) {
        self.id = UUID()
        self.name = name
        self.image = Image(name)
        self.uiImage = UIImage(named: name)
    }
}

/// 아이콘 프리셋 이미지 이름
let iconPresetNames: [String] =
[
    "account", "attach_money", "credit_card", "currency_exchange", "payments", "savings",
    "fork_spoon", "restaurant", "bakery_dining", "coffee", "cookie", "sports_bar", "local_convenience_store",
    "self_care", "shopping_cart",
    "accessible", "home", "family_home", "person", "person_heart", "group", "diversity_3", "real_estate_agent", "volunteer_activism", "approval_delegation",
    "directions_bus", "directions_car", "train", "electric_scooter", "travel",
    "medication", "medical_services", "syringe", "pill", "cardiology",
    "auto_stories", "book_2", "edit", "ink_pen", "school", "desktop_windows", "laptop_mac", "mobile", "photo_camera", "headphones", "music_note", "sports_esports", "smart_display", "palette", "imagesearch_roller", "exercise", "camping", "build",
    "favorite", "kid_star", "star", "star_shine", "emergency", "sentiment_satisfied", "emoticon", "crown", "dark_mode", "light_mode", "bomb",
    "compost", "eco", "forest", "potted_plant", "recycling",
    "alarm", "conversion_path", "database", "folder_open", "interests", "language", "loyalty", "map_pin_review", "monitoring", "package_2", "page_info", "sell", "shield", "trending_up", "wifi"
]

/// 아이콘 프리셋
let iconPresets: [Icon] = iconPresetNames.map{ Icon(name: $0) }
