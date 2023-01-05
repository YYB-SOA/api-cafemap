# MoneyPlan

Overview
--
Moneyplan is a web service that allows you search the coffee shop near you or the coffee shop located at targeted region.
We use 3 API to provide you a information integration platform for cafe shop.

1. Short-term usability goals
Integreted cafe nomad and the data of place api


2. API  information
* Name : Cafe nomad
* Url : https://cafenomad.tw/api/v1.2/cafes
* Description : 

Open-source Cafe platform. No need for the token.

* Name : place api
* Url : https://maps.googleapis.com/maps/api/place/textsearch/json?query=#{input}&key=#{token}&language=zh-TW

* Description : 
We use the place api, which is supported by Google, to search regional cafe shop information on google map. However, due to this api is charable, we saved it in out database as cache and use vcr package to lower the request sending demand for our platform.

3. Long-term usability goals

Added addtional api for locate the user without loggin required.
It haven't been built yet. We will build this function in the future.

* Name : google map
* Url : https://developers.google.com/maps?hl=zh-tw
* Description : 

Get the users location. We will use the longitude and latitude of user to caculate the distance of the cofffee shops to recommended.


# CafeMap Web API

Web API that allows user search the local cafe store with abundant informations.

## Routes

### Root check

`GET /`

Status:

- 200: API server running (happy)

### Recommend a previously stored project

`GET /cafemap/{city_name}/{store_name}[/{store_list}/]`

Status

- 200: cafestores returned (happy)
- 404: city name or folder not found (sad)
- 500: problem may resulted from server side, kindly clear the cookie or use newest version browser (bad)

### Store interested store into cache

`POST /cafemap/{city_name}/{interest}[/{store_list}/]`

Status

- 201: stores stored (happy)
- 404: store or city-specified or folder not found on database  (sad)
- 500: server error: problems storing store  (bad)

