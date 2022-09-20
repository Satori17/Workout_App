//
//  AlertViewController.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 07.09.22.
//

import UIKit

protocol AlertDisplayLogic: AnyObject {
    func displayIntensityData(viewModel: AlertModel.GetWorkoutIntensity.ViewModel)
    func displayAlert(viewModel: AlertModel.ShowAlert.ViewModel)
}

final class AlertViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var saveView: UIView!
    @IBOutlet weak var saveViewTitle: UILabel!
    @IBOutlet weak var setsAndRepsPickerView: UIPickerView!
    @IBOutlet weak var weekDayPickerView: UIPickerView!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var triggerView: UIView!
    @IBOutlet weak var homeIcon: UIImageView!
    @IBOutlet weak var fakeTabBar: UITabBar!
    
    //MARK: - Clean Components
    var interactor: AlertBusinessLogic?
    var router: (AlertRoutingLogic & AlertDataPassing)?
    
    //MARK: - Gradient Mask
    private let gradientMaskLayer = CAGradientLayer()
    
    //MARK: - Save Alert Data
    private var sets = [String]()
    private var reps = [String]()
    private var weekDays = [String]()
    private var selectedData: (sets: Int, reps: Int, weekDay: String)?
    
    //MARK: - Animation Manager
    private let animationManager = AnimationManager()
    
    //MARK: - Custom Alert Components
    private let alertView = UIView()
    private let alertLabel = UILabel()
    private let alertButton = UIButton()
    private let timer = Timer()
    
    //MARK: - Object Lifecycle
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
    }
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    //MARK: - IBActions
    @IBAction func saveBtnTapped(_ sender: UIButton) {
        guard let sets = selectedData?.sets,
              let reps = selectedData?.reps,
              let weekDay = selectedData?.weekDay,
              reps >= 5 else {
            repRangeAlert()
            animationManager.shakeAnimation(ofView: saveView)
            return
        }
        let request = AlertModel.SaveWorkout.Request(
            sets: sets,
            reps: reps,
            weekDay: WeekDayModel(name: weekDay)
        )
        interactor?.saveWorkout(request: request)
        animateSaving()
    }
    
    @IBAction func cancelBtnTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    //MARK: - Setup Methods
    private func setupView() {
        //adding imageView to tabBar for transparent background
        fakeTabBar.backgroundImage = UIImage()
        makeAlertRequest()
    }
    
    private func setupSaveView() {
        saveView.withAppDesign(layer: gradientMaskLayer, curvedCorners: true)
        saveBtn.maskCurved(highly: false)
        cancelBtn.maskCurved(highly: false)
    }
    
    private func setupAlertView(withTitle text: String, success: Bool) {
        saveView.removeFromSuperview()
        getAlertView(success: success)
        getAlertTitle(withText: text, success: success)
        getAlertButton(success: success)
    }
    
    private func setupIntensity(data: (sets: [String], reps: [String], weekDays: [String])) {
        self.sets = data.sets
        self.reps = data.reps
        self.weekDays = data.weekDays
    }
    
    //MARK: - Request Methods
    private func makeAlertRequest() {
        interactor?.showAlert(request: AlertModel.ShowAlert.Request())
    }
    
    //MARK: - Helper Methods
    private func repRangeAlert(repCount: Int=0) {
        if repCount >= 5 {
            saveViewTitle.text = SaveTitle.initialText
            saveViewTitle.textColor = SaveTitle.initialColor
        } else {
            saveViewTitle.text = SaveTitle.alertText
            saveViewTitle.textColor = SaveTitle.alertColor
        }
    }
    
    private func animateSaving() {
        self.animationManager.movingAnimation(fromView: self.saveView, toView: self.triggerView, isRotated: true) { [weak self] in
            self?.saveView.removeFromSuperview()
            self?.view.backgroundColor = .clear
            self?.homeIcon.isHidden = false
            if let icon = self?.homeIcon {
                self?.animationManager.zoomingAnimation(ofView: icon, withShake: true) { [weak self] in
                    self?.dismiss(animated: true)
                }
            }
        }
    }
}

//MARK: - Display Logic protocol
extension AlertViewController: AlertDisplayLogic {
    
    func displayIntensityData(viewModel: AlertModel.GetWorkoutIntensity.ViewModel) {
        setupIntensity(data: (viewModel.sets, viewModel.reps, viewModel.weekDays))
        setupSaveView()
    }
    
    func displayAlert(viewModel: AlertModel.ShowAlert.ViewModel) {
        setupAlertView(withTitle: viewModel.alertText, success: viewModel.success)
    }
}

//MARK: - PickerView Delegate
extension AlertViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case setsAndRepsPickerView:
            switch component {
            case 0:
                return sets[row]
            case 1:
                return reps[row]
            default:
                return nil
            }
        case weekDayPickerView:
            return weekDays[row]
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let currentSet = setsAndRepsPickerView.selectedRow(inComponent: 0)
        let currentRep = setsAndRepsPickerView.selectedRow(inComponent: 1)
        let currentWeekDay = weekDayPickerView.selectedRow(inComponent: 0)
        selectedData = (sets: Int(sets[currentSet]) ?? 0, reps: Int(reps[currentRep]) ?? 0, weekDay: weekDays[currentWeekDay])
        if let repRange = selectedData?.reps {
            repRangeAlert(repCount: repRange)
        }
    }
}

//MARK: - PickerView DataSource
extension AlertViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch pickerView {
        case setsAndRepsPickerView:
            return 2
        case weekDayPickerView:
            return 1
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case setsAndRepsPickerView:
            switch component {
            case 0:
                return sets.count
            case 1:
                return reps.count
            default:
                return 0
            }
        case weekDayPickerView:
            return weekDays.count
        default:
            return 0
        }
    }
}

//MARK: - Creating custom components programatically
extension AlertViewController {
    
    private func getAlertView(success: Bool) {
        alertView.frame = CGRect(x: self.view.frame.midX, y: self.view.frame.midY, width: self.view.frame.width-40, height: success ? self.view.frame.height/6 : self.view.frame.height/4)
        alertView.center = self.view.center
        alertView.clipsToBounds = true
        alertView.backgroundColor = .white
        alertView.withAppDesign(layer: gradientMaskLayer, curvedCorners: true)
        self.view.addSubview(alertView)
    }
    
    private func getAlertTitle(withText text: String, success: Bool) {
        alertLabel.center = alertView.center
        alertLabel.translatesAutoresizingMaskIntoConstraints = false
        alertLabel.text = text
        alertLabel.numberOfLines = 0
        alertLabel.textAlignment = .center
        alertLabel.font = UIFont.boldSystemFont(ofSize: 17)
        alertLabel.textColor = success ? .darkGray : .systemRed
        alertView.addSubview(alertLabel)
        
        let leading = NSLayoutConstraint(
            item: alertLabel,
            attribute: .leading,
            relatedBy: .equal,
            toItem: alertView,
            attribute: .leading,
            multiplier: 1,
            constant: 10
        )
        let trailing = NSLayoutConstraint(
            item: alertLabel,
            attribute: .trailing,
            relatedBy: .equal,
            toItem: alertView,
            attribute: .trailing,
            multiplier: 1,
            constant: -10
        )
        let top = NSLayoutConstraint(
            item: alertLabel,
            attribute: .top,
            relatedBy: .equal,
            toItem: alertView,
            attribute: .top,
            multiplier: 1,
            constant: success ? 50 : 20
        )
        NSLayoutConstraint.activate([top, leading, trailing])
    }
    
    private func getAlertButton(success: Bool) {
        //if alert is displaying dismissable info, view&button disappears automatically
        alertButton.isHidden = success
        timer.setDismissTimer(duration: 1) { [weak self] in
            self?.dismiss(animated: true)
        }
        alertButton.translatesAutoresizingMaskIntoConstraints = false
        alertButton.tintColor = .white
        alertButton.maskCurved(highly: false)
        alertButton.backgroundColor = UIColor.ColorKey.skyBlue
        alertButton.setTitle(ButtonTitle.cancel, for: .normal)
        alertButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        alertView.addSubview(alertButton)
        
        let top = NSLayoutConstraint(
            item: alertButton,
            attribute: .top,
            relatedBy: .equal,
            toItem: alertLabel,
            attribute: .bottom,
            multiplier: 1,
            constant: 10
        )
        let bottom = NSLayoutConstraint(
            item: alertButton,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: alertView,
            attribute: .bottom,
            multiplier: 1,
            constant: -10
        )
        let height = NSLayoutConstraint(
            item: alertButton,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1,
            constant: 40
        )
        let aspectRatio = NSLayoutConstraint(
            item: alertButton,
            attribute: .width,
            relatedBy: .equal,
            toItem: alertButton,
            attribute: .height,
            multiplier: 4,
            constant: 0
        )
        let centerX = NSLayoutConstraint(
            item: alertButton,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: alertView,
            attribute: .centerX,
            multiplier: 1,
            constant: 0
        )
        NSLayoutConstraint.activate([top, bottom, height, aspectRatio, centerX])
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
