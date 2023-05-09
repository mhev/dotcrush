import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScoreCell", for: indexPath)
        
        if scores.isEmpty {
            cell.textLabel?.text = ""
            cell.textLabel?.textAlignment = .center
        } else {
            let sortedScores = scores.sorted(by: >)
            let score = sortedScores[indexPath.row]
            cell.textLabel?.text = "\(score)"
            cell.backgroundColor = UIColor.systemTeal // Set all cells to blue
            
            // Set text color based on score ranking
            if score == sortedScores.first {
                cell.textLabel?.textColor = UIColor.yellow
            } else if score == sortedScores[1] {
                cell.textLabel?.textColor = UIColor.gray
            } else if score == sortedScores[2] {
                cell.textLabel?.textColor = UIColor.brown
            }else {
                cell.textLabel?.textColor = UIColor.systemTeal
            }

            
            // Set font size and alignment
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            cell.textLabel?.textAlignment = .center
        }
        
        return cell
    }




    

    @IBOutlet var startPressed: UIImageView!
    @IBOutlet var tappableLogo: UILabel!

    @IBOutlet var counterLabel: UILabel!
    
    @IBOutlet var timerLabel: UILabel!
            
    @IBOutlet var topScoresLabel: UILabel!
    
    @IBOutlet var scoreBox: UITableView!
    
    @IBOutlet var highScore1: UILabel!
    
    var scores: [Int] = []
    var timer: Timer?
    var counter = 0 {
        didSet {
            if counter == 1 {
                startTimer()
            }
            counterLabel.text = "Count: \(counter)"
        }
    }
    
    
    var timerValue = 30 {
        didSet {
            if timerValue <= 0 {
                timerLabel.text = "Time's up!"
                scores.append(counter)
                print(scores)
                sleep(2)
                counter = 0
                startPressed.center = view.center
                topScoresLabel.isHidden = false
                scoreBox.isHidden = false
                tappableLogo.isHidden = false
                timerLabel.isHidden = true
                counterLabel.isHidden = true
                if highScore1.text == "Label"{
                    highScore1.isHidden = true
                }else{
                    highScore1.isHidden = false
                }

                timer?.invalidate()
                timer = nil
                timerLabel.text = "Timer: \(timerValue)"

                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                    self.timerValue = 30
                    self.timerLabel.text = "Timer: \(self.timerValue)"

                    let sortedScores = self.scores.sorted(by: >)
                    self.highScore1.text = sortedScores.map({ String($0) }).joined(separator: ", ")

                    // Save the scores to UserDefaults
                    UserDefaults.standard.set(sortedScores, forKey: "scores")
                    UserDefaults.standard.synchronize()

                    // Reload the scores in the table view
                    self.scores = sortedScores
                    self.scoreBox.reloadData()

                }
            } else {
                timerLabel.text = "Timer: \(timerValue)"
            }
        }
    }
    
    func saveScores() {
        UserDefaults.standard.set(scores, forKey: "scores")
    }

    
    
    func startTimer() {
            // invalidate the current timer and create a new one
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                if self.timerValue > 0 {
                    self.timerValue -= 1
                }
            }
            timer?.fire()
        }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
   
        topScoresLabel.center.y = view.center.y

        scoreBox.center = view.center
        
        let bottomMargin: CGFloat = 40.0

        let verticalMargin: CGFloat = 40.0

        let scoreBoxY = view.bounds.height - scoreBox.bounds.height / 2.0 - bottomMargin

        scoreBox.center = CGPoint(x: view.bounds.midX, y: scoreBoxY)

        let topScoresLabelY = scoreBox.frame.origin.y - topScoresLabel.bounds.height / 2.0 - verticalMargin

        topScoresLabel.center = CGPoint(x: scoreBox.center.x, y: topScoresLabelY)


        scoreBox.backgroundColor = UIColor.systemTeal


        scoreBox.dataSource = self
        scoreBox.register(UITableViewCell.self, forCellReuseIdentifier: "ScoreCell")
        if let savedScores = UserDefaults.standard.array(forKey: "scores") as? [Int] {
            scores = savedScores
        }

        // Add a tap gesture recognizer to the startPressed UIImageView
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        startPressed.addGestureRecognizer(tapGesture)
        startPressed.isUserInteractionEnabled = true

        // Generate a random position for the startPressed UIImageView
        changePosition()
        topScoresLabel.isHidden = false
        counterLabel.isHidden = true
        timerLabel.isHidden = true
        scoreBox.isHidden = false
        highScore1.isHidden = highScore1.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true || highScore1.text == "Label"
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        // Generate a new random position for the startPressed UIImageView

        changePosition()
        timerLabel.isHidden = false
        counterLabel.isHidden = false
        scoreBox.isHidden = true
        highScore1.isHidden = true
        
        // Hide the tappableLogo UILabel
        tappableLogo.isHidden = true
        topScoresLabel.isHidden = true

        
        counter += 1
        
    }
    
    func changePosition() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let safeAreaInsets = UIApplication.shared.windows.first?.safeAreaInsets ?? UIEdgeInsets.zero
        
        let imageViewWidth = startPressed.frame.width
        let imageViewHeight = startPressed.frame.height
        
        let minX = Int(safeAreaInsets.left)
        let maxX = Int(screenWidth - imageViewWidth - safeAreaInsets.right)
        
        let minY = Int(safeAreaInsets.top)
        let maxY = Int(screenHeight - imageViewHeight - safeAreaInsets.bottom)
        
        let randomX = Int.random(in: minX...maxX)
        let randomY = Int.random(in: minY...maxY)
        
        startPressed.frame.origin = CGPoint(x: randomX, y: randomY)
    }





}
