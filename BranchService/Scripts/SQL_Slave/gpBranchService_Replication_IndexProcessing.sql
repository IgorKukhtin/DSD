-- Function: gpBranchService_Replication_IndexProcessing (TVarChar)

DROP FUNCTION IF EXISTS _replica.gpBranchService_Replication_IndexProcessing (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION _replica.gpBranchService_Replication_IndexProcessing(
    IN inTableName         TVarChar,   -- Таблица
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, IndexCountOk Integer, IndexCount Integer, ErrorText TBlob) 
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
   DECLARE vbIndex     record;
BEGIN
   -- !!! это временно !!!
   -- ioId := (SELECT Id FROM Object WHERE ObjectCode=inCode AND DescId =zc_Object_Account());

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Account());
   vbUserId:= inSession::Integer;
   
   text_var1 := '';
   
   SELECT Host, DBName, Port, UserName, Password
   INTO vbHost, vbDBName, vbPort, vbUserName, vbPassword
   FROM _replica.gpBranchService_Select_MasterConnectParams(inSession);

   CREATE TEMP TABLE _tmpIndex (Name TVarChar, SQL Text, isCrete boolean) ON COMMIT DROP;
   
   BEGIN
   

     -- Получаем даннын для создания индексов
     vbQueryText := 'INSERT INTO _tmpIndex '||
                    'SELECT q.Name '|| 
                         ', q.SQL '||
                         ', False '||
                    'FROM dblink(''host='||vbHost||
                                  ' dbname='||vbDBName||
                                  ' port='||vbPort::Text|| 
                                  ' user='||vbUserName||
                                  ' password='||vbPassword||'''::text,'''|| 
                                 'SELECT i.indexname::TVarChar AS Name '|| 
                                      ', REPLACE(i.indexdef, '''' INDEX'''', '''' INDEX IF NOT EXISTS'''')::Text AS SQL '|| 
                                 'FROM pg_indexes i '|| 
                                 'WHERE i.tablename ILIKE '''''||inTableName||''''' '|| 
                                 '  AND i.indexname NOT ILIKE ''''%_pkey'''' '|| 
                                 '  AND i.indexname NOT ILIKE ''''pk_%'''';''::text) AS q(Name TVarChar, SQL Text)';
                      
     --raise notice 'Value 1: % %', CLOCK_TIMESTAMP(), vbQueryText;

     EXECUTE vbQueryText;

   EXCEPTION
      WHEN others THEN
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
   END;
   
   IF text_var1 = '' AND EXISTS(SELECT 1 FROM _tmpIndex)
   THEN

     -- Пробигаемся по индексам
           
     FOR vbIndex IN
        SELECT _tmpIndex.Name, _tmpIndex.SQL, _tmpIndex.isCrete       
        FROM _tmpIndex
     LOOP
       
       IF vbIndex.isCrete = FALSE
       THEN
       
         vbQueryText := vbIndex.SQL;

         raise notice 'Value 1: % %', CLOCK_TIMESTAMP(), vbQueryText;
           
         BEGIN
           EXECUTE vbQueryText;

           UPDATE _tmpIndex SET isCrete = TRUE
           WHERE _tmpIndex.Name ILIKE vbIndex.Name;
         EXCEPTION
            WHEN others THEN
              GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
         END;         
       END IF;
                        
     END LOOP;  
   END IF;  

          
   -- Результат
   RETURN QUERY
   SELECT 1, (SELECT COUNT(*) FROM _tmpIndex WHERE _tmpIndex.isCrete = TRUE)::INTEGER, (SELECT COUNT(*) FROM _tmpIndex)::INTEGER, text_var1::TBlob;
   

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

  
/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 11.02.23                                                       * 
*/

-- Тест
-- 
-- select * from _replica.gpBranchService_Replication_IndexProcessing('Object', '0');