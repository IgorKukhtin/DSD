-- Function: gpBranchService_Replication_Table_IdList (TVarChar, TVarChar)

DROP FUNCTION IF EXISTS _replica.gpBranchService_Replication_Table_IdList (TVarChar, Text, Text, Text, TVarChar);

CREATE OR REPLACE FUNCTION _replica.gpBranchService_Replication_Table_IdList(
    IN inTableName              TVarChar,   -- Название таблицы
    IN inIdField                Text,       -- Поле в базе с Id
    IN inIdList                 Text,       -- Начиная с позиции
    IN inTableNameId            Text,   -- Название таблицы куда поместить Id
    IN inSession                TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, ErrorText TBlob, RowCount Integer) 
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
   DECLARE vbRowCount  Integer; 
   
   DECLARE vbColumn_Name_List   TEXT;
   DECLARE vbColumn_Name_Select TEXT;
   DECLARE vbColumn_Name_Type   TEXT;
   DECLARE vbColumn_Name_Order  TEXT;
   DECLARE vbColumn_Name_Update TEXT;   
BEGIN
   -- !!! это временно !!!
   -- ioId := (SELECT Id FROM Object WHERE ObjectCode=inCode AND DescId =zc_Object_Account());

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Account());
   vbUserId:= inSession::Integer;
   
   text_var1 := '';
   --raise notice 'Value 1: % % % % %', CLOCK_TIMESTAMP(), inTableName, inIdField, inIdList, inTableNameId;   

   BEGIN

     SELECT Host, DBName, Port, UserName, Password
     INTO vbHost, vbDBName, vbPort, vbUserName, vbPassword
     FROM _replica.gpBranchService_Select_MasterConnectParams(inSession);

       WITH tmpIndexes AS (SELECT string_to_array(SUBSTRING(i.indexdef, POSITION('(' IN i.indexdef) + 1, length(i.indexdef) - POSITION('(' IN i.indexdef) - 1), ', ') AS Columns
                           FROM pg_indexes i 
                           WHERE i.tablename ILIKE inTableName 
                             AND (i.indexname ILIKE '%_pkey' OR i.indexname ILIKE 'pk_%')
                           LIMIT 1)


       SELECT string_agg(c.column_name::Text, ', ')                                    AS Column_Name_List
            , string_agg('q.'||c.column_name::Text, ', ')                              AS Column_Name_Select
            , string_agg(c.column_name::Text||' '||udt_name::Text, ', ')               AS Column_Name_Type
            , string_agg(CASE WHEN tmpIndexes.Columns && Array[c.column_name::Text] 
                              THEN c.column_name::Text END, ', ')                      AS Column_Name_Order
            , string_agg(CASE WHEN not tmpIndexes.Columns && Array[c.column_name::Text] 
                              THEN c.column_name::Text||' = EXCLUDED.'||c.column_name::Text END, ', ') AS Column_Name_Update
       INTO vbColumn_Name_List
          , vbColumn_Name_Select
          , vbColumn_Name_Type
          , vbColumn_Name_Order
          , vbColumn_Name_Update
       FROM information_schema.columns c 
       
            LEFT JOIN tmpIndexes ON 1 = 1 
            
       WHERE c.table_catalog = current_database()
         AND c.table_name ILIKE inTableName;   
     
       vbQueryText := 'ALTER TABLE '||inTableName||' DISABLE TRIGGER ALL;';
       EXECUTE vbQueryText;
       
       IF COALESCE(inTableNameId, '') = ''
       THEN
         vbQueryText := 'WITH ins AS ('||
                        'INSERT INTO '||inTableName||' ('||vbColumn_Name_List||') '||
                        'SELECT '||vbColumn_Name_Select||' '||
                        'FROM dblink(''host='||vbHost||
                                      ' dbname='||vbDBName||
                                      ' port='||vbPort::Text|| 
                                      ' user='||vbUserName||
                                      ' password='||vbPassword||'''::text,'''|| 
                                     'SELECT '||vbColumn_Name_List||' FROM '||inTableName||' '||
                                     'WHERE '||inIdField||' IN ('||inIdList||') '||
                                     'ORDER BY '||vbColumn_Name_Order||';''::text) AS '||
                                     'q('||vbColumn_Name_Type||') '||
                        'ON CONFLICT ('||vbColumn_Name_Order||') DO UPDATE SET '||vbColumn_Name_Update||' '||
                        'RETURNING '||vbColumn_Name_Order||' '||
                        ') SELECT Count(*) AS RowCount FROM ins';
                        
         -- raise notice 'Value 1: % %', CLOCK_TIMESTAMP(), vbQueryText;

         EXECUTE vbQueryText INTO vbRowCount;
       ELSE
         vbQueryText := 'WITH ins AS ('||
                        'INSERT INTO '||inTableName||' ('||vbColumn_Name_List||') '||
                        'SELECT '||vbColumn_Name_Select||' '||
                        'FROM dblink(''host='||vbHost||
                                      ' dbname='||vbDBName||
                                      ' port='||vbPort::Text|| 
                                      ' user='||vbUserName||
                                      ' password='||vbPassword||'''::text,'''|| 
                                     'SELECT '||vbColumn_Name_List||' FROM '||inTableName||' '||
                                     'WHERE '||inIdField||' IN ('||inIdList||') '||
                                     'ORDER BY '||vbColumn_Name_Order||';''::text) AS '||
                                     'q('||vbColumn_Name_Type||') '||
                        'ON CONFLICT ('||vbColumn_Name_Order||') DO UPDATE SET '||vbColumn_Name_Update||' '||
                        'RETURNING '||vbColumn_Name_Order||' '||
                        ') INSERT INTO '||inTableNameId||' (Id) '|| 
                        'SELECT ins.'||vbColumn_Name_Order||' FROM ins';
                        
         -- raise notice 'Value 1: % %', CLOCK_TIMESTAMP(), vbQueryText;

         EXECUTE vbQueryText;
         GET DIAGNOSTICS vbRowCount = ROW_COUNT;
       
       END IF;

       --raise notice 'Value 1: % %', CLOCK_TIMESTAMP(), vbRowCount;
     
   EXCEPTION
      WHEN others THEN
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
   END;
   
   vbQueryText := 'ALTER TABLE '||inTableName||' ENABLE TRIGGER ALL;';
   EXECUTE vbQueryText;
         
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

-- 