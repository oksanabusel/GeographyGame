
import UIKit

class TaskTableViewCell: UITableViewCell {
    
    @IBOutlet weak var roundView: UIView!
    @IBOutlet weak var taskLabel: UILabel!
    
    private let defaults = UserDefaults.standard

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let radius = self.roundView.frame.height/2
        roundView.layer.cornerRadius = radius
    }
    
    func setData(taskDescription: [[String:UIImage]], index: IndexPath) {
        let numberOfTheRow = index.row + 1
        
        let questionDictionary = taskDescription[index.row]
        let dictKey = Array(questionDictionary.keys)
        
        if defaults.bool(forKey: dictKey[0]) {
             self.taskLabel.textColor = .green
        }
        self.taskLabel.text = task + "#" + String(numberOfTheRow)
    }
    
}
