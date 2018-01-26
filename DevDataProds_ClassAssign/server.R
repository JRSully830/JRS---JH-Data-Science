library(shiny);library(randomForest);library(caret);library(rpart);
            library(tidyverse)
  data(iris)
  colnames(iris) <- c("SepalL","SepalW","PetalL","PetalW","Species")


shinyServer(function(input, output) {
  irism1 <- randomForest(Species~.,data=iris)

   ##irism2 <- rpart(Species~.,data=iris,method="class")
  irism2 <- lm(Species~.,data=iris,method="class")
  
   irisp1 <- reactive({
         SepLIn <- input$sliderSepalL
         SepWIn <- input$sliderSepalW
         PetLIn <- input$sliderPetalL
         PetWIn <- input$sliderPetalW
         predict(irism1,newdata=data.frame(SepalL=SepLIn,SepalW=SepWIn,
                  PetalL=PetLIn,PetalW=PetWIn),type="prob")
     
   
  })
  
  irisp2 <- reactive({
        SepLIn <- input$sliderSepalL
        SepWIn <- input$sliderSepalW
        PetLIn <- input$sliderPetalL
        PetWIn <- input$sliderPetalW
        predict(irism2, 
             newdata=data.frame(SepalL=SepLIn,SepalW=SepWIn,
                               PetalL=PetLIn,PetalW=PetWIn))
    
  
    })
  
  output$iplot1 <- renderPlot({
        SepLIn <- input$sliderSepalL
        SepWIn <- input$sliderSepalW
        PetLIn <- input$sliderPetalL
        PetWIn <- input$sliderPetalW
      
      
        irisdf1 <-gather(data.frame(irisp1()),key="Species",value="Prob")
        irisdf1$Modl <- "RandForest"
        
 
        irisdf2 <-gather(data.frame(irisp2()),key="Species",value="Prob")
        irisdf2$Modl <- "RegTree"
        
              irisFrm <- data.frame()
           
       if(input$showModel1 && input$showModel2){
           irisFrm <- rbind(irisdf1,irisdf2)
           } else {
                   if(input$showModel1) {
                         irisFrm <-  irisdf1
                         } else {
                                 if(input$showModel2) {
                                       irisFrm <-  irisdf2
                                                      }           
                                          }
                              }

        p<-ggplot(irisFrm, aes(x=Species, y=Prob, fill=Modl)) +
              geom_bar(stat="identity",position=position_dodge())+
              theme_minimal() +labs(fill="Model",y="Probability") +
              ggtitle("Iris Species Prediction and Probability") +
              theme(plot.title = element_text(hjust = 0.5))
        p
    
 
  })
  

  output$pred1 <- renderText({
    if(!input$showModel1){
         ""
        } else {  
       irisdf1 <-gather(data.frame(irisp1()),key="Species",value="Prob")
       maxprob1 <- max(irisdf1$Prob)
       irisdf1$Species[irisdf1$Prob == maxprob1]
      }
  })
  
  output$pred2 <- renderText({
        if(!input$showModel2){
              ""
        } else {  
        irisdf2 <-gather(data.frame(irisp2()),key="Species",value="Prob")
        maxprob2 <- max(irisdf2$Prob)
        irisdf2$Species[irisdf2$Prob == maxprob2]
        }
  })
})