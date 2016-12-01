//
//  ImageProcessUtil.swift
//  PanoramaCamera
//
//  Created by Kris Yang on 2016-12-01.
//  Copyright © 2016 Kris Yang. All rights reserved.
//

//
//  JabueUtil.swift
//  PanoDemo
//
//  Created by Kris Yang on 2016-11-23.
//  Copyright © 2016 Kris Yang. All rights reserved.
//

import UIKit

class ImageProcessUtil {
    
    fileprivate func panoramaBitmapContext(_ pixelsHigh: Int) -> CGContext? {
        let pixelsWide = pixelsHigh * 6
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        // create the bitmap context
        let bitmapContext = CGContext(data: nil, width: pixelsWide, height: pixelsHigh, bitsPerComponent: 8,
                                      bytesPerRow: 0, space: colorSpace,
                                      // this will give us an optimal BGRA format for the device:
            bitmapInfo: CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue)
        
        return bitmapContext
    }
    
    func projectImage(_ fromImage: UIImage) -> UIImage? {
        
        let increment = fromImage.size.height/60
        var vector = CGFloat(0.0)
        
        // create a bitmap graphics context the size of the image
        let mainViewContentContext = panoramaBitmapContext(Int(fromImage.size.height))
        print("Start")
        for i in 0...359 {
            vector = vector + increment
            mainViewContentContext?.draw(fromImage.cgImage!, in: CGRect(x: vector, y: 0.0, width: fromImage.size.width, height: fromImage.size.width))
        }
        print("Done")
        //mainViewContentContext?.draw(fromImage.cgImage!, in: CGRect(x: 0.0, y: 0.0, width: fromImage.size.width, height: fromImage.size.width))
        // mainViewContentContext?.draw(fromImage.cgImage!, in: CGRect(x: 300.0, y: 0.0, width: fromImage.size.width, height: fromImage.size.width))
        
        // create CGImageRef of the main view bitmap content, and then release that bitmap context
        let reflectionImage = mainViewContentContext?.makeImage()
        
        // convert the finished reflection image to a UIImage
        let theImage = UIImage(cgImage: reflectionImage!)
        
        return theImage
    }
}

