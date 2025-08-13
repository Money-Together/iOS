//
//  SettlementMemberSelectionViewModel.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 8/2/25.
//

import Foundation
import Combine


class SettlementMemberSelectionViewModel {
    
    typealias Member = SelectableSettlementMember
    
    var members: [Member]
//    var displayedMembers: [SelectableSettlementMember] = []
    var selectedMembers: [Member] = []
    
    @Published var displayedMembers: [SelectableSettlementMember] = []
//    @Published var selectedMembers: [SelectableSettlementMember] = []
    
    /// 뒤로가기 실행 클로져
    var onBackTapped: (() -> Void)?
    
    /// 완료 실행 클로져
    var onDoneTapped: (([Member]) -> Void)?
    
    init(members: [Member],
         onBackTapped: (() -> Void)?,
         onDoneTapped: (([Member]) -> Void)?) {
        
        self.onBackTapped = onBackTapped
        self.onDoneTapped = onDoneTapped
        
        self.members = members

        self.initDisplayedMembers()
        
        self.selectedMembers = self.members.filter {
            $0.isPayer || $0.isSelected
        }
    }
    
    func selectMember(id: UUID) {
        guard !selectedMembers.contains(where: { $0.id == id }) else {
            print("[❌ Error] at: \(#fileID):\(#function):\(#line) - already selected ❌")
            return
        }

        guard let index = members.firstIndex(where: {
            $0.id == id
        }) else {
            print("[❌ Error] at: \(#fileID):\(#function):\(#line) - invalid member id ❌")
            return
        }
        members[index].isSelected = true
        addSelectedMember(id: id)
    }
    
    func deselectMember(id: UUID) {
        guard let index = members.firstIndex(where: {
            $0.id == id
        }) else {
            print("[❌ Error] at: \(#fileID):\(#function):\(#line) - invalid member id ❌")
            return
        }
        members[index].isPayer = false
        members[index].isSelected = false
        removeSelectedMember(id: id)
    }
    
    func addSelectedMember(id: UUID) {
        guard let member = members.first(where: {
            $0.id == id
        }) else {
            print("[❌ Error] at: \(#fileID):\(#function):\(#line) - invalid member id ❌")
            return
        }
        
        selectedMembers.insert(member, at: 0)
    }
    
    func removeSelectedMember(id: UUID) {
        selectedMembers.removeAll { $0.id == id }
    }
    
    func getIndexOfSelectedMember(id: UUID) -> Int? {
        return selectedMembers.firstIndex { $0.id == id }
    }
    
    func getIndexOfMember(id: UUID) -> Int? {
        return members.firstIndex { $0.id == id }
    }

    func setPayer(_ isPayer: Bool, for id: UUID) {
        guard let member = members.first(where: {
            $0.id == id
        }) else {
            print("[❌ Error] at: \(#fileID):\(#function):\(#line) - invalid member id ❌")
            return
        }
        
        member.isPayer = isPayer
    }
    
    func initDisplayedMembers() {
        self.displayedMembers = self.members
    }
    
    func updateDisplayedMembers(with query: String) {
        self.displayedMembers = members.filter {
            $0.userInfo.nickname.contains(query)
        }
    }
    
}
