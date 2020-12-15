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

xgb_1111 <- xgb.load("../xgb_0821.file")
# Error in xgb.Booster.handle(modelfile = modelfile) : 
  # [22:36:39] amalgamation/../src/objective/./regression_loss.h:89: Check failed: base_score > 0.0f && base_score < 1.0f: base_score must be in (0,1) for logistic loss, got: -0
t2$pred <- 1/(1+exp(-xgboost:::predict.xgb.Booster(xgb_1111,tdata,type="response"))) 

#try to load as raw ????
xgb_1111 <- xgb.load(readBin("../xgb_0821.rawfile",what=raw(),n=20989)) 
t2$pred <- 1/(1+exp(-xgboost:::predict.xgb.Booster(xgb_1111,tdata,type="response"))) 

## try rds ??
(r1 <- readRDS(file="../xgb_0821.rds"))
t2$pred <- 1/(1+exp(-xgboost:::predict.xgb.Booster(r1,tdata,type="response"))) 
# [23:24:33] amalgamation/../src/learner.cc:506: Check failed: mparam_.num_feature != 0 (0 vs. 0) : 0 feature is supplied.  Are you using raw Booster interface?
t2$pred <- 1/(1+exp(-xgboost:::predict.xgb.Booster(xgb.Booster.complete(r1),tdata,type="response"))) 
#ror in xgboost:::predict.xgb.Booster(xgb.Booster.complete(r1), tdata,  : 
# [23:23:49] amalgamation/../src/learner.cc:506: Check failed: mparam_.num_feature != 0 (0 vs. 0) : 0 feature is supplied.  Are you using raw Booster interface?