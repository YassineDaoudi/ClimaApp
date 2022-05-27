//
//  CAError.swift
//  ClimaApp
//
//  Created by Yassine DAOUDI on 27/5/2022.
//

import Foundation

enum CAError: String, Error {
    case invalidUrl = "This url created an invalid request. Please try again."
    case unableToComplete = "Unable to complete your request. Please check your internet connection."
    case invalidResponse = "Invalid response from the server. Please try again."
    case invalidData = "The data received from the server was invalid. Please try again."
}
