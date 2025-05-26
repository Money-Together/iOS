//
//  PhotoManager.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 5/8/25.
//

import Foundation
import PhotosUI

class PhotoManager {
    
    /// 앨범 접근 권한 설정을 요청하는 함수
    /// - Returns: 전체 접근 가능 또는 제한 접근 가능할 경우 True 리턴
     private static func requestPhotosAuthorization() async -> Bool {
        let accessStatus = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
        switch accessStatus {
        case .authorized, .limited: return true
        case .denied, .restricted, .notDetermined: return false
        @unknown default:
            print(#fileID, #function, #line, "Unhandled photo authorization status: \(accessStatus)")
            return false
        }
    }
    
    /// 앨범에 접근 가능한지 확인하는 함수
    /// - Parameter viewController: 앨범 접근을 요구하는 뷰 컨트롤러
    /// - Returns: 접근 가능(전체 접근 or 제한 접근)하면 true 리턴
    static func canAccessPhotoLibrary(from viewController: UIViewController) async -> Bool {
        let photoAceessStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        
        switch photoAceessStatus {
        case .notDetermined:
            return await requestPhotosAuthorization()
        case .restricted, .denied:
            return false
        case .authorized:
            return true
        case .limited:
#warning("접근가능하도록 선택한 이미지 외에도 접근 가능함 -> 접근 가능한 이미지 선택할 경우, 에러 때문에 사용자 경험이 부자연스러워서 일단 주석처리")
            // await shared.presentLimitedLibraryPicker(from: viewController)
            return true
        @unknown default:
            print(#fileID, #function, #line, "Unhandled photo authorization status: \(photoAceessStatus)")
            return false
        }
    }
    
    /// 사진을 가져오기 위한 포토 피커를 생성하는 함수
    /// - Parameter selectionLimit: 선택할 이미지 수
    /// - Returns: 생성한 포토 피커
    static func createPhotoPickerView(selectionLimit: Int = 1) -> PHPickerViewController {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        
        let filter = PHPickerFilter.any(of: [.images, .livePhotos, .depthEffectPhotos, .screenshots])

        config.filter = filter
        config.preferredAssetRepresentationMode = .current
        config.selection = .ordered
        config.selectionLimit = selectionLimit

        let picker = PHPickerViewController(configuration: config)
        
        return picker
    }
    
    /// 앨범 접근 권한이 없을 경우 처리하는 함수
    /// 관련 안내 메세지를 포함한 alert를 띄운 후, 설정화면으로 유도
    /// - Parameter viewController: 앨범 접근을 요구하는 뷰 컨트롤러, alert를 띄울 뷰 컨트롤러
    class func handlePhotoLibraryPermissionDenied(from viewController: UIViewController) {
        let alert = UIAlertController(
            title: "사진 접근 권한이 필요합니다",
            message: "사진을 선택하려면 접근 권한이 필요합니다. 설정 > 앱 이름 > 사진에서 허용해주세요.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "설정으로 이동", style: .default) { _ in
            guard let settingsURL = URL(string: UIApplication.openSettingsURLString),
                  UIApplication.shared.canOpenURL(settingsURL) else { return }
            UIApplication.shared.open(settingsURL)
        })
        
        viewController.present(alert, animated: true)
    }
}
