//
//  FinishedController.swift
//  iQuiz
//
//  Created by Katie Hsu on 2/18/26.
//

import UIKit

class FinishedController: UIViewController {
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var finalScore: Int = 0
    let totalQuestions: Int = 1 // hardcoded 1 question

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Requirement: Display score (x of y)
        scoreLabel.text = "\(finalScore) of \(totalQuestions) correct"
        
        // Requirement: Descriptive text
        if finalScore == totalQuestions {
            descriptionLabel.text = "Perfect!"
        } else {
            descriptionLabel.text = "Almost!"
        }
    }
}
