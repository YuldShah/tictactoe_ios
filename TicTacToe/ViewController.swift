//
//  ViewController.swift
//  TicTacToe
//
//  Created by PU2025-17 on 21/04/25.
//

import UIKit

class ViewController: UIViewController {

    enum Turn {
        case Nought
        case Cross
    }

    var firstTurn = Turn.Cross
    var currentTurn = Turn.Cross

    var NOUGHT = "O"
    var CROSS = "X"
    var board = [UIButton]()
    var winningLine: CAShapeLayer?

    @IBOutlet weak var turnLabel: UILabel!
    @IBOutlet weak var a1: UIButton!
    @IBOutlet weak var a2: UIButton!
    @IBOutlet weak var a3: UIButton!
    @IBOutlet weak var b1: UIButton!
    @IBOutlet weak var b2: UIButton!
    @IBOutlet weak var b3: UIButton!
    @IBOutlet weak var c1: UIButton!
    @IBOutlet weak var c2: UIButton!
    @IBOutlet weak var c3: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        initBoard()
    }

    func initBoard() {
        board.append(contentsOf: [a1, a2, a3, b1, b2, b3, c1, c2, c3])
    }

    @IBAction func boardTapAction(_ sender: UIButton) {
        addToBoard(sender)

        if let winButtons = checkForVictory(NOUGHT) {
            drawWinningLine(over: winButtons, for: NOUGHT)
            resultAlert(title: "Noughts Win!")
        } else if let winButtons = checkForVictory(CROSS) {
            drawWinningLine(over: winButtons, for: CROSS)
            resultAlert(title: "Crosses Win!")
        } else if isFullBoard() {
            resultAlert(title: "Draw")
        }
    }

    func resultAlert(title: String) {
        let ac = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Reset", style: .default, handler: { _ in
            self.resetBoard()
        }))
        present(ac, animated: true)
    }

    func resetBoard() {
        for button in board {
            button.setTitle(nil, for: .normal)
            button.isEnabled = true
        }

        winningLine?.removeFromSuperlayer()
        winningLine = nil

        if firstTurn == .Cross {
            firstTurn = .Nought
            turnLabel.text = NOUGHT
            turnLabel.textColor = .red
        } else {
            firstTurn = .Cross
            turnLabel.text = CROSS
            turnLabel.textColor = .black
        }

        currentTurn = firstTurn
    }

    func isFullBoard() -> Bool {
        return !board.contains(where: { $0.title(for: .normal) == nil })
    }

    func checkForVictory(_ symbol: String) -> [UIButton]? {
        let winningCombos: [[UIButton]] = [
            [a1, a2, a3], [b1, b2, b3], [c1, c2, c3], // Rows
            [a1, b1, c1], [a2, b2, c2], [a3, b3, c3], // Columns
            [a1, b2, c3], [a3, b2, c1]                // Diagonals
        ]

        for combo in winningCombos {
            if combo.allSatisfy({ $0.title(for: .normal) == symbol }) {
                return combo
            }
        }
        return nil
    }

    func drawWinningLine(over buttons: [UIButton], for symbol: String) {
        guard let first = buttons.first, let last = buttons.last else { return }

        let start = first.superview!.convert(first.center, to: view)
        let end = last.superview!.convert(last.center, to: view)

        let path = UIBezierPath()
        path.move(to: start)
        path.addLine(to: end)

        let line = CAShapeLayer()
        line.path = path.cgPath
        line.lineWidth = 5.0
        line.lineCap = .round
        line.strokeColor = (symbol == NOUGHT ? UIColor.black : UIColor.red).cgColor

        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 0.4
        line.add(animation, forKey: "line")

        view.layer.addSublayer(line)
        winningLine = line
    }

    func addToBoard(_ sender: UIButton) {
        guard sender.title(for: .normal) == nil else { return }

        sender.isEnabled = false

        if currentTurn == .Nought {
            sender.setTitle(NOUGHT, for: .normal)
            sender.setTitleColor(.red, for: .disabled)
            currentTurn = .Cross
            turnLabel.text = CROSS
            turnLabel.textColor = .black
        } else {
            sender.setTitle(CROSS, for: .normal)
            sender.setTitleColor(.black, for: .disabled)
            currentTurn = .Nought
            turnLabel.text = NOUGHT
            turnLabel.textColor = .red
        }
    }
}
