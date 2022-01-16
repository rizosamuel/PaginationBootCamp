//
//  ViewController.swift
//  PaginationBootCamp
//
//  Created by Rijo Samuel on 16/01/22.
//

import UIKit

class ViewController: UIViewController {
	
	private let apiCaller: APICaller = APICaller()
	
	private var data: [String] = []
	
	private let tableView: UITableView = {
		
		let table = UITableView(frame: .zero, style: .grouped)
		table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
		return table
	}()

	override func viewDidLoad() {
		
		super.viewDidLoad()
		
		navigationController?.navigationBar.prefersLargeTitles = true
		title = "Home"
		view.addSubview(tableView)
		
		tableView.dataSource = self
		tableView.delegate = self
	}
	
	override func viewDidLayoutSubviews() {
		
		super.viewDidLayoutSubviews()
		tableView.frame = view.bounds
		
		apiCaller.fetchData(pagination: false) { result in
			
			switch result {
					
				case .success(let data):
					self.data.append(contentsOf: data)
					DispatchQueue.main.async {
						self.tableView.reloadData()
					}
					
				case .failure(let error):
					print(error.localizedDescription)
			}
		}
	}
	
	private func createSpinnerFooter() -> UIView {
		
		let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
		let spinner = UIActivityIndicatorView()
		
		spinner.center = footerView.center
		spinner.startAnimating()
		footerView.addSubview(spinner)
		
		return footerView
	}
}

// MARK: - Table View Delegate Methods
extension ViewController: UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return data.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
		cell.textLabel?.text = data[indexPath.row]
		return cell
	}
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		
		let position = scrollView.contentOffset.y
		let offset = tableView.contentSize.height - 100 - scrollView.frame.size.height
		
		if position > offset {
			
			guard !apiCaller.isPaginating else { return }
			
			self.tableView.tableFooterView = self.createSpinnerFooter()
			
			apiCaller.fetchData(pagination: true) { result in
				
				DispatchQueue.main.async {
					self.tableView.tableFooterView = nil
				}
				
				switch result {
						
					case .success(let data):
						self.data.append(contentsOf: data)
						DispatchQueue.main.async {
							self.tableView.reloadData()
						}
						
					case .failure(let error):
						print(error.localizedDescription)
				}
			}
		}
	}
}
