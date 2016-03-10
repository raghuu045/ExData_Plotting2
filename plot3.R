if(!file.exists("data")) {
        dir.create("./data")
}
unzip("exdata-data-NEI_data.zip",exdir="./data")
NEI <- readRDS("./data/summarySCC_PM25.rds")
SCC <- readRDS("./data/Source_Classification_Code.rds")

library(ggplot2)
library(dplyr)
sub_data <- subset(NEI,fips == "24510", select = c(year,type,Emissions))

grouped <- group_by(sub_data,year,type)

final_data <- summarise(grouped,Emission=sum(Emissions))

png(file = "plot3.png")
g <- ggplot(final_data, aes(x=year, y=Emission)) 
g <- g + geom_point(aes(color=type),size=4)
g <- g + facet_wrap( ~  type, scales="free")
g <- g + labs(y=expression(PM[2.5] * "   Emissions"), 
              x="Year", 
              title = expression("Baltimore City " * PM[2.5] * " Emissions"))
g
dev.off()