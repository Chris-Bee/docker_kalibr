[![Docker Image CI](https://github.com/Chris-Bee/docker_kalibr/actions/workflows/docker-image.yml/badge.svg)](https://github.com/Chris-Bee/docker_kalibr/actions/workflows/docker-image.yml)

# Kalibr Docker container

This is a setup docker container of the [ethz_asl_kalibr](https://github.com/ethz-asl/kalibr) calibration repository.

## Building the Container

Clone the repository and build the docker environment.

```bash
git clone https://github.com/Chris-Bee/docker_kalibr.git
cd docker_kalibr
docker build --network=host -t kalibr:latest .
```

## Pulling a Pre-Build Docker Image

A pre-build docker image of this dockerfile can be found [here](https://hub.docker.com/r/christianbrommer/kalibr), and you can pull it by running `docker pull christianbrommer/kalibr`.
If you do pull the image, then the name for running the image changes from `kalibr:latest` to `christianbrommer/kalibr:latest`.

## Usage

### Run the container

Run the container in the folder in which your calibration bags are located, as the contents of `./` get mapped to the container.

```bash
docker run -it --rm --net=host -v "$(pwd)":/kalibr/data kalibr:latest
```

If you want to have visual output (and use the kalibr `--show-extraction` command), you also have to map the display accordingly.

```bash
docker run -it --rm --net=host --env="DISPLAY" --volume="$HOME/.Xauthority:/root/.Xauthority:rw" -v "$(pwd)":/kalibr/data kalibr:latest
```

### Kalibr Tools

Please refer to the [Kalibr Wiki](https://github.com/ethz-asl/kalibr/wiki) for detailed usage of kalibr.

#### Aprilgrid generation

An aprilgrid for printouts can be created with the following command

```bash
#Apriltag DIN A4
kalibr_create_target_pdf --type apriltag --nx 5 --ny 7 --tsize 0.025 --tspace 0.4
#Apriltag DIN A3
kalibr_create_target_pdf --type apriltag --nx 5 --ny 7 --tsize 0.035 --tspace 0.5
#Checkerboard DIN A3
kalibr_create_target_pdf --type checkerboard --nx 5 --ny 7 --csx 0.035 --csy 0.035
```

#### Intrinsics

The intrinsics can be calibrated using the following command. The `--show-extraction` can be used if the docker display has been mapped correctly (see [running the container](#run-the-container)).


```bash
kalibr_calibrate_cameras --topics /camera/image_raw --models <model> --target ./target.yaml  --bag ./<bagname>.bag # --show-extraction

kalibr_calibrate_cameras --topics /camera1/image_raw /camera1/image_raw --models <model1> <model1> --target ./target.yaml  --bag ./<bagname>.bag # --show-extraction
```

**Please make sure that the bag is in the folder the container was started. Otherwise it will not be found inside the container!**

The most common models for `<model>` are:
- `pinhole-fov`
- `omni-radtan`

#### Extrinsics

Similar the intrinsics can be calibrated using the following command. The `--show-extraction` can be used if the docker display has been mapped correclty (see [running the container](#run-the-container)).

```bash
kalibr_calibrate_imu_camera --target target.yaml --cam camchain.yaml --imu imu_model.yaml --bag ./extrinsics.bag # --show-extraction
```

---

## License (MIT)

Copyright (c) 2020 Christian Brommer

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
