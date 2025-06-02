**This is the script doing accelerometer calibration**

The data is collected by putting the IMU's 6 faces align with gravity direction

The output is the 3-by-3 skew matrix **S_est_inv** that calibrating accelerometer axes and a bias **b_est** that accounts for  IMU's bias.

The new collected data should be corrected by:

Acc_corrected = S_est_inv * (Acc_raw - b_est)
