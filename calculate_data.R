df <- read.csv('cleaned.csv')
start_milage = min(df$Km_End)
df$diff <- c(0, diff(df$Km_End))

