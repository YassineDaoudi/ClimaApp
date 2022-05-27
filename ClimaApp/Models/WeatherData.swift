//
//  WeatherData.swift
//  ClimaApp
//
//  Created by Yassine DAOUDI on 27/5/2022.
//

import Foundation

struct WeatherData: Decodable {
    
    struct Main: Decodable {
        let temp: Double
        let pressure: Int
        let humidity: Int
    }
    
    struct Weather: Decodable {
        let description: String
        let id: Int
    }
    
    struct Wind: Decodable {
        let speed: Double
    }
    
    let name: String
    let main: Main
    let weather: [Weather]
    let wind: Wind
}


