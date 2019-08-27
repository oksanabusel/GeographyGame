
import UIKit

class MainMenuController: UIViewController {
    
    @IBOutlet weak var canselButton:       UIButton!
    @IBOutlet weak var buyCathegoryButton: UIButton!
    @IBOutlet weak var lockButton:         UIButton!
    @IBOutlet weak var citiesButton:       UIButton!
    @IBOutlet weak var countriesButton:    UIButton!
    @IBOutlet weak var capitalsButton:     UIButton!
    @IBOutlet weak var buyCathegoryLabel:  UILabel!
    @IBOutlet weak var buyCathegoryView:   UIView!
    
    private let defaults = UserDefaults.standard
    private var coinsNeeded: Int = 99
    
    var citiesList:    [[String:UIImage]] = []
    var countriesList: [[String:UIImage]] = []
    var capitalsList:  [[String:UIImage]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.buyCathegoryView.isHidden = true
        customizingButtons()
        
        if defaults.value(forKey: "capitalsCathegory") != nil {
            self.lockButton.isHidden = true
        }
        
        fillDataDictionary(typeOfTheTask: PrefixType.cityPrefix, array: &citiesList)
        fillDataDictionary(typeOfTheTask: PrefixType.countryPrefix, array: &countriesList)
        fillDataDictionary(typeOfTheTask: PrefixType.capitalPrefix, array: &capitalsList)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == citiesSegue {
            let destination = segue.destination as! TasksViewController
            destination.dataArray = citiesList
            destination.tasksNameLabelText = cities
        }
        
        if segue.identifier == countriesSegue {
            let destination = segue.destination as! TasksViewController
            destination.dataArray = countriesList
            destination.tasksNameLabelText = countries
        }
        
        if segue.identifier == capitalsSegue {
            let destination = segue.destination as! TasksViewController
            destination.dataArray = capitalsList
            destination.tasksNameLabelText = capitals
        }
    }
    
    func customizingButtons() {
        let radius = self.citiesButton.frame.height/2
        let smallerRadius = self.buyCathegoryButton.frame.height/2
        self.citiesButton.layer.cornerRadius       = radius
        self.countriesButton.layer.cornerRadius    = radius
        self.capitalsButton.layer.cornerRadius     = radius
        self.lockButton.layer.cornerRadius         = radius
        self.buyCathegoryButton.layer.cornerRadius = smallerRadius
        self.canselButton.layer.cornerRadius       = smallerRadius
        
        self.lockButton.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
    }

    @IBAction func tapLockButton(_ sender: Any) {
        self.buyCathegoryLabel.text = buyTaskText
        if let value = defaults.value(forKey: "coins") {
           let coins = value as! Int
            if coins < 99{
               buyCathegoryButton.isUserInteractionEnabled = false
               buyCathegoryButton.alpha = 0.3
            } else {
                buyCathegoryButton.isUserInteractionEnabled = true
                buyCathegoryButton.alpha = 1
            }
        }
        self.buyCathegoryView.isHidden = false
    }
    
    @IBAction func tapBuyCathegoryButton(_ sender: Any) {
        if let value = defaults.value(forKey: "coins") {
            var coins = value as! Int
            if coins >= coinsNeeded {
                coins -= coinsNeeded
                self.lockButton.isHidden = true
                self.buyCathegoryView.isHidden = true
                defaults.set(true, forKey: "capitalsCathegory")
                defaults.set(coins, forKey: "coins")
            }
        }
    }
    
    @IBAction func tapCanselButton(_ sender: Any) {
        self.buyCathegoryView.isHidden = true
    }
    
    func fillDataDictionary(typeOfTheTask: String, array: inout [[String:UIImage]]) {
        let fileManager = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fileManager.contentsOfDirectory(atPath: path)
        
        for item in items where item.hasPrefix(typeOfTheTask)  {
            guard let image = UIImage(named: item) else {
                return
            }
            let fileName = item.replacingOccurrences(of: typeOfTheTask, with: "").replacingOccurrences(of: ".png", with: "")
            let dictionary: [String:UIImage] = [fileName:image]
            
            array.append(dictionary)
        }
    }
    
}
