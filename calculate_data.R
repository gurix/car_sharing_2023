# Read the data
df <- read.csv('cleaned.csv')

# Calculate the amount of km driven per row
df$diff <- c(0, diff(df$Km_End))

# Calculate the sum of driven km per driver
by(df$diff,df$FahrerIn, sum)

# Calculate the usages of driven km per driver
by(df$diff,df$FahrerIn, length)

write.csv(df, file="cleaned_with_difference.csv")