function H = computeHomography(x, X)
% X = Hx: 
% X 3d coordinate
% x 2d coordinate
u1 = x(1,1); v1 = x(1,2);
u2 = x(2,1); v2 = x(2,2);
u3 = x(3,1); v3 = x(3,2);
u4 = x(4,1); v4 = x(4,2);

x1 = X(1,1); y1 = X(1,2);
x2 = X(2,1); y2 = X(2,2);
x3 = X(3,1); y3 = X(3,2);
x4 = X(4,1); y4 = X(4,2);

% A: 8x8
A = [u1, v1, 1, 0, 0, 0, -u1*x1, -v1*x1, -x1;
     0, 0, 0, u1, v1, 1, -u1*y1, -v1*y1, -y1;
     u2, v2, 1, 0, 0, 0, -u2*x2, -v2*x2, -x2;
     0, 0, 0, u2, v2, 1, -u2*y2, -v2*y2, -y2;
     u3, v3, 1, 0, 0, 0, -u3*x3, -v3*x3, -x3;
     0, 0, 0, u3, v3, 1, -u3*y3, -v3*y3, -y3;
     u4, v4, 1, 0, 0, 0, -u4*x4, -v4*x4, -x4;
     0, 0, 0, u4, v4, 1, -u4*y4, -v4*y4, -y4];
 
% b = [x1; y1; x2; y2; x3; y3; x4; y4];
% h = [A\b; 1];
% H = reshape(h, 3, 3); % X=Hx

[~, ~, d] = svd(A'*A); 
h = d(:,9);
h = h(:) ./ h(9); % normalize
H = reshape(h, 3, 3)'; % reshape is column-prior

end