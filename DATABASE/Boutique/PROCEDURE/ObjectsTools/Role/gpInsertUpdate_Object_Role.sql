-- Function: gpInsertUpdate_Object_Role()

-- DROP FUNCTION gpInsertUpdate_Object_Role();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Role(
 INOUT ioId	        Integer   ,     -- ���� ������� <��������> 
    IN inCode           Integer   ,     -- ��� ������� <��������> 
    IN inName           TVarChar  ,     -- �������� ������� <��������>
    IN inSession        TVarChar        -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE UserId Integer;
BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Role());

   UserId := inSession;

   -- ����� ��� �������� �� Sybase �.�. ��� ��� = 0 
   IF inCode = 0 THEN  inCode := NEXTVAL ('Object_Role_seq'); END IF; 
   
   -- �������� ������������ ��� �������� <������������ ��������>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Role(), inName);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Role(), inCode, inName);
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, UserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.
 06.05.17                                                        *
 23.09.13                         *

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Role()