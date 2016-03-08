library(data.table)
library(dplyr)

setwd("~/Foundations of Data Science")
original <- read.csv("titanic_original.csv")

#Port of embarcation
embarked <- setDT(original)[embarked == "", embarked := "S"]
embarked

#Age
meanAge <- mean(embarked$age, na.rn = TRUE)
aged <- setDT(embarked)[is.null(age), age := meanAge]
  # Other options for setting the age would include acquiring it from another data source or choosing the median age.  Another idea would be to calculate
  # multiple mean ages - one for each of several groups.  For instance you could find that passengers with a parch > 0 have a different mean age than 
  # those with a parch == 0.  Using these means could lend any analyses you perform that includes age more accuracy.

#Lifeboat
noLifeboat <- setDT(aged)[boat == "", boat := "NA"]

#Cabin
  # Unlike some of the above additions, adding in missing records to the cabin column stands to do more harm than good.  Unless there was another dataset
  # we could use to determine the cabin assignments of these passengers, I recommend leaving them blank.

  # A missing value in this column could mean one of a number of things, the original data set with their cabin assignment could have been lost (perhaps 
  # these passengers booked before or after those with a cabin value - perhaps they booked in a different way ie from a different ticket office).

hasCabin <- mutate(noLifeboat, has_cabin_number = ifelse(cabin == "", 0, 1))

write.csv(hasCabin, file = "titanic_clean.csv")