import UIKit
import Swinject
import SwinjectStoryboard



protocol DependencyRegistry {
    var container: Container { get }
    
    var navigationCoordinator: NavigationCoordinator! {get}
    
    typealias rootNavigationCoordinatorMaker = (UIViewController) -> NavigationCoordinator
    
    func makeRootNavigationCoordinator(rootViewController:UIViewController) -> NavigationCoordinator
    
    //MARK: - Maker Methods
    typealias SpyCellMaker = (UITableView, IndexPath, SpyDTO) -> SpyCell
    func makeSpyCell(for tableView: UITableView, at indexPath: IndexPath, spy: SpyDTO) -> SpyCell
    
    typealias DetailViewControllerMaker = (SpyDTO) -> DetailViewController
    func makeDetailViewController(with spy: SpyDTO) -> DetailViewController
    typealias SecretDetailsViewControllerMaker = (SpyDTO)  -> SecretDetailsViewController   //here
    func makeSecretDetailsViewController(with spy: SpyDTO) -> SecretDetailsViewController
}

class DependencyRegistryImpl: DependencyRegistry{
    
    
    var navigationCoordinator: NavigationCoordinator!
    

    var container: Container
    
    init(container: Container) {
        
        Container.loggingFunction = nil
        
        self.container = container
        
        registerDependencies()
        registerPresenters()
        registerViewControllers()
    }
    
    func registerDependencies() {
        
        container.register(NavigationCoordinator.self){
            
            (r,rootViewController: UIViewController) in
            return RootNavigationCoordinatorImpl(with: rootViewController, registry: self)
        }.inObjectScope(.container)
        
        container.register(NetworkLayer.self    ) { _ in NetworkLayerImpl()  }.inObjectScope(.container)
        container.register(DataLayer.self       ) { _ in DataLayerImpl()     }.inObjectScope(.container)
        container.register(SpyTranslator.self   ) { _ in SpyTranslatorImpl() }.inObjectScope(.container)
        
        container.register(TranslationLayer.self) { r in
            TranslationLayerImpl(spyTranslator: r.resolve(SpyTranslator.self)!)
        }.inObjectScope(.container)

        container.register(ModelLayer.self){ r in
            ModelLayerImpl(
                 networkLayer:     r.resolve(NetworkLayer.self)!,
                dataLayer:     r.resolve(DataLayer.self)!,
                             translationLayer: r.resolve(TranslationLayer.self)!
                             
                             )
        }.inObjectScope(.container)
    }
    
    func registerPresenters() {
        container.register(SpyListPresenter.self) { r in SpyListPresenterImpl(modelManager: r.resolve(ModelLayer.self)!) }
        container.register( DetailPresenter.self) { (r, spy: SpyDTO)  in DetailPresenterImpl(with: spy) }
        container.register(SpyCellPresenter.self) { (r, spy: SpyDTO) in SpyCellPresenterImpl(with: spy) }
        container.register(SecretDetailsPresenter.self) { (r, spy: SpyDTO) in SecretDetailsPresenterImpl(with: spy) }
    }
    
    func registerViewControllers() {
        container.register(SecretDetailsViewController.self) { (r, spy: SpyDTO) in   //here
            let presenter = r.resolve(SecretDetailsPresenter.self, argument: spy)!
            return SecretDetailsViewController(with: presenter,  navigationCoordinator: self.navigationCoordinator)
        }
        container.register(DetailViewController.self) { (r, spy:SpyDTO) in
            let presenter = r.resolve(DetailPresenter.self, argument: spy)!

            //NOTE: We don't have access to the constructor for this VC so we are using method injection
            let vc = UIStoryboard.main.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
//                vc.configure(with: presenter, secretDetailsViewControllerMaker: self.makeSecretDetailsViewController)
            vc.configure(with: presenter, navigationCoordinator: self.navigationCoordinator)
            return vc
        }
    }

    //MARK: - Maker Methods
   
    func makeSpyCell(for tableView: UITableView, at indexPath: IndexPath, spy: SpyDTO) -> SpyCell {
        let presenter = container.resolve(SpyCellPresenter.self, argument: spy)!
        let cell = SpyCell.dequeue(from: tableView, for: indexPath,  with: presenter)
        return cell
    }
    
   
    func makeDetailViewController(with spy: SpyDTO) -> DetailViewController {
        return container.resolve(DetailViewController.self, argument: spy)!
    }

   
    func makeSecretDetailsViewController(with spy: SpyDTO) -> SecretDetailsViewController {  //here
        return container.resolve(SecretDetailsViewController.self, argument: spy)!
    }
    
    
    
    func makeRootNavigationCoordinator(rootViewController:UIViewController) -> NavigationCoordinator {
        navigationCoordinator = container.resolve(NavigationCoordinator.self,argument: rootViewController)
        
        return navigationCoordinator
    }
}
