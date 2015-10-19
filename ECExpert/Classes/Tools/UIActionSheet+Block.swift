//
//  UIActionSheet+Block.swift
//  ECExpert
//
//  Created by Fran on 15/6/13.
//  Copyright (c) 2015年 Fran. All rights reserved.
//

import Foundation

typealias CompleteActionSheetFunc = (buttonIndex: Int) -> Void

class CompleteActionSheetFuncClass: NSObject {
    var completeActionSheetFunc: CompleteActionSheetFunc?
    
    init(completeActionSheetFunc: CompleteActionSheetFunc?){
        self.completeActionSheetFunc = completeActionSheetFunc
    }
    
    func copyWithZone(zone: NSZone) -> AnyObject {
        return CompleteActionSheetFuncClass(completeActionSheetFunc: self.completeActionSheetFunc)
    }
}

extension UIActionSheet: UIActionSheetDelegate {
    
    private static var key = "ActionSheetComplete"
    
    func showActionSheetWithCompleteBlock(inView: UIView, completeActionSheetFunc: CompleteActionSheetFunc!){
        if completeActionSheetFunc != nil{
            objc_removeAssociatedObjects(self)
            objc_setAssociatedObject(self, &UIActionSheet.key, CompleteActionSheetFuncClass(completeActionSheetFunc: completeActionSheetFunc) as AnyObject, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
            self.delegate = self
        }
        self.showInView(inView)
    }
    
    public func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        let completeActionSheetFuncObj: CompleteActionSheetFuncClass? = objc_getAssociatedObject(self, &UIActionSheet.key) as? CompleteActionSheetFuncClass
        
        if completeActionSheetFuncObj != nil && completeActionSheetFuncObj?.completeActionSheetFunc != nil{
            completeActionSheetFuncObj!.completeActionSheetFunc!(buttonIndex: buttonIndex)
        }
    }
}
