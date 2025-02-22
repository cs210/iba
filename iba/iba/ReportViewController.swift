//
//  ReportViewController.swift
//  iba
//
//  Created by Raymond kennedy on 4/8/15.
//  Copyright (c) 2015 Raymond Kennedy. All rights reserved.
//

import UIKit

/**
This viewcontroller is responsible for the submission of user-generated reports
for parking spots and features 4 IBARateItemViews (4 different categories)
*/
class ReportViewController: UIViewController {
    
    enum ReportType {
        case Regular
        case Ding
    }
    
    let kRateItemHeight: CGFloat = 90
    let kRateItemPadding: CGFloat = 20
    
    let easeRateItem: IBARateItemView
    let damageRateItem: IBARateItemView
    let spotPriceRateItem: IBARateItemView
    let ticketPriceRateItem: IBARateItemView
    
    var currentLocation: CLLocationCoordinate2D
    var streetName: String
    var reportType: ReportType
    
    let descriptionLabel: UILabel
    let submitButton: IBAButton
    
    let scrollView: UIScrollView
    
    // MARK: Init Methods
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    convenience init(type: ReportType, currentLocation: CLLocationCoordinate2D?, streetName: String?) {
        
        self.init()
        if (currentLocation != nil) {
            self.currentLocation = currentLocation!
        }
        if (streetName != nil) {
            self.streetName = streetName!
        }
        
        self.reportType = type

        setupDescriptionLabel();
        self.submitButton.addTarget(self, action: "submitPressed:", forControlEvents: .TouchUpInside)

    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        
        // Setup the rate items
        self.easeRateItem = IBARateItemView(title: "Ease of parking", lowText: "easy", highText: "hard")
        self.damageRateItem = IBARateItemView(title: "Damage to vehicle", lowText: "none", highText: "lots")
        self.spotPriceRateItem = IBARateItemView(title: "Price of spot", lowText: "free", highText: "expensive")
        self.ticketPriceRateItem = IBARateItemView(title: "Price of ticket", lowText: "no ticket", highText: "$100+")
        
        self.currentLocation = CLLocationCoordinate2DMake(0, 0)
        self.streetName = ""
        self.reportType = .Regular
        
        self.scrollView = UIScrollView(frame: CGRectZero)
        self.scrollView.alwaysBounceVertical = true
        
        self.descriptionLabel = UILabel(frame: CGRectZero)
        self.submitButton = IBAButton(frame: CGRectZero, title: "Submit", colorScheme: UIColor(red: 0.18, green: 0.8, blue: 0.44, alpha: 1.0), clear: true)
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

    }
    
    // MARK: ViewController Life Cycle
    
    override func viewDidLoad() {
        
        // Set the navigationbar titles
        self.title = "Report"
        
        // Layout the subviews
        layoutSubviews()
        
        // Turn off back gestures
        self.navigationController?.interactivePopGestureRecognizer.enabled = false
        
        // Set background color
        self.view.backgroundColor = UIColor.whiteColor()
    }
    
    // MARK: Setup Methods
    
    func setupDescriptionLabel() {
        self.descriptionLabel.font = UIFont(name: "HelveticaNeue-Light", size: 21)
        self.descriptionLabel.textColor = UIColor.blackColor()
        self.descriptionLabel.textAlignment = .Center
        self.descriptionLabel.text = "Let us know how your parking spot at " + self.streetName + " was!"
        self.descriptionLabel.numberOfLines = 3
        self.scrollView.addSubview(self.descriptionLabel)
    }
    
    // MARK: Private Methods
    
    func layoutSubviews() {
        var originY = 0 as CGFloat
        
        let descriptionText: NSString = self.descriptionLabel.text! as NSString
        let descriptionTextSize: CGRect = descriptionText.boundingRectWithSize(CGSizeMake(self.view.bounds.size.width - (kRateItemPadding), self.view.bounds.size.height), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName : self.descriptionLabel.font], context: nil)
        
        self.descriptionLabel.frame = CGRectMake(kRateItemPadding, kRateItemPadding, self.view.bounds.size.width - (kRateItemPadding * 2), descriptionTextSize.height)
        
        originY += self.descriptionLabel.bounds.size.height + kRateItemPadding
        
        // Configure the frames for the rateitems
        self.easeRateItem.frame = CGRectMake(kRateItemPadding, originY + kRateItemPadding, self.view.frame.size.width - (kRateItemPadding * 2), kRateItemHeight)
        self.easeRateItem.userInteractionEnabled = true
        
        originY += kRateItemPadding + kRateItemHeight
        
        self.damageRateItem.frame = CGRectMake(kRateItemPadding, originY + kRateItemPadding, self.view.frame.size.width - (kRateItemPadding * 2), kRateItemHeight)
        self.damageRateItem.userInteractionEnabled = true
        
        originY += kRateItemPadding + kRateItemHeight
        
        self.spotPriceRateItem.frame = CGRectMake(kRateItemPadding, originY + kRateItemPadding, self.view.frame.size.width - (kRateItemPadding * 2), kRateItemHeight)
        self.spotPriceRateItem.userInteractionEnabled = true
        
        originY += kRateItemPadding + kRateItemHeight
        
        self.ticketPriceRateItem.frame = CGRectMake(kRateItemPadding, originY + kRateItemPadding, self.view.frame.size.width - (kRateItemPadding * 2), kRateItemHeight)
        self.ticketPriceRateItem.userInteractionEnabled = true
        
        originY += kRateItemPadding + kRateItemHeight
        
        self.submitButton.frame = CGRectMake(kRateItemPadding, originY + kRateItemPadding, self.view.frame.size.width - (kRateItemPadding * 2), kRateItemHeight/2)
        
        self.scrollView.frame = self.view.frame
        self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, originY + self.submitButton.frame.size.height + kRateItemPadding*2)
        
        // Add them as subviews
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.easeRateItem)
        self.scrollView.addSubview(self.damageRateItem)
        self.scrollView.addSubview(self.spotPriceRateItem)
        self.scrollView.addSubview(self.ticketPriceRateItem)
        self.scrollView.addSubview(self.submitButton)
    }
    
    /**
    Called when the "submit report" button is hit
    
    :param: sender The button who calls the selector
    */
    func submitPressed(sender: UIButton) {
        
        var hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.mode = MBProgressHUDMode.Indeterminate
        hud.labelText = "Submitting Report"
        self.view.userInteractionEnabled = false
        
        let dict = compileReport()
        IBANetworking.submitReport(dict, completion: { (succeeded, error) -> Void in
            hud.hide(true)
            if (succeeded) {
                println("Successfully Generated Report")
                hud =  MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                hud.mode = MBProgressHUDMode.Text
                hud.labelText = "Success"
                hud.hide(true, afterDelay: 1.0)

                delay(1.0, { () -> () in
                    if (self.reportType == .Regular) {
                        self.navigationController?.popViewControllerAnimated(true)
                    } else if (self.reportType == .Ding) {
                        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
                    }
                    return
                })

            } else {
                hud =  MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                hud.mode = MBProgressHUDMode.Text
                hud.labelText = "Failed to submit report"
                hud.hide(true, afterDelay: 2.0)
                self.view.userInteractionEnabled = true
            }
        })
    }
    
    /**
    Compiles the report to send to IBANetworking to save the report in the database
    
    :returns: A nicely compiled dictionary of report information (for use with IBANetworking.submitReport)
    */
    func compileReport() -> [String: AnyObject!] {
        let easePercent = self.easeRateItem.currentValue
        let damagePercent = self.damageRateItem.currentValue
        let spotPricePercent = self.spotPriceRateItem.currentValue
        let ticketPricePercent = self.ticketPriceRateItem.currentValue
        let location = CLLocation(latitude: self.currentLocation.latitude, longitude: self.currentLocation.longitude)
        var rt = "regular"
        if (self.reportType == .Ding) {
            rt = "ding"
        }
        
        let dict: [String: AnyObject] = [
            "reportType": rt,
            "easePercent": easePercent,
            "damagePercent": damagePercent,
            "spotPricePercent": spotPricePercent,
            "ticketPricePercent": ticketPricePercent,
            "location": location
        ]
        
        return dict
    }
    
}
