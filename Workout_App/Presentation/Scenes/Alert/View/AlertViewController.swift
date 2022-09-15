//
//  AlertViewController.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 07.09.22.
//

import UIKit

protocol AlertDisplayLogic: AnyObject {
    func displayIntensityData(viewModel: Alert.GetWorkoutIntensity.ViewModel)
}

final class AlertViewController: UIViewController, CAAnimationDelegate {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var alertViewTitle: UILabel!
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
    
    //MARK: - Alert Data
    private var sets = [String]()
    private var reps = [String]()
    private var weekDays = [String]()
    private var selectedData: (sets: Int, reps: Int, weekDay: String)?
    
    //MARK: - Animation Manager
    let animationManager = AnimationManager()
    
    //MARK: - Object Lifecycle
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
    }
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //adding imageView to tabBar for transparent backgroudn
        fakeTabBar.backgroundImage = UIImage()
        getIntensityData()
        setupAlertView()
    }
    
    //MARK: - IBAction
    
    @IBAction func saveBtnTapped(_ sender: UIButton) {
        guard let sets = selectedData?.sets,
              let reps = selectedData?.reps,
              let weekDay = selectedData?.weekDay,
              reps >= 5 else {
            repRangeAlert()
            animationManager.shakeAnimation(ofView: alertView)
            return
        }
        
        let request = Alert.SaveWorkout.Request(sets: sets, reps: reps, weekDay: WeekDayModel(name: weekDay))
        interactor?.saveWorkout(request: request)
        animateSaving()
    }
    
    @IBAction func cancelBtnTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    //MARK: - Methods
    
    private func getIntensityData() {
        let request = Alert.GetWorkoutIntensity.Request()
        interactor?.getWorkoutIntensityData(request: request)
    }
    
    private func setupAlertView() {
        alertView.withAppDesign(layer: gradientMaskLayer, curvedCorners: true)
        saveBtn.maskCurved()
        cancelBtn.maskCurved()
    }
    
    private func setupIntensity(data: (sets: [String], reps: [String], weekDays: [String])) {
        self.sets = data.sets
        self.reps = data.reps
        self.weekDays = data.weekDays
    }
    
    private func repRangeAlert(repCount: Int=0) {
        if repCount >= 5 {
            alertViewTitle.text = AlertTitle.initialText
            alertViewTitle.textColor = AlertTitle.initialColor
        } else {
            alertViewTitle.text = AlertTitle.alertText
            alertViewTitle.textColor = AlertTitle.alertColor
        }
    }
    
    private func animateSaving() {
        self.animationManager.movingAnimation(fromView: self.alertView, toView: self.triggerView, isRotated: true) { [weak self] in
            self?.alertView.removeFromSuperview()
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
    
    func displayIntensityData(viewModel: Alert.GetWorkoutIntensity.ViewModel) {
        setupIntensity(data: (viewModel.sets, viewModel.reps, viewModel.weekDays))
    }
}

//MARK: - PickerView Delegate & DataSource

extension AlertViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
