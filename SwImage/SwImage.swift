//
//  SwImage.swift
//  SwImage
//
//  Created by Alex Stein on 4/16/17.
//  Copyright © 2017 Alexander Stein. All rights reserved.
//

import Foundation

class SwImage{
    /**
     Fetch an NSImage from a given path
     */
    class func fetchImageFromPath(_ path : URL) -> NSImage?{
        let outputImage = NSImage(contentsOf: path)
        
        return outputImage
    }
    
    
    /**
     Resize an NSImage
     
     - Parameter image: Image to resize
     - newSize: The new size to resize the image to
     
     - Returns: Copy of the original image with the new dimensions
     */
    class func resizeImage(_ image : NSImage, withDimensions newSize : NSSize) -> NSImage{
        
        //Scale in order to account for screen differences
        let scalingFactor = (NSScreen.main()?.backingScaleFactor)!
        let newSize = NSSize(width: newSize.width.divided(by: scalingFactor),
                             height: newSize.height.divided(by: scalingFactor))
        
        //Generate the new image and resize it
        let newImage = NSImage(size: newSize)
        newImage.lockFocus()
        image.draw(in: NSMakeRect(0, 0, newSize.width, newSize.height), from: NSMakeRect(0, 0, image.size.width, image.size.height), operation: NSCompositingOperation.sourceOver, fraction: CGFloat(1))
        newImage.unlockFocus()
        newImage.size = newSize
        
        return NSImage(data: newImage.tiffRepresentation!)!
    }
    
    /**
     Writes image out to a file. Valid image file extensions are `jpg`/`jpeg`, `png`, `gif`, `tiff`, and `bmp`.
     
     - Parameter image: NSImage to write out to a file.
     - Parameter outputPath: The path and file name to write the image to.
     
     - Returns: `true` if operation was succesful, `false` if otherwise
     */
    class func writeImageToFile(_ image : NSImage, outputPath : URL) -> Bool{
        
        //General a core graphics reference rectangle and load the bitmap data into it
        let cgRef = image.cgImage(forProposedRect: nil, context: nil, hints: nil)!
        let bitmap = NSBitmapImageRep(cgImage: cgRef)
        bitmap.size = image.size
        
        var imageData : Data?
        
        //Check the extension
        switch outputPath.pathExtension.lowercased() {
        case "jpg":
            fallthrough
        case "jpeg":
            imageData = bitmap.representation(using: NSJPEGFileType, properties: [:])
        case "gif":
            imageData = bitmap.representation(using: NSGIFFileType, properties: [:])
        case "png":
            imageData = bitmap.representation(using: NSPNGFileType, properties: [:])
            break
        case "bmp":
            imageData = bitmap.representation(using: NSBMPFileType, properties: [:])
        case "tiff":
            imageData = bitmap.representation(using: NSTIFFFileType, properties: [:])
        default:
            print("Error: Invalid image file extension \"\(outputPath.pathExtension.lowercased())\" used.")
            return false
        }
        
        //Generate an image from the bitmap data
        do{
            try imageData?.write(to: outputPath)
        }catch{
            print("Failed to write image file")
            return false
        }
        return true
    }
}
