//
//  CategoryViewController.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 30.07.22.
//

import UIKit

protocol CategoryDisplayLogic: AnyObject {
    func displayCategory(from viewModel: CategoryModel.GetCategories.ViewModel)
    func didFailDisplayCategory(withError message: FetchingError)
    func displayCategoryWorkouts(viewModel: CategoryModel.ShowCategoryWorkouts.ViewModel)
}

final class CategoryViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var categoriesTableView: UITableView!
    
    //MARK: - Properties
    
    //clean components
    var interactor: CategoryBusinessLogic?
    var router: CategoryRoutingLogic?
    //category data
    var allCategories = [CategoryViewModel]()
    
    //MARK: - Object Lifecycle
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        CategoryConfigurator.configure(vc: self)
    }
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ActivityIndicatorManager.shared.setupActivityIndicator(self)
        //registering cell
        categoriesTableView.registerNib(class: CategoryCell.self)
        makeRequest()
    }
    
    //MARK: - Methods
    
    private func makeRequest() {
        interactor?.getCategories(request: CategoryModel.GetCategories.Request())
    }
    
    private func setupCategory(data: [CategoryViewModel]) {
        self.allCategories = data
        categoriesTableView.reloadData()
        ActivityIndicatorManager.shared.stopAnimating()
    }
    
}

//MARK: - Display Logic protocol

extension CategoryViewController: CategoryDisplayLogic {    
    
    func displayCategory(from viewModel: CategoryModel.GetCategories.ViewModel) {
        setupCategory(data: viewModel.displayedCategories)
    }
    
    func didFailDisplayCategory(withError message: FetchingError) {
        //TODO: - FIX THIS with alerts
        print(message.rawValue)
    }
    
    func displayCategoryWorkouts(viewModel: CategoryModel.ShowCategoryWorkouts.ViewModel) {
        router?.routeToWorkouts()
    }
}

//MARK: - TableView Delegates

extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        allCategories.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        130
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as CategoryCell
        let currentCategory = allCategories[indexPath.row]
        cell.configure(with: currentCategory)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCategory = allCategories[indexPath.row]
        let request = CategoryModel.ShowCategoryWorkouts.Request(id: currentCategory.id, name: currentCategory.name)
        interactor?.showCategoryWorkouts(request: request)
    }
    
}
