# Use a fluid Bootstrap layout
fluidPage(
  # page title
  title = "National Park Trails",
  # create grid layout row with 2 columns
  fluidRow(
    # create first column
    column(3,
      # display page title      
      h3("US National Park Trails"),
      # create select input for national park name
      selectInput("park", "park:", choices = parks[1]),
      # create input for trail name in national park
      selectInput("trail", "trail:", choices = ""),
      # slider input for trail length difficulty 
      sliderInput("difficulty", "difficulty:",
                  min = min(dataset$difficulty_rating), max = max(dataset$difficulty_rating),
                  # starts w/ all difficulties (1 - 7)
                  value = 7, step = 1),
      # display data source info
      helpText("National Park trail data from AllTrails")
    ),
    # create second wider column for outputs
    column(9,
      br(), 
      # output longest trail at park
      verbatimTextOutput('trailOutput1'),
      # output shortest trail at park
      verbatimTextOutput('trailOutput2'),
      hr(),
      h4("Selected trail"), 
      # output selected trail info 
      htmlOutput('trailOutput3')
           )
  ),
  # create bottom row for graph output
  fluidRow(
    plotOutput('trailsPlot')
  )
)

