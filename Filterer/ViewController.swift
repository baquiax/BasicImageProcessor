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
    @IBOutlet var sliderView: UIView!
    @IBOutlet var bottomMenu: UIView!
    @IBOutlet weak var filtersCollectionView: UICollectionView!
    @IBOutlet var filterButton: UIButton!
    @IBOutlet weak var compareButton: UIButton!
    @IBOutlet weak var originalLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var initLabelSlider: UILabel!
    @IBOutlet weak var endLabelSlider: UILabel!
    @IBOutlet weak var sliderValue: UILabel!
    
    var currentFilterIndex : Int = 0
    let reuseIdentifier = "ImageFilterCell"
    var availableFilters : Array<Filter> = Array<Filter>()
    var imagesFiltered : Array<UIImage> = Array<UIImage>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        secondaryMenu.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        secondaryMenu.translatesAutoresizingMaskIntoConstraints = false
        sliderView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        sliderView.translatesAutoresizingMaskIntoConstraints = false
        
        availableFilters.append(Brightness(increaseFactor: 0.5))
        availableFilters.append(Contrast(factor: 2))
        availableFilters.append(Gamma(gamma: 1.5))
        availableFilters.append(Threshold (minimumLevel: 127))
        availableFilters.append(IncreaseIntensity(increaseFactor: 1, color: Colors.Red))
        availableFilters.append(Invert())
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
            resetImagesFiltered()
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Filter Menu
    @IBAction func onFilter(sender: UIButton) {
        hideSliderMenu()
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
    
    func showSliderMenu() {
        view.addSubview(sliderView)
        
        let bottomConstraint = sliderView.bottomAnchor.constraintEqualToAnchor(bottomMenu.topAnchor)
        let leftConstraint = sliderView.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        let rightConstraint = sliderView.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
        
        let heightConstraint = sliderView.heightAnchor.constraintEqualToConstant(128)
        
        NSLayoutConstraint.activateConstraints([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        view.layoutIfNeeded()
        
        self.sliderView.alpha = 0
        UIView.animateWithDuration(0.4) {
            self.sliderView.alpha = 1.0
        }
    }
    
    func hideSliderMenu() {
        UIView.animateWithDuration(0.4, animations: {
            self.sliderView.alpha = 0
            }) { completed in
                if completed == true {
                    self.sliderView.removeFromSuperview()
                    self.editButton.selected = false
                }
        }
    }
    
    @IBAction func onPressEdit(sender: UIButton) {
        hideSecondaryMenu()
        if (sender.selected) {
            hideSliderMenu()
            sender.selected = false
        } else {
            showSliderMenu()
            sender.selected = true
        }
        
        
        
        let currentFilter : Filter = self.availableFilters[currentFilterIndex];
        
        if (currentFilter is Contrast || currentFilter is Gamma) {
            slider.minimumValue = -5
            slider.maximumValue = 5
        } else if (currentFilter is Threshold) {
            slider.minimumValue = -127
            slider.maximumValue = 127
        } else if (currentFilter is Invert) {
            slider.maximumValue = 0
            slider.minimumValue = 0
        } else {
            slider.minimumValue = -1
            slider.maximumValue = 1
        }
        
        slider.value = Float(currentFilter.getIntensity())
        sliderValue.text = String(format:"%.2f", currentFilter.getIntensity())
        initLabelSlider.text = String(slider.minimumValue);
        endLabelSlider.text = String(slider.maximumValue);
        sliderView.layoutIfNeeded()
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
                    self.filterButton.selected = false
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
        self.currentFilterIndex = indexPath.row
        filteredImageView.image = self.imagesFiltered[indexPath.row];
        filteredImageView.hidden = false;
        filteredImageView.alpha = 1;
        self.compareButton.selected = false
        self.compareButton.hidden = false
        self.editButton.hidden = false
    }

    func resetImagesFiltered () {
        self.imagesFiltered.removeAll()
        for counter in 0...self.availableFilters.count - 1 {
            let rgba = RGBAImage(image: imageView.image!)
            if (rgba == nil) {
                continue
            }
            let newImage = ImageProcessor.applyFilter(self.availableFilters[counter], image: rgba!)
            self.imagesFiltered.append(newImage.toUIImage()!)
        }
    }
    
    @IBAction func changingSlider(sender: UISlider) {
        let currentFilter = self.availableFilters[self.currentFilterIndex];
        sender.enabled = false
        currentFilter.changeIntensity(Double(sender.value));

        let rgba = RGBAImage(image: imageView.image!)
        if (rgba == nil) {
            return
        }
        let newImage = ImageProcessor.applyFilter(currentFilter, image:rgba!)
        self.availableFilters[currentFilterIndex] = currentFilter
        self.imagesFiltered[currentFilterIndex] = newImage.toUIImage()!
        self.filtersCollectionView.reloadData()
        filteredImageView.image = newImage.toUIImage()
        sliderValue.text = String(format:"%.2f", currentFilter.getIntensity())
        sender.enabled = true
    }
}


