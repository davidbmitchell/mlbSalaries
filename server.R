 
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(dplyr)
library(ggplot2)
library(scales)

shinyServer(function(input, output) {
  
  # Filter data based on selections
  output$plot <- renderPlot({ 
    
    sal <- read.csv('data/mlbSalaries.csv')
    
    sal <- sal[sal$year == input$year, c("year", "team", "name", "position", "salary")]
    
    team.sal <- setNames(aggregate(sal$salary,
                                   by=list(year = sal$year,
                                           team = sal$team
                                           ),
                                   FUN=sum),
                         c("year", "team", "salary"))  
    

    if(input$order == "Ascending") {
    
      team.sal <- with(team.sal, team.sal[order(salary),])
    
    } else {
      
        team.sal <- with(team.sal, team.sal[order(-salary),])
    
    }
    
    
    labels <- unique(team.sal$team)
        
    team.sal$team <- factor(team.sal$team, level=labels)
      
    colors <-
      c("ARI"="#A71930","ATL"="#002F5F","BAL"="#ED4C09","BOS"="#C60C38",
        "CHC"="#000000","CHW"="#003279","CIN"="#C6011F","CLE"="#003366",
        "COL"="#333366","DET"="#DE4406","HOU"="#FF7F00","KCR"="#74B4FA", # cin - kc
        "ANA"="#B71234","LAD"="#0836CB","FLA"="#F9423A","MIL"="#92754C",
        "MIN"="#072754","NYY"="#1C2841","NYM"="#FB4F14","OAK"="#003831",
        "PHI"="#BA0C2F","PIT"="#FD8829","SDP"="#84A76C","SEA"="#005C5C", # NYM - SEA
        "SFG"="#F2552C","STL"="#C41E3A","TBD"="#9ECEEE","TEX"="#BD1021",
        "TOR"="#003DA5","WSN"="#BA122B","MON"="#165B9E")# SF - WAS    
    
  # Plot that shit
    ggplot(data=team.sal, aes(team,(salary/1000000))) +
    
    geom_point(aes(colour=team),size=4) + 
    
    geom_hline(yintercept=(mean(team.sal$salary)/1000000)) +
    
    labs(y = "Team Salaries in Millions of Dollars",
         x = "Team") +
    
    scale_y_continuous(
      breaks=ifelse(team.sal$year < 1991, seq(0, 30, 2.5), 
                    ifelse(team.sal$year < 1998, seq(0, 70, 5),
                           ifelse(team.sal$year < 2003, seq(0, 100, 10), seq(0, 300, 25)
                          )
                    )
              )
    ) +
    
    scale_colour_manual(values=colors,
                        guide = guide_legend(nrow=15))
  })
  
  

  output$plot2 <- renderPlot({

    sal <- read.csv('data/mlbSalaries.csv')

    sal <- sal[sal$team == input$team, c("year", "team", "name", "position", "salary")]
    
    year <- as.numeric(unique(sal$year))
    
    year <- input$year
    
    team.sal <- setNames(aggregate(sal$salary,
                               by=list(year = sal$year,
                                       team = sal$team),
                               FUN=sum),
                     c("year", "team", "salary")) 
    
    colors <-
      c("ARI"="#A71930","ATL"="#002F5F","BAL"="#ED4C09","BOS"="#C60C38",
        "CHC"="#000000","CHW"="#003279","CIN"="#C6011F","CLE"="#003366",
        "COL"="#333366","DET"="#DE4406","HOU"="#FF7F00","KCR"="#74B4FA", # cin - kc
        "ANA"="#B71234","LAD"="#0836CB","FLA"="#F9423A","MIL"="#92754C",
        "MIN"="#072754","NYY"="#1C2841","NYM"="#FB4F14","OAK"="#003831",
        "PHI"="#BA0C2F","PIT"="#FD8829","SDP"="#84A76C","SEA"="#005C5C", # NYM - SEA
        "SFG"="#F2552C","STL"="#C41E3A","TBD"="#9ECEEE","TEX"="#BD1021",
        "TOR"="#003DA5","WSN"="#BA122B","MON"="#165B9E")
    
    ggplot(data=team.sal, aes(year,(salary/1000000))) +
      
      geom_line(aes(colour=team)) +
      
      geom_point(aes(colour=team),size=4) +
      
      scale_colour_manual(values=colors) +
      
      scale_x_continuous(breaks=pretty_breaks(n=10), limits=c(input$slider[1],input$slider[2])) 

  })
  
})
