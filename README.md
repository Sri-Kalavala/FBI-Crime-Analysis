# FBI Hate Crime Analysis

This project provides an interactive dashboard and data analysis for hate crime incidents in the United States, using data from the FBI. The dashboard is built with R Shiny, and additional data exploration is provided in an R Markdown report.

## Features

- **Interactive Shiny Dashboard** (`app.R`):
  - Filter hate crime data by offense type, year, state, bias description, and location.
  - Visualize trends, bias types, and locations of hate crimes.
  - View a map of hate crimes by state.
  - Explore the raw data in a searchable table.
  - Predict future hate crime counts using linear regression.

- **Data Analysis Report** (`Project.Rmd`):
  - Data cleaning and summary statistics.
  - Exploratory plots (offense type, year, bias, state, location, victim age group, offender race).
  - K-means clustering of states by total crimes.

## Files

- `app.R`: Main Shiny app for interactive dashboard.
- `Project.Rmd`: R Markdown report for data analysis and visualization.
- `hate_crime.csv`: Main dataset of hate crime incidents.
- `my_database.db`: (Optional) Database file, not required for the Shiny app.
- `Project.html`: Rendered HTML report from `Project.Rmd`.
- `FBI-Hate-Crime-Analysis.Rproj`: RStudio project file.

## Getting Started

1. **Install Required Packages**
   - Open R or RStudio and run:
     ```r
     install.packages(c("shiny", "tidyverse", "leaflet", "shinythemes"))
     ```

2. **Run the Shiny App**
   - Open `app.R` in RStudio and click "Run App", or run in R:
     ```r
     shiny::runApp("app.R")
     ```

3. **View the Analysis Report**
   - Open `Project.Rmd` in RStudio and knit to HTML, or open `Project.html` directly in your browser.

## Data Source

- The dataset `hate_crime.csv` is based on FBI hate crime statistics.

## Author

Srinika Kalavala

---

*For questions or suggestions, please contact me!*
