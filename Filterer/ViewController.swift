//
//  ViewController.swift
//  Filterer
//
//  Created by Jack on 2015-09-22.
//  Copyright © 2015 UofT. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var filteredImageView: UIImageView!
    @IBOutlet var secondaryMenu: UIView!
    @IBOutlet var bottomMenu: UIView!
    @IBOutlet weak var filtersCollectionView: UICollectionView!
    @IBOutlet var filterButton: UIButton!
    @IBOutlet weak var compareButton: UIButton!
    @IBOutlet weak var originalLabel: UILabel!
    
    let reuseIdentifier = "ImageFilterCell"
    var availableFilters : Array<String> = Array<String>()
    var imagesFiltered : Array<UIImage> = Array<UIImage>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        secondaryMenu.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        secondaryMenu.translatesAutoresizingMaskIntoConstraints = false
        availableFilters.append("increase 50% of brightness")
        availableFilters.append("increase contrast by 2")
        availableFilters.append("gamma 1.5")
        availableFilters.append("middle threshold")
        availableFilters.append("duplicate intensity of red")
        availableFilters.append("invert")
        resetImagesFiltered()
    }

    // MARK: Share
    @IBAction func onShare(sender: AnyObject) {
        let activityController = UIActivityViewController(activityItems: ["Check out our really cool app", imageView.image!], applicationActivities: nil)
        presentViewController(activityController, animated: true, completion: nil)
    }
    
    // MARK: New Photo
    @IBAction func onNewPhoto(sender: AnyObject) {
        let actionSheet = UIAlertController(title: "New Photo", message: nil, preferredStyle: .ActionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .Default, handler: { action in
            self.showCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Album", style: .Default, handler: { action in
            self.showAlbum()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func showCamera() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .Camera
        
        presentViewController(cameraPicker, animated: true, completion: nil)
    }
    
    func showAlbum() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .PhotoLibrary
        
        presentViewController(cameraPicker, animated: true, completion: nil)
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imageView.image = image
            self.hideFilteredImageView()
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Filter Menu
    @IBAction func onFilter(sender: UIButton) {
        if (sender.selected) {
            hideSecondaryMenu()
            sender.selected = false
        } else {
            showSecondaryMenu()
            sender.selected = true
        }
    }
    
    func hideFilteredImageView() {
        UIView.animateWithDuration(0.4, animations: {
            self.filteredImageView.alpha = 0
            }) { completed in
                if completed == true {
                    self.originalLabel.hidden = false;
                    self.filteredImageView.hidden = true
                }
        }
    }
    
    func showFilteredImageView() {
        self.filteredImageView.alpha = 0
        self.filteredImageView.hidden = false
        UIView.animateWithDuration(0.4) {
            self.originalLabel.hidden = true;
            self.filteredImageView.alpha = 1.0
        }
    }
    
    @IBAction func compare(sender: UIButton) {
        if (sender.selected) {
            showFilteredImageView()
            sender.selected = false
        } else {
            hideFilteredImageView()
            sender.selected = true
        }
    }
    @IBAction func onPresImage(sender: UILongPressGestureRecognizer) {
        if (sender.state == UIGestureRecognizerState.Began) {
            hideFilteredImageView()
        } else if (sender.state == UIGestureRecognizerState.Ended) {
            showFilteredImageView()
        }
    }
    
    
    func showSecondaryMenu() {
        self.filtersCollectionView.reloadData()
        view.addSubview(secondaryMenu)
        
        let bottomConstraint = secondaryMenu.bottomAnchor.constraintEqualToAnchor(bottomMenu.topAnchor)
        let leftConstraint = secondaryMenu.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        let rightConstraint = secondaryMenu.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
        
        let heightConstraint = secondaryMenu.heightAnchor.constraintEqualToConstant(128)
        
        NSLayoutConstraint.activateConstraints([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        view.layoutIfNeeded()
        
        self.secondaryMenu.alpha = 0
        UIView.animateWithDuration(0.4) {
            self.secondaryMenu.alpha = 1.0
        }
    }

    func hideSecondaryMenu() {
        UIView.animateWithDuration(0.4, animations: {
            self.secondaryMenu.alpha = 0
            }) { completed in
                if completed == true {
                    self.secondaryMenu.removeFromSuperview()
                }
        }
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.availableFilters.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
        cell.backgroundView = UIImageView(image: self.imagesFiltered[indexPath.row])
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        filteredImageView.image = self.imagesFiltered[indexPath.row];
        filteredImageView.hidden = false;
        filteredImageView.alpha = 1;
        self.compareButton.selected = false
        self.compareButton.hidden = false
    }

    func resetImagesFiltered () {
        self.imagesFiltered.removeAll()
        for counter in 0...self.availableFilters.count - 1 {
            let rgba = RGBAImage(image: imageView.image!)
            if (rgba == nil) {
                continue
            }
            let newImage = ImageProcessor.applyDefaultFilter(name: self.availableFilters[counter], image: rgba!)
            self.imagesFiltered.append(newImage.toUIImage()!)
        }
    }
}


