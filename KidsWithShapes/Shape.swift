//
//  Shape.swift
//  KidsWithShapes
//
//  Created by Graisorn Soisakhoo on 11/24/2558 BE.
//  Copyright © 2558 Graisorn Soisakhoo. All rights reserved.
//

import UIKit

protocol ShapeDelegate{
    func didSelectedShape( sender: Shape )
}

enum ShapeType {
    case Normal, ThreeDimensions, Colorful, Random
}

enum ShapeColor{
    case Red, Green, Blue, Pink, Orange
}


class Shape : NSObject {
    
    var name:String!
    var type:ShapeType!
    
    init( name: String, type: ShapeType! ) {
        self.name = name
        self.type = type
    }
}

extension CollectionType {
    /// Return a copy of `self` with its elements shuffled
    func shuffle() -> [Generator.Element] {
        var list = Array(self)
        list.shuffleInPlace()
        return list
    }
}

extension MutableCollectionType where Index == Int {
    /// Shuffle the elements of `self` in-place.
    mutating func shuffleInPlace() {
        // empty and single-element collections don't shuffle
        if count < 2 { return }
        
        for i in 0..<count - 1 {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
    }
}
