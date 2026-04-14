# Median vs Adaptive Median Filtering in MATLAB

## Overview
This project compares the performance of standard median filtering and adaptive median filtering under different noise conditions.

---

## Why I Built This
The objective was to:
- Understand noise removal techniques
- Compare fixed vs adaptive filtering strategies
- Evaluate performance using quantitative metrics

---

## Features
- Salt & Pepper Noise addition at:
  - 30%
  - 50%
  - 70%
- Implementations of:
  - Standard Median Filter
  - Adaptive Median Filter (dynamic window size)
- Mean Squared Error (MSE) calculation
- Visualization of results

---

## Results
- Adaptive filtering performs better at high noise levels
- Standard median works well for low noise

---

## How to Run
1. Open MATLAB
2. Place input image in project folder
3. Run:
   ```matlab
   main.m
