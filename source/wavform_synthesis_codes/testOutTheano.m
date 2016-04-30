clear all;
close all;
clc;

%load the input features
OUTDIR = 'G:/TTSAshish/outFeats/';
fileName = 'wavEpochREP100.mat'; 
load(strcat(OUTDIR,fileName));
outputs = resultOut;
% outputs = importdata(strcat(OUTDIR,fileName)); 

output = outputs(:,1:40);
f0_target = outputs(:,41);

fs=16000;
addpath('G:\TTSAshish\Straight\TandemSTRAIGHTmonolithicPackage010\');
[testfeature,weightMatrix,q,f]=mfcc_straight('G:/TTSAshish/wav/cmu_us_arctic_slt_a0001.wav');
[inpWav,~] = audioread('G:/TTSAshish/wav/cmu_us_arctic_slt_a0001.wav');
%load('weightMatrixQF.mat');

% Using the output 
q.f0 = f0_target*2;
nCoefficients = size(weightMatrix,1);
cosTable=dctmtx(nCoefficients)';
n3sgram=(pinv(weightMatrix)*(sqrt(exp(cosTable\output')))).^2;
f.spectrogramSTRAIGHT=n3sgram;

sgramSTRAIGHT = 10*log10(n3sgram);
maxLevel = max(max(sgramSTRAIGHT));
figure;
imagesc([0 f.temporalPositions(end)],[0 fs/2],max(maxLevel-80,sgramSTRAIGHT));
axis('xy')
set(gca,'fontsize',14);
xlabel('time (s)')
ylabel('frequency (Hz)');
title('Reconstructed STRAIGHT spectrogram');
s2 = exGeneralSTRAIGHTsynthesisR2(q,f);
sound(s2.synthesisOut,fs);
%audiowrite('moni_1_straight.wav',s2.synthesisOut,fs);
wavwrite(s2.synthesisOut,fs,'generated_straightASH.wav');