import requests
import datetime
import time
import pandas as pd 


#helper functions
def timeit(time):
	return(datetime.datetime.fromtimestamp(int(time)).strftime('%Y-%m-%d %H:%M'))


#pull spot data
def spull():
	sdata = []
	#spot https://www.okex.com/api/v1/ticker.do?symbol=bch_usdt
	spots_tickers = ['bch_usdt','btc_usdt','ltc_usdt','eth_usdt','xrp_usdt','eos_usdt','etc_usdt','btg_usdt']
	spot_slug = 'https://www.okex.com/api/v1/ticker.do?symbol='
	for spot in spots_tickers:
		link = spot_slug + spot 
		response = requests.get(link)

		jresp = response.json()
		data = {	'spot_ticker': spot,
					'response' : jresp
				}
		sdata.append(data)

	return sdata

#pull futures data
def fpull():

	fdata = []
	#futures https://www.okex.com/api/v1/future_ticker.do?symbol=bch_usd&contract_type=next_week
	future_slug = 'https://www.okex.com/api/v1/future_ticker.do?symbol='
	date_slug = '&contract_type='

	futures_tickers = ['bch_usd','btc_usd','ltc_usd','eth_usd','xrp_usd','eos_usd','etc_usd','btg_usd']

	fdates = ['this_week','next_week','quarter']

	for futures_ticker in futures_tickers:
		for fdate in fdates:
			link = future_slug + futures_ticker + date_slug + fdate
			response = requests.get(link)
			jresp = response.json()
			data = { 
					'futures_ticker':futures_ticker,
					'fdate' : fdate,
					'response' : jresp
					}
			fdata.append(data)

	return fdata

def fdatacleanRAW(import_data):
	#takes data and cleans and exports data as list of dictionaries
	export_data = []
	for x in range(0,len(import_data)):
		entry = {
					'futures_ticker': import_data[x]['futures_ticker'],
					'fdate': import_data[x]['fdate'],
					'datetime': timeit(import_data[x]['response']['date']),
					'systime': timeit(time.time()),
					'last': import_data[x]['response']['ticker']['last']
					}
		export_data.append(entry)
	return export_data

def sdatacleanRAW(import_data):
	#takes data and cleans and exports data as list of dictionaries
	export_data = []
	for x in range(0,len(import_data)):
		entry = {
					'spot_ticker': import_data[x]['spot_ticker'][:7],
					'datetime': timeit(import_data[x]['response']['date']),
					'systime': timeit(time.time()),
					'last': import_data[x]['response']['ticker']['last']
					}
		export_data.append(entry)
	return export_data	


def fdatapandas():
	df = pd.DataFrame(fdatacleanRAW(fpull()))
	return df 

def sdatapandas():
	df = pd.DataFrame(sdatacleanRAW(spull()))
	return df 







