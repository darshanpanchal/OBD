//
//  ViewController.swift
//  OBD2Scanner
//
//  Created by IPS on 23/07/20.
//  Copyright © 2020 iPS. All rights reserved.
//

import UIKit
import CoreBluetooth
import LTSupportAutomotive

class ViewController: UIViewController,CBCentralManagerDelegate {
    
    var transporter: LTBTLESerialTransporter? = nil
    var obd2Adapter: LTOBD2Adapter? = nil
    
    var serviceUUIDs: [CBUUID]? = nil
    //    var pids: [LTOBD2PID]? = nil
  
    var monitors: [LTOBD2MonitorResult]? = nil
    //    var dtcs: [LTOBD2DTC]? = nil
    
    var pids: [AnyObject]? = nil
    var dtcs: [LTOBD2DTC]? = nil
    
    @IBOutlet weak var btnconnect: UIButton!
    @IBOutlet weak var btnScanVehicle: UIButton!
    @IBOutlet weak var btnScanDTC: UIButton!
    @IBOutlet weak var btnMonitoring: UIButton!
    @IBOutlet weak var rpmLbl: UILabel!
    @IBOutlet weak var speefLbl: UILabel!
    @IBOutlet weak var tempLbl: UILabel!
    
    @IBOutlet weak var lblOBDStatus:UILabel!
    
    let _statusPID: LTOBD2PID_MONITOR_STATUS_SINCE_DTC_CLEARED_01? = nil
    
    var peripherals:[CBPeripheral] = []
    var manager: CBCentralManager? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Bluetooth Manager Configuration
        self.bluetoothConfigurationAndUpdate()
        //manager = CBCentralManager(delegate: self, queue: nil)
        
        //setUp Screen User interface
        self.setUpUserInterface()
        
        //Configure NavigationView
        self.configureNavigationView()
       
        
        //add Observer for device change
        NotificationCenter.default.addObserver(self, selector: #selector(onAdapterChangedState(_:)), name: NSNotification.Name(rawValue: LTOBD2AdapterDidUpdateState), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onTransporterDidUpdateSignalStrength(_:)), name: NSNotification.Name(rawValue: LTBTLESerialTransporterDidUpdateSignalStrength), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onAdapterDidSendBytes(_:)), name: NSNotification.Name(rawValue: LTOBD2AdapterDidSend), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onAdapterDidReceiveBytes(_:)), name: NSNotification.Name(rawValue: LTOBD2AdapterDidReceive), object: nil)

        let rain = #" "test" "#
        print(rain)
        
        
        let rollNumber = 5
        
        if rollNumber.isMultiple(of: 2){
            print("even")
        }else{
            print("odd")
        }
        
        let scores = [100,80,85]
       
        let number = [1,2,3,4,5]
        let doubled = number.map { $0 * 2}
       
        let numberString = number.map { String($0) }
        let numberInt = numberString.map { Int($0) ?? 0 }
        let numberFloat = numberString.map { Float($0) ?? 0.0 }
        print(numberFloat)
        print(numberInt)
        print(numberString)
        print(doubled)
        
        
        let wizards = ["Harry", "Hermione", "Ron"]
        let upperCase = wizards.map { $0.uppercased()}
        print(upperCase)
        let objMap = wizards.map { Int($0)}
        let objCompact = wizards.compactMap { Int($0)}
        print(objMap)
        print(objCompact)
        
        
        
        
        
    }
    //Bluetooth Connection Configuration
    func bluetoothConfigurationAndUpdate(){
        manager = CBCentralManager.init(delegate: self, queue: nil)
    }
    //setup User interface of screen
    func setUpUserInterface(){
        self.btnconnect.layer.masksToBounds = true
        self.btnconnect.layer.cornerRadius = 10

        self.btnScanVehicle.roundedCornorRadius()
        
        //self.btnScanVehicle.layer.masksToBounds = true
        //self.btnScanVehicle.layer.cornerRadius = self.btnScanVehicle.frame.height/2

        self.btnScanDTC.layer.masksToBounds = true
        self.btnScanDTC.layer.cornerRadius = self.btnScanDTC.frame.height/2

        self.btnMonitoring.layer.masksToBounds = true
        self.btnMonitoring.layer.cornerRadius = self.btnMonitoring.frame.height/2
    }
    //Configure Navigation View Controller
    func configureNavigationView(){
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor.init(hex: "#18365B",alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        //18365B
    }
    
    
    func scanBLEDevice(){
        manager?.scanForPeripherals(withServices: nil, options: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 60.0) {
            self.stopScanForBLEDevice()
        }
    }
    
    func stopScanForBLEDevice(){
        manager?.stopScan()
        print("scan stopped")
    }

    //CBCentralMaganerDelegate code
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if (!peripherals.contains(peripheral)){
            peripherals.append(peripheral)
            }
         print(peripherals)
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
               case .unknown:
                   print("unknown")
               case .resetting:
                   print("resetting")
               case .unsupported:
                   print("unsupported")
               case .unauthorized:
                   print("unauthorized")
               case .poweredOff:
                   print("poweredOff")
                   manager?.stopScan()
               case .poweredOn:
                   print("poweredOn")
                   manager?.scanForPeripherals(withServices: nil, options: nil)
          default:
            print("default")
        }
    }
   
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        // pass reference to connected peripheral to parentview
        print("Connected to "+peripheral.name!)
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print(error!)
    }
    func connect(){
        var ma = [
            LTOBD2CommandELM327_IDENTIFY.command(),
            LTOBD2CommandELM327_IGNITION_STATUS.command(),
            LTOBD2CommandELM327_READ_VOLTAGE.command(),
            LTOBD2CommandELM327_DESCRIBE_PROTOCOL.command(),
            
            LTOBD2PID_VIN_CODE_0902(),
            LTOBD2PID_FUEL_SYSTEM_STATUS_03.forMode1(),
            LTOBD2PID_OBD_STANDARDS_1C.forMode1(),
            LTOBD2PID_FUEL_TYPE_51.forMode1(),
            
            LTOBD2PID_ENGINE_LOAD_04.forMode1(),
            LTOBD2PID_COOLANT_TEMP_05.forMode1(),
            LTOBD2PID_SHORT_TERM_FUEL_TRIM_1_06.forMode1(),
            LTOBD2PID_LONG_TERM_FUEL_TRIM_1_07.forMode1(),
            LTOBD2PID_SHORT_TERM_FUEL_TRIM_2_08.forMode1(),
            LTOBD2PID_LONG_TERM_FUEL_TRIM_2_09.forMode1(),
            LTOBD2PID_FUEL_PRESSURE_0A.forMode1(),
            LTOBD2PID_INTAKE_MAP_0B.forMode1(),
            
            LTOBD2PID_ENGINE_RPM_0C.forMode1(),
            LTOBD2PID_VEHICLE_SPEED_0D.forMode1(),
            LTOBD2PID_TIMING_ADVANCE_0E.forMode1(),
            LTOBD2PID_INTAKE_TEMP_0F.forMode1(),
            LTOBD2PID_MAF_FLOW_10.forMode1(),
            LTOBD2PID_THROTTLE_11.forMode1(),
            
            LTOBD2PID_SECONDARY_AIR_STATUS_12.forMode1(),
            LTOBD2PID_OXYGEN_SENSORS_PRESENT_2_BANKS_13.forMode1()
        ]
        for i in 0..<8 {
            ma.append(LTOBD2PID_OXYGEN_SENSORS_INFO_1.pid(forSensor: UInt(i), mode: 1))
        }
        
        ma.append(contentsOf: [
            LTOBD2PID_OXYGEN_SENSORS_PRESENT_4_BANKS_1D.forMode1(),
            LTOBD2PID_AUX_INPUT_1E.forMode1(),
            LTOBD2PID_RUNTIME_1F.forMode1(),
            LTOBD2PID_DISTANCE_WITH_MIL_21.forMode1(),
            LTOBD2PID_FUEL_RAIL_PRESSURE_22.forMode1(),
            LTOBD2PID_FUEL_RAIL_GAUGE_PRESSURE_23.forMode1()
        ])
        
        for i in 0..<8 {
            ma.append(LTOBD2PID_OXYGEN_SENSORS_INFO_2.pid(forSensor: UInt(i), mode: 1))
        }
        
        ma.append(contentsOf: [
            LTOBD2PID_COMMANDED_EGR_2C.forMode1(),
            LTOBD2PID_EGR_ERROR_2D.forMode1(),
            LTOBD2PID_COMMANDED_EVAPORATIVE_PURGE_2E.forMode1(),
            LTOBD2PID_FUEL_TANK_LEVEL_2F.forMode1(),
            LTOBD2PID_WARMUPS_SINCE_DTC_CLEARED_30.forMode1(),
            LTOBD2PID_DISTANCE_SINCE_DTC_CLEARED_31.forMode1(),
            LTOBD2PID_EVAP_SYS_VAPOR_PRESSURE_32.forMode1(),
            LTOBD2PID_ABSOLUTE_BAROMETRIC_PRESSURE_33.forMode1()
        ])
        
        for i in 0..<8 {
            ma.append(LTOBD2PID_OXYGEN_SENSORS_INFO_3.pid(forSensor: UInt(i), mode: 1))
        }
        
        ma.append(contentsOf: [
             LTOBD2PID_CATALYST_TEMP_B1S1_3C.forMode1(),
             LTOBD2PID_CATALYST_TEMP_B2S1_3D.forMode1(),
             LTOBD2PID_CATALYST_TEMP_B1S2_3E.forMode1(),
             LTOBD2PID_CATALYST_TEMP_B2S2_3F.forMode1(),
             LTOBD2PID_CONTROL_MODULE_VOLTAGE_42.forMode1(),
             LTOBD2PID_ABSOLUTE_ENGINE_LOAD_43.forMode1(),
             LTOBD2PID_AIR_FUEL_EQUIV_RATIO_44.forMode1(),
             LTOBD2PID_RELATIVE_THROTTLE_POS_45.forMode1(),
             LTOBD2PID_AMBIENT_TEMP_46.forMode1(),
             LTOBD2PID_ABSOLUTE_THROTTLE_POS_B_47.forMode1(),
             LTOBD2PID_ABSOLUTE_THROTTLE_POS_C_48.forMode1(),
             LTOBD2PID_ACC_PEDAL_POS_D_49.forMode1(),
             LTOBD2PID_ACC_PEDAL_POS_E_4A.forMode1(),
             LTOBD2PID_ACC_PEDAL_POS_F_4B.forMode1(),
             LTOBD2PID_COMMANDED_THROTTLE_ACTUATOR_4C.forMode1(),
             LTOBD2PID_TIME_WITH_MIL_4D.forMode1(),
             LTOBD2PID_TIME_SINCE_DTC_CLEARED_4E.forMode1(),
             LTOBD2PID_MAX_VALUE_FUEL_AIR_EQUIVALENCE_RATIO_4F.forMode1(),
             LTOBD2PID_MAX_VALUE_OXYGEN_SENSOR_VOLTAGE_4F.forMode1(),
             LTOBD2PID_MAX_VALUE_OXYGEN_SENSOR_CURRENT_4F.forMode1(),
             LTOBD2PID_MAX_VALUE_INTAKE_MAP_4F.forMode1(),
             LTOBD2PID_MAX_VALUE_MAF_AIR_FLOW_RATE_50.forMode1()
        ])
        pids = ma
        //  print(ma)
        print(pids ?? "")
        transporter = LTBTLESerialTransporter(identifier: nil, serviceUUIDs: serviceUUIDs!)
        transporter?.connect({ inputStream, outputStream in
            if inputStream == nil {
                ShowToast.show(toatMessage: "Could not connect to OBD2 adapter")
                return
            }
            self.obd2Adapter = LTOBD2AdapterELM327.init(inputStream: inputStream!, outputStream: outputStream!)
            self.obd2Adapter?.connect()
        })
        transporter?.startUpdatingSignalStrength(withInterval: 1.0)
        dtcConnection()
        updateSensorData()
        monitoringData()
    }
        
    func disconnect() {
        obd2Adapter?.disconnect()
        transporter?.disconnect()
    }
    
    func dtcConnection(){
        let pid0A = LTOBD2PID_PERMANENT_DTC_0A()
         obd2Adapter?.transmitCommand(pid0A, responseHandler: { command in
            print("PERMANENT DTC = ", pid0A.formattedResponse)
        })
        let pid07 = LTOBD2PID_PENDING_DTC_07()
        obd2Adapter?.transmitCommand(pid07, responseHandler: { command in
          print("PENDING DTC = ", pid07.formattedResponse)
         })
        let dtcPid = LTOBD2PID_STORED_DTC_03()
        obd2Adapter?.transmitCommand(dtcPid, responseHandler: { command in
           print("DTC = ", dtcPid.formattedResponse)
            self.dtcs = dtcPid.troubleCodes
            DispatchQueue.main.async(execute: {
                print(self.dtcs ?? "")
            })
        })
    }
    
    func updateSensorData() {
        let rpm = LTOBD2PID_ENGINE_RPM_0C.forMode1()
        let speed = LTOBD2PID_VEHICLE_SPEED_0D.forMode1()
        let temp = LTOBD2PID_COOLANT_TEMP_05.forMode1()
        obd2Adapter?.transmitMultipleCommands([rpm, speed, temp], responseHandler: { commands in
            DispatchQueue.main.async(execute: {
                self.rpmLbl.text = rpm.formattedResponse
                self.speefLbl.text = speed.formattedResponse
                self.tempLbl.text = temp.formattedResponse
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                    self.updateSensorData()
                })
            })
        })
    }

    func monitoringData(){
        for i in 0..<10 {
            let ffDTCPid = LTOBD2PID_DTC_CAUSING_FREEZE_FRAME_02.pid(forFreezeFrame: UInt(i))
            obd2Adapter?.transmitCommand(ffDTCPid, responseHandler: { command in
               print("FREEZE FRAME %u DTC %@", i, ffDTCPid.formattedResponse)
            })
        }
        let pid = LTOBD2PID_MONITOR_STATUS_SINCE_DTC_CLEARED_01.forMode1()
        obd2Adapter?.transmitCommand(pid, responseHandler: { command in
            self.monitors = pid.monitorResults
            DispatchQueue.main.async(execute: {
            })
        })
    }
    @objc func onAdapterChangedState(_ notification: Notification?) {
        DispatchQueue.main.async {
            if let connectedOBD = self.obd2Adapter{
                self.lblOBDStatus.text = "\(connectedOBD.adapterState)"
            }
        }
    }
    @objc func onAdapterDidSendBytes(_ notification: Notification?){
        
    }
    @objc func onAdapterDidReceiveBytes(_ notification: Notification?){
        
    }
    @objc func onTransporterDidUpdateSignalStrength(_ notification: Notification){
        
    }
    @IBAction func btnConnectClicked(sender: UIButton){
        
        var arrayUUID: [CBUUID]? = []
        (["FFF0", "FFE0", "BEEF", "E7810A71-73AE-499D-8C15-FAA9AEF0C3F2"] as NSArray).enumerateObjects({ uuid, idx, stop in
            arrayUUID?.append(CBUUID(string: uuid as? String ?? ""))
        })
        
        
        
        if let _ = arrayUUID {
            serviceUUIDs = arrayUUID!
        }
        
        if serviceUUIDs!.count > 0{
            self.btnconnect.setTitle("BlueTooth Disconnect", for: .normal)
            self.connect()
            self.updateSensorData()
        }
    }
    
    @IBAction func btnScanVehicleClicked(sender: UIButton){
        
        if pids != nil {
            if let vc:ScanListingViewController = self.storyboard?.instantiateViewController(withIdentifier: "ScanListingViewController") as? ScanListingViewController{
                vc.strTitle = "Scan Vehicle"
             // vc.pidsData = pids
                vc.serviceUUID = serviceUUIDs
                vc.dtcsFlg = 1 //1 for scan vehicle 2 for Scan DTC and 3 for Monitoring
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else{
            ShowToast.show(toatMessage: "Please connect OBD device with Bluetoooth")
        }
    }
    
    @IBAction func btnScanDTCClicked(sender: UIButton){
        if dtcs != nil {
            if let vc:ScanListingViewController = self.storyboard?.instantiateViewController(withIdentifier: "ScanListingViewController") as? ScanListingViewController{
                vc.strTitle = "Scan DTC"
             // vc.dtcsData = dtcs
                vc.serviceUUID = serviceUUIDs
                vc.dtcsFlg = 2 //1 for scan vehicle 2 for Scan DTC and 3 for Monitoring
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else{
            ShowToast.show(toatMessage: "Please connect OBD device with Bluetoooth")
        }
    }
    
    @IBAction func btnMonitoringClicked(sender: UIButton){
       if monitors != nil {
           if let vc:ScanListingViewController = self.storyboard?.instantiateViewController(withIdentifier: "ScanListingViewController") as? ScanListingViewController{
              vc.strTitle = "Monitoring "
              vc.serviceUUID = serviceUUIDs
              vc.dtcsFlg = 3 //1 for scan vehicle 2 for Scan DTC and 3 for Monitoring
             self.navigationController?.pushViewController(vc, animated: true)
          }
       }
    }      
}

extension UIView : RoundProtocol{
    func roundedCornorRadius() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.bounds.height / 2.0
    }
}

/*
class RoundButton: UIButton,RoundProtocol{

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.roundedCornorRadius()
    }
    func roundedCornorRadius() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.bounds.height / 2.0
    }
}
 */
protocol RoundProtocol {
    func roundedCornorRadius()
}
