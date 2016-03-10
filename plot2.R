if(!file.exists("data")) {
        dir.create("./data")
}
unzip("exdata-data-NEI_data.zip",exdir="./data")
NEI <- readRDS("./data/summarySCC_PM25.rds")
SCC <- readRDS("./data/Source_Classification_Code.rds")

Baltimore_total_emission <- with(NEI, tapply(Emissions[fips == "24510"],
                            year[fips == "24510"],sum,na.rm=T))

png(file = "plot2.png")
plot(names(Baltimore_total_emission), Baltimore_total_emission, type = "n",
     xlab = "Year",ylab = expression(PM[2.5] * "   Emissions"))
points(names(Baltimore_total_emission), Baltimore_total_emission, type = "l")
title (expression("Baltimore City total " * PM[2.5] * " Emissions"))
dev.off()