# ui.R 

library(rCharts)
library(shiny)

# Define UI made
shinyUI(
        navbarPage("Historical Snow Fall Records in Chicago (1958-present)",
                tabPanel("Explorer",
                            sidebarPanel(
                                    sliderInput("range", 
                                                label = "Year:", 
                                                        min = 1958, 
                                                        max = 2014, 
                                                value = c(1958, 2014),
                                                format="####"),
                                    uiOutput("monthsControl")
                            ),                        
                            mainPanel(
                                    tabsetPanel(
                                            tabPanel('Snow Fall',
                                                     h4('Total Monthly Snow Fall in Chicago (inches)', align = "center"),
                                                     showOutput("snowPlot", "morris")
                                                     

                                            ),
                                            tabPanel('Air Temp',                                                  
                                                     h4('Average Monthly Air Temperture in Chicago (Fahrenheit)', align = "center"),
                                                     showOutput("tempPlot", "morris")
                                                     

                                            ),
                                            tabPanel('Data',                                                  
                                                     dataTableOutput("table"),
                                                     downloadButton('downloadData', 'Download')

                                            )
                                    )
                            )
                ),
                tabPanel("About",
                            mainPanel(     
                                    includeMarkdown("include.md")
                            )
                )
        )
)