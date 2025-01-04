% Turn on the diary to start logging output to a file
diary('console_output.txt')

% Define the size of the matrices
n = 4;

% Generate two random matrices A and B of size n x n
A = rand(n);
B = rand(n);

% Multiply the two matrices
C = A * B;

% Compute the eigenvalues of the resulting matrix C
eigenvalues = eig(C);

% Optionally, print the matrices and the eigenvalues to the MATLAB console
disp('Matrix A:');
disp(A);
disp('Matrix B:');
disp(B);
disp('Product Matrix C:');
disp(C);
disp('Eigenvalues of Matrix C:');
disp(eigenvalues);

% Turn off the diary to stop logging
diary off