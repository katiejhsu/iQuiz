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
    var quizzes: [QuizTopic] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // use this file for data
        tableView.dataSource = self
        
        // download json
        let url = UserDefaults.standard.string(forKey: "quiz_url") ?? "http://tednewardsandbox.site44.com/questions.json"
        fetchData(from: url)
    }
    
    // for correct num of cells requirement
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizzes.count
    }
    // closes the old screen instead of piling a new one over the old one
    @IBAction func unwindToMain(segue: UIStoryboardSegue) {}
    
    @IBAction func settingsPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Settings", message: "Enter Quiz URL", preferredStyle: .alert)
            
            // Add a url field to the popup for alt sources (default to the curr quiz json)
            alert.addTextField { (textField) in
                textField.text = UserDefaults.standard.string(forKey: "quiz_url") ?? "http://tednewardsandbox.site44.com/questions.json"
            }

        // check now button for updates
            alert.addAction(UIAlertAction(title: "Check Now", style: .default, handler: { [weak alert] (_) in
                if let newURL = alert?.textFields?[0].text {
                    // save the new url
                    // settings persistence requirement
                    UserDefaults.standard.set(newURL, forKey: "quiz_url")
                    // fetch the data from new url
                    self.fetchData(from: newURL)
                }
            }))
            
            // back/cancel button
            alert.addAction(UIAlertAction(title: "Back/Cancel", style: .cancel))
            self.present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Use a generic identifier (make sure one cell in Storyboard has this ID)
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
    
    // fetches data from site
        func fetchData(from urlString: String) {
            guard let url = URL(string: urlString) else { return }

            URLSession.shared.dataTask(with: url) { (data, response, error) in
                // PART 1: OFFLINE FALLBACK
                // If an error occurs (like no internet), check local storage
                if let networkError = error {
                    print("Network Error: \(networkError.localizedDescription)") // Uses error to avoid warning
                    
                    // Try to load from the local JSON file
                    if let localData = try? Data(contentsOf: self.getFilePath()),
                       let decoded = try? JSONDecoder().decode([QuizTopic].self, from: localData) {
                        
                        DispatchQueue.main.async {
                            self.quizzes = decoded
                            self.tableView.reloadData()
                        }
                    } else {
                        // ONLY show popup if BOTH network and local storage fail
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "No Connection",
                                                          message: "Please connect to the internet to download quizzes.",
                                                          preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default))
                            self.present(alert, animated: true)
                        }
                    }
                    return
                }

                guard let jsonData = data else { return }

                let decoder = JSONDecoder()
                do {
                    let decodedQuizzes = try decoder.decode([QuizTopic].self, from: jsonData)
                    
                    // PART 2: SAVE FOR OFFLINE
                    // save downloaded data to disk for future offline use
                    self.saveDataToDisk(jsonData)
                    
                    DispatchQueue.main.async {
                        self.quizzes = decodedQuizzes
                        self.tableView.reloadData()
                    }
                } catch {
                    print("JSON Decoding Error: \(error)")
                    // Optional: Fallback to local data if the new download is corrupted
                    self.loadLocalData()
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
    
}

