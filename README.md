# COVID-19 Data Analysis SQL Queries

## Overview

This repository contains a collection of SQL queries for analyzing COVID-19 data. These queries are designed to retrieve, analyze, and visualize data related to COVID-19 cases, deaths, vaccinations, and population statistics. The queries are organized into sections for easy navigation and understanding.

## Requirements

- SQL Server or a compatible database management system.

## Dataset
The datasets used in these SQL queries are included within this repository. You can find them in the `datasets` directory. The datasets are named `CovidDeaths.csv` and `CovidVaccinations.csv`, and they contain the COVID-19 data used for analysis.

If you wish to update or replace these datasets, simply replace the CSV files in the `datasets` directory with your desired data files.

## Usage

1. Clone or download this repository to your local machine.

2. Connect to your SQL database management system.

3. Open and execute the SQL script `SQLQuery_Covid.sql` in your database environment. This script contains all the SQL queries organized into sections.

4. The script includes comments explaining each section's purpose and the data it retrieves or calculates.

5. After executing the script, you can run the individual queries or access the created view (`PercentPopulationVaccinated`) to retrieve and visualize the data as needed.

## SQL Query Sections

1. **Initial Data Retrieval**: Retrieves the initial data from the CovidDeaths and CovidVaccinations tables, filtering out records where the continent is not specified.

2. **Data Selection**: Selects the data that will be used for analysis.

3. **Percentage of Cases and Deaths in Portugal**: Calculates and displays the percentage of COVID-19 cases that resulted in death in Portugal over time.

4. **Percentage of Population Infected in Portugal**: Calculates and displays the percentage of the population in Portugal that has been infected with COVID-19 over time.

5. **Countries with Highest Infection Rates**: Identifies countries with the highest infection rates compared to their population and displays relevant statistics.

6. **Countries with Highest Death Counts**: Identifies countries with the highest death counts and displays the total death count for each country.

7. **Continents with Highest Death Counts**: Identifies continents with the highest death counts and displays the total death count for each continent.

8. **Global COVID-19 Numbers**: Calculates and displays global COVID-19 statistics, including total cases, total deaths, and death percentage.

9. **Total Population vs Vaccinations Using CTE**: Calculates rolling people vaccinated over time using a Common Table Expression (CTE).

10. **Total Population vs Vaccinations Using Temp Table**: Calculates rolling people vaccinated over time using a temporary table.

11. **Creating a View for Data Visualization**: Creates a view (`PercentPopulationVaccinated`) to store data for later visualizations.

## Data Visualization

To visualize the data obtained from these queries, you can access the `PercentPopulationVaccinated` view, which includes information about continents, locations, dates, populations, new vaccinations, and rolling people vaccinated.

## Disclaimer

These SQL queries are meant for analysis purposes and may require adjustments to suit your specific database setup and data source.
