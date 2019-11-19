# Eurostat-API-custom-connector
<h3>Power BI custom connector for Eurostat API</h3>


The connector delivered by this project allow for access to <a href="https://ec.europa.eu/eurostat/web/json-and-unicode-web-services/getting-started/rest-request">Eurostat’s REST API</a>,which API deliver data in JSON-stat format. Although it is possible to load data in JSON-stat format to Power BI, it is not straightforward (
<a href="https://eriksvensen.wordpress.com/2019/01/09/guide-how-to-import-data-from-eurostat-directly-into-powerbi/">you can try to do it using this guide</a> )

<h3>Installation</h3>

To use a Custom Connector, put Eurostat API.mez file in the [Documents]\Power BI Desktop\Custom Connectors folder, and adjust the security settings as described <a href="https://docs.microsoft.com/en-us/power-bi/desktop-connector-extensibility"> on this website.</a>

<h3>How to use</h3>

Power BI uses star schema model to connect datasets. Data returned from Eurostat’s API have many dimensions ( Year, Geo, Sex, …). The connector splits every dimension into separate table and create common id which connects all tables. There are three steps necessary to load data from the Eurostat’s API to Power Bi:
1)	Find a dataset
2)	Create an URL
3)	Load data 

<h4>Step 1. Finding a dataset</h4>

Datasets can be found in <a href="https://ec.europa.eu/eurostat/data/database">Eurostat’s database</a>.


<h4>Step 2. Creating an URL</h4>


<h4>Step 3. Loading data</h4>
