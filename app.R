library(shiny)
library(tidyverse)
library(ggplot2)
library(RColorBrewer)
library(choroplethr)
library(choroplethrMaps)
library(tidyverse)


#data prep work
Chloropleth_prep <- select(mydata,"country", "co2_growth_abs", "year")
Chloropleth_prep<- filter(Chloropleth_prep, year == 2000)
Chloropleth_prep <- rename(Chloropleth_prep, "value" = "co2_growth_abs", "region" = "country")
Chloropleth_prep <-select(Chloropleth_prep, -"year")
Chloropleth_prep$region <- tolower(Chloropleth_prep$region)
Chloropleth_prep$region <- trimws(Chloropleth_prep$region, which = c("left"))

gg_plot_prep <- select(mydata, "country", "year", "co2_per_capita")
gg_plot_prep <- filter(gg_plot_prep, country == "United States")

pageOne <-
  tabPanel(
    "Introduction",
    fluidPage(
      titlePanel("Co2 Emissions around the world"),
      h5("by: Samir Ouijdani"),
      h3(em("Questions:")),
      h4("1. Q) Which country emits the most Co2? ------------------ A) China in 2019"),
      h4("2. Q)Which country emits the least Co2 per capita in 2020?--------------- A) The Democratic Republic of the Congo"),
      h4("3. Q)How much more Co2 have Americans produced in 2020 than another similar sized country?----- A) The US emitted 4245.387 more co2 than Brazil in 2020"),
      h4("4. Q)Which continent emits the most Co2?------------------------------ A) Asia"),
      h4("4. Q)Which continent emits the least Co2 ----------------------------- A) Africa"),
      
      
      tags$head(
        # Note the wrapping of the string in HTML()
        tags$style(HTML("
      @import url('https://fonts.googleapis.com/css2?family=Yusei+Magic&display=swap');
      body {
        background-color: ghostwhite;
        color: black;
      }
      titlePanel{font-family: 'Times New Roman'}
      titlePanel{font-family: 'Times New Roman'}
      h1{font-family: 'Times New Roman'}
      h2{font-family: 'Times New Roman'
      }
      h3{font-family: 'Times New Roman'}
      p{font-family: 'Times New Roman'}
      h3{font-family: 'Times New Roman'}
      h3{font-family: 'Times New Roman'}
      h4{font-family: 'Times New Roman'}
      h4{font-family: 'Times New Roman'}
      h4{font-family: 'Times New Roman'}
      h3{font-family: 'Times New Roman'}
      h4{font-family: 'Times New Roman'}
      h5{font-family: 'Times New Roman'}
      .shiny-input-container {
        color: #474747;
      }")),
      )
    ))

pageTwo <-
  tabPanel(
    "America and its relationship with Co2", 
    fluidPage(
      titlePanel("Co2 in the US over the years chart"),
      sidebarLayout(
        sidebarPanel(
          width = 2,
          selectInput("yearInput", "select year", unique(mydata$year), multiple = TRUE)
        ),
        mainPanel(
          width = 50, 
          plotOutput("water")
        )
      )
    )
  )

pageThree <-
  tabPanel (
    "Air Quality", 
    fluidPage(
      titlePanel("Country Vs Air Quality Interactive Map")),
    h3(em("How does air quality vary across the globe?")),
    h4("Below is a map of countries and where they fall on the co2 index."),
    selectInput(inputId = "countryname", label = "What Country's Air Quality Would you like to see?", choices = Chloropleth_prep$region),
    textOutput(outputId = "countryname"),
    textOutput(outputId = "ExitMessage"),
    mainPanel(plotOutput("map_country"))
  )




ui <- (                        
  fluidPage(                   
    navbarPage (              
      
      "Pollution",          
      pageOne,               
      pageTwo,
      pageThree
      
      
    )
  )
)


server <- function(input, output) {
  output$water <- renderPlot({
    if(is.null(input$yearInput)){
      ggplot(data = mydata, aes(x= year, y= co2_per_capita)) +
        geom_bar(stat="identity") +
        ggtitle("Americans co2 per capita output since 1850") +
        theme(axis.text.x = element_text(angle=90, vjust=.5, hjust=1)) +
        xlim(1850, 2021)+
        geom_col(width = 1) 
      
    }
    else{
      mydata %>%
        filter(year %in% input$yearInput) %>%
        ggplot( aes(x= year, y= co2_per_capita)) +
        geom_bar(stat="identity") +
        ggtitle("Americans co2 per capita output since 1850") +
        theme(axis.text.x = element_text(angle=90, vjust=.5, hjust=1)) +
        xlim(1850, 2021)+
        geom_col(width = 1) 
        
    }
  })
  output$countryname <- renderText({
    msg<-paste("You have chosen ", input$countryname)
    return(msg)
  })
  output$map_country <- renderPlot({
    country_choropleth(Chloropleth_prep, title = "Country vs co2 Growth % in the year 2000", legend = "Co2 growth index rating")
    
  })
  output$ExitMessage <- renderText({
    myval <- filter(Chloropleth_prep, region == input$countryname)
    ExitMessage<-paste(myval)
    
    return(ExitMessage)
  })
  
  }

shinyApp(ui = ui, server = server)


