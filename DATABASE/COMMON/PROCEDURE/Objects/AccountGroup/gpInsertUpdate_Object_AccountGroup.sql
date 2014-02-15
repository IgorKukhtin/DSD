-- Function: gpInsertUpdate_Object_AccountGroup(Integer, Integer, TVarChar, TVarChar)

-- DROP FUNCTION gpInsertUpdate_Object_AccountGroup (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_AccountGroup(
 INOUT ioId             Integer,       -- ���� ������� <������ �������������� ������>
    IN inCode           Integer,       -- �������� <��� ������ �������������� ������>
    IN inName           TVarChar,      -- �������� <������������ ������ �������������� ������>
    IN inSession        TVarChar       -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE UserId Integer;
   DECLARE Code_calc Integer;   
 
BEGIN
   -- !!! ��� �������� !!!
   ioId := (SELECT Id FROM Object WHERE ObjectCode=inCode AND DescId =zc_Object_AccountGroup());
 
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_AccountGroup());
   UserId := inSession;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   Code_calc:=lfGet_ObjectCode (inCode, zc_Object_AccountGroup()); 
   
   -- �������� ������������ ��� �������� <������������ ������ �������������� ������>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_AccountGroup(), inName);
   -- �������� ������������ ��� �������� <��� ������ �������������� ������>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_AccountGroup(), Code_calc);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_AccountGroup(), Code_calc, inName);
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, UserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_AccountGroup (Integer, Integer, TVarChar, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 25.08.13                                        * !!! ��� �������� !!!
 21.06.13          * zc_Enum_Process_InsertUpdate_Object_AccountGroup(); Code_calc:=lpGet_ObjectCode (inCode, zc_Object_User());
 17.06.13          *

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_AccountGroup()
