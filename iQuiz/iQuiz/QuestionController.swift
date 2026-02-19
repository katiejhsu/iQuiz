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
        
        questionLabel.text = "testQuestion"
        let option1 = UIAction(title: "CorrectAns") { action in
            self.selectedAnswer = action.title
            self.answerChoices.setTitle(action.title, for: .normal)
        }
        let option2 = UIAction(title: "IncorrectAns") { action in
            self.selectedAnswer = action.title
            self.answerChoices.setTitle(action.title, for: .normal)
        }
        
        answerChoices.menu = UIMenu(children: [option1, option2])
        answerChoices.showsMenuAsPrimaryAction = true
        answerChoices.changesSelectionAsPrimaryAction = false
        
        answerChoices.setTitle("Click for answer choices", for: .normal)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if let destination = segue.destination as? AnswerController {
                destination.userPick = self.selectedAnswer
                destination.correctAnswer = "CorrectAns" // Hardcoded for this draft
            }
        }
}
