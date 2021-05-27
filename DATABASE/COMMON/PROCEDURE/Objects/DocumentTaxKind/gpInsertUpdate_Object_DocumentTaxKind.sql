-- Function: gpInsertUpdate_Object_DocumentTaxKind(Integer, Integer, TVarChar, TVarChar)

-- DROP FUNCTION gpInsertUpdate_Object_DocumentTaxKind (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_DocumentTaxKind(
 INOUT ioId             Integer,       -- ���� ������� <���� ���� ������>
    IN inCode           Integer,       -- �������� <��� ���� ����� ������>
    IN inName           TVarChar,      -- �������� <������������ ���� ����� ������>
    IN inSession        TVarChar       -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE Code_max Integer;

BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_DocumentTaxKind());
   vbUserId:= lpGetUserBySession (inSession);

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   IF COALESCE (inCode, 0) = 0
   THEN
       SELECT MAX (ObjectCode) + 1 INTO Code_max FROM Object WHERE Object.DescId = zc_Object_DocumentTaxKind();
   ELSE
       Code_max := inCode;
   END IF;

   -- �������� ���� ������������ ��� �������� <������������ ���� ����� ������>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_DocumentTaxKind(), inName);
   -- �������� ���� ������������ ��� �������� <��� ���� ����� ������>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_DocumentTaxKind(), Code_max);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_DocumentTaxKind(), Code_max, inName);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_DocumentTaxKind (Integer, Integer, TVarChar, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 10.02.14                                                         *

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_DocumentTaxKind(2, 2,'test','2')
