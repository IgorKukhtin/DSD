-- Function: gpRewiring_Replication_Function (TVarChar)

DROP FUNCTION IF EXISTS _replica.gpRewiring_Replication_Function (TVarChar);

CREATE OR REPLACE FUNCTION _replica.gpRewiring_Replication_Function(
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
   DECLARE vbFuncName      TEXT;
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
   FROM _replica.gpSelect_MasterConnectParams(inSession);

   CREATE TEMP TABLE _tmpFunction (Schema TVarChar, Name TVarChar, Argument Text, Proc Text, SQL Text) ON COMMIT DROP;
   
   BEGIN
   
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
 26.09.23                                                       * 
*/

-- Тест

-- select * from _replica.gpRewiring_Replication_Function(0, 100, zfCalc_UserAdmin());