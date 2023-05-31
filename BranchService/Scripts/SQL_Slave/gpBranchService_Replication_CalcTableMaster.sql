-- Function: gpBranchService_Replication_CalcTableMaster (TVarChar, TVarChar)

DROP FUNCTION IF EXISTS _replica.gpBranchService_Replication_CalcTableMaster (Text, TVarChar);

CREATE OR REPLACE FUNCTION _replica.gpBranchService_Replication_CalcTableMaster(
    IN inTableNameList          Text,       -- Перечень таблиц
    IN inSession                TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, TableNane TVarChar, RecordCount Integer) 
AS
$BODY$
   DECLARE vbUserId    Integer;
   DECLARE vbHost      TVarChar;
   DECLARE vbDBName    TVarChar;
   DECLARE vbPort      Integer;
   DECLARE vbUserName  TVarChar;
   DECLARE vbPassword  TVarChar;
   DECLARE text_var1   Text;
   DECLARE vbQueryText TEXT;
   DECLARE vbIndex     Integer;
   DECLARE vbRecordCount  Integer;
   DECLARE vbWhere     TEXT;
   DECLARE vbLike      TEXT;
   DECLARE vbTableName TVarChar;
   DECLARE vbDateSnapshot TDateTime;
BEGIN
   -- !!! это временно !!!
   -- ioId := (SELECT Id FROM Object WHERE ObjectCode=inCode AND DescId =zc_Object_Account());

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Account());
   vbUserId:= inSession::Integer;
   
   text_var1 := '';
   
   CREATE TEMP TABLE _tmpCalculateTable (Id Integer, TableNane TVarChar, RecordCount Integer) ON COMMIT DROP;

   SELECT Host, DBName, Port, UserName, Password
   INTO vbHost, vbDBName, vbPort, vbUserName, vbPassword
   FROM _replica.gpBranchService_Select_MasterConnectParams(inSession);
   
   -- Пробигаемся по таблицам
   vbIndex := 1;
   WHILE SPLIT_PART (inTableNameList, ',', vbIndex) <> '' LOOP
   
  --   BEGIN
     
        vbWhere := ''; vbLike := '';
        vbTableName := SPLIT_PART (inTableNameList, ',', vbIndex);
        
        IF  SPLIT_PART (vbTableName, ';', 1) ILIKE 'Movement'
        THEN
        
          vbDateSnapshot := COALESCE((SELECT _replica.BranchService_Settings.DateSnapshot FROM _replica.BranchService_Settings WHERE _replica.BranchService_Settings.Id = 1), CURRENT_DATE);
          vbRecordCount := 0;
                  
          IF SPLIT_PART (vbTableName, ';', 3) ILIKE 'OperDate'
          THEN
            vbWhere := 'Movement.OperDate >= '''''||TO_CHAR (date_trunc('Year', vbDateSnapshot) - INTERVAL '2 YEAR', 'yyyy-mm-dd')||'''''';
          
          ELSEIF SPLIT_PART (vbTableName, ';', 3) ILIKE 'zc_MovementDate%'
          THEN
            vbLike := ' INNER JOIN MovementDate ON MovementDate.MovementId = Movement.Id'||
                      ' AND MovementDate.DescId = '||SPLIT_PART (vbTableName, ';', 3)||'() ';
            vbWhere := 'COALESCE(MovementDate.ValueData, CURRENT_DATE) >= '''''||TO_CHAR (date_trunc('Year', vbDateSnapshot) - INTERVAL '2 YEAR', 'yyyy-mm-dd')||'''''';
                    
          ELSE
            vbWhere := 'Movement.OperDate >= '''''||TO_CHAR (vbDateSnapshot, 'yyyy-mm-dd')||'''''';          
          END IF;


          /*vbQueryText := 'SELECT q.RecordCount '||
                         'FROM dblink(''host='||vbHost||
                                       ' dbname='||vbDBName||
                                       ' port='||vbPort::Text|| 
                                       ' user='||vbUserName||
                                       ' password='||vbPassword||'''::text,'''|| 
                                      'WITH tmpMovement AS (SELECT Movement.Id FROM Movement '||vbLike||' WHERE Movement.DescId = '||
                                        SPLIT_PART (vbTableName, ';', 2)||'() AND '||vbWhere||'), '||
                                      ' tmpMI AS (SELECT MovementItem.Id FROM tmpMovement INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement.Id) '||
                                      'SELECT (SELECT COUNT(*) FROM tmpMovement) + '||
                                          '(SELECT COUNT(*) FROM tmpMI) + '||
                                          '(SELECT COUNT(*) FROM MovementString WHERE MovementString.MovementId in (SELECT tmpMovement.Id FROM tmpMovement)) + '||
                                          '(SELECT COUNT(*) FROM MovementFloat WHERE MovementFloat.MovementId in (SELECT tmpMovement.Id FROM tmpMovement)) + '||
                                          '(SELECT COUNT(*) FROM MovementDate WHERE MovementDate.MovementId in (SELECT tmpMovement.Id FROM tmpMovement)) + '||
                                          '(SELECT COUNT(*) FROM MovementBoolean WHERE MovementBoolean.MovementId in (SELECT tmpMovement.Id FROM tmpMovement)) + '||
                                          '(SELECT COUNT(*) FROM MovementBLOB WHERE MovementBLOB.MovementId in (SELECT tmpMovement.Id FROM tmpMovement)) + '||
                                          '(SELECT COUNT(*) FROM MovementLinkMovement WHERE MovementLinkMovement.MovementId in (SELECT tmpMovement.Id FROM tmpMovement) AND MovementLinkMovement.MovementChildId IS NOT NULL) + '||
                                          '(SELECT COUNT(*) FROM MovementLinkObject WHERE MovementLinkObject.MovementId in (SELECT tmpMovement.Id FROM tmpMovement) AND MovementLinkObject.ObjectId IS NOT NULL) + '||
                                          '(SELECT COUNT(*) FROM MovementItemString WHERE MovementItemString.MovementItemId IN (SELECT  tmpMI.Id FROM tmpMI)) + '||
                                          '(SELECT COUNT(*) FROM MovementItemFloat WHERE MovementItemFloat.MovementItemId IN (SELECT  tmpMI.Id FROM tmpMI)) + '||
                                          '(SELECT COUNT(*) FROM MovementItemDate WHERE MovementItemDate.MovementItemId IN (SELECT  tmpMI.Id FROM tmpMI)) + '||
                                          '(SELECT COUNT(*) FROM MovementItemBoolean WHERE MovementItemBoolean.MovementItemId IN (SELECT  tmpMI.Id FROM tmpMI)) = '||
                                          '(SELECT COUNT(*) FROM MovementItemLinkObject WHERE MovementItemLinkObject.MovementItemId IN (SELECT  tmpMI.Id FROM tmpMI) AND MovementItemLinkObject.ObjectId IS NOT NULL)'||
                                      ' AS RecordCount;''::text) AS '||'q(RecordCount Integer)';*/

          vbQueryText := 'SELECT q.RecordCount '||
                         'FROM dblink(''host='||vbHost||
                                       ' dbname='||vbDBName||
                                       ' port='||vbPort::Text|| 
                                       ' user='||vbUserName||
                                       ' password='||vbPassword||'''::text,'''|| 
                                      'SELECT COUNT(*) AS RecordCount FROM Movement '||vbLike||' WHERE Movement.DescId = '||
                                        SPLIT_PART (vbTableName, ';', 2)||'() AND '||vbWhere||';''::text) AS q(RecordCount Integer)';

          --raise notice 'Value 1: % %', CLOCK_TIMESTAMP(), vbQueryText;

          EXECUTE vbQueryText INTO vbRecordCount;
        
        ELSE
        
          IF SPLIT_PART (inTableNameList, ',', vbIndex) ILIKE 'ObjectLink' OR
             SPLIT_PART (inTableNameList, ',', vbIndex) ILIKE 'ObjectHistoryLink'
          THEN 
             vbWhere := ' WHERE COALESCE(ObjectId, 0) <> 0';
          END IF;
       
          vbQueryText := 'SELECT q.RecordCount '||
                         'FROM dblink(''host='||vbHost||
                                       ' dbname='||vbDBName||
                                       ' port='||vbPort::Text|| 
                                       ' user='||vbUserName||
                                       ' password='||vbPassword||'''::text,'''|| 
                                      'SELECT COUNT(*) AS  RecordCount FROM '||SPLIT_PART (inTableNameList, ',', vbIndex)||vbWhere||';''::text) AS '||
                                      'q(RecordCount Integer)';
                        
          EXECUTE vbQueryText INTO vbRecordCount;
        
        END IF;
        
        
        INSERT INTO _tmpCalculateTable VALUES (vbIndex, SPLIT_PART (inTableNameList, ',', vbIndex), vbRecordCount);

 /*    EXCEPTION
        WHEN others THEN
          GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
     END;*/
        
      -- теперь следуюющий
      vbIndex := vbIndex + 1;
   END LOOP;     

   -- Результат
   RETURN QUERY
   SELECT *
   FROM _tmpCalculateTable
   WHERE _tmpCalculateTable.RecordCount > 0
   ORDER BY _tmpCalculateTable.ID;
   

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

  
/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 11.02.23                                                       * 
*/

-- Тест
-- select * from _replica.gpBranchService_Replication_CalcTableMaster('Movement;zc_Movement_Promo;zc_MovementDate_EndPromo', '0');