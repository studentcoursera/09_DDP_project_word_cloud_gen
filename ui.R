library(shiny)
library(networkD3)
library(rCharts)
library(markdown)

shinyUI(navbarPage(HTML("<p style='color:darkorange'>
                        <img src='word_cloud_logo.png', align='center', width=50, height=35>
                        WORD CLOUD GENERATOR
                        </img></p>"),
            tabPanel("App",
                sidebarPanel(
                    br(),
                    em("    File size: < 250 kb."),br(),
                    fileInput('txtfile', 'Choose a file (only .txt files).'
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
                    p("NOTE: By default, a dummy file is processed.
                      "),
                    hr(),
                    strong("The app displays:"), br(),
                    code("1. Top 7 words frequency"), br(),
                    em("[Download entire table]"), br(),
                    code("2. The word cloud"),br(),
                    em("[Download word cloud image]"), br(),
                    code("for the file uploaded successfully.")
                ),
                mainPanel(
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
                    downloadButton("wordcloud_img", "Download png Image"),
                    HTML("</td></tr><tr><td colspan=2>"),
                    plotOutput("plot"),
                    HTML("</td></tr></table></html>"))
            ),
            tabPanel("Analysis", 
                sidebarPanel(
                    hr(),
                    HTML("<p>Grouped into 5 groups; based on starting alphabet
                         of every word, for a better perspective. <br>
                         1 -> a, b, c, d e <br>
                         2 -> f, g, h, i, j <br>
                         3 -> k, l, m, n, o <br>
                         4 -> p, q, r, s, t <br>
                         5 -> u, v, w, x, y, z
                         </p>"), hr(),

                    HTML('<p>Also, there are 2 views "Grouped" and "Stacked". 
                            You can switch between these 2 views.</p>'),
                    
                    HTML('<p> The words that are shown on legend can also be
                         toggled. Each toggle, switches ON/OFF that word.</p>'),
                    
                    HTML('<p> Hover over the bars, to see the [word, value and group].
                         Stacked view also gives you totals.</p>')
                ),
                    
                mainPanel(h2("An analysis of top 7 frequencies"), hr(),
                    chartOutput("analysis", "nvd3")
                    #showOutput("analysis", "polycharts") #"morris", "polycharts", "nvd3
                    #showOutput("analysis", "nvd3")
                )
            ),
            tabPanel("App details", 
                sidebarPanel(
                    HTML("<h2>About <img src='word_cloud_logo.png', align='right', 
                        width=150, height=100></img></h2>"),
                    hr(),
                    includeMarkdown("about.md")
                ),    
                mainPanel(
                    includeMarkdown("more_info.md")            
                )
            ),
            tabPanel("DEMO: Force Network",
                sidebarPanel(
                    br(),
                    sliderInput("opacity", "Opacity", 0.6, min = 0.1,
                                max = 1, step = .1),
                    br(), hr(),
                    strong("Demo app (Demo - Force Network):"), br(),
                    HTML("<UL><li>This demo 'Force Network' app is unrelated to
                    word cloud generator.</li>
                        <li> This is  added to demo the network app. Just an 
                             additional app. </li>
                        <li> This is again    referenced from shiny app 
                            gallery; network d3. </li>
                        <li> If you click on this, while word cloud is getting
                            generated, 
                        <br> &nbsp;&nbsp;you may experience a delay. </li>
                        <li> Only the first time, you can see the motion of 
                            the n/w graph or when you change opacity.</li></UL>")), 
                mainPanel(
                    HTML("<center>Hover over the nodes to see the name of the 
                         node.</center>"), br(),
                    forceNetworkOutput("force"))
            )
))