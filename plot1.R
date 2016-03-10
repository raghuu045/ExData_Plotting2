if(!file.exists("data")) {
        dir.create("./data")
}
unzip("exdata-data-NEI_data.zip",exdir="./data")
NEI <- readRDS("./data/summarySCC_PM25.rds")
SCC <- readRDS("./data/Source_Classification_Code.rds")

total_emission <- with(NEI, tapply(Emissions,year,sum,na.rm=T))

png(file = "plot1.png", bg = "transparent")
plot(names(total_emission), total_emission, type = "n",
     xlab = "Year",ylab = expression(PM[2.5] * "   Emissions"))
points(names(total_emission), total_emission, type = "l")
title (expression("United States total " * PM[2.5] * " Emissions"))
dev.off()