//
//  TableViewController1.swift
//  BusanMap02
//
//  Created by D7703_11 on 2018. 12. 11..
//  Copyright © 2018년 김종현. All rights reserved.
//

import UIKit

class TableViewController1: UITableViewController {

    @IBOutlet weak var dadd: UILabel!
    @IBOutlet weak var dgubun: UILabel!
    @IBOutlet weak var dtel: UILabel!
    @IBOutlet weak var dmember: UILabel!
    @IBOutlet weak var dteacher: UILabel!
    @IBOutlet weak var droom: UILabel!
    @IBOutlet weak var dcar: UILabel!
    @IBOutlet weak var dhome: UILabel!
    
    var selectedForDetail: BusanData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let title = selectedForDetail?.title
        let subtitle = selectedForDetail?.subtitle
        let tel = selectedForDetail?.phone
        let member = selectedForDetail?.member
        let teacher = selectedForDetail?.teacher
        let room = selectedForDetail?.room
        let car = selectedForDetail?.car
        let home = selectedForDetail?.homepage
        let add = selectedForDetail?.addrRoad
        
        self.title = title
        dadd.text = add
        dgubun.text = subtitle
        dtel.text = tel
        dmember.text = member
        dteacher.text = teacher
        droom.text = room
        dcar.text = car
        dhome.text = home
    }

   
}
