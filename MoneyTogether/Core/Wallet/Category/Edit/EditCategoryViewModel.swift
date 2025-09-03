//
//  EditCategoryViewModel.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 9/3/25.
//

import Foundation

/// 카테고리 편집 뷰 모델
class EditCategoryViewModel: ObservableObject {
    
    private let mode: EditingMode<Category>
    
    @Published var name: String
    @Published private(set) var color: PaletteColor
    @Published private(set) var icon: Icon
    
    
    var isLoading: Bool = false
    
    
    var onBack: (() -> Void)?
    
    var onDone: ((EditingMode<Int64>, Category) -> Void)?
    
    var onSelectColor: (() -> Void)?
    
    var onSelectIcon: (() -> Void)?
    
    init(name: String = "",
         colorHex: String = ColorPalette.presets[5].hex,
         iconName: String = iconPresetNames[5] ) {
        self.mode = .create
        self.name = name
        self.color = PaletteColor(hex: colorHex)
        self.icon = Icon(name: iconName)
    }
    
    init(mode: EditingMode<Category>) {
        self.mode = mode
        switch mode {
        case .create:
            self.name = ""
            self.color = ColorPalette.presets[5]
            self.icon = iconPresets[5]
        case .update(let orgData):
            self.name = orgData.name
            self.color = orgData.color
            self.icon = orgData.icon
        }
    }
}

extension EditCategoryViewModel {
    
    func updateColor(_ newValue: PaletteColor) {
        self.color = newValue
    }
    
    func updateIcon(_ newValue: Icon) {
        self.icon = newValue
    }
}

extension EditCategoryViewModel {
    
    /// 뒤로가기 클릭 시 핸들링
    func handleBackButtonTap() {
        self.onBack?()
    }
    
    /// 완료 버튼 클릭 시 핸들링
    func handleDoneButtonTap() {
        guard !self.isLoading else { return }
        
        Task {
            var editmode: EditingMode<Int64>
            var category: Category
            
            do {
                self.isLoading = true
                switch self.mode {
                case .create:
                    editmode = .create
                    category = try await createCategory()
                case .update(let orgData):
                    editmode = .update(orgData: orgData.id!)
                    category = try await updateCategory(org: orgData)
                }
                self.isLoading = false
                
                print(#fileID, #function, #line, "✅ success creating category")
                self.onDone?(editmode, category)
                
                
            } catch {
                self.isLoading = false
                let errorMessage = error.localizedDescription
                print(#fileID, #function, #line, "❌ Error: \(errorMessage)")
            }
        }
    }
    
    /// 카테고리 생성 api 호출
    /// - Returns: 생성된 category data
    private func createCategory() async throws -> Category {
        // api
        try await Task.sleep(nanoseconds: 1_000_000_000)
        if Bool.random() { // success
            // 이후 리스트에서 수동으로 업데이트를 하려면 여기서 새로 생성된 카테고리의 id를 받아와야 함
            return Category(id: CategoryListViewModel.tmpMaxId + 1, name: self.name, icon: self.icon, color: self.color)
        } else { // fail
            throw NSError(domain: "MockError", code: -1, userInfo: [NSLocalizedDescriptionKey: "category creation failed"])
        }
    }
    
    /// 카테고리 수정 api 호출
    /// - Parameter org: 기존 데이터
    /// - Returns: 변경된 데이터
    private func updateCategory(org: Category) async throws  -> Category {
        // api
        try await Task.sleep(nanoseconds: 1_000_000_000)
        if Bool.random() { // success
            return Category(id: org.id, name: self.name, icon: self.icon, color: self.color)
        } else { // fail
            throw NSError(domain: "MockError", code: -1, userInfo: [NSLocalizedDescriptionKey: "category creation failed"])
        }
    }
}
 
