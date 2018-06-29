use ep
go


CREATE PROCEDURE [dbo].[usp_FairIsaac_Extract] AS



declare @begindate char(12)

declare @enddate char(12)

declare @earlydate char(12)

Select @enddate = dateadd(day, -1, Convert(char(12), getdate(), 1))

Select @begindate = dateadd(day, -14, Convert(char(12), getdate(), 1))

Select @earlydate = dateadd(day, -14, Convert(char(12), getdate(), 1))



--Truncate table ep.dbo.fi_record_count



/********************************************************************************/

/* coupon code table */

/********************************************************************************/

/***** discontinued using media marketing view   11/6 2005   *********/

/*

truncate table ep.dbo.fi_coupon_codes



insert into ep.dbo.fi_coupon_codes

select distinct coupon_id, description, begin_on, end_on, 

markdown, discount, sales_price  

from ep.dbo.coupon_style



insert into ep.dbo.fi_record_count

select 'fi_coupon_codes' as table_name, convert(char(10),getdate(),101) as rundate, count(*) as record_count

from ep.dbo.fi_coupon_codes

*/



/********************************************************************************/

/* item hierarchy table */

/********************************************************************************/



--truncate table ep.dbo.fi_item_hierarchy



insert into

ep.dbo.fi_item_hierarchy

select 

ep.dbo.item.sku_num,

ep.dbo.item.sku_desc,

ep.dbo.item.dept,

ep.dbo.item.sub_dept,

ep.dbo.item.class,

ep.dbo.item.sub_class,

ep.dbo.jda_invdpt.dept_desc,

ep.dbo.jda_invdpt.sub_dept_desc,

ep.dbo.jda_invdpt.class_desc,

ep.dbo.jda_invdpt.sub_class_desc

from ep.dbo.item WITH(NOLOCK) inner join ep.dbo.jda_invdpt WITH(NOLOCK) on

ep.dbo.item.dept = ep.dbo.jda_invdpt.dept and

ep.dbo.item.sub_dept = ep.dbo.jda_invdpt.sub_dept and

ep.dbo.item.class = ep.dbo.jda_invdpt.class and

ep.dbo.item.sub_class = ep.dbo.jda_invdpt.sub_class



/***** add ecommerce SKUs to the item hierarchy table ***/

insert into ep.dbo.fi_item_hierarchy

select 

Sku, 

Name, 

dept, 

sub_dept, 

class, 

sub_class,

dept_desc,

sub_dept_desc,

class_desc,

sub_class_desc 

from eCommerceItem WITH(NOLOCK)



insert into ep.dbo.fi_record_count

select 'fi_item_hierarchy' as table_name, convert(char(10),getdate(),101) as rundate, count(*) as record_count

from ep.dbo.fi_item_hierarchy WITH(NOLOCK)



/********************************************************************************/

/* store table */

/********************************************************************************/



--truncate table ep.dbo.fi_store



insert into ep.dbo.fi_store

select

ep.dbo.store.store,

ep.dbo.store.region,

ep.dbo.store.district,

ep.dbo.store.store_name,

ep.dbo.store.address1,

ep.dbo.store.city,

ep.dbo.store.state,

ep.dbo.store.zip,

ep.dbo.store.county,

ep.dbo.store.vphone1,

ep.dbo.store.sto_dopen,

ep.dbo.store.sto_dclose,

ep.dbo.store.sto_lactive,

ep.dbo.store.longitude,

ep.dbo.store.latitude,

ep.dbo.store.store_group,

ep.dbo.store.remodel_date,

ep.dbo.store.remodel_type

From ep.dbo.store WITH(NOLOCK)



insert into ep.dbo.fi_record_count

select 'fi_store' as table_name, convert(char(10),getdate(),101) as rundate, count(*) as record_count

from ep.dbo.fi_store WITH(NOLOCK)



/********************************************************************************/

/* customer 800 table */

/********************************************************************************/



--truncate table ep.dbo.fi_customer_800



insert into ep.dbo.fi_customer_800

select

customer.dbo.customer_800.fname,

customer.dbo.customer_800.lname,

customer.dbo.customer_800.address,

customer.dbo.customer_800.apart_num,

customer.dbo.customer_800.city,

customer.dbo.customer_800.state,

customer.dbo.customer_800.zip,

customer.dbo.customer_800.phone_num,

customer.dbo.customer_800.kid1_name,

customer.dbo.customer_800.kid1_bdate,

customer.dbo.customer_800.kid2_name,

customer.dbo.customer_800.kid2_bdate,

customer.dbo.customer_800.kid3_name,

customer.dbo.customer_800.kid3_bdate,

customer.dbo.customer_800.kid4_name,

customer.dbo.customer_800.kid4_bdate,

customer.dbo.customer_800.contact_type,

customer.dbo.customer_800.email

from customer.dbo.customer_800 WITH(NOLOCK)

where customer.dbo.customer_800.key_date between @begindate and @enddate





insert into ep.dbo.fi_record_count

select 'fi_customer_800' as table_name, convert(char(10),getdate(),101) as rundate, count(*) as record_count

from ep.dbo.fi_customer_800 WITH(NOLOCK)



/********************************************************************************/ 

/* header table */

/********************************************************************************/



--truncate table ep.dbo.fi_header



insert into ep.dbo.fi_header

select

marketing.dbo.trans_header.store_num,

marketing.dbo.trans_header.t_number,

marketing.dbo.trans_header.s21_cust_num,

marketing.dbo.trans_header.t_date,

marketing.dbo.trans_header.t_time,

marketing.dbo.trans_header.prev_num,

marketing.dbo.trans_header.mod_type,

marketing.dbo.trans_header.sit,

marketing.dbo.trans_header.pkg,

marketing.dbo.trans_header.sales,

case when marketing.dbo.trans_header.portrait_club = 'Y' then '1' 

ELSE '0' END,

marketing.dbo.trans_header.ss,

marketing.dbo.trans_header.coupon,

marketing.dbo.trans_header.sheets,

marketing.dbo.trans_header.sheet_sales,

ecom_flag = null

from marketing.dbo.trans_header WITH(NOLOCK)

where
marketing.dbo.trans_header.t_date between @earlydate and @enddate
--(marketing.dbo.trans_header.t_date between @earlydate and @enddate) OR marketing.dbo.trans_header.t_date = '2015-01-04' OR marketing.dbo.trans_header.t_date = '2015-01-25'
and marketing.dbo.trans_header.fi_export is null
and marketing.dbo.trans_header.s21_cust_num <> ''





insert into ep.dbo.fi_record_count

select 'fi_header' as table_name, convert(char(10),getdate(),101) as rundate, count(*) as record_count

from ep.dbo.fi_header WITH(NOLOCK)



/********************************************************************************/

/* update fi_export with last date */

/********************************************************************************/



Update h

set h.fi_export = @enddate

from ep.dbo.fi_header fh inner join marketing.dbo.trans_header h on

fh.store_num = h.store_num and

fh.t_number = h.t_number 





/******************************     add   ecommerce header records   **********************************************************************/

update ep.dbo.fi_header

set

	ecom_flag = 1

where

	t_number > 651000000





/********************************************************************************/

/* update fi_export with last date */

/********************************************************************************/



Update h

set h.fi_export = @enddate

from ep.dbo.fi_header fh inner join marketing.dbo.e_header h on

fh.store_num = h.store_num and

fh.t_number = h.t_number and

fh.t_date = h.t_date









/*

update marketing.dbo.trans_header set marketing.dbo.trans_header.fi_export = @enddate

where (marketing.dbo.trans_header.t_date between  @earlydate and @enddate) and marketing.dbo.trans_header.fi_export is null

*/



/********************************************************************************/

/* sales_item table */

/********************************************************************************/





--truncate table ep.dbo.fi_sales_item 


insert into ep.dbo.fi_sales_item

select distinct itm.store_num, itm.t_number, hdr.s21_cust_num as cust_num, itm.t_line, itm.t_date,

			    itm.t_time, itm.sku_num, itm.quantity, itm.list_price, itm.selling_price, disc.coupon as markdown,

				null as comment, null as prev_num, itm.mod_type

from marketing.dbo.trans_header hdr  WITH(NOLOCK) INNER JOIN marketing.dbo.trans_item itm  WITH(NOLOCK)

			ON hdr.store_num = itm.store_num AND hdr.t_number = itm.t_number AND hdr.t_date = itm.t_date

		LEFT JOIN marketing.dbo.trans_discount disc  WITH(NOLOCK)

			ON itm.store_num = disc.store_num AND itm.t_number = disc.t_number AND itm.t_date = disc.t_date AND itm.t_line = (disc.t_line - 1)

where
	hdr.t_date between @earlydate and @enddate
	--(hdr.t_date between @earlydate and @enddate) OR hdr.t_date = '2015-01-04' OR hdr.t_date = '2015-01-25'
	
	and hdr.fi_export is null
	and hdr.s21_cust_num <> ''







insert into ep.dbo.fi_record_count

select 'fi_sales_item' as table_name, convert(char(10),getdate(),101) as rundate, count(*) as record_count

from ep.dbo.fi_sales_item WITH(NOLOCK)



/********************************************************************************/

/* sales_discount table */

/********************************************************************************/

--truncate table ep.dbo.fi_sales_discount

insert into ep.dbo.fi_sales_discount(store_num, t_date, t_number, t_line, discount_line, coupon, coupon_amt)

select store_num, (CAST(DATEPART(yyyy,t_Date) as varchar(4)) + '-' + CAST(DATEPART(mm,t_Date) as varchar(2)) + '-' + CAST(DATEPART(dd,t_Date) as varchar(2))) as t_date, 

	   t_number, (t_line - (t_line % 1000)) as t_line, 

	   t_line as discount_line, UPPER(coupon) as coupon, coupon_amt

from marketing.dbo.trans_discount WITH(NOLOCK)

where t_date between @earlydate and @enddate and coupon_amt <> 0



insert into ep.dbo.fi_record_count

select 'fi_sales_discount' as table_name, convert(char(10),getdate(),101) as rundate, count(*) as record_count

from ep.dbo.fi_sales_discount WITH(NOLOCK)


GO