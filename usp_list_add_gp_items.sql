--exec [usp_list_add_gp_items] 'SELECT', '70065' --16131
--exec [usp_list_add_gp_items] 'ADD', '70065','ALL'
--exec [usp_list_add_gp_items] 'DELETE', '70065'


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [dbo].[usp_list_add_gp_items]
	@OPTION VARCHAR(10)
	,@item varchar(128) = null
	,@locncode varchar(128) = null
AS
set nocount on;

declare @loc varchar(100), @ItemExist int

IF @OPTION NOT IN ('SELECT','ADD','DELETE')
BEGIN 
	SELECT 'Not a valid option: only SELECT, ADD and DELETE are valid.' as [Item]
      ,'' as [Studio]
	RETURN
END

IF @locncode NOT IN ('ALL','PIM','BBB','MALL','SEARS')
BEGIN 
	SELECT 'Not a valid option: only ALL BBB MALL PIM or SEARS are valid.' as [Item]
      ,'' as [Studio]
	RETURN
END


IF @OPTION = 'ADD' 
	AND LEN(isnull(@Item,'')) = 0 
BEGIN 
	SELECT 'Not a valid length: ALL fields needs to have values to add an item' as [Item]
      ,'' as [Studio]
	RETURN
END 

IF @OPTION = 'SELECT'
BEGIN 
	SELECT ITEMNMBR as Item, LOCNCODE as Studio FROM tpp02..IV00102 WHERE ITEMNMBR = @item;

	RETURN
END 


IF @OPTION = 'DELETE'
BEGIN 
	delete FROM tpp02..IV00102 WHERE ITEMNMBR = @item;
	RETURN
END 

IF @OPTION = 'ADD' AND NOT EXISTS (SELECT ITEMNMBR as Item, LOCNCODE as Studio FROM tpp02..IV00102 with(nolock) WHERE ITEMNMBR = @item)
BEGIN 
	

			DECLARE TablePositionCursor CURSOR FOR
			SELECT itemnmbr FROM tpp02..IV00101 i where itemnmbr=@item -- All -----------******************


			OPEN TablePositionCursor
			FETCH NEXT FROM TablePositionCursor INTO @item
			WHILE (@@fetch_status <> -1)
			BEGIN
			IF @locncode = 'ALL'
			 DECLARE TablePositionCursor2 CURSOR FOR SELECT locncode FROM tpp02..IV40700 order by locncode
			IF @locncode = 'BBB'
			 DECLARE TablePositionCursor2 CURSOR FOR SELECT locncode FROM tpp02..IV40700 where locncode between 4000 and 4999 order by locncode
			IF @locncode = 'PIM'
			 DECLARE TablePositionCursor2 CURSOR FOR SELECT locncode FROM tpp02..IV40700 where locncode between 7000 and 7999 order by locncode
			IF @locncode = 'SEARS'
			 DECLARE TablePositionCursor2 CURSOR FOR SELECT locncode FROM tpp02..IV40700 where locncode between 8000 and 8999 order by locncode
			IF @locncode = 'MALL'
			 DECLARE TablePositionCursor2 CURSOR FOR SELECT locncode FROM tpp02..IV40700 where locncode between 1 and 999 order by locncode
			OPEN TablePositionCursor2
			FETCH NEXT FROM TablePositionCursor2 INTO  @loc
			WHILE (@@fetch_status <> -1)
			BEGIN
			SELECT @ItemExist = isnull(count(*), 0) FROM tpp02..IV00102 WHERE ITEMNMBR = @item AND LOCNCODE = @loc

			--SELECT ITEMNMBR as Item, LOCNCODE as Studio FROM tpp02..IV00102 WHERE ITEMNMBR = @item AND LOCNCODE = @loc

			----delete FROM IV00102 WHERE ITEMNMBR = '16375' AND locncode between 7000 and 7999

			IF @ItemExist  = 0
			BEGIN
				Print 'Assigning item ' + @item + ' to ' + @loc
				print @loc
				--Actual Insert
				INSERT INTO tpp02..iv00102 VALUES(@item,@loc,'',2,'',0,0,0,0,'01/01/1900','','01/01/1900',0,0,0,0,0,0,0,0,0,0,0,0,'01/01/1900','01/01/1900','01/01/1900','01/01/1900',0,'','','',1,0,0,1,0,0,1,2,0,0,0,0,0,0,0,1,0,0,0,3,0,0,0,'AUTOCREATE','AUTOCREATE','AUTOCREATE','AUTOCREATE','','','','',1,1,'',1,1,0,1,1,1,0,0,0,0,0)
			END
			FETCH NEXT FROM TablePositionCursor2 INTO @loc
			END
			DEALLOCATE TablePositionCursor2
			FETCH NEXT FROM TablePositionCursor INTO  @item
			END
			DEALLOCATE TablePositionCursor

		
	SELECT ITEMNMBR as Item, LOCNCODE as Studio FROM tpp02..IV00102 WHERE ITEMNMBR = @item;
	RETURN
END 

IF @OPTION = 'ADD' AND EXISTS (SELECT ITEMNMBR as Item, LOCNCODE as Studio FROM tpp02..IV00102 with(nolock) WHERE ITEMNMBR = @item)
BEGIN SELECT 'Not a valid ADD: Item : ' + ISNULL(@item,'') + ' already exists.'  as [item]
      ,'' as [Studio]
     RETURN
 END 




GO