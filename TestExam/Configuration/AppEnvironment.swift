
//
//  Untitled.swift
//  TestExam
//
//  Created by Sabbir on 1/6/26.
//
enum AppEnvironment {
    case dev
    case qa
    case prod

    static var current: AppEnvironment {
        #if DEBUG
        return .dev
        #else
        return .prod
        #endif
    }

    var baseURL: String {
        "https://newsapi.org/v2"
    }

    var apiKey: String {
        "f7022c7355454bdc87c70ae3e07a64b4"
    }
}

