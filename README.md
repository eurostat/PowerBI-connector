# Eurostat-API-custom-connector
### Power BI custom connector for Eurostat API


The connector delivered by this project allows for access to [Eurostat’s REST API](https://ec.europa.eu/eurostat/web/json-and-unicode-web-services/getting-started/rest-request), which delivers data in JSON-stat format. Although it is possible to load data in JSON-stat format to Power BI, it is not straightforward [you can try to do it using this guide](https://eriksvensen.wordpress.com/2019/01/09/guide-how-to-import-data-from-eurostat-directly-into-powerbi) )

### Installation

To use a Custom Connector, put Eurostat API.mez file in the [Documents]\Power BI Desktop\Custom Connectors folder, and adjust the security settings as described [on this website](https://docs.microsoft.com/en-us/power-bi/desktop-connector-extensibility).

### How to use

Power BI uses star schema model to connect datasets. Data returned from Eurostat’s API have many dimensions ( Year, Geo, Sex, …). The connector splits every dimension into separate tables and create common id which connects all tables. There are three steps necessary to load data from the Eurostat’s API to Power Bi:
1)	Find a dataset
2)	Create an URL
3)	Load data

#### Step 1. Finding a dataset

Datasets can be found in [Eurostat’s database](https://ec.europa.eu/eurostat/data/database).

<table>
<header>
<td align="centre">Eurostat's database</td>
</header>
<tr>
<td><kbd><a href="https://ec.europa.eu/eurostat/data/database"><img src="docs/eurostat_database.png" alt="Eurostat's database" width="800"></a></kbd></td>
</tr>
</table>

Each dataset has its unique code (like nama_10_gdp). This code is necessary in the next step.

#### Step 2. Creating an URL

In order to get data from Eurostat, connector needs properly formated  URL to Eurostat's API. The best way to create this URL is to use [Query Builder](https://ec.europa.eu/eurostat/web/json-and-unicode-web-services/getting-started/query-builder).

<table>
<header>
<td align="centre">Query builder</td>
</header>
<tr>
<td><kbd><a href="https://ec.europa.eu/eurostat/data/database"><img src="docs/query_builder.png" alt="Query builder" width="400"></a></kbd></td>
</tr>
</table>

Building an URL is quite easy – the only caveat is that there is the limit of 50 categories. If this limit is exceed, no data will be returned. Connector will show the error:

<table>
<header>
<td align="centre">Error</td>
</header>
<tr>
<td><kbd><a href="https://ec.europa.eu/eurostat/data/database"><img src="docs/PBI_error.png" alt="Error" width="800"></a></kbd></td>
</tr>
</table>



<table>
<header>
<td align="centre">Query generator</td>
</header>
<tr>
<td><kbd><a href="https://ec.europa.eu/eurostat/data/database"><img src="docs/query_builder2.png" alt="Query generator" width="800"></a></kbd></td>
</tr>
</table>

The output will be like this

<table>
<header>
<td align="centre">Query generator - output</td>
</header>
<tr>
<td><kbd><a href="https://ec.europa.eu/eurostat/data/database"><img src="docs/query_builder3.png" alt="Query generator - output" width="800"></a></kbd></td>
</tr>
</table>

#### Step 3. Loading data
