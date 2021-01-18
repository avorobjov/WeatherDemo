import Entities
import Foundation

public typealias ForecastResult = Result<Forecast, ServiceError>

public protocol WeatherService {
    func loadForecastData(query: String, completion: @escaping (ForecastResult) -> Void)
    func readCachedForecast(data: Data) -> ForecastResult
}

public class WeatherServiceImpl {
    static let queryParameterName = "q"

    private let session: URLSession

    public init(session: URLSession) {
        self.session = session
    }
}

extension WeatherServiceImpl: WeatherService {
    public func loadForecastData(query: String, completion: @escaping (ForecastResult) -> Void) {
        guard var comps = URLComponents(string: "https://api.openweathermap.org/data/2.5/forecast?appid=1ef6cbf2f430380e2eb6b2509fdee1d4&units=metric") else {
            return completion(.failure(.loadError))
        }

        var queryItems = comps.queryItems ?? []
        queryItems.append(URLQueryItem(name: Self.queryParameterName, value: query))
        comps.queryItems = queryItems

        guard let url = comps.url else {
            return completion(.failure(.loadError))
        }

        let task = session.dataTask(with: url) { data, response, error in
            if let urlError = error as? URLError, urlError.code == .notConnectedToInternet {
                return completion(.failure(.noInternetConnection))
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                return completion(.failure(.loadError))
            }

            if httpResponse.statusCode == 404 {
                return completion(.failure(.notFound))
            }

            guard
                httpResponse.statusCode >= 200,
                httpResponse.statusCode < 300,
                let data = data,
                !data.isEmpty
            else {
                return completion(.failure(.loadError))
            }

            let result = self.parseForecast(data: data)
            completion(result)
        }

        task.resume()
    }

    public func readCachedForecast(data: Data) -> ForecastResult {
        return parseForecast(data: data)
    }
}

private extension WeatherServiceImpl {
    func parseForecast(data: Data) -> ForecastResult {
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(ForecastResponse.self, from: data)
            let model = response.toModel()
            return .success(model)
        }
        catch {
            print("WeatherServiceImpl: parse error \(error)")
            return .failure(.parseError)
        }
    }
}
