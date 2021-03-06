% --- Source file: summaryjointNestedPenal.Rd ---
\name{summary.jointNestedPenal}
\Rdversion{1.1}
\alias{summary.jointNestedPenal}
\alias{print.summary.jointNestedPenal}


\title{summary of parameter estimates of a joint nested frailty model}

\description{
  This function returns hazard rations (HR) and its confidence intervals.
}
\usage{
\method{summary}{jointNestedPenal}(object, level = 0.95, len = 6, d = 2, lab="hr", ...)
}

\arguments{
  \item{object}{output from a call to frailtyPenal for joint nested models} 
  \item{level}{significance level of confidence interval. Default is 95\%.}
  \item{d}{the desired number of digits after the decimal point. Default of 6 digits is used.}
  \item{len}{the total field width. Default is 6.}
  \item{lab}{label of printed results.}
  \item{\dots}{ other unused arguments.}
}


\value{
  Prints HR and its confidence intervals for each covariate. Confidence level is allowed (level argument).
}


\seealso{
 \code{\link{frailtyPenal}}
}

\examples{

\dontrun{

#-- here is generated cluster (30 clusters)
readmissionNested <- transform(readmission,group=id\%\%30+1)

# Baseline hazard function approximated with splines with calendar-timescale

model.spli.AG <- frailtyPenal(formula = Surv(t.start, t.stop, event)
 ~ subcluster(id) + cluster(group) + dukes + terminal(death), 
 formula.terminalEvent = ~dukes, data = readmissionNested, 
 recurrentAG = TRUE, n.knots = 8, kappa = c(9.55e+9, 1.41e+12),
 initialize = TRUE)

summary(model.spli.AG)

}
}
\keyword{methods}
