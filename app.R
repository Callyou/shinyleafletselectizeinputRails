#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(DT) # for datatable filering
#library(rgdal) # to use kml Google earth file
library(leaflet)
library(sp)

# Read data from CSV file
#gares<-read.csv("./data/gares.csv", sep = ';')
prices<-read.csv("./data/prices.csv", sep = ';')
test3<-read.csv("./data/test3.csv", sep = ';')


# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Exploration des donnees de la SNCF"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
        fluidRow(
          column(6,
                 HTML("<font color='#33cc330'>Filtrer par</font>"), 
                 checkboxInput("tgv", "TGV", FALSE),
                 checkboxInput("ter", "TER", FALSE),
                 uiOutput("conditionalInput"),
                 selectizeInput("destinations", 
                                HTML("ARRIV\u00c9E"), 
                                choices = prices$destination, multiple = FALSE)
          )# column 1 end
      )
      )#sideBarpanel end
      ,
      
      # Show a plot of the generated distribution
      mainPanel(
        tabsetPanel(
          tabPanel('Resultats Origine Destination',  dataTableOutput("table")),
          tabPanel('Carte', leafletOutput("Map")),
          tabPanel('Idees supplementaires', includeHTML('runapp.html'))
          
        )# tabsetPanel end
      )# mainPanel end
)#sideBarLayout end
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
  # server begin
  # control the selectizeinput value destinations after selecting the origine
  
  # render the output selectizeInput
  output$conditionalInput <- renderUI({
    if(input$tgv){
      selectizeInput("origines", "DEPART",
                     choices = grep("TGV", test3$NomGare, value = TRUE))
    } 
    else if (input$ter){
      selectizeInput("origines", "DEPART",
                     choices = grep("TGV", test3$NomGare, value = TRUE, invert = TRUE))
    } 
    else if ((input$tgv) && (input$ter)){
      selectizeInput("origines", "DEPART",choices = test3$NomGare, multiple = FALSE)
    } else {
      selectizeInput("origines", "DEPART",choices = test3$NomGare, multiple = FALSE)
    }
  })
  
  observe({
      dataset<- test3[test3$NomGare == input$origines,]
      val<-dataset$vers
      updateSelectizeInput(session, "destinations", choices = dataset$vers)
  })
  # start map
  acm_defaults <- function(map, x, y) addCircleMarkers(map, x, y, radius=6, color="black", fillColor="red", fillOpacity=1, opacity=1, weight=2, stroke=TRUE, layerId="Selected")
  
  output$Map <- renderLeaflet({
    leaflet() %>% setView(lng = 2.82, lat = 47.53, zoom = 5) %>% addTiles() %>%
      addCircleMarkers(data=test3, radius=6, color="black", stroke=FALSE, fillOpacity=0.5, group="locations", layerId = ~NomGare, popup = ~NomGare)
  })
  observeEvent(input$Map_marker_click, { # update the map markers and view on map clicks
    p <- input$Map_marker_click
    proxy <- leafletProxy("Map")
    if(p$id=="Selected"){
      proxy %>% removeMarker(layerId="Selected")
    } else {
      proxy %>% setView(lng=p$lng, lat=p$lat, input$Map_zoom) %>% acm_defaults(p$lng, p$lat)
    }
  })
  
  observeEvent(input$Map_marker_click, { # update the location selectInput on map clicks
    p <- input$Map_marker_click
    if(!is.null(p$id)){
      if(is.null(input$origines) || input$origines!=p$id) updateSelectInput(session, "origines", selected=p$id)
    }
  })
  observeEvent(input$origines, { # update the map markers and view on location selectInput changes
    p <- input$Map_marker_click
    p2 <- subset(test3, test3$NomGare==input$origines)
    proxy <- leafletProxy("Map")
    if(nrow(p2)==0){
      proxy %>% removeMarker(layerId="Selected")
    } else if(length(p$id) && input$origines!=p$id){
      proxy %>% setView(lng=2.82, lat=47.53, input$Map_zoom) %>% acm_defaults(p2$long, p2$lat)
    } else if(!length(p$id)){
      proxy %>% setView(lng=2.82, lat=47.53, input$Map_zoom) %>% acm_defaults(p2$long, p2$lat)
    }
  })
  
  #output datatable table
  output$table <- renderDataTable({
    subset(prices,
           prices$origine == input$origines & prices$destination == input$destinations)
  }, 
  options = list(aLengthMenu = c(15, 20, 30, 50, 100), 
                 iDisplayLength = 20,
                 bAutoWidth = FALSE,
                 columnDef = list(list(width = "30px", targets = "_all"))
                 )
  )

} # server end

# Run the application 
shinyApp(ui = ui, server = server)