//
//  ScanListingViewController.swift
//  OBD2Scanner
//
//  Created by IPS on 27/07/20.
//  Copyright © 2020 iPS. All rights reserved.
//

import UIKit
import Foundation
import CoreBluetooth
import LTSupportAutomotive

class ScanListingViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var transporter: LTBTLESerialTransporter? = nil
    var obd2Adapter: LTOBD2Adapter? = nil
    
    var serviceUUID: [CBUUID]? = nil
    var pidsData: [AnyObject]? = nil
    var monitors: [LTOBD2MonitorResult]? = nil
    //  var dtcs: [LTOBD2DTC]? = nil
    var dtcsData: [LTOBD2DTC]? = nil
    var monitoringData:[LTOBD2MonitorResult]? = nil
    var dtcsFlg: Int = 0 //1 for scan vehicle 2 for Scan DTC and 3 for Monitoring based on it listing will be change
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableview: UITableView!
    
    
    
    
    var strTitle:String = ""
    let _statusPID: LTOBD2PID_MONITOR_STATUS_SINCE_DTC_CLEARED_01? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.text = strTitle
        self.connect()
        
        self.tableview.estimatedRowHeight = 100.0
        self.tableview.rowHeight = UITableView.automaticDimension
        
    }
    
    @IBAction func btnBackClicked(sender: UIButton){
        self.navigationController?.popViewController(animated: true)
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
        /*
        for i in 0..<8 {
            ma.append(LTOBD2PID_OXYGEN_SENSORS_INFO_2.pid(forSensor: UInt(i), mode: 1))
        }
        */
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
        /*
        for i in 0..<8 {
            ma.append(LTOBD2PID_OXYGEN_SENSORS_INFO_3.pid(forSensor: UInt(i), mode: 1))
        }*/
        
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
        pidsData = ma
        //  print(ma)
        print(pidsData ?? "")
        transporter = LTBTLESerialTransporter(identifier: nil, serviceUUIDs: serviceUUID!)
        transporter?.connect({ inputStream, outputStream in
            if inputStream == nil {
                ShowToast.show(toatMessage: "Could not connect to OBD2 adapter")
                return
            }
            self.obd2Adapter = LTOBD2AdapterELM327.init(inputStream: inputStream!, outputStream: outputStream!)
            self.obd2Adapter?.connect()
        })
        transporter?.startUpdatingSignalStrength(withInterval: 1.0)
        if dtcsFlg == 1{
            self.tableview.reloadData()
        }else if dtcsFlg == 2{
            self.dtcConnection()
        }else{
            self.monitoringDataConnection()
        }
        
    }
   
    func monitoringDataConnection(){
        for i in 0..<10 {
            let ffDTCPid = LTOBD2PID_DTC_CAUSING_FREEZE_FRAME_02.pid(forFreezeFrame: UInt(i))
            obd2Adapter?.transmitCommand(ffDTCPid, responseHandler: { command in
                print("FREEZE FRAME DTC", i, ffDTCPid.formattedResponse)
            })
        }
        let pid = LTOBD2PID_MONITOR_STATUS_SINCE_DTC_CLEARED_01.forMode1()
        obd2Adapter?.transmitCommand(pid, responseHandler: { command in
            self.monitors = pid.monitorResults
            self.monitoringData = pid.monitorResults
            DispatchQueue.main.async(execute: {
                self.tableview.reloadData()
            })
        })
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
            self.dtcsData = dtcPid.troubleCodes
            DispatchQueue.main.async(execute: {
                print(self.dtcsData ?? "")
                self.tableview.reloadData()
            })
        })
        print(self.dtcsData ?? "")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if dtcsFlg == 1{
            return pidsData!.count
        }else if dtcsFlg == 2{
            return dtcsData!.count
        }else{
            return monitors!.count
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"scanListCell", for: indexPath) as! scanListCell
        cell.selectionStyle = .none
        if dtcsFlg == 1{
            if let ids = pidsData{
                if let modelObject = ids[indexPath.row] as? LTOBD2PID{
                    cell.lblTitle?.text = "\(modelObject.purpose)"
//                    cell.lblDetail.text =  "\(modelObject.formattedResponse)"
                    cell.lblDetail.text = "\(modelObject.accessibilityValue ?? "\(modelObject.formattedResponse)")"
                    
                    print("LTOBD2PID \(modelObject.purpose) Index \(ids.firstIndex{$0 === modelObject} ?? 0) \(indexPath.row) )")
                     do{
                        /*
                        let obj = Int.random(in: 0...5)
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(obj)) {
                            modelObject.accessibilityValue = "LTOBD2PID \(indexPath.row) \(modelObject.formattedResponse) \(Date())"
                            tableView.beginUpdates()
                            tableView.reloadRows(at: [indexPath], with: .none)
                            tableView.endUpdates()
                        }*/
                        obd2Adapter?.transmitCommand(modelObject as LTOBD2PID, responseHandler: { command in
                            DispatchQueue.main.async(execute: {
                                tableView.beginUpdates()
                                tableView.reloadRows(at: [indexPath], with: .none)
                                tableView.endUpdates()
                            })
                        })
                     }
                    /*
                    DispatchQueue.main.asyncAfter(deadline: .now()+5.0) {
                        modelObject.accessibilityValue = "LTOBD2PID \(modelObject.formattedResponse)"
                          cell.lblDetail.text =  "LTOBD2PID \(modelObject.formattedResponse)"
                        tableView.reloadRows(at: [indexPath], with: .automatic)
                    }*/
                    
                }else if let modelObject = ids[indexPath.row] as? LTOBD2Command{
                    cell.lblTitle?.text = "\(modelObject.purpose)"
//                    cell.lblDetail.text =  "\(modelObject.formattedResponse)"
                    cell.lblDetail.text = "\(modelObject.accessibilityValue ?? "\(modelObject.formattedResponse)")"

                    print(" LTOBD2Command \(modelObject.purpose) Index \(ids.firstIndex{$0 === modelObject} ?? 0) \(indexPath.row)")
                    do{
                        /*
                        let obj = Int.random(in: 0...5)
                        print()
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(obj) ) {
                            modelObject.accessibilityValue = "LTOBD2Command \(indexPath.row) \(modelObject.formattedResponse) \(Date()) "
                            tableView.beginUpdates()
                            tableView.reloadRows(at: [indexPath], with: .none)
                            tableView.endUpdates()
                        }*/
                        obd2Adapter?.transmitCommand(modelObject as LTOBD2Command, responseHandler: { command in
                            DispatchQueue.main.async {
                                tableView.beginUpdates()
                                tableView.reloadRows(at: [indexPath], with: .none)
                                tableView.endUpdates()
                            }
                        })
                    }
                    /*
                    DispatchQueue.main.asyncAfter(deadline: .now()+5.0) {
                         modelObject.accessibilityValue = "LTOBD2Command \(modelObject.formattedResponse)"
                          //cell.lblDetail.text =  "LTOBD2Command \(modelObject.formattedResponse)"
                        tableView.reloadRows(at: [indexPath], with: .automatic)
                    }*/
                    
                }else{
                    print("indexPath  \(indexPath.row)")
                }
            }
                 /*
            let obj = pidsData?[indexPath.row] as? LTOBD2Command{
                do{
                    obd2Adapter?.transmitCommand(modelObject as LTOBD2PID, responseHandler: { command in
                        DispatchQueue.main.async(execute: {
                            
                            tableView.reloadData()
//                            cell.lblDetail?.text = modelObject.formattedResponse
                        })
                    })
                }
            }
       
            if let modelObject = pidsData?[indexPath.row] as? LTOBD2Command{
                cell.lblTitle?.text = "\(modelObject.purpose)"
                cell.lblDetail.text = "\(modelObject.formattedResponse)"
                print("Index \(pidsData?.firstIndex{$0 === modelObject}) \(indexPath.row)")
                do{
                    obd2Adapter?.transmitCommand(modelObject as LTOBD2Command, responseHandler: { command in
                        DispatchQueue.main.async(execute: {
//                            cell.lblDetail?.text = modelObject.formattedResponse
                            tableView.reloadData()
                        })
                    })
                }
            } */
             return cell
        }else if dtcsFlg == 2{
            if dtcsData != nil{
                let modelObject = dtcsData?[indexPath.row] as? LTOBD2DTC
                cell.lblTitle?.text = modelObject?.code
                cell.lblDetail?.text = modelObject?.formattedEcu
            }
             return cell
        }else{
            if !(monitors != nil){
                let modelObject = monitors?[indexPath.row]
                cell.lblTitle?.text = "TEST " + (modelObject?.formattedName ?? "")
                cell.lblDetail?.text = modelObject?.formattedResult
            }
             return cell
        }
       
    }
}

class scanListCell: UITableViewCell {
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblDetail:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

