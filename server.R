library(shiny)
library(tm)
library(wordcloud)
library(memoise)
library(networkD3)
library(rCharts)

#options(shiny.maxRequestSize = 30*1024^2) #30MB; shiny default is 5MB.
#options(shiny.maxRequestSize = -1) #Large files
options(shiny.maxRequestSize = 0.25*1024^2) #0.5MB; shiny default is 5MB.

# This is for network graph.
# As this needs to be in data frame format, etc., 
# it should be called this way.
data(MisLinks)
data(MisNodes)

shinyServer(function(input, output, session) {
    
    # Using "memoise" to automatically cache the results
    getTermMatrix <- memoise(function(txt) {
        #text <- readLines(txtfile, encoding="UTF-8")

        toSpace <- content_transformer(function (x , pattern ) gsub(pattern, " ", x))
                
        words <- Corpus(VectorSource(txt))
        words <- tm_map(words, content_transformer(tolower))
        #inspect(words)
        words <- tm_map(words, toSpace, "[[:punct:]]+")
        #words <- tm_map(words, removePunctuation)
        words <- tm_map(words, removeNumbers)
        words <- tm_map(words, removeWords,
                       c(stopwords("SMART"), "man", "men"))
        
        termsMatrix = TermDocumentMatrix(words, control = list(minWordLength = 1))
        
        m = as.matrix(termsMatrix)
        
        sort(rowSums(m), decreasing = TRUE)
    })
    
    # Define a reactive expression for the document term matrix
    terms <- reactive({
        infile <- input$txtfile
        
        withProgress({
            if (is.null(infile)) {
                setProgress(message = "Processing dummy file's corpus...")
                text <- readRDS("./data/dummy.rds")
            }
            else {
                setProgress(message = "Processing uploaded file's corpus...")
                text <- readLines(infile$datapath, encoding="UTF-8")
            }
            getTermMatrix(text)
        })
        
    })
    
    # Make the wordcloud drawing predictable during a session
    wordcloud_rep <- repeatable(wordcloud)
    
    build_word_cloud <- function() {
        v <- terms()
        wordcloud_rep(names(v), v, scale=c(4,0.5),
                      min.freq = input$min_freq, max.words = input$max_wrds,
                      rot.per = input$rot, random.order = F,
                      colors = brewer.pal(8, "Dark2"))
    }
    
    output$plot <- renderPlot({
        build_word_cloud()
    })
    
    image_word_cloud <- function() {
        png("wordcloud.png", width=10, height=8, units="in", res=350)
        build_word_cloud()
        dev.off()
        filename <- "wordcloud.png"
    }
    
    output$analysis <- renderChart2({
        words <- data.frame(freq=terms())
        #words <- data.frame(freq=getTermMatrix("data/dummy.txt"))
        word_list <- data.frame(wrds=row.names(words), freq=words$freq)
        t1 <- cbind(word_list[grep("[a-e]",substring(word_list$wrds, 1, 1)),],grp=1)
        t1 <- rbind(t1, cbind(word_list[grep("[f-j]",substring(word_list$wrds, 1, 1)),],grp=2))
        t1 <- rbind(t1, cbind(word_list[grep("[k-o]",substring(word_list$wrds, 1, 1)),],grp=3))
        t1 <- rbind(t1, cbind(word_list[grep("[p-t]",substring(word_list$wrds, 1, 1)),],grp=4))
        t1 <- rbind(t1, cbind(word_list[grep("[u-z]",substring(word_list$wrds, 1, 1)),],grp=5))
        
        sorted_t1 <- t1[order(t1$freq, decreasing = TRUE),]
        n1 <- nPlot(freq ~ grp, group = 'wrds', type = 'multiBarChart', data = sorted_t1[1:7,])
        n1$set(width = 500)
        return(n1)
        #n1$print('chart')
        #n1$show("inline", include_assets = TRUE, cdn = F)
    })
    
    # Download handler for the image.
    output$wordcloud_img <- downloadHandler(
        #filename = "wordcloud.png",
        filename <- function() { paste(input$txtfile, "wordcloud", ".png", sep="") },
        content = function(filename) {
            file.copy(image_word_cloud(), filename)
        })
    
    output$freq_csv <- downloadHandler(
        #filename = "freq.csv",
        filename <- function() { paste(input$txtfile, "freq", ".csv", sep="") },
        content = function(filename) {
            write.csv(terms(), filename)
        })
    
    output$csvtable <- renderTable({
        if(length(t(terms())) < 7) max <- length(t(terms()))
        else max <- 7
        words <- data.frame(cbind(terms())[1:max,])
        colnames(words) <- "freq"
        t(words)
    })
    
    output$force <- renderForceNetwork({
        forceNetwork(Links = MisLinks, Nodes = MisNodes,
                     Source = "source", Target = "target",
                     Value = "value", NodeID = "name",
                     Group = "group", opacity = input$opacity)
    })

})