-- Function: gpRewiring_Replication_CalcFunctionMaster (TVarChar, TVarChar)

DROP FUNCTION IF EXISTS _replica.gpRewiring_Replication_CalcFunctionMaster (TVarChar);

CREATE OR REPLACE FUNCTION _replica.gpRewiring_Replication_CalcFunctionMaster(
    IN inSession                TVarChar    -- ������ ������������
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
   DECLARE vbFunctionCount  Integer;
BEGIN
   -- !!! ��� �������� !!!
   -- ioId := (SELECT Id FROM Object WHERE ObjectCode=inCode AND DescId =zc_Object_Account());

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Account());
   vbUserId:= inSession::Integer;
   
   text_var1 := '';
   vbFunctionCount := 0;
   
   SELECT Host, DBName, Port, UserName, Password
   INTO vbHost, vbDBName, vbPort, vbUserName, vbPassword
   FROM _replica.gpSelect_MasterConnectParams(inSession);
   
   BEGIN

     -- ������������ ���������� �������
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
                                 '      AND n.nspname <> ''''information_schema'''' ;''::text) AS q(FunctionCount Integer)';
                      
     --raise notice 'Value 1: % % %', CLOCK_TIMESTAMP(), vbFilter, vbQueryText;

     EXECUTE vbQueryText INTO vbFunctionCount;
        
        
   EXCEPTION
      WHEN others THEN
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
   END;
        
   -- ���������
   RETURN QUERY
   SELECT 1, vbFunctionCount, text_var1::TBlob;
   

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

  
/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 26.09.23                                                       * 
*/

-- ����

-- select * from _replica.gpRewiring_Replication_CalcFunctionMaster(zfCalc_UserAdmin());