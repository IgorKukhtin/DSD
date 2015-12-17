-- Function: gpUpdate_Object_Branch_Personal()

DROP FUNCTION IF EXISTS gpUpdate_Object_Branch_Personal (Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Object_Branch_Personal(
    IN inId                    Integer   ,     -- ���� ������� <> 
    IN inPersonalBookkeeperId  Integer   ,     -- ��������� (���������)
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
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Branch_PersonalBookkeeper(), inId, inPersonalBookkeeperId);

        
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;



/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 16.12.15         *
*/

-- ����
-- SELECT * FROM gpUpdate_Object_Branch_Personal(inId:=null, inPersonalBookkeeperId:=null, inSession:='2')