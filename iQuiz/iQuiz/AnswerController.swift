//
//  AnswerController.swift
//  iQuiz
//
//  Created by Katie Hsu on 2/18/26.
//

import UIKit

class AnswerController: UIViewController {
    @IBOutlet weak var resultLabel: UILabel! // "Correct" or "Incorrect"
    @IBOutlet weak var correctLabel: UILabel! // "The answer was: The Correct Answer"
    
    @IBOutlet weak var questionLabel: UILabel!
    
    var questionReceived: String?
    var userPick: String?
    var correctAnswer: String?
    var currentScore: Int = 0
    var totalAnswered: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionLabel.text = questionReceived
        
        // Update labels based on the data passed
        if userPick == correctAnswer {
            resultLabel.text = "Correct!"
            resultLabel.textColor = .systemGreen
            currentScore += 1
        } else {
            resultLabel.text = "Incorrect"
            resultLabel.textColor = .systemRed
        }
        
        correctLabel.text = "The correct answer was: \(correctAnswer ?? "")"
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if let destination = segue.destination as? FinishedController {
                destination.finalScore = self.currentScore
                destination.totalQuestionsAnswered = self.totalAnswered
            }
        }
}
