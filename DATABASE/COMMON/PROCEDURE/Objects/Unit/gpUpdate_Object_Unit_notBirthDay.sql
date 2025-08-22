-- Function: gpUpdate_Object_Unit_notBirthDay

DROP FUNCTION IF EXISTS gpUpdate_Object_Unit_notBirthDay (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Unit_notBirthDay(
    IN inId                    Integer   , -- ���� ������� <�������������>
    IN inisnotBirthDay         Boolean   , -- 
    IN inSession               TVarChar    -- ������ ������������
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Object_Unit_notBirthDay());

   IF inId = 0
   THEN
       Return;
   END IF;
   
   -- �������� �������
   inisnotBirthDay:= NOT inisnotBirthDay;
   
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_notBirthDay(), inId, inisnotBirthDay);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 14.08.25         *            
*/

-- ����
-- 