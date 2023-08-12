SELECT * FROM `xxxxx.store_sales`
 where
ss_sold_date_sk in(2450944,2451176)
and ss_sold_time_sk in (57314,35556,47181)
and ss_item_sk in (1240,17918,5684,8935)
and ss_customer_sk in (94488,94032,39335)
ORDER BY ABS(ss_net_profit);

