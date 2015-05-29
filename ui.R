
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

Team.Payroll <- readRDS("data/Team.Payroll.rds")
Team <- as.character(unique(Team.Payroll$Team))

shinyUI(navbarPage("Navbar!",
  tabPanel("Team Payrolls Over Time",
    headerPanel("Payrolls of Major League Baseball Teams Over Time"),
    fluidRow(
      shiny::column(12,
        plotOutput("plot")
      )
    ),
    
    fluidRow(
      shiny::column(4, offset = 2,
        sliderInput("Year", "Year",
                    min = 1985, max = 2013,
                    value = 1985, animate = TRUE
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
        selectInput("Team", "Team", Team)
      )  
    )
  ),
  tabPanel("MLB Payroll Data Table",
           headerPanel("MLB Payroll Data"),
           fluidRow(
             DT::dataTableOutput(outputId="table")
             )
           )
))
