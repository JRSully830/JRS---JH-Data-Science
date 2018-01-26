library(shiny)
shinyUI(fluidPage(
  titlePanel("Flower species prediction based on flower stats"),
             
  sidebarLayout(
    sidebarPanel(
          helpText("USAGE HINTS: Use slide bars and SUBMIT button to set flower 
                  stats. Iris species probabilities are displayed in bar graph. 
                  Most likely Iris species indicated below graph."),
      sliderInput("sliderSepalL", "Flower Sepal Length?", 4, 8, value = 5),
      sliderInput("sliderSepalW", "Flower Sepal Width?", 1.8, 5, value = 3),
      sliderInput("sliderPetalL", "Flower Petal Length?", 0.8, 7.5, value = 5),
      sliderInput("sliderPetalW", "Flower Petal Width?", 0.1, 2.8, value = 1.5),
      checkboxInput("showModel1", "Show/Hide Random Forest Model", value = TRUE),
      checkboxInput("showModel2", "Show/Hide Regression Tree Model", value = TRUE),
      submitButton("Submit")
    ),
    mainPanel(
      plotOutput("iplot1"),
      h3("Predicted Species from Random Forest:"),
      textOutput("pred1"),
      h3("Predicted Species from Simple Regression Tree:"),
      textOutput("pred2")
    )
  )
))