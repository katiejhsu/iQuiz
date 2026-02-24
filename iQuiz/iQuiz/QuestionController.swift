//
//  QuestionController.swift
//  iQuiz
//
//  Created by Katie Hsu on 2/18/26.
//

import UIKit

class QuestionController: UIViewController {
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var answerChoices: UIButton!
    // code
    
    var quiz: QuizTopic?
        var questionIndex: Int = 0
        var currentScore: Int = 0
        
        var selectedAnswerIndex: Int? // Track the index (1, 2, 3, or 4) to compare with JSON
        var selectedAnswerText: String = ""

        override func viewDidLoad() {
            super.viewDidLoad()
            
            setupSwipe()
            loadQuestionData()
        }
        
        func loadQuestionData() {
            guard let currentQuiz = quiz else { return }
            let questionData = currentQuiz.questions[questionIndex]
            
            // 1. Set the Question Text
            questionLabel.text = questionData.text
            
            // 2. Build the menu options dynamically from the JSON array
            var menuOptions: [UIAction] = []
            
            for (index, answerText) in questionData.answers.enumerated() {
                let action = UIAction(title: answerText) { action in
                    self.selectedAnswerText = action.title
                    self.selectedAnswerIndex = index + 1 // JSON answers are usually 1-indexed
                    self.answerChoices.setTitle(action.title, for: .normal)
                    self.updateMenuSelection(selectedTitle: action.title)
                }
                menuOptions.append(action)
            }
            
            // 3. Attach the dynamic menu to the button
            answerChoices.menu = UIMenu(children: menuOptions)
            answerChoices.showsMenuAsPrimaryAction = true
            answerChoices.setTitle("Select an Answer:", for: .normal)
        }

        func updateMenuSelection(selectedTitle: String) {
            answerChoices.menu?.children.forEach { action in
                guard let action = action as? UIAction else { return }
                action.state = (action.title == selectedTitle) ? .on : .off
            }
        }

        @objc func handleSwipe() {
            // Only allow swipe if an answer was picked
            if selectedAnswerIndex != nil {
                performSegue(withIdentifier: "showAnswer", sender: self)
            } else {
                // Optional: alert the user to pick an answer first
            }
        }

        func setupSwipe() {
            let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
            swipeRight.direction = .right
            view.addGestureRecognizer(swipeRight)
        }

        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if let destination = segue.destination as? AnswerController {
                guard let currentQuiz = quiz else { return }
                let questionData = currentQuiz.questions[questionIndex]
                
                // Pass the data to the Answer screen
                destination.quiz = self.quiz
                destination.questionIndex = self.questionIndex
                destination.userPick = self.selectedAnswerText
                
                // Get the correct answer text using the 'answer' index from JSON
                let correctIdx = Int(questionData.answer)! - 1 // convert "1" to index 0
                destination.correctAnswer = questionData.answers[correctIdx]
                
                destination.questionReceived = questionData.text
                
                // Check if user was right and update score
                let userIsCorrect = (String(self.selectedAnswerIndex!) == questionData.answer)
                destination.currentScore = userIsCorrect ? (self.currentScore + 1) : self.currentScore
                destination.totalAnswered = self.questionIndex + 1
            }
        }
}
