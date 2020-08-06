
# ETHZ_KALIBR Docker container

This is a setup docker container of the [ethz_asl_kalibr](https://github.com/ethz-asl/kalibr) calibration repository.

## Instllation

Clone the repository and build the docker environment.

```bash
git clone https://github.com/Chris-Bee/docker_kalibr.git
cd docker_kalibr
docker build --network=host -t kalibr:latest .
```

## Usage

### Run the container

Run the container in the folder in which your calibration bags are located, as the contents of `./` get mapped to the container.

```bash
docker run -it --rm --net=host -v "$(pwd)":/kalibr/data kalibr:latest
```

If you want to have visual output (and use the kalibr `--show-extraction`) command, you also have to map the display accordingly.

```bash
docker run -it --rm --net=host --env="DISPLAY" --volume="$HOME/.Xauthority:/root/.Xauthority:rw" -v "$(pwd)":/kalibr/data kalibr:latest
```

### Kalibr Tools

Please refer to the [Kalibr Wiki](https://github.com/ethz-asl/kalibr/wiki) for detailed usage of kalibr.

#### Aprilgrid generation

An aprilgrid for printouts can be created with the following command

```sh
kalibr_create_target_pdf --type apriltag --nx 5 --ny 7 --tsize 0.025 --tspace 0.4
```

#### Intrinsics

The intrinsics can be calibrated using the following command. The `--show-extraction` can be used if the docker display has been mapped correclty (see [running the container](#run-the-container)).


```bash
kalibr_calibrate_cameras --topics /camera/image_raw --models <model> --target ./target.yaml  --bag ./<bagname>.bag # --show-extraction
```

**Please make sure that the bag is in the folder the container was started. Otherwise it will not be found inside the container!**

The most common models for `<model>` are:
- `pinhole-fov`
- `omni-radtan`

#### Extrinsics

Similar the intrinsics can be calibrated using the following command. The `--show-extraction` can be used if the docker display has been mapped correclty (see [running the container](#run-the-container)).

```sh
kalibr_calibrate_imu_camera --target target.yaml --cam camchain.yaml --imu imu_model.yaml --bag extrinsics.bag --show-extraction
```
