#!/bin/bash

files=$(ls Photos/*.jpg)

prompt="In the attachment are photos of a hand written table describing when a shared car was used by whom and what the milage was. The table has 4 columns. The first column indicates the date in the european date format \"day.month.year\". The year is formated using two digits only, 23 means 2023 and 24 means 2024. The second column represents the name of the two drivers, either Eva or Markus. The third column is the milage in Kilometer. The last column is for comments. Your job is it to read all tables, extract the data and combine it into one single table formated as CSV. Only return the blank CSV formated table."

aichat --model openai:gpt-4-vision-preview -f $files -- $prompt > raw.csv

