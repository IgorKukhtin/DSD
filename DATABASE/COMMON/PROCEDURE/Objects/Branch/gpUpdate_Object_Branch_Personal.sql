-- Function: gpUpdate_Object_Branch_Personal()

DROP FUNCTION IF EXISTS gpUpdate_Object_Branch_Personal (Integer, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Branch_Personal(
    IN inId                    Integer   ,     -- ���� ������� <> 
    IN inPersonalId            Integer   ,     -- ��������� (���������) ��� ����.���.
    IN inPersonalStoreId       Integer   ,     -- ��������� (���������)
    IN inPersonalBookkeeperId  Integer   ,     -- ��������� (���������)
    IN inPersonalBookkeeper    TVarChar,      -- ��������� (���������) ���������
    IN inPlaceOf               TVarChar  ,     -- ����� �����������
    IN inSession               TVarChar        -- ������ ������������
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_Branch_Personal());

   -- ��������� ��-�� 
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Branch_Personal(), inId, inPersonalId);
   -- ��������� ��-�� 
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Branch_PersonalStore(), inId, inPersonalStoreId);
   -- ��������� ��-�� 
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Branch_PersonalBookkeeper(), inId, inPersonalBookkeeperId);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Branch_PersonalBookkeeper(), inId, inPersonalBookkeeper);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Branch_PlaceOf(), inId, inPlaceOf);
        
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;



/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.03.21         * add inPersonalBookkeeper
 20.12.15
 16.12.15         *
*/

-- ����
-- SELECT * FROM gpUpdate_Object_Branch_Personal(inId:=null, inPersonalBookkeeperId:=null, inSession:='2')