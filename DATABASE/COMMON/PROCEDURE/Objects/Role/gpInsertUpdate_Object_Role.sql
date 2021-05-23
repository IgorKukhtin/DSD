-- Function: gpInsertUpdate_Object_Role()

-- DROP FUNCTION gpInsertUpdate_Object_Role();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Role(
 INOUT ioId	        Integer   ,     -- ���� ������� <��������>
    IN inCode           Integer   ,     -- ��� ������� <��������>
    IN inName           TVarChar  ,     -- �������� ������� <��������>
    IN inSession        TVarChar        -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Role());
   vbUserId:= lpGetUserBySession (inSession);


   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   inCode := lfGet_ObjectCode(inCode, zc_Object_Role());

   -- �������� ������������ ��� �������� <������������ ��������>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Role(), inName);
   -- �������� ������������ ��� �������� <��� ����� ��������>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Role(), inCode);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Role(), inCode, inName);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 23.09.13                         *

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Role()
