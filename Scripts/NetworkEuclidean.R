## Script is adapted from Baek et al (2023). Lonely individuals process the world in idiosyncratic ways. Psychological Science, 34(6), 683-695.
rm(list = ls())#clear

setwd("E:/Cartoon/LME/Data")
Euc <- read.csv("NetworkEuclidean_dele48.csv")
PTData <- read.csv("PT_dele48.csv")
n_unique_dyad <- 1485 #input the number of unique dyads in dataset

#Grouping based on high and low median
PTData$PT_binary <- ifelse(PTData$PT > median(PTData$PT, na.rm = TRUE), "high", "low")

# Transform the dataframe into a dyad-level dataframe
dyad_list <- unique(Euc[,c("sub1", "sub2")])
PTData_dyad <- merge(dyad_list, PTData, by.x = c("sub1"), by.y = c("pID"))
colnames(PTData_dyad)[c(3:4)] <- paste("sub1", colnames(PTData_dyad)[c(3:4)], sep = "_")
PTData_dyad <- merge(PTData_dyad, PTData, by.x = c("sub2"), by.y = c("pID"))
colnames(PTData_dyad)[5:6] <- paste("sub2", colnames(PTData_dyad)[5:6], sep = "_")

PTData_dyad$dyad_PT_binary <- ifelse(PTData_dyad$sub1_PT_binary==c("low") &
                                       PTData_dyad$sub2_PT_binary==c("low"), "low_low", ifelse(
                                         PTData_dyad$sub1_PT_binary==c("high") &
                                           PTData_dyad$sub2_PT_binary==c("high"), "high_high", "low_high"))

#Merge dyad-level dataframes together:
Euc_dyad <- merge(Euc, PTData_dyad, by = c("sub1", "sub2"))


#Create doubled dataframes (adding redundancy) to allow fully-crossed random effects :
library(DescTools)
Euc_dyad_2 <- Euc_dyad
colnames(Euc_dyad_2)[1:2] <- c("sub2", "sub1") # reverse the position of subjects 
Euc_dyad_double <- rbind(Euc_dyad, Euc_dyad_2)


#Dyad-level analysis: Relate Euc with binarized PT

library(emmeans)
library(lmerTest)

emm_options(pbkrtest.limit = 3080)
emm_options(lmerTest.limit = 3080)

md <- lmer(scale(Euc) ~ dyad_PT_binary + (1 | sub1) + (1 | sub2), data = Euc_dyad_double)
emm_md <- emmeans(md, ~ dyad_PT_binary, contr = Contrasts, adjust = "none")


# Set contrasts:
Contrasts <- list(HHvsLL = c(1, 0, -1),
                  HHvsLH = c(1, -1, 0),
                  LHvsLL = c(0, 1, -1))

dyad_Euc_IDC_bin <- function(data)
{
  md <- (lmer(scale(Euc) ~ dyad_PT_binary + (1|sub1) + (1|sub2), data))
  emm_md <- emmeans(md, ~ dyad_PT_binary, contr = Contrasts, adjust = "none")
  
  HHvsLL_B <- summary(emm_md$contrasts)[1,2]
  HHvsLH_B <- summary(emm_md$contrasts)[2,2]
  LHvsLL_B <- summary(emm_md$contrasts)[3,2]
  
  HHvsLL_p <- summary(emm_md$contrasts)[1,6]
  HHvsLH_p <- summary(emm_md$contrasts)[2,6]
  LHvsLL_p <- summary(emm_md$contrasts)[3,6]
  
  HHvsLL_t <- summary(emm_md$contrasts)[1,5]
  HHvsLH_t <- summary(emm_md$contrasts)[2,5]
  LHvsLL_t <- summary(emm_md$contrasts)[3,5]
  
  HHvsLL_se <- summary(emm_md$contrasts)[1,3]
  HHvsLH_se <- summary(emm_md$contrasts)[2,3]
  LHvsLL_se <- summary(emm_md$contrasts)[3,3]
  
  HHvsLL_se <- HHvsLL_se * (sqrt(2*(n_unique_dyad-1)-1)/sqrt((n_unique_dyad-1)-1))
  HHvsLH_se <- HHvsLH_se * (sqrt(2*(n_unique_dyad-1)-1)/sqrt((n_unique_dyad-1)-1))
  LHvsLL_se <- LHvsLL_se * (sqrt(2*(n_unique_dyad-1)-1)/sqrt((n_unique_dyad-1)-1))
  
  HHvsLL_p_penalized <- 2 * pt(-abs(HHvsLL_t), (n_unique_dyad-1))
  HHvsLH_p_penalized <- 2 * pt(-abs(HHvsLH_t), (n_unique_dyad-1))
  LHvsLL_p_penalized <- 2 * pt(-abs(LHvsLL_t), (n_unique_dyad-1))
  
  return(data.frame(HHvsLL_B, HHvsLL_t, HHvsLL_se, HHvsLL_p, HHvsLL_p_penalized, 
                    HHvsLH_B, HHvsLH_t, HHvsLH_se, HHvsLH_p, HHvsLH_p_penalized, 
                    LHvsLL_B, LHvsLL_t, LHvsLL_se, LHvsLL_p, LHvsLL_p_penalized))
}

library(plyr)
dyad_Euc_IDC_results_bin <- ddply(Euc_dyad_double, .(Network), dyad_Euc_IDC_bin)


#Function to rearrange data:
library(reshape2)

func_rearrange <- function(data){
  melt_B <- melt(data[,c("Network","HHvsLL_B", "HHvsLH_B", "LHvsLL_B")], id.vars = c("Network"), measure.vars = c("HHvsLL_B", "HHvsLH_B", "LHvsLL_B"))
  melt_B$variable <- gsub("_B","",melt_B$variable)
  colnames(melt_B) <- c("Network", "contrast", "B")
  
  melt_p <- melt(data[,c("Network","HHvsLL_p_penalized", "HHvsLH_p_penalized", "LHvsLL_p_penalized")], id.vars = c("Network"), measure.vars =
                   c("HHvsLL_p_penalized", "HHvsLH_p_penalized", "LHvsLL_p_penalized"))
  melt_p$variable <- gsub("_p_penalized","",melt_p$variable)
  colnames(melt_p) <- c("Network", "contrast", "p_penalized")
  
  melt_se <- melt(data[,c("Network","HHvsLL_se", "HHvsLH_se", "LHvsLL_se")], id.vars = c("Network"), measure.vars =
                    c("HHvsLL_se", "HHvsLH_se", "LHvsLL_se"))
  melt_se$variable <- gsub("_se","",melt_se$variable)
  colnames(melt_se) <- c("Network", "contrast", "se")
  
  new_data <- merge(melt_B, melt_p, by = c("Network", "contrast"))
  new_data <- merge(new_data, melt_se, by = c("Network", "contrast"))
  new_data$corrected_p <- p.adjust(new_data$p_penalized, method = "fdr")
  return(new_data)
}



dyad_Euc_IDC_results_bin <- func_rearrange(dyad_Euc_IDC_results_bin)

