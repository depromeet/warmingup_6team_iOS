//
//  Networking.swift
//  WePet
//
//  Created by hb1love on 2019/10/15.
//  Copyright © 2019 depromeet. All rights reserved.
//

import Moya

typealias MapNetworking = Networking<MapAPI>
typealias WeatherNetworking = Networking<WeatherAPI>

final class Networking<Target: TargetType>: MoyaProvider<Target> {

    init(plugins: [PluginType] = []) {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Manager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 5

        let manager = Manager(configuration: configuration)
        manager.startRequestsImmediately = false
        super.init(manager: manager, plugins: plugins)
    }

    func requestWithLog(
        _ target: Target,
        completion: @escaping (Result<Response, WepetError>) -> Void
    ) {
        let requestString = "\(target.method) \(target.path)"
        let message = "REQUEST: \(requestString)"
        log.debug(message)
        self.request(target) { result in
            switch result {
            case .success(let response):
                let message = "SUCCESS: \(requestString) (\(response.statusCode))"
                log.debug(message)
                completion(.success(response))
            case .failure(let error):
                if let response = error.response {
                  if let jsonObject = try? response.mapJSON(failsOnEmptyData: false) {
                    let message = "FAILURE: \(requestString) (\(response.statusCode))\n\(jsonObject)"
                    log.warning(message)
                    completion(.failure(.parsingError))
                  } else if let rawString = String(data: response.data, encoding: .utf8) {
                    let message = "FAILURE: \(requestString) (\(response.statusCode))\n\(rawString)"
                    log.warning(message)
                    completion(.failure(.unknown))
                  } else {
                    let message = "FAILURE: \(requestString) (\(response.statusCode))"
                    log.warning(message)
                    completion(.failure(.unknown))
                  }
                } else {
                    let message = "FAILURE: \(requestString)\n\(error)"
                    log.warning(message)
                    completion(.failure(.unknown))
                }
            }
        }
    }

    func request<T: Codable>(
        _ target: Target,
        completion: @escaping (Result<T, WepetError>) -> Void
    ) {
        self.requestWithLog(target) { result in
            switch result {
            case .success(let response):
                do {
                    let responseData = try response.map(ResponseData<T>.self)
                    if let data = responseData.data {
                        completion(.success(data))
                    } else {
                        completion(.failure(.parsingError))
                    }
                } catch {
                    completion(.failure(.parsingError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
