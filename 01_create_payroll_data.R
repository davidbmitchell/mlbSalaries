library(data.table)
# Import the Lahman Salary csv into data.table
Salaries <- data.table(read.csv("Salaries.csv"))

# Aggregate Salaries by Team
Team.Payroll <- Salaries[, .(salary = sum(salary)), by=.(yearID, teamID)]

# Import Lahman Team csv into data.table
Teams <- data.table(read.csv("Teams.csv"))
# subset the teams data.table by yearID, teamID, franchID, name, W
Teams <- Teams[,.(yearID, teamID, franchID, name, W)]

# set the keys to be used when merging the data.tables
setkey(Teams, teamID, yearID)
setkey(Team.Payroll, teamID, yearID)

Team.Payroll <- merge(Team.Payroll, Teams)

# Drop the teamID as we will be using the franchID
Team.Payroll[, teamID := NULL]

setnames(Team.Payroll, c("yearID", "salary", "franchID", "name", "W"),
         c("Year", "Payroll", "Franchise.ID", "Team", "Wins"))

setcolorder(Team.Payroll, c("Year", "Team", "Payroll", "Wins", "Franchise.ID"))

# The Lahman files used have the Chicago Cubs and Chicago White Sox team names
# flipped so we have to fix them, but its easy

Team.Payroll[c(186:187),4] <- "Chicago Cubs"
Team.Payroll[c(156:157),4] <- "Chicago White Sox"

# Convert Team.Payrolls to data.frame so it will play nicely with shiny
Team.Payroll <- data.frame(Team.Payroll)

# save the Team.Payroll to rds
saveRDS(Team.Payroll, "data/Team.Payroll.rds")

