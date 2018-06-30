
--Dupes


SELECT JOB,COUNT(JOB) FROM EMP GROUP BY JOB;





SELECT OrderNo, shoppername, amountPayed, city, item, count(*) as cnt
FROM dbo.sales
GROUP BY OrderNo, shoppername, amountPayed, city, item
HAVING COUNT(*) > 1





with x as   (select  *,rn = row_number()
            over(PARTITION BY OrderNo,item  order by OrderNo)
            from    #temp1)
select * from x
--delete x 
where rn > 1



