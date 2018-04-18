//
//  imageManager.swift
//  FunnyRectangles
//
//  Created by Alex Voronov on 17.04.18.
//  Copyright © 2018 Alex Voronov. All rights reserved.
//

import UIKit

class ImageManager {
    
    init() {}
    
    // MARK: Properties
    weak var delegate: DesktopBackgroundImageDelegate?
    //var arrIndexes: [Int] = []
    var arrIndexes: [Int] = [2, 0, 1]
    var currentIndex = 1
    
    let backgroungImages: [String] = [
        "background1",
        "background2",
        "background3",
        "background4",
        "background5" ]
    
    //MARK: Internal
    
    func changeBackground(firstTime: Bool) {
        // TODO: correct logic
        var firstTimePatch = firstTime
        firstTimePatch = true
        //guard arrIndexes.count > 1 else { return }
        // TODO: now works unsafe. Only if all names in arr are correct
        if firstTimePatch {
            
            let name = getRandomNameBackground()
            
            if checkImageExistence(name: name) {
                
                setBackgroundImage(with: name)
                return
                
            } else {
                
                var nextName = getNextNameBackgroundAfter(index: arrIndexes[currentIndex])
                
                while (self.currentIndex < backgroungImages.count - 1) && !checkImageExistence(name: nextName) {
                    self.currentIndex += 1
                    nextName = getNextNameBackgroundAfter(index: self.currentIndex)
                }
                
                if self.currentIndex < backgroungImages.count {
                    setBackgroundImage(with: nextName)
                    return
                }
                
                // if came here it ment there were no images with names from array
            }
            
        } else {
//            // TODO: DRY!  and correct logic
//            var nextName = getNextNameBackgroundAfter(index: arrIndexes[currentIndex])
//            
//            while (self.currentIndex < backgroungImages.count - 1) && !checkImageExistence(name: nextName) {
//                self.currentIndex += 1
//                nextName = getNextNameBackgroundAfter(index: self.currentIndex)
//            }
//            
//            if self.currentIndex < backgroungImages.count {
//                setBackgroundImage(with: nextName)
//                return
//            }
//            
//            // if came here it ment there were no images with names from array
        }
    }
}

// MARK: Private
private extension ImageManager {
    
    @discardableResult func getRandomNameBackground() -> String {
    
        guard !backgroungImages.isEmpty else { return "guard: arr names is empty!" }
        
        let randomIndex = Int(arc4random_uniform(UInt32(backgroungImages.count)))
        
//        let imageExists = checkImageExistence(name: backgroungImages[randomIndex])
//        
//        
//        if imageExists && randomIndex != self.currentIndex {
//            
//            self.currentIndex = randomIndex
//            
//            return backgroungImages[randomIndex]
//        
//        } else {
//            //randomIndex = Int(arc4random_uniform(UInt32(backgroungImages.count)))
//            getRandomNameBackground()
//        }
//        
        
//        for i in 0...backgroungImages.count - 1 {
//            arrIndexes.append(i)
//        }
        
        //print(arrIndexes)
        //print(randomIndex)
        
//        for element in arrIndexes {
//            while element != randomIndex {
//                let first = arrIndexes.removeFirst()
//                arrIndexes.append(first)
//            }
//        }
//        print(arrIndexes)
        
        return backgroungImages[randomIndex]
    }
    
    func getNextNameBackgroundAfter(index: Int) -> String {
        
        return ""
    }
    
    func checkImageExistence(name: String) -> Bool {
        if (UIImage(named: name) != nil) {
            //print("Image exists")
            setBackgroundImage(with: name)
            
            return true
        }
        else {
            print("Image does not exist")
            return false
        }
    }
    
    func setBackgroundImage(with name: String) {
        guard let desktop = delegate else { return }
        
        desktop.setBackgroundImage(imageName: name)
    }
}
