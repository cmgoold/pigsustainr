require(shiny)
require(shinythemes)

shinyUI( 
   fluidPage(
        theme = shinytheme("darkly"), 
        titlePanel("PigSustainR Shiny App"), 

        tabsetPanel(
            type = "tabs", 
                tabPanel(
                 title="Introduction", 
                 includeMarkdown("markdown/introduction.Rmd")
                ),#introduction panel 
                tabPanel(
                  title="Model setup"
                  ),# model setup panel 
                tabPanel(
                  title="Run model"
                  )#run model panel
           ) 
   )#fluid page
)#shiny ui

