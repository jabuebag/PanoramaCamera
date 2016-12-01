//
//  ViewController.swift
//  PanoramaCamera
//
//  Created by Kris Yang on 2016-12-01.
//  Copyright © 2016 Kris Yang. All rights reserved.
//

import UIKit
import DKCamera

class ViewController: UIViewController {
    
    @IBOutlet weak var showImage: UIImageView!
    
    let camera = DKCamera()
    
    var imageProcessUtil = ImageProcessUtil()

    override func viewDidLoad() {
        super.viewDidLoad()
//        let image = UIImage(named: "haha.jpg")
//        showImage.image = imageProcessUtil.projectImage(image!)
        configureCamera()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startCamera(_ sender: Any) {
        self.present(camera, animated: true, completion: nil)
    }
    
    func configureCamera() {
        camera.didCancel = { () in
            print("didCancel")
            
            self.dismiss(animated: true, completion: nil)
        }
        
        camera.didFinishCapturingImage = {(image: UIImage) in
            print(image.size)
            
            // self.dismiss(animated: true, completion: nil)
        }
    }


}

