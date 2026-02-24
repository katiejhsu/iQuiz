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
        var totalQuestionsAnswered: Int = 0
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            // update the score text based on dynamic JSON data
            scoreLabel.text = "You got \(finalScore) out of \(totalQuestionsAnswered) correct!"
            
            // custom messages
            if finalScore == totalQuestionsAnswered && totalQuestionsAnswered > 0 {
                descriptionLabel.text = "Perfect!"
            } else if finalScore > (totalQuestionsAnswered / 2) {
                descriptionLabel.text = "Almost!"
            } else {
                descriptionLabel.text = "Better luck next time!"
            }
        }
}
