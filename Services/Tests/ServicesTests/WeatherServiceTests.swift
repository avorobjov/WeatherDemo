import XCTest
@testable import Services

final class WeatherServiceTests: XCTestCase {
    class MockDataTask: URLSessionDataTask {
        override func resume() {
        }
    }

    class MockSession: URLSession {
        var data: Data?
        var response: URLResponse?
        var error: Error?

        var url: URL?

        override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            self.url = url

            completionHandler(self.data, self.response, self.error)

            return MockDataTask()
        }
    }

    var session: MockSession!
    var service: WeatherService!

    override func setUpWithError() throws {
        session = MockSession()
        service = WeatherServiceImpl(session: session)
    }

    override func tearDownWithError() throws {
        service = nil
        session = nil
    }

    func testPassesQuery() {
        let query = "test query"

        let expectation = XCTestExpectation()
        service.loadForecastData(query: query) { _ in
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.5)
        XCTAssertNotNil(session.url)
        let comps = URLComponents(url: session.url!, resolvingAgainstBaseURL: false)!
        let param = comps.queryItems?.first { $0.name == WeatherServiceImpl.queryParameterName }
        XCTAssertNotNil(param)
        XCTAssertEqual(param!.value, query)
    }

    func testNoInternetConnection() {
        session.error = URLError(.notConnectedToInternet)
        service.loadForecastData(query: "asd") { response in
            switch response {
            case .failure(let error):
                XCTAssertEqual(error, .noInternetConnection)

            default:
                XCTAssert(false, "should return error")
            }
        }
    }

    func testErrorCodes() {
        session.response = testResponse(code: 199)
        service.loadForecastData(query: "asd") { response in
            switch response {
            case .failure(let error):
                XCTAssertEqual(error, .loadError)

            default:
                XCTAssert(false, "should return error")
            }
        }

        session.response = testResponse(code: 300)
        service.loadForecastData(query: "asd") { response in
            switch response {
            case .failure(let error):
                XCTAssertEqual(error, .loadError)

            default:
                XCTAssert(false, "should return error")
            }
        }
    }

    func testNotFound() {
        session.response = testResponse(code: 404)
        service.loadForecastData(query: "asd") { response in
            switch response {
            case .failure(let error):
                XCTAssertEqual(error, .notFound)

            default:
                XCTAssert(false, "should return error")
            }
        }
    }

    func testParseError() {
        session.response = testResponse(code: 200)
        session.data = "bad data".data(using: .utf8)
        service.loadForecastData(query: "asd") { response in
            switch response {
            case .failure(let error):
                XCTAssertEqual(error, .parseError)

            default:
                XCTAssert(false, "should return error")
            }
        }
    }

    func testParseData() {
        session.response = testResponse(code: 200)
        session.data = readTestJson(name: "test")
        service.loadForecastData(query: "asd") { response in
            switch response {
            case .failure:
                XCTAssert(false, "should return value")

            case .success(let forecast):
                XCTAssertEqual(forecast.city, "Minsk, BY")
                XCTAssertEqual(forecast.timeZone.secondsFromGMT(), 10800)
                XCTAssertEqual(forecast.items.count, 40)
            }
        }
    }

    func testCachedData() {
        let data = readTestJson(name: "test")
        let result = service.readCachedForecast(data: data)
        switch result {
        case .failure:
            XCTAssert(false, "should return value")

        case .success(let forecast):
            XCTAssertEqual(forecast.city, "Minsk, BY")
            XCTAssertEqual(forecast.timeZone.secondsFromGMT(), 10800)
            XCTAssertEqual(forecast.items.count, 40)
        }
    }

    func testResponse(code: Int) -> URLResponse {
        return HTTPURLResponse(url: URL(string: "https://www.google.com")!, statusCode: code, httpVersion: nil, headerFields: nil)!
    }

    func readTestJson(name: String) -> Data {
        let jsonURL = Bundle.module.url(forResource: name, withExtension: "json")!
        return try! Data(contentsOf: jsonURL)
    }
}
