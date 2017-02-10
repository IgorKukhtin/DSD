-- Function: gpUpdate_Object_Branch_TTN()

DROP FUNCTION IF EXISTS gpUpdate_Object_Branch_TTN (Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Branch_TTN(
    IN inId                    Integer   ,     -- ���� ������� <> 
    IN inPersonalDriverId      Integer   ,     -- ��������
    IN inMember1Id             Integer   ,     -- �������� / ����������
    IN inMember2Id             Integer   ,     -- ���������
    IN inMember3Id             Integer   ,     -- ������������� ����(������ ��������)
    IN inMember4Id             Integer   ,     -- ������������� ����(����)
    IN inCarId                 Integer   ,     -- ���������� 
    IN inSession               TVarChar        -- ������ ������������
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_Branch_TTN());

   -- ��������� ��-�� 
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Branch_PersonalDriver(), inId, inPersonalDriverId);
   -- ��������� ��-�� 
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Branch_Member1(), inId, inMember1Id);
   -- ��������� ��-�� 
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Branch_Member2(), inId, inMember2Id);
   -- ��������� ��-�� 
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Branch_Member3(), inId, inMember3Id);
   -- ��������� ��-�� 
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Branch_Member4(), inId, inMember4Id);
   -- ��������� ��-�� 
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Branch_Car(), inId, inCarId);
        
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;



/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 26.01.16         *
*/

-- ����
-- 