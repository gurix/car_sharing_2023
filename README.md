# Car Sharing Analysis AI Powered

## Background
I had the opportunity to use my neighbor's car, as they rarely used it. I have been able to use the car for the past six months whenever I need it. To avoid any conflicts or confusion, we decided to use the online platform https://www.weeshare.com to manage car reservations. After each ride, we simply write down the date and mileage in a pocket notebook that we leave in the car. This method has been quite effective.

## Digitalizing the Data
Now, the challenge lies in digitizing the handwritten table. Instead of manually typing down all 50 rows, I decided to employ artificial intelligence as a lazy software developer and AI enthusiast. I took photos of the table and used chatGPT to extract the data and combine it into one comprehensive table. However, as expected, it was not a simple task.

## 1. Extracting the Table from the Images
The table was not a single large entity but rather multiple pages within a booklet. Therefore, I had to take a photo of each page and instruct chatGPT to extract the data and merge everything into one cohesive table.

```sh
#!/bin/bash

files=$(ls Photos/*.jpg)

prompt="In the attachment are photos of a hand written table describing when a shared car was used by whom and what the milage was. The table has 4 columns. The first column indicates the date in the european date format \"day.month.year\". The year is formated using two digits only, 23 means 2023 and 24 means 2024. The second column represents the name of the two drivers, either Eva or Markus. The third column is the milage in Kilometer. The last column is for comments. Your job is it to read all tables, extract the data and combine it into one single table formated as CSV. Only return the blank CSV formated table."

aichat --model openai:gpt-4-vision-preview -f $files -- $prompt > raw.csv
``` 

There were several challenges I faced during this process. In order to obtain consistent results, I had to provide explicit instructions about the table structure in the prompt. Additionally, I had to clarify the date format and address the issue of two-digit years that were occasionally used.

In the end, I managed to obtain a mostly accurate table. However, the OCR (optical character recognition) did have some inaccuracies. As a result, I had to manually review the entire table and correct approximately 30% of the entries. After cleaning up the table, I created the `cleaned.csv` file containing the accurate data.

## 2. Calculating the Results

I utilized AI to calculate the results as well.

```sh
#!/bin/bash

prompt="The csv table describing when a shared car was used by whom and what the milage was. The table has 4 columns. The first column indicates the date in the european date format \"day.month.year\". The year is formated using two digits only, 23 means 2023 and 24 means 2024. The second column represents the name of the two drivers, either Eva or Markus. The third column is the milage in Kilometer. The last column is for comments. The driver noted the mileage of the car after the ride. Each row is one ride. The first ride is the start. Calculate how many km each ride was by calculating the differenze to the milage before. Now we now the km per ride and who was the driver. print this as a table and also calculate the total of km per ride by driver. Do the calculation by yourself. Don't suggest code that can do the calculation." 

aichat --model openai:gpt-4 -f cleaned.csv -- .set temperature 0 $prompt 
```

Similar to before, I provided a description of the table and the process. However, this time chatGPT encountered some difficulties in accurately calculating the results based on the provided instructions. To resolve this issue, I gave a hint on how to calculate the differences between each ride. Additionally, I explicitly instructed chatGPT to perform the calculations independently, rather than just suggesting a Python script for the task.

Result:
```
Datum,FahrerIn,Km pro Fahrt, Gesamt Km
03.09.23,Eva,-,0
04.09.23,Eva,37,37
05.09.23,Eva,36,73
...
28.12.23,Markus,2,630
29.12.23,Markus,45,675
01.01.24,Markus,121,796

Gesamt Km: Eva=1170, Markus=796
```

## 3. Verifying the Outcome
It is important to verify the results whenever AI is used. I achieved this by utilizing a simple R script that calculated the results in the same manner I expected from chatGPT.

```R
# Read the data
df <- read.csv('cleaned.csv')

# Calculate the amount of km driven per row
df$diff <- c(0, diff(df$Km_End))

# Calculate the sum of driven km per driver
by(df$diff,df$FahrerIn, sum)

# Calculate the usages of driven km per driver
by(df$diff,df$FahrerIn, length)

write.csv(df, file="cleaned_with_difference.csv")
```

Results:
```
> # Read the data
> df <- read.csv('cleaned.csv')
> 
> # Calculate the amount of km driven per row
> df$diff <- c(0, diff(df$Km_End))
> 
> # Calculate the sum of driven km per driver
> by(df$diff,df$FahrerIn, sum)
df$FahrerIn: Eva
[1] 1170
--------------------------------------------------------------------- 
df$FahrerIn: Markus
[1] 796
> 
> # Calculate the usages of driven km per driver
> by(df$diff,df$FahrerIn, length)
df$FahrerIn: Eva
[1] 30
--------------------------------------------------------------------- 
df$FahrerIn: Markus
[1] 20
> 
> write.csv(df, file="cleaned_with_difference.csv")
```

## Conclusion
OCR has its limitations. Although it successfully detected the table structure, the accuracy of number recognition was lacking. In the future, we can overcome this issue by improving handwriting legibility. Additionally, it is crucial to always double-check the calculations, as they can lead to inaccurate answers.
