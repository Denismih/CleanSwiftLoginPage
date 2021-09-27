//
//  Created by Denis Mikhaylovskiy on 05/11/2020.
//
import Foundation
protocol loginProviderProtocol {
    func loadAppConfig(id: String, pin: String, completion: @escaping (Result<loginModel, LoginServiceError>) -> Void)
    func loadCredentials() -> CredentialsModel?
}

enum loginProviderError: Error {
    case getItemsFailed(underlyingError: Error)
}

/// Отвечает за получение данных модуля login
struct loginProvider: loginProviderProtocol {
    let dataStore: loginDataStore
    let service: loginServiceProtocol

    init(dataStore: loginDataStore = loginDataStore(), service: loginServiceProtocol = loginService()) {
        self.dataStore = dataStore
        self.service = service
    }

    func loadCredentials() -> CredentialsModel? {
        let model = dataStore.model ?? dataStore.loadCredentials()
        return model
    }
    
    func loadAppConfig(id: String, pin: String, completion: @escaping (Result<loginModel, LoginServiceError>) -> Void) {
        service.fetchItems(id: id, pin: pin) { result in
            dataStore.saveCredentials(model: CredentialsModel(id: id, pin: pin))
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
