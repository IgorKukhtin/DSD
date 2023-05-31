-- Function: gpBranchService_Replication_View (TVarChar)

DROP FUNCTION IF EXISTS _replica.gpBranchService_Replication_View (TVarChar);

CREATE OR REPLACE FUNCTION _replica.gpBranchService_Replication_View(
    IN inSession                TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, ViewCountOk Integer, ViewCount Integer, ErrorText TBlob) 
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
   DECLARE vbView      record;
   DECLARE vbIndex     Integer;
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

   CREATE TEMP TABLE _tmpView (Name TVarChar, SQL Text, isCrete boolean) ON COMMIT DROP;
   
   BEGIN
   

     -- Получаем даннын для создания функций
     vbQueryText := 'INSERT INTO _tmpView '||
                    'SELECT q.Name '|| 
                         ', q.SQL '||
                         ', False '||
                    'FROM dblink(''host='||vbHost||
                                  ' dbname='||vbDBName||
                                  ' port='||vbPort::Text|| 
                                  ' user='||vbUserName||
                                  ' password='||vbPassword||'''::text,'''|| 
                                 'SELECT p.viewname::TVarChar AS Name '|| 
                                      ', p.definition::Text   AS SQL '|| 
                                 'FROM pg_catalog.pg_views p '|| 
                                 'WHERE p.schemaname <> ''''pg_catalog'''' '|| 
                                 '  AND p.schemaname <> ''''information_schema'''' '|| 
                                 'ORDER BY p.definition ILIKE ''''%_View%'''', 1 DESC;''::text) AS q(Name TVarChar, SQL Text)';
                      
     -- raise notice 'Value 1: % %', CLOCK_TIMESTAMP(), vbQueryText;

     EXECUTE vbQueryText;

   EXCEPTION
      WHEN others THEN
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
   END;
   
   IF text_var1 = '' AND EXISTS(SELECT 1 FROM _tmpView)
   THEN

     -- Пробигаемся по фильтрам
     vbIndex := 6;
     WHILE vbIndex > 0 LOOP
      
       -- raise notice 'Value 1: % <%> %', CLOCK_TIMESTAMP(), vbIndex, text_var1;

       IF vbIndex > 1 THEN text_var1 = ''; END IF;
           
       FOR vbView IN
          SELECT _tmpView.Name, _tmpView.SQL, _tmpView.isCrete       
          FROM _tmpView
       LOOP
       
         IF vbView.isCrete = FALSE
         THEN
       
           vbQueryText := 'CREATE OR REPLACE VIEW '||vbView.Name||' AS '||vbView.SQL||' '||'ALTER TABLE '||vbView.Name||' OWNER TO postgres';

           --raise notice 'Value 1: % %', CLOCK_TIMESTAMP(), vbQueryText;
           
           UPDATE _tmpView SET isCrete = TRUE
           WHERE _tmpView.Name ILIKE vbView.Name;

           BEGIN
             EXECUTE vbQueryText;
           EXCEPTION
              WHEN others THEN
                GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
           END; 
         
         END IF;
           
       END LOOP;
             
       -- Уменьшаем счетчие
       vbIndex := vbIndex - 1;
     END LOOP;  
   END IF;  

          
   -- Результат
   RETURN QUERY
   SELECT 1, (SELECT COUNT(*) FROM _tmpView WHERE _tmpView.isCrete = TRUE)::INTEGER, (SELECT COUNT(*) FROM _tmpView)::INTEGER, text_var1::TBlob;
   

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

  
/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 11.02.23                                                       * 
*/

-- Тест
-- select * from _replica.gpBranchService_Replication_View('0');