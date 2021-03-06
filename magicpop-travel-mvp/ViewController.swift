//
//  ViewController.swift
//  magicpop-travel-mvp
//
//  Created by kikuchi wataru on 2018/04/02.
//  Copyright © 2018年 kikuchi wataru. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {
    
    @IBOutlet var sceneView: ARSCNView!
    var Button: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
        
        let screenWidth:CGFloat = self.view.frame.width
        let screenHeight:CGFloat = self.view.frame.height
        
        Button = UIButton(type: .custom)
        Button?.setTitle("Tap me!", for:UIControlState.normal)
        Button?.frame = CGRect(x:screenWidth/4, y:screenHeight/2,width:screenWidth/2, height:50)
        Button?.translatesAutoresizingMaskIntoConstraints = false
        Button?.layer.cornerRadius = 10.0
        Button?.addTarget(self, action: #selector(self.photoButtonTapped(_:)), for: .touchUpInside)
        
        self.view.addSubview(Button!)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    @IBAction func photoButtonTapped(_ sender: Any) {
        showUIImagePicker()
    }
    
    private func showUIImagePicker() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let pickerView = UIImagePickerController()
            pickerView.sourceType = .photoLibrary
            pickerView.delegate = self
            pickerView.modalPresentationStyle = .overFullScreen
            self.present(pickerView, animated: true, completion: nil)
        }
    }
    
    private func setImageToScene(image: UIImage) {
        if let camera = sceneView.pointOfView {
            let position = SCNVector3(x: 0, y: 0, z: -0.5) // 偏差のベクトルを生成する
            let convertPosition = camera.convertPosition(position, to: nil)
            let node = createPhotoNode(image, position: convertPosition)
            self.sceneView.scene.rootNode.addChildNode(node)
        }
    }
    
    private func createPhotoNode(_ image: UIImage, position: SCNVector3) -> SCNNode {
        let node = SCNNode()
        let scale: CGFloat = 0.3
        let geometry = SCNBox(width: image.size.width * scale / image.size.height,
                              height: scale,
                              length: 0.00000001,
                              chamferRadius: 0.0)
        geometry.firstMaterial?.diffuse.contents = image
        node.geometry = geometry
        node.position = position
        return node
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            setImageToScene(image: image)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
