//
//  UIImage+Extension.swift
//  Delicious
//
//  Created by Think on 15/11/26.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit

extension UIImage {
    class func compressImage(image:UIImage ,toMaxFileSize maxFileSize:NSInteger) -> NSData? {
        var compression:CGFloat = 0.9
        let maxCompression:CGFloat = 0.1
        var imageData = UIImageJPEGRepresentation(image, compression)
        while (imageData!.length > maxFileSize && compression > maxCompression) {
            compression -= 0.1
            imageData = UIImageJPEGRepresentation(image, compression)
        }
        return imageData
    }
    
    class func imageClipToNewImage(image: UIImage, newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(newSize)
        image.drawInRect(CGRect(origin: CGPointZero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /**
    颜色生成图像
    
    - parameter color: 颜色值
    
    - returns: 图像
    */
    class func imageFromColor(color: UIColor) -> UIImage {
        let rect = CGRectMake(0, 0, 1, 1);
        UIGraphicsBeginImageContext(rect.size);
        let context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextFillRect(context, rect);
        let img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return img;
    }
    
    /**
     视图生成图像
     
     - parameter view: 视图对象
     
     - returns: 图像
     */
    class func imageFromView(view: UIView) -> UIImage? {
        var image:UIImage? = nil
        UIGraphicsBeginImageContext(view.bounds.size);
        if let context = UIGraphicsGetCurrentContext() {
            view.layer.renderInContext(context)
            image = UIGraphicsGetImageFromCurrentImageContext();
        }
        UIGraphicsEndImageContext();
        
        return image
    }
    
    func shrinkImage(scaleSize: CGFloat) -> UIImage {
        let size = CGSizeMake(self.size.width * scaleSize, self.size.height * scaleSize)
        UIGraphicsBeginImageContext(size);
        self.drawInRect(CGRectMake(0, 0, size.width, size.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return scaledImage;
    }
    
    func fixOrientation() -> UIImage {
        if (self.imageOrientation == .Up) {
            return self
        }
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.drawInRect(CGRectMake(0,0,self.size.width,self.size.height))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return normalizedImage;
        
//        // No-op if the orientation is already correct
//        if (self.imageOrientation == .Up) {
//            return self
//        }
//    
//        // We need to calculate the proper transformation to make the image upright.
//        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
//        var transform = CGAffineTransformIdentity;
//        
//        switch (self.imageOrientation) {
//        case .Down, .DownMirrored:
//            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
//            transform = CGAffineTransformRotate(transform, CGFloat(M_PI));
//        
//        case .Left, .LeftMirrored:
//            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
//            transform = CGAffineTransformRotate(transform, CGFloat(M_PI_2));
//        
//        case .Right, .RightMirrored:
//            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
//            transform = CGAffineTransformRotate(transform, CGFloat(-M_PI_2));
//        case .Up, .UpMirrored:
//            break;
//        }
//        
//        switch (self.imageOrientation) {
//        case .UpMirrored, .DownMirrored:
//            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
//            transform = CGAffineTransformScale(transform, -1, 1);
//        
//        case .LeftMirrored, .RightMirrored:
//            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
//            transform = CGAffineTransformScale(transform, -1, 1);
//        
//        case .Up, .Down, .Left, .Right:
//            break;
//        }
//    
//        // Now we draw the underlying CGImage into a new context, applying the transform
//        // calculated above.
//        let ctx = CGBitmapContextCreate(nil, Int(self.size.width), Int(self.size.height)
//            , CGImageGetBitsPerComponent(self.CGImage), 0
//            , CGImageGetColorSpace(self.CGImage)
//            , CGImageGetBitmapInfo(self.CGImage).rawValue);
//        
//        CGContextConcatCTM(ctx, transform);
//        
//        switch (self.imageOrientation) {
//        case .Left, .LeftMirrored, .Right, .RightMirrored:
//            // Grr...
//            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
//        default:
//            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
//        }
//        
//        // And now we just create a new UIImage from the drawing context
//        if let cgimg = CGBitmapContextCreateImage(ctx) {
//            let img = UIImage(CGImage: cgimg)
//            return img
//        } else {
//            return self
//        }
    }
    
}
