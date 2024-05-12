# COVID-19 Data Exploration

This repository contains code for exploring COVID-19 data using SQL. The code showcases various SQL techniques and functionalities to gain insights and perform analysis on COVID-19 related data. 

The COVID-19 data exploration code in this repository leverages the following SQL techniques:

- **Joins:** Combining data from multiple tables to analyze COVID-19 cases, deaths, and vaccination data collectively.
- **CTEs (Common Table Expressions):** Utilizing CTEs to create temporary result sets for complex queries and improving code readability.
- **Temp Tables:** Using temporary tables to store intermediate results and facilitate further analysis.
- **Window Functions:** Employing window functions to perform rolling calculations and obtain cumulative values over a specific window or partition.
- **Aggregate Functions:** Utilizing aggregate functions like `SUM`, `MAX`, and `COUNT` to calculate total cases, total deaths, and other statistics.
- **Creating Views:** Creating views to store reusable queries and simplify complex data retrieval operations.
- **Converting Data Types:** Handling data type conversions to ensure compatibility and accurate calculations.

## Data Loading

The provided code snippet is used to load data from CSV files into the respective tables (`covid_vaccination` and `covid_deaths`) in the database. The `LOAD DATA INFILE` statement is utilized to efficiently import the data.

### Loading Vaccination Data

To load the vaccination data, use the following command:

```
LOAD DATA LOCAL INFILE '/path/to/file/CovidVaccination.csv' INTO TABLE covid_vaccination
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(iso_code,continent,location,date,new_tests,total_tests,total_tests_per_thousand,new_tests_per_thousand,new_tests_smoothed,new_tests_smoothed_per_thousand,positive_rate,tests_per_case,tests_units,total_vaccinations,people_vaccinated,people_fully_vaccinated,total_boosters,new_vaccinations,new_vaccinations_smoothed,total_vaccinations_per_hundred,people_vaccinated_per_hundred,people_fully_vaccinated_per_hundred,total_boosters_per_hundred,new_vaccinations_smoothed_per_million,new_people_vaccinated_smoothed,new_people_vaccinated_smoothed_per_hundred,stringency_index,population_density,median_age,aged_65_older,aged_70_older,gdp_per_capita,extreme_poverty,cardiovasc_death_rate,diabetes_prevalence,female_smokers,male_smokers,handwashing_facilities,hospital_beds_per_thousand,life_expectancy,human_development_index,excess_mortality_cumulative_absolute,excess_mortality_cumulative,excess_mortality,excess_mortality_cumulative_per_million);
```

### Loading Deaths Data

To load the deaths data, use the following command:

```
LOAD DATA LOCAL INFILE '/path/to/file/Covid\ Deaths.csv' INTO TABLE covid_deaths
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(iso_code,continent,location,date,population,total_cases,new_cases,new_cases_smoothed,total_deaths,new_deaths,new_deaths_smoothed,total_cases_per_million,new_cases_per_million,new_cases_smoothed_per_million,total_deaths_per_million,new_deaths_per_million,new_deaths_smoothed_per_million,reproduction_rate,icu_patients,icu_patients_per_million,hosp_patients,hosp_patients_per_million,weekly_icu_admissions,weekly_icu_admissions_per_million,weekly_hosp_admissions,weekly_hosp_admissions_per_million);
```

Make sure to adjust the file paths in the above commands to the correct locations of the CSV files on your system.

After executing the code, the data from the CSV files will be loaded into the covid_vaccination and covid_deaths tables, respectively.

Note: The provided code assumes that the database and tables are already created in the MySQL environment.
