//
//  ViewController.swift
//  FlippingLabelExample
//
//  Created by Matthias Mellouli on 2017-02-03.
//  Copyright © 2017 Matthias Mellouli. All rights reserved.
//

import UIKit

class MainView: MainViewPositions {
  
    
    override func fillWithData(){
  
        titleMain.text = "Дневная лотерея"
        titlePrize.text = "Призовой фонд"
        
        moneyTablet.startTimer(0, 300)
        
        peopleCount.text = Int(2442345).stringWithSepator
        usSum.text = Int(232345).stringWithSepator

        
        titleUntilTheEnd.text = "До конца регистрации"

        clockTablet.startTimer(1500, 2500)

        prizePlaces.setTitle("Призовые места", for: .normal)
        takePartEth.text = "0,0005 Eth"

    }

 
}


