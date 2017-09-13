//
//  ViewController.swift
//  ARKit4-任意门
//
//  Created by 刘文 on 2017/9/10.
//  Copyright © 2017年 刘文. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // 设置追踪方向
//        configuration.planeDetection = .horizontal
        // 自适应灯光（相机从暗到强光快速过渡效果会平缓一些）
        configuration.isLightEstimationEnabled = true

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first else {
//            return
//        }
//        let touchLocation = touch.location(in: sceneView)
//        let results = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
//        guard let hitResult = results.first else {
//            return
//        }
        
        guard let cameraTransform = sceneView.session.currentFrame?.camera.transform else {
            return
        }
        
//        var translate = matrix_identity_float4x4
//        translate.columns.3.x = -0.5
//        translate.columns.2.y = -1
//
//        let transform = matrix_multiply(cameraTransform, translate)
        
        let boxScene = SCNScene(named: "art.scnassets/portal.scn")!
        
        if let boxNode = boxScene.rootNode.childNode(withName: "portal", recursively: true) {
            
//            boxNode.position = SCNVector3(x: hitResult.worldTransform.columns.3.x, y: hitResult.worldTransform.columns.3.y + 0.05, z: hitResult.worldTransform.columns.3.z)
            
//            boxNode.simdTransform = simdTransform // 变形了
            
//            boxNode.position = SCNVector3Make(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
            
            boxNode.position = SCNVector3Make(cameraTransform.columns.3.x, cameraTransform.columns.3.y - 1, cameraTransform.columns.3.z - 1)
            
            sceneView.scene.rootNode.addChildNode(boxNode)
        }
    }

    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        if anchor is ARPlaneAnchor {
            let planeAnchor = anchor as! ARPlaneAnchor
            
            planeAnchor.center
            
            let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x) * 0.3, height: CGFloat(planeAnchor.extent.z) * 0.3)
            let planeNode = SCNNode()
            planeNode.position = SCNVector3(x: planeAnchor.center.x, y: 0, z: planeAnchor.center.z)
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
            let gridMaterial = SCNMaterial()
            gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
            plane.materials = [gridMaterial]
            planeNode.geometry = plane
            node.addChildNode(planeNode)
        }
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
