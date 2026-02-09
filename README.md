# Cardiovascular Health Monitoring Using OMRON Blood Pressure Data

This repository contains R code for processing, visualizing, and summarizing blood pressure and pulse data exported from an **OMRON upper‑arm blood pressure monitor**. The script performs data cleaning, date‑time normalization, graphical visualization, and statistical summarization to support personal cardiovascular health tracking.

---

## Features

- Imports raw CSV data exported from OMRON devices  
- Cleans and standardizes date and time formats  
- Converts Spanish month abbreviations into numeric format  
- Generates a time‑series visualization of:
  - Systolic blood pressure  
  - Diastolic blood pressure  
  - Pulse rate  
- Adds reference lines for normal and hypertensive blood pressure thresholds  
- Produces a statistical summary of all measurements  

---

## 1. Data Loading and Cleaning

The script begins by loading the required libraries:

```r
library(ggplot2)
library(dplyr)


It then reads the CSV file (omron.csv) and performs several preprocessing steps:

- Combines the date and time columns into a single string
- Replaces Spanish month abbreviations (e.g., ene., feb., mar.) with numeric values
- Converts the resulting string into a POSIXct date‑time object
- Selects the relevant variables:
  - Systolic pressure
  - Diastolic pressure
  - Pulse rate
- Removes rows with invalid dates
- Sorts the dataset chronologically

This produces a clean and structured dataset suitable for analysis.

---

## 2. Visualization

The script generates a detailed time‑series plot using ggplot2. The visualization includes:

- Individual measurement points for systolic, diastolic, and pulse values
- LOESS‑smoothed trend lines for each variable
- Distinct colors and shapes to differentiate measurements
- Reference lines indicating:
  - Normal blood pressure ranges
  - Hypertensive thresholds
- A customized theme with improved readability and clear labeling

The plot provides an intuitive overview of cardiovascular trends over time.

---

## 3. Statistical Summary

At the end of the script, a summary of key statistics is printed to the console:

- **Systolic pressure:** mean and maximum
- **Diastolic pressure:** mean and maximum
- **Pulse rate:**
  - Mean
  - Minimum and maximum (range)
  - Standard deviation (variability)

This summary complements the visualization by offering quantitative insights into the measurements.

---

## Usage

Place your exported OMRON CSV file in the working directory and name it:


```r
omron.csv
```


Run the R script.

The plot will be displayed, and the statistical summary will appear in the console.

---

## Requirements

- R (version 4.0 or higher recommended)
- Packages:
  - ggplot2
  - dplyr

Install missing packages with:

```r
install.packages(c("ggplot2", "dplyr"))

## Purpose

This project is intended for personal health monitoring, data exploration, and visualization. It is not a medical diagnostic tool. Always consult a healthcare professional for medical interpretation.



