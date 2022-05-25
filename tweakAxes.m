function tweakAxes(theAxes)

narginchk(0, 1);
if nargin == 0
    theAxes = gca();
end

v = axis(theAxes);

minFreq = v(1);
maxFreq = v(2);

minMag = v(3);
maxMag = v(4);

minFreqTick = 10^ceil(log10(minFreq));
maxFreqTick = 10^floor(log10(maxFreq));

grid(theAxes, 'on')
set(theAxes, 'XTick', 10.^(log10(minFreqTick):log10(maxFreqTick)));

minMagTick = 20*ceil(minMag/20);
maxMagTick = 20*floor(maxMag/20);

set(theAxes, 'YTick', minMagTick:20:maxMagTick)


