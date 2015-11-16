library(tm)
library(wordcloud)
library(memoise)

#options(shiny.maxRequestSize = 30*1024^2) #30MB; shiny default is 5MB.
#options(shiny.maxRequestSize = -1) #Large files
options(shiny.maxRequestSize = 0.5*1024^2) #1MB; shiny default is 5MB.

function(input, output, session) {
    
    # Using "memoise" to automatically cache the results
    getTermMatrix <- memoise(function(txtfile) {
        text <- readLines(txtfile, encoding="UTF-8")
        
        words = Corpus(VectorSource(text))
        words = tm_map(words, content_transformer(tolower))
        words = tm_map(words, removePunctuation)
        words = tm_map(words, removeNumbers)
        words = tm_map(words, removeWords,
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
                getTermMatrix("./data/dummy.txt")
            }
            else {
                setProgress(message = "Processing uploaded file's corpus...")
                getTermMatrix(infile$datapath)   
            }
        })
    })
    
    # Make the wordcloud drawing predictable during a session
    wordcloud_rep <- repeatable(wordcloud)
    
    build_word_cloud <- function() {
        v <- terms()
        wordcloud_rep(names(v), v, scale=c(4,0.5),
                      min.freq = input$min_freq, max.words = input$max_wrds,
                      rot.per = input$rot,
                      colors=brewer.pal(8, "Dark2"))
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
}