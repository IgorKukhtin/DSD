-- Function: gpInsertUpdate_Object_ClientKind(Integer,Integer,TVarChar,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ClientKind (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ClientKind(
 INOUT ioId	                 Integer,       -- ���� ������� <������� ��������>
    IN inCode                Integer,       -- ��� ������� <>
    IN inName                TVarChar,      -- �������� ������� <>
    IN inSession             TVarChar       -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpGetUserBySession (inSession);

   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   inCode:=lfGet_ObjectCode (inCode, zc_Object_ClientKind());

    
   -- �������� ���� ������������ ��� �������� <������������>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_ClientKind(), inName);
   -- �������� ���� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_ClientKind(), inCode);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ClientKind(), inCode, inName);
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 25.08.25         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_ClientKind ()
                            