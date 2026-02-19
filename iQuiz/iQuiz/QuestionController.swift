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
    
    var selectedAnswer: String = ""
    var currentScore: Int = 0
    var totalAnswered: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
  
        view.addGestureRecognizer(swipeRight)
        
        questionLabel.text = "Hardcoded Question 1 Text"
        let option1 = UIAction(title: "The Correct Answer") { action in
            self.selectedAnswer = action.title
            self.answerChoices.setTitle(action.title, for: .normal)
            // update checkmarks
            self.updateMenuSelection(selectedTitle: action.title)
        }
        let option2 = UIAction(title: "The Incorrect Answer") { action in
            self.selectedAnswer = action.title
            self.answerChoices.setTitle(action.title, for: .normal)
            // updated checkmarks
            self.updateMenuSelection(selectedTitle: action.title)
        }
        
        answerChoices.menu = UIMenu(children: [option1, option2])
        answerChoices.showsMenuAsPrimaryAction = true
        answerChoices.changesSelectionAsPrimaryAction = false
        
        answerChoices.setTitle("Click Me for Answer Choices:", for: .normal)
    }
    func updateMenuSelection(selectedTitle: String) {
            answerChoices.menu?.children.forEach { action in
                guard let action = action as? UIAction else { return }
                action.state = (action.title == selectedTitle) ? .on : .off
            }
        }
    @objc func handleSwipe() {
            performSegue(withIdentifier: "showAnswer", sender: self)
        }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? AnswerController {
            destination.userPick = self.selectedAnswer
            destination.correctAnswer = "The Correct Answer"
            destination.questionReceived = self.questionLabel.text
            
            destination.currentScore = self.currentScore
            // increment the total so it equals 1 for the first question
            destination.totalAnswered = self.totalAnswered + 1
        }
    }
}
