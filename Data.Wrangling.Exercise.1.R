setwd("~/Foundations of Data Science")

library(dplyr)
library(tidyr)

# Load the data in R Studio
original <- read.csv("refine_original.csv")

# Clean up the brand names
updated <- tbl_df(original)
updated$company[1:6] <- "philips"
updated$company[7:13] <- "akzo"
updated$company[14:16] <- "philips"
updated$company[17:21] <- "van houten"
updated$company[22:25] <- "unilever"

# Separate product code and number
separated <- separate(updated, Product.code...number, c("product_code", "product_number"), "-")

# Add product categories
mutated <- mutate(separated, category = ifelse(product_code == "p", "Smartphone", ifelse(product_code == "v", "TV", ifelse(product_code == "x", "Laptop", ifelse(product_code == "q", "Tablet", "")))))

#Add full address geocoding
geocoded <- mutate(mutated, full_address = paste(address, ", ", city, ", ", country))

#Create dummy boolean variables for company and product category
dummied <- mutate(geocoded, 
    company_philips = ifelse(company == "philips", 1, 0),
    company_akzo = ifelse(company == "akzo", 1, 0),
    company_van_houten = ifelse(company == "van houten", 1, 0),
    company_unilever = ifelse(company == "unilever", 1, 0)
    ) %>%
  mutate(
    product_smartphone = ifelse(product_code == "p", 1, 0),
    product_laptop = ifelse(product_code == "x", 1, 0),
    product_tv = ifelse(product_code == "v", 1, 0),
    product_tablet = ifelse(product_code == "q", 1, 0)
    )

#Write to CSV
write.csv(dummied, file = "refine_clean.csv")