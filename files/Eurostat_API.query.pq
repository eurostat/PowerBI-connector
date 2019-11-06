// Use this file to write queries to test your data connector
let
    result = Eurostat_API.Contents("http://ec.europa.eu/eurostat/wdds/rest/data/v2.1/json/en/nama_10_gdp?na_item=B1G&na_item=D21&precision=1&geo=AT&geo=FR&unit=CLV05_MEUR&unit=CLV05_MNAC&unit=CLV_I05&time=2017")
in
    result
