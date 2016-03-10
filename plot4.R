if(!file.exists("data")) {
        dir.create("./data")
}
unzip("exdata-data-NEI_data.zip",exdir="./data")
NEI <- readRDS("./data/summarySCC_PM25.rds")
SCC <- readRDS("./data/Source_Classification_Code.rds")

library(ggplot2)
coal_source_logical <- NEI$SCC %in% 
        SCC$SCC[grep("coal",SCC$Short.Name,ignore.case = TRUE)]

sub_data <- subset(NEI,SCC %in% SCC[coal_source_logical], 
                     select = c(SCC,year,type,Emissions))

final_data <- with(sub_data, tapply(Emissions,year,sum,na.rm=T))

df <- data.frame(year=names(final_data),Emissions=final_data)

png(file = "plot4.png")
g <- ggplot(df, aes(x=year, y=Emissions))
g <- g + geom_point(size=4,color="green")
g <- g + labs(y=expression(PM[2.5] * "   Emissions"), 
              x="Year", 
              title = expression("United States Coal Combustion " 
                                 * PM[2.5] * " Emissions"))
g
dev.off()
