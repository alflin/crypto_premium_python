import requests
import datetime

def spull():
	
	sdata = []
	#spot https://www.okex.com/api/v1/ticker.do?symbol=bch_usdt
	spots_tickers = ['bch_usdt','btc_usdt','ltc_usdt','eth_usdt','xrp_usdt','eos_usdt','etc_usdt','btg_usdt']
	spot_slug = 'https://www.okex.com/api/v1/ticker.do?symbol='
	for spot in spots_tickers:
		link = spot_slug + spot 
		response = requests.get(link)
		sdata.append(response.json())

	return sdata


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

def timeit(time):
	print(datetime.datetime.fromtimestamp(int(time)).strftime('%Y-%m-%d %H:%M:%S'))

