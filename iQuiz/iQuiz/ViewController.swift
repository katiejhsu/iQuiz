//
//  ViewController.swift
//  iQuiz
//
//  Created by Katie Hsu on 2/11/26.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    //in-memory array for testing
    var quizzes: [QuizTopic] = []

    override func viewDidLoad() {
            super.viewDidLoad()
            tableView.dataSource = self
            
            // clicks trigger didSelectRowAt
            tableView.delegate = self
            
            let url = UserDefaults.standard.string(forKey: "quiz_url") ?? "http://tednewardsandbox.site44.com/questions.json"
            fetchData(from: url)
        
        // test offline-> gives json file directory
        print("File Path: \(getFilePath())")
        }
    
    // for if a user changes url in settings app then comes back to app
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let url = UserDefaults.standard.string(forKey: "quiz_url") ?? "http://tednewardsandbox.site44.com/questions.json"
        fetchData(from: url)
    }
    
    // perform the segue
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showQuestion", sender: self)
        
        // deselect the row so it doesn't stay gray
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // for correct num of cells requirement
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizzes.count
    }
    // closes the old screen instead of piling a new one over the old one
    @IBAction func unwindToMain(segue: UIStoryboardSegue) {}
    
    @IBAction func settingsPressed(_ sender: Any) {
        // replaced old popup code with link to settings bundle in apple settings
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // use a generic identifier
        let cell = tableView.dequeueReusableCell(withIdentifier: "quizCell", for: indexPath)
        
        let quiz = quizzes[indexPath.row]
        cell.textLabel?.text = quiz.title
        cell.detailTextLabel?.text = quiz.desc
        
        var imageName = ""
                switch quiz.title {
                case "Mathematics":
                    imageName = "math"
                case "Marvel Super Heroes":
                    imageName = "marvel"
                case "Science!":
                    imageName = "science"
                default:
                    imageName = "math"
                }
                cell.imageView?.image = UIImage(named: imageName)
        
        return cell
    }
    
    func fetchData(from urlString: String) {
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            // if internet fails, try to load the local file
            if let networkError = error {
                print("Network Error: \(networkError.localizedDescription)")
                self.loadLocalData()
                return
            }

            if let jsonData = data {
                let decoder = JSONDecoder()
                do {
                    let decodedQuizzes = try decoder.decode([QuizTopic].self, from: jsonData)
                    
                    // save this data for offline use
                    self.saveDataToDisk(jsonData)

                    DispatchQueue.main.async {
                        self.quizzes = decodedQuizzes
                        self.tableView.reloadData()
                    }
                } catch {
                    print("Decoding Error: \(error)")
                    self.loadLocalData() // fallback if the JSON itself is broken
                }
            }
        }.resume()
    }
    
    // helper funcs for offline
    func getFilePath() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent("quizzes.json")
    }

    func saveDataToDisk(_ data: Data) {
        try? data.write(to: getFilePath())
    }

    func loadLocalData() {
        if let localData = try? Data(contentsOf: getFilePath()),
           let decoded = try? JSONDecoder().decode([QuizTopic].self, from: localData) {
            DispatchQueue.main.async {
                self.quizzes = decoded
                self.tableView.reloadData()
            }
        }
    }
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showQuestion",
           let dest = segue.destination as? QuestionController,
           let indexPath = tableView.indexPathForSelectedRow {
            dest.quiz = quizzes[indexPath.row]
            dest.questionIndex = 0
            dest.currentScore = 0
        }
    }
    
}

