

shinyServer(function(input, output) {
  
  output$mytable <- DT::renderDataTable({
    tmp <- data.frame(df[which(df[,1] == as.character(as.factor(input$Indicator))),])
    tmp <- tmp[,c(3,46 - (2015 - input$Year))]
    colnames(tmp) <- c("Country",input$Indicator)
    rownames(tmp) <- NULL
    tmp <- na.omit(tmp)
    DT::datatable(tmp)
  })
  
  
  output$myChart1 <- renderChart2({
    
    tmp <- data.frame(df[which(df$Country==as.character(as.factor(input$country))),])
  
    
    colnames(tmp) <- substr(colnames(tmp), 2, 5)
    colnames(tmp)[1] <-  "Series_Name"
    colnames(tmp)[2] <-  "Series_Code"
    colnames(tmp)[3] <-  "Country"
    colnames(tmp)[4] <-  "Country_Code"
    
    tmp <- tmp[which(tmp$Series_Name==as.character(as.factor(input$Indicator))),]
    
    if(input$Indicator == "Population, total")
      tmp[2:ncol(tmp)] <- tmp[2:ncol(tmp)]/1000000
      
    tmp <- tmp[-c(2:11)]
    tmp[tmp == ".."] <- 0
    
    
    X <- data.frame(cbind(year = as.integer(colnames(tmp)[2:ncol(tmp)]),
                          X = as.double(t(tmp[1,2:ncol(tmp)]))), rep(input$country, ncol(tmp)-1))
    colnames(X) <- c("year","x", "country")
    x1 <- which(X$x!=0,arr.ind = T)
    
    if (length(x1) != 0)
      X <- X[c(x1[1]:x1[length(x1)]),]
    
    
    
    p1 <- nPlot(x ~ year, X, group = c("Type"), type = 'multiBarChart') 
      
    p1$chart(reduceXTicks = FALSE)
    p1$xAxis(staggerLabels = TRUE)
    if(input$Indicator == "Population, total")
        p1$yAxis(axisLabel = paste(input$Indicator," (Million) "), width = 50)
    else 
        p1$yAxis(axisLabel = paste(input$Indicator," "), width = 50)
    
    p1$chart(tooltipContent = "#! function(key, x, y, e ){ 
    var d = e.series.values[e.pointIndex];
             return    d.country + ': ' + y
    } !#")
    return(p1)
    
  })
  
  
  output$myChart3 <- renderPlotly({
    
    
    tmpx <- data.frame(df[which(df[,1] == as.character(as.factor(input$Axisx))),])
    tmpy <- data.frame(df[which(df[,1] == as.character(as.factor(input$Axisy))),])
    tmpx[tmpx == ".."] <- ""
    tmpy[tmpy == ".."] <- ""
    
    
    
    for(i in 1:nrow(tmpx)){
      tmpx$mean[i] <- mean(as.numeric(apply(tmpx[i,6:ncol(tmpx)], 2, function(x) gsub("^$|^ $", NA, x))),
                           na.rm = T)
      tmpy$mean[i] <- mean(as.numeric(apply(tmpy[i,6:ncol(tmpy)], 2, function(x) gsub("^$|^ $", NA, x))),
                           na.rm = T)
      
    }
    reg <- data.frame(tmpx$mean,tmpy$mean, tmpx[,3])
    colnames(reg) <- c("meanx", "meany","country")
    
    
    p <- ggplot(data = reg, aes(x = meanx, y = meany, label=country))+ 
      geom_point(size=3, alpha=0.6 , label = "d.country")+
      #geom_point(size=3, alpha=0.6 , aes(reg$country))+
      labs(x = paste(input$Axisx, " "), 
           y = paste(input$Axisy, " "), width = 50)
    
    
    ggplotly(p)
  })
  
 
  
  
  output$text1 <- renderText({ 
    
      
      "For each selected country, you can find the available values of the chosen indocator over the years in the graph."
  })
  
  output$text3 <- renderText({ 
    "For each pair of indicators, you can see the scatterplot of average values over the years in the graph. Each point represents a specific country."
  })
  output$text4 <- renderText({ 
    paste ("Year:", input$Year)
  })
})

