--SELECT distinct 
--       --ti.[fldInvNo]
--	   tid.[fldStudioNo] as 'Studio used in'
--	   ,im.[fldItemCustom7] as 'Paper Roll Size in inches'
--	   ,im.[fldItemCustom8] as 'Paper Type'
--	   --,sum(count(tid.[fldItemNumber]) * im.[fldItemCustom9]) as 'Paper Used in inches'

--exec usp_FindPaperUsed '2017-11-6','2017-11-6'

--exec usp_FindPaperUsed @FromDate='2017-11-6',@ToDate='2017-11-6'

--exec usp_FindPaperUsed @FromDate= ? ,@ToDate=?

use spectra
go
create procedure usp_FindPaperUsed
@FromDate as datetime,
@ToDate as datetime
as

	   select 
	   --ti.[fldInvNo]
	   x.[fldStudioNo] as 'Studio used in'
	   ,x.[fldItemCustom7] as 'Paper Roll Size in inches'
	   ,x.[fldItemCustom8] as 'Paper Type'
	   ,sum(x.count1) 'Paper Used in inches'
from
(
    
select 
	   --ti.[fldInvNo]
	   tid.[fldStudioNo] as 'fldStudioNo'
	   ,im.[fldItemCustom7] as 'fldItemCustom7'
	   ,im.[fldItemCustom8] as 'fldItemCustom8'
	   ,count(tid.[fldItemNumber]) * im.[fldItemCustom9] as 'count1'
from stratustpp.tpp.dbo.[tblInvoices] ti inner join stratustpp.tpp.dbo.[tblInvoiceDetail] tid on ti.[fldInvID] = tid.[fldInvID] 
       inner join stratustpp.tpp.dbo.[tblItemMaint] im on tid.[fldItemNumber] = im.[fldItemNumber]

where  (ti.[fldInvDate] between @FromDate and @ToDate) 
    and (tid.[fldItemNumber] in --('9003'))
	 ('15627','15628','16000','16001','16002','16003','16004','16005','8274'
	 ,'14641','14759','15028','15856','16193','16194','16195','16211','70008'
	 ,'70005','70006','70009','70010','70000','70013','70007','70024','16111','16112'
	 ,'16113','14875','15487','15868','10943','10000','12132','12133','12234','12238'
	 ,'13287','13288','16025','15814','11924','12134','13284','13285','9004','9006'
	 ,'10909','12127','12128','12129','15455','15475','9066','9074','9075','13604'
	 ,'15366','15434','15558','15593','15599','15726','15732','9003','9008','9070'
	 ,'3509','3800','7649','7650','8934','8945','8946'
	 ,'8948','12681','12682','12683','13931','13932','13933','14376'
	 ,'14588','14589','15323','15324','15325','15329','15330','15331'
	 ,'15332','15333','70033','70032','70031','70035','14561','14562','14563'
	 ,'14676','14677','14678','15321','15322','15902','15903','15904','16238','14305'
	 ,'70044','16281','9912','14609','16205','15400','10956','13289','10945','14285'
	 ,'11006','11000','11001','7224','8362','16348','16349','16350'
	 ,'11002','11003','70061','70062','999811','999812','999813','999814','999815'
	 ,'70063','70064','16362','16361','70067','16329','16343','16342','16374'
	 ,'70073','70071','70077','70075','16379','16383','16377','16378','16375','70072'
	 ,'70076','16387','16352','16352','16340','P1114','1 - 6x8 Portrait'
	 ,'6x8 Portraits','1 6x8 Portrait','9075 (Backup)','APPCTST2','PSTBTST'))
    	   Group by tid.[fldStudioNo],im.[fldItemCustom7],im.[fldItemCustom8] ,im.[fldItemCustom9]

) x
Group by fldStudioNo,fldItemCustom7,fldItemCustom8
GO
