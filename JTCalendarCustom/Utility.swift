//
//  Utility.swift
//  JTCalendarCustom
//
//  Created by Lam Le Tung on 12/14/18.
//  Copyright © 2018 ltlam. All rights reserved.
//

import Foundation
import UIKit

class Utility: NSObject {
    static func backToPreviousScreen(_ view: UIViewController){
        if view.navigationController != nil{
            view.navigationController?.popViewController(animated: true)
        }else{
            view.dismiss(animated: true, completion: nil)
        }
    }
}
