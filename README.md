# # Analysis of Wind Turbine Failure

## Project Overview
This project performs an Exploratory Data Analysis (EDA) on wind turbine operational data to identify conditions contributing to turbine failure. The dataset includes sensor and environmental parameters such as wind speed, power output, temperatures, and failure status. The analysis aims to extract key insights for predictive maintenance to improve turbine reliability and operational uptime.

## Tools & Technologies
- Python (pandas, numpy, matplotlib, seaborn)
- SQL (MySQL queries for data extraction and preprocessing)
- Tableau (for dashboard visualizations)

## Data Preprocessing
- Deduplication of records with no duplicates found
- Standardization of data (removal of extra spaces, type conversion)
- Null-value handling (no missing values present)
- Column cleanup (e.g., removal of unnecessary columns like Row_Num)

## Key Findings from EDA

### 1. Failure Distribution
- Dataset is imbalanced, with fewer failure instances but crucial for identifying failure conditions.
- Failure rate was calculated to assess frequency of breakdowns.

### 2. Influential Features
- **Power Output:** Failure rates spike at very low (<1) and very high (>6) power levels.
- **Gear Oil Temperature:** Failures only when temperature > 90°C, indicating overheating issues.
- **Gear Box Inlet Temperature:** 100% failure when temperature exceeds 50°C, a critical predictor.
- **Ambient and Nacelle Temperatures:** Indirectly influence failure under specific conditions, e.g., ambient > 20°C combined with moderate power output leads to failures.

### 3. Wind Speed & Other Factors
- Wind speed, rotor speed, yaw angle, and wind direction showed no strong direct correlation with failures.

### 4. Interaction Effects
- Compound conditions such as moderate power + high ambient temperature or high gear oil + inlet temperatures lead to 100% failure rates, highlighting multifactorial causes.

## Summary of Analysis Steps
| Step                          | Description                               | Action/Observation                                 |
|-------------------------------|------------------------------------------|--------------------------------------------------|
| Data Preprocessing            | Cleaning and type conversion              | Created clean dataset with consistent types      |
| Identifying Duplicates        | Duplicate row check                       | No duplicates found                               |
| Standardizing Data            | Removing spaces, type conversions         | Standardized Wind_speed, Power, and date columns |
| Null Values                  | Null/missing values check                  | No missing data found                             |
| Column Cleanup               | Removing unwanted columns                   | Removed Row_Num after duplicate check            |
| Statistical Moments          | Calculated mean, variance, skewness       | Analyzed Wind_speed, Power, temperatures          |
| Failure Status Analysis      | Grouped by failure status                   | Found critical failure indicators in power & temps|

## Conclusion
Power output and gear-related temperatures (Gear Oil and Gear Box Inlet) are key predictors of wind turbine failure. Monitoring these variables, especially temperature metrics, is essential for predictive maintenance and operational efficiency. The analysis reveals multifactorial failure causes, emphasizing the need for continuous sensor monitoring and potential classification models to predict failures in future work.

## How to Use This Repo
- Run Python scripts in `/scripts` for data cleaning and EDA
- Execute SQL queries from `/sql` folder to extract and preprocess turbine data
- Explore dashboards in `/tableau` folder for interactive visualization of failure trends and KPIs
- Refer to `/data` for a sample dataset (anonymized and size-reduced)

## Contact
Mohamed Fazal  
[LinkedIn](https://www.linkedin.com/in/mohamed-fazal-a-f-b94737285)  
Email: fazalmohamedstb2020@gmail.com
