-- Function: gpUpdate_Object_Unit_notStaffList

DROP FUNCTION IF EXISTS gpUpdate_Object_Unit_notStaffList (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Unit_notStaffList(
    IN inId                    Integer   , -- ���� ������� <�������������>
    IN inisnotStaffList        Boolean   , -- 
    IN inSession               TVarChar    -- ������ ������������
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Object_Unit_notStaffList());

   IF inId = 0
   THEN
       Return;
   END IF;
   
   -- �������� �������
   inisnotStaffList:= NOT inisnotStaffList;
   
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_notStaffList(), inId, inisnotStaffList);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 23.10.25         *            
*/

-- ����
-- 