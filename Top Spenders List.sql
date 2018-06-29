
use marketing
go

select  c.store_num as StudioNumber,
c.fname as FirstName,
c.lname as LastName,
C.on_mailing_list as OnMailingList,
C.on_email_list as OnEmailList,
(SUBSTRING(c.hm_phone, 1, 3) + '-' + SUBSTRING(c.hm_phone, 4, 3) + '-' + SUBSTRING(c.hm_phone, 7, 4)) as HomePhone,  
CONVERT(VARCHAR(10), h.TransDate, 101) as TransDate, 
 h.sales as Sales,
 CASE
    WHEN h.TransDate > b.last_visit 
     THEN CONVERT(VARCHAR(10), h.TransDate, 101)
     ELSE CONVERT(VARCHAR(10), b.last_visit, 101)
     END AS LastVisitDate 

from pos_customers.dbo.customer c with (nolock)
inner join (--h
	SELECT a.s21_cust_num, max(a.t_date) AS TransDate,  max(a.sales) as sales
	from  marketing.dbo.trans_header a  (nolock)
	WHERE a.t_date BETWEEN '01/01/17' AND '12/31/17' and a.sales >= 150
	--and  b.s21_cust_num is null
	group by a.s21_cust_num 
	) h
on c.s21_cust_num = h.s21_cust_num
left join pos_customers.dbo.customer_birthday b on c.s21_cust_num = b.s21_cust_num
LEFT OUTER JOIN pos_customers.dbo.DoNotCall dnc with(nolock) ON c.hm_phone= dnc.PhoneNumber
INNER JOIN ep.dbo.store s ON s.store = c.store_num  --and  s.sto_lactive=1 --and region  < 3
WHERE c.hm_phone IS NOT NULL --and s.region = 1 
--and h.TransDate > b.last_visit
order by c.store_num, c.lname, c.fname



--select top 1000 * from pos_customers.dbo.customer





/***********************************************************************************************************
Name: Top spenders script
Purpose: Ad-hoc telemarketing script
Description: Script that returns top spenders  between a date range

Defined Parameters:
		

Special Notes: This procedure is executed by a scheduled task name “XXXX” that runs…
***************************************************************************************************************
Date			Developer’s Name			Description of Change (including Ticket number)
*************	************************	*******************************************************
04/19/2017		Afra Quadri					Ticket 00155009 - Created script						
**************************************************************************************************************/

-- Region 1

select  c.store_num as StudioNumber,
c.fname as FirstName,
c.lname as LastName,
(SUBSTRING(c.hm_phone, 1, 3) + '-' + SUBSTRING(c.hm_phone, 4, 3) + '-' + SUBSTRING(c.hm_phone, 7, 4)) as HomePhone,  
CONVERT(VARCHAR(10), h.TransDate, 101) as TransDate, 
 h.sales as Sales,
 CASE
    WHEN h.TransDate > b.last_visit 
     THEN CONVERT(VARCHAR(10), h.TransDate, 101)
     ELSE CONVERT(VARCHAR(10), b.last_visit, 101)
     END AS LastVisitDate 

from pos_customers.dbo.customer c with (nolock)
inner join (--h
	SELECT a.s21_cust_num, max(a.t_date) AS TransDate,  max(a.sales) as sales
	from  marketing.dbo.trans_header a  (nolock)
	WHERE a.t_date BETWEEN '01/01/17' AND '12/31/17' and a.sales >= 100
	--and  b.s21_cust_num is null
	group by a.s21_cust_num 
	) h
on c.s21_cust_num = h.s21_cust_num
left join pos_customers.dbo.customer_birthday b on c.s21_cust_num = b.s21_cust_num
LEFT OUTER JOIN pos_customers.dbo.DoNotCall dnc with(nolock) ON c.hm_phone= dnc.PhoneNumber
INNER JOIN ep.dbo.store s ON s.store = c.store_num  and  s.sto_lactive=1 and region  < 3
WHERE c.hm_phone IS NOT NULL and s.region = 1 
--and h.TransDate > b.last_visit
order by c.store_num, c.lname, c.fname



-- Region 2



select  c.store_num as StudioNumber,
c.fname as FirstName,
c.lname as LastName,
(SUBSTRING(c.hm_phone, 1, 3) + '-' + SUBSTRING(c.hm_phone, 4, 3) + '-' + SUBSTRING(c.hm_phone, 7, 4)) as HomePhone,  
CONVERT(VARCHAR(10), h.TransDate, 101) as TransDate, 
 h.sales as Sales,
 CASE
    WHEN h.TransDate > b.last_visit 
     THEN CONVERT(VARCHAR(10), h.TransDate, 101)
     ELSE CONVERT(VARCHAR(10), b.last_visit, 101)
     END AS LastVisitDate 

from pos_customers.dbo.customer c with (nolock)
inner join (--h
	SELECT a.s21_cust_num, max(a.t_date) AS TransDate,  max(a.sales) as sales
	from  marketing.dbo.trans_header a  (nolock)
	WHERE a.t_date BETWEEN '10/01/17' AND '12/31/17' and a.sales >= 100
	--and  b.s21_cust_num is null
	group by a.s21_cust_num 
	) h
on c.s21_cust_num = h.s21_cust_num
left join pos_customers.dbo.customer_birthday b on c.s21_cust_num = b.s21_cust_num
LEFT OUTER JOIN pos_customers.dbo.DoNotCall dnc with(nolock) ON c.hm_phone= dnc.PhoneNumber
INNER JOIN ep.dbo.store s ON s.store = c.store_num  and  s.sto_lactive=1 and region  < 3
WHERE c.hm_phone IS NOT NULL and s.region = 2 --and h.TransDate > b.last_visit
order by c.store_num, c.lname, c.fname


-- Region 3

select  c.store_num as StudioNumber,
c.fname as FirstName,
c.lname as LastName,
(SUBSTRING(c.hm_phone, 1, 3) + '-' + SUBSTRING(c.hm_phone, 4, 3) + '-' + SUBSTRING(c.hm_phone, 7, 4)) as HomePhone,  
CONVERT(VARCHAR(10), h.TransDate, 101) as TransDate, 
 h.sales as Sales,
 CASE
    WHEN h.TransDate > b.last_visit 
     THEN CONVERT(VARCHAR(10), h.TransDate, 101)
     ELSE CONVERT(VARCHAR(10), b.last_visit, 101)
     END AS LastVisitDate 

from pos_customers.dbo.customer c with (nolock)
inner join (--h
	SELECT a.s21_cust_num, max(a.t_date) AS TransDate,  max(a.sales) as sales
	from  marketing.dbo.trans_header a  (nolock)
	WHERE a.t_date BETWEEN '10/01/17' AND '12/31/17' and a.sales >= 100
	--and  b.s21_cust_num is null
	group by a.s21_cust_num 
	) h
on c.s21_cust_num = h.s21_cust_num
left join pos_customers.dbo.customer_birthday b on c.s21_cust_num = b.s21_cust_num
LEFT OUTER JOIN pos_customers.dbo.DoNotCall dnc with(nolock) ON c.hm_phone= dnc.PhoneNumber
INNER JOIN ep.dbo.store s ON s.store = c.store_num  and  s.sto_lactive=1 and region  = 3
--WHERE c.hm_phone IS NOT NULL and s.region = 3 --and h.TransDate > b.last_visit
WHERE c.hm_phone IS NOT NULL and s.region = 3  --and h.TransDate > b.last_visit
order by c.store_num, c.lname, c.fname


--- store 246
select  c.s21_cust_num,c.store_num as StudioNumber,
c.fname as FirstName,
c.lname as LastName,
(SUBSTRING(c.hm_phone, 1, 3) + '-' + SUBSTRING(c.hm_phone, 4, 3) + '-' + SUBSTRING(c.hm_phone, 7, 4)) as HomePhone,  
CONVERT(VARCHAR(10), h.TransDate, 101) as TransDate, 
 h.sales as Sales,
 CASE
    WHEN h.TransDate > b.last_visit 
     THEN CONVERT(VARCHAR(10), h.TransDate, 101)
     ELSE CONVERT(VARCHAR(10), b.last_visit, 101)
     END AS LastVisitDate 
into #temptopspend
from pos_customers.dbo.customer c with (nolock)
inner join (--h
	SELECT a.s21_cust_num, max(a.t_date) AS TransDate,  max(a.sales) as sales
	from  marketing.dbo.trans_header a  (nolock)
	WHERE a.t_date BETWEEN '01/01/17' AND '12/31/17' and a.sales >= 150
	--and  b.s21_cust_num is null
	group by a.s21_cust_num 
	) h
on c.s21_cust_num = h.s21_cust_num
left join pos_customers.dbo.customer_birthday b on c.s21_cust_num = b.s21_cust_num
LEFT OUTER JOIN pos_customers.dbo.DoNotCall dnc with(nolock) ON c.hm_phone= dnc.PhoneNumber
INNER JOIN ep.dbo.store s ON s.store = c.store_num and  s.store = 376  
WHERE c.hm_phone IS NOT NULL 
--and h.TransDate > b.last_visit
order by c.store_num, c.lname, c.fname

update ts
set LastVisitDate = CONVERT(VARCHAR(10), lastvist, 101)

select * 
from #temptopspend ts
inner join (select s21_cust_num, max(t_date) as lastvist
from  marketing.dbo.trans_header
--where store_num = 246
group by  s21_cust_num
having ( count(s21_cust_num) > 0 )
) head on head.s21_cust_num = ts.s21_cust_num

select StudioNumber, FirstName, LastName,HomePhone,
TransDate,Sales,LastVisitDate 
from #temptopspend
order by 7 desc

