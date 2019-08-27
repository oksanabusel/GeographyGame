
import UIKit

class TasksViewController: UIViewController {

    @IBOutlet weak var tasksTableView: UITableView!
    @IBOutlet weak var coinsLabel: UILabel!
    @IBOutlet weak var tasksNameLabel: UILabel!
    
    private let defaults = UserDefaults.standard
    private var selectedRowIndex: Int?
    private var counter:          Int = 0

    var dataArray: [[String:UIImage]] = [[:]]
    var tasksNameLabelText: String    = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tasksNameLabel.text = tasksNameLabelText
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkCoinsQuantity()
        counter += 1

        if counter >= 2 {
          self.tasksTableView.reloadData()
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func checkCoinsQuantity() {
        if let value = defaults.value(forKey: "coins") {
            let coins = value as! Int
            coinsLabel.text = String(coins)
        }
    }
    
    func checkIfAlreadyAnswered() {
       
    }

    @IBAction func tapBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == toGameScreenSegue {
            let destination = segue.destination as!  GameScreenController
            if let index = selectedRowIndex {
                destination.question = dataArray[index]
                destination.questionCathegory = tasksNameLabelText
            }
        }
    }
    
}

extension TasksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.setData(taskDescription: dataArray, index: indexPath)
        
        return cell
    }
    
}

extension TasksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedRowIndex = indexPath.row
        
        return indexPath
    }
    
}
