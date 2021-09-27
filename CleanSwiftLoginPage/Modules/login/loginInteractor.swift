//
//  login screen
//  Created by Denis Mikhaylovskiy on 05/11/2020.
//

protocol loginBusinessLogic {
    func loadTemplate(request: login.LoginData.Request)
    func loadSavedCredentials()
}

/// Класс для описания бизнес-логики модуля login
class loginInteractor: loginBusinessLogic {
    let presenter: loginPresentationLogic
    let provider: loginProviderProtocol

    init(presenter: loginPresentationLogic, provider: loginProviderProtocol = loginProvider()) {
        self.presenter = presenter
        self.provider = provider
    }
    
    func loadSavedCredentials() {
        if let model = provider.loadCredentials() {
            presenter.fillCredentials(response: login.LoginData.CredentialsResponse(credentialsModel: model))
        }
    }
    
    func loadTemplate(request: login.LoginData.Request) {
        
        if let id = request.credentialsModel.id, let pin = request.credentialsModel.pin, !id.isEmpty, !pin.isEmpty {
            provider.loadAppConfig(id: id, pin: pin) { result in
                switch result {
                case .success(let model):
                    Constants.shared.setupConstants(with: model) { (res) in
                        switch res {
                        case .success( _):
                            self.presenter.presentSomething(response: login.LoginData.Response(result: .success))
                        case .failure(let error):
                            print("!!!ERROR!!! - \(#file) - \(#function) ERROR: \(error.localizedDescription)")
                            self.presenter.presentSomething(response: login.LoginData.Response(result: .failure(.someError(message: "Unable to download images for app"))))
                        }
                    }
                case .failure(let error):
                    print("!!!ERROR!!! - \(#file) - \(#function) ERROR: \(error.localizedDescription)")
                    var errorDesc = ""
                    switch error {
                    case .connectionFailure :
                        errorDesc = "connection Failure"
                    case .serializationFailure:
                        errorDesc = "serialization Failure"
                    case .forwarded(let err):
                        errorDesc = String(describing: err)
                    case .unknown:
                        errorDesc = "unknown error"
                    case .apiError(let err):
                        errorDesc = err
                    }
                    self.presenter.presentSomething(response: login.LoginData.Response(result: .failure(.someError(message: "Unable to download app config. \(errorDesc)"))))
                }
            }
        } else {
            self.presenter.presentSomething(response: login.LoginData.Response(result: .failure(.someError(message: "Enter ID and PIN"))))
        }
        
    }
}
