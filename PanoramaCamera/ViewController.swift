//
//  ViewController.swift
//  PanoramaCamera
//
//  Created by Kris Yang on 2016-12-01.
//  Copyright © 2016 Kris Yang. All rights reserved.
//

import UIKit
import DKCamera
import ImageViewer
import CoreMotion

extension UIImageView: DisplaceableView {}

class ViewController: UIViewController, GalleryItemsDatasource, GalleryDisplacedViewsDatasource {
    
    @IBOutlet weak var showImage: UIImageView!
    @IBOutlet weak var angleLbl: UILabel!
    
    var vectorMove: CGFloat?
    var incrementMove: CGFloat?
    
    let camera = DKCamera()
    var motionManager = CMMotionManager()
    
    var imageProcessUtil = ImageProcessUtil()
    
    let internalVector:Double = 1.0
    var picNumber: Int = 0
    var yawTemp : Double?
    var rotatedAngle: Double = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        var imageTapGesture = UITapGestureRecognizer(target: self, action: "imageTapAction")
        showImage.addGestureRecognizer(imageTapGesture)
        vectorMove = CGFloat(0.0)
        configureCamera()
        motionManager.deviceMotionUpdateInterval = 1/20
        self.motionManager.startDeviceMotionUpdates(to: OperationQueue.current!, withHandler: {motion,error in self.calculateRotationByGyro(motion: motion!)})
    }
    
    func calculateRotationByGyro(motion:CMDeviceMotion){
        let qx = motion.attitude.quaternion.x
        let qy = motion.attitude.quaternion.y
        let qz = motion.attitude.quaternion.z
        let qw = motion.attitude.quaternion.w
        // motion.attitude.
        var pitch = atan2(2*(qx*qw + qy*qz), 1 - 2*qx*qx - 2*qz*qz) * 180 / M_PI
        var roll = atan2(2*(qy*qw + qx*qz), 1 - 2*qy*qy - 2*qz*qz) * 180 / M_PI
        let yaw = asin(2*qx*qy + 2*qz*qw) * 180 / M_PI
        var rotateDirection = motion.rotationRate.y*180 / M_PI
        if (rotatedAngle >= 360) {
            self.motionManager.stopDeviceMotionUpdates()
        }
        if yawTemp == nil {
            yawTemp = yaw
            rotatedAngle += abs(yawTemp!)
        }
        if rotateDirection < 0 {
            var oneTimeAngle = abs(yaw - yawTemp!)
            rotatedAngle += oneTimeAngle
            if oneTimeAngle >= internalVector {
                picNumber += 1
            }
        }
        else {
            if rotateDirection > 30 {
                self.motionManager.stopDeviceMotionUpdates()
                print("Please restart")
            } else {
                print("please rotate to right")
            }
            
        }
        yawTemp = yaw
        angleLbl.text = String(yaw)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startCamera(_ sender: Any) {
        self.present(camera, animated: true, completion: nil)
        // camera.takePicture()
    }
    
    func imageTapAction() {
        let frame = CGRect(x: 0, y: 0, width: 200, height: 24)
        // let footerView = CounterView(frame: frame)
        let galleryViewController = GalleryViewController(startIndex: 0, itemsDatasource: self, displacedViewsDatasource: self, configuration: galleryConfiguration())
        // galleryViewController.footerView = footerView
        //        galleryViewController.launchedCompletion = { print("LAUNCHED") }
        //        galleryViewController.closedCompletion = { print("CLOSED") }
        //        galleryViewController.swipedToDismissCompletion = { print("SWIPE-DISMISSED") }
        self.presentImageGallery(galleryViewController)
    }
    
    func configureCamera() {
        camera.didCancel = { () in
            self.showImage.image = self.imageProcessUtil.generateImage()
            self.dismiss(animated: true, completion: nil)
        }
        
        camera.didFinishCapturingImage = {(image: UIImage) in
            var newImage = self.imageProcessUtil.resizeImageWithFixedRatio(image: image, newWidth: 800)
            if self.incrementMove == nil {
                self.incrementMove = newImage.size.height/60
            }
            self.vectorMove = self.vectorMove! + self.incrementMove!
            self.imageProcessUtil.projectImage(newImage, vector: self.vectorMove!)
            print(newImage.size)
            
        }
    }

    func itemCount() -> Int {
        
        return 1
    }
    
    func provideDisplacementItem(atIndex index: Int) -> DisplaceableView? {
        
        return showImage
    }
    
    func provideGalleryItem(_ index: Int) -> GalleryItem {
        let image = showImage.image ?? UIImage(named: "0")!
        
        return GalleryItem.image { $0(image) }
    }
    
    func galleryConfiguration() -> GalleryConfiguration {
        
        return [
            
            GalleryConfigurationItem.pagingMode(.standard),
            GalleryConfigurationItem.presentationStyle(.displacement),
            GalleryConfigurationItem.hideDecorationViewsOnLaunch(false),
            
            // GalleryConfigurationItem.swipeToDismissHorizontally(false),
            // GalleryConfigurationItem.toggleDecorationViewsBySingleTap(false),
            
            GalleryConfigurationItem.overlayColor(UIColor(white: 0.035, alpha: 1)),
            GalleryConfigurationItem.overlayColorOpacity(1),
            GalleryConfigurationItem.overlayBlurOpacity(1),
            GalleryConfigurationItem.overlayBlurStyle(UIBlurEffectStyle.light),
            
            GalleryConfigurationItem.maximumZoolScale(8),
            GalleryConfigurationItem.swipeToDismissThresholdVelocity(500),
            
            GalleryConfigurationItem.doubleTapToZoomDuration(0.15),
            
            GalleryConfigurationItem.blurPresentDuration(0.5),
            GalleryConfigurationItem.blurPresentDelay(0),
            GalleryConfigurationItem.colorPresentDuration(0.25),
            GalleryConfigurationItem.colorPresentDelay(0),
            
            GalleryConfigurationItem.blurDismissDuration(0.1),
            GalleryConfigurationItem.blurDismissDelay(0.4),
            GalleryConfigurationItem.colorDismissDuration(0.45),
            GalleryConfigurationItem.colorDismissDelay(0),
            
            GalleryConfigurationItem.itemFadeDuration(0.3),
            GalleryConfigurationItem.decorationViewsFadeDuration(0.15),
            GalleryConfigurationItem.rotationDuration(0.15),
            
            GalleryConfigurationItem.displacementDuration(0.55),
            GalleryConfigurationItem.reverseDisplacementDuration(0.25),
            GalleryConfigurationItem.displacementTransitionStyle(.springBounce(0.7)),
            GalleryConfigurationItem.displacementTimingCurve(.linear),
            
            GalleryConfigurationItem.statusBarHidden(true),
            GalleryConfigurationItem.displacementKeepOriginalInPlace(false),
            GalleryConfigurationItem.displacementInsetMargin(50)
        ]
    }
}

