 
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(ggplot2)
library(ggthemes)
library(scales)
library(magrittr)

Team.Payroll <- readRDS("data/Team.Payroll.rds")
colors <-
  c("ARI"="#A71930","ATL"="#002F5F","BAL"="#ED4C09","BOS"="#C60C38",
    "CHC"="#000000","CHW"="#003279","CIN"="#C6011F","CLE"="#003366",
    "COL"="#333366","DET"="#DE4406","HOU"="#FF7F00","KCR"="#74B4FA", # cin - kc
    "LAA"="#B71234","LAD"="#0836CB","FLA"="#F9423A","MIL"="#92754C",
    "MIN"="#072754","NYY"="#1C2841","NYM"="#FB4F14","OAK"="#003831",
    "PHI"="#BA0C2F","PIT"="#FD8829","SDP"="#84A76C","SEA"="#005C5C", # NYM - SEA
    "SFG"="#F2552C","STL"="#C41E3A","TBD"="#9ECEEE","TEX"="#BD1021",
    "TOR"="#003DA5","WSN"="#BA122B","MON"="#165B9E", "CAL" = "#C4023C",
    "ML4" = "#043EA4", "FLO" = "#04A6B4", "ANA" = "#B71234")

shinyServer(function(input, output) {
  
  # Filter data based on selections
  output$plot <- renderPlot({ 
    
    Team.Payroll <- Team.Payroll[Team.Payroll$Year == input$Year, c("Year", "Team", "Payroll", "Wins", "Franchise.ID")]

    if(input$order == "Ascending") {
    
      Team.Payroll <- with(Team.Payroll, Team.Payroll[order(Payroll),])
    
    } else {
      
        Team.Payroll <- with(Team.Payroll, Team.Payroll[order(-Payroll),])
    
    }
    
    
    labels <- unique(Team.Payroll$Franchise.ID)
        
    Team.Payroll$Franchise.ID <- factor(Team.Payroll$Franchise.ID, level=labels)
    
    ggplot(data=Team.Payroll, aes(Franchise.ID,(Payroll/1000000))) +
    
    geom_point(aes(colour=Franchise.ID),size=4) + 
    
    geom_hline(yintercept=(mean(Team.Payroll$Payroll)/1000000)) +
    
    labs(y = "Team Salaries in Millions of Dollars",
         x = "Team") +
    
    scale_y_continuous(
      breaks=ifelse(Team.Payroll$Year < 1991, seq(0, 30, 2.5), 
                    ifelse(Team.Payroll$Year < 1998, seq(0, 70, 5),
                           ifelse(Team.Payroll$Year < 2003, seq(0, 100, 10),
                                  seq(0, 300, 25))))) +
    
    scale_colour_manual(values=colors,
                    guide = guide_legend(nrow=15)) +
    
    theme_pander()
  })
  
  

  output$plot2 <- renderPlot({

    Team.Payroll <- Team.Payroll[Team.Payroll$Team == input$Team, c("Year", "Team", "Payroll", "Wins", "Franchise.ID")]
    
    ggplot(data=Team.Payroll, aes(Year,(Payroll/1000000))) +
      
      geom_line(aes(colour=Franchise.ID)) +
      
      geom_point(aes(colour=Franchise.ID),size=4) +
      
      scale_colour_manual(values=colors) +
      
      scale_x_continuous(breaks=pretty_breaks(n=10), limits=c(input$slider[1],input$slider[2])) +
      
      labs(y = "Salary in Millions of Dollars",
           x = "Year") +
      
      theme_hc()

  })
  
  output$table <- DT::renderDataTable({
    DT::datatable(Team.Payroll, rownames=F) %>% DT::formatCurrency("Payroll", currency = "$", interval = 3, mark = ",")
  })
  
})
