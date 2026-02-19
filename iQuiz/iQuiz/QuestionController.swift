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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? AnswerController {
            destination.userPick = self.selectedAnswer
            destination.correctAnswer = "The Correct Answer"
            
            // Pass the question text to satisfy the rubric
            destination.questionReceived = self.questionLabel.text
        }
    }
}
