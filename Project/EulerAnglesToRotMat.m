function R = EulerAnglesToRotMat(roll, pitch, yaw)

R11 = cosd(pitch)*cosd(yaw);
R12 = cosd(yaw)*sind(pitch)*sind(roll) - cosd(roll)*sind(yaw);
R13 = cosd(yaw)*cosd(yaw)*sind(pitch) + sind(yaw)*sind(roll);

R21 = cosd(pitch)*sind(yaw);
R22 = sind(yaw)*sind(pitch)*sind(roll) + cosd(roll)*cosd(yaw);
R23 = sind(yaw)*sind(yaw)*cosd(pitch) - cosd(yaw)*sind(roll);

R31 = -sind(pitch);
R32 = cosd(pitch)*sind(roll);
R33 = cosd(pitch)*cosd(roll);

R = [R11 R12 R13; R21 R22 R23; R31 R32 R33];

end