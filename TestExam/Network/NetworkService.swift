//
//  NetworkService.swift
//  TestExam
//
//  Created by Sabbir on 1/6/26.
//

import Foundation
import RxSwift

protocol NetworkService {
    func request<T: Decodable>(url: URL) -> Single<T>
}
