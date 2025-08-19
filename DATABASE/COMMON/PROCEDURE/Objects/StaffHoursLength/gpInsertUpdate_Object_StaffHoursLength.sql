-- Function: gpInsertUpdate_Object_StaffHoursLength()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_StaffHoursLength(Integer, Integer, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_StaffHoursLength(
 INOUT ioId                  Integer   ,    -- ���� ������� <>
    IN inCode                Integer   ,    -- ��� �������
    IN inName                TVarChar  ,    -- �������� �������
    IN inComment             TVarChar  ,    -- ����������
    IN inSession             TVarChar       -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_StaffHoursLength());
   vbUserId:= lpGetUserBySession (inSession);

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   inCode:=lfGet_ObjectCode (inCode, zc_Object_StaffHoursLength());

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_StaffHoursLength(), inCode, inName);

   -- ��������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_StaffHoursLength_Comment(), ioId, inComment);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.    ������ �.�.   ���������� �.�.
 19.08.25         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_StaffHoursLength()