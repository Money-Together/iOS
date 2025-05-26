//
//  Binder.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 5/6/25.
//

import Foundation

class Binder<T> {

    private var listener: ((T) -> ())?

    var value: T {
        didSet { listener?(value) }
    }

    init(_ value: T) {
        self.value = value
    }

    func bind(_ listener: ((T) -> Void)?) {
        self.listener = listener
    }
}
