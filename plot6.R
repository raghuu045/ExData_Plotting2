if(!file.exists("data")) {
        dir.create("./data")
}
unzip("exdata-data-NEI_data.zip",exdir="./data")
NEI <- readRDS("./data/summarySCC_PM25.rds")
SCC <- readRDS("./data/Source_Classification_Code.rds")

library(ggplot2)
motor_source_logical <- NEI$SCC %in% 
        SCC$SCC[grep("vehicle",SCC$SCC.Level.Two,ignore.case = TRUE)]

baltimore_data <- subset(NEI,SCC %in% SCC[motor_source_logical] & 
                                 fips == "24510", 
                         select = c(SCC,year,type,Emissions,fips))
baltimore_data$city <- rep("Baltimore",nrow(baltimore_data))

los_angeles_data <- subset(NEI,SCC %in% SCC[motor_source_logical] & 
                                   fips == "06037", 
                           select = c(SCC,year,type,Emissions,fips))
los_angeles_data$city <- rep("Los Angeles",nrow(los_angeles_data))

total_baltimore_data <- with(baltimore_data, tapply(Emissions,year,sum,na.rm=T))
baltimore_data <- data.frame(year=names(total_baltimore_data),Emissions=total_baltimore_data,
                             city=rep("Baltimore City",length(total_baltimore_data)))

total_los_angeles_data <- with(los_angeles_data, tapply(Emissions,year,sum,na.rm=T))

los_angeles_data <- data.frame(year=names(total_los_angeles_data),Emissions=total_los_angeles_data,
                city=rep("Los Angeles",length(total_los_angeles_data)))
final_data <- rbind(baltimore_data,los_angeles_data)

png(file = "plot6.png")
g <- ggplot(final_data, aes(x=year, y=Emissions))
g <- g + geom_point(aes(color=city),size=4) + facet_grid( ~  city) 
g <- g + labs(y=expression(PM[2.5] * "   Emissions"), 
              x="Year", 
              title = expression("Motor Vehicle " * PM[2.5] * " Emissions"))
g
dev.off()
