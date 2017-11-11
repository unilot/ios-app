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
    
    let pagesCount = 6

    
    @IBOutlet weak var scroll: UIScrollView!
    
    @IBOutlet weak var pages: UIPageControl!
    

    class func createTutorialScroll() -> TutorialScroll {
        let myClassNib = UINib(nibName: "TutorialScroll", bundle: nil)
        return myClassNib.instantiate(withOwner: nil, options: nil)[0] as! TutorialScroll
    }
    
    override func setInitBorders() { 
        
        self.clipsToBounds = true
        scroll.backgroundColor = UIColor.clear
        scroll.layoutIfNeeded()
        scroll.frame = CGRect(x: 0, y: 55, width: self.bounds.width, height: self.bounds.height - 80)
        scroll.isPagingEnabled = true
        
        let labelHeight = CGFloat(80)

        for index in 0..<pagesCount {
            
            let subView = UIImageView(image: UIImage(named: "promt-\(1+index)"))
            subView.frame =  CGRect(x: 20, y: labelHeight + 20,
                                    width: scroll.frame.width - 40, height: scroll.frame.height - labelHeight - 20)
            subView.frame.origin.x = scroll.frame.size.width * CGFloat(index) + 20
            subView.backgroundColor = UIColor.clear
            subView.contentMode = .scaleAspectFit
            scroll.addSubview(subView)
            
            
            let textTitle = UILabel(frame: CGRect(x: 20, y: 0,
                                                  width: scroll.frame.width - 40, height: labelHeight))
            textTitle.frame.origin.x = scroll.frame.size.width * CGFloat(index) + 20
            textTitle.text = TR("tutorial_text_\(1+index)")
            textTitle.numberOfLines = 0
            textTitle.font = UIFont(name: kFont_Light, size: 14)
            textTitle.layer.cornerRadius = 6
            textTitle.backgroundColor = UIColor.black.withAlphaComponent(0.8)
            textTitle.textAlignment   = .center
            textTitle.textColor       = UIColor.white
            scroll.addSubview(textTitle)

        }
        
        
        let subView = UIView(frame: scroll.frame)
        subView.frame.origin.x = scroll.frame.size.width * CGFloat(pagesCount)
        subView.backgroundColor = UIColor.clear
        scroll.addSubview(subView)
        
        pages.numberOfPages = pagesCount
        scroll.contentSize = CGSize(width: scroll.frame.size.width * CGFloat(pagesCount),
                                        height: scroll.frame.size.height)
        pages.addTarget(self, action: #selector(TutorialScroll.changePage(_:)), for: .valueChanged)

        
    }
    
    func changePage(_ sender: AnyObject) -> () {
        let x = CGFloat(pages.currentPage) * scroll.frame.size.width
        scroll.setContentOffset(CGPoint(x: x, y: 0), animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pageNumber = Int(round(scroll.contentOffset.x / scroll.frame.size.width))
        pages.currentPage = pageNumber

    }
    
    override func addSwipeGesture(){
    
    
    }
        
}



