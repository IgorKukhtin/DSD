-- Function: gpBranchService_Replication_Function (TVarChar, TVarChar)

DROP FUNCTION IF EXISTS _replica.gpBranchService_Replication_Function (Text, TVarChar);

CREATE OR REPLACE FUNCTION _replica.gpBranchService_Replication_Function(
    IN inFunctionFilter         Text,       -- Фильтр для функций
    IN inOffset                 Integer,    -- Начиная с позиции
    IN inRecordCount            Integer,    -- Количество записей за раз
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
   DECLARE vbFuncName      TEXT;
   DECLARE vbIndex     Integer;
   DECLARE vbFunction  record;
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

   CREATE TEMP TABLE _tmpFunction (Schema TVarChar, Name TVarChar, Argument Text, Proc Text, SQL Text) ON COMMIT DROP;
   
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

     -- Получаем даннын для создания функций
     vbQueryText := 'INSERT INTO _tmpFunction '||
                    'SELECT q.Schema '|| 
                         ', q.Name '|| 
                         ', q.Argument '||   
                         ', q.Proc '||   
                         ', q.SQL '||
                    'FROM dblink(''host='||vbHost||
                                  ' dbname='||vbDBName||
                                  ' port='||vbPort::Text|| 
                                  ' user='||vbUserName||
                                  ' password='||vbPassword||'''::text,'''|| 
                                 'SELECT n.nspname::TVarChar AS Schema '|| 
                                      ', p.proname::TVarChar AS Name '|| 
                                      ', pg_catalog.pg_get_function_arguments(p.oid)::Text AS Argument '||   
                                      ', p.proname||''''(''''||oidvectortypes(p.proargtypes)||'''')'''' AS Proc '||   
                                      ', pg_get_functiondef((p.proname||''''(''''||oidvectortypes(p.proargtypes)||'''')'''')::regprocedure)::Text AS SQL '|| 
                                 'FROM pg_catalog.pg_proc p '|| 
                                 '     LEFT JOIN pg_catalog.pg_namespace n ON n.oid = p.pronamespace '|| 
                                 'WHERE pg_catalog.pg_function_is_visible(p.oid) '|| 
                                 '      AND n.nspname <> ''''pg_catalog'''' '|| 
                                 '      AND n.nspname <> ''''information_schema'''' '|| 
                                 '      '||vbFilter||' '||
                                 'ORDER BY 1, 2 DESC, 3 '||' '|| 
                                 'LIMIT '||inRecordCount::Text||' '||
                                 'OFFSET '||inOffset::Text||';''::text) AS q(Schema TVarChar, Name TVarChar, Argument Text, Proc Text, SQL Text)';
                      
     -- raise notice 'Value 1: % % %', CLOCK_TIMESTAMP(), vbFilter, vbQueryText;

     EXECUTE vbQueryText;

   EXCEPTION
      WHEN others THEN
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
      text_var1 = text_var1;
   END;
   
   IF COALESCE(text_var1, '') = ''
   THEN
     FOR vbFunction IN
        SELECT _tmpFunction.SQL       
             , _tmpFunction.Name  
             , _tmpFunction.Proc     
        FROM _tmpFunction
     LOOP
       vbFuncName := vbFunction.Name;
       
       BEGIN
         EXECUTE vbFunction.SQL;
       EXCEPTION
          WHEN others THEN
            GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
          text_var1 = vbFuncName||' '||text_var1;
       END;
       
       
       IF COALESCE(text_var1, '') <> ''
       THEN
         BEGIN
           EXECUTE 'DROP FUNCTION IF EXISTS '||vbFunction.Proc;
           EXECUTE vbFunction.SQL;
           text_var1 := '';
         EXCEPTION
            WHEN others THEN
              GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
            text_var1 = vbFuncName||' '||text_var1;
         END;
       END IF;

     END LOOP;
   END IF;
        
                
   -- Результат
   RETURN QUERY
   SELECT 1, (SELECT COUNT(*) FROM _tmpFunction)::INTEGER, text_var1::TBlob;
   

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

  
/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 11.02.23                                                       * 
*/

-- Тест

-- select * from _replica.gpBranchService_Replication_Function('zc_%,zfcalc_%,zfconvert_%,gpselect_%', 0, 100, '0');