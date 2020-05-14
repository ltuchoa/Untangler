
import UIKit

class StartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
    }
    
    private func makeUI() {
        
        // MARK: - BackgroundView Configuration
        let backgroundView: UIImageView = UIImageView(image: UIImage(named: "background"))
        backgroundView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        self.view.addSubview(backgroundView)
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        backgroundView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        backgroundView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        
        // MARK: - GameButton Configuration
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "startButton"), for: .normal)
        button.frame = CGRect(x: 100, y: 406, width: 221, height: 61)
        
        self.view.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        button.topAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 20).isActive = true
        
        button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        
        // MARK: - GameLabel Configuration
        
        var gameLabel: UILabel = UILabel()
        gameLabel.text = "Untangler"
        gameLabel.textColor = .white
        gameLabel.font = gameLabel.font.withSize(60)
        gameLabel.font = UIFont(name: "Avenir-Black", size: gameLabel.font.pointSize)
        
        self.view.addSubview(gameLabel)
        
        gameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        gameLabel.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -100).isActive = true
        gameLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
    }
    
    
    @objc func buttonClicked(sender : UIButton){
        let vc = ConnectionViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
