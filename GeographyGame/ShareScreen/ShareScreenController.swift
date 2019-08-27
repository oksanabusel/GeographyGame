
import UIKit

class ShareScreenController: UIViewController {

    @IBOutlet weak var shareButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizingButton()
    }
    
    @IBAction func tapBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func customizingButton() {
        let radius = self.shareButton.frame.height/2
        self.shareButton.layer.cornerRadius = radius
    }
    
}
