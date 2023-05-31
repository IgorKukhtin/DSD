-- Function: gpBranchService_Equalization_MasterStep (TVarChar)

DROP FUNCTION IF EXISTS _replica.gpBranchService_Equalization_MasterStep (TVarChar);

CREATE OR REPLACE FUNCTION _replica.gpBranchService_Equalization_MasterStep(
    IN inSession                TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer 
             , ErrorText TBlob
             , RowCount Integer
             , DateEqualization TDateTime
             , TableName TVarChar
             , RowUpdate Integer) 
AS
$BODY$
   DECLARE vbUserId    Integer;

   DECLARE vbHost        TVarChar;
   DECLARE vbDBName      TVarChar;
   DECLARE vbPort        Integer;
   DECLARE vbUserName    TVarChar;
   DECLARE vbPassword    TVarChar;
   DECLARE vbUserNameUpd TVarChar;

   DECLARE text_var1   Text;
   DECLARE vbQueryText Text;

   DECLARE vbResult    Text;
   DECLARE vbRowCount  Integer; 
   DECLARE vbRowTmp    Integer; 
   DECLARE vbRowUpdate Integer; 
   DECLARE vbRecord    Record;
   
   DECLARE vbReplServerId        Integer;
   DECLARE vbDateEqualization    TIMESTAMP WITHOUT TIME ZONE;
   DECLARE vbEqualizationLastId  BIGINT;
   DECLARE vbRecordStep          Integer;
   DECLARE vbOffsetTimeEnd       Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Account());
   vbUserId:= inSession::Integer;
   
   text_var1 := '';
   vbResult := '';
   vbRowUpdate := 0;
   
   BEGIN

     SELECT Host, DBName, Port, UserName, Password, UserNameUpd
     INTO vbHost, vbDBName, vbPort, vbUserName, vbPassword, vbUserNameUpd
     FROM _replica.gpBranchService_Select_MasterConnectParams(inSession);

     SELECT BranchService_Settings.ReplServerId
          , COALESCE(BranchService_Settings.DateEqualization, BranchService_Settings.DateSnapshot)
          , BranchService_Settings.EqualizationLastId
          , BranchService_Settings.OffsetTimeEnd
     INTO vbReplServerId, vbDateEqualization, vbEqualizationLastId, vbOffsetTimeEnd
     FROM _replica.BranchService_Settings 
     WHERE BranchService_Settings.Id = 1;

     vbRecordStep := 30000;
          
     IF COALESCE(vbReplServerId, 0) = 0
     THEN
       RAISE EXCEPTION 'Не определен ID сервера репликации.';
     END IF;
          
     -- Чистим старые данные
     
     vbQueryText := 'CREATE TEMP TABLE tmpEqualizationPrepare ON COMMIT DROP AS '||
                    'SELECT q.Id, q.CountRecord, q.RowCount, q.LastId, q.DayeEnd '||
                    'FROM dblink(''host='||vbHost||
                                  ' dbname='||vbDBName||
                                  ' port='||vbPort::Text|| 
                                  ' user='||vbUserName||
                                  ' password='||vbPassword||'''::text,'''|| 
                                 'select Id, CountRecord, RowCount, LastId, DayeEnd '||
                                 'from _replica.gpBranchService_EqualizationPrepareId( ' ||
                                 '      '||vbReplServerId::TEXT||' '|| 
                                 '    , '''''||COALESCE(vbUserNameUpd, '')::TEXT||''''' '|| 
                                 '    , '''''||TO_CHAR (vbDateEqualization, 'yyyy-mm-dd hh:mm')||''''' '||
                                 '    , '||COALESCE(vbEqualizationLastId, 0)::TEXT||' '|| 
                                 '    , '||COALESCE(NULLIF(vbRecordStep, 0), 14000)::TEXT||' '|| 
                                 '    , '||vbOffsetTimeEnd::TEXT||' '|| 
                                 '    , ''''0'''');''::text) ' || 
                                 'AS q (Id Integer, CountRecord Integer, RowCount Integer, LastId BIGINT, DayeEnd TIMESTAMP WITHOUT TIME ZONE)';

     --raise notice 'Value 1: % %', CLOCK_TIMESTAMP(), vbQueryText;
                                 
     EXECUTE vbQueryText;
     
     vbRowCount := COALESCE((SELECT EP.RowCount FROM tmpEqualizationPrepare AS EP), 0);

     IF vbRowCount > 0
     THEN
       -- Получить перечень таблиц
       
       vbQueryText := 'CREATE TEMP TABLE tmpEqualizationTable ON COMMIT DROP AS '||
                      'SELECT q.Table_Name, q.CountRecord, q.RowCount '||
                      'FROM dblink(''host='||vbHost||
                                    ' dbname='||vbDBName||
                                    ' port='||vbPort::Text|| 
                                    ' user='||vbUserName||
                                    ' password='||vbPassword||'''::text,'''|| 
                                   'SELECT EI.Table_Name '||
                                   '     , count(*)::Integer  AS CountRecord ' ||
                                   '     , count(DISTINCT EI.ValueId||''''_''''||EI.DescId)::Integer AS RowCount ' ||
                                   'FROM _replica.BranchService_Equalization_Id AS EI ' ||
                                   'WHERE EI.ReplServerId = '||vbReplServerId::TEXT||' '|| 
                                   'GROUP BY EI.Table_Name;''::text) ' || 
                                   'AS q (Table_Name Text, CountRecord Integer, RowCount Integer)';

       --raise notice 'Value 1: % %', CLOCK_TIMESTAMP(), vbQueryText;
                                   
       EXECUTE vbQueryText;
       
       FOR vbRecord IN
          SELECT tmpEqualizationTable.Table_Name
               , tmpEqualizationTable.CountRecord
               , tmpEqualizationTable.RowCount  
          FROM _replica.BranchService_Table_Equalization AS TE
          
               INNER JOIN tmpEqualizationTable ON tmpEqualizationTable.Table_Name ILIKE TE.TableName
               
          ORDER BY TE.ID
       LOOP
             
         --raise notice 'Value 1: % %', CLOCK_TIMESTAMP(), vbRecord.Table_Name;
         
         SELECT UTD.RowCount
         INTO vbRowTmp
         FROM _replica.gpBranchService_Equalization_UpdateTableData(vbReplServerId, vbRecord.Table_Name, inSession) AS UTD;
         
         vbRowUpdate := vbRowUpdate + vbRowTmp;
         UPDATE tmpEqualizationTable SET RowCount = vbRowTmp WHERE tmpEqualizationTable.Table_Name = vbRecord.Table_Name;
                                         
       END LOOP;  

       UPDATE _replica.BranchService_Settings SET DateEqualization = (SELECT tmpEqualizationPrepare.DayeEnd FROM tmpEqualizationPrepare)
                                                , EqualizationLastId = (SELECT tmpEqualizationPrepare.LastId + 1 FROM tmpEqualizationPrepare)
       WHERE _replica.BranchService_Settings.Id = 1;
     
     END IF;     
      
   EXCEPTION
      WHEN others THEN
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
   END;
   
   SELECT _replica.BranchService_Settings.DateEqualization
   INTO vbDateEqualization
   FROM _replica.BranchService_Settings
   WHERE _replica.BranchService_Settings.Id = 1;
   
   -- Результат
   IF COALESCE(text_var1, '') <> '' OR vbRowCount = 0 
   THEN
     RETURN QUERY
     SELECT 1 AS Id, text_var1::TBlob AS ErrorText, vbRowCount AS RowCount, vbDateEqualization::TDateTime, ''::TVarChar, 0;
   ELSE 
   
     IF EXISTS(SELECT * FROM _replica.BranchService_Table_Equalization AS TE
               INNER JOIN tmpEqualizationTable ON tmpEqualizationTable.Table_Name ILIKE TE.TableName
               WHERE tmpEqualizationTable.RowCount > 0)
     THEN
       RETURN QUERY
       SELECT TE.Id, text_var1::TBlob AS ErrorText, vbRowCount AS RowCount, vbDateEqualization::TDateTime
            , TE.TableName::TVarChar, tmpEqualizationTable.RowCount AS RowUpdate
       FROM _replica.BranchService_Table_Equalization AS TE
            
            INNER JOIN tmpEqualizationTable ON tmpEqualizationTable.Table_Name ILIKE TE.TableName
            
       WHERE tmpEqualizationTable.RowCount > 0          
       ORDER BY TE.ID;
     ELSE
       RETURN QUERY
       SELECT 1 AS Id, text_var1::TBlob AS ErrorText, vbRowCount AS RowCount, vbDateEqualization::TDateTime, ''::TVarChar, 0;     
     END IF;
   END IF;
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

  
/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 11.02.23                                                       * 
*/

-- Тест

-- SELECT Count(*) FROM Object
-- select * from _replica.gpBranchService_Equalization_MasterStep('0');