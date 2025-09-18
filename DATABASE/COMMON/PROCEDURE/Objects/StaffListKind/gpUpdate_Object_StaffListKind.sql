
-- Function: gpUpdate_Object_StaffListKind  (Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_StaffListKind (Integer, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Object_StaffListKind(
    IN inId                Integer   ,    -- ���� ������� <> 
    IN inComment           TVarChar  ,    -- 
    IN inSession           TVarChar       -- ������ ������������
)
 RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_StaffListKind());
   
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_StaffListKind_Comment(), inId, inComment);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId, FALSE);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 15.09.25         * 
*/

-- ����
--