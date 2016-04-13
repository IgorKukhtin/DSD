-- Function: gpInsertUpdate_Object_MarginCategory(Integer, Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MarginCategory (Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MarginCategory (Integer, Integer, TVarChar, Tfloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MarginCategory (Integer, Integer, TVarChar, Tfloat, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MarginCategory(
    IN ioId             Integer,       -- ���� ������� <���� ���� ������>
    IN inCode           Integer,       -- �������� <��� ���� ����� ������>
    IN inName           TVarChar,      -- �������� <������������ ���� ����� ������>
    IN inPersent        Tfloat,        -- % ������� "�����"
    IN inisSite         Boolean,       -- ��� �����
    IN inSession        TVarChar       -- ������ ������������
)
RETURNS TABLE(Id INTEGER, Code Integer ) AS
$BODY$
   DECLARE UserId Integer;
   DECLARE Code_max Integer;   
   
BEGIN
 
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_MarginCategory());
   UserId := inSession;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   Code_max := lfGet_ObjectCode(inCode, zc_Object_MarginCategory());
   
   -- �������� ���� ������������ ��� �������� <������������ ���� ����� ������>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_MarginCategory(), inName);
   -- �������� ���� ������������ ��� �������� <��� ���� ����� ������>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_MarginCategory(), Code_max);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_MarginCategory(), Code_max, inName);
   
   -- ��������� �������� <% ������� "�����">
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_MarginCategory_Percent(), ioId, inPersent);
   -- ��������� �������� <��� �����>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_MarginCategory_Site(), ioId, inisSite);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, UserId);

   RETURN 
      QUERY SELECT ioId AS Id, Code_max AS Code;

END;$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 13.04.16         *
 05.04.16         *
 09.04.15                          *

*/

-- ����
-- BEGIN; SELECT * FROM gpInsertUpdate_Object_MarginCategory(0, 2,'��','2'); ROLLBACK
