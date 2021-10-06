# https://stackoverflow.com/questions/63768949/plotting-uk-regions-using-gadm-data-in-r?rq=1

eng <- rgdal::readOGR(paste0("https://opendata.arcgis.com/datasets/",
                             "8d3a9e6e7bd445e2bdcc26cdf007eac7_4.geojson"))

countries <- rgdal::readOGR(paste0("https://opendata.arcgis.com/datasets/",
                                   "92ebeaf3caa8458ea467ec164baeefa4_0.geojson"))

eng <- sf::st_as_sf(eng)
countries <- sf::st_as_sf(countries)
UK <- countries[-1,] 
names(eng)[3] <- "Region"
names(UK)[3] <- "Region"
UK$objectid <- 10:12
eng <- eng[-2]
UK <- UK[c(1, 3, 9:11)]
UK <- rbind(eng, UK)

saveRDS(eng, "presentations/intermediate-quant/eng.rds")
saveRDS(countries, "presentations/intermediate-quant/countries.rds")
saveRDS(UK, "presentations/intermediate-quant/UK.rds")