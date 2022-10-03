//
//  WeekDayHeaderView.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 04.09.22.
//

import UIKit

protocol updateHeaderDataProtocol: AnyObject {
    func getScheduledTime()
}

class WeekDayHeaderView: UIView {
    
    //MARK: - IBOutlets
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var weekDayLabel: UILabel!
    @IBOutlet weak var reminderBackgroundView: UIView!
    @IBOutlet weak var setReminderBtn: UIButton!
    @IBOutlet weak var cancelReminderBtn: UIButton!
    @IBOutlet weak var saveReminderBtn: UIButton!
    @IBOutlet weak var editReminderBtn: UIButton!
    
    //MARK: - Managers
    private var animationManager: AnimationManager?
    private var notificationManager: NotificationManager?
    private var storageManager: WorkoutStorageManagerLogic?
    
    //MARK: - UserDefaults
    private let userDefaults = UserDefaults.standard
    
    //MARK: - View Components
    var viewController: UIViewController?
    private let datePicker = UIDatePicker()
    private let loadingView = UIActivityIndicatorView()
    private let timer = Timer()
    private var startDate: Date?
    private var isEditing = false
    
    //MARK: - Categories data for notification description text
    var workoutCategories = [String]() {
        didSet {
            workoutCategories = getMode(from: workoutCategories)
        }
    }
    
    private var notificationDescription: String {
        getNotificationDescription()
    }
    
    //MARK: - Updating delegate
    weak var delegate: updateHeaderDataProtocol?
    
    //MARK: - Object Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        initWeekDayHeaderView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initWeekDayHeaderView()
    }
    
    //MARK: - IBActions
    @IBAction func setReminderBtnTapped(_ sender: UIButton) {
        self.setupDatePicker()
        animationManager?.toggleAppearence(ofViews: [datePicker, setReminderBtn], actorView: reminderBackgroundView) { [weak self] in
            self?.checkIfHasNotification(weekDay: self?.weekDayLabel.text)
            self?.dismissViewToInitialState()
            self?.startDate = Date()
        }
    }
    
    @IBAction func cancelReminderBtnTapped(_ sender: UIButton) {
        reminderActions { [weak self] in
            if let datePicker = self?.datePicker,
               let reminderBtn = self?.setReminderBtn,
               let backgroundView = self?.reminderBackgroundView {
                self?.animationManager?.toggleAppearence(ofViews: [datePicker, reminderBtn], actorView: backgroundView)
                self?.removeWeekDayNotification()
                self?.removeScheduled(weekDay: self?.weekDayLabel.text)
            }
        }
    }
    
    @IBAction func saveReminderBtnTapped(_ sender: UIButton) {
        reminderActions { [weak self] in
            self?.checkIsEditing()
            self?.removeWeekDayNotification()
            self?.addWeekDayNotification()
            self?.saveScheduled(weekDay: self?.weekDayLabel.text)
        }
    }
    
    @IBAction func editReminderBtnTapped(_ sender: UIButton) {
        animationManager?.toggleAppearence(ofButtons: [cancelReminderBtn, saveReminderBtn])
        let buttonsCondition = animationManager?.checkIfButtonsAppeared([cancelReminderBtn, saveReminderBtn])
        if let buttonsCondition {
            datePicker.isEnabled = buttonsCondition
        }
        isEditing = true
        dismissViewToInitialState()
        startDate = Date()
    }
    
    //MARK: - Configure Methods
    func configure(weekDay: WeekDayModel) {
        weekDayLabel.text = weekDay.name
        setReminderBtn.isSelected = weekDay.isScheduled
        setReminderBtn.setTitle(weekDay.scheduledTime, for: .normal)
    }
    
    private func configureManagers() {
        let animationManager = AnimationManager()
        let notificationManager = NotificationManager()
        let storageManager = WorkoutStorageManager()
        
        self.animationManager = animationManager
        self.notificationManager = notificationManager
        self.storageManager = storageManager
    }
    
    //MARK: - Initial Setup Methods
    private func initWeekDayHeaderView() {
        let nib = UINib(nibName: Ids.headerView, bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        contentView.clipsToBounds = true
        configureManagers()
        addSubview(contentView)
    }
    
    private func setupDatePicker() {
        datePicker.isHidden = false
        datePicker.alpha = 0
        datePicker.isEnabled = false
        datePicker.preferredDatePickerStyle = .compact
        datePicker.minuteInterval = 1
        datePicker.datePickerMode = .time
        datePicker.locale = Locale(identifier: Formatted.en_localeId)
        datePicker.frame = setReminderBtn.frame
        reminderBackgroundView.addSubview(datePicker)
    }
    
    private func setupLoadingView() {
        loadingView.hidesWhenStopped = true
        loadingView.frame = setReminderBtn.frame
        loadingView.style = .medium
        loadingView.startAnimating()
        reminderBackgroundView.addSubview(loadingView)
    }
    
    //MARK: - Helper Methods
    private func getMode(from categoriesData: [String]) -> [String] {
        var dictionary = [String: Int]()
        categoriesData.forEach({
            dictionary[$0] = (dictionary[$0] ?? CustomTitle.zero) + 1
        })
        let mode = dictionary.filter({$0.value == dictionary.values.max()}).keys
        let result = mode.map { "\($0), " }
        
        return result
    }
    
    private func getNotificationDescription() -> String {
        var textData = "\(workoutCategories.reduce(CustomTitle.empty, +))"
        textData.removeLast(2)
        let descriptionText = "\(textData) day!"
        
        return descriptionText
    }
    
    private func reminderActions(completion: @escaping () -> ()) {
        setupLoadingView()
        datePicker.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            completion()
            self?.toggleSetReminderBtn()
            self?.loadingView.stopAnimating()
        }
    }
    
    //getting user's chosen time from date picker
    private func getChosenTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = Formatted.dateFormat
        let currentTime = formatter.string(from: datePicker.date)
        
        return currentTime
    }
    
    //MARK: - Notification Helper Methods
    private func addWeekDayNotification() {
        if let weekDay = weekDayLabel.text,
           let selectedWeekDay = WeekDayKeys.weekDaysDict[weekDay] {
            notificationManager?.createNotification(withTitle: weekDay, description: notificationDescription, weekDay: selectedWeekDay, hourDate: datePicker.date, completionHandler: { [weak self] errorMessage in
                guard let vc = self?.viewController else { return }
                self?.notificationManager?.errorNotificationAlert(onVC: vc, text: errorMessage)
            })
        }
    }
    
    private func removeWeekDayNotification() {
        notificationManager?.removePendingNotification(key: weekDayLabel.text)
    }
    
    private func checkIfHasNotification(weekDay: String?) {
        var buttonsToAppear = [UIButton]()
        if let weekDay = weekDay,
           let _ = userDefaults.string(forKey: weekDay) {
            buttonsToAppear = [editReminderBtn]
        } else {
            buttonsToAppear = [cancelReminderBtn, saveReminderBtn]
            datePicker.isEnabled = true
        }
        animationManager?.toggleAppearence(ofButtons: buttonsToAppear)
    }
    
    //MARK: - Storage Manager Helper Methods
    private func saveScheduled(weekDay: String?) {
        do {
            if let weekDay = weekDay {
                try storageManager?.addSchedule(ofWeekDay: weekDay, time: getChosenTime())
            }
        } catch {
            guard let vc = viewController else { return }
            notificationManager?.errorNotificationAlert(onVC: vc, text: StorageManagerError.saveScheduleFailed.rawValue)
        }
    }
    
    private func removeScheduled(weekDay: String?) {
        do {
            if let weekDay = weekDay {
                try storageManager?.removeSchedule(ofWeekDay: weekDay)
            }
        } catch {
            guard let vc = viewController else { return }
            notificationManager?.errorNotificationAlert(onVC: vc, text: StorageManagerError.removeScheduleFailed.rawValue)
        }
    }
    
    //MARK: - HeaderView Helper Methods
    private func toggleSetReminderBtn() {
        setReminderBtn.isSelected = !setReminderBtn.isSelected
        let text = setReminderBtn.isSelected ? "\(getChosenTime())" : CustomTitle.plus
        setReminderBtn.setTitle(text, for: .normal)
        DispatchQueue.main.async {
            self.delegate?.getScheduledTime()
        }
    }
    
    //adding animation depend on scheduled weekDay is editing or creating new notification
    private func checkIsEditing() {
        if !isEditing {
            animationManager?.toggleAppearence(ofButtons: [cancelReminderBtn, saveReminderBtn])
            animationManager?.toggleAppearence(ofViews: [datePicker, setReminderBtn], actorView: reminderBackgroundView)
        } else {
            animationManager?.toggleAppearence(ofButtons: [cancelReminderBtn, saveReminderBtn])
        }
    }
    
    //adds timer for views to be dismissed
    private func dismissViewToInitialState() {
        timer.setDismissTimer(duration: 3) { [weak self] in
            if let datePicker = self?.datePicker,
               let setReminder = self?.setReminderBtn,
               let editBtn = self?.editReminderBtn,
               let backgroundView = self?.reminderBackgroundView {
                if !datePicker.isEnabled {
                    //checks duration between last and previous tap on edit button
                    if let startDate = self?.startDate {
                        let timeInterval = Date().timeIntervalSince(startDate)
                        if timeInterval > 3 {
                            self?.animationManager?.toggleAppearence(ofViews: [datePicker, setReminder, editBtn], actorView: backgroundView)
                        }
                    }
                }
            }
        }
    }
}
