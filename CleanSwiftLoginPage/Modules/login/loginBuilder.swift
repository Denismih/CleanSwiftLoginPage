//
//  login screen
//  Created by Denis Mikhaylovskiy on 05/11/2020.
//

import UIKit

class loginBuilder: ModuleBuilder {

    var initialState: login.ViewControllerState?

    func set(initialState: login.ViewControllerState) -> loginBuilder {
        self.initialState = initialState
        return self
    } 

    func build() -> UIViewController {
        let presenter = loginPresenter()
        let interactor = loginInteractor(presenter: presenter)
        let controller = loginViewController(interactor: interactor)

        presenter.viewController = controller
        return controller
    }
}
