//
//  login screen
//  Created by Denis Mikhaylovskiy on 05/11/2020.
//

import UIKit

protocol loginPresentationLogic {
    func presentSomething(response: login.LoginData.Response)
    func fillCredentials(response: login.LoginData.CredentialsResponse)
}

/// Отвечает за отображение данных модуля login
class loginPresenter: loginPresentationLogic {
    weak var viewController: loginDisplayLogic?

    // MARK: Do something
    func presentSomething(response: login.LoginData.Response) {
        var viewModel: login.LoginData.ViewModel
        
        switch response.result {
        case .failure(let error):
            switch error {
            case .someError(message: let mes):
                viewModel = login.LoginData.ViewModel(state: .error(message: mes))
            default:
                viewModel = login.LoginData.ViewModel(state: .error(message: "Unknoun error"))
            }
            
        case .success:
            viewModel = login.LoginData.ViewModel(state: .result(true))
        }
        viewController?.displaySomething(viewModel: viewModel)
    }
    func fillCredentials(response: login.LoginData.CredentialsResponse){
        viewController?.fillCredentials(model: response.credentialsModel)
    }
}
