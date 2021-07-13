-- Function: gpUpdate_Object_CheckoutTesting_Cash()

DROP FUNCTION IF EXISTS gpUpdate_Object_CheckoutTesting_Cash (Integer, TVarchar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_CheckoutTesting_Cash(
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

   
   IF EXISTS(SELECT Object_CheckoutTesting.Id
             FROM Object AS Object_CheckoutTesting
             WHERE Object_CheckoutTesting.DescId = zc_Object_CheckoutTesting()
               AND Object_CheckoutTesting.ValueData = inCashSessionId)
   THEN
   
     SELECT Object_CheckoutTesting.Id
     INTO vbId
     FROM Object AS Object_CheckoutTesting
     WHERE Object_CheckoutTesting.DescId = zc_Object_CheckoutTesting()
       AND Object_CheckoutTesting.ValueData = inCashSessionId;

     -- ��������� ����� � <��� ������� ���������� �����>
     PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_CheckoutTesting_Updates(), vbId, True);

     -- ��������� �������� <���� ������ ��������>
     PERFORM lpInsertUpdate_ObjectDate(zc_ObjectDate_CheckoutTesting_DateUpdate(), vbId, CURRENT_TIMESTAMP);
       
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
-- select * from gpUpdate_Object_CheckoutTesting_Cash(inCashSessionId := '{CAE90CED-6DB6-45C0-A98E-84BC0E5D9F26}' ,  inSession := '3');