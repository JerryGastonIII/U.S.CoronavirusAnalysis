<h1 align="center">United States Coronavirus Data Analysis Project</h1>

## Click [here](https://public.tableau.com/app/profile/jerry.gaston.iii/viz/COVIDDashboard_16881458439100/U_S_CovidCasesStory) for the Tableau Story:</h2>
<p align="center">
  <a href="https://public.tableau.com/app/profile/jerry.gaston.iii/viz/COVIDDashboard_16881458439100/U_S_CovidCasesStory"> <img src= "https://github.com/JerryWGaston/U.S.CoronavirusAnalysis/blob/b775156a1756dc57535da3c1cfdd7bebae251533/images/title.png"/></a>
</p>

## Overview:
Having witnessed the Coronavirus's far-reaching effects in different aspects of my life, I became curious about its impact, specifically within the United States. The emergence and ongoing progression of COVID-19 have had a profound influence on a global scale, continuing to shape our lives even today. Recognizing that everyone has been affected by the pandemic in some manner, I decided to delve into available data on COVID-19 to gain insights and address the questions lingering in my mind.

## Key Findings:
- The Covid infection rate among the population witnessed a 4.62% increase from 2020 to 2021
- Among individuals aged 18 to 49, the infection rate from Covid was the highest, reaching 51%, with the majority of cases reported among White/Caucasian individuals (23.86%)
 - California recorded the highest total number of Covid cases, with approximately 12.53% of its population being infected
- Population size by State proved to have a strong relationship with the number of covid cases

### The questions that I aimed to address through my data project are:

- What is the percentage of the population affected by Covid? 
- Which states have had the highest Covid cases since the onset of the COVID-19 pandemic?
- Which age group has had the highest incidence of Covid infections?
- Which year witnessed the highest number of Covid cases?
- How are Covid cases distributed geographically across the United States?
- Is there a connection between the number of Covid cases and different racial groups?
- Is there a correlation between a state's population and the number of Covid cases it has experienced?

Overall, the primary objective of this data project is to offer insights and shed light on the impact of Covid cases in the United States.

## Data Gathering
#### With these questions I had, I downloaded three datasets to help me answer these questions:
1. **[Covid-19 Case Surveillance Public Data](https://data.cdc.gov/Case-Surveillance/COVID-19-Case-Surveillance-Public-Use-Data-with-Ge/n8mc-b4w4)** (Source: Centers for Disease Control and Prevention)
 - Provides cumulative data for the total cases from 2021-2023 by states & counties
2. **[Coronavirus (COVID-19) Cases, Vaccinations & Deaths](https://ourworldindata.org/covid-deaths)** (Source: Our World in Data)
 - Provides cases, vaccinations, and deaths data on North American countries 
3. **[US Cities Population Dataset](https://www.census.gov/data/tables/time-series/demo/popest/2020s-total-cities-and-towns.html)** (Source: U.S. Census Bureau) 
 - Provides data on US States, calculating the population size of each state. 

## Data Cleaning + Data Manipulation
Once I downloaded my datasets, I loaded them into SQL Server Management Studio to query them using Data Manipulation Language (DML) techniques to create tables I uploaded in to Tableau Public. I also performed JOINS and VIEWS to combine my datasets during this process. 

The following is a query that I performed to create a VIEW for the percentage of the population that's vaccinated; using aggregate functions, partition by, and joins to make the necessary calculations: 

```
Create View PercentPopulationVaccinated as
	SELECT death.location, death.date, death.population, vacc.new_vaccinations,
		MAX(CONVERT(int, vacc.new_vaccinations)) OVER (PARTITION BY death.location ORDER BY death.location, death.date) AS rolling_count_people_vaccinated
	FROM covid_deaths AS death
	JOIN covid_vaccinations AS vacc
		ON death.location = vacc.location
		AND death.date = vacc.date
	WHERE death.continent = 'North America'
```

The rest of the SQL queries that I performed can be accessed [here](https://github.com/JerryWGaston/U.S.CoronavirusAnalysis/blob/b775156a1756dc57535da3c1cfdd7bebae251533/SQL%20Queries/North%20America%20Covid%20SQL%20Queries.sql).

## Data Visualizing
After conducting the queries and exporting the results as an Excel file, the data was loaded into Tableau for visualization. Multiple dashboards have been created and compiled into a cohesive storyboard, which presents the following findings regarding Coronavirus cases from 2020 to early 2023:

### Which year witnessed the highest number of Covid cases?
<p align="center">
  <img src= "https://github.com/JerryGastonIII/U.S.CoronavirusAnalysis/blob/main/images/%23ofCovidCasesPerYear.png">
</p>

The year with the most covid cases was 2022, with 40,505,154 cases. This tell us which year was the peak of Covid. 


### What is the percentage of the population that has been affected by Covid? 
<p align="center">
  <img src= "https://github.com/JerryGastonIII/U.S.CoronavirusAnalysis/blob/b775156a1756dc57535da3c1cfdd7bebae251533/images/%23ofCovidCasesvsPopulation.png">
</p>

According to the data, over 30% of the population has been infected by Coronavirus. There was an increase in Covid cases by **4.62%** from the years 2020 and 2021. Covid cases increased by **2.02%** between 2021 and 2022, but this was the year most Covid cases occurred. Overall, over 30% of the population has been infected with Coronavirus. 

### Which states have had the highest Covid cases since the onset of the COVID-19 pandemic?
<p align="center">
  <img src= "https://github.com/JerryGastonIII/U.S.CoronavirusAnalysis/blob/b775156a1756dc57535da3c1cfdd7bebae251533/images/Top5States.png">
</p>

According to the data, the top 5 states with the highest cases are California, Texas, New York, Florida, and Illinois. California had **12,257,432 cases**, with **31.10%** of their population infected. California had **12.53%** of the total cases in the United States compared to other states. Texas had the second most, with **8,957,966** cases, **32.01%** of their population infected, and **9.16%** of the total cases in the United States. 

<p align="center">
  <img src= "https://github.com/JerryGastonIII/U.S.CoronavirusAnalysis/blob/b775156a1756dc57535da3c1cfdd7bebae251533/images/Top5StatesDIfferencesByYear.png">
</p>

This visual shows the percent difference in Covid cases per the top 5 states by year. In California, from 2020 to 2021, the number of covid cases increased by **25.8%.** In Texas, the covid cases from 2020 to 2021 increased by **63.6%.**

### Which age group has had the highest incidence of Covid infections?
  <img src= "https://github.com/JerryGastonIII/U.S.CoronavirusAnalysis/blob/b775156a1756dc57535da3c1cfdd7bebae251533/images/%23ofCovidCasesByAgeGroup.png" >
</p>

The age group 18 to 49 years had the highest incidence of Covid infections, with **49,374,738** total infections overall. They made up **51%** of the total cases.

<p align="center">
  <img src= "https://github.com/JerryGastonIII/U.S.CoronavirusAnalysis/blob/b775156a1756dc57535da3c1cfdd7bebae251533/images/%23CovidCasesByAge%26Year.png">
</p>

Breaking it down, the age group 18 to 49 comprised most of the total cases by year. This age group peaked in 2022, having a total of **19,341,560** cases.  The next age group with the most of cases is 50 to 64 years old, with a total **7,290,400**  cases in 2022. 2022 was the year that most Covid cases occurred.

### How are Covid cases distributed geographically across the United States?
<p align="center">
  <img src= "https://github.com/JerryWGaston/U.S.CoronavirusAnalysis/blob/b775156a1756dc57535da3c1cfdd7bebae251533/images/%25CovidCasesPerState.png">
</p>

The map shows that California had the highest Covid cases, totaling **12.53%.** The next state is Texas, making up 9.16% of the total cases. 

<p align="center">
  <img src= "https://github.com/JerryWGaston/U.S.CoronavirusAnalysis/blob/b775156a1756dc57535da3c1cfdd7bebae251533/images/%23CovidCasesPerState.png">
</p>

This map shows us the total number of Covid cases per state. As we can see, California's total cases are **12,257,432.** Texas is **8,957,966.**

### Is there a connection between the number of Covid cases and different racial groups?
<p align="center">
  <img src= "https://github.com/JerryWGaston/U.S.CoronavirusAnalysis/blob/b775156a1756dc57535da3c1cfdd7bebae251533/images/%25ofCasesByRace%26Age.png">
</p>

This chart shows a possible connection between cases by age group and race. In each age group, White/Caucasia cases comprised the highest percentage. In 2022, White/Caucasians made up **23.86%** of the total cases. 

### Is there a correlation between a state's population and the number of Covid cases it has experienced?
<p align="center">
  <img src= "https://github.com/JerryWGaston/U.S.CoronavirusAnalysis/blob/b775156a1756dc57535da3c1cfdd7bebae251533/images/Relationship%20(State%20Population%20vs.%20Total%20Cases).png">
</p>

The analysis of the relationship between the population size by state and the number of Covid cases revealed a strong correlation, as indicated by an R-squared value of 0.94. The R-squared value measures the goodness of fit of a regression model, with values closer to 1 indicating a stronger relationship. In this case, the high R-squared value of 0.94 suggests a robust association between the population size and the number of Covid cases reported. The relationship between these variables is substantial, emphasizing the influence of population size on the incidence of Covid cases at the state level.
## Conclusion

The data analysis reveals significant relationships between Covid cases and variables such as state, age group, year, and population. The analysis shows that the Covid infection rate as a percentage of the population experienced a notable increase of 3.62% from 2020 to 2021, representing the highest percentage increase among the examined years. Among age groups, individuals aged 18 to 49 accounted for the highest proportion of infections, constituting 51% of the total cases. Within this age group, most cases were reported among White/Caucasian individuals, comprising 23.86%. California emerged as the state with the highest Covid cases, affecting approximately 12.53% of its population. The analysis also highlights a strong correlation between a state's population and the number of Covid cases reported in 2020, emphasizing the role of state location and population size in determining the likelihood of contracting the Coronavirus at the onset of the pandemic.
	
It is crucial to acknowledge that the analysis may only capture some Covid cases, and the actual numbers could differ from those presented in this analysis. As a nation, the United States continues to be significantly impacted by the Coronavirus. Despite the reduced focus on the disease in current discussions, it remains essential for individuals to take necessary precautions to minimize their risk of contracting the virus. Vigilance and adherence to preventive measures remain crucial in ensuring the well-being of ourselves and others, even as the pandemic evolves.
