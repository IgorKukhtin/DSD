-- Function: gpBranchService_Replication_UpdateDataLog (TVarChar)

DROP FUNCTION IF EXISTS _replica.gpBranchService_Replication_UpdateDataLog (TVarChar);

CREATE OR REPLACE FUNCTION _replica.gpBranchService_Replication_UpdateDataLog(
    IN inSession                TVarChar    -- ������ ������������
)
RETURNS TABLE (Id Integer, OutText TBlob, ErrorText TBlob) 
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
   
   DECLARE vbOutText   TEXT;

   DECLARE vbIndex     Integer;
   DECLARE vbRecord    record;
BEGIN
   -- !!! ��� �������� !!!
   -- ioId := (SELECT Id FROM Object WHERE ObjectCode=inCode AND DescId =zc_Object_Account());

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Account());
   vbUserId:= inSession::Integer;
   
   text_var1 := '';
   vbOutText  := '������ ��������� �������� ����������� ���������'||chr(13)||chr(10);
   
   CREATE TEMP TABLE _tmpFunction (Schema TVarChar, Name TVarChar, Argument Text, Proc Text, SQL Text) ON COMMIT DROP;
   CREATE TEMP TABLE _tmpTrigger (TableName TVarChar, SQLDrop Text, SQL Text) ON COMMIT DROP;
   
   BEGIN
   
     SELECT Host, DBName, Port, UserName, Password
     INTO vbHost, vbDBName, vbPort, vbUserName, vbPassword
     FROM _replica.gpBranchService_Select_MasterConnectParams(inSession);

     -- ********** �������� ������ ��� �������� �������
     IF NOT EXISTS(select Table_Name from information_schema.tables AS ISD where ISD.table_schema = '_replica' AND Table_Name ILIKE 'table_update_data')
     THEN
                              
       vbQueryText := 'SELECT q.SQL '||
                      'FROM dblink(''host='||vbHost||
                                    ' dbname='||vbDBName||
                                    ' port='||vbPort::Text|| 
                                    ' user='||vbUserName||
                                    ' password='||vbPassword||'''::text,'''|| 
                                   'select _replica.pg_get_tabledef(''''_replica'''', '''''||lower('table_update_data')||''''', False) AS SQL;''::text) AS '||
                                   'q(SQL Text)';

       --raise notice 'Value 1: % %', CLOCK_TIMESTAMP(), vbQueryText;
                      
       EXECUTE vbQueryText INTO vbQueryText;

       --raise notice 'Value 1: % %', CLOCK_TIMESTAMP(), vbQueryText;

       EXECUTE vbQueryText;
       
       vbOutText := vbOutText||'������� _replica.table_update_data ������� �������.'||chr(13)||chr(10);
              
     ELSE
       vbOutText := vbOutText||'������� _replica.table_update_data ��� �������.'||chr(13)||chr(10);
     END IF;


     -- ********** ������� �������
     -- �������� ������ ��� �������� �������
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
                                      ', pg_get_functiondef((n.nspname||''''.''''||p.proname||''''(''''||oidvectortypes(p.proargtypes)||'''')'''')::regprocedure)::Text AS SQL '|| 
                                 'FROM pg_catalog.pg_proc p '|| 
                                 '     LEFT JOIN pg_catalog.pg_namespace n ON n.oid = p.pronamespace '|| 
                                 'WHERE n.nspname = ''''_replica'''' '|| 
                                 '  AND (p.proname ILIKE ''''notice_changed%'''' OR p.proname ILIKE ''''zc_%'''') '||
                                 'ORDER BY 1 ;''::text) AS q(Schema TVarChar, Name TVarChar, Argument Text, Proc Text, SQL Text)';
                        
     --raise notice 'Value 1: % %', CLOCK_TIMESTAMP(), vbQueryText;

     EXECUTE vbQueryText;

     vbOutText := vbOutText||'������� ������� - '||(SELECT COUNT(*) FROM _tmpFunction)::TEXT||chr(13)||chr(10);

     -- ��������������� �������� �������
     FOR vbRecord IN
        SELECT _tmpFunction.SQL       
             , _tmpFunction.Name  
             , _tmpFunction.Proc     
        FROM _tmpFunction
     LOOP

       vbOutText := vbOutText||'�������� (����������) ������� - '||vbRecord.Name::TEXT||chr(13)||chr(10);
       
       EXECUTE vbRecord.SQL;       
     END LOOP;

     -- ********** �������� ��������
     -- �������� ������ ��� �������� ��������
     vbQueryText := 'INSERT INTO _tmpTrigger '||
                    'SELECT q.TableName '|| 
                         ', q.SQLDrop '|| 
                         ', q.SQL '||
                    'FROM dblink(''host='||vbHost||
                                  ' dbname='||vbDBName||
                                  ' port='||vbPort::Text|| 
                                  ' user='||vbUserName||
                                  ' password='||vbPassword||'''::text,'''|| 
                                 'SELECT c.relname  AS TableName '||
                                 '     , ''''DROP TRIGGER IF EXISTS ''''||t.TgName||'''' ON ''''||c.relname  AS SQLDrop'||
                                 '     , pg_get_triggerdef(t.oid, True) AS SQL '||
                                 'FROM pg_trigger t, pg_class c, pg_namespace n '||
                                 'WHERE n.nspname = ''''public'''' '||
                                 '  AND n.oid = c.relnamespace '||
                                 '  AND c.relkind = ''''r'''' '||
                                 '  AND t.tgrelid = c.oid '||
                                 '  AND NOT t.tgisinternal '||
                                 'ORDER BY 1 ;''::text) AS q(TableName TVarChar, SQLDrop Text, SQL Text)';
                        
     --raise notice 'Value 1: % %', CLOCK_TIMESTAMP(), vbQueryText;

     EXECUTE vbQueryText;

     vbOutText := vbOutText||'������� �������� - '||(SELECT COUNT(*) FROM _tmpTrigger)::TEXT||chr(13)||chr(10);

     -- ��������������� �������� ��������
     FOR vbRecord IN
        SELECT _tmpTrigger.TableName  
             , _tmpTrigger.SQLDrop     
             , _tmpTrigger.SQL     
        FROM _tmpTrigger
     LOOP
     
       IF EXISTS(select Table_Name 
                 from information_schema.tables AS ISD 
                 where ISD.table_schema = 'public' 
                   AND Table_Name ILIKE vbRecord.TableName)
       THEN

         vbOutText := vbOutText||'�������� (����������) ������� - '||vbRecord.TableName::TEXT||chr(13)||chr(10);
       
         EXECUTE vbRecord.SQLDrop;       

         EXECUTE vbRecord.SQL;       
       
       END IF;
     END LOOP;

   EXCEPTION
      WHEN others THEN
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
   END;
   
   IF COALESCE (text_var1, '') <> ''
   THEN
     vbOutText := vbOutText||text_var1;
   END IF;
          
   -- ���������
   RETURN QUERY
   SELECT 1, vbOutText::TBlob, text_var1::TBlob;
   

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

  
/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 11.02.23                                                       * 
*/

-- ����
-- 
select * from _replica.gpBranchService_Replication_UpdateDataLog('0');