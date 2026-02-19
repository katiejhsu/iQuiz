//
//  AnswerController.swift
//  iQuiz
//
//  Created by Katie Hsu on 2/18/26.
//

import UIKit

class AnswerController: UIViewController {
    @IBOutlet weak var resultLabel: UILabel! // "Correct" or "Incorrect"
    @IBOutlet weak var correctLabel: UILabel! // "The answer was: Olympia"
    
    var userPick: String?
    var correctAnswer: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Update labels based on the data passed
        if userPick == correctAnswer {
            resultLabel.text = "Correct!"
            resultLabel.textColor = .systemGreen
        } else {
            resultLabel.text = "Incorrect"
            resultLabel.textColor = .systemRed
        }
        
        correctLabel.text = "The correct answer was: \(correctAnswer ?? "")"
    }
}
