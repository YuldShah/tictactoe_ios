//
//  ViewController.swift
//  TicTacToe
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
    var noughtsScore = 0
    var crossesScore = 0
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
        // initialize the board
        initBoard()
    }

    func initBoard() {
        // add buttons to board manually
        board.append(a1)
        board.append(a2)
        board.append(a3)
        board.append(b1)
        board.append(b2)
        board.append(b3)
        board.append(c1)
        board.append(c2)
        board.append(c3)
    }

    @IBAction func boardTapAction(_ sender: UIButton) {
        // handle button tap and check for victory or draw
        addToBoard(sender)

        let noughtWinButtons = checkForVictory(NOUGHT)
        if noughtWinButtons != nil {
            drawWinningLine(over: noughtWinButtons!, for: NOUGHT)
            noughtsScore += 1
            resultAlert(title: "Noughts Win!\n\nScore:\nNoughts - \(noughtsScore)\nCrosses - \(crossesScore)")
            return
        }

        let crossWinButtons = checkForVictory(CROSS)
        if crossWinButtons != nil {
            drawWinningLine(over: crossWinButtons!, for: CROSS)
            crossesScore += 1
            resultAlert(title: "Crosses Win!\n\nScore:\nNoughts - \(noughtsScore)\nCrosses - \(crossesScore)")
            return
        }

        if isFullBoard() {
            resultAlert(title: "Draw\n\nScore:\nNoughts - \(noughtsScore)\nCrosses - \(crossesScore)")
        }
    }

    @IBAction func tapInfoButton(_ sender: UIButton) {
        // show game information
        let ac = UIAlertController(title: "Information", message: "This is a Tic-Tac-Toe game. The game is played with X and O symbols. The first player to get three in a row wins!\n\nDeveloped by FPS team", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Thanks for wonderful game!", style: .default, handler: nil))
        present(ac, animated: true)
    }

    @IBAction func theyGottaBeJoking(_ sender: UIButton) {
        // show quit confirmation
        let ac = UIAlertController(title: "You wanna quit?", message: "You can't just quit, you can't just give up, okay? You gotta fight for it, till the end! Actually, there is no end.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "I'm not going to give up", style: .default, handler: nil))
        present(ac, animated: true)
    }

    func resultAlert(title: String) {
        // show result alert and reset board
        let ac = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Reset", style: .default, handler: { _ in
            self.resetBoard()
        }))
        present(ac, animated: true)
    }

    func resetBoard() {
        // reset all buttons and turn
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
        // check if any button is empty
        for button in board {
            if button.title(for: .normal) == nil {
                return false
            }
        }
        return true
    }

    func checkForVictory(_ symbol: String) -> [UIButton]? {
        // define all winning combinations
        let winningCombos: [[UIButton]] = [
            [a1, a2, a3], [b1, b2, b3], [c1, c2, c3], // rows
            [a1, b1, c1], [a2, b2, c2], [a3, b3, c3], // columns
            [a1, b2, c3], [a3, b2, c1]                // diagonals
        ]

        for combo in winningCombos {
            // check if all buttons in combo match symbol
            var allMatch = true
            for button in combo {
                if button.title(for: .normal) != symbol {
                    allMatch = false
                    break
                }
            }
            if allMatch {
                return combo
            }
        }
        return nil
    }

    func drawWinningLine(over buttons: [UIButton], for symbol: String) {
        // draw a line over the winning buttons
        if buttons.first == nil || buttons.last == nil {
            return
        }
        let first = buttons.first!
        let last = buttons.last!

        let start = first.superview!.convert(first.center, to: view)
        let end = last.superview!.convert(last.center, to: view)

        let path = UIBezierPath()
        path.move(to: start)
        path.addLine(to: end)

        let line = CAShapeLayer()
        line.path = path.cgPath
        line.lineWidth = 5.0
        line.lineCap = .round
        
        if symbol == NOUGHT {
            line.strokeColor = UIColor.black.cgColor
        } else {
            line.strokeColor = UIColor.red.cgColor
        }

        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 0.4
        line.add(animation, forKey: "line")

        view.layer.addSublayer(line)
        winningLine = line
    }

    func addToBoard(_ sender: UIButton) {
        // add symbol to button and update turn
        if sender.title(for: .normal) != nil {
            return
        }

        sender.isEnabled = false

        if currentTurn == .Nought {
            sender.setTitle(NOUGHT, for: .normal)
            sender.setTitleColor(.red, for: .normal)
            sender.setTitleColor(.red, for: .disabled)
            currentTurn = .Cross
            turnLabel.text = CROSS
            turnLabel.textColor = .black
        } else {
            sender.setTitle(CROSS, for: .normal)
            sender.setTitleColor(.black, for: .normal)
            sender.setTitleColor(.black, for: .disabled)
            currentTurn = .Nought
            turnLabel.text = NOUGHT
            turnLabel.textColor = .red
        }
    }
}
