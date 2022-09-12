//
//  Timer+Extension.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 12.09.22.
//

import UIKit

extension Timer {
    
    func setDismissTimer(duration: Int,completion: @escaping () -> ()) {
        let timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(duration), repeats: false) { timer in
            completion()
            timer.invalidate()
        }
        RunLoop.current.add(timer, forMode:RunLoop.Mode.default)
    }
}
