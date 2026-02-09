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



