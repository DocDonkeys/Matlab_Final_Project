function rotVec = RotMatToRotVec(R)

rotVec(2) = asind(R(3, 1));
rotVec(1) = atan2d((R(3, 2) / cosd(rotVec(2))), (R(3, 3) / cosd(rotVec(2))));
rotVec(3) = atan2d((R(2, 1) / cosd(rotVec(2))), (R(1, 1) / cosd(rotVec(2))));

end