//
//  DateFilterSelectorView.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 5/29/25.
//

import Foundation
import SwiftUI

class SelectedDateFilterUIView: UIView {
    private let viewModel: MoneyLogsViewModel
    private var hostingVC : UIHostingController<SelectedDateFilterView>!
    
    init(viewModel: MoneyLogsViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        let rootView = SelectedDateFilterView(viewModel: viewModel)
        hostingVC = UIHostingController(rootView: rootView)
        let view = hostingVC.view.disableAutoresizingMask()
        
        self.addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.topAnchor),
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            view.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
        
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

struct SelectedDateFilterView: View {
    @ObservedObject var moneyLogsVM: MoneyLogsViewModel
    
    private var selectedDateText: String {
        self.moneyLogsVM.selectedDateFilter.formattedString(format: "yyyy년 M월")
    }
    
    private var isMoveToNextBtnEnalbed: Bool {
        return self.moneyLogsVM.canMoveToNextMonth()
    }
    
    init(viewModel: MoneyLogsViewModel) {
        self.moneyLogsVM = viewModel
    }
    
    var body: some View {
        HStack(spacing: 0) {
            Button(action: {
                let _  = self.moneyLogsVM.moveToPreviousMonth()
            }, label: {
                Image("arrow_left").iconStyle(padding: 10)
            })
            
            Button(action: {
                print(#fileID, #function, #line, "show picker view")
            }, label: {
                Text(selectedDateText)
                    .moneyTogetherFont(style: .b1)
                    .foregroundStyle(Color.moneyTogether.label.alternative)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 2)
            })
            
            Button(action: {
                let _  = self.moneyLogsVM.moveToNextMonth()
            }, label: {
                Image("arrow_right").iconStyle(padding: 10)
            })
            .disabled(!self.isMoveToNextBtnEnalbed)
            
            Spacer()
        }
    }
}

//struct DateFilterSelectorView: View {
//    var body: some View {
//        
//    }
//}

#Preview {
    SelectedDateFilterView(viewModel: MoneyLogsViewModel())
}
