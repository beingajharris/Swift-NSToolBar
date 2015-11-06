//
//  AppDelegate.swift
//  Swiftbased-NSToolBar
//
//  Created by A.J. Harris on 11/2/15
//  Copyright (c) 2015 Appsnschmidt. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate,NSToolbarDelegate {

    @IBOutlet weak var window: NSWindow!
    var toolbar:NSToolbar!

    var toolbarTabsArray = []
    
    var toolbarTabsIdentifierArray:[String] = []
    
    var currentViewController:NSViewController!

    var currentView = ""
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        self.toolbarTabsArray = toolbarItems()
        println(self.toolbarTabsArray)
        
        for dictionary in toolbarTabsArray{
            toolbarTabsIdentifierArray.append(dictionary["identifier"] as! String)
            
        }
        println(toolbarTabsIdentifierArray)
        toolbar = NSToolbar(identifier:"ScreenNameToolbarIdentifier")
        toolbar.allowsUserCustomization = true
        toolbar.delegate = self
        self.window?.toolbar = toolbar
    }


    
    func toolbar(toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: String, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem?
    {
        var infoDictionary: Dictionary<String, String> = Dictionary<String, String> ()
        
        for dictionary in toolbarTabsArray{
            if (dictionary["identifier"] as! String == itemIdentifier ){
                infoDictionary = dictionary as! Dictionary<String, String>
                break
            }
        }
        
        var iconImage = NSImage(named: infoDictionary["icon"]!)
        
        let toolbarItem = NSToolbarItem(itemIdentifier: itemIdentifier)
        toolbarItem.label = infoDictionary["title"]!
        toolbarItem.image = iconImage
        toolbarItem.target = self
        toolbarItem.action = Selector("viewSelected:")

        return toolbarItem
    }

    func toolbarDefaultItemIdentifiers(toolbar: NSToolbar) -> [AnyObject]
    {
        return self.toolbarTabsIdentifierArray;
    }

    func toolbarAllowedItemIdentifiers(toolbar: NSToolbar) -> [AnyObject]
    {
        return self.toolbarDefaultItemIdentifiers(toolbar)
    }

    func toolbarSelectableItemIdentifiers(toolbar: NSToolbar) -> [AnyObject]
    {
        return self.toolbarDefaultItemIdentifiers(toolbar)
    }

    func toolbarWillAddItem(notification: NSNotification)
    {
        println("toolbarWillAddItem")
    }

    func toolbarDidRemoveItem(notification: NSNotification)
    {
        println("toolbarDidRemoveItem")
        
    }

    @IBAction func viewSelected(sender: NSToolbarItem){
        println("view is selected")
        loadViewWithIdentifier(sender.itemIdentifier, withAnimation: true)
    }
    
    func loadViewWithIdentifier(viewTabIdentifier: String, withAnimation shouldAnimate:Bool){
        println("loadViewWithIdentifier")
        println(viewTabIdentifier)
        if (currentView == viewTabIdentifier){
            return
        }
        currentView = viewTabIdentifier
        
        var infoDictionary: Dictionary<String, String> = Dictionary<String, String> ()
        
        for dictionary in toolbarTabsArray{
            if (dictionary["identifier"] as! String == viewTabIdentifier ){
                infoDictionary = dictionary as! Dictionary<String, String>
                break
            }
        }
        
        var className = infoDictionary["class"]!
        println(className)

        if (className == "DepartmentViewController"){
            currentViewController =  DepartmentViewController(nibName: "DepartmentView", bundle: nil)
        }
        
        else if (className == "AccountViewController"){
            currentViewController = AccountViewController(nibName: "AccountView", bundle: nil)
        }
        else if (className == "EmployeeViewController"){
            currentViewController = EmployeeViewController(nibName: "EmployeeView", bundle: nil)
        }
        
        println(currentViewController)
        let newView = currentViewController.view
        
        var windowRect = self.window?.frame
        var currentViewRect = newView.frame
        
        println(windowRect)
        
        
        window?.contentView = newView
        
        var yPos = windowRect!.origin.y + (windowRect!.size.height - currentViewRect.size.height)
        
        let newFrame = NSMakeRect(windowRect!.origin.x, yPos, currentViewRect.size.width, currentViewRect.size.height)
        
        window?.setFrame(newFrame, display: true, animate: true)
    }

    func toolbarItems() -> NSArray{
        var toolbarItemsArray =
        [
            ["title":"Find Departments","icon":"NSPreferencesGeneral","class":"DepartmentViewController","identifier":"DepartmentViewController"],
            ["title":"Find Accounts","icon":"NSFontPanel","class":"AccountViewController","identifier":"AccountViewController"],
            ["title":"Find Employees","icon":"NSAdvanced","class":"EmployeeViewController","identifier":"EmployeeViewController"]];
        return toolbarItemsArray;
        
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

}

