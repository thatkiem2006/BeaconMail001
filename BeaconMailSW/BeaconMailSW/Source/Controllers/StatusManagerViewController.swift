//
//  StatusManagerViewController.swift
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

import UIKit
import MapKit
class StatusManagerViewController: BaseViewController {
    @IBOutlet weak var tabBar: UITabBar!
    fileprivate var pageViewController:UIPageViewController?
    fileprivate var indexPage = 0
    fileprivate(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.newViewController("StatusScreenViewController"),
                self.newViewController("iBeaconMonitorViewController"),
                self.newViewController("GeoFenceMonitorViewController")]
    }()
    
    fileprivate func newViewController(_ identifier: String) -> UIViewController {
        return self.storyboard!.instantiateViewController(withIdentifier: "\(identifier)")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initForView()
        self.tabBar.delegate = self;
    }
    func initForView() {
        self.pageViewController = self.storyboard?.instantiateViewController(withIdentifier: "PageViewController") as? UIPageViewController
        self.pageViewController?.delegate = self;
        self.pageViewController?.dataSource = self;
        DispatchQueue.main.async {
            if let firtViewController = self.orderedViewControllers.first{
                self.pageViewController?.setViewControllers([firtViewController], direction: .forward, animated: true, completion: nil)
            }
        }
        
        self.addChildViewController(self.pageViewController!)
        var framePage = self.pageViewController?.view.frame
        framePage = CGRect(x: 0, y: 64, width: framePage!.size.width, height: framePage!.size.height - 114)
        self.pageViewController?.view.frame = framePage!
        self.view.addSubview((self.pageViewController?.view)!)
        self.pageViewController?.didMove(toParentViewController: self)
        self.tabBar.selectedItem = self.tabBar.items![0]
        self.removeSwipeGestureOfPageVC()
        self.reloadTitleBy(index: 0)
    }
    
    //MARK: - Private Method
    fileprivate func removeSwipeGestureOfPageVC(){
        for view in self.pageViewController!.view.subviews {
            if let subView = view as? UIScrollView {
                subView.isScrollEnabled = false
            }
        }
    }
    //MARK: - Public Method
    func reloadTitleBy(index: Int) {
        var title = ""
        var iconName = "img_status_disable"
        switch index {
        case 0:
            title = "ステータス"
        case 1:
            title = "iBeacon"
        case 2:
            title = "GeoFence"
        default:
            break
        }
        self.setNavWithImageAndTitle(iconName, title: title)
        
    }
    
}
extension StatusManagerViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = self.orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        return orderedViewControllers[nextIndex]
    }
    
}
extension StatusManagerViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if let index = tabBar.items?.index(of: item){
            let viewcontroler = self.orderedViewControllers[index]
            self.pageViewController?.setViewControllers([viewcontroler], direction: .forward, animated: false, completion: nil)
            if index == 2  {
                self.tap()
            }
            self.reloadTitleBy(index: index)
        }
        
    }
}


//test
extension StatusManagerViewController:UIViewControllerTransitioningDelegate{
    //MARK: - Test Add MapView
    func tap() {
        
        let pvc = self.storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        
        pvc.modalPresentationStyle = UIModalPresentationStyle.custom
        pvc.transitioningDelegate = self
        
        self.present(pvc, animated: true, completion: nil)
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController??, source: UIViewController) -> UIPresentationController? {
        return HalfSizePresentationController(presentedViewController: presented, presenting: presentingViewController!)
    }
}

class HalfSizePresentationController : UIPresentationController {
    override var frameOfPresentedViewInContainerView : CGRect {
        return CGRect(x: 0, y: (containerView?.bounds.height)!/2, width: (containerView?.bounds.width)!, height: (containerView?.bounds.height)!/2)
    }
}

class MapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mapView.zoomToUserLocation()
        if let geoFenceList = StaticData.shared.bmConfiguration?.geofenceList {
            for geoFence in geoFenceList {
                self.addRadiusOverlay(geoFence.region())
            }
        }
    }
    @IBAction func closeView(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func addRadiusOverlay(_ region: CLCircularRegion) {
        mapView.addAnnotation(Geotification(coordinate: region.center, radius: region.radius, identifier: region.identifier, note: ""))
        mapView?.add(MKCircle(center: region.center, radius: region.radius))
    }
}
extension MKMapView {
    func zoomToUserLocation() {
        guard let coordinate = userLocation.location?.coordinate else { return }
        let region = MKCoordinateRegionMakeWithDistance(coordinate, 10000, 10000)
        setRegion(region, animated: true)
    }
}

class Geotification: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var radius: CLLocationDistance
    var identifier: String
    var note: String
    var title: String? {
        if note.isEmpty {
            return "No Note"
        }
        return note
    }
    var subtitle: String? {
        return "Radius: \(radius)m)"
    }
    
    init(coordinate: CLLocationCoordinate2D, radius: CLLocationDistance, identifier: String, note: String) {
        self.coordinate = coordinate
        self.radius = radius
        self.identifier = identifier
        self.note = note
    }
}
