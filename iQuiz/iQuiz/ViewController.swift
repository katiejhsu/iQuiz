//
//  ViewController.swift
//  iQuiz
//
//  Created by Katie Hsu on 2/11/26.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    //in-memory array for testing
    let quizzes = [
        (title: "Mathematics", desc: "Math Quiz on Algebra + Geometry."),
        (title: "Marvel Super Heroes", desc: "Superhero Quiz on Superman and Ironman"),
        (title: "Science", desc: "Science Quiz on Physics and Biology")
    ]
    
    let questions = [
        (question: "Test Math Question", ans1: "mathans1", ans2: "mathans2"),
        (question: "Test Marvel Question", ans1: "marvelans1", ans2: "marvelans2"),
        (question: "Test Science Question", ans1: "scienceans1", ans2: "scienceans2"),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // use this file for data
        tableView.dataSource = self
    }
    
    // for correct num of cells requirement
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizzes.count
    }
    // closes the old screen instead of piling a new one over the old one
    @IBAction func unwindToMain(segue: UIStoryboardSegue) {}
    
    @IBAction func settingsPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Settings", message: "Settings go here", preferredStyle: .alert)
        // ok button
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //display the table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier: String
            
        // match identifiers hardcoded in storyboard
        switch indexPath.row {
        case 0: identifier = "math"  // Changed from MathCell to math
        case 1: identifier = "marvel"
        case 2: identifier = "science"
        default: identifier = "math"
        }
            
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
            return cell
        }

}

