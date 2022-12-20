# Librerias necesarias
library(survminer)
library(survival)
library(tidyverse)
library(magrittr)
library(ggalt)
library(openxlsx)
library(ggfortify)

# Cargamos la base de datos:
rm(list = ls())


load("data_model.RData")
write.xlsx(data.model, file = "DataForModel.xlsx", rowNames = T)

#attach(data.model)
#detach(data.model)

df <- data.model[,c(1,8,9,10,11)]


fit <- survfit(Surv(time_ccm, ccm) ~ treat, data = df)


summary(fit)

fortify(fit)


ggsurvplot(fit,data = df, 
           conf.int = FALSE, 
           surv.median.line = "hv", ylim = c(0.93,1),
           risk.table = T)



df[24:50,] %>%  ggplot(.,
       mapping = aes(x = rep(0,27),
                     xend = time_ccm,
                     y = fct_rev(paste0("P-",24:50)),
                     color = fct_recode(factor(ccm))))+
  geom_dumbbell(size_x = 2, size_xend = 2)
###################################################################



time.ccm1[rowSums(time.ccm1 == rep(1,13), na.rm = T) != ncol(time.ccm1),]
  
  
time.anatf1[rowSums(time.anatf1 == rep(1,13), na.rm = T) != ncol(time.anatf1),]
  
  
  
  

