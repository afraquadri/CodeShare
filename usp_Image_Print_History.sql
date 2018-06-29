

EXEC [usp_Image_Print_History] '1/1/2017', '01/01/2017'


GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[usp_Image_Print_History]
@FromDate as datetime, @ToDate as datetime

AS


Declare 


@RollInch_8 as Real,
@RollInch_24cp as Real,
@RollInch_24w as Real,
--@RollDIV as int,
@RollNum as Real

SET @RollInch_8 = 2556
SET @RollInch_24cp = 1200
SET @RollInch_24w = 1800 

          Select 
           
            x.[fldInvNo] as 'Invoice #'
           ,x.[fldStudioNo] as 'Studio #'
		   ,x.[fldInvDate] as 'Invoice Date'
           ,x.[fldSessionNo] as 'Sesson Number'
           ,x.[fldClientName] as 'Customer Name'
           ,x.[fldItemNumber] as 'Item Printed'
           ,sum(x.[fldPrintCount]) as 'Number Printed'
           ,Case x.[fldItemCustom7] --roll width
              when 8 then Round(sum(x.TotalInches)/@RollInch_8,4)
              when 24 then 
                Case x.[fldItemCustom8]
                  when 'Canvas' then Round(sum(x.TotalInches)/@RollInch_24cp,4)
                  when 'Portrait Paper' then Round(sum(x.TotalInches)/@RollInch_24cp,4)
                  when 'Wrapping Paper' then Round(sum(x.TotalInches)/@RollInch_24w,4)
                END 
               end as 'Number of Rolls'


from

(


Select distinct 
ti.[fldInvNo] as 'fldInvNo'
,rpq.[fldStudioNo] as 'fldStudioNo'
,ti.[fldInvDate] as 'fldInvDate'
,rpq.[fldSessionNo] as 'fldSessionNo'
,rpq.[fldClientName] as 'fldClientName'
,tid.[fldItemNumber] as 'fldItemNumber'
,rpq.[fldPrintCount] as 'fldPrintCount'
,im.[fldItemCustom7] --roll width
,im.[fldItemCustom8] --paper desc, cust 9 is paper length
,(count(tid.[fldItemNumber]) * im.[fldItemCustom9]) as 'TotalInches'

from 
stratustpp.tpp.dbo.[tblInvoices] ti inner join stratustpp.tpp.dbo.[tblInvoiceDetail] tid on ti.[fldInvID] = tid.[fldInvID] 
inner join stratustpp.tpp.dbo.[tblItemMaint] im on tid.[fldItemNumber] = im.[fldItemNumber]
inner join stratustpp.tpp.dbo.[tblRenderPrintQueueHistorical] rpq on tid.fldInvID = rpq.fldInvoiceID
--where  (ti.[fldInvDate] between @'12/31/2017' and '01/01/2018') 
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

Group by rpq.[fldStudioNo],ti.[fldInvDate],ti.[fldInvNo],tid.[fldItemNumber]
        ,rpq.[fldSessionNo], rpq.[fldClientName], rpq.[fldPrintCount]
		,im.[fldItemCustom7], im.[fldItemCustom8], im.[fldItemCustom9]               

) x

Group by [fldStudioNo],[fldInvDate],[fldInvNo],[fldItemNumber],[fldSessionNo],[fldClientName]
         ,[fldItemCustom7],[fldItemCustom8],TotalInches 

		 --
GO