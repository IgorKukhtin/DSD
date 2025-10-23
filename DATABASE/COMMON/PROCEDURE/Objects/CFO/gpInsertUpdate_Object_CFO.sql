-- Function: gpInsertUpdate_Object_CFO()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_CFO(Integer, Integer, TVarChar, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_CFO(
 INOUT ioId                  Integer   ,    -- ���� ������� <>
    IN inCode                Integer   ,    -- ��� �������
    IN inName                TVarChar  ,    -- �������� �������
    IN inMemberId            Integer   ,    -- ���. ����
    IN inComment             TVarChar  ,    -- ����������
    IN inSession             TVarChar       -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_CFO());
   vbUserId:= lpGetUserBySession (inSession);

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   inCode:=lfGet_ObjectCode (inCode, zc_Object_CFO());

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_CFO(), inCode, inName);

   -- ��������� ����� � <���.�����>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_CFO_Member(), ioId, inMemberId);
   -- ��������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_CFO_Comment(), ioId, inComment);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.    ������ �.�.   ���������� �.�.
 23.10.25         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_CFO()