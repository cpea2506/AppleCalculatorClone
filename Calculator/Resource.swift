//
//  Calculator.swift
//  Calculator
//
//  Created by Đỗ Viên on 27/03/2022.
//

import SwiftUI

// MARK: - KeyColor

/// A type represents for calculator keys color
typealias KeyColor = (fg: Color, bg: Color, onPressBg: Color)

// MARK: - Operator

enum Operator: String {
    case mod = "%"
    case div = "÷"
    case plus = "+"
    case minus = "−"
    case mul = "×"
}

// MARK: - KeyPad

enum KeyPad: CaseIterable, Hashable {
    case one
    case two
    case three
    case four
    case five
    case six
    case seven
    case eight
    case nine
    case zero
    case dot
    case clear
    case clearAll
    case plusMinus
    case opr(Operator)
    case equal

    // MARK: Internal

    static var allCases: [Self] = [
        .one, .two, .three, .four,
        .opr(.minus), .dot, .equal,
        .five, .six, .seven, .eight,
        .nine, .zero, .clear, .clearAll,
        .plusMinus, .opr(.div), .opr(.mul), .opr(.plus),
    ]

    var rawValue: String {
        switch self {
            case .clearAll:
                return "AC"
            case .clear:
                return "C"
            case .plusMinus:
                return "±"
            case .one:
                return "1"
            case .two:
                return "2"
            case .three:
                return "3"
            case .four:
                return "4"
            case .five:
                return "5"
            case .six:
                return "6"
            case .seven:
                return "7"
            case .eight:
                return "8"
            case .nine:
                return "9"
            case .zero:
                return "0"
            case .dot:
                return "."
            case .equal:
                return "="
            case .opr(let op):
                return op.rawValue
        }
    }

    var height: CGFloat {
        (UIScreen.main.bounds.width - 5 * 12) / 4
    }

    var width: CGFloat {
        self == .zero
            ? (UIScreen.main.bounds.width - 4 * 12) / 4 * 2
            : (UIScreen.main.bounds.width - 5 * 12) / 4
    }

    func color(didTap: Bool) -> KeyColor {
        switch self {
            case .clear,
                 .clearAll,
                 .opr(.mod),
                 .plusMinus:
                return (.black, Color(.lightGray), .white)
            case .opr(let o) where o != .mod:
                guard didTap else {
                    fallthrough
                }

                return (.orange, .white, Color("lightOrange"))
            case .equal:
                return (.white, .orange, Color("lightOrange"))
            default:
                return (.white, Color("darkGray"), .white.opacity(0.5))
        }
    }
}
