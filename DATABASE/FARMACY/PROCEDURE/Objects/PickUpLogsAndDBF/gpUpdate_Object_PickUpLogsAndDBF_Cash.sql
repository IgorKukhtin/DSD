-- Function: gpUpdate_Object_PickUpLogsAndDBF_Cash()

DROP FUNCTION IF EXISTS gpUpdate_Object_PickUpLogsAndDBF_Cash (Integer, TVarchar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_PickUpLogsAndDBF_Cash(
    IN inCashSessionId  TVarChar  , -- �� ������
    IN inSession        TVarChar       -- ������ ������������
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_CorrectMinAmount());
   vbUserId := lpGetUserBySession (inSession); 

   
   IF EXISTS(SELECT Object_PickUpLogsAndDBF.Id
             FROM Object AS Object_PickUpLogsAndDBF
             WHERE Object_PickUpLogsAndDBF.DescId = zc_Object_PickUpLogsAndDBF()
               AND Object_PickUpLogsAndDBF.ValueData = inCashSessionId)
   THEN
   
     SELECT Object_PickUpLogsAndDBF.Id
     INTO vbId
     FROM Object AS Object_PickUpLogsAndDBF
     WHERE Object_PickUpLogsAndDBF.DescId = zc_Object_PickUpLogsAndDBF()
       AND Object_PickUpLogsAndDBF.ValueData = inCashSessionId;

     -- ��������� ����� � <��� ������� ���������� �����>
     PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_PickUpLogsAndDBF_Loaded(), vbId, True);

     -- ��������� �������� <���� ������ ��������>
     PERFORM lpInsertUpdate_ObjectDate(zc_ObjectDate_PickUpLogsAndDBF_DateLoaded(), vbId, CURRENT_TIMESTAMP);
       
     -- ��������� ��������
     PERFORM lpInsert_ObjectProtocol (vbId, vbUserId);
   END IF;


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 25.06.21                                                       *
*/

-- ����
-- select * from gpUpdate_Object_PickUpLogsAndDBF_Cash(inCashSessionId := '{CAE90CED-6DB6-45C0-A98E-84BC0E5D9F26}' ,  inSession := '3');