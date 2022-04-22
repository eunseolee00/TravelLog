//
//  PhotoAddViewController.swift
//  travel-log
//
//  Created by Eunseo Lee and Karen Ren on 2022/4/21.
//

import UIKit

class PhotoAddViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var itemImageView: UIImageView!
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
    }//viewDidLoad
    
    
    @IBAction func addTapped(_ sender: Any) {
        if let context =
            (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                let item = LogObject(entity: LogObject.entity(), insertInto: context)
                item.title = titleTextField.text
                if let image = itemImageView.image {
                    if let imageData = image.pngData() {
                        item.image = imageData
                    }
                }
                try? context.save()
                navigationController?.popViewController(animated: true)
            }
    }//addTapped()
    
    
    @IBAction func photosTapped(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let choosenImage =  info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            itemImageView.image = choosenImage
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }//func ImagePickerController
    

}//PhotoAddViewController
