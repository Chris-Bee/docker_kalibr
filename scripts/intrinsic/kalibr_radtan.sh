#!/bin/bash
kalibr_calibrate_cameras --topics /nav_cam/image_raw --models pinhole-radtan --target ./target_a3.yaml  --bag ./data.bag #--bag-from-to 1 100 #--show-extraction
