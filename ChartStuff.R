library("choroplethr")
library("choroplethrMaps")
library("tidyverse")
air_pollution <- read.csv("https://raw.githubusercontent.com//info201b-2021-aut//final-project-SamirOuijdani//main//air%20pollution.csv?token=AV5GCDKGPMSRO3DJKY4V55DBWKFD4")
cities_air_and_water_pollution <- read.csv("https://raw.githubusercontent.com/info201b-2021-aut/final-project-SamirOuijdani/main/cities_air_quality_water_pollution.18-10-2021.csv?token=AV5GCDNVHEOZGW5HTBQT6VDBWKFKE")

data(df_pop_country)


Chloropleth_prep <- select(cities_air_and_water_pollution,"Country", "AirQuality")
Chloropleth_prep <- rename(Chloropleth_prep, "value" = "AirQuality", "region" = "Country")
Chloropleth_prep$region <- tolower(Chloropleth_prep$region)
Chloropleth_prep$region <- trimws(Chloropleth_prep$region, which = c("left"))


Chloropleth_prep <- Chloropleth_prep %>% 
group_by(region) %>% 
  summarize(value=mean(value)) 


 country_choropleth(Chloropleth_prep, title = "Country vs Air Quality", legend = "Air Quality Index rating")

