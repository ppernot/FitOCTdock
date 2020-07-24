
navbarPage(
  title = 'FitOCT',
  # Config ####
  theme = shinythemes::shinytheme(c("cosmo","cerulean",
                                    "spacelab","yeti")[2]),
  tabPanel(
    # Noise + Exp ####
    title = 'Noise + Exp.',
    sidebarLayout(
      sidebarPanel(
        fileInput(
          inputId = 'dataFile',
          label   = 'Select data file',
          multiple= FALSE,
          accept  = c('.txt','.csv')
        ),
        radioButtons(
          inputId = 'dataType',
          label   = 'Data type',
          choices = c('Amplitude' = 1,
                      'Intensity' = 2),
          selected = 2,
          inline = TRUE
        ),
        hr(style="border-color: #666;"),
        sliderInput(
          inputId = 'depthSel',
          label   = 'Select depth range',
          min = 0,
          max = 1,
          value = c(0,1),
          sep = ''
        ),
        sliderInput(
          inputId = 'subSample',
          label   = 'Sub-sample factor',
          min   = 1,
          max   = 10,
          value = 1,
          step  = 1,
          sep = ''
        ),
        hr(style='border-color: #666;'),
        tabsetPanel(
          tabPanel(
            title = 'Noise',
            wellPanel(
              sliderInput(
                inputId = 'smooth_df',
                label   = 'Smoothing level',
                min     = 2,
                max     = 30,
                value   = 15
              ),
              verbatimTextOutput(
                'resNoise'
              )
            )
          ),
          tabPanel(
            title = 'MonoExp',
            verbatimTextOutput(
              'resMonoExp'
            )
          ),
          type = 'pills',
          selected = 'MonoExp'
        )
      ),
      mainPanel(
          wellPanel(
            h4("Noise estimation: uy(x) = a_1 * exp( -depth / a_2 )"),
            plotOutput(
              outputId = 'plotNoise',
              height   = '300px'
            )
          ),
          wellPanel(
            h4("Monoexponential fit: y(x) = b_1 + b_2 * exp( -c*depth / b_3 )"),
            plotOutput(
              outputId = 'plotMonoExp',
              height = '300px'
            )
          )
      )
    )
  ),
  tabPanel(
    # Modulation ####
    title = 'Modulation',
    sidebarLayout(
      sidebarPanel(
        h4('Bayesian Inference'),
        wellPanel(
          fluidRow(
            column(
              width = 7,
              radioButtons(
                inputId = 'method',
                label   = 'Method',
                choices = c(M.A.P. = 'optim',
                            Sample = 'sample'),
                selected = 'optim',
                inline = FALSE
              )
            ),
            column(
              width = 3,
              actionButton(
                inputId = 'runExpGP',
                strong("Run"),
                icon=icon('gear')
              ),
              tags$style(type='text/css',
                         "#runExpGP {margin-top: 0px;}")
            )
          ),
          conditionalPanel(
            condition = "input.method == 'sample'",
            fluidRow(
              column(
                width = 5,
                numericInput(
                  "nb_warmup",
                  label='nb_warmup',
                  value = 500,
                  min = 100,
                  max = 5000,
                  step = 100,
                  width = "100px"
                )
              ),
              column(
                width = 5,
                numericInput(
                  "nb_sample",
                  label='nb_sample',
                  value = 500,
                  min = 100,
                  max = 10000,
                  step = 100,
                  width = "100px"
                )
              )
            )
          )
        ),
        hr( style="border-color: #666;"),
        h4('Controls'),
        tabsetPanel(
          tabPanel(
            title = 'Prior-Exp',
            wellPanel(
              fluidRow(
                column(
                  width = 6,
                  radioButtons(
                    inputId = 'priorType',
                    label   = 'Prior type',
                    choices = c('ABC'     = 'abc',
                                'MonoExp' = 'mono'
                                ),
                    selected = 'abc',
                    inline = FALSE
                  )
                ),
                column(
                  width = 6,
                  conditionalPanel(
                    condition = "input.priorType == 'mono'",
                    numericInput(
                      "ru_theta",
                      label='ru_theta',
                      value = 0.05,
                      min = 0.01,
                      max = 0.5,
                      step = 0.01,
                      width = "100px"
                    )
                  )
                )
              )
            )
          ),
          tabPanel(
            title = 'Prior-GP',
            wellPanel(
              fluidRow(
                column(
                  width = 6,
                  numericInput(
                    "Nn",
                    label='Ctrl. points',
                    value = 10,
                    min = 5,
                    max = 20,
                    step = 1
                  )
                ),
                column(
                  width = 6,
                  radioButtons(
                    inputId = 'gridType',
                    label   = 'Grid Type',
                    choices = c(Extremal = 'extremal',
                                Internal = 'internal'),
                    selected = 'internal',
                    inline = FALSE
                  )
                )
              ),
              fluidRow(
                column(
                  width = 6,
                  sliderInput(
                    'lambda_rate',
                    label='lambda',
                    value = 0.1,
                    min   = 0.0,
                    max   = 0.5,
                    step  = 0.01
                  )
                ),
                column(
                  width = 6,
                  sliderInput(
                    'rho_scale',
                    label='rho',
                    value = 0.0,
                    min   = 0.0,
                    max   = 1.0,
                    step  = 0.01
                  )
                )
              )
            )
          ),
          tabPanel(
            title = 'Graphs',
            wellPanel(
              fluidRow(
                column(
                  width = 12,
                  sliderInput(
                    "modRange",
                    "Scale Modulation range",
                    min   = 0.1,
                    max   = 5,
                    value = 0.3,
                    step  = 0.1
                  )
                )
              )
            )
          ),
          type = 'pills'
        ),
        hr( style="border-color: #666;"),
        h4("Fit results"),
        verbatimTextOutput(
          'resExpGP'
        )
      ),
      mainPanel(
        tabsetPanel(
          tabPanel(
            title = 'Posterior',
            wellPanel(
              tabsetPanel(
                tabPanel(
                  title = 'Predictions',
                  wellPanel(
                    # withSpinner(
                      plotOutput(
                        'plotExpGP',
                        height = '600px'
                      # ),
                      # type = 4
                    )
                  )
                ),
                tabPanel(
                  title = 'Statistics',
                  wellPanel(
                    DT::dataTableOutput(
                      'summaryOut'
                    )
                  )
                ),
                tabPanel(
                  title = 'Traces',
                  wellPanel(
                    # withSpinner(
                      plotOutput(
                        'tracesExpGP',
                        height = '600px'
                      # ),
                      # type = 4
                    )
                  )
                ),
                tabPanel(
                  title = 'Output',
                  # withSpinner(
                    verbatimTextOutput(
                      'outExpGP'
                    # ),
                    # type = 4
                  )
                )
              )
            )
          ),
          tabPanel(
            title = 'Prior',
            wellPanel(
              fluidRow(
                column(
                  width=6,
                  actionButton(
                    inputId = 'runPriExpGP',
                    strong("Simulate"),
                    icon=icon('gear')
                  ),
                  tags$style(type='text/css',
                             "#runPriExpGP { margin-bottom: 25px;}"
                  )
                )
              ),
              tabsetPanel(
                tabPanel(
                  title = 'Predictions',
                  wellPanel(
                    # withSpinner(
                      plotOutput(
                        'plotPriExpGP',
                        height = '300px'
                      # ),
                      # type = 4
                    )
                  )
                ),
                tabPanel(
                  title = 'Statistics',
                  wellPanel(
                    DT::dataTableOutput(
                      'summaryPriOut'
                    )
                  )
                ),
                tabPanel(
                  title = 'Traces',
                  wellPanel(
                    # withSpinner(
                      plotOutput(
                        'tracesPriExpGP',
                        height = '600px'
                      # ),
                      # type = 4
                    )
                  )
                )
              )
            )
          ),
          tabPanel(
            title = 'Identification',
            wellPanel(
              tabsetPanel(
                tabPanel(
                  title = 'Pri/Post',
                  wellPanel(
                    # withSpinner(
                      plotOutput(
                        'priPostExpGP',
                        height = '600px'
                      # ),
                      # type = 4
                    )
                  )
                )
              )
            )
          ),
          id   = 'tabsetPriPost',
          type = 'pills'
        )
      )
    )
  ),
  tabPanel(
    # GP Designer ####
    title = "GP-Design",
    sidebarLayout(
      sidebarPanel(
        fluidRow(
          column(
            width = 5,
            numericInput(
              inputId = 'NnTest',
              label='Ctrl. points',
              value = 10,
              min = 5,
              max = 20,
              step = 1
            ),
            radioButtons(
              inputId = 'gridTypeTest',
              label   = 'Grid Type',
              choices = c(Extremal = 'extremal',
                          Internal = 'internal'),
              selected = 'internal',
              inline = FALSE
            )
          ),
          column(
            width = 5,
            numericInput(
              'alpha_scaleTest',
              label='alpha_scale',
              value = 0.1,
              min = 0.01,
              max = 1.0,
              step = 0.05
            ),
            sliderInput(
              'rho_scaleTest',
              label='rho_scale',
              value = 0.0,
              min   = 0.0,
              max   = 1.0,
              step  = 0.01
            )
          )
        ),
        fluidRow(
          column(
            width = 5,
            actionButton(
              inputId = 'cloneGPDesign',
              strong('Clone'),
              icon=icon('clone')
            ),
            tags$style(type='text/css',
                       "#cloneGPDesign { width:100%; margin-top: 25px;}"
            )
          ),
          column(
            width = 5,
            actionButton(
              inputId = 'applyGPDesign',
              strong('Apply'),
              icon=icon('stamp')
            ),
            tags$style(type='text/css',
                       "#applyGPDesign { width:100%; margin-top: 25px;}"
            )
          )
        )
      ),
      mainPanel(
        wellPanel(
          h4('Simulate GP for test modulation curve'),
          plotOutput(
            'plotGP',
            height = '600px'
          )
        )
      )
    )
  ),
  # Save ####
  tabPanel(
    title="Save",
    sidebarPanel(
      wellPanel(
        h4('Generate report'),
        fluidRow(
          column(
            width = 6,
            downloadButton(
              outputId = 'report',
              label    = 'Download  (Ctrl+Click)'
            )
          )
        ),
        h4('Save parameters'),
        fluidRow(
          column(
            width = 6,
            downloadButton(
              outputId = 'params',
              label    = 'Download  (Ctrl+Click)'
            )
          )
        )
      )
    )
  ),
  # About ####
  tabPanel(
    title="About",
    sidebarPanel(
      h5("Author      : P. Pernot"),
      h5("Affiliation : CNRS"),
      h5("Version     : 1.3.1"),
      h5("Date        : 2018/11/20"),
      hr( style="border-color: #666;"),
      a(href="https://github.com/ppernot/FitOCT","How to cite..."),
      br(),
      a(href="https://github.com/ppernot/FitOCT","code@github"),
      br(),
      a(href="https://github.com/ppernot/FitOCT/issues","Bugs report, Features request")
    )
  )

)

