## ----message=FALSE, warning=FALSE, include=FALSE--------------------------------
# Librerías Necesarias:
library(survminer)
library(survival)
library(tidyverse)
library(magrittr)
library(ggalt)
library(openxlsx)
library(ggfortify)
library(kableExtra)
library(knitr)
library(xtable)
library(StepReg)
library(biostat3)
library(radiant)
# data-base loading
load("data_model.RData")
data.model2 %<>% as_tibble()
data.model2 %>% head()
rm(data.model)


## ---- fig.align='center', echo=FALSE--------------------------------------------
attach(data.model2)
lifetab2(Surv(time_ccm, ccm) ~ 1,
         data.model2, breaks = c(0,6,12,18,24)) %>%
  kable(., booktabs = T, digits = 6, format = "latex",
        longtable = TRUE,
        caption = "tabla de vida sin discriminar por tratamiento") %>%
  kable_styling(font_size = 7)


## ---- echo=FALSE----------------------------------------------------------------
result <- pivotr(
  data.model2, 
  cvars = c("treat", "time_ccm"), 
  nvar = "ccm", 
  fun = "sum", 
  nr = Inf
)

# summary()
result$tab_freq %>%
  kable(., booktabs = T,
        caption = "resumen del no. de eventos por tratamiento") %>%
  kable_styling(., full_width = T, latex_options = "hold_position")


## ---- echo=FALSE----------------------------------------------------------------
# Ajuste del modelo Kaplan:
fit <- survfit(Surv(time_ccm, ccm) ~ treat, data = data.model2)
fortify(fit) %>% xtable()



## ---- echo=FALSE----------------------------------------------------------------
ggsurvplot(fit,data = data.model2,
           ylim = c(0.93,1),palette = "grey", ggtheme = theme_bw())+
  labs(title = "Curva de Supervivencia Kaplan-Meier",
       subtitle = "Por tipo de tratamiento")+
  xlab("Tiempo (en meses)")+ylab("Probabilidad de supervivencia")


## ---- echo=FALSE, include=FALSE, eval=FALSE-------------------------------------
## 

log_rank <- survdiff(Surv(time_ccm, ccm) ~ treat, data = data.model2, rho = 0) # Log-Rank test
print("Log-Rank test")
print("Resultados")
log_rank # Resultados
print("Valor del Estadístico de prueba Log-Rank")
round(log_rank$chisq,4) # Valor del Estadístico de prueba Log-Rank
print("Valor p asociado a este test")
round(pchisq(log_rank$chisq,1,lower.tail = F),4) # Valor p asociado a este test

