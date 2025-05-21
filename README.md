# Analysis of Wind Turbine Failure

![Python](https://img.shields.io/badge/Python-3.9%2B-blue)
![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
![Platform](https://img.shields.io/badge/Platform-Jupyter%20%7C%20SQL%20%7C%20PowerBI-lightgrey)
![Repo Size](https://img.shields.io/github/repo-size/fazzzzzzzzal/Analysis_of_wind_turbine_failure)
![Last Commit](https://img.shields.io/github/last-commit/fazzzzzzzzal/Analysis_of_wind_turbine_failure)

---

## Table of Contents
- [Project Overview](#project-overview)
- [EDA Summary](#exploratory-data-analysis-eda-summary)
- [Sample Data](#sample-data-structure-dummy-data)
- [Usage](#usage-instructions)
- [Notebooks and Scripts](#notebooks-and-scripts)
- [Next Steps](#next-steps)
- [Contact](#contact)

---

## Project Overview

This project investigates the operational parameters of wind turbines to understand the conditions contributing to equipment failure. Using sensor and environmental data such as wind speed, power output, internal temperatures, and failure status, the analysis aims to identify key factors linked to turbine failures. The insights generated can support predictive maintenance and improve turbine reliability.

---

## Exploratory Data Analysis EDA Summary

### 1. Failure Distribution
- The dataset is imbalanced, with fewer failure instances compared to non-failure cases.
- The `Failure_status` column clearly distinguishes operational turbines from failed ones.
- Failure records reveal important patterns that help isolate operational conditions leading to turbine failure.

### 2. Key Influential Features

- **Power Output:**
  - Very high or very low power values correspond to a higher failure rate.
  - Operating at extreme power outputs may stress the turbine.

- **Gear Oil Temperature:**
  - Failures occurred only when gear oil temperature was high (>90°C).
  - High temperature indicates overheating and possible lubrication failure.

- **Gear Box Inlet Temperature:**
  - 100% failure rate observed when temperature exceeded 50°C.

- **Ambient and Nacelle Temperatures:**
  - High ambient temperature alone does not strongly correlate with failure.
  - However, combined with moderate power (1–2), failure rate reaches 100%.

### 3. Wind Speed & Other Factors
- Wind speed, rotor speed, yaw angle, and wind direction did not show strong correlations with failure.

### 4. Feature Interactions
- Compound risk conditions identified:
  - Moderate power (1–2) + High ambient temperature (>20°C) → 100% failure.
  - High Gear Box Inlet Temp + High Gear Oil Temp → 100% failure.
  
Failures are multifactorial and often result from extreme conditions combined.

---

## Sample Data Structure Dummy Data

| date       | Wind_speed | Power  | Nacelle_ambient_temperature | Generator_bearing_temperature | Gear_oil_temperature | Ambient_temperature | Rotor_Speed | Nacelle_temperature | Bearing_temperature | Generator_speed | Yaw_angle | Wind_direction | Wheel_hub_temperature | Gear_box_inlet_temperature | Failure_status |
|------------|------------|--------|-----------------------------|------------------------------|----------------------|---------------------|-------------|---------------------|---------------------|-----------------|-----------|----------------|-----------------------|----------------------------|----------------|
| 01-01-2023 | 16.85      | 6.78   | -56.85                      | 129.90                       | 97.78                | 12.38               | 21.18       | 45.34               | 39.5                | 1508.96         | 168.80    | 105.59         | 109.39                | 44.26                      | Failure        |
| 08-01-2023 | 42.78      | 5.42   | 3.64                        | 56.35                        | 47.57                | 22.36               | 217.85      | 84.21               | 71.4                | 1271.36         | 12.54     | 80.81          | -59.11                | 55.50                      | No_failure     |
| 15-01-2023 | 32.93      | 6.57   | -28.56                      | 45.93                        | 54.54                | 73.62               | 221.66      | 62.45               | 39.5                | 2252.94         | 94.15     | 15.76          | 104.58                | 89.69                      | No_failure     |

*Note: This is dummy data for illustration only. The actual dataset is confidential and not publicly shared.*

---

## Usage Instructions

- The raw dataset contains sensitive information and is **not included** in this repository.
- You can run the Jupyter notebooks provided in the `/notebooks` folder for analysis using your own data.
- SQL scripts for data preprocessing are available in the `/sql` folder.
- A Power BI file for dashboard visualization will be added soon.

---

## Notebooks and Scripts

| File | Description |
|------|-------------|
| [`/notebooks/wind_turbine_eda.ipynb`](https://github.com/fazzzzzzzzal/Analysis_of_wind_turbine_failure/blob/main/notebooks/wind_turbine_eda.ipynb) | Exploratory Data Analysis of wind turbine dataset |
| [`/sql/wind_turbine_failure.sql`](https://github.com/fazzzzzzzzal/Analysis_of_wind_turbine_failure/blob/main/sql/wind_turbine_failure.sql) | SQL script to preprocess turbine failure data |
| Power BI file (coming soon) | Interactive dashboard for failure monitoring |

---

## Next Steps

- Use the EDA insights to build predictive models for failure detection.
- Monitor critical temperature features and power output in real-time systems.
- Incorporate this analysis into maintenance scheduling for wind turbines.
- Extend the project by adding classification models and more advanced analytics.

---

## Contact

For any questions, feel free to contact:  
**Fazal Mohamed**  
📧 Email: fazalmohamedstb2020@gmail.com  
🔗 LinkedIn: [linkedin.com/in/mohamed-fazal-a-f-b94737285](https://www.linkedin.com/in/mohamed-fazal-a-f-b94737285)

---


