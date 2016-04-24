install.packages("rpart")


#load data file
dataDirectory <-file.path(Sys.getenv("HOME"),"programming","W261","Tableau")
dataFile <- file.path(dataDirectory,"rail_demo_pop_casaulties_2011.csv")
railway_suicide<-read.csv(dataFile)

#converting data types to factor
railway_suicide$SUICIDE_ATTEMPTED <- factor(railway_suicide$SUICIDE_ATTEMPTED)
railway_suicide$ALCOHOL <- factor(railway_suicide$ALCOHOL)
railway_suicide$DRUG <- factor(railway_suicide$DRUG)
railway_suicide$MONTH <- factor(railway_suicide$MONTH)
railway_suicide$DAY <- factor(railway_suicide$DAY)
railway_suicide$TIME24HR <- factor(railway_suicide$TIME24HR)
railway_suicide$CNTYCD <- factor(railway_suicide$CNTYCD)


#
fullmodel <- glm(SUICIDE_ATTEMPTED ~ MONTH+POVERTYRATE +UNEMPLOYMENTRATE+ ALCOHOL+DRUG+
                pct_private_health+pct_no_heath+pct_public_health+pct_disability+median_household_income + 
                  pct_married + pct_widowed +pct_separated+count_not_citizen, 
              data=railway_suicide,
              family=binomial())
summary(fullmodel)

#Determing correlation between features 
cor.test(railway_suicide$UNEMPLOYMENTRATE,railway_suicide$POVERTYRATE,use="complete.obs",method="pearson")

#given that there is correlation between unemployment rate and poverty rate 
model1 <- glm(SUICIDE_ATTEMPTED ~ MONTH+POVERTYRATE + ALCOHOL+DRUG+
                   pct_private_health+pct_no_heath+pct_public_health+pct_disability+median_household_income + 
                   pct_married + pct_widowed +pct_separated+count_not_citizen, 
                 data=railway_suicide,
                 family=binomial())
summary(model1)



########################### GBM ################################################################################
file_11 <- file.path(dataDirectory,"county_pop_data_metrics_2011.csv")
train_2011<-read.csv(file_11)

file_12 <- file.path(dataDirectory,"county_pop_data_metrics_2012.csv")
train_2012<-read.csv(file_12)

file_13 <- file.path(dataDirectory,"county_pop_data_metrics_2013.csv")
train_2013<-read.csv(file_13)

file_14 <- file.path(dataDirectory,"county_pop_data_metrics_2014.csv")
train_2014<-read.csv(file_14)

str(train_2014)

file_15 <- file.path(dataDirectory,"county_data_metrics_2015.csv")
train_2015<-read.csv(file_15)

tmp = train_2011[,-c("YEAR","STATE","CNTYCD","DEATH_COUNT","POPULATION_COUNT")]

drops <- c("YEAR","STATE","CNTYCD","DEATH_COUNT","POPULATION_COUNT")
train_2011=train_2011[ , !(names(train_2011) %in% drops)]

train_2012=train_2012[ , !(names(train_2012) %in% drops)]

train_2013=train_2013[ , !(names(train_2013) %in% drops)]

train_2014=train_2014[ , !(names(train_2014) %in% drops)]

# train_2011['CRUDE_RATE']=train_2011$SUICIDE_COUNT*1000/train_2011$POPULATION_COUNT
# train_2012['CRUDE_RATE']=train_2012$SUICIDE_COUNT*1000/train_2012$POPULATION_COUNT
# train_2013['CRUDE_RATE']=train_2013$SUICIDE_COUNT*1000/train_2013$POPULATION_COUNT
# train_2014['CRUDE_RATE']=train_2014$SUICIDE_COUNT*1000/train_2014$POPULATION_COUNT





set.seed(998)

fitControl <- trainControl(## 10-fold CV
  method = "repeatedcv",
  number = 10,
  ## repeated ten times
  repeats = 10)

gbmFit1 <- train(SUICIDE_COUNT ~ ., data = train_2011,
                 method = "gbm",n.trees=10,
                 trControl = fitControl,distribution="gaussian", verbose = FALSE)

gbmFit1$finalModel

plot(gbmFit1,n.trees=gbmFit1$finalModel$n.trees)

pretty.gbm.tree(gbmFit1,i.tree= -1)

predictors(gbmFit1)

gbm_dev <- predict(gbmFit1, data=train_2012)
head(cbind(prediction=gbm_dev,actual=train_2012$SUICIDE_COUNT,error = abs(train_2012$SUICIDE_COUNT-gbm_dev)))
      (train_2012$SUICIDE_COUNT-gbm_dev)/train_2012$SUICIDE_COUNT)

summary(gbmFit1)


formula <- as.formula(SUICIDE_COUNT ~.)
t <- train(formula,train_2011,method = "rpart",cp=0.002,maxdepth=8)
plot(t$finalModel)
text(t$finalModel)

gbmFit12 <- train(SUICIDE_COUNT ~ ., data = train_2012,
                 method = "gbm",
                 trControl = fitControl,distribution="gaussian", verbose = FALSE)

plot(gbmFit1,n.trees=gbmFit1$n.trees)


predictors(gbmFit12)

gbm_dev <- predict(gbmFit1, data=train_2012)
head(cbind(prediction=gbm_dev,actual=train_2012$SUICIDE_COUNT,error = abs(train_2012$SUICIDE_COUNT-gbm_dev)))
(train_2012$SUICIDE_COUNT-gbm_dev)/train_2012$SUICIDE_COUNT)


######## ATEMPT to do time series analysis
#removing employemnt rate did not impact the AIC

suci_2015=railway_suicide[railway_suicide$YEAR == 2015,c('SUICIDE_ATTEMPTED','MONTH','COUNTY_x','STATEDESC_x','YEAR')]
suci_2014=railway_suicide[railway_suicide$YEAR == 2014,c('SUICIDE_ATTEMPTED','MONTH','COUNTY_x','STATEDESC_x','YEAR')]
suci_2013=railway_suicide[railway_suicide$YEAR == 2013,c('SUICIDE_ATTEMPTED','MONTH','COUNTY_x','STATEDESC_x','YEAR')]
suci_2012=railway_suicide[railway_suicide$YEAR == 2012,c('SUICIDE_ATTEMPTED','MONTH','COUNTY_x','STATEDESC_x','YEAR')]
suci_2011=railway_suicide[railway_suicide$YEAR == 2011,c('SUICIDE_ATTEMPTED','MONTH','COUNTY_x','STATEDESC_x','YEAR')]

suci_2015$SUICIDE_ATTEMPTED <- num() 
suci_2015_ag <- aggregate(SUICIDE_ATTEMPTED ~ MONTH+YEAR, data=suci_2015, sum,na.action=na.omit)
suci_2014_ag <- aggregate(SUICIDE_ATTEMPTED ~ MONTH+YEAR, data=suci_2014, sum,na.action=na.omit)
suci_2013_ag <- aggregate(SUICIDE_ATTEMPTED ~ MONTH+YEAR, data=suci_2013, sum,na.action=na.omit)
suci_2012_ag <- aggregate(SUICIDE_ATTEMPTED ~ MONTH+YEAR, data=suci_2012, sum,na.action=na.omit)
suci_2011_ag <- aggregate(SUICIDE_ATTEMPTED ~ MONTH+YEAR, data=suci_2011, sum,na.action=na.omit)

combined_year <- rbind(suci_2015_ag,suci_2014_ag,suci_2013_ag,suci_2012_ag,suci_2011_ag)
par(mfrow = c(1,1))


#TIME SERIES ANALYSIS
suicide.ts <- ts(combined_year$SUICIDE_ATTEMPTED,start=2011,,frequency=12)


adf.test(diff(suicide.ts))

plot(suicide.ts, col = "blue",  main = "Suicide",ylab="values", xlab="Time Period")

# model = auto.arima(suicide.ts)

plot(decompose(suicide.ts, type= "additive", filter=NULL),col='blue')
acf(suicide.ts)
pacf(suicide.ts)

get.best.ma <- function (x.ts,maxord=c(0,0,1))
{
  best.aic <- Inf
  n <- length(x.ts)
  for(q in 0:maxord[3]) 
  {
    fit <- Arima(x.ts, order=c(0,0,q))
    fit.aic <- -2 * fit$loglik + (log(n)+1)*length(fit$coef)
    if(fit.aic < best.aic)
    {
      best.aic <- fit.aic
      best.fit <- fit
      best.model <- c(0,0,q)
    }
  }
  list(best.aic,best.fit,best.model)
}


best.ma.suicide <- get.best.ma(suicide.ts,maxord=c(0,0,4))
best.ma.suicide[[1]]
best.ma.suicide[[3]]
best.fit.s<-best.ma.suicide[[2]]
acf(resid(best.fit.s))
summary(best.fit.s)
cbind(suicide.ts, fitted(best.fit.s), best.fit.s$resid)

forecast(best.fit.s,h=12)
plot(forecast(best.fit.s,h=12),lty=2,
     main="Out-of-Sample Forecast",
     ylab="Original, Estimated, and Forecast Values")

ma2 <- Arima(suicide.ts[1:(length(suicide.ts)-12)], order=c(0,0,2))
summary(ma2)
length(fitted(ma2))
cbind(suicide.ts[1:(length(suicide.ts)-12)], fitted(ma2), ma2$resid)

# Step 2: Out-of-Sample Forecast
ma2.fcast <- forecast.Arima(ma2, h=12)

par(mfrow=c(1,1))
plot(ma2.fcast,lty=2,
     main="Out-of-Sample Forecast",
     ylab="Original, Estimated, and Forecast Values")

par(new=T)
plot.ts(suicide.ts, col="navy",axes=F,ylab="", lty=1)

leg.txt <- c("Original Series", "Forecast series")
legend("top", legend=leg.txt, lty=1, col=c("navy","blue"),
       bty='n', cex=1)

aggregate(SUICIDE_ATTEMPTED ~ YEAR, data=suci_2011_ag, mean)

