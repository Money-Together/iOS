//
//  CategoryListViewModel.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 9/2/25.
//

import Foundation

final class CategoryListViewModel {
    
    /// 나중에 삭제해야할 임시 id, 새로 생성된 카테고리 id 처리용
    static var tmpMaxId: Int64 = 0
    
    @Published var categoryList: [Category]
    
    private var isLoading: Bool = false
    
    var onBackTapped: (() -> Void)?
    
    var onAddBtnTapped: (() -> Void)?
    
    var onUpdateBtnTapped: ((Category) -> Void)?
    
    init(categoryList: [Category]) {
        self.categoryList = categoryList
    }
}

extension CategoryListViewModel {
    /// 카테고리 수정 버튼 클릭 시 핸들링
    func handleEditButtonTap(for category: Category) {
        self.onUpdateBtnTapped?(category)
    }
    
    /// 카테고리 삭제 버튼 클릭 시 핸들링
    func handleDeleteButtonTap(for category: Category) {
        self.deleteCategory(of: category.id!)
    }
}

extension CategoryListViewModel {
    private func fetchCategoryList() {
        self.categoryList = Category.createDummyList()
    }
    
    /// 카테고리 리스트에 새로운 카테고리 추가
    func addCategory(_ newValue: Category) {
        self.categoryList.append(newValue)
        CategoryListViewModel.tmpMaxId = CategoryListViewModel.tmpMaxId + 1
    }
    
    /// 카테고리 리스트에 선택한 카테고리 데이터 수정
    func updateCategory(of id: Int64, _ newValue: Category) {
        if let idx = self.categoryList.firstIndex(where: { $0.id == id }) {
            self.categoryList[idx] = newValue
        }
    }
    
    /// 카테고리 삭제 api 호출 및 카테고리 리스트에서 해당 카테고리 삭제
    func deleteCategory(of id: Int64) {
        guard !isLoading else {
            return
        }
        
        guard let idx = categoryList.firstIndex(where: { $0.id == id }) else {
            fatalError("Error!!!! no item")
        }
        
        Task {
            do {
                self.isLoading = true
                try await Task.sleep(nanoseconds: 1_000_000_000)
                self.isLoading = false
                
                if Bool.random() { // success
                    print(#fileID, #function, #line, "✅ success delete category")
                    self.categoryList.remove(at: idx)
                }
                else { // fail
                    throw NSError(domain: "MockError", code: -1, userInfo: [NSLocalizedDescriptionKey: "error: delete failed"])
                }
            } catch {
                self.isLoading = false
                print(#fileID, #function, #line, "\(error.localizedDescription)")
            }
        }
    }
}
