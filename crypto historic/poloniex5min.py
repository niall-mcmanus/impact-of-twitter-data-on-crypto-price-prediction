from poloniex import Poloniex
import pandas as pd
from time import mktime, strptime
from calendar import timegm
import datetime

api = Poloniex()
coin = ['BTC_XRP', 'BTC_XMR', 'BTC_STR']
now = datetime.datetime.now().date()


for c in coin:
    raw = api.returnChartData(c, period=300, start=1522800000 ,end= 1524355200)#5min data (dates must be unix timestamp)
    df = pd.DataFrame(raw)

    # adjust dates format and set dates as index
    df['date'] = pd.to_datetime(df["date"], unit='s')

    # show the end of dataframe
    df.to_csv(r'xxxxxxx.csv' % (c,now), index=False)