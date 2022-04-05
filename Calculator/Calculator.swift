//
//  Calculator.swift
//  Calculator
//
//  Created by Đỗ Viên on 29/03/2022.
//

import Foundation

// MARK: - Calculator

struct Calculator {
    // MARK: Lifecycle

    init(firstOperand: Double, secondOperand: Double, opr: Operator?) {
        self.firstOperand = firstOperand
        self.secondOperand = secondOperand
        self.opr = opr
    }

    // MARK: Internal

    static func toggleSign(operand: Double) -> Double {
        operand * -1.0
    }

    static func eval(firstOperand: Double, secondOperand: Double, opr: Operator?) -> Double {
        switch opr {
            case .plus:
                return firstOperand + secondOperand
            case .minus:
                return firstOperand - secondOperand
            case .mul:
                return firstOperand * secondOperand
            case .div:
                return firstOperand / secondOperand
            case .mod:
                return firstOperand
                    .truncatingRemainder(dividingBy: secondOperand)
            case .none:
                return firstOperand
        }
    }

    // MARK: Private

    private var firstOperand: Double
    private var secondOperand: Double
    private var opr: Operator?
}
