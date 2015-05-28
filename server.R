 
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(ggplot2)
library(ggthemes)
library(scales)

team.sal <- readRDS("data/Team.Salaries.rds")
colors <-
  c("ARI"="#A71930","ATL"="#002F5F","BAL"="#ED4C09","BOS"="#C60C38",
    "CHN"="#000000","CHA"="#003279","CIN"="#C6011F","CLE"="#003366",
    "COL"="#333366","DET"="#DE4406","HOU"="#FF7F00","KCA"="#74B4FA", # cin - kc
    "LAA"="#B71234","LAN"="#0836CB","MIA"="#F9423A","MIL"="#92754C",
    "MIN"="#072754","NYA"="#1C2841","NYN"="#FB4F14","OAK"="#003831",
    "PHI"="#BA0C2F","PIT"="#FD8829","SDN"="#84A76C","SEA"="#005C5C", # NYM - SEA
    "SFN"="#F2552C","SLN"="#C41E3A","TBA"="#9ECEEE","TEX"="#BD1021",
    "TOR"="#003DA5","WAS"="#BA122B","MON"="#165B9E", "CAL" = "#C4023C",
    "ML4" = "#043EA4", "FLO" = "#04A6B4", "ANA" = "#B71234")

shinyServer(function(input, output) {
  
  # Filter data based on selections
  output$plot <- renderPlot({ 
    
    team.sal <- team.sal[team.sal$year == input$year, c("year", "team", "salary", "name")]

    if(input$order == "Ascending") {
    
      team.sal <- with(team.sal, team.sal[order(salary),])
    
    } else {
      
        team.sal <- with(team.sal, team.sal[order(-salary),])
    
    }
    
    
    labels <- unique(team.sal$team)
        
    team.sal$team <- factor(team.sal$team, level=labels)
    
    ggplot(data=team.sal, aes(team,(salary/1000000))) +
    
    geom_point(aes(colour=team),size=4) + 
    
    geom_hline(yintercept=(mean(team.sal$salary)/1000000)) +
    
    labs(y = "Team Salaries in Millions of Dollars",
         x = "Team") +
    
    scale_y_continuous(
      breaks=ifelse(team.sal$year < 1991, seq(0, 30, 2.5), 
                    ifelse(team.sal$year < 1998, seq(0, 70, 5),
                           ifelse(team.sal$year < 2003, seq(0, 100, 10),
                                  seq(0, 300, 25))))) +
    
    scale_colour_manual(values=colors,
                    guide = guide_legend(nrow=15)) +
    
    theme_pander()
  })
  
  

  output$plot2 <- renderPlot({

    team.sal <- team.sal[team.sal$name == input$name, c("year", "team", "salary", "name")]
    
    ggplot(data=team.sal, aes(year,(salary/1000000))) +
      
      geom_line(aes(colour=team)) +
      
      geom_point(aes(colour=team),size=4) +
      
      scale_colour_manual(values=colors) +
      
      scale_x_continuous(breaks=pretty_breaks(n=10), limits=c(input$slider[1],input$slider[2])) +
      
      labs(y = "Salary in Millions of Dollars",
           x = "Year") +
      
      theme_hc()

  })
  
})
