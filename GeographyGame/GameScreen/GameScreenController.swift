
import UIKit

class GameScreenController: UIViewController {
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var winTextLabel: UILabel!
    @IBOutlet weak var winView: UIView!
    @IBOutlet weak var questionImage: UIImageView!
    @IBOutlet weak var buttonsContainer: UIView!
    @IBOutlet weak var questionLabel: UILabel!
    
    private let defaults   = UserDefaults.standard
    private var coinsForCorrectAnswer: Int = 30
    private var counter: Int = 0
    
    var buttonsArray:      [UIButton] = []
    var question:          [String:UIImage] = [:]
    var questionCathegory: String = ""
    var correctAnswer:     String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.winView.isHidden = true
        
        setQuestionCathegory()
        createQuestion(questionString: question)
        customizingButton()
    }
    
    @IBAction func tapBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func tapOkButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapDeleteButton(_ sender: Any) {
        guard let text = questionLabel.text else {
            return
        }
        if buttonsArray.count > 0 {
            let currentText = text.replacingOccurrences(of: " ", with: "")
            
            guard let index = currentText.indexInt(of: "_") else {
                return
            }
            
            let numberOfItems = buttonsArray.count
            let lastUsedButton = buttonsArray[numberOfItems - 1]
            lastUsedButton.isHidden = false
            
            buttonsArray.removeLast()
            counter -= 1

            let newString = currentText.replace("_", at: (index-1))
            let result =  newString.insertSeparator(" ", atEvery: 1)
            questionLabel.text = result
        }
    }
    
    func createQuestion(questionString: [String:UIImage]) {
        let index = question.startIndex
        let dictKey = question.keys[index]
        
        correctAnswer = dictKey
        var question = dictKey
        
        if (defaults.value(forKey: correctAnswer) != nil) {
            coinsForCorrectAnswer = 0
        }
        
        let firstQuestionPart  = String(question.remove(at: question.startIndex))
        let secondQuestionPart = String(repeating: " _ ", count: question.count - 1)
        let thirdQuestionPart  = String(question.remove(at: question.index(before: question.endIndex)))
        
        questionLabel.text = firstQuestionPart + secondQuestionPart + thirdQuestionPart
        let charsForButtons = (dictKey[1 ..< dictKey.count - 1]).shuffled()
        
        addButtons(question: String(charsForButtons))
    }
    
    func addButtons(question: String) {
        let numberOfTheButtons = question.count
        var xPoint: Int = 0
        var yPoint: Int = 0

        for i in 1...numberOfTheButtons {
            self.buttonsContainer.addSubview(createButton(title: question[i-1],
                                                      xPosition: xPoint,
                                                      yPosition: yPoint))
            xPoint += 50
            
            if i % 5 == 0 {
               xPoint = 0
               yPoint += 60
            }
        }
    }
    
    func createButton(title: String, xPosition: Int, yPosition: Int) -> UIButton {
        let button = UIButton(frame: CGRect(x: xPosition, y: yPosition, width: 25, height: 30))
        button.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        return button
    }
    
    @objc func buttonTapped(button: UIButton) {
        guard let labelText = questionLabel.text else {
            return
        }
        
        guard let buttonTitle = button.titleLabel?.text else {
            return
        }
        
        guard let index = labelText.indexInt(of: "_") else {
            return
        }
        
        let newString = labelText.replace(buttonTitle, at: index)
        questionLabel.text = newString
        
        button.isHidden = true
        buttonsArray.append(button)
        
        checkTheAnswer(answer: newString)
    }
    
    func setQuestionCathegory() {
        let index = question.startIndex
        let dictKey = question.keys[index]
        
        if questionCathegory == cities {
            questionImage.image = UIImage(named: PrefixType.cityPrefix + dictKey)
        } else if questionCathegory == countries {
            questionImage.image = UIImage(named: PrefixType.countryPrefix + dictKey)
        } else {
            questionImage.image = UIImage(named: PrefixType.capitalPrefix + dictKey)
        }
    }
    
    func checkTheAnswer(answer: String) {
        let answerWithoutSpaces = answer.replacingOccurrences(of: " ", with: "")
        counter += 1

        if correctAnswer == answerWithoutSpaces {
            self.winTextLabel.text = winText
            self.winView.isHidden = false
            
            if let value = defaults.value(forKey: "coins") {
                var coins = value as! Int
                  coins += coinsForCorrectAnswer
                  defaults.set(coins, forKey: "coins")
                  defaults.set(true, forKey: correctAnswer)
            } else {
                 defaults.set(coinsForCorrectAnswer, forKey: "coins")
                defaults.set(true, forKey: correctAnswer)
            }
        } else if counter == correctAnswer.count - 2 {
            self.winTextLabel.text = wrongAnswerText
            self.winView.isHidden = false
        }
    }
    
    func customizingButton() {
        let radius = self.okButton.frame.height/2
        self.okButton.layer.cornerRadius = radius
        self.deleteButton.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
    }
    
}

extension String {
    
    var length: Int {
        return count
    }
    
    func indexInt(of char: Character) -> Int? {
        return firstIndex(of: char)?.utf16Offset(in: self)
    }
    
    func replace(_ with: String, at index: Int) -> String {
        var modifiedString = String()
        for (i, char) in self.enumerated() {
            modifiedString += String((i == index) ? with : String(char))
        }
        return modifiedString
    }
    
    func insertSeparator(_ separatorString: String, atEvery n: Int) -> String {
        guard 0 < n else { return self }
        return self.enumerated().map({String($0.element) + (($0.offset != self.count - 1 && $0.offset % n ==  n - 1) ? "\(separatorString)" : "")}).joined()
    }
    
    mutating func insertedSeparator(_ separatorString: String, atEvery n: Int) {
        self = insertSeparator(separatorString, atEvery: n)
    }
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }
    
    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    
}
