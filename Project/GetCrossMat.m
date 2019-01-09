function crossMat = GetCrossMat(vec)

%Returns "cross" matrix from a vector
if (length(vec) ~= 3)
    error('Vector must have 3 members.');
else
    crossMat = [    0       -vec(3, 1)  vec(2, 1);
                vec(3, 1)       0       -vec(1, 1);
                 -vec(2, 1) vec(1, 1)       0    ];
end

end