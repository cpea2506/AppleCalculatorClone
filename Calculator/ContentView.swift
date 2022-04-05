//
//  ContentView.swift
//  Calculator
//
//  Created by Đỗ Viên on 25/03/2022.
//

import SwiftUI

// MARK: - KeyButtonStyle

struct KeyButtonStyle: ButtonStyle {
    var color: KeyColor

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(color.fg)
            .background(configuration.isPressed ? color.onPressBg : color.bg)
            .cornerRadius(.infinity)
    }
}

// MARK: - KeyButton

struct KeyButton: View {
    // MARK: Lifecycle

    init(label key: KeyPad, didTap: Bool, action: @escaping () -> Void) {
        self.key = key
        self.action = action
        self.didTap = didTap
    }

    // MARK: Internal

    var body: some View {
        Button(action: action) {
            Text(key.rawValue)
                .font(.system(size: 35))
                .frame(width: key.width, height: key.height)
        }
        .buttonStyle(KeyButtonStyle(color: keyColor))
    }

    // MARK: Private

    private var key: KeyPad
    private var action: () -> Void
    private var didTap: Bool

    private var keyColor: KeyColor {
        key.color(didTap: didTap)
    }
}

// MARK: - ContentView

struct ContentView: View {
    // MARK: Internal

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack {
                Spacer() // Result display
                HStack {
                    Spacer()
                    Text(result)
                        .font(.custom("HelveticaNeue-light", size: 120))
                        .foregroundColor(.white)
                }
                .padding()

                // Keypad
                ForEach(buttons, id: \.self) { row in
                    HStack(spacing: 12) {
                        ForEach(row, id: \.self) { key in
                            KeyButton(label: key, didTap: key == currentKey) {
                                currentKey = key
                                buttons[0][0] = .clear
                                keyDidTap()
                            }
                        }.padding(.bottom, 3)
                    }
                }
            }
        }
    }

    func numberDidTap() {
        let value = currentKey!.rawValue

        if currentOperator == nil {
            if hasResult {
                result = value
                hasResult = false
            } else {
                result += value
            }

            firstOperand = Double(result)!
        } else {
            if hasResult {
                currentOperator = nil
                hasResult = false
                result = value

                firstOperand = Double(result)!
            } else {
                if secondOperand.isZero {
                    result = value
                } else {
                    result += value
                }

                secondOperand = Double(result)!
            }
        }

        result = Double(result)!.removeTraillingZeros().description
    }

    func operatorDidTap() {
        if hasResult {
            secondOperand = 0.0
            hasResult = false
        } else {
            if !secondOperand.isZero {
                result = Calculator.eval(
                    firstOperand: firstOperand,
                    secondOperand: secondOperand,
                    opr: currentOperator
                )
                .removeTraillingZeros()
                .description

                firstOperand = Double(result)!
                secondOperand = 0.0
            }
        }

        currentOperator = Operator(rawValue: currentKey!.rawValue)
    }

    func plusMinusDidTap() {
        result = Calculator
            .toggleSign(operand: Double(result)!)
            .removeTraillingZeros()
            .description
    }

    func clearDidTap() {
        result = "0"
        firstOperand = 0.0
        secondOperand = 0.0
        currentOperator = nil
        buttons[0][0] = .clearAll
    }

    func keyDidTap() {
        switch currentKey {
            case .clear,
                 .clearAll:
                clearDidTap()
            case .dot:
                dotDidTap()
            case .plusMinus:
                plusMinusDidTap()
            case .opr:
                operatorDidTap()
            case .equal:
                equalDidTap()
            default:
                numberDidTap()
        }
    }

    func dotDidTap() {
        if !result.contains(".") {
            result += "."
        }
    }

    func equalDidTap() {
        let value = Calculator.eval(
            firstOperand: firstOperand,
            secondOperand: secondOperand,
            opr: currentOperator
        )

        result = value.removeTraillingZeros().description
        firstOperand = value
        hasResult = true
    }

    // MARK: Private

    @State private var currentKey: KeyPad?
    @State private var currentOperator: Operator?
    @State private var result: String = "0"
    @State private var hasResult: Bool = false
    @State private var firstOperand: Double = 0.0
    @State private var secondOperand: Double = 0.0
    @State private var buttons: [[KeyPad]] = [
        [.clearAll, .plusMinus, .opr(.mod), .opr(.div)],
        [.seven, .eight, .nine, .opr(.mul)],
        [.four, .five, .six, .opr(.minus)],
        [.one, .two, .three, .opr(.plus)],
        [.zero, .dot, .equal],
    ]
}

// MARK: - ContentView_Previews

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.portrait)
    }
}
