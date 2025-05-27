//
//  WalletHomeViewModel.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 5/27/25.
//

import Foundation

class WalletHomeViewModel {
    let walletVM: WalletViewModel
    let logsVM: MoneyLogsViewModel
    
    init(walletVM: WalletViewModel = WalletViewModel(), logsVM: MoneyLogsViewModel = MoneyLogsViewModel()) {
        self.walletVM = walletVM
        self.logsVM = logsVM
    }
    
    func fetchWalletProfile() {
        walletVM.fetchWalletData()
        walletVM.fetchMembers()
    }
    
}

