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
    
    // Properties to fix your "has no member" errors
        var quiz: QuizTopic?
        var questionIndex: Int = 0
        
        // Data passed from QuestionController
        var questionReceived: String?
        var userPick: String?
        var correctAnswer: String?
        var currentScore: Int = 0
        var totalAnswered: Int = 0

        override func viewDidLoad() {
            super.viewDidLoad()
            
            let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
            swipeRight.direction = .right
            view.addGestureRecognizer(swipeRight)
            
            questionLabel.text = questionReceived
            
            // Logic to determine if user was correct
            if userPick == correctAnswer {
                resultLabel.text = "Correct!"
                resultLabel.textColor = .systemGreen
                // Note: If you increment score in QuestionController's prepare,
                // you don't need to do it again here.
            } else {
                resultLabel.text = "Incorrect"
                resultLabel.textColor = .systemRed
            }
            
            correctLabel.text = "The correct answer was: \(correctAnswer ?? "")"
        }
        
        @objc func handleSwipe() {
            guard let currentQuiz = quiz else { return }
            
            // PART 4 LOGIC: Check if more questions exist in the JSON
            if questionIndex + 1 < currentQuiz.questions.count {
                performSegue(withIdentifier: "backToQuestion", sender: self)
            } else {
                performSegue(withIdentifier: "showFinished", sender: self)
            }
        }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToQuestion",
           let dest = segue.destination as? QuestionController {
            // Pass the quiz data along
            dest.quiz = self.quiz
            // Advance the index by 1 so the next question shows
            dest.questionIndex = self.questionIndex + 1
            // Keep the current score
            dest.currentScore = self.currentScore
        } else if segue.identifier == "showFinished",
                  let dest = segue.destination as? FinishedController {
            // Send the final score to the results screen
            dest.finalScore = self.currentScore
                dest.totalQuestionsAnswered = quiz?.questions.count ?? totalAnswered
        }
    }
    @IBAction func nextButtonPressed(_ sender: Any) {
        guard let totalQuestions = quiz?.questions.count else { return }
        
        // Check if the current question is NOT the last one
        if questionIndex + 1 < totalQuestions {
            // Go back to the Question screen
            performSegue(withIdentifier: "backToQuestion", sender: self)
        } else {
            // Go to the final Finished screen
            performSegue(withIdentifier: "showFinished", sender: self)
        }
    }
}
