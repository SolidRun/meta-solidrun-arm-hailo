
do_install:append() {
    sed -i "s/sensor_i2c_bus = 0/sensor_i2c_bus = 4/g" ${D}/etc/imaging/cfg/imx678/theia_sl410m/4k/profiles/daylight/tuning/Sensor0_Entry.cfg
}
