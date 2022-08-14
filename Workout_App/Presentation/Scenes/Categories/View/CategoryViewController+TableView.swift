//
//  CategoryViewController+TableView.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 03.08.22.
//

import UIKit

extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        allCategories.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        130
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Ids.Cell.category) as? CategoryCell else { return UITableViewCell() }
        let currentCategory = allCategories[indexPath.row]
        cell.configure(with: currentCategory)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCategory = allCategories[indexPath.row]
        router?.routeToWorkouts(id: currentCategory.id, name: currentCategory.name)
    }

}
