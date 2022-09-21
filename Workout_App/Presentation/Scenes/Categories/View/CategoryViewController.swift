//
//  CategoryViewController.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 30.07.22.
//

import UIKit

protocol CategoryDisplayLogic: AnyObject {
    func displayCategories(viewModel: CategoryModel.GetCategories.ViewModel)
    func didFailDisplayCategory(withError message: FetchingError)
    func displayCategoryWorkouts(viewModel: CategoryModel.ShowCategoryWorkouts.ViewModel)
}

final class CategoryViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var categoriesTableView: UITableView!
    
    //MARK: - Clean Components
    var interactor: CategoryBusinessLogic?
    var router: (CategoryRoutingLogic & CategoryDataPassing)?
    
    //MARK: - Categories Data
    private var allCategories = [CategoryViewModel]()
    
    //MARK: - Activity Indicator Manager
    private lazy var activityIndicator = ActivityIndicatorManager.shared
    
    //MARK: - Object Lifecycle
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        CategoryConfigurator.configure(vc: self)
    }
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        activityIndicator.startAnimating()
    }
    
    //MARK: - Setup Methods
    private func setupView() {
        categoriesTableView.registerNib(class: CategoryCell.self)
        activityIndicator.setupActivityIndicator(self)
        makeDataRequest()
    }
    
    private func setupCategory(data: [CategoryViewModel]) {
        self.allCategories = data
        categoriesTableView.reloadData()
        activityIndicator.stopAnimating()
    }
    
    //MARK: - Request Methods
    private func makeDataRequest() {
        interactor?.getCategories(request: CategoryModel.GetCategories.Request())
    }
}


//MARK: - Display Logic protocol
extension CategoryViewController: CategoryDisplayLogic {    
    
    func displayCategories(viewModel: CategoryModel.GetCategories.ViewModel) {
        setupCategory(data: viewModel.displayedCategories)
    }
    
    func didFailDisplayCategory(withError message: FetchingError) {
        router?.routeToShowAlert(withTitle: message.rawValue, success: false)
    }
    
    func displayCategoryWorkouts(viewModel: CategoryModel.ShowCategoryWorkouts.ViewModel) {
        router?.routeToWorkouts()
    }
}

//MARK: - TableView Delegate
extension CategoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        130
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCategory = allCategories[indexPath.row]
        let request = CategoryModel.ShowCategoryWorkouts.Request(id: currentCategory.id, name: currentCategory.name)
        interactor?.showCategoryWorkouts(request: request)
    }
}

//MARK: - TableView DataSource
extension CategoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        allCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as CategoryCell
        let currentCategory = allCategories[indexPath.row]
        cell.configure(with: currentCategory)
        
        return cell
    }
}
