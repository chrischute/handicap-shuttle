//
//  MainPageViewController.swift
//  Wheels
//
//  Created by Christopher Chute on 10/30/16.
//  Copyright © 2016 Christopher Chute. All rights reserved.
//

import UIKit

class MainPageViewController: UIPageViewController, UIPageViewControllerDataSource {
    private enum PageId {
        case queue
        case onDemand
        case planAhead
    };
    
    private var pages: [UIViewController] =
        [MainPageViewController.pageVC(with: PageId.queue),
         MainPageViewController.pageVC(with: PageId.onDemand),
         MainPageViewController.pageVC(with: PageId.planAhead)]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
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
        if let vcIndex = pages.index(of: viewController) {
            if vcIndex > 0 {
                return pages[vcIndex - 1]
            }
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let vcIndex = pages.index(of: viewController) {
            if vcIndex < pages.count - 1 {
                return pages[vcIndex + 1]
            }
        }

        return nil
    }

    private class func pageVC(with id: PageId) -> UIViewController {
        var idString = ""
        switch (id) {
        case .onDemand: idString = "onDemandViewController"
        case .queue: idString = "queueViewController"
        case .planAhead: idString = "planAheadViewController"
        }
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: idString)
    }
}
