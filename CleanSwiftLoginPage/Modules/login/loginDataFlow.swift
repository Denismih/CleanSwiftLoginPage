//
//  login screen
//  Created by Denis Mikhaylovskiy on 05/11/2020.
//

enum login {
    // MARK: Use cases
    enum LoginData {
        struct Request {
            var credentialsModel : CredentialsModel
        }

        struct Response {
            var result: loginRequestResult
        }
        
        struct CredentialsResponse {
            var credentialsModel : CredentialsModel
        }

        struct ViewModel {
            var state: ViewControllerState
        }
    }

    enum loginRequestResult {
        case failure(loginError)
        case success
    }

    enum ViewControllerState {
        case loading
        case result(Bool)
        case initial
        case error(message: String)
    }

    enum loginError: Error {
        case someError(message: String)
    }
}
