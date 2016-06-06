//
//  ViewController.swift
//  KidsWithShapes
//
//  Created by Graisorn Soisakhoo on 11/2/2558 BE.
//  Copyright © 2558 Graisorn Soisakhoo. All rights reserved.
//

import UIKit
import GoogleMobileAds

let kwsGreen: UIColor = UIColor(red: 0.416, green: 0.667, blue: 0.000, alpha: 1.00)
let kwsRed: UIColor = UIColor(red: 0.96, green: 0.247, blue: 0.357, alpha: 1.00)
let kwsBlue: UIColor = UIColor(red: 0.000, green: 0.569, blue: 0.812, alpha: 1.00)
let kwsPurple: UIColor = UIColor(red: 0.66, green: 0.4, blue: 0.67, alpha: 1.00)
let kwsOrange: UIColor = UIColor.orangeColor()
let kwsYellow = UIColor(red: 0.98, green: 0.83, blue: 0.16, alpha: 1.0)
let kwsPink = UIColor(red: 0.90, green: 0.247, blue: 0.35, alpha: 1.00)
let kwsWhite: UIColor = UIColor.whiteColor()
let kwsBlack: UIColor = UIColor.blackColor()
let kwsDarkGray: UIColor = UIColor.darkGrayColor()

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, GADBannerViewDelegate  {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var banner: GADBannerView!
    
    var selectedMenu: Int = 0
    
    let colors = [ kwsGreen, kwsRed, kwsBlue, kwsPurple, kwsYellow, kwsOrange ]
    
    let maxShape : UInt32 = 7
    let shapeTypeString = ["normal", "3d", "color"]
    let movements = ["spin", "flip", "upDown", "scale", "shake"]
    var randomShapes = [Shape]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.hidden = true
        
        banner.hidden = true
        banner.delegate = self
        banner.adUnitID = "ca-app-pub-1913643963550195/2942422460"
        banner.rootViewController = self
        banner.adSize = kGADAdSizeLeaderboard
        banner.loadRequest(GADRequest())
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        banner.loadRequest(request)
        
    }
    
    // banner delegate
    func adViewDidReceiveAd(bannerView: GADBannerView!) {
        banner.hidden = false
    }
    
    func adView(bannerView: GADBannerView!, didFailToReceiveAdWithError error: GADRequestError!) {
        banner.hidden = true
    }
    
    func generateObject( sender: UIBarButtonItem, max: Int ){
        randomShapes = []
        switch sender.tag {
        case 1,4:
            getRandomNormalShape(max)
        case 2:
            getRandom3dShape(max)
        case 3:
            getRandomColorShape(max)
        case 5:
            getFullyRandomShape(max)
        default: break
        }
    }
    
    // normal
    func getRandomNormalShape(max: Int){
        for _ in 0..<max{
            let shapeNumber = arc4random_uniform( maxShape )
            let tempShape = Shape(name: "shape_\(shapeNumber.hashValue)_normal", type: .Normal)
            randomShapes += [tempShape]
        }
    }
    
    // 3d shapes
    func getRandom3dShape(max: Int){
        for _ in 0..<max{
            let shapeNumber = arc4random_uniform( maxShape )
            let tempShape = Shape(name: "shape_\(shapeNumber)_3d", type: .ThreeDimensions)
            randomShapes += [tempShape]
        }
    }
    
    // color shapes
    func getRandomColorShape(max: Int){
        for _ in 0..<max{
            let shapeNumber = arc4random_uniform( maxShape )
            let tempShape = Shape(name: "shape_\(shapeNumber)_normal", type: .Colorful)
            randomShapes += [tempShape]
        }
    }
    
    // fully random both 3d and normal shapes
    func getFullyRandomShape(max: Int){
        for _ in 0..<max{
            let shapeNumber = arc4random_uniform( maxShape )
            let shapeTypeNumber = arc4random_uniform( UInt32(shapeTypeString.count) )
            let shapeType = shapeTypeString[ shapeTypeNumber.hashValue ]
            let tempShape = Shape(name: "shape_\(shapeNumber)_\(shapeType)", type: .Random)
            randomShapes += [tempShape]
        }
    }
    
    @IBAction func barButtonTapped(sender: UIBarButtonItem) {
        collectionView.hidden = false
        selectedMenu = sender.tag
        generateObject(sender, max: 15)
        collectionView.reloadData()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return randomShapes.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func getMovementType() -> String{
        var moveType:String!
        let moveNumber = arc4random_uniform( UInt32(movements.count) )
            moveType = movements[ moveNumber.hashValue ]
        return moveType
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let reuseIdentifier = "reusecell"
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! customCell
        
        cell.shape = randomShapes[indexPath.row]
        cell.backgroundColor = kwsWhite
        
        // reset back to normal
        cell.transform = CGAffineTransformIdentity
        
        // movement animation
        if selectedMenu == 4 {
            
            var moveType = getMovementType()
            
            // check if circle and got spin as animation
            if (cell.shape!.name.containsString("2") && moveType == "spin" ){
                moveType = getMovementType()
                // if still got spin just use temp move ment
                if(moveType == "spin"){
                    let tempMovements = ["flip","upDown","scale","shake"]
                    let moveNumber = arc4random_uniform( UInt32(tempMovements.count) )
                    moveType = tempMovements[ moveNumber.hashValue ]
                }
            }
            
            // switch animation
            switch moveType {
                case "spin":
                    let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
                    rotationAnimation.toValue = NSNumber(double: M_PI_2)
                    rotationAnimation.duration = 0.5
                    rotationAnimation.cumulative = true
                    rotationAnimation.repeatCount = Float.infinity
                    cell.layer.addAnimation(rotationAnimation, forKey: "rotationAnimation")
                case "flip":
                    let flipAnimation = CABasicAnimation(keyPath: "transform.rotation.y")
                    flipAnimation.toValue = NSNumber(double: M_PI_2)
                    flipAnimation.duration = 0.2
                    flipAnimation.cumulative = true
                    flipAnimation.repeatCount = Float.infinity
                    cell.layer.addAnimation(flipAnimation, forKey: "flipAnimation")
                case "upDown":
                    let updownAnimation = CABasicAnimation(keyPath: "position")
                    updownAnimation.additive = true
                    updownAnimation.fromValue = NSValue(CGPoint: CGPointZero)
                    updownAnimation.toValue = NSValue(CGPoint: CGPointMake(0.0, -10.0))
                    updownAnimation.duration = 0.5
                    updownAnimation.autoreverses = true
                    updownAnimation.cumulative = true
                    updownAnimation.repeatCount = Float.infinity
                    cell.layer.addAnimation(updownAnimation, forKey: "upDownAnimation")
                case "scale":
                    let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
                    scaleAnimation.additive = true
                    scaleAnimation.fromValue = NSValue(CGPoint: CGPointZero)
                    scaleAnimation.toValue = NSValue(CGPoint: CGPointMake(0.5, 0.5))
                    scaleAnimation.duration = 0.5
                    scaleAnimation.autoreverses = true
                    scaleAnimation.cumulative = true
                    scaleAnimation.repeatCount = Float.infinity
                    cell.layer.addAnimation(scaleAnimation, forKey: "scaleAnimation")
                case "shake":
                    let shakeAnimation = CABasicAnimation(keyPath: "position")
                    shakeAnimation.duration = 0.2
                    shakeAnimation.repeatCount = Float.infinity
                    shakeAnimation.autoreverses = true
                    shakeAnimation.fromValue = NSValue(CGPoint: CGPointMake(cell.center.x - 10, cell.center.y))
                    shakeAnimation.toValue = NSValue(CGPoint: CGPointMake(cell.center.x + 10, cell.center.y))
                    cell.layer.addAnimation(shakeAnimation, forKey: "shakeAnimation")
                default: break
            }
        }
        
        if cell.shape != nil {
            let image = UIImage(named: cell.shape!.name)
            cell.shapeImage.image = image
            
            // if normal shape paint black color to all
            if ( cell.shape!.type == ShapeType.Normal ){
                let tintedImage = image?.imageWithRenderingMode(.AlwaysTemplate)
                cell.shapeImage.image = tintedImage
                cell.shapeImage.tintColor = kwsBlack
            }
            
            // if color shape paint random color
            if ( cell.shape!.type == ShapeType.Colorful ){
                let tintedImage = image?.imageWithRenderingMode(.AlwaysTemplate)
                cell.shapeImage.image = tintedImage
                
                let colorNumber = arc4random_uniform( UInt32(colors.count) )
                let color = colors[ colorNumber.hashValue ]
                cell.shapeImage.tintColor = color
            }
            
            // if fully random mix - color, normal, 3d
            if ( cell.shape!.type == ShapeType.Random ){
                // if color
                if cell.shape!.name.containsString("color") {
                    let tintedImage = image?.imageWithRenderingMode(.AlwaysTemplate)
                    cell.shapeImage.image = tintedImage
                    
                    let colorNumber = arc4random_uniform( UInt32(colors.count) )
                    let color = colors[ colorNumber.hashValue ]
                    cell.shapeImage.tintColor = color
                }
            }
            
            cell.setNeedsLayout()
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("-- \(indexPath.row)")
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 50
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(20, 30, 30, 30)
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

class customCell: UICollectionViewCell{
    
    @IBOutlet weak var shapeImage: UIImageView!
    var shape: Shape?
    
    override func setNeedsLayout() {
        super.setNeedsLayout()
        shapeImage.contentMode = .ScaleAspectFit
    }
}

