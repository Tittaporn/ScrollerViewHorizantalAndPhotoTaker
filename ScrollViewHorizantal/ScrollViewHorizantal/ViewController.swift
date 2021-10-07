//
//  ViewController.swift
//  ScrollViewHorizantal
//
//  Created by M3ts LLC on 10/7/21.
//

import UIKit

class ViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var imageViewPhotoTaken: UIImageView!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnTakePhoto: UIButton!
    @IBOutlet weak var btnPhoto: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var horizontalScroll: UIStackView!
    
    // MARK: - Properties
    let imagePicker = UIImagePickerController()
    let lableText = ["Photo 1","Photo 2","Photo 3","Photo 4","Photo 5"]
    var contenWidth: CGFloat = 0.0
    var index = 0
    var currentTakenPhoto = -1
    let image1: UIImage = {
        let image = UIImage(systemName: "1.circle")
        return image ?? UIImage()
    }()
    let image2: UIImage = {
        let image = UIImage(systemName: "2.circle")
        return image ?? UIImage()
    }()
    let image3: UIImage = {
        let image = UIImage(systemName: "3.circle")
        return image ?? UIImage()
    }()
    let image4: UIImage = {
        let image = UIImage(systemName: "4.circle")
        return image ?? UIImage()
    }()
    let image5: UIImage = {
        let image = UIImage(systemName: "5.circle")
        return image ?? UIImage()
    }()
    var imagesToDisplay: [UIImage] = []
    var photosToDisplay: [UIImage] = []
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        setupViews()
        imagesToDisplay = [image1,image2,image3,image4,image5]
        for image in imagesToDisplay {
            if let photoView = Bundle.main.loadNibNamed("PhotosView", owner: nil, options: nil)!.first as? PhotoView {
                photoView.translatesAutoresizingMaskIntoConstraints = false
                photoView.widthAnchor.constraint(equalToConstant: view.frame.width/2).isActive = true
                photoView.lbl.text = lableText[index]
                let anImageToDisplay = image
                photoView.img.image = anImageToDisplay
                if photosToDisplay.count == 1 {
                    photoView.img.image = photosToDisplay[0]
                }
                photoView.delegate = self
                horizontalScroll.backgroundColor = .red
                horizontalScroll.addArrangedSubview(photoView)
                contenWidth += photoView.frame.width + 100
                index += 1
            }
        }
        scrollView.contentSize = CGSize(width: contenWidth, height: view.frame.height)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Actions
    @IBAction func photoButtonTapped(_ sender: Any) {
        print("I am about to taking photo.")
        openCamera()
    }
    
    @IBAction func takePhotoButtonTapped(_ sender: Any) {
        print("I am about to taking photo.")
        openCamera()
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        currentTakenPhoto += 1
        updatePhotoViews(currentIndex: currentTakenPhoto)
    }
    
    // MARK: - Helper Functions
    func setupViews() {
        scrollView.anchor(top: view.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 50, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: view.frame.width, height: view.frame.height / 5)
        horizontalScroll.anchor(top: scrollView.topAnchor, bottom: scrollView.bottomAnchor, leading: scrollView.leadingAnchor, trailing: scrollView.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0,height: scrollView.frame.height)
        index = 0
    }
    
    func updatePhotoViews(currentIndex: Int) {
        if currentIndex < 5 {
            let photoToHide = horizontalScroll.arrangedSubviews[currentIndex]
            horizontalScroll.removeArrangedSubview(photoToHide)
            if let newPhotoView = Bundle.main.loadNibNamed("PhotosView", owner: nil, options: nil)!.first as? PhotoView {
                newPhotoView.translatesAutoresizingMaskIntoConstraints = false
                newPhotoView.widthAnchor.constraint(equalToConstant: view.frame.width/2).isActive = true
                newPhotoView.lbl.text = lableText[currentIndex]
                newPhotoView.img.image = imageViewPhotoTaken.image//photosToDisplay[currentIndex]
                newPhotoView.delegate = self
                
                horizontalScroll.insertArrangedSubview(newPhotoView, at: currentIndex)
            }
        } else {
            print("Index out of range, we took all photos that needed")
        }
    }
}

// MARK: -  UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func openCamera() {
        // we check if camera is source, then present imagePicker.
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        } else { //Camera Source is not available.
            let alert = UIAlertController(title: "No camera access", message: "Plese allow access to the Camera to use this feature", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            imageViewPhotoTaken.image = pickedImage
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}


// MARK: - Delegate
extension ViewController: PhotoViewDelegate {
    func updatePhotoData(image: UIImageView, text: String) {
        print("I am tapping the photo")
        imageViewPhotoTaken.image = image.image
        print(text)
    }
}

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?, bottom: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, trailing: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingBottom: CGFloat, paddingLeft: CGFloat, paddingRight: CGFloat, width: CGFloat? = nil, height: CGFloat? = nil) {
        self.translatesAutoresizingMaskIntoConstraints = false
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: paddingLeft).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom).isActive = true
        }
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: paddingRight).isActive = true
        }
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}

extension UIStackView {
    func removeFully(view: UIView) {
        removeArrangedSubview(view)
        view.removeFromSuperview()
    }
    
    func removeFullyAllArrangedSubviews() {
        arrangedSubviews.forEach { (view) in
            removeFully(view: view)
        }
    }
}
