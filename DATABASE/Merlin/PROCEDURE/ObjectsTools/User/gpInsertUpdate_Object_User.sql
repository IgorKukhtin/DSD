-- Function: gpInsertUpdate_Object_User()
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_User (Integer, Integer, TVarChar, TVarChar, TVarChar, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_User (Integer, Integer, TVarChar, TVarChar, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_User(
 INOUT ioId          Integer   ,    -- ���� ������� <������������> 
    IN inCode        Integer   ,    -- 
    IN inUserName    TVarChar  ,    -- ������� �������� ������������ ������� <������������> 
    IN inPassword    TVarChar  ,    -- ������ ������������ 
    IN inMemberId    Integer   ,    -- ���. ����
    IN inLanguageId  Integer   ,    -- ����
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS Integer 
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE Code_max Integer;
  DECLARE vbIsInsert Boolean;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_User());

   -- ���������� ������� ��������/�������������
   vbIsInsert:= COALESCE (ioId, 0) = 0;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   inCode:=lfGet_ObjectCode (inCode, zc_Object_User()); 
 
   -- �������� ������������ ��� �������� <������������ ������������>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_User(), inUserName, vbUserId);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_User(), inCode, inUserName);

   -- ��������� ��������  <������>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_User_Password(), ioId, inPassword);

   -- ��������� ��������  <���. ����>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_User_Member(), ioId, inMemberId);
   -- ��������� ��������  <�������������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_User_Language(), ioId, inLanguageId);

   IF vbIsInsert = TRUE THEN
      -- ��������� �������� <���� ��������>
      PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), ioId, CURRENT_TIMESTAMP);
      -- ��������� �������� <������������ (��������)>
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), ioId, vbUserId);
   END IF;

   -- ������� ���������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    �������� �.�.
 22.10.20         *
*/

-- select ObjectCode from Object where DescId = zc_Object_User() group by ObjectCode having count (*) > 1
-- select ValueData from Object where DescId = zc_Object_User() group by ValueData having count (*) > 1

-- ����
-- SELECT * FROM gpInsertUpdate_Object_User (zfCalc_UserAdmin())
