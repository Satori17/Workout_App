//
//  WeekDayHeaderView.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 04.09.22.
//

import UIKit

class WeekDayHeaderView: UIView {
    
    //MARK: - IBOutlets
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var weekDayLabel: UILabel!
    @IBOutlet weak var reminderBackgroundView: UIView!
    @IBOutlet weak var setReminderBtn: UIButton!
    @IBOutlet weak var cancelReminderBtn: UIButton!
    @IBOutlet weak var saveReminderBtn: UIButton!
    @IBOutlet weak var editReminderBtn: UIButton!
    
    //MARK: - Properties
    
    private let datePicker = UIDatePicker()
    private let animationManager = AnimationManager()
    private let notificationManager = NotificationManager()
    private let userDefaults = UserDefaults.standard
    private let timer = Timer()
    private var isEditing = false
    
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
        animationManager.toggleAppearence(ofViews: [datePicker, setReminderBtn], actorView: reminderBackgroundView) { [weak self] in
            _ = self?.checkHasNotification(weekDay: self?.weekDayLabel.text)
        }
    }
    
    @IBAction func cancelReminderBtnTapped(_ sender: UIButton) {
        animationManager.toggleAppearence(ofViews: [datePicker, setReminderBtn], actorView: reminderBackgroundView)
        if checkHasNotification(weekDay: weekDayLabel.text) {
            animationManager.toggleAppearence(ofButtons: [cancelReminderBtn, saveReminderBtn])
        }
        removeWeekDayNotification()
        //notificationManager.removeAllPendingRequests()
        //print(notificationManager.getPendingRequests())
        //print(userDefaults.string(forKey: weekDayLabel.text!))
    }

    @IBAction func saveReminderBtnTapped(_ sender: UIButton) {
        setupAddReminderBtn()
        checkIsEditing()
        removeWeekDayNotification()
        addWeekDayNotification()
        checkButtonAppearence()
        
    }
    
    @IBAction func editReminderBtnTapped(_ sender: UIButton) {
        animationManager.toggleAppearence(ofButtons: [cancelReminderBtn, saveReminderBtn])
        checkButtonAppearence()
        datePicker.isEnabled = animationManager.isButtonsAppeared
        isEditing = true
    }
    
    //MARK: - Initial Setup Methods
    
    private func initWeekDayHeaderView() {
        let nib = UINib(nibName: "WeekDayHeaderView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        contentView.clipsToBounds = true
        addSubview(contentView)
    }
    
    private func setupDatePicker() {
        datePicker.alpha = 0
        datePicker.isEnabled = false
        datePicker.preferredDatePickerStyle = .compact
        datePicker.minuteInterval = 1
        datePicker.datePickerMode = .time
        datePicker.locale = Locale(identifier: "en_GB")
        datePicker.frame = setReminderBtn.frame
        reminderBackgroundView.addSubview(datePicker)
    }
    
    private func setupAddReminderBtn() {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let currentTime = formatter.string(from: datePicker.date)
        setReminderBtn.setTitle("\(currentTime)", for: .normal)
        setReminderBtn.isSelected = true
    }
    
    //MARK: - Helper Methods
    
    //general method of scheduling notification
    private func addWeekDayNotification() {
        if let weekDay = weekDayLabel.text,
           let selectedWeekDay = WeekDayKeys.weekDaysDict[weekDay] {
            notificationManager.createNotification(withTitle: weekDay, description: "Workout day!", weekDay: selectedWeekDay, hourDate: datePicker.date)
        }
    }
    
    //general method of removing notification
    private func removeWeekDayNotification() {
        notificationManager.removePendingNotification(key: weekDayLabel.text)
    }
    
    //checks if weekDay has notification scheduled already
    private func checkHasNotification(weekDay: String?) -> Bool {
        var buttonsToAppear = [UIButton]()
        var result = false
        if let weekDay = weekDay,
           let _ = userDefaults.string(forKey: weekDay) {
            buttonsToAppear = [editReminderBtn]
            result = true
        } else {
            buttonsToAppear = [cancelReminderBtn, saveReminderBtn]
            datePicker.isEnabled = true
            result = false
        }
        animationManager.toggleAppearence(ofButtons: buttonsToAppear)
        return result
    }
    
    //checks if secondary buttons (remove&save) is appeared
    private func checkButtonAppearence() {
        if !animationManager.isButtonsAppeared, !editReminderBtn.isHidden {
            dismissViews()
        }
    }
    
    //adding animation depend on scheduled weekDay is editing or creating new notification
    private func checkIsEditing() {
        if !isEditing {
        animationManager.toggleAppearence(ofButtons: [cancelReminderBtn, saveReminderBtn])
        animationManager.toggleAppearence(ofViews: [datePicker, setReminderBtn], actorView: reminderBackgroundView)
        } else {
            animationManager.toggleAppearence(ofButtons: [cancelReminderBtn, saveReminderBtn])
        }
    }
    
    //adds timer for views to be dismissed
    private func dismissViews() {
        timer.setDismissTimer(duration: 5) { [weak self] in
            if let datePicker = self?.datePicker,
               let setReminder = self?.setReminderBtn,
               let editBtn = self?.editReminderBtn,
               let backgroundView = self?.reminderBackgroundView {
                self?.animationManager.toggleAppearence(ofViews: [datePicker, setReminder, editBtn], actorView: backgroundView)
            }
        }
    }
    
}
