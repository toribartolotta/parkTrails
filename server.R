# Define a server for the Shiny app
function(input, output, session) {
  
  updateSelectizeInput(session, "park", "park:", 
                       choices = parks, server = TRUE)
  
  # Fill in the spot created for a plot
  output$trailsPlot <- renderPlot({
    
    # get selected park name
    parkInput = input$park
    
    # create data frame with results for selected national park and difficulty ratings
    df <- dataset %>% filter(area_name == parkInput, difficulty_rating <= input$difficulty) %>%
      group_by(name) %>% group_by(n = length)
    
    # update trail input with selected park trails
    updateSelectizeInput(session, "trail", "trail:",
                         choices = sort(df$name), server = TRUE)
    
    # generate a bar graph of trail lengths for all trails in national park
    main <- paste0("Trail lengths in ", parkInput)
    # set bottom, left, top, right margins for graph
    # to keep trail names from being cut off at bottom 
    par(mar=c(10,5,1,1)) 
    barplot(df$n, names.arg = df$name, col = "pink",
            ylab = "length (m)",
            main = main, las = 2,
            axis.lty = 1)
    
  })
  
# output 1: longest trail in park  
  output$trailOutput1 <- renderText({
    
    # find trail names and lengths for park
    dfTrailLength <- dataset %>% filter(area_name == input$park) %>%
      group_by(name) %>% group_by(n = length)
 
    # find longest trail name in park 
    w <- which.max(dfTrailLength$length)
    longestTrail <- dfTrailLength$name[w]
    
    # find length of longest trail in meters
    longestLength <- round(dfTrailLength$length[w], digits=2)
    
    # convert longest trail to miles
    longestMiles <- round(longestLength/1609, digits=2)
    
    # create output
    paste('Longest trail:', longestTrail, '--', longestLength, 'meters, or', longestMiles, 'miles')
  })
  
  
  # output 2: shortest trail in park
  output$trailOutput2 <- renderText({
    
    # find trail names and lengths for park
    dfTrailLength <- dataset %>% filter(area_name == input$park) %>%
      group_by(name) %>% group_by(n = length)
    
    # find shortest trail name
    m <- which.min(dfTrailLength$length)
    shortTrail <- dfTrailLength$name[m]
    
    # find length of shortest trail in meters
    shortestLength <- round(dfTrailLength$length[m], digits=2)
    
    # convert shortest trail to miles
    shortestMiles <- round(shortestLength/1609, digits=2)
    
    # create output
    paste('Shortest trail:', shortTrail, '--', shortestLength, 'meters, or', shortestMiles, 'miles')
  })
  
  # output 3: selected trail info
  output$trailOutput3 <- renderText({
    
    # find selected trail in selected national park 
    dfSelectedTrail <- dataset %>% filter(area_name == input$park, name == input$trail)
    
    # output trail name, park name, state, trai length, difficulty (1-7), trail type, avg. user rating / 5
    paste('<b>Trail name:</b>', input$trail, '<br/>
          <b>Park:</b>', input$park, '<br/>
          <b>State:</b>', dfSelectedTrail$state, '<br/>
          <b>Length:</b>', round(dfSelectedTrail$length, digits=2), 'meters, or', round(dfSelectedTrail$length/1609, digits=2), 'miles <br/>
          <b>Difficulty:</b>', dfSelectedTrail$difficulty_rating, '<br/>
          <b>Trail type:</b>', dfSelectedTrail$route_type, '<br/>
          <b>Average rating:</b>', dfSelectedTrail$avg_rating, '/ 5'
          )
  })
}



