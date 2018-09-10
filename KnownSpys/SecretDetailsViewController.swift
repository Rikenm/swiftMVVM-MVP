import UIKit








//protocol SecretDetailsDelegate: class {
//    func passwordCrackingFinished()
//}





class SecretDetailsViewController: UIViewController {

    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var passwordLabel: UILabel!
    
    fileprivate var presenter: SecretDetailsPresenter
    
//    weak var delegate: SecretDetailsDelegate?
    
    fileprivate weak var navigationCoordinator: NavigationCoordinator?
    
    init(with presenter: SecretDetailsPresenter,navigationCoordinator: NavigationCoordinator) {
        self.presenter = presenter
       self.navigationCoordinator = navigationCoordinator
        
        super.init(nibName: "SecretDetailsViewController", bundle: nil)
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.showPassword()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isMovingFromParentViewController {
            navigationCoordinator?.movingBack()
        }
    }
    
    
    func showPassword() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        passwordLabel.text = presenter.password
    }
    
    @IBAction func finishedButtonTapped(_ button: UIButton) {
//        navigationController?.popViewController(animated: true) //when cord
        
//        delegate?.passwordCrackingFinished() //ehrn cord
        
        
        navigationCoordinator?.next(arguments: [:])
        
    }
}
