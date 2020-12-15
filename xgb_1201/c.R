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


t2 <-  datasets::Titanic %>% 
  as_tibble() %>% 
  uncount(n) 

xgb_1201 <- xgb.load("../xgb_0821.file")
# Error in xgb.Booster.handle(modelfile = modelfile) : 
  # [22:36:39] amalgamation/../src/objective/./regression_loss.h:89: Check failed: base_score > 0.0f && base_score < 1.0f: base_score must be in (0,1) for logistic loss, got: -0
t2$pred <- 1/(1+exp(-xgboost:::predict.xgb.Booster(xgb_1201,tdata,type="response"))) 

