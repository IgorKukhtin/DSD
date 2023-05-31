-- Function: gpBranchService_Replication_Table (TVarChar, TVarChar)

DROP FUNCTION IF EXISTS _replica.gpBranchService_Replication_Table (TVarChar, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION _replica.gpBranchService_Replication_Table(
    IN inTableName              TVarChar,   -- Название таблицы
    IN inOffset                 Integer,    -- Начиная с позиции
    IN inRecordCount            Integer,    -- Количество записей за раз
    IN inSession                TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, ErrorText TBlob, RowCount Integer) 
AS
$BODY$
   DECLARE vbUserId    Integer;
   DECLARE text_var1   Text;
   DECLARE vbRowCount  Integer; 

   DECLARE vbTableName TVarChar;
   DECLARE vbWhere     TEXT;
   DECLARE vbLike      TEXT;
   DECLARE vbDateSnapshot TDateTime;
   
   DECLARE vbRecord    Record;
BEGIN
   -- !!! это временно !!!
   -- ioId := (SELECT Id FROM Object WHERE ObjectCode=inCode AND DescId =zc_Object_Account());

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Account());
   vbUserId:= inSession::Integer;
   
   text_var1 := '';
   vbTableName := SPLIT_PART (inTableName, ';', 1);

   IF vbTableName NOT ILIKE 'Movement' AND vbTableName ILIKE 'Movement%' AND vbTableName NOT ILIKE '%Desc'
   THEN 
     text_var1 = 'Содержимое таблицы <Movement> загружаеться вместе с таблицей <Movement>';
   ELSEIF vbTableName ILIKE 'Movement'
   THEN 
     
     vbRowCount := 0;
     vbWhere := ''; vbLike := '';
     vbDateSnapshot := COALESCE((SELECT _replica.BranchService_Settings.DateSnapshot FROM _replica.BranchService_Settings WHERE _replica.BranchService_Settings.Id = 1), CURRENT_DATE);

     IF SPLIT_PART (inTableName, ';', 3) ILIKE 'OperDate'
     THEN
       vbWhere := 'Movement.OperDate >= '''''||TO_CHAR (date_trunc('Year', vbDateSnapshot) - INTERVAL '2 YEAR', 'yyyy-mm-dd')||'''''';
          
     ELSEIF SPLIT_PART (inTableName, ';', 3) ILIKE 'zc_MovementDate%'
     THEN
       vbLike := ' LEFT JOIN MovementDate ON MovementDate.MovementId = Movement.Id'||
                 ' AND MovementDate.DescId = '||SPLIT_PART (inTableName, ';', 3)||'() ';
       vbWhere := 'COALESCE(MovementDate.ValueData, CURRENT_DATE) >= '''''||TO_CHAR (date_trunc('Year', vbDateSnapshot) - INTERVAL '2 YEAR', 'yyyy-mm-dd')||'''''';
                    
     ELSE
       vbWhere := 'Movement.OperDate >= '''''||TO_CHAR (vbDateSnapshot, 'yyyy-mm-dd')||'''''';          
     END IF;

     -- **** Movement

     CREATE TEMP TABLE tmpMovementId (Ord serial NOT NULL PRIMARY KEY,Id  Integer) ON COMMIT DROP;
     CREATE TEMP TABLE tmpMovementItemId (Ord serial NOT NULL PRIMARY KEY,Id  Integer) ON COMMIT DROP;
  
     SELECT Ins.ErrorText, Ins.RowCount 
     INTO text_var1, vbRowCount
     FROM _replica.gpBranchService_Replication_Table_Movement(vbTableName, 'tmpMovementId', SPLIT_PART (inTableName, ';', 2), vbLike, vbWhere, inOffset, inRecordCount, inSession) AS Ins;
     
     
     if (SELECT COUNT(*) FROM tmpMovementId) > 0
     THEN


       FOR vbRecord IN
          SELECT ceil(MovementId.Ord / (inRecordCount * 10)) AS Ord
               , string_agg(MovementId.Id::Text, ',')        AS IdList    
          FROM tmpMovementId AS MovementId
          GROUP BY ceil(MovementId.Ord / (inRecordCount * 10))
       LOOP
             
         PERFORM _replica.gpBranchService_Replication_Table_IdList('MovementString', 'MovementId', vbRecord.IdList, '', inSession);
         PERFORM _replica.gpBranchService_Replication_Table_IdList('MovementFloat', 'MovementId', vbRecord.IdList, '', inSession);
         PERFORM _replica.gpBranchService_Replication_Table_IdList('MovementDate', 'MovementId', vbRecord.IdList, '', inSession);
         PERFORM _replica.gpBranchService_Replication_Table_IdList('MovementBoolean', 'MovementId', vbRecord.IdList, '', inSession);
         PERFORM _replica.gpBranchService_Replication_Table_IdList('MovementBLOB', 'MovementId', vbRecord.IdList, '', inSession);
         PERFORM _replica.gpBranchService_Replication_Table_IdList('MovementLinkMovement', 'MovementId', vbRecord.IdList, '', inSession);
         PERFORM _replica.gpBranchService_Replication_Table_IdList('MovementLinkObject', 'MovementId', vbRecord.IdList, '', inSession);
         PERFORM _replica.gpBranchService_Replication_Table_IdList('MovementProtocol', 'MovementId', vbRecord.IdList, '', inSession);
         PERFORM _replica.gpBranchService_Replication_Table_IdList('MovementItem', 'MovementId', vbRecord.IdList, 'tmpMovementItemId', inSession);
                                
       END LOOP;  
     
     
     END IF;

     if (SELECT COUNT(*) FROM tmpMovementItemId) > 0
     THEN

       FOR vbRecord IN
          SELECT ceil(MovementId.Ord / (inRecordCount * 10)) AS Ord
               , string_agg(MovementId.Id::Text, ',')        AS IdList    
          FROM tmpMovementItemId AS MovementId
          GROUP BY ceil(MovementId.Ord / (inRecordCount * 10))
       LOOP
             
         PERFORM _replica.gpBranchService_Replication_Table_IdList('MovementItemString', 'MovementItemId', vbRecord.IdList, '', inSession);
         PERFORM _replica.gpBranchService_Replication_Table_IdList('MovementItemFloat', 'MovementItemId', vbRecord.IdList, '', inSession);
         PERFORM _replica.gpBranchService_Replication_Table_IdList('MovementItemDate', 'MovementItemId', vbRecord.IdList, '', inSession);
         PERFORM _replica.gpBranchService_Replication_Table_IdList('MovementItemBoolean', 'MovementItemId', vbRecord.IdList, '', inSession);
         PERFORM _replica.gpBranchService_Replication_Table_IdList('MovementItemLinkObject', 'MovementItemId', vbRecord.IdList, '', inSession);
         PERFORM _replica.gpBranchService_Replication_Table_IdList('MovementProtocol', 'MovementItemId', vbRecord.IdList, '', inSession);
                                
       END LOOP;  
     
     
     END IF;
     
   ELSE 
     
     SELECT Ins.ErrorText, Ins.RowCount 
     INTO text_var1, vbRowCount
     FROM _replica.gpBranchService_Replication_Table_Simple(vbTableName, inOffset, inRecordCount, inSession) AS Ins;
     
   END IF;
   
   
      -- Результат
   RETURN QUERY
   SELECT 1 AS Id, text_var1::TBlob AS ErrorText, vbRowCount AS RowCount;
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

  
/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 11.02.23                                                       * 
*/

-- Тест

-- SELECT * FROM HistoryCost
-- SELECT Count(*) FROM Object
-- SELECT Count(*) FROM ObjectString
-- SELECT Count(*) FROM ObjectBoolean
-- select * from _replica.gpBranchService_Replication_Table('Movement;zc_Movement_OrderExternal', 0, 100, '0');
-- select * from _replica.gpBranchService_Replication_Table('MovementProtocol', 0, 10, '0');