
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(dplyr)
library(ggplot2)
library(scales)



sal <- read.csv('data/mlbSalaries.csv')

team.sal <- setNames(aggregate(sal$salary, by=list(year = sal$year,
                                                   team = sal$team),
                                           FUN=sum),
                    c("year", "team", "salary")) 

year <- as.numeric(unique(team.sal$year))

team <- as.character(unique(sal$team))

shinyUI(navbarPage("Navbar!",
  tabPanel("Team Salaries Over Time",
    headerPanel("Salaries of Major League Baseball Teams Over Time"),
    fluidRow(
      shiny::column(12,
        plotOutput("plot")
      )
    ),
    
    fluidRow(
      shiny::column(4, offset = 2,
        sliderInput("year", "Year",
                    min = min(year), max = max(year),
                    value = min(year), animate = TRUE
        )
      ),
      shiny::column(4,
        selectInput("order", "Order By:",
                    c("Ascending", "Descending")
        )
      )
    )
  ),
  tabPanel("Each Teams Payroll Over Time",
    headerPanel("Team Salaries From 1985-2014"),
    fluidRow(
      shiny::column(12,
        plotOutput("plot2")
      )
    ),
    fluidRow(
      shiny::column(4,
        selectInput("team", "Team", team)
      )  
    )
  )
))
