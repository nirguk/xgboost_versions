library(renv)
renv::restore()
library(xgboost)
library(tidyverse)
packageVersion("xgboost")

(tdata <- datasets::Titanic %>% 
  as_tibble() %>% 
  uncount(n) %>% 
  mutate(surv = ifelse(Survived=="No",0L,1L)) %>% 
    select(-Survived) %>% mutate_if(is.character,~as.integer(as.factor(.x))) %>% as.matrix())

xgb_0821 <- xgboost(data=tdata,
        label = tdata[,"surv"],
        objective="binary:logitraw",
        nrounds = 100)

t2 <-  datasets::Titanic %>% 
  as_tibble() %>% 
  uncount(n) 

t2$pred <- 1/(1+exp(-xgboost:::predict.xgb.Booster(xgb_0821,tdata,type="response"))) 

xgboost::xgb.save(model = xgb_0821,fname = "../xgb_0821.file")