import UIKit

extension URLSession {
    func request(_ request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) {
        let task = self.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Сетевая ошибка: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ Ошибка: некорректный HTTP-ответ")
                completion(.failure(NSError(domain: "OAuth2Service", code: 1, userInfo: nil)))
                return
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                print("❌ Ошибка сервера: статус-код \(httpResponse.statusCode)")
                completion(.failure(NSError(domain: "OAuth2Service", code: httpResponse.statusCode, userInfo: nil)))
                return
            }

            guard let data = data else {
                print("❌ Ошибка: отсутствует тело ответа")
                completion(.failure(NSError(domain: "OAuth2Service", code: 2, userInfo: nil)))
                return
            }

            completion(.success(data))
        }
        task.resume()
    }
}
