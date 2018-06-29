CREATE procedure [dbo].[usp_Find_Groupons_Local]
@start datetime, @end datetime
as
select
	i.fldStudioNo as store_num,
	i.fldInvNo as t_number,
	i.fldInvDate as t_date,
	'EGF' as t_code,
	------d.fldItemPrice*-1 as tender,
	------i.fldNonTaxableTotal*-1 as tender,
	d.fldItemExtended*-1 as tender,
	'EGF' as check_num,
	NULL as cc_expire,
	NULL as cc_auth
	,d.fldItemDesc
	,d.fldItemNumber
from 
	stratustpp.[tpp].[dbo].tblInvoices i with (nolock) inner join stratustpp.[tpp].[dbo].tblInvoiceDetail d with (nolock) on i.fldInvId = d.fldInvID --tblInvoiceDetail > tblInvDetail
	left join stratustpp.[tpp].[dbo].tblItemMaint im with (nolock) on d.fldItemID = im.fldItemID
where
	--and i.fldStudioNo = 363
	--i.fldInvDate >= '2017-02-26' and i.fldInvDate <= '2017-04-01'
	i.fldInvDate >= @start and i.fldInvDate <= @end
	and im.fldItemCustomBoolean2  = 1 --Flag for EGF
	and i.fldInvType not in ('Estimate')


