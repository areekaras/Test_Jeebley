//
//  SplashViewController.swift
//  Test_Jeebley
//
//  Created by Shibili Areekara on 26/10/18.
//  Copyright © 2018 Shibili Areekara. All rights reserved.
//

import UIKit


/// SplashViewController Handle the following
///   * store Info API  call
///   * downlad store image
///   * go to store VC after api call
class SplashViewController: BaseViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var logoAlignCenterConstraint: NSLayoutConstraint!
    
    //MARK: - VC Variables
    var storeImage: UIImage?
    var isImageDownload = false
    var storeObj : Store?
}

//MARK: - Life cycles
extension SplashViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animateCompanyLogo()
        // API call to get store Info
        getStoreInfo_API()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


//MARK: - Functionalities
extension SplashViewController {
    
    /// Animate Company Logo after view loaded
    func animateCompanyLogo() {
        self.loadingIndicator.isHidden = true
        self.logoImageView.isHidden = false
        UIView.animate(withDuration: 0.8, animations: {
            self.logoAlignCenterConstraint.constant = 0
            self.view.layoutIfNeeded()
        }) { _ in
            self.loadingIndicator.isHidden = false
            self.loadingIndicator.startAnimating()
        }
    }
    
    
    /// API call to get Store Information
    func getStoreInfo_API() {
        self.isImageDownload = false
        let storeInfoURL = "https://jeebleybeta.com/services_new/services.php?action=restaurantAreaInfo&langId=1&countryId=21&areaId=1&rId=366"

        apiCall(url: storeInfoURL)
    }
    
    
    /// Download Store Image
    func downloadStoreImage() {
        self.isImageDownload = true
        let storelist = DBEntityHelpers().fetchStoreEntity()
        storeObj = storelist[0]
        if let storeImageUrl = storeObj?.rImage {
//            let urltest = "https://upload.wikimedia.org/wikipedia/commons/3/36/Hopetoun_falls.jpg"
            apiCall(url: storeImageUrl)
        }
        else {
            presentStoreVC()
        }
    }
        
    
    /// Perform Segue to StoreVC
    func presentStoreVC() {
        DispatchQueue.main.sync {
            self.performSegue(withIdentifier: SegueIds.SPLASH_STORE.rawValue, sender: self)
        }
    }
    
    
    /// Actions after API response
    ///
    /// - Parameter data: data recieved through API call
    func apiResponseActions (data:Data?) {
        guard let data = data else { return }

        do {
            let restaurentInfo = try JSONDecoder().decode(RestaurentInfo.self, from: data)

            guard let storeInfo = restaurentInfo.restaurantAreaInfo else { return }

            DBEntityHelpers().saveToDB(storeInfoObj: storeInfo)

            self.downloadStoreImage()
        }
        catch let jsonErr {
           print("jsonErr :: \(jsonErr)")
        }
    }
    
    
    /// Common Class for API call
    ///
    /// - Parameter url: URL for API call
    func apiCall (url : String) {
        let service = Service()
        service.setConfigUrl(url)
        service.execute{ (data, action, serviceStatus) in
            if self.isImageDownload {
                print(action)
                if serviceStatus == ServiceStatus.SUCCESS.rawValue {
                    self.storeImage = UIImage(data: data!)!
                }
                self.presentStoreVC()
            }
            else {
                if serviceStatus == ServiceStatus.FAILED.rawValue {
                    self.showAlert(title: "", message: action)
                }
                else {
                    self.apiResponseActions(data: data)
                }
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIds.SPLASH_STORE.rawValue{
            let storeVC = segue.destination as! StoreViewController
            
            // Passing store image to next VC
            storeVC.storeImage = self.storeImage
            storeVC.storeInfo = self.storeObj
        }
    }
}
