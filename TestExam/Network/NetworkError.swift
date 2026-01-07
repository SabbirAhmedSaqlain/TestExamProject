//
//  NetworkError.swift
//  TestExam
//
//  Created by Sabbir on 1/6/26.
//
enum NetworkError: Error {
    case invalidURL
    case decodingError
    case serverError(String)
}

