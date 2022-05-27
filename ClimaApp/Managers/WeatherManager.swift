//
//  WeatherManager.swift
//  ClimaApp
//
//  Created by Yassine DAOUDI on 26/5/2022.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate: AnyObject {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: CAError)
}

class WeatherManager {
    static let shared = WeatherManager()
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=34519cd25ec8108974d2d0d79ff51158&units=metric"
    
    weak var delegate: WeatherManagerDelegate?
    
    private init() { }
        
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        Task {
            do {
                try await performRequest(with: urlString)
            } catch {
                if let error = error as? CAError {
                    delegate?.didFailWithError(error: error)
                }
            }
        }
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        Task {
            do {
                try await performRequest(with: urlString)
            } catch {
                if let error = error as? CAError {
                    delegate?.didFailWithError(error: error)
                }
            }
        }
    }
    
    func performRequest(with urlString: String) async throws {
        
        guard let url = URL(string: urlString) else { throw CAError.invalidUrl }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw CAError.invalidResponse }
        
        if let weather = self.parseJSON(data) {
            self.delegate?.didUpdateWeather(self, weather: weather)
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            let humidity = decodedData.main.humidity
            let pressure = decodedData.main.pressure
            let speed = decodedData.wind.speed

            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp, humidity: humidity, pressure: pressure, windSpeed: speed)
            
            return weather
            
        } catch {
            delegate?.didFailWithError(error: CAError.invalidData)
            return nil
        }
    }
}
