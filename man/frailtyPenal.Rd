\name{frailtyPenal}
\alias{frailtyPenal}
\alias{waldtest}
\alias{factor.names}
\alias{timedep.names}

\title{Fit a Shared, Joint or Nested Frailty model}

\description{

\bold{Shared Frailty model}

Fit a shared gamma or log-normal frailty model using a semiparametric Penalized Likelihood estimation or parametric estimation on the hazard function.
Left-truncated, right-censored data, interval-censored data and strata (up to 6 levels) are allowed.
It allows to obtain a non-parametric smooth hazard of survival function.
This approach is different from the partial penalized likelihood approach of Therneau et al.

The hazard function, conditional on the frailty term \eqn{\omega_i}, of a shared gamma frailty model for the \eqn{j^{th}} subject in the \eqn{i^{th}} group:

\deqn{\lambda_{ij}(t|\omega_i)=\lambda_0(t)\omega_i\exp(\bold{\beta^{'}Z_{ij}})}

\deqn{\omega_i\sim\Gamma\left(\frac{1}{\theta},\frac{1}{\theta}\right)
 \hspace{0.5cm} \bold{E}(\omega_i)=1 \hspace{0.5cm}\bold{Var}(\omega_i)=\theta}

where \eqn{\lambda_0(t)} is the baseline hazard function, \eqn{\bold{\beta}} the vector of the regression coefficient associated to the covariate vector \eqn{\bold{Z_{ij}}} for the \eqn{j^{th}} individual in the \eqn{i^{th}} group.

Otherwise, in case of a shared log-normal frailty model, we have for the \eqn{j^{th}} subject in the \eqn{i^{th}} group:

\deqn{\lambda_{ij}(t|\eta_i)=\lambda_0(t)\exp(\eta_i+\bold{\beta^{'}Z_{ij}})}

\deqn{\eta_i\sim N(0,\sigma^2)}

From now on, you can also consider time-varying effects covariates in your model, see \code{timedep} function for more details.

\bold{Joint Frailty model}

Fit a joint either with gamma or log-normal frailty model for recurrent and terminal events using a penalized likelihood estimation on the hazard function or a parametric estimation. Right-censored data and strata (up to 6 levels) for the recurrent event part are allowed. Left-truncated data is not possible. Joint frailty models allow studying, jointly, survival processes of recurrent and terminal events, by considering the terminal event as an informative censoring. 

There is two kinds of joint frailty models that can be fitted with \code{frailtyPenal} :

- The first one (Rondeau et al. 2007) includes a common frailty term to the individuals \eqn{(\omega_i)} for the two rates which will take into account the heterogeneity in the data, associated with unobserved covariates. The frailty term acts differently for the two rates ( \eqn{\omega_i} for the recurrent rate and \eqn{\omega_i^{\alpha}} for the death rate). The covariates could be different for the recurrent rate and death rate.

For the \eqn{j^{th}}{j^th} recurrence \eqn{(j=1,...,n_i)} and the \eqn{i^{th}}{i^th} subject \eqn{(i=1,...,G)}, the joint gamma frailty model for recurrent event hazard function \eqn{r_{ij}(.)} and death rate \eqn{\lambda_i(.)} is :

\deqn{\left\{
\begin{array}{ll}
r_{ij}(t|\omega_i)=\omega_ir_0(t)\exp(\bold{\beta_1^{'}Z_i(t)}) & \mbox{(Recurrent)} \\
\lambda_i(t|\omega_i)=\omega_i^{\alpha}\lambda_0(t)\exp(\bold{\beta_2^{'}Z_i(t)}) & \mbox{(Death)} \\
 \end{array}
 \right.
}

where \eqn{r_0(t)} (resp. \eqn{\lambda_0(t)}) is the recurrent (resp. terminal) event baseline hazard function, \eqn{\bold{\beta_1}} (resp. \eqn{\bold{\beta_2}}) the regression coefficient vector, \eqn{\bold{Z_i(t)}} the covariate vector. The random effects of frailties \eqn{\omega_i\sim\bold{\Gamma}(\frac{1}{\theta},\frac{1}{\theta})} and are iid.

The joint log-normal frailty model will be :

\deqn{\left\{
\begin{array}{ll}
r_{ij}(t|\eta_i)=r_0(t)\exp(\eta_i+\bold{\beta_1^{'}Z_i(t)}) & \mbox{(Recurrent)} \\
\lambda_i(t|\eta_i)=\lambda_0(t)\exp(\alpha \eta_i+\bold{\beta_2^{'}Z_i(t)}) & \mbox{(Death)} \\
 \end{array}
 \right.
}

where \deqn{\eta_i\sim N(0,\sigma^2)}

- The second one (Rondeau et al. 2011) is quite similar but the frailty term is common to the individuals from a same group. This model is useful for the joint modelling two clustered survival outcomes. This joint models have been developed for clustered  semi-competing events. The follow-up of each of the two competing outcomes stops when the event occurs. In this case, j is for the subject and i for the cluster.

\deqn{\left\{
\begin{array}{ll}
r_{ij}(t|u_i)=u_ir_0(t)\exp(\bold{\beta_1^{'}Z_{ij}(t)}) & \mbox{(Time to event)} \\
\lambda_{ij}(t|u_i)=u_i^{\alpha}\lambda_0(t)\exp(\bold{\beta_2^{'}Z_{ij}(t)}) & \mbox{(Death)} \\
 \end{array}
 \right.
}

It should be noted that in these models it is not recommended to include \eqn{\alpha} parameter as there is not enough information to estimate it and thus there might be convergence problems.

In case of a log-normal distribution of the frailties, we will have :

\deqn{\left\{
\begin{array}{ll}
r_{ij}(t|v_i)=r_0(t)\exp(v_i+\bold{\beta_1^{'}Z_{ij}(t)}) & \mbox{(Time to event)} \\
\lambda_{ij}(t|v_i)=\lambda_0(t)\exp(\alpha v_i+\bold{\beta_2^{'}Z_{ij}(t)}) & \mbox{(Death)} \\
 \end{array}
 \right.
}

where \deqn{v_i\sim N(0,\sigma^2)}

This joint frailty model can also be applied to clustered recurrent events and a terminal event (example on "readmission" data below).

From now on, you can also consider time-varying effects covariates in your model, see \code{timedep} function for more details.


General Joint Frailty model
Fit a general joint frailty model for recurrent and terminal events considering two independent
frailty terms. The frailty term \eqn{u_i} represents the unobserved association between recurrences and
death. The frailty term \eqn{v_i} is specific to the recurrent event rate. Thus, the general joint frailty model
is:


\eqn{\left\{
\begin{array}{ll}
r_{ij}(t|u_i,v_i)=u_iv_ir_0(t)\exp(\bold{\beta_1^{'}Z_{ij}(t)}) =u_iv_ir_{ij}(t) & \mbox{(Reccurent)} \\
\lambda_{i}(t|u_i)=u_i\lambda_0(t)\exp(\bold{\beta_1^{'}Z_{i}(t)}) = u_i \lambda_{i}(t) & \mbox{(Death)} \\
 \end{array}
 \right.
}

where the \eqn{iid} random effects \eqn{\bold{u_i}\sim\Gamma(\frac{1}{\theta},\frac{1}{\theta})} and the \eqn{iid} random effects \eqn{\bold{v_i}\sim\Gamma(\frac{1}{\eta},\frac{1}{\eta})}  are independent from each other.  The joint model is fitted using a penalized  likelihood estimation on the hazard. Right-censored data and time-varying covariates \eqn{\bold{Z}_i(t)} are allowed.

\bold{Nested Frailty model}

Fit a nested frailty model using a Penalized Likelihood on the hazard function or using a parametric estimation. Nested frailty models allow survival studies for hierarchically clustered data by including two iid gamma random effects.
Left-truncated and right-censored data are allowed. Stratification analysis is allowed (maximum of strata = 2).

The hazard function conditional on the two frailties \eqn{v_i} and \eqn{w_{ij}} for the \eqn{k^{th}} individual of the \eqn{j^{th}} subgroup of the \eqn{i^{th}} group is :

\deqn{\left\{
\begin{array}{ll}
\lambda_{ijk}(t|v_i,w_{ij})=v_iw_{ij}\lambda_0(t)exp(\bold{\beta^{'}X_{ijk}}) \\
v_i\sim\Gamma\left(\frac{1}{\alpha},\frac{1}{\alpha}\right) \hspace{0.05cm}i.i.d. \hspace{0.2cm} \bold{E}(v_i)=1 \hspace{0.2cm}\bold{Var}(v_i)=\alpha \\
 w_{ij}\sim\Gamma\left(\frac{1}{\eta},\frac{1}{\eta}\right)\hspace{0.05cm}i.i.d. \hspace{0.2cm} \bold{E}(w_{ij})=1 \hspace{0.2cm} \bold{Var}(w_{ij})=\eta
 \end{array}
 \right.
}

where \eqn{\lambda_0(t)} is the baseline hazard function, \eqn{X_{ijk}}
 denotes the covariate vector and \eqn{\beta} the corresponding vector of regression parameters.
 
\bold{Joint Nested Frailty Model}

Fit a joint model for recurrent and terminal events using a penalized likelihood on the hazard functions or a parametric estimation. Right-censored data are allowed but left-truncated data and stratified analysis are not allowed.

Joint nested frailty models allow studying, jointly, survival processes of recurrent and terminal events for hierarchically clustered data, by considering the terminal event as an informative censoring and by including two iid gamma random effects. 

The joint nested frailty model includes two shared frailty terms, one for the subgroup (\eqn{u_{fi}}) and one for the group (\eqn{w_f}) into the hazard functions. This random effects account the heterogeneity in the data, associated with unobserved covariates. The frailty terms act differently for the two rates (\eqn{u_{fi}}, \eqn{w_f^\xi} for the recurrent rate and \eqn{u_{fi}^\alpha, {w_i}} for the terminal event rate). The covariates could be different for the recurrent rate and death rate.

For the \eqn{j^{th}} recurrence (j = 1, ..., \eqn{n_i}) of the \eqn{i^{th}} individual (i = 1, ..., \eqn{m_f}) of the \eqn{f^{th}} group (f = 1, ..., n), the joint nested gamma frailty model for recurrent event hazard function \eqn{r_{fij}}(.) and for terminal event hazard function \eqn{\lambda_{fi}} is :

\deqn{\left\{
\begin{array}{ll}
r_{fij}(t|\omega_f, u_{fi}, \bold{X_{fij}})= r_0(t) u_{fi} \omega_f^\xi \exp(\bold{\beta'} \bold{X_{fij}}) & \mbox{(Recurrent)} \\
\lambda_{fi}(t|\omega_f, u_{fi}, \bold{X_{fij}})=\lambda_0(t)u_{fi}^\alpha \omega_f \exp(\bold{\gamma'} \bold{X_{fi}}) & \mbox{(Death)} \\
 \end{array}
 \right.
}

where \eqn{r_0(t)}(resp. \eqn{\lambda_0(t)}) is the recurrent (resp. terminal) event baseline hazard function, \eqn{\beta} (resp. \eqn{\gamma}) the regression coefficient vector, \eqn{\bold{X_{fij}}(t)} the covariates vector. The random effects are \deqn{\omega_f \sim \Gamma \left( \frac{1}{\eta}, \frac{1}{\eta}\right)} and \deqn{ u_{fi} \sim \Gamma \left( \frac{1}{\theta}, \frac{1}{\theta} \right)}
}



\usage{

frailtyPenal(formula, formula.terminalEvent, data, recurrentAG = FALSE, 
cross.validation = FALSE, jointGeneral,n.knots, kappa, maxit = 300,
hazard = "Splines", nb.int, RandDist = "Gamma", betaknots = 1, 
betaorder = 3, initialize = TRUE, init.B, init.Theta, init.Alpha, 
Alpha, init.Ksi, Ksi, init.Eta, LIMparam = 1e-3, LIMlogl = 1e-3,
LIMderiv = 1e-3, print.times = TRUE)
}

\arguments{

  \item{formula}{ a formula object, with the response on the left of a \eqn{\sim}
          operator, and the terms on the right. The response must be a
          survival object as returned by the 'Surv' function like in survival package.
          In case of interval-censored data, the response must be an object as returned by
          the 'SurvIC' function from this package.  Interactions are possible using * or :.}

  \item{formula.terminalEvent}{only for joint and joint nested frailty models : a formula object, only requires terms on the right to indicate which variables are modelling the terminal event.  Interactions are possible using * or :.}

  \item{data}{a 'data.frame' with the variables used in 'formula'.}

  \item{recurrentAG}{Logical value. Is Andersen-Gill model fitted? If so indicates that recurrent event times with the
                 counting process approach of Andersen and Gill is used. This formulation can be used for dealing with
                 time-dependent covariates. The default is FALSE.}

  \item{cross.validation}{Logical value. Is cross validation procedure used for estimating smoothing parameter
                 in the penalized likelihood estimation?
                 If so a search of the smoothing parameter using cross validation is done, with kappa as the seed.
                 The cross validation is not implemented for several strata, neither for interval-censored data. The cross validation has been implemented 
                 for a Cox proportional hazard model, with no covariates. The default is FALSE.}

  \item{jointGeneral}{ Logical value. Does the model include two independent random effects? If
so, this will fit a general joint frailty model with an association between the
recurrent events and a terminal event (explained by the variance \eqn{\theta}) and an association
amongst the recurrent events (explained by the variance \eqn{\eta}).}


  \item{n.knots}{ integer giving the number of knots to use. Value required in the penalized likelihood estimation.
                It corresponds to the (n.knots+2) splines functions for the approximation of the hazard or the survival functions.
                We estimate I or M-splines of order 4. When the user set a number of knots equals to k (n.knots=k) then the number of interior knots is (k-2) and the number of splines is (k-2)+order.  
                Number of knots must be between 4 and 20. (See Note)}

  \item{kappa}{ positive smoothing parameter in the penalized likelihood estimation. In a stratified shared model, this argument must be a vector with kappas for both strata.
          In a stratified joint model, this argument must be a vector with kappas 
          for both strata for recurrent events plus one kappa for terminal event.
          The coefficient kappa of the integral of the squared second derivative of hazard function in the fit (penalized log likelihood). To obtain an initial
          value for \code{kappa}, a solution is to fit the corresponding shared frailty model using cross validation (See cross.validation).
          We advise the user to identify several possible tuning parameters, note their defaults and look at the sensitivity
          of the results to varying them. Value required. (See Note).}

  \item{maxit}{maximum number of iterations for the Marquardt algorithm. Default is 300}

 \item{hazard}{Type of hazard functions: "Splines" for semiparametric hazard functions using equidistant intervals or "Splines-per" using percentile with the penalized likelihood estimation,
            "Piecewise-per" for piecewise constant hazard function using percentile (not available for interval-censored data), "Piecewise-equi" for piecewise constant hazard 
            function using equidistant intervals, "Weibull" for parametric Weibull functions. Default is "Splines".
            In case of \code{jointGeneral = TRUE} or if a joint nested frailty model is fitted, only \code{hazard = "Splines"} can be chosen.}

  \item{nb.int}{Number of time intervals (between 1 and 20) for the parametric hazard functions ("Piecewise-per", "Piecewise-equi"). In a joint model, you need to specify a number of time interval for both recurrent hazard function and the death hazard function (vector of length 2).}

  \item{RandDist}{Type of random effect distribution: "Gamma" for a gamma distribution, "LogN" for a log-normal distribution. Default is "Gamma". Not implemented for nested model. If \code{jointGeneral = TRUE} or if a joint nested frailty model is fitted, the log-normal distribution cannot be chosen.}

  \item{betaknots}{Number of inner knots used for the estimation of B-splines. Default is 1. See 'timedep' function for more details. Not implemented for nested and joint nested frailty models.}

  \item{betaorder}{Order of the B-splines. Default is cubic B-splines (order = 3). See 'timedep' function for more details. Not implemented for nested and joint nested frailty models.}

  \item{initialize}{Logical value, only for joint nested frailty models. Option \code{TRUE} indicates fitting an appropriate standard joint frailty model (without group effect, only the subgroup effect) to provide initial values for the joint nested model. Default is \code{TRUE}.}
  
  \item{init.B}{A vector of initial values for regression coefficients. This vector should be of the same size as the whole vector of covariates with the first elements for the covariates related to the recurrent events and then to the terminal event (interactions in the end of each component). Default is 0.1 for each (for Cox and shared model) or 0.5 (for joint and joint nested frailty models).}

  \item{init.Theta}{Initial value for variance of the frailties.}

  \item{init.Alpha}{Only for joint and joint nested frailty models : initial value for parameter alpha.}
  
  \item{init.Ksi}{Only for joint nested frailty model : initial value for parameter \eqn{\xi}.}
  
  \item{init.Eta}{Only for general joint and joint nested frailty models : initial value for the variance \eqn{\eta} of the frailty \eqn{v_i} (general joint model) and of the frailty \eqn{\omega_i} (joint nested frailty model).}

  \item{Alpha}{Only for joint and joint nested frailty model : input "None" so as to fit a joint model without the parameter alpha.}
  
  \item{Ksi}{Only for joint nested frailty model : input \code{"None"} indicates a joint nested frailty model without the parameter \eqn{\xi}.}

  \item{LIMparam}{Convergence threshold of the Marquardt algorithm for the parameters (see Details), \eqn{10^{-3}} by default.}

  \item{LIMlogl}{Convergence threshold of the Marquardt algorithm for the log-likelihood (see Details), \eqn{10^{-3}} by default.}

  \item{LIMderiv}{Convergence threshold of the Marquardt algorithm for the gradient (see Details), \eqn{10^{-3}} by default.}

  \item{print.times}{a logical parameter to print iteration process. Default is TRUE.}
  
}

\details{
Typical usages are
for a Cox model
\preformatted{frailtyPenal(Surv(time,event)~var1+var2, data, \dots)}

for a shared model
\preformatted{frailtyPenal(Surv(time,event)~cluster(group)+var1+var2,
             data, \dots)}

for a joint model
\preformatted{frailtyPenal(Surv(time,event)~cluster(group)+var1+var2+
             var3+terminal(death), formula.terminalEvent=~
             var1+var4, data, \dots)}

for a joint model for clustered data
\preformatted{frailtyPenal(Surv(time,event)~cluster(group)+num.id(group2)+
             var1+var2+var3+terminal(death),
             formula.terminalEvent=~var1+var4, data, \dots)}

for a nested model
\preformatted{frailtyPenal(Surv(time,event)~cluster(group)+subcluster(sbgroup)+
             var1+var2, data, \dots)}
			 
for a joint nested frailty model
\preformatted{frailtyPenal(Surv(time,event)~cluster(group)+subcluster(sbgroup)+
             var1+var2++terminal(death),
             formula.terminalEvent=~var1+var4, data, \dots)}

The estimated parameter are obtained using the robust Marquardt algorithm (Marquardt, 1963) which is a combination
between a Newton-Raphson algorithm and a steepest descent algorithm. The iterations are stopped when the difference
between two consecutive log-likelihoods was small \eqn{(<10^{-3})}, the estimated coefficients were stable
(consecutive values \eqn{(<10^{-3})}, and the gradient small enough \eqn{(<10^{-3})}. When frailty parameter
is small, numerical problems may arise. To solve this problem, an alternative formula of the penalized
log-likelihood is used (see Rondeau, 2003 for further details). Cubic M-splines of order 4 are used for
the hazard function, and I-splines (integrated M-splines) are used for the cumulative hazard function.

The inverse of the Hessian matrix is the variance estimator and to deal with the positivity constraint of
the variance component and the spline coefficients, a squared transformation is used and the standard errors
are computed by the \eqn{\Delta}-method (Knight & Xekalaki, 2000). The smooth parameter can be chosen by
maximizing a likelihood cross validation criterion (Joly and other, 1998). The integrations in the full
log likelihood were evaluated using Gaussian quadrature. Laguerre polynomials with 20 points were used
to treat the integrations on \eqn{[0,\infty[}

\bold{INITIAL VALUES}

The splines and the regression coefficients are initialized to 0.1. In case of shared model, the program fits,
firstly, an adjusted Cox model to give new initial values for the splines and the regression coefficients.
The variance of the frailty term \eqn{\theta} is initialized to 0.1. Then, a shared frailty model is fitted.

In case of a joint frailty model, the splines and the regression coefficients are initialized to 0.5. The
program fits an adjusted Cox model to have new initial values for the regression and the splines coefficients.
The variance of the frailty term \eqn{\theta} and the coefficient \eqn{\alpha} associated in the death hazard
function are initialized to 1. Then, it fits a joint frailty model.

In case of a general joint frailty model we need to initialize the \code{jointGeneral} logical value to \code{TRUE}.

In case of a nested model, the program fits an adjusted Cox model to provide new initial values for the
regression and the splines coefficients. The variances of the frailties are initialized to 0.1. Then,
a shared frailty model with covariates with only subgroup frailty is fitted to give a  new initial value
for the variance of the subgroup frailty term. Then, a shared frailty model with covariates and only group
frailty terms is fitted to give a  new initial value for the variance of the group frailties. In a last step,
a nested frailty model is fitted.

In case of a joint nested model, the splines and the regression coefficients are initialized to 0.5 and the variances of the frailty terms \eqn{\eta} and \eqn{\xi} are initialized to 1. 
If the option \code{'initialize'} is \code{TRUE}, the program fits a joint frailty model to provide initial values for the splines, covariates coefficients, variance \eqn{\theta} of the frailty terms and \eqn{\alpha}.
The variances of the second frailty term (\eqn{\eta}) and the second coefficient \eqn{\xi} are initialized to 1. 
Then, a joint nested frailty model is fitted.
}

\value{

The following components are included in a 'frailtyPenal' object for each model.

\item{b}{sequence of the corresponding estimation of the coefficients for the hazard functions (parametric or semiparametric), the random effects variances and the regression coefficients.}
\item{call}{The code used for the model.}
\item{formula}{the formula part of the code used for the model.}
\item{coef}{the regression coefficients.}
\item{cross.Val }{Logical value. Is cross validation procedure used for estimating the smoothing parameters in the penalized likelihood estimation?}
\item{DoF}{Degrees of freedom associated with the "kappa".}
\item{groups}{the maximum number of groups used in the fit.}
\item{kappa}{ A vector with the smoothing parameters  in the penalized likelihood estimation corresponding to each baseline function as components.}
\item{loglikPenal}{the complete marginal penalized log-likelihood in the semiparametric case.}
\item{loglik}{the marginal log-likelihood in the parametric case.}
\item{n}{the number of observations used in the fit.}
\item{n.events}{the number of events observed in the fit.}
\item{n.iter}{number of iterations needed to converge.}
\item{n.knots}{number of knots for estimating the baseline functions in the penalized likelihood estimation.}
\item{n.strat}{ number of stratum.}
\item{varH}{the variance matrix of all parameters before positivity constraint transformation. Then, the delta method is needed to obtain the estimated variance parameters. That is why some variances don't match with the printed values at the end of the model.}
\item{varHIH}{the robust estimation of the variance matrix of all parameters.}
\item{x}{matrix of times where both survival and hazard function are estimated. By default seq(0,max(time),length=99), where time is the vector of survival times.}
\item{lam}{array (dim=3) of hazard estimates and confidence bands.}
\item{surv}{array (dim=3) of baseline survival estimates and confidence bands.}
\item{nbintervR}{Number of intervals (between 1 and 20) for the parametric hazard functions ("Piecewise-per", "Piecewise-equi").}
\item{npar}{number of parameters.}
\item{nvar}{number of explanatory variables.}
\item{LCV}{the approximated likelihood cross-validation criterion in the semiparametric case (with H minus the converged Hessian matrix, and l(.) the full log-likelihood).\deqn{LCV=\frac{1}{n}(trace(H^{-1}_{pl}H) - l(.))}}
\item{AIC}{the Akaike information Criterion for the parametric case.\deqn{AIC=\frac{1}{n}(np - l(.))}}
\item{n.knots.temp}{initial value for the number of knots.}
\item{shape.weib}{shape parameter for the Weibull hazard function.}
\item{scale.weib}{scale parameter for the Weibull hazard function.}
\item{martingale.res}{martingale residuals for each cluster.}
\item{martingaleCox}{martingale residuals for observation in the Cox model.}
\item{Frailty}{Logical value. Was model with frailties fitted ?}
\item{frailty.pred}{empirical Bayes prediction of the frailty term (ie, using conditional posterior distributions).}
\item{frailty.var}{variance of the empirical Bayes prediction of the frailty term (only for gamma frailty models).}
\item{frailty.sd}{standard error of the frailty empirical Bayes prediction (only for gamma frailty models).}
\item{global_chisq}{a vector with the values of each multivariate Wald test.}
\item{dof_chisq}{a vector with the degree of freedom for each multivariate Wald test.}
\item{global_chisq.test}{a binary variable equals to 0 when no multivariate Wald is given, 1 otherwise.}
\item{p.global_chisq}{a vector with the p_values for each global multivariate Wald test.}
\item{names.factor}{Names of the "as.factor" variables.}
\item{Xlevels}{vector of the values that factor might have taken.}
\item{contrasts}{type of contrast for factor variable.}

The following components are specific to \bold{shared} models.

\item{equidistant}{Indicator for the intervals used the estimation of baseline hazard functions (for splines or pieceiwse-constaant functions) : 1 for equidistant intervals ;  0 for intervals using percentile (note: \code{equidistant} = 2 in case of parametric estimation using Weibull distribution).}
\item{intcens}{Logical value. Indicator if a joint frailty model with interval-censored data was fitted)}
\item{theta}{variance of the gamma frailty parameter \eqn{(\bold{Var}(\omega_i))}}
\item{sigma2}{variance of the log-normal frailty parameter \eqn{(\bold{Var}(\eta_i))}}
\item{linear.pred}{linear predictor: uses simply "Beta'X" in the cox proportional hazard model or "Beta'X + log w_i" in the shared gamma frailty models, otherwise uses "Beta'X + w_i" for log-normal frailty distribution.}
\item{BetaTpsMat}{matrix of time varying-effects and confidence bands (the first column used for abscissa of times)}

The following components are specific to \bold{joint} models.
\item{intcens}{Logical value. Indicator if a joint frailty model with interval-censored data was fitted)}
\item{theta}{variance of the gamma frailty parameter \eqn{(\bold{Var}(\omega_i))} or \eqn{(\bold{Var}(u_i))}}
\item{sigma2}{variance of the log-normal frailty parameter \eqn{(\bold{Var}(\eta_i))} or \eqn{(\bold{Var}(v_i))}}
\item{eta}{variance of the second gamma frailty parameter in general joint frailty models \eqn{(\bold{Var}(v_i))}}
\item{indic_alpha}{indicator if a joint frailty model with \eqn{\alpha} parameter was fitted}
\item{alpha}{the coefficient \eqn{\alpha} associated with the frailty parameter in the terminal hazard function.}
\item{nbintervR}{Number of intervals (between 1 and 20) for the recurrent parametric hazard functions ("Piecewise-per", "Piecewise-equi").}
\item{nbintervDC}{Number of intervals (between 1 and 20) for the death parametric hazard functions ("Piecewise-per", "Piecewise-equi").}
\item{nvar}{A vector with the number of covariates of each type of hazard function as components.}
\item{nvarRec}{number of recurrent explanatory variables.}
\item{nvarEnd}{number of death explanatory variables.}
\item{noVar1}{indicator of recurrent explanatory variables.}
\item{noVar2}{indicator of death explanatory variables.}
\item{xR}{matrix of times where both survival and hazard function are estimated for the recurrent event. By default seq(0,max(time),length=99), where time is the vector of survival times.}
\item{xD}{matrix of times for the terminal event.}
\item{lamR}{array (dim=3) of hazard estimates and confidence bands for recurrent event.}
\item{lamD}{the same value as lamR for the terminal event.}
\item{survR}{array (dim=3) of baseline survival estimates and confidence bands for recurrent event.}
\item{survD}{the same value as survR for the terminal event.}
\item{martingale.res}{martingale residuals for each cluster (recurrent).}
\item{martingaledeath.res}{martingale residuals for each cluster (death).}
\item{linear.pred}{linear predictor: uses "Beta'X + log w_i" in the gamma frailty model, otherwise uses "Beta'X + eta_i" for log-normal frailty distribution}
\item{lineardeath.pred}{linear predictor for the terminal part : "Beta'X + alpha.log w_i" for gamma, "Beta'X + alpha.eta_i" for log-normal frailty distribution}
\item{Xlevels}{vector of the values that factor might have taken for the recurrent part.}
\item{contrasts}{type of contrast for factor variable for the recurrent part.}
\item{Xlevels2}{vector of the values that factor might have taken for the death part.}
\item{contrasts2}{type of contrast for factor variable for the death part.}
\item{BetaTpsMat}{matrix of time varying-effects and confidence bands for recurrent event (the first column used for abscissa of times of recurrence)}
\item{BetaTpsMatDc}{matrix of time varying-effects and confidence bands for terminal event (the first column used for abscissa of times of death)}

The following components are specific to \bold{nested} models.

\item{alpha}{variance of the cluster effect \eqn{(\bold{Var}(v_{i}))}}
\item{eta}{variance of the subcluster effect \eqn{(\bold{Var}(w_{ij}))}}
\item{subgroups}{the maximum number of subgroups used in the fit.}
\item{frailty.pred.group}{empirical Bayes prediction of the frailty term by group.}
\item{frailty.pred.subgroup}{empirical Bayes prediction of the frailty term by subgroup.}
\item{linear.pred}{linear predictor: uses "Beta'X + log v_i.w_ij".}
\item{subgbyg}{subgroup by group.}
\item{n.strat}{A vector with the number of covariates of each type of hazard function as components.}

The following components are specific to \bold{joint nested frailty} models.
\item{theta}{variance of the subcluster effect \eqn{(\bold{Var}(u_{fi}))}}
\item{eta}{variance of the cluster effect \eqn{(\bold{Var}(\omega_f))}}
\item{alpha}{the power coefficient \eqn{\alpha} associated with the frailty parameter (\eqn{u_{fi}}) in the terminal event hazard function.}
\item{ksi}{the power coefficient \eqn{\xi} associated with the frailty parameter (\eqn{\omega_f}) in the recurrent event hazard function.}
\item{indic_alpha}{indicator if a joint frailty model with \eqn{\alpha} parameter was fitted or not.}
\item{indic_ksi}{indicator if a joint frailty model with \eqn{\xi} parameter was fitted or not.}
\item{frailty.fam.pred}{empirical Bayes prediction of the frailty term by family.}
}

\note{

From a prediction aim, we recommend you to input a data sorted by the group variable with numerical numbers
from 1 to n (number of groups). In case of a nested model, we recommend you to input a data sorted by the
group variable then sorted by the subgroup variable both with numerical numbers from 1 to n (number of groups)
and from 1 to m (number or subgroups).
"kappa" and "n.knots" are the arguments that the user have to change if the fitted model
does not converge.
"n.knots" takes integer values between 4 and 20. But with n.knots=20, the model would take a long time to
converge. So, usually, begin first with n.knots=7, and increase it step by step until it converges.
"kappa" only takes positive values. So, choose a value for kappa (for instance 10000), and if it does
not converge, multiply or divide this value by 10 or 5 until it converges.

}

\references{

V. Rondeau, Y. Mazroui and J. R. Gonzalez (2012). Frailtypack: An R package for the analysis of correlated survival data with frailty models using penalized likelihood estimation or parametric estimation.
\emph{Journal of Statistical Software} \bold{47}, 1-28.

Y. Mazroui, S. Mathoulin-Pelissier,P. Soubeyranb and Virginie Rondeau (2012) General joint frailty model for recurrent event data with a dependent terminalevent: Application to follicular lymphoma data.
\emph{Statistics in Medecine}, \bold{31}, 11-12, 1162-1176.

V. Rondeau, J.P. Pignon, S. Michiels (2011). A joint model for the dependance between clustered times to tumour progression and deaths: A meta-analysis of chemotherapy in head and neck cancer.
\emph{Statistical methods in medical research} \bold{897}, 1-19.

V. Rondeau, S. Mathoulin-Pellissier, H. Jacqmin-Gadda, V. Brouste, P. Soubeyran (2007). Joint frailty models for recurring events and death using maximum penalized likelihood estimation:application on cancer events.
\emph{Biostatistics} \bold{8},4, 708-721.

V. Rondeau, L. Filleul, P. Joly (2006). Nested frailty models using maximum penalized likelihood estimation.
\emph{Statistics in Medecine}, \bold{25}, 4036-4052.

V. Rondeau, D. Commenges, and P. Joly (2003). Maximum penalized likelihood estimation in a gamma-frailty model.
\emph{Lifetime Data Analysis} \bold{9}, 139-153.

McGilchrist CA and Aisbett CW (1991). Regression with frailty in survival analysis.
\emph{Biometrics} \bold{47}, 461-466.

D. Marquardt (1963). An algorithm for least-squares estimation of nonlinear parameters.
\emph{SIAM Journal of Applied Mathematics}, 431-441.

}

\seealso{
 \code{\link{SurvIC}}, \code{\link{cluster}}, \code{\link{subcluster}}, \code{\link{terminal}}, \code{\link{num.id}}, \code{\link{timedep}}
}


\examples{

\dontrun{

###---  COX proportional hazard model (SHARED without frailties) ---###
###---  estimated with penalized likelihood ---###

data(kidney)
frailtyPenal(Surv(time,status)~sex+age,
n.knots=12,kappa=10000,data=kidney)

###---  Shared Frailty model  ---###

frailtyPenal(Surv(time,status)~cluster(id)+sex+age,
n.knots=12,kappa=10000,data=kidney)

#-- with an initialisation of regression coefficients

frailtyPenal(Surv(time,status)~cluster(id)+sex+age,
n.knots=12,kappa=10000,data=kidney,init.B=c(-1.44,0))

#-- with truncated data

data(dataNested)

frailtyPenal(Surv(t1,t2,event) ~ cluster(group),
data=dataNested,n.knots=10,kappa=10000,
cross.validation=TRUE,recurrentAG=FALSE)

#-- stratified analysis

data(readmission)
frailtyPenal(Surv(time,event)~cluster(id)+dukes+strata(sex),
n.knots=10,kappa=c(10000,10000),data=readmission)

#-- recurrentAG=TRUE

frailtyPenal(Surv(t.start,t.stop,event)~cluster(id)+sex+dukes+
charlson,data=readmission,n.knots=6,kappa=1e5,recurrentAG=TRUE)

#-- cross.validation=TRUE

frailtyPenal(Surv(t.start,t.stop,event)~cluster(id)+sex+dukes+
charlson,data=readmission,n.knots=6,kappa=5000,recurrentAG=TRUE,
cross.validation=TRUE)

#-- log-normal distribution

frailtyPenal(Surv(t.start,t.stop,event)~cluster(id)+sex+dukes+
charlson,data=readmission,n.knots=6,kappa=5000,recurrentAG=TRUE,
RandDist="LogN")

###--- Joint Frailty model (recurrent and terminal events) ---###

data(readmission)
#-- Gap-time
modJoint.gap <- frailtyPenal(Surv(time,event)~cluster(id)+sex+dukes+charlson+
terminal(death),formula.terminalEvent=~sex+dukes+charlson,
data=readmission,n.knots=14,kappa=c(9.55e+9,1.41e+12),
recurrentAG=FALSE)

#-- Calendar time
modJoint.calendar <- frailtyPenal(Surv(t.start,t.stop,event)~cluster(id)+
sex+dukes+charlson+terminal(death),formula.terminalEvent=~sex
+dukes+charlson,data=readmission,n.knots=10,kappa=c(9.55e9,1.41e12),
recurrentAG=TRUE)

#-- without alpha parameter
modJoint.gap <- frailtyPenal(Surv(time,event)~cluster(id)+sex+dukes+charlson+
terminal(death),formula.terminalEvent=~sex+dukes+charlson,
data=readmission,n.knots=10,kappa=c(9.55e9,1.41e12),
recurrentAG=FALSE,Alpha="None")

#-- log-normal distribution

modJoint.log <- frailtyPenal(Surv(t.start,t.stop,event)~cluster(id)+sex
+dukes+charlson+terminal(death),formula.terminalEvent=~sex
+dukes+charlson,data=readmission,n.knots=10,kappa=c(9.55e9,1.41e12),
recurrentAG=TRUE,RandDist="LogN")

###--- Joint Frailty model for clustered data ---###

#-- here is generated cluster (5 clusters)
readmission <- transform(readmission,group=id\%\%5+1)

#-- exclusion all recurrent events --#
#--  to obtain framework of semi-competing risks --#
readmission2 <- subset(readmission, (t.start == 0 & event == 1) | event == 0)

joi.clus.gap <- frailtyPenal(Surv(time,event)~cluster(group)+
num.id(id)+dukes+charlson+sex+chemo+terminal(death),
formula.terminalEvent=~dukes+charlson+sex+chemo,
data=readmission2,recurrentAG=FALSE, n.knots=8,
kappa=c(1.e+10,1.e+10) ,Alpha="None")


###--- General Joint model (recurrent and terminal events) 
with 2 covariates ---###

data(readmission)
modJoint.general <- frailtyPenal(Surv(time,event) ~ cluster(id) + dukes +
charlson + sex  + chemo + terminal(death), 
formula.terminalEvent = ~ dukes + charlson + sex + chemo,
data = readmission, jointGeneral = TRUE,  n.knots = 8, 
kappa = c(2.11e+08, 9.53e+11))


###--- Nested Frailty model ---###

data(dataNested)
modClu <- frailtyPenal(Surv(t1,t2,event)~cluster(group)+
subcluster(subgroup)+cov1+cov2,data=dataNested,
n.knots=8,kappa=50000)

modClu.str <- frailtyPenal(Surv(t1,t2,event)~cluster(group)+
subcluster(subgroup)+cov1+strata(cov2),data=dataNested,
n.knots=8,kappa=c(50000,50000))

###--- Joint Nested Frailty model ---###

#-- here is generated cluster (30 clusters)
readmissionNested <- transform(readmission,group=id\%\%30+1)

modJointNested_Splines <- frailtyPenal(formula = Surv(t.start, t.stop, event) 
~ subcluster(id) + cluster(group) + dukes + terminal(death), 
formula.terminalEvent = ~dukes, data = readmissionNested, recurrentAG = TRUE, 
n.knots = 8, kappa = c(9.55e+9, 1.41e+12), initialize = TRUE)

modJointNested_Weib <- frailtyPenal(Surv(t.start,t.stop,event)~subcluster(id)
+cluster(group)+dukes+ terminal(death),formula.terminalEvent=~dukes, 
hazard = ('Weibull'), data=readmissionNested,recurrentAG=TRUE, initialize = FALSE)

JoiNes_GapSpline <- frailtyPenal(formula = Surv(time, event) 
~ subcluster(id) + cluster(group) + dukes + terminal(death), 
formula.terminalEvent = ~dukes, data = readmissionNested, 
recurrentAG = FALSE, n.knots = 8, kappa = c(9.55e+9, 1.41e+12), 
initialize = TRUE, init.Alpha = 1.091, Ksi = "None")

}

}

\keyword{models}

