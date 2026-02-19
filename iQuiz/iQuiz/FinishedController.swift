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
        

        scoreLabel.text = "\(finalScore) of \(totalQuestionsAnswered) correct"
        
        if finalScore == totalQuestionsAnswered && totalQuestionsAnswered > 0 {
                descriptionLabel.text = "Perfect!"
            } else {
                descriptionLabel.text = "Almost!"
            }
    }
}
