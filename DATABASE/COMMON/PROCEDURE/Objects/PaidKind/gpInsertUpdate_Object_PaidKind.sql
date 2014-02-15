-- Function: gpInsertUpdate_Object_PaidKind(Integer, Integer, TVarChar, TVarChar)

-- DROP FUNCTION gpInsertUpdate_Object_PaidKind (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_PaidKind(
 INOUT ioId             Integer,       -- ���� ������� <���� ���� ������>
    IN inCode           Integer,       -- �������� <��� ���� ����� ������>
    IN inName           TVarChar,      -- �������� <������������ ���� ����� ������>
    IN inSession        TVarChar       -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE UserId Integer;
   DECLARE Code_max Integer;   
   
BEGIN
 
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_PaidKind());
   UserId := inSession;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   IF COALESCE (inCode, 0) = 0
   THEN 
       SELECT MAX (ObjectCode) + 1 INTO Code_max FROM Object WHERE Object.DescId = zc_Object_PaidKind();
   ELSE
       Code_max := inCode;
   END IF; 
   
   -- �������� ���� ������������ ��� �������� <������������ ���� ����� ������>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_PaidKind(), inName);
   -- �������� ���� ������������ ��� �������� <��� ���� ����� ������>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_PaidKind(), Code_max);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_PaidKind(), Code_max, inName);
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, UserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_PaidKind (Integer, Integer, TVarChar, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 08.06.13          *

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_PaidKind(2, 2,'��','2')
