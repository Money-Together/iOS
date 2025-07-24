//
//  SliderSegmentedPicker.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 7/24/25.
//

import Foundation
import SwiftUI

/// 이 프로토콜을 채택 시, SliderSegmentedPicker에서 사용 가능
protocol SliderSegmentedPickable: CaseIterable, Identifiable, Equatable {}

/// 커스텀 슬라이딩 탭 형태의 Picker 컴포넌트
/// 어떤 `SliderSegmentedPickable (== CaseIterable + Identifiable + Equatable)` 타입이든 대응 가능
struct SliderSegmentedPicker<T: SliderSegmentedPickable>: View {
    /// 선택된 값 바인딩 (탭을 클릭하면 값 변경됨)
    @Binding var selection: T
    
    /// 보여줄 항목들 (보통은 T.allCases)
    let items: [T]
    
    /// 항목마다 보여줄 텍스트를 결정하는 클로저
    let getTitle: (T) -> String
    
    /// 항목 간 간격
    let spacing: CGFloat = 4
    
    /// 피커 width (기본값은 화면 width 에서 양쪽 Layout.side를 뺀 값)
    let pickerWidth: CGFloat = UIScreen.main.bounds.width - (Layout.side * 2)
    
    /// 피커 height
    let pickerHeight: CGFloat = 40
    
    /// 각 버튼의 width 계산 (피커 전체 width 기준)
    var sliderButtonWidth: CGFloat {
        pickerWidth / CGFloat(items.count) - spacing
    }
    
    /// 각 버튼의 height 계산 (피커  height 기준)
    var sliderButtonHeight: CGFloat {
        pickerHeight - (spacing * 2)
    }

    /// 선택된 항목의 위치 오프셋 (애니메이션을 위한 포인터 위치)
    var selectedOffset: CGFloat {
        guard let index = items.firstIndex(of: selection) else { return 0 }
        return CGFloat(index) * (sliderButtonWidth + spacing)
    }

    var body: some View {
        ZStack(alignment: .leading) {
            // 선택된 항목 뒤에 깔리는 배경 포인터
            RoundedRectangle(cornerRadius: sliderButtonHeight / 2)
                .foregroundStyle(Color.moneyTogether.background)
                .frame(width: sliderButtonWidth, height: sliderButtonHeight)
                .offset(x: selectedOffset)
                .animation(.easeInOut, value: selection)

            // 항목들 텍스트 버튼
            // 각 텍스트 버튼 탭할 경우, 선택 항목 변경됨
            HStack(spacing: spacing) {
                ForEach(items) { item in
                    Text(getTitle(item))
                        .moneyTogetherFont(style: .b2)
                        .foregroundStyle(Color.moneyTogether.label.normal)
                        .frame(width: sliderButtonWidth, height: sliderButtonHeight)
                        .onTapGesture {
                            selection = item
                        }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, spacing)
        .frame(maxWidth: .infinity, minHeight: pickerHeight)
        .background(Color.moneyTogether.grayScale.baseGray20)
        .clipShape(RoundedRectangle(cornerRadius: pickerHeight / 2))
    }
}
