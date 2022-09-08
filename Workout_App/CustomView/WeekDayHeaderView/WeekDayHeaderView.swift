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
    
    //MARK: - Object Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initWeekDayHeaderView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initWeekDayHeaderView()
    }
    
    //MARK: - Methods
    
    private func initWeekDayHeaderView() {
        let nib = UINib(nibName: "WeekDayHeaderView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        contentView.clipsToBounds = true
        addSubview(contentView)
    }
}
