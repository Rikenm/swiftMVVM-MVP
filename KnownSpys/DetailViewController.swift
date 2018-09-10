import UIKit






class DetailViewController: UIViewController {
    
    
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var ageLabel: UILabel!
    @IBOutlet var genderLabel: UILabel!
    
    fileprivate var presenter: DetailPresenter!
//    fileprivate var secretDetailsViewControllerMaker: DependencyRegistry.SecretDetailsViewControllerMaker!
    
     fileprivate weak var navigationCoordinator: NavigationCoordinator?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isMovingFromParentViewController {
            navigationCoordinator?.movingBack()
        }
    }

//    func configure(with presenter: DetailPresenter,secretDetailsViewControllerMaker: @escaping DependencyRegistry.SecretDetailsViewControllerMaker) {
     func configure(with presenter: DetailPresenter,navigationCoordinator: NavigationCoordinator ) {
        self.presenter = presenter
        
//        self.secretDetailsViewControllerMaker = secretDetailsViewControllerMaker
        
        self.navigationCoordinator = navigationCoordinator
    }
    
    func setupView() {
        profileImage.image = UIImage(named: presenter.imageName)
        nameLabel.text = presenter.name
        ageLabel.text  = presenter.age //String(spy.age)
        genderLabel.text = presenter.gender
    }
}

//MARK: - Touch Events
extension DetailViewController {
    @IBAction func briefcaseTapped(_ button: UIButton) {
        
//        let secretDetailsPresenter = SecretDetailsPresenter(with: presenter.spy)
        
//        let vc = secretDetailsViewControllerMaker(presenter.spy,self) // when making coord
//        let vc = SecretDetailsViewController(with: secretDetailsPresenter, and: self as SecretDetailsDelegate)
        
//        navigationController?.pushViewController(vc, animated: true) // when making coord
        
        
        
        let args  = ["spy":presenter.spy!]
        
        navigationCoordinator?.next(arguments: args)
    }
}

//MARK: - SecretDetailsDelegate
//extension DetailViewController {
//    func passwordCrackingFinished() {
//        //close middle layer too
//        navigationController?.popViewController(animated: true)
//    }
//}



