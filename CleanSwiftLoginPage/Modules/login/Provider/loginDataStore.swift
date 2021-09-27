//
//  Created by Denis Mikhaylovskiy on 05/11/2020.
//
import Foundation
/// Класс для хранения данных модуля login
class loginDataStore {
    var model: CredentialsModel?
    func loadCredentials () -> CredentialsModel? {
        if let id = UserDefaults.standard.string(forKey: "id"), let pin = UserDefaults.standard.string(forKey: "pin") {
            let model = CredentialsModel(id: id, pin: pin)
            self.model = model
            return model
        }
        return  nil
    }
    func saveCredentials(model: CredentialsModel) {
        self.model = model
        UserDefaults.standard.setValue(model.id, forKey: "id")
        UserDefaults.standard.setValue(model.pin, forKey: "pin")
    }
}
