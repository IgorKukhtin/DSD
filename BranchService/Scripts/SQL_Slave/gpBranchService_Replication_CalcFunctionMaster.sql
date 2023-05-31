-- Function: gpBranchService_Replication_CalcFunctionMaster (TVarChar, TVarChar)

DROP FUNCTION IF EXISTS _replica.gpBranchService_Replication_CalcFunctionMaster (Text, TVarChar);

CREATE OR REPLACE FUNCTION _replica.gpBranchService_Replication_CalcFunctionMaster(
    IN inFunctionFilter         Text,       -- Фильтр для функций
    IN inSession                TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, FunctionCount Integer, ErrorText TBlob) 
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
   DECLARE vbFilter    TEXT;
   DECLARE vbFunctionCount  Integer;
   DECLARE vbIndex     Integer;
BEGIN
   -- !!! это временно !!!
   -- ioId := (SELECT Id FROM Object WHERE ObjectCode=inCode AND DescId =zc_Object_Account());

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Account());
   vbUserId:= inSession::Integer;
   
   text_var1 := '';
   vbFunctionCount := 0;
   
   SELECT Host, DBName, Port, UserName, Password
   INTO vbHost, vbDBName, vbPort, vbUserName, vbPassword
   FROM _replica.gpBranchService_Select_MasterConnectParams(inSession);
   
   BEGIN

     -- Пробигаемся по фильтрам
     vbIndex := 1;
     vbFilter := '';
     WHILE SPLIT_PART (inFunctionFilter, ',', vbIndex) <> '' LOOP
   
       IF vbFilter <> '' THEN vbFilter := vbFilter||' OR '; END IF;
       
       vbFilter := vbFilter||'p.proname ILIKE '''||SPLIT_PART (inFunctionFilter, ',', vbIndex)||'''';

       -- теперь следуюющий
       vbIndex := vbIndex + 1;
     END LOOP;     

     IF vbFilter <> '' THEN 
       vbFilter := 'AND ('||REPLACE(vbFilter, '''', '''''')||')'; 
     END IF;

     -- Подсчитываем количество функций
     vbQueryText := 'SELECT q.FunctionCount '||
                    'FROM dblink(''host='||vbHost||
                                  ' dbname='||vbDBName||
                                  ' port='||vbPort::Text|| 
                                  ' user='||vbUserName||
                                  ' password='||vbPassword||'''::text,'''|| 
                                 'SELECT count(*)::Integer AS FunctionCount '|| 
                                 'FROM pg_catalog.pg_proc p '|| 
                                 '     LEFT JOIN pg_catalog.pg_namespace n ON n.oid = p.pronamespace '|| 
                                 'WHERE pg_catalog.pg_function_is_visible(p.oid) '|| 
                                 '      AND n.nspname <> ''''pg_catalog'''' '|| 
                                 '      AND n.nspname <> ''''information_schema'''' '|| 
                                 '      '||vbFilter||';''::text) AS q(FunctionCount Integer)';
                      
     --raise notice 'Value 1: % % %', CLOCK_TIMESTAMP(), vbFilter, vbQueryText;

     EXECUTE vbQueryText INTO vbFunctionCount;
        
        
   EXCEPTION
      WHEN others THEN
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
   END;
        
   -- Результат
   RETURN QUERY
   SELECT 1, vbFunctionCount, text_var1::TBlob;
   

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

  
/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 11.02.23                                                       * 
*/

-- Тест

-- select * from _replica.gpBranchService_Replication_CalcFunctionMaster('zc_%,zfcalc_%,zfconvert_%,gpselect_%', '0');