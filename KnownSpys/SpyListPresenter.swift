//
//  SpyListPresenter.swift
//  KnownSpys
//
//  Created by Riken Maharjan on 9/8/18.
//  Copyright © 2018 JonBott.com. All rights reserved.
//

import Foundation



typealias BlockWithSource = (Source)->Void
typealias VoidBlock = ()->Void




class SpyListPresenter{
    
    
     var data = [SpyDTO]()
    fileprivate var modelLayer: ModelLayer
    
    init(modelManager: ModelLayer){
        
        self.modelLayer = modelManager
    }
    
    
    
}


//MARK: - Data Methods
extension SpyListPresenter {
    
    func loadData(finished: @escaping BlockWithSource) {
        modelLayer.loadData { [weak self] source, spies in
            self?.data = spies
            finished(source)
        }
    }
}








//MARK: - Translation Methods
extension SpyListPresenter {
    
    
}



