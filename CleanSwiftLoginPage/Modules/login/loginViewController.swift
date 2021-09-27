//
//  login screen
//  Created by Denis Mikhaylovskiy on 05/11/2020.
//

import UIKit
import MBProgressHUD

protocol loginDisplayLogic: class {
    func displaySomething(viewModel: login.LoginData.ViewModel)
    func fillCredentials(model: CredentialsModel)
}

class loginViewController: UIViewController {
 
    
    var interactor: loginBusinessLogic?
    var state: login.ViewControllerState?
    
    lazy var customView = self.view as? loginView
    
    init(interactor: loginBusinessLogic, initialState: login.ViewControllerState = .initial) {
        self.interactor = interactor
        self.state = initialState
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

     //MARK: View lifecycle
    override func loadView() {
        let view = loginView(frame: UIScreen.main.bounds, delegate: self, refreshDelegate: self)
        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        display(newState: .initial)
    }
}

extension loginViewController: loginDisplayLogic {
    func fillCredentials(model: CredentialsModel) {
        customView?.fillCredentials(model: model)
    }
    
    func displaySomething(viewModel: login.LoginData.ViewModel) {
        display(newState: viewModel.state)
    }

    func display(newState: login.ViewControllerState) {
        state = newState
        switch state {
        case .loading:
            customView?.showLogin()
        case let .error(message):
            customView?.showError(message: message)
        case .result(_):
            customView?.hideHud()
            startProject()
        case .initial:
            interactor?.loadSavedCredentials()
        case .none:
            break
        }
    }
    
    func startProject() {
        let vc = TabBarController()
        self.view.window?.rootViewController = vc
        self.view.window?.makeKeyAndVisible()
    }
}

extension loginViewController: loginViewListener {
    func loginBtnTapped(id: String?, pin: String?) {
        let request = login.LoginData.Request(credentialsModel: CredentialsModel(id: id, pin: pin))
        interactor?.loadTemplate(request: request)
    }
}

extension loginViewController: LoginErrorViewDelegate {
    func reloadButtonWasTapped() {
        display(newState: .loading)
    }
}
