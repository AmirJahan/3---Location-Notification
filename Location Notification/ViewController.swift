import UIKit
import UserNotifications
import CoreLocation

class ViewController: UIViewController, UNUserNotificationCenterDelegate, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    var region : CLCircularRegion!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUserPermission();
        
        

        locationManager.delegate = self
        
        
        // must
        locationManager.requestWhenInUseAuthorization()

        // Simple repeatable way
        let notCenter = CLLocationCoordinate2D(latitude: 49, longitude: -123)
        let notRegion = CLCircularRegion(center: notCenter, radius: 2000.0, identifier: "lhl")
        notRegion.notifyOnEntry = true
        notRegion.notifyOnExit = false
        let trigger = UNLocationNotificationTrigger(region: notRegion, repeats: false)
        showNotification(inpTrigger: trigger)
        
        
        
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = 50;
        let center = CLLocationCoordinate2D(latitude: 49,
                                            longitude: -123)
        region = CLCircularRegion(center: center,
                                  radius: 1000.0,
                                  identifier: "lhl")

        locationManager.startMonitoring(for: region)
        
        if !CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            print("Can't use this for monitorinh")
        }
        locationManager.startUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        print(locations)
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("failed to monitor")
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print("began monitoring for \(region)")
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didEnterRegion region: CLRegion) {
        print("Geofence Entered")
        let trigger = UNLocationNotificationTrigger(region: region,
                                      repeats: false)
        showNotification(inpTrigger: trigger)
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didExitRegion region: CLRegion) {
        print("Geofence Exited")
    }
    
    func showNotification (inpTrigger: UNLocationNotificationTrigger) {
        let locationTrigger = inpTrigger
        
        let locationContent = UNMutableNotificationContent()
        locationContent.title = "Location Based Event"
        locationContent.body = "This should happen within LHL!"
        locationContent.sound = UNNotificationSound.default()
        
        // Creating notification request
        let request = UNNotificationRequest(identifier: "myId",
                                            content: locationContent,
                                            trigger: locationTrigger)
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().add(request) {(error) in
            if let error = error {
                print("error with request: \(error)")
            }
        }
    }
    
    func getUserPermission()
    {
        // grant access by user to receve notifications
        UNUserNotificationCenter
            .current()
            .requestAuthorization(options: [.alert, .sound])
            {
                (accepted, error) in
                var alert : UIAlertController;
                
                if !accepted
                {
                    alert = UIAlertController(title: "Denied",
                                              message: "Notification access denied.",
                                              preferredStyle: UIAlertControllerStyle.alert);
                }
                else
                {
                    alert = UIAlertController(title: "Granted",
                                              message: "Notification access granted.",
                                              preferredStyle: UIAlertControllerStyle.alert);
                }
                alert.addAction(UIAlertAction(title: "Ok",
                                              style: UIAlertActionStyle.default,
                                              handler: nil))
                
                self.present(alert, animated: true, completion: nil)
        }
    }
}
