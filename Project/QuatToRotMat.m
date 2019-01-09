function R = QuatToRotMat(q)

qVec = [q(2,:); q(3,:); q(4,:)];
R = (q(1,:)^2 - qVec'*qVec) * eye(3) + (2*qVec)*qVec' + (2*q(1,:))*GetCrossMat(qVec);

end