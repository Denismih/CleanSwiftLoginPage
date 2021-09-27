//
//  Created by Denis Mikhaylovskiy on 05/11/2020.
//
import Foundation

protocol loginServiceProtocol {
    func fetchItems(id: String, pin: String, completion: @escaping (Result<loginModel, LoginServiceError>) -> Void)
}

enum LoginServiceError : Error {
    case connectionFailure
    case serializationFailure
    case forwarded(Error)
    case unknown
    case apiError(String)
}

/// Получает данные для модуля login
class loginService: loginServiceProtocol {

    func fetchItems(id: String, pin: String, completion: @escaping (Result<loginModel, LoginServiceError>) -> Void) {
        let apiURLString = "http://appsalut.io/start.json?id=\(id)&pin=\(pin)"
        guard let url = URL(string: apiURLString) else { completion(.failure(.connectionFailure)); return }
        let session = URLSession.shared.dataTask(with: url) { (data, responce, error) in
            if let error = error  {
                completion(.failure(.forwarded(error)))
                return
            }
            if let data = data{
                do {
                    //print(String(data: data, encoding: .utf8))
                    let model = try JSONDecoder().decode(loginModel.self, from: data)
                    completion(.success(model))
                    
                } catch (let error){
                    print("!!!ERROR!!! - \(#file) - \(#function) ERROR: \(error)")
                    do {
                        let jsObj = try JSONSerialization.jsonObject(with: data, options: .init(rawValue: 0))
                        if let jsonObjDict = jsObj as? Dictionary<String, Any> {
                            if let err = jsonObjDict["error"] as? String{
                                completion(.failure(.apiError(err)))
                            } else {
                                completion(.failure(.forwarded(error)))
                            }
                        } else {
                            completion(.failure(.forwarded(error)))
                        }
                    } catch {
                        print("!!!ERROR!!! - \(#file) - \(#function) ERROR: \(error.localizedDescription)")
                        completion(.failure(.forwarded(error)))
                    }
//                    print("!!!ERROR!!! - \(#file) - \(#function) ERROR: \(error.localizedDescription)")
//                    completion(.failure(.forwarded(error)))
                }
            }
            
        }
        session.resume()
    }
}
