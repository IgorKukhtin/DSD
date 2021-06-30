-- Function: gpUpdate_Object_CheckoutTesting_Clear()

DROP FUNCTION IF EXISTS gpUpdate_Object_CheckoutTesting_Clear (Integer, TVarchar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_CheckoutTesting_Clear(
    IN inId                      Integer   ,   	-- ���� ������� <>
    IN inSession                 TVarChar       -- ������ ������������
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_CorrectMinAmount());
   vbUserId := lpGetUserBySession (inSession); 

   
   IF COALESCE(inId, 0) = 0
   THEN
     RAISE EXCEPTION '������ �� ���������.';
   END IF;

   -- ��������� ����� � <��� ������� ���������� �����>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_CheckoutTesting_Updates(), inId, False);

   -- ��������� �������� <���� ������ ��������>
   PERFORM lpInsertUpdate_ObjectDate(zc_ObjectDate_CheckoutTesting_DateUpdate(), inId, Null);
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 25.06.21                                                       *
*/

-- ����
-- 

select * from gpUpdate_Object_CheckoutTesting_Clear(inId := 0, inSession := '3');