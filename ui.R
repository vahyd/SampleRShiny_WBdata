library(shiny)
shinyUI(fluidPage(
  
  sidebarPanel( hr(),
                width = 4,
                h3("World Bank Economic Indicators Dashboard"),
                sliderInput("Year",
                            "Year:",
                            min = 1974,  max = 2015, value = 2014, sep = ""),
                
                selectInput("Indicator", "Indicator List:", choices = inputInd$ind,selected = "Population, total"),
                selectInput("country", "Country List:", choices = c(levels(unique(df$Country))),selected = "Afghanistan"),
                
                h3("Scatter Plot:"),
                selectInput("Axisx", "Axis X:", choices = axis$ind,selected = axis$ind[1]),
                
                selectInput("Axisy", "Axis Y:", choices = axis$ind,selected = axis$ind[2])
                
  ),

  mainPanel(
    hr(),
    tabsetPanel(
      
      tabPanel("Data Table", hr(),textOutput("text4"), hr(), DT::dataTableOutput("mytable")),
      tabPanel(position = "left","Historical Trend",  
               showOutput("myChart1","nvd3"),textOutput("text1")),
      
      tabPanel("Scatter Plot",  
               plotlyOutput("myChart3"),textOutput("text3"))
      
      
    )
    
  )
  
))
