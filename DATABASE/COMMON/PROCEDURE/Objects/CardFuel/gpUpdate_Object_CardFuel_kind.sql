-- Function: gpUpdate_Object_CardFuel_kind(Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS  gpUpdate_Object_CardFuel_kind (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_CardFuel_kind(
    IN inId                Integer   , -- ���� ������� <��������� �����>
    IN inCardFuelKindId    Integer   , -- C�����
    IN inSession           TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_CardFuel());

   -- ��������� ����� � <������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_CardFuel_CardFuelKind(), inId, inCardFuelKindId);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 28.12.21         *
*/

-- ����
--