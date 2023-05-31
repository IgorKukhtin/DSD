-- Function: _replica.gpBranchService_Create_NewTable (TVarChar, Boolean, Boolean, TVarChar)

DROP FUNCTION IF EXISTS _replica.gpBranchService_Create_NewTable (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION _replica.gpBranchService_Create_NewTable(
    IN inTableName              TVarChar,   -- �������� �������
   OUT outIsError               Boolean,   -- ������ ���������� 
   OUT outText                  TVarChar,   -- ������ ���������� 
    IN inSession                TVarChar    -- ������ ������������
)
  RETURNS Record AS
$BODY$
   DECLARE vbUserId    Integer;
   DECLARE vbHost      TVarChar;
   DECLARE vbDBName    TVarChar;
   DECLARE vbPort      Integer;
   DECLARE vbUserName  TVarChar;
   DECLARE vbPassword  TVarChar;
   DECLARE text_var1   Text;
   DECLARE vbQueryText TEXT;
BEGIN
   -- !!! ��� �������� !!!
   -- ioId := (SELECT Id FROM Object WHERE ObjectCode=inCode AND DescId =zc_Object_Account());

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Account());
   vbUserId:= inSession::Integer;
   
   outIsError := False;
   outText := '';

   BEGIN

     SELECT Host, DBName, Port, UserName, Password
     INTO vbHost, vbDBName, vbPort, vbUserName, vbPassword
     FROM _replica.gpBranchService_Select_MasterConnectParams(inSession);
     
     IF NOT EXISTS(select Table_Name from information_schema.tables AS ISD where ISD.table_schema = 'public' AND Table_Name ILIKE inTableName)
     THEN
                              
       vbQueryText := 'SELECT q.SQL '||
                      'FROM dblink(''host='||vbHost||
                                    ' dbname='||vbDBName||
                                    ' port='||vbPort::Text|| 
                                    ' user='||vbUserName||
                                    ' password='||vbPassword||'''::text,'''|| 
                                   'select _replica.pg_get_tabledef(''''public'''', '''''||lower(inTableName)||''''', False) AS SQL;''::text) AS '||
                                   'q(SQL Text)';
                      
       EXECUTE vbQueryText INTO vbQueryText;
              
       IF POSITION('TABLESPACE' IN vbQueryText) > 0 AND
          POSITION('pg_default' IN vbQueryText) = 0 
       THEN
         vbQueryText := SUBSTRING(vbQueryText, 1, POSITION('TABLESPACE' IN vbQueryText) - 1)||'TABLESPACE pg_default';
       END IF;

       --raise notice 'Value 1: % %', CLOCK_TIMESTAMP(), vbQueryText;

       EXECUTE vbQueryText;
       
       /*IF inTableName ILIKE '%Protocol'
       THEN
         vbQueryText := 'DROP SEQUENCE public.'||lower(inTableName)||'_id_seq CASCADE; '
                        'CRETE SEQUENCE public.'||lower(inTableName)||'_id_seq '||
                        'INCREMENT -1 MINVALUE -9223372036854775807 '||
                        'MAXVALUE -1 START -1 '||
                        'CACHE 1 OWNED BY NONE;';
                        
         --raise notice 'Value 1: % %', CLOCK_TIMESTAMP(), vbQueryText;

         EXECUTE vbQueryText;
       END IF;*/
          
       
       outText := '������� '||inTableName||' ������� �������.';
       
     END IF;

     -- raise notice 'Value 1: % %', CLOCK_TIMESTAMP(), vbQueryText;

   EXCEPTION
      WHEN others THEN
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
        outText := text_var1::TVarChar;
        outIsError := True;
   END;
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
select * from _replica.gpBranchService_Create_NewTable('ObjectProtocol', '0');