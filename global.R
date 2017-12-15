if("shiny" %in% rownames(installed.packages()) == FALSE) {install.packages("shiny")}
#if("rNVD3" %in% rownames(installed.packages()) == FALSE) {install.packages("rNVD3")}
if("devtools" %in% rownames(installed.packages()) == FALSE) {install.packages("devtools")}
if("data.table" %in% rownames(installed.packages()) == FALSE) {install.packages("data.table")}
if("ggplot2" %in% rownames(installed.packages()) == FALSE) {install.packages("ggplot2")}
if("plotly" %in% rownames(installed.packages()) == FALSE) {install.packages("plotly")}
if("DT" %in% rownames(installed.packages()) == FALSE) {install.packages("DT")}
if("rCharts" %in% rownames(installed.packages()) == FALSE) {require(devtools)
  install_github('rCharts', 'ramnathv')}

library(googleVis)
library(shiny)

library(rCharts)
#require(rNVD3)

library(data.table)
library(ggplot2)
library(plotly)
library(tibble)

data_file <- file.path("data", "data1.csv") 
df <- read.csv(data_file, header=T, sep=",")
dic_file <- file.path("data", "data-dic.csv") 
df_dic <- read.csv(dic_file, header=T, sep=",")


ind <- data.frame(ind = df_dic$Indicator.Name[3:nrow(df_dic)])
inputInd <- data.frame(ind = ind[-c(24,25),])
axis <- data.frame(ind = ind[-c(9,10,11,24,25),])