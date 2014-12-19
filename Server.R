# server.R

library(rCharts)
library(shiny)
library(plyr)
library(reshape2)
library(markdown)
require(devtools)

dat <- read.csv("NORR.csv")

shinyServer(function(input, output) {
        #Month Input
        output$monthsControl <- renderUI({
                m<- unique(as.character(dat$Month))
                if(1) {
                        checkboxGroupInput('Month', 'Month:', m, selected=m)
                }
        })
     
        ##Filter data based on selections
        dataSelected <- reactive({
                t1<- subset(dat, Year >= input$range[1] & Year <= input$range[2] & Month%in%input$Month)                       
        })
        
        #Data output
        output$table <- renderDataTable({dataSelected()}[, -3], options =list(pageLength = 10))      

        #Data download
        output$downloadData <- downloadHandler(
                filename = 'data.csv',
                content = function(file) {
                        write.csv({dataSelected()}[, -3], file, row.names=FALSE)
                }
        )
        #Snow fall plot
        output$snowPlot <- renderChart({
                df1 <- subset(
                        dataSelected()[, c("Date", "Snow.Fall")]
                )
                df2 <- transform(df1, Date = as.character(strptime(df1$Date, format = "%Y%m%d")))
                
                m1 <- mPlot(x = "Date", y = "Snow.Fall", type = "Area", data = df2, height =500, width = 800)
                m1$set(pointSize = 2, lineWidth = 0.8, pointFillColors="blue")
                m1$set(smooth=TRUE)
                m1$set(hideHover = "auto")
                m1$set(dom = "snowPlot")
                
                return(m1)
        })
        
        #Air temp plot
        output$tempPlot <- renderChart({
                df3 <- subset(
                        dataSelected()[, c("Date", "Temp.Max","Temp.Min", "Temp.Mean")]
                )
                df4 <- transform(df3, Date = as.character(strptime(df3$Date, format = "%Y%m%d")))
                
                m2 <- mPlot(x = "Date", y = c("Temp.Min", "Temp.Mean", "Temp.Max"), type = "Line", data = df4, height =500, width = 800)
                m2$set(pointSize = 1, lineWidth = 0.8, lineColors=c("red","green","blue"))
                m2$set(smooth=TRUE)
                m2$set(hideHover = "auto")
                m2$set(dom = "tempPlot")
                
                return(m2)
        }) 
})


