//
//  TutorialScroll.swift
//  Carita
//
//  Created by   on 3/28/17.
//  Copyright © 2017 TheRealStart. All rights reserved.
//


import UIKit

class TutorialScroll : PopUpCore , UIScrollViewDelegate{
    
    // MARK: Loadings
    
    let pagesCount = 5

    
    @IBOutlet weak var scroll: UIScrollView!
    
    @IBOutlet weak var pages: UIPageControl!

    @IBOutlet weak var skip: UIButton!

    @IBOutlet weak var tutorial_text: UILabel!

    @IBOutlet weak var want_more: UIButton!

    @IBOutlet weak var lets_start: UIButton!


    class func createTutorialScroll() -> TutorialScroll {
        let myClassNib = UINib(nibName: "TutorialScroll", bundle: nil)
        return myClassNib.instantiate(withOwner: nil, options: nil)[0] as! TutorialScroll
    }
    
    override func setInitBorders() { 
        
        self.clipsToBounds = true
        scroll.backgroundColor = UIColor.clear
        scroll.setNeedsLayout()
        scroll.layoutIfNeeded()
        scroll.isPagingEnabled = true
        
        want_more.layer.opacity = 0
        lets_start.layer.opacity = 0
        
        for index in 0..<pagesCount {
            
            let subView = UIImageView(image: UIImage(named: "\(1+index)_" + langCodes[current_language_ind]))
            subView.frame =  CGRect(x: scroll.frame.size.width * CGFloat(index) + 30,
                                    y: 0,
                                    width:  scroll.frame.width - 60,
                                    height: scroll.frame.height)
            subView.backgroundColor = UIColor.clear
            subView.contentMode = .scaleAspectFit
            
            scroll.addSubview(subView)

        }
        
        
        let subView = UIView(frame: scroll.frame)
        subView.frame.origin.x = scroll.frame.size.width * CGFloat(pagesCount)
        subView.backgroundColor = UIColor.clear
        scroll.addSubview(subView)
        
        pages.numberOfPages = pagesCount
        scroll.contentSize = CGSize(width: scroll.frame.size.width * CGFloat(pagesCount),
                                        height: scroll.frame.size.height)
        pages.addTarget(self, action: #selector(TutorialScroll.changePage(_:)), for: .valueChanged)

        changeText(0)
        
        skip.setTitle(TR("skip"), for: .normal)
        want_more.setTitle(TR("need_more_info"), for: .normal)
        lets_start.setTitle(TR("lets_start"), for: .normal)

        self.isUserInteractionEnabled = true
         
    }
    
    func changePage(_ sender: AnyObject) -> () {
        let x = CGFloat(pages.currentPage) * scroll.frame.size.width
        scroll.setContentOffset(CGPoint(x: x, y: 0), animated: true)
        changeText(pages.currentPage)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pageNumber = Int(round(scroll.contentOffset.x / scroll.frame.size.width))
        pages.currentPage = pageNumber
        changeText(pageNumber)
        
    }

   
    override func addSwipeGesture(){
    
    
    }
    
 
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let ind = Int(round(scroll.contentOffset.x / scroll.frame.size.width))

        let middlz = scroll.contentOffset.x / scroll.frame.size.width
        
        let diff = (middlz - ceil(middlz) + 0.5) * 2

//        print("diff = ",diff, " ind = ",ind)
        
        changeText(ind, Float(diff))

        if ind == (pagesCount - 1) {
            revealButtons(Float(diff))
        } else {
            revealButtons()
        }
    }
    
    func changeText(_ num: Int, _ opacity : Float = 1){
        
        tutorial_text.layer.opacity = abs(opacity)
        tutorial_text.text = TR("tutorial_text_\(num + 1)")
    }
    
    func revealButtons( _ opacity : Float = 0){
        
        want_more.layer.opacity = opacity
        lets_start.layer.opacity = opacity
        skip.layer.opacity = 1 - opacity
    }
    
    
    @IBAction func onLets(){
        
        if lets_start.layer.opacity == 1 {
            
            onX()
        }
    }
    
    @IBAction func onMore(){
        if want_more.layer.opacity == 1 {
            
            onWideX(0, {
                current_controller_core?.goToFAQ()
            })
            
        }
    }


}
