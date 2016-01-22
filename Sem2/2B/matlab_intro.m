format compact % Makes more fit on the screen in Matlab's output

% This file demonstrates some matrix operations in Matlab/Octave.
% For plotting, I'll provide a separate example.
% A Python+NumPy version is also available.
%
% I tend to use Matlab via:
%     matlab -nodesktop -nosplash
% from the same directory as my script. You may prefer the heavy-weight GUI,
% which you get by running without -nodesktop
%
% Iain Murray, January 2013

% IMPORTANT:
% Data analysis, programming, and mathematics are not spectator sports! You can
% only learn to munge data by doing it. Unless you spend a reasonable amount of
% time per lecture (~2hrs) reproducing the material for yourself, you won't
% really understand it. It's easy to kid yourself otherwise, but you really
% should be writing your own programs to reproduce at least some of the
% figures/numbers/methods discussed.
%
% If you can't do something here, or something related to the material here,
% ask a question on the copy you can find on NB.

% 1D arrays
% ---------

% In Matlab 1D arrays don't really exist.
% A vector is actually a 2D array or matrix.
vec = [3, 1, 4, 1, 5, 9, 2] % The commas are optional
size_vec = size(vec)
% vec is a row vector, 1x7
col_vec = vec'
% vec' is a column vector 7x1
% A column vector could also be entered like this:
col_vec = [3; 1; 4; 1; 5; 9; 2]

% If you put a semi-colan at the end of any line of computation, it will
% suppress the answer being output. (Important for code inside long loops or
% if the answer is LARGE.)

% EXERCISE explore simple operations on the vector.
% Load Matlab or Octave, and type matlab_intro, or simply copy-paste the vec
% definition into the prompt.
%
% Then evaluate vec+vec, vec/2, vec+3, vec.*vec, vec.^2, etc.
% Some operators (+,-) and most functions (exp,log,sin,etc) work
% element-wise on all the numbers in the array.
% * and / work elementwise with scalars, but for matrices do matrix
% multiplication (and division). For elementwise versions of multiplication,
% division, and raising to the power, use .* ./ and .^ (note the dots)
%
% Matlab arrays support one-based indexing and slicing.
% (NB Python+Numpy is zero-based!)
% Predict and evaluate: vec(1), vec(4:5), vec(end)
% Matlab arrays also let you select an array of indexes:
% Try vec([1,4,6,3,3])
%
% TODO -- have you worked through all the exercises above?


% Matrices
% --------

% Most variables in Matlab are matrices of double floating point numbers.
% If you write "x=1" you will get a 1x1 matrix of doubles containing a 1.0

% Create a matrix, separating rows with ";".
% You can put commas between each element if you like.
fprintf('\nHere''s the whole test array:\n')
A = [ 1  2  3;
      4  5  6;
      7  8  9;
     10 11 12;
     13 14 15]
fprintf('A is a matrix with size %dx%d\n', size(A))
fprintf('That means A has %d rows.\n', size(A, 1))
fprintf('EXERCISE: print the number of columns in A\n')
% TODO
size(A,2)

fprintf('\nTo get the top left element, we select row1, col1:\n')
A(1,1) %or A(end)

fprintf('\nEXERCISE: print the bottom right element of the array\n')
% TODO
A(5,3)

fprintf('\nSubsets of rows and columns can be selected with ranges or lists:\n')
% Ranges really are just lists: 1:3 is equivalent to [1 2 3]
% EXERCISE: (TODO) predict and verify what all of these return:
A(:,1:2)
A(1:2,:)
A(1:2,2:3)
A(end,[1 3]) %13 15

fprintf('\nEXERCISE: print the last column of A:\n')
% TODO
A(:,end)
fprintf('\nEXERCISE: print the first two rows of the last column of A:\n')
% TODO
A([1 2],end)


% Work with matrices
% ------------------

% To find the mean of each column of an array you might do:
[I, J] = size(A)
mu = zeros(1, J); % allocate space for answer
for i = 1:I
    for j = 1:J
        mu(j) = mu(j) + A(i,j);
    end
end
mu = mu / I
%
% But code with a lot of numerical computations would be cluttered very quickly.
% So you you would create a function called "mean". Except Matlab already has
% one:
mu = mean(A, 1) % 1 means sum over the 1st dimension of the array (the rows)
%
% EXERCISE: create a vector containing the mean of each row of A
% TODO
mu2=mean(A,2)

% To make each column zero-mean, we could laboriously subtract off the mean:
fprintf('\nCentering the columns:\n');
A_shift = A; % (lazily) creates a copy (if you modify either)
for i = 1:I
    for j = 1:J
        A_shift(i,j) = A_shift(i,j) - mu(j);
    end
end
A_shift
% But we can subtract arrays of the same shape in numpy, so can take
% the mean row off each row in one operation per row:
A_shift = A;
for i = 1:I
    A_shift(i,:) = A_shift(i,:) - mu;
end
A_shift
% Unfortunately (unlike numpy) Matlab doesn't work out what you mean by:
%     A_shift = A - mu
% (Although recent versions of Octave do.) Matlab will complain that A and mu
% aren't the same size, and so it doesn't know how to subtract them.
%
% The classic fix is to make them the same size, by copying:
A_shift = A - repmat(mu, size(A,1), 1);
% EXERCISE check the sizes of A, mu, and repmat(mu, size(A,1), 1), and look at
% mu and repmat(mu, size(A,1), 1). -- TODO, actually do it!
%
% Matlab also supports "broadcasting" (like in Python), but through a
% regrettably ugly function called bsxfun. Any size of length 1 is implicitly
% expanded, so that the sizes match without having to do the repmat:
A_shift = bsxfun(@minus, A, mu)
fprintf('Check the columns are centered: \n')
mean(A_shift, 1)

% EXERCISE make the rows zero mean:
fprintf('\nCentering the rows:\n');
row_mu = mean(A, 2)
A_rshift = bsxfun(@minus,A,row_mu)
% TODO
% EXERCISE: check that this answer had the intended effect.
% TODO
mean(A_rshift,2)

% EXERCISE A' is the matrix transpose of the array. You could also make the
% rows zero mean by transposing the array, making the columns zero-mean, and
% transposing back. Try this method:
% TODO
At=A'
mct=mean(At,1)
At_cshift=bsxfun(@minus,At,mct)
Att=At_cshift'
mean(Att,2)

% EXERCISE: make a standardized version of array A where each column has zero
% mean and standard deviation of one. And check your answer. The sample standard
% deviation is provided by std.
% TODO

% EXERCISE: make a standardized version of array A where each row has zero mean
% and standard deviation of one. And check your answer.
% TODO


% Finding and sorting
% -------------------

% cell-arrays (curly braces) can store anything, including strings, just like
% Python lists. We don't usually use them for numbers.
people = {'jim', 'alice', 'ali', 'bob'};
height_cm = [180, 165, 165, 178];

% The laborious, procedural programming way:
largest_height = -Inf;
tallest_person = '';
for i = 1:numel(height_cm)
    if height_cm(i) > largest_height
        largest_height = height_cm(i);
        tallest_person = people{i}; % {} not () so don't get cell array result
    end;
end
largest_height
tallest_person
% Of course there's a standard routine built in:
largest_height = max(height_cm);
% we can optionally pull out the id of the largest element:
[largest_height, id] = max(height_cm);
largest_height
tallest_person = people{id}

% What about the shortest person?
[smallest_height, id] = min(height_cm);
smallest_person = people{id}
% Except actually, that's just the first one, there is a tie:
ids = find(height_cm == smallest_height);
smallest_people = people(ids)

% sort(height_cm) sorts the list. Again, a second argument will give the indexes
% of the corresponding items.
[sorted_heights, ids] = sort(height_cm)
people_in_height_order = people(ids)


% Turning maths in matrix operations "vectorization"
% --------------------------------------------------

% Mathematical expressions can often be computed with terse array-based
% expressions. The most important thing is to have working, correct code. So
% don't be afraid to accumulate your answers in for loops, at least as first.
% However, where you can spot standard matrix operations, your code will be
% shorter, sometimes clearer, and faster.

% Given a mathematical expression like:
% result = \sum_{i=1}^I fn(x_i, x_j) val(z_i)
% The results of fn could be put in an IxJ matrix, and the results of val in a
% Ix1 vector. The sum is then a matrix-vector multiply: result = fn'*val

% Given another expression:
% result_j = \sum_{i=1}^I fn(x_i, x_j) weights(z_i, z_j)
% The result is a vector. We can do the multiplication inside the sum for all i
% and j at once, and then sum out the index i: results = sum(fn.*weights, 1)

% Sometimes repmat or bsxfun is required to make the dimensions of matrices
% match.

% There are no exercises here for now. If you see code that involves tricks you
% don't understand, try to write a for-loop version based on what you think it
% should do, and see if you get the same answer. If you are writing code with
% lots of for loops, keep going, but then afterwards try to replace parts of it
% with a "vectorized" version, checking that your answers don't change.

% There are more references in the Matlab notes at:
% http://homepages.inf.ed.ac.uk/imurray2/compnotes/matlab_octave_efficiency.html
