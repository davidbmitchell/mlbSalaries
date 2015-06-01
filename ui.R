
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

Team.Payroll <- readRDS("data/Team.Payroll.rds")
Team <- as.character(unique(Team.Payroll$Team))

shinyUI(fluidPage(
	tags$head(
		tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
	),
	titlePanel("MLB Team Payrolls"),
	mainPanel(
		tabsetPanel(id = "tabset",
			tabPanel("Team Payrolls Over Time",
				h2("Payrolls of MLB Teams Over Time"),
				fluidRow(
					column(7,
						sliderInput("Year", "Year", min = 1985, max = 2014, value = 1985, sep="")
						),
					column(4,
						selectInput("order", "Order By:", c("Ascending", "Descending"))
						)
					),
				plotOutput("plot",width="900px")),
			tabPanel("Each Teams Payroll Over Time", 
				h2("Team Salaries From 1985-2014"), 
				fluidRow(
					column(4, selectInput("Team", "Team", Team))),
				plotOutput("plot2")
				),
			tabPanel("MLB Payroll Data Table",
				h2("MLB Payroll Data"),
				fluidRow(
					DT::dataTableOutput(outputId="table"))
				)
			)
		)
	)
)
