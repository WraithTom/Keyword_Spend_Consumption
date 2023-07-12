select 
  "AA keyword", 
  "customer search term", 
  campaign_name, 
  campaign_type, 
  "asin", 
  title, 
  division, 
  b.SEARCH_FREQUENCY_RANK,
  c.volume as search_volume,
  date_trunc(month, "date") as month, 
  sum ("AA spend") as AA_Spend, 
  sum ("AA sales") as AA_Sales, 
  avg ("Page Rank") as Avg_org_rank, 
  count("Page Rank") as obsvd_ranks, 
  sum("impressions") as impressions, 
  sum ("clicks") as clicks, 
  sum ("AA Profit") as sum_profit,
  sum ("Total Amazon Sales (AA Supported ASINs)") as Tot_AMZ_Sales,
  sum ("AA spend") / sum(case when "clicks" = 0 then NULL else "clicks" end) as CPC,
  sum ("AA sales") / sum ("Total Amazon Sales (AA Supported ASINs)") as AA_pct_of_tot_Sales,
  sum ("AA spend") / sum(case when "AA sales" = 0 then NULL else "AA sales" end) as ACOS,
  sum ("AA sales")/ sum (case when "AA spend" = 0 then NULL else "AA spend" end) as ROAS

  
  
from PRH_GLOBAL_DK_SANDBOX.PUBLIC.VW_AADASH_CST_UK a
left join 
    (select SEARCH_TERM, SEARCH_FREQUENCY_RANK
    from PRH_GLOBAL_UK_SANDBOX..GDH_EDW_AMAZON_SEARCH_TERMS
    where summary_level = 'Monthly' and department = 'Amazon.co.uk' and SRC_FILE_DATE = '2023-03-31'
    order by SEARCH_FREQUENCY_RANK) b 
on a."AA keyword" = b.SEARCH_TERM

left join
    (select rank, volume 
    from PRH_GLOBAL_DK_SANDBOX.PUBLIC.AMZ_SEARCH_RANK_VOLUME 
    where country = 'uk') c
on b.SEARCH_FREQUENCY_RANK = c.rank

where "date" between '2023-03-01' and '2023-03-31' 
group by 1,2,3,4,5,6,7,8,9,10
order by AA_Spend desc nulls last