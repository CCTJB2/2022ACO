%% testrho
% Test script for the 'rho' function

%%% Introduction
% rho is a function for computing the frequency-wise stability margin of a
% plant-controller pair.  For further help, please inspect that function's
% help.
%
% This script contains some simple functional tests for the rho function.
% It does not check that the results are actually correct - this is left as
% an exercise for someone who wishes to make a separate implementation!

%%% Test Case 1: check rho works with default syntax

clear

% Setup a (non-square) plant transfer function
P1 = tf(1, [1 2 1]);
P2 = tf(1, [10 1 1]);
P3 = tf(1, [100 0.5 1]);
P = [P1 P2 0; 0 0 P3];

% Produce a simple controller
C = -0.1 * eye(size(P))';
assert(isstable(feedback(P, C, +1)));

% Run the function
[r, rinf, omega] = rho(P, C);

% Standard bank of tests.
assert(all(r <= 1));
assert(all(r >= 0));
assert(all(r >= rinf));
assert(isequal(size(r), size(omega)));


%% Test Case 2: check rho works with an optional omega argument

clear

% Setup a (non-square) plant transfer function
P1 = tf(1, [1 2 1]);
P2 = tf(1, [10 1 1]);
P3 = tf(1, [100 0.5 1]);
P = [P1 P2 0; 0 0 P3];

% Produce a simple controller
C = -0.1 * eye(size(P))';
assert(isstable(feedback(P, C, +1)));

% Create a frequency vector
omega = logspace(-2, 2, 501);

% Run the function
[r, rinf, omegaOut] = rho(P, C, omega);

% Check the omega we've used is the one we've given
assert(isequal(omega, omegaOut));

% Standard bank of tests.
assert(all(r <= 1));
assert(all(r >= 0));
assert(all(r >= rinf));
assert(isequal(size(r), size(omega)));


%% Test Case 3: check rho works when asked to produce a graph
% This is indicated by the absence of output arguments.

clear

% Setup a (non-square) plant transfer function
P1 = tf(1, [1 2 1]);
P2 = tf(1, [10 1 1]);
P3 = tf(1, [100 0.5 1]);
P = [P1 P2 0; 0 0 P3];

% Produce a simple controller
C = -0.1 * eye(size(P))';
assert(isstable(feedback(P, C, +1)));

% Create a new figure window
h = figure();

% Run the function
rho(P, C);

% Give the user a chance to see the result, then close the figure
pause(2)
close(h);


%% Test Case 4: check that it works ok for discrete-time systems
% There's nothing different about the maths, so it should work. The only
% difference is that we plot a solid line at the Nyquist frequency.

clear

% Set up a simple discrete-time plant
P = tf(1, [1 0.1 1]);
P = c2d(P, 0.1);
P.Ts = -1; % unspecified sample period is an edge case so harder!

% Set up a simple controller
C = -0.1 * eye(size(P))';
assert(isstable(feedback(P, C, +1)));

% Create a new figure
h = figure();

% Run the function
rho(P, C);

% Pause so the user can see the results, then close the figure
pause(2)
close(h);


%% Test Case 5: check results and warning from an unstable feedback network
% The frequency-wise robust stability margin 

clear

% Reset the warning state.
lastwarn('');

% Setup an unstable plant-controller pair
P = tf(1, [1 2 1]);
C = 1;
assert(~isstable(feedback(P, C, +1)));

% Run the function - with the warning temporarily set to silent
warning off rho:unstablePCPair
[r,rinf,omega] = rho(P, C);
warning on rho:unstablePCPair

% The warning message is still set - check it was as expected
[msg, msgId] = lastwarn();
assert(strcmp(msgId, 'rho:unstablePCPair'));

% Reset the warning state
lastwarn('');

% Check that the infimum result is zero
assert(isequal(rinf, 0))

% Standard bank of tests.
assert(all(r <= 1));
assert(all(r >= 0));
assert(all(r >= rinf));
assert(isequal(size(r), size(omega)));
