//
//  APICaller.swift
//  PaginationBootCamp
//
//  Created by Rijo Samuel on 16/01/22.
//

import Foundation

final class APICaller {
	
	var isPaginating: Bool = false
	
	func fetchData(pagination: Bool = false, completion: @escaping (Result<[String], Error>) -> Void) {
		
		isPaginating = pagination ? true : false
		
		DispatchQueue.global().asyncAfter(deadline: .now() + (pagination ? 3 : 2)) {
			
			let originalData = [
				"Apple",
				"Google",
				"Facebook",
				"Apple",
				"Google",
				"Facebook",
				"Apple",
				"Google",
				"Facebook",
				"Apple",
				"Google",
				"Facebook",
			]
			
			let newData = [
				"Banana",
				"Oranges",
				"Grapes",
				"Food"
			]
			
			completion(.success(pagination ? newData : originalData))
			self.isPaginating = false
		}
	}
}
