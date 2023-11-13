import AVFoundation
import UIKit

class QRScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, ScannerDelegate {
    
    // Reference to DormViewController
    var dormViewController = DormViewController()
    var selectedBatch: String?
    // Closure to handle scanned code
    var didScanCode: ((String) -> Void)?

    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize the capture session
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            // Include both QR code and barcode types
            metadataOutput.metadataObjectTypes = [.qr, .ean8, .ean13, .pdf417, .upce, .code39, .code93, .code128, .aztec, .interleaved2of5, .itf14, .dataMatrix]
        } else {
            failed()
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)

        // Start the capture session on a background thread
        DispatchQueue.global(qos: .background).async {
            self.captureSession.startRunning()
        }
    }

    func failed() {
        // Handle failure scenarios
        print("Failed to initialize the camera")
    }

    // Implement the delegate method to handle the scanned QR code or barcode
    // Implement the delegate method to handle the scanned QR code or barcode
    // Implement the delegate method to handle the scanned QR code or barcode
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let metadataObject = metadataObjects.first else {
            // If no metadata objects are found, do nothing
            return
        }

        guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
        guard let stringValue = readableObject.stringValue else { return }
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))

        // Process the scanned QR code or barcode value (stringValue)
        print("Scanned Code: \(stringValue)")
        didScanCode(stringValue)

        // Stop the capture session after processing the first code
        captureSession.stopRunning()

        // Delay the presentation of DormViewController to ensure captureSession is fully stopped
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            //dormVC.abhyasiID = "hello"
            //dormVC.selectedBatch = "not sure"
            self?.performSegue(withIdentifier: "ScannerToDorm", sender: self)
            //self!.present(dormVC, animated: true, completion: nil)
        }
    }
    
    // This method is called just before the segue is performed
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ScannerToDorm" {
            // Check if the destination view controller is DormViewController
            if let dormViewController = segue.destination as? DormViewController {
                // Pass the scanned code to DormViewController
                dormViewController.abhyasiID = self.dormViewController.abhyasiID
                dormViewController.selectedBatch = selectedBatch
            }
        }
    }
    
    // Implement the delegate method to pass the scanned code to DormViewController
    func didScanCode(_ code: String) {
        // Handle the scanned code as needed
        dormViewController.abhyasiID = code
    }
}
