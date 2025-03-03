//
//  ViewController.swift
//  researchPurpose
//
//  Created by Suitmedia on 02/03/25.
//

import UIKit
import ReadiumShared
import ReadiumStreamer
import ReadiumNavigator
import ReadiumAdapterGCDWebServer
import SVProgressHUD

class ViewController: UIViewController {

    private var navigator: EPUBNavigatorViewController?

    lazy var httpClient: HTTPClient = DefaultHTTPClient()
    lazy var httpServer: HTTPServer = GCDHTTPServer(assetRetriever: assetRetriever)
    lazy var assetRetriever = AssetRetriever(
            httpClient: httpClient
        )
    lazy var publicationOpener = PublicationOpener(
            parser: DefaultPublicationParser(
                httpClient: httpClient,
                assetRetriever: assetRetriever,
                pdfFactory: DefaultPDFDocumentFactory()
            ),
            contentProtections: []
        )
    override func viewDidLoad()  {
        super.viewDidLoad()
        view.backgroundColor = .white
        let buttonCoba = UIButton(type: .system)
        buttonCoba.setTitle("Tap Me", for: .normal)
        buttonCoba.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
                
        buttonCoba.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(buttonCoba)
                
                NSLayoutConstraint.activate([
                    buttonCoba.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    buttonCoba.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                    buttonCoba.widthAnchor.constraint(equalToConstant: 120),
                    buttonCoba.heightAnchor.constraint(equalToConstant: 50)
                ])
    }
    
    @objc func buttonTapped() {
        downloadAndOpenEPUB()
    }
    
    func downloadAndOpenEPUB() {
        let urlepub = HTTPURL(string: "https://ypph-cms.suitdev.com/storage/Cecil_si_Ikal.epub")
        Task {
            await MainActor.run {
                SVProgressHUD.show()
            }
            
            do {
                let asset = try await assetRetriever.retrieve(url: urlepub!).get()
                let publication = try await publicationOpener.open(asset: asset, allowUserInteraction: true).get()
                
                await MainActor.run {
                    SVProgressHUD.dismiss()
                    
                    do {
                        let navigator = try EPUBNavigatorViewController(
                            publication: publication,
                            initialLocation: nil,
                            httpServer: self.httpServer
                        )
                        self.present(navigator, animated: true)
                    } catch {
                        print("Failed to initialize EPUB navigator: \(error)")
                    }
                }
            } catch {
                await MainActor.run {
                    SVProgressHUD.dismiss()
                    print("Failed to retrieve the asset: \(error)")
                }
            }
        }
    }

}

#if DEBUG
extension UIViewController {
    @objc func injected() {
        viewDidLoad()
    }
}
#endif
