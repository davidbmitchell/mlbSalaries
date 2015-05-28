
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

team.sal <- readRDS("data/Team.Salaries.rds")
name <- as.character(unique(team.sal$name))

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
        selectInput("name", "Team", name)
      )  
    )
  )
))
