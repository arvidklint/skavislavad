//
//  BearViewController.swift
//  skavislavad
//
//  Created by Arvid Sätterkvist on 20/03/16.
//  Copyright © 2016 arvidsat. All rights reserved.
//

import UIKit

class BearViewController:
    UIViewController,
    UITextFieldDelegate,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate
{
    
    // MARK: Properties
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveBearButton: UIBarButtonItem!
    
    var bear: Bear?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Handle the text field’s user input through delegate callbacks.
        nameTextField.delegate = self
        
        // Set up views if editing an existing Meal.
        if let bear = bear {
            navigationItem.title = bear.name
            nameTextField.text   = bear.name
            photoImageView.image = bear.photo
            ratingControl.rating = bear.rating
        }
        
        // Enable the Save button only if the text field has a valid Meal name.
        checkValidBearName()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkValidBearName()
        navigationItem.title = textField.text
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // Disable the Save button while editing.
        saveBearButton.enabled = false
    }
    
    func checkValidBearName() {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        saveBearButton.enabled = !text.isEmpty
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // The info dictionary contains multiple representations of the image, and this uses the original.
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        
        // Dismiss the picker.
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Navigation
    @IBAction func cancelNewBear(sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddBearMode = presentingViewController is UINavigationController
        
        if isPresentingInAddBearMode {
            dismissViewControllerAnimated(true, completion: nil)
        }
        else {
            navigationController!.popViewControllerAnimated(true)
        }
    }
    
    // This method lets you configure a view controller before it's presented.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveBearButton === sender {
            let name = nameTextField.text ?? ""
            let photo = photoImageView.image
            let rating = ratingControl.rating
            bear = Bear(name: name, photo: photo, rating: rating)
        }
    }
    

    // MARK: Actions
    @IBAction func selectImageFromPhotoLibrary(sender: UITapGestureRecognizer) {
        // Hide the keyboard.
        nameTextField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .PhotoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
}

