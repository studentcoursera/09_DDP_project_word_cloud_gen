library(shiny)
library(networkD3)

shinyUI(fluidPage(
    titlePanel("WORD CLOUD GENERATOR"),
    hr(),
    sidebarPanel(
        strong("You can:"),br(),
        em("1. Choose a file (only .txt files)."), br(),
        em("    File size: < 500 kb."), br(),
        em("2. Do other settings given below"),br(),br(),
        p("NOTE: By default, a dummy file is processed."),
        hr(),
        
        fileInput('txtfile', 'Choose text file'
                  ,accept=c(".txt")),
        sliderInput("min_freq",
                    "Minimum Frequency:",
                    min = 1,  max = 75, value = 25),
        sliderInput("max_wrds",
                    "Maximum Number of Words:",
                    min = 1,  max = 250,  value = 100), 
        sliderInput("rot", "Rotation of Words:",
                    min = 0.0, max = 1.0, value = 0.25),
        
        hr(),
        strong("The app displays:"), br(),
        code("1. Top 7 words frequency"), br(),
        em("[Download entire table]"), br(),
        code("2. The word cloud"),br(),
        em("[Download word cloud image]"), br(),
        code("for the file uploaded successfully.")
    ),
    
    mainPanel(
        tabsetPanel(
            tabPanel("Word Cloud Generator",
                     HTML("<html><table><tr><td>"), 
                     h3("Top 7 words"),
                     HTML('</td><td style="text-align:right">'), 
                     # CSV download button
                     downloadButton("freq_csv", "Download Freq CSV"),
                     HTML("</td></tr><tr><td colspan=2>"),
                     tableOutput("csvtable"),
                     HTML("</td></tr><tr><td><br><hr>"),
                     h3("Word cloud"),
                     HTML('</td><td style="text-align:right"><br><hr>'), 
                     # Image download button
                     downloadButton("wordcloud_img", "Download Image"),
                     HTML("</td></tr><tr><td colspan=2>"),
                     plotOutput("plot"),
                     HTML("</td></tr></table></html>")
            ),
            tabPanel("More Info",
                     
                     br(), strong("Limitations (future improvements):"), br(),
                     ("1. If the value chosen for 'Minimum Frequency' is above 
                            the maximum frequency,"),br(),
                     HTML("&nbsp;&nbsp;&nbsp;&nbsp;then, it defaults to 1."), br(),
                     ("2. By default, Shiny limits file uploads to 5MB per file."), br(),
                     HTML("&nbsp;&nbsp;&nbsp;&nbsp;But, this app further limits to 500 MB."),br(),
                     ("3. All delimiters are not recognised as word seperator."), br(),
                     HTML("&nbsp;&nbsp;&nbsp;&nbsp;So, you may see big words, with the delimiter removed."), br(),
                     ("4. The word cloud, tries to rotate and realign;"),br(),
                     HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;so, we notice the 'word cloud' moving."), br(),
                     ("5. Once you CANCEL while you 'choose file', the previously chosen filename goes off."),br(),
                     HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;so, we notice the 'word cloud' moving."),
                     br(),  hr(),
                     
                     strong("REFERENCES:"), br(),
                     ("1. Built this app by refering to shiny apps gallery 
                        'word cloud',  and added a few more features into it."),br(),
                     ("2. Download feature has been refered to 
                        'TrigonaMinima' code."),
                     
                     br(), hr(),
                     strong("Author:"), br(),                     
                     HTML("The app was created by Ambika J.
                     <br>Code @ <a href='https://github.com/studentcoursera/09_DDP_project_word_cloud_gen'
                         target='_blank'>word_cloud_gen</a>; Online app @ 
                         <a href='https://neo-r-apps.shinyapps.io/word_cloud_gen' 
                          target='_blank'>word_cloud_gen</a>"),
                     
                     br(), hr(),
                     strong("Demo app (Demo - Force Network):"), br(),
                     HTML("<UL><li>This demo 'Force Network' app is unrelated to word cloud generator.</li>
                          <li> This is  added to demo the network app. Just an additional app. </li>
                          <li> This is again    referenced from shiny app gallery; network d3. </li>
                          <li> If you click on this, while word cloud is getting generated, 
                          <br> &nbsp;&nbsp;you may experience a delay. </li>
                          <li> Only the first time, you can see the motion of the   n/w graph.</li></UL>") 
            ),
            tabPanel("Demo - Force Network", forceNetworkOutput("force"))
        )
    )))