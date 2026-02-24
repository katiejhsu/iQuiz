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

        var quiz: QuizTopic?
        var questionIndex: Int = 0
        
        // data passed from QuestionController
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
            
            // determine if user was correct
            if userPick == correctAnswer {
                resultLabel.text = "Correct!"
                resultLabel.textColor = .systemGreen
            } else {
                resultLabel.text = "Incorrect"
                resultLabel.textColor = .systemRed
            }
            
            correctLabel.text = "The correct answer was: \(correctAnswer ?? "")"
        }
        
        @objc func handleSwipe() {
            guard let currentQuiz = quiz else { return }
            
            // check if more questions exist in the JSON
            if questionIndex + 1 < currentQuiz.questions.count {
                performSegue(withIdentifier: "backToQuestion", sender: self)
            } else {
                performSegue(withIdentifier: "showFinished", sender: self)
            }
        }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToQuestion",
           let dest = segue.destination as? QuestionController {
            // pass the quiz data along
            dest.quiz = self.quiz
            // inc index by 1 so the next question shows
            dest.questionIndex = self.questionIndex + 1
            // keep the current score
            dest.currentScore = self.currentScore
        } else if segue.identifier == "showFinished",
                  let dest = segue.destination as? FinishedController {
            // send the final score to the results screen
            dest.finalScore = self.currentScore
                dest.totalQuestionsAnswered = quiz?.questions.count ?? totalAnswered
        }
    }
    @IBAction func nextButtonPressed(_ sender: Any) {
        guard let totalQuestions = quiz?.questions.count else { return }
        
        // check if the current question is NOT the last one
        if questionIndex + 1 < totalQuestions {
            // go back to the Question screen
            performSegue(withIdentifier: "backToQuestion", sender: self)
        } else {
            // go to the final Finished screen
            performSegue(withIdentifier: "showFinished", sender: self)
        }
    }
}
