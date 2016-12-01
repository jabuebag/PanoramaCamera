//
//  ViewController.swift
//  PanoramaCamera
//
//  Created by Kris Yang on 2016-12-01.
//  Copyright © 2016 Kris Yang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var showImage: UIImageView!
    
    var imageProcessUtil = ImageProcessUtil()

    override func viewDidLoad() {
        super.viewDidLoad()
        let image = UIImage(named: "haha.jpg")
        showImage.image = imageProcessUtil.projectImage(image!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

