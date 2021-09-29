-- Function: gpUpdateObject_Partner_UnitMobile()

DROP FUNCTION IF EXISTS gpUpdateObject_Partner_UnitMobile (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateObject_Partner_UnitMobile(
    IN inId                  Integer   ,    -- ���� ������� <����������� ����>
    IN inUnitMobileId        Integer   ,    -- �����-����
    IN inSession             TVarChar       -- ������� ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_Partner_UnitMobile());
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Partner());

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Partner_UnitMobile(), inId, inUnitMobileId);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 27.09.21         *
*/

-- ����
-- SELECT * FROM gpUpdate_Object_Partner_UnitMobile()
