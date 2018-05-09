import requests
import datetime
import time
import pandas as pd 
import numpy as np

#helper functions
def timeit(time):
	return(datetime.datetime.fromtimestamp(int(time)).strftime('%Y-%m-%d %H:%M'))

def spull():
	#pull spot data
	sdata = []
	#example link spot https://www.okex.com/api/v1/ticker.do?symbol=bch_usdt
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

def fpull():
	#pull futures data	
	fdata = []
	#example link futures https://www.okex.com/api/v1/future_ticker.do?symbol=bch_usd&contract_type=next_week
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

def fclean(import_data):
	#takes data and cleans and exports data as pandas
	export_data = []
	for x in range(0,len(import_data)):
		entry = {
					'futures_ticker': import_data[x]['futures_ticker'],
					'fdate': import_data[x]['fdate'],
					'fdatetime': timeit(import_data[x]['response']['date']),
					'fsystime': timeit(time.time()),
					'future_last': import_data[x]['response']['ticker']['last']
					}
		export_data.append(entry)

	return pd.DataFrame(export_data)
	
def sclean(import_data):
	#takes data and cleans and exports data as pandas
	export_data = []
	for x in range(0,len(import_data)):
		entry = {
					'spot_ticker': import_data[x]['spot_ticker'][:7],
					'sdatetime': timeit(import_data[x]['response']['date']),
					'ssystime': timeit(time.time()),
					'spot_last': import_data[x]['response']['ticker']['last']
					}
		export_data.append(entry)

	return pd.DataFrame(export_data)

def switch_date(argument):
	#switch function, 0 is monday, 6 is sunday. If currently it is monday, 5 more days left until Friday (when contracts end)	
    switcher = {
        0: 5,
        1: 4,
        2: 3,
        3: 2,
        4: 1,
        5: 0,
        6: 6
    }
    return switcher.get(argument, -1)

def fulldata():
	#pulls spot and futures data
	sdf = sclean(spull())
	fdf = fclean(fpull())
	df = sdf.merge(fdf, how='inner', left_on = 'spot_ticker',right_on = 'futures_ticker')

	#chooses the columns I actually need
	# df = df[[
	# 	'spot_ticker','spot_last','future_last','fdate'
	# ]]	

	df[['spot_last','future_last']] = df[['spot_last','future_last']].apply(pd.to_numeric)	
	df['premium'] = (df['future_last'] - df['spot_last']) / df['spot_last']

	#adding number of days left
	conditions = [
	    (df['fdate'] == 'this_week') ,
	    (df['fdate'] == 'next_week') ,
	    (df['fdate'] == 'quarter')]

	choice1 = switch_date(datetime.datetime.today().weekday())
	choice2 = choice1 + 7
	
	now = datetime.datetime.now()
	today = datetime.date.today()
	
	q1 = (datetime.date(now.year, 3, 30) - today).days
	q2 = (datetime.date(now.year, 6, 29) - today).days
	q3 = (datetime.date(now.year, 9, 28) - today).days
	q4 = (datetime.date(now.year, 12, 28) - today).days

	q = [q1,q2,q3,q4]
	q = [item for item in q if item >= 0]
	choice3 = min(q)	
	choices = [choice1, choice2, choice3]
	df['daysleft'] = np.select(conditions, choices, default=-1)

	df['annual_return'] = (1+df['premium']) ** ( 365/df['daysleft'])

	df = df[[
		'spot_ticker','premium','daysleft','annual_return','fdate','spot_last','future_last'
		,'ssystime','sdatetime','fdatetime','fsystime'
	]]

	return df.sort_values(['premium'], ascending=False)

def csv_update_current():
	df = fulldata()
	df.to_csv('premiums.csv', encoding='utf-8', index=False)
	print('added current premium csv file')

def csv_update_history():
	df = fulldata()
	df.to_csv('premiums_historical.csv', encoding='utf-8', index=False, mode='a', header=False)
	print('added historical csv file')	

# removing column
# df.drop(columns=['new'])

