//
//  LinkPreviewVC.swift
//  Demo
//
//  Created by iMac on 01/09/22.
//

import UIKit
import LinkPresentation

class LinkPreviewVC: UIViewController {
    
    @IBOutlet weak var mainView: UIView!
    
    let urlString = "https://github.com/apploft/ExpandableLabel/tree/master/ExpandableLabelDemo/ExpandableLabelDemo"

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchPreview()
    }
    
    func fetchPreview(){
        guard let url = URL(string: urlString) else {
            return
        }
        let linkView = LPLinkView()
        let provider = LPMetadataProvider()
        provider.startFetchingMetadata(for: url) { [weak self] metaData, error in
            guard let data = metaData, error == nil else {
                return
            }
            print(data.title)
            print(data.debugDescription)
            print(data.originalURL)
            print(data.url)
            print(data.imageProvider?.description)
            
            data.imageProvider?.loadFileRepresentation(forTypeIdentifier: "public.png", completionHandler: { url, error in
                print(url)
                print(error)
            })
            
            DispatchQueue.main.async {
                linkView.metadata = data
                self?.mainView.addSubview(linkView)
                self?.view.addSubview(linkView)
                linkView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
//                linkView.center = self?.view.center ?? .zero
            }
        }
        
    }

}
