-- Function: gpInsertUpdate_Object_User()

-- DROP FUNCTION gpInsertUpdate_Object_User();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_User(
 INOUT ioId          Integer   ,    -- ���� ������� <������������> 
    IN inCode        Integer   ,    -- 
    IN inUserName    TVarChar  ,    -- ������� �������� ������������ ������� <������������> 
    IN inPassword    TVarChar  ,    -- ������ ������������ 
    IN inMemberId    Integer   ,    -- ���. ����
    IN inSession     TVarChar       -- ������ ������������
)
  RETURNS Integer 
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE Code_max Integer;  
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_User());

   -- �������� ������������ ��� �������� <������������ ������������>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_User(), inUserName);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_User(), inCode, inUserName);

   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_User_Password(), ioId, inPassword);
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_User_Member(), ioId, inMemberId);


   -- ������� ���������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 07.06.13                                        * lpCheckRight
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_User ('2')
