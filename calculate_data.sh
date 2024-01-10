#!/bin/bash

prompt="The csv table describing when a shared car was used by whom and what the milage was. The table has 4 columns. The first column indicates the date in the european date format \"day.month.year\". The year is formated using two digits only, 23 means 2023 and 24 means 2024. The second column represents the name of the two drivers, either Eva or Markus. The third column is the milage in Kilometer. The last column is for comments. The driver noted the mileage of the car after the ride. Each row is one ride. The first ride is the start. Calculate how many km each ride was by calculating the differenze to the milage before. Now we now the km per ride and who was the driver. print this as a table and also calculate the total of km per ride by driver. Do the calculation by yourself. Don't suggest code that can do the calculation." 

aichat --model openai:gpt-4 -f cleaned.csv -- .set temperature 0 $prompt 

