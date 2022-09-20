//
//  OnBoardingViewController.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 18.09.22.
//

import UIKit

protocol OnBoardingDisplayLogic: AnyObject {
    func displayOnBoardingScreens(viewModel: OnBoarding.getScreen.ViewModel)
    func displayMainTabBar(viewModel: OnBoarding.ShowMainTabBar.ViewModel)
}

final class OnBoardingViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var onBoardingCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var continueBtn: UIButton!
    
    //MARK: - Clean Components
    var interactor: OnBoardingBusinessLogic?
    var router: OnBoardingRoutingLogic?
    
    //MARK: - Screen Data
    private var onBoardingScreens = [OnBoardingModel]()
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    //MARK: - IBAction
    @IBAction func skipBtnTapped(_ sender: UIButton) {
        interactor?.showMainTabBar(request: OnBoarding.ShowMainTabBar.Request())
    }
    
    @IBAction func pageControlTapped(_ sender: UIPageControl) {
        showScreen(at: pageControl.currentPage)
    }
    
    @IBAction func continueBtnTapped(_ sender: UIButton) {
        pageControl.page += 1
        sender.currentTitle == ButtonTitle.getStarted ? interactor?.showMainTabBar(request: OnBoarding.ShowMainTabBar.Request()) : showScreen(at: pageControl.currentPage)
        setupContinueBtn()
    }
    
    //MARK: - Setup Methods
    private func setupView() {
        setupCollectionView()
        makeDataRequest()
        setupContinueBtn()
    }
    
    private func setupContinueBtn() {
        continueBtn.maskCurved(highly: true)
        continueBtn.layer.borderWidth = 2
        continueBtn.layer.borderColor = UIColor.ColorKey.skyBlue?.cgColor
        continueBtn.tintColor = pageControl.page == onBoardingScreens.count-1 ? .white : UIColor.ColorKey.skyBlue
        continueBtn.backgroundColor = pageControl.page == onBoardingScreens.count-1 ? UIColor.ColorKey.skyBlue : .white
        continueBtn.setTitle(pageControl.page == onBoardingScreens.count-1 ? ButtonTitle.getStarted : ButtonTitle.continueNext, for: .normal)
    }
    
    private func setupCollectionView() {
        onBoardingCollectionView.registerNib(class: OnBoardingCell.self)
        if let flowLayout = self.onBoardingCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
        }
    }
    
    private func setupOnboardingScreen(data: [OnBoardingModel]) {
        self.onBoardingScreens = data
        onBoardingCollectionView.reloadData()
    }
    
    //MARK: - Request Methods
    private func makeDataRequest() {
        interactor?.getOnBoardingScreens(request: OnBoarding.getScreen.Request())
    }
    
    private func showScreen(at index: Int) {
        pageControl.page = index
        let indexPath = IndexPath(item: index, section: 0)
        onBoardingCollectionView.scrollToItem(at: indexPath, at: [.centeredHorizontally, .centeredVertically], animated: true)
    }
}

//MARK: - Display Logic protocol
extension OnBoardingViewController: OnBoardingDisplayLogic {
    
    func displayOnBoardingScreens(viewModel: OnBoarding.getScreen.ViewModel) {
        setupOnboardingScreen(data: viewModel.screens)
    }
    
    func displayMainTabBar(viewModel: OnBoarding.ShowMainTabBar.ViewModel) {
        router?.routeToMainTabBar()
    }
}

//MARK: - CollectionView Delegate
extension OnBoardingViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor(scrollView.contentOffset.x - pageWidth/2) / pageWidth + 1)
        self.pageControl.page = page
        setupContinueBtn()
    }
}

//MARK: - CollectionView DataSource
extension OnBoardingViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        onBoardingScreens.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as OnBoardingCell
        let currentScreen = onBoardingScreens[indexPath.row]
        cell.configure(with: currentScreen)
        
        return cell
    }
}

//MARK: - CollectionView FlowLayout
extension OnBoardingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: onBoardingCollectionView.frame.width-10, height: onBoardingCollectionView.frame.height)
    }
}
