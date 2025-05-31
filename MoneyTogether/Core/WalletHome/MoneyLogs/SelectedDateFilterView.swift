//
//  SelectedDateFilterView.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 5/29/25.
//

import Foundation
import SwiftUI

// MARK: SelectedDateFilter UIView

/// 선택된 날짜 필터 UIView
/// SwiftUI 뷰를 호스팅
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


// MARK: SelectedDateFilter View

/// 년/월 단위로 머니로그 필터링을 위한 상단 날짜 선택 뷰
struct SelectedDateFilterView: View {
    @ObservedObject var moneyLogsVM: MoneyLogsViewModel
    @State var showPickerView: Bool = false
    
    /// 선택된 날짜를 "yyyy년 M월" 형식의 문자열로 반환
    private var selectedDateText: String {
        self.moneyLogsVM.selectedDateFilter.formattedString(format: "yyyy년 M월")
    }
    
    /// 이전 달로 이동 가능한지 여부
    private var isMoveToNextBtnEnalbed: Bool {
        return self.moneyLogsVM.canMoveToNextMonth()
    }
    
    /// 다음 달로 이동 가능한지 여부
    private var isMoveToPrevBtnEnalbed: Bool {
        return self.moneyLogsVM.canMoveToPrevMonth()
    }
    
    init(viewModel: MoneyLogsViewModel) {
        self.moneyLogsVM = viewModel
    }
    
    var body: some View {
        HStack(spacing: 0) {
            // move to previous month button
            Button(action: {
                let _  = self.moneyLogsVM.moveToPreviousMonth()
            }, label: {
                Image("arrow_left")
                    .iconStyle(foregroundColor: isMoveToPrevBtnEnalbed ? .moneyTogether.label.alternative : .moneyTogether.system.inactive, padding: 10)
            })
            .disabled(!self.isMoveToPrevBtnEnalbed)
            
            // selected date text
            // show year month picker sheet when tapped
            Button(action: {
                self.showPickerView = true
            }, label: {
                Text(selectedDateText)
                    .moneyTogetherFont(style: .b1)
                    .foregroundStyle(Color.moneyTogether.label.alternative)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 4)
            })
            
            // move to next month button
            Button(action: {
                let _  = self.moneyLogsVM.moveToNextMonth()
            }, label: {
                Image("arrow_right")
                    .iconStyle(foregroundColor: isMoveToNextBtnEnalbed ? .moneyTogether.label.alternative : .moneyTogether.system.inactive, padding: 10)
            })
            .disabled(!self.isMoveToNextBtnEnalbed)
            
            Spacer()
        }
        // 년/월 선택 sheet
        .sheet(isPresented: $showPickerView, content: {
            YearMonthPickerView(
                selectedDate: moneyLogsVM.selectedDateFilter,
                onSelect: { newDate in
                    moneyLogsVM.setSelectedDateFilter(value: newDate)
                }
            ).presentationDetents([.fraction(0.4)])
        })
    }
}



#Preview {
    SelectedDateFilterView(viewModel: MoneyLogsViewModel())
}
