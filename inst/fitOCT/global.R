# Libraries ####
libs =c('V8','shiny','parallel','rstan','knitr',
        'inlmisc','shinycssloaders','DT',
        'RandomFields','stringr','devtools',
        'rmarkdown','rlist','digest','shinythemes')
for (lib in libs ) {
  if(!require(lib,character.only = TRUE, quietly = TRUE))
    install.packages(lib,dependencies=TRUE,
                     repos = "http://cran.irsn.fr/")
  library(lib,character.only = TRUE, quietly = TRUE)
}

lib ='FitOCTLib'
if(!require(lib,character.only = TRUE))
  devtools::install_github("ppernot/FitOCTlib")
library(lib,character.only = TRUE)

# Options ####
Sys.setlocale(category = "LC_NUMERIC", locale="C")
options(mc.cores = parallel::detectCores(),
        width = 60,
        warn  = 0)
rstan::rstan_options(auto_write = TRUE)
RandomFields::RFoptions(spConform=FALSE)

# set.seed(1234) # Initialise la graine du RNG

# Graphical parameters ####
gPars = list(
  cols    = inlmisc::GetColors(8),
  # Transparents for spaghetti
  col_tr  = inlmisc::GetColors(8,alpha=0.1),
  # Darker for legends or fillings
  col_tr2 = inlmisc::GetColors(8,alpha=0.4),
  pty = 's',
  mar = c(3.2,3,1.5,.5),
  mgp = c(2,.75,0),
  tcl = -0.5,
  lwd = 2,
  cex = 1,
  cex.leg = 0.9,
  xlabel  = 'stromal depth (µm)',
  plot_title = NULL,
  graphTable = FALSE
)

# Tables output parameters ###
DTopts = list(
  ordering    = FALSE,
  searching   = FALSE,
  paging      = FALSE,
  info        = FALSE,
  pageLength  = 16,
  deferRender = TRUE,
  scrollY     = FALSE,
  scrollX     = TRUE,
  stateSave   = FALSE
)

# Misc functions ####

summaryNoise    <- function(out){
  fit = out$fit
  if (out$method == 'optim') {

    pars = c('theta')
    opt = list()
    for (par in pars)
      opt[[par]] = fit$par[[par]]
    opt = unlist(opt,use.names = TRUE)

    if(!is.null(fit$hessian)) {
      H = fit$hessian
      tags = colnames(H)
      tags = gsub('\\.','',tags)
      colnames(H) = rownames(H) = tags
      se = list()
      for (par in names(opt))
        se[[par]]  = sqrt(-1/H[par,par])
      se = unlist(se)
    }
    sum = data.frame(opt = opt, sd = se)

    DT::datatable(
      data = signif(sum,digits = 3),
      options = DTopts )

  } else {
    pars = c('theta')

    sum  = rstan::summary(fit,pars=pars,
                          use_cache=FALSE,
                          c(0.025,0.5,0.975))$summary[,-2]

    `%>%` <- DT::`%>%`
    DT::datatable(
      data = signif(sum,digits = 3),
      options = DTopts
    ) %>%
      DT::formatStyle(
        columns = "Rhat",
        color = DT::styleInterval(1.1, c("blue", "red"))
      ) %>%
      DT::formatRound(
        columns = "n_eff",
        digits = 0
      )
  }
}
summaryMonoExp  <- function(out){
  fit = out$fit
  if (out$method == 'optim') {

    pars = c('theta')
    opt = list()
    for (par in pars)
      opt[[par]] = fit$par[[par]]
    opt = unlist(opt,use.names = TRUE)

    if(!is.null(fit$hessian)) {
      H = fit$hessian
      tags = colnames(H)
      tags = gsub('\\.','',tags)
      colnames(H) = rownames(H) = tags
      se = list()
      for (par in names(opt))
        se[[par]]  = sqrt(-1/H[par,par])
      se = unlist(se)
    }
    sum = data.frame(opt = opt, sd = se)

    DT::datatable(data = signif(sum,digits = 3),
                  options = DTopts )

  } else {
    pars = c('theta','br')

    sum  = rstan::summary(fit,pars=pars,
                          use_cache=FALSE,
                          c(0.025,0.5,0.975))$summary[,-2]

    `%>%` <- DT::`%>%`
    DT::datatable(
      data = signif(sum,digits = 3),
      options = DTopts
    ) %>%
      DT::formatStyle(
        columns = "Rhat",
        color = DT::styleInterval(1.1, c("blue", "red"))
      ) %>%
      DT::formatRound(
        columns = "n_eff",
        digits = 0
      )
  }
}
summaryExpGP    <- function(out){
  fit = out$fit
  if (out$method == 'optim') {

    pars = c('theta','yGP','lambda','sigma')
    opt = list()
    for (par in pars)
      opt[[par]] = fit$par[[par]]
    opt = unlist(opt,use.names = TRUE)

    if(!is.null(fit$hessian)) {
      H = fit$hessian
      tags = colnames(H)
      tags = gsub('\\.','',tags)
      colnames(H) = rownames(H) = tags
      se = list()
      for (par in names(opt))
        se[[par]]  = sqrt(-1/H[par,par])
      se = unlist(se)
    }
    sum = data.frame(opt = opt, sd = se)

    DT::datatable(data = signif(sum,digits = 3),
                  options = list(
                    ordering    = FALSE,
                    searching   = FALSE,
                    paging      = FALSE,
                    info        = FALSE,
                    pageLength  = 16,
                    deferRender = TRUE,
                    scrollY     = FALSE,
                    scrollX     = TRUE,
                    stateSave   = FALSE
                  ) )

  } else {
    pars = c('theta','yGP','lambda','sigma','br')

    sum  = rstan::summary(fit,pars=pars,
                          use_cache=FALSE,
                          c(0.025,0.5,0.975))$summary[,-2]

    `%>%` <- DT::`%>%`
    DT::datatable(data = signif(sum,digits = 3),
                  options = list(
                    ordering    = FALSE,
                    searching   = FALSE,
                    paging      = FALSE,
                    info        = FALSE,
                    pageLength  = 16,
                    deferRender = TRUE,
                    scrollY     = FALSE,
                    scrollX     = TRUE,
                    stateSave   = FALSE
                  ) ) %>%
      DT::formatStyle(
        columns = "Rhat",
        color = DT::styleInterval(1.1, c("blue", "red"))) %>%
      DT::formatRound(columns = "n_eff", digits = 0)
  }
}
summaryPriExpGP <- function(out){
  fit  = out$fit

  pars = c('theta','yGP','lambda','sigma')

  sum  = rstan::summary(fit,pars=pars,
                        use_cache=FALSE,
                        c(0.025,0.5,0.975))$summary[,-2]
  `%>%` <- DT::`%>%`
  DT::datatable(
    data = signif(sum,digits = 3),
    options = DTopts
  ) %>%
    DT::formatStyle(
      columns = "Rhat",
      color = DT::styleInterval(1.1, c("blue", "red"))
    ) %>%
    DT::formatRound(
      columns = "n_eff",
      digits = 0
    )

}

# Global variables ####

Inputs = reactiveValues(
  x           = NULL,
  y           = NULL,
  xSel        = NULL,
  outSmooth   = NULL,
  outMonoExp  = NULL,
  outExpGP    = NULL,
  outPriExp   = NULL,
  outPriExpGP = NULL,
  fitOut      = NULL,
  priHash     = NULL,
  posHash     = NULL
)

