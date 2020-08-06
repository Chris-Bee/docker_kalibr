
# Build the Docker file
```sh
docker build --network=host -t kalibr:latest .
```


# Run the container
~~~sh
docker run -it --rm --net=host -v "$(pwd)":/kalibr/data kalibr:latest
docker run -it --rm --net=host --env="DISPLAY" --volume="$HOME/.Xauthority:/root/.Xauthority:rw" -v "$(pwd)":/kalibr/data kalibr:latest
~~~


## Aprilgrid generation

```sh
kalibr_create_target_pdf --type apriltag --nx 5 --ny 7 --tsize 0.025 --tspace 0.4
```

## Intrinsics

```sh
kalibr_calibrate_cameras --topics /camera/image_raw --models omni-radtan --target ./target.yaml --show-extraction --bag ./intrinsic.bag 
```

```sh
kalibr_calibrate_cameras --topics /camera/image_raw --models pinhole-radtan --target ./target.yaml --show-extraction --bag ./intrinsic.bag 
```

## Extrinsics

```sh
kalibr_calibrate_imu_camera --target target.yaml --cam camchain.yaml --imu imu_model.yaml --bag extrinsics.bag --show-extraction
```

