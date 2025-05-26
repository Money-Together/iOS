//
//  ProfileImgView.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 4/26/25.
//

import Foundation
import SwiftUI


//class ProfileImageData: ObservableObject {
//    @Published var imageUrl: String?
//
//    init(imageUrl: String?) {
//        self.imageUrl = imageUrl
//    }
//}

/// 프로필 이미지 뷰
struct ProfileImageView: View {
    var size: CGFloat
    var imageUrl: String?
    
    init(size: CGFloat, imageUrl: String? = nil) {
        self.size = size
        self.imageUrl = imageUrl
    }
    
    var body: some View {
        if let urlStr = imageUrl,
           let url = URL(string: urlStr) {
            createImageView(with: url)
        } else {
            defaultProfileImage
        }
        
    }
    
    /// 설정된 이미지 없을 경우 기본 이미지
    var defaultProfileImage: some View {
        Image("default_profile_image")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: size, height: size)
    }
    
    /// url로 이미지 비동기 처리
    func createImageView(with url: URL) -> some View {
        AsyncImage(url: url) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size, height: size)
                    .clipped()
                    .background(Color.moneyTogether.system.inactive)
                    .cornerRadius(size / 2)
            } else if phase.error != nil {
                defaultProfileImage
            } else {
                ProgressView()
                    .frame(width: size, height: size)
                    .cornerRadius(size / 2)
            }
        }
    }
}

#Preview {
    ProfileImageView(size: 96, imageUrl: nil)
}
