-- Function: gpBranchService_Replication_CalcViewMaster (TVarChar, TVarChar)

DROP FUNCTION IF EXISTS _replica.gpBranchService_Replication_CalcViewMaster (TVarChar);

CREATE OR REPLACE FUNCTION _replica.gpBranchService_Replication_CalcViewMaster(
    IN inSession                TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, ViewCount Integer, ErrorText TBlob) 
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
   DECLARE vbViewCount Integer;
BEGIN
   -- !!! это временно !!!
   -- ioId := (SELECT Id FROM Object WHERE ObjectCode=inCode AND DescId =zc_Object_Account());

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Account());
   vbUserId:= inSession::Integer;
   
   text_var1 := '';
   vbViewCount := 0;
   
   SELECT Host, DBName, Port, UserName, Password
   INTO vbHost, vbDBName, vbPort, vbUserName, vbPassword
   FROM _replica.gpBranchService_Select_MasterConnectParams(inSession);
   
   BEGIN

     -- Подсчитываем количество видов
     vbQueryText := 'SELECT q.ViewCount '||
                    'FROM dblink(''host='||vbHost||
                                  ' dbname='||vbDBName||
                                  ' port='||vbPort::Text|| 
                                  ' user='||vbUserName||
                                  ' password='||vbPassword||'''::text,'''|| 
                                 'SELECT count(*)::Integer AS ViewCount '|| 
                                 'FROM pg_catalog.pg_views p '|| 
                                 'WHERE p.schemaname <> ''''pg_catalog'''' '|| 
                                 '  AND p.schemaname <> ''''information_schema'''';''::text) AS q(ViewCount Integer)';
                      
     --raise notice 'Value 1: % % %', CLOCK_TIMESTAMP(), vbFilter, vbQueryText;

     EXECUTE vbQueryText INTO vbViewCount;
        
        
   EXCEPTION
      WHEN others THEN
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
   END;
        
   -- Результат
   RETURN QUERY
   SELECT 1, vbViewCount, text_var1::TBlob;
   

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

  
/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 11.02.23                                                       * 
*/

-- Тест
-- select * from _replica.gpBranchService_Replication_CalcViewMaster('0');