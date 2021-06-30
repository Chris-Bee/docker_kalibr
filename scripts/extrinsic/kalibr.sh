#!/bin/bash
kalibr_calibrate_imu_camera --target target_a3.yaml --cam camchain.yaml --imu imu_model_px4.yaml --bag ./data.bag #--bag-from-to 1 100 #--timeoffset-padding 0.1  #--show-extraction
