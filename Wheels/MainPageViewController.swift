//
//  MainPageViewController.swift
//  Wheels
//
//  Created by Christopher Chute on 10/30/16.
//  Copyright © 2016 Christopher Chute. All rights reserved.
//

import UIKit
import CoreData

class MainPageViewController: UIPageViewController, UIPageViewControllerDataSource {
    var rider: Rider!
    var moc: NSManagedObjectContext!
    private var pages: [UIViewControllerWithRider]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        
        pages = [pageVC(with: StoryboardConstants.queueViewControllerId),
                 pageVC(with: StoryboardConstants.onDemandViewControllerId),
                 pageVC(with: StoryboardConstants.planAheadViewControllerId)]
        
        if let firstPageToDisplay = pages[1] as? OnDemandViewController {
            setViewControllers([firstPageToDisplay],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    /* UIPageViewControllerDataSource Protocol */
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! UIViewControllerWithRider
        if let vcIndex = pages.index(of: vc) {
            if vcIndex > 0 {
                return pages[vcIndex - 1]
            }
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! UIViewControllerWithRider
        if let vcIndex = pages.index(of: vc) {
            if vcIndex < pages.count - 1 {
                return pages[vcIndex + 1]
            }
        }
        
        return nil
    }
    
    /**
     * Initialize and return one of the main pages. Each must be given the rider
     * and the NSManagedObject context against which to query for rides.
     */
    private func pageVC(with id: String) -> UIViewControllerWithRider {
        let rvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: id) as! UIViewControllerWithRider
        rvc.rider = self.rider
        rvc.moc = self.moc
        
        Debug.log("Initialized VC with ID \(id) and rider \(rvc.rider.netId!)")
        
        return rvc
    }
}
