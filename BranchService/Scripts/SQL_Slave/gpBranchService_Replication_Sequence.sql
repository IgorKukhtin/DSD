-- Function: gpBranchService_Replication_Sequence (TVarChar)

DROP FUNCTION IF EXISTS _replica.gpBranchService_Replication_Sequence (TVarChar);

CREATE OR REPLACE FUNCTION _replica.gpBranchService_Replication_Sequence(
    IN inSession                TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, SequenceCountOk Integer, ErrorText TBlob) 
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
   DECLARE vbSequence      record;
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

   CREATE TEMP TABLE _tmpSequence (Name TVarChar
                                 , increment TVarChar  
                                 , Minimum_value TVarChar
                                 , Maximum_value TVarChar
                                 , Start_value TVarChar
                                 , isCrete boolean) ON COMMIT DROP;
   
   BEGIN
   

     -- Получаем даннын для создания функций
     vbQueryText := 'INSERT INTO _tmpSequence '||
                    'SELECT q.sequence_name '|| 
                         ', q.increment '||
                         ', q.minimum_value '||
                         ', q.maximum_value '||
                         ', q.start_value '||
                         ', False '||
                    'FROM dblink(''host='||vbHost||
                                  ' dbname='||vbDBName||
                                  ' port='||vbPort::Text|| 
                                  ' user='||vbUserName||
                                  ' password='||vbPassword||'''::text,'''|| 
                                 'SELECT s.sequence_name::TVarChar, s.increment::TVarChar, s.minimum_value::TVarChar, s.maximum_value::TVarChar, s.start_value::TVarChar '|| 
                                 'FROM information_schema.sequences AS S '|| 
                                 'WHERE S.sequence_catalog = current_database() '|| 
                                 '  AND S.sequence_schema = current_schema() '||  
                                 'ORDER BY sequence_name;''::text) AS q(sequence_name TVarChar, increment TVarChar, minimum_value TVarChar, maximum_value TVarChar, start_value TVarChar)';
                      
     -- raise notice 'Value 1: % %', CLOCK_TIMESTAMP(), vbQueryText;

     EXECUTE vbQueryText;

   EXCEPTION
      WHEN others THEN
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
   END;
              
   FOR vbSequence IN
      SELECT _tmpSequence.Name, _tmpSequence.increment, _tmpSequence.minimum_value, _tmpSequence.maximum_value, _tmpSequence.start_value, _tmpSequence.isCrete       
      FROM _tmpSequence
   LOOP
       
     IF (SELECT COUNT(*) from pg_statio_all_sequences where relname ILIKE vbSequence.Name) = 0 
     THEN
        vbQueryText := 'CREATE SEQUENCE '||vbSequence.Name||' '||
                       'INCREMENT '||vbSequence.increment||' '||
                       'MINVALUE '||vbSequence.minimum_value||' '||
                       'MAXVALUE '||vbSequence.maximum_value||' '||
                       'START '||vbSequence.start_value||' '||
                       'CACHE 1; '||
                       'ALTER TABLE '||vbSequence.Name||' '||
                       '  OWNER TO postgres';
       

       --raise notice 'Value 1: % %', CLOCK_TIMESTAMP(), vbQueryText;
           
       BEGIN
         EXECUTE vbQueryText;
         
         UPDATE _tmpSequence SET isCrete = TRUE
         WHERE _tmpSequence.Name ILIKE vbSequence.Name;
         
       EXCEPTION
          WHEN others THEN
            GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
       END; 
         
     END IF;
           
   END LOOP;
                       
   -- Результат
   RETURN QUERY
   SELECT 1, (SELECT COUNT(*) FROM _tmpSequence WHERE _tmpSequence.isCrete = TRUE)::INTEGER, text_var1::TBlob;
   

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

  
/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 30.04.23                                                       * 
*/

-- Тест
-- select * from _replica.gpBranchService_Replication_Sequence('0');