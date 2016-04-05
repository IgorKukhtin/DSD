-- Function: gpInsertUpdate_Object_MarginReport(Integer, Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MarginReport (Integer, Integer, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MarginReport(
    IN ioId             Integer,       -- ���� ������� <���� ���� ������>
    IN inCode           Integer,       -- �������� <��� ���� ����� ������>
    IN inName           TVarChar,      -- �������� <������������ ���� ����� ������>
    IN inSession        TVarChar       -- ������ ������������
)
RETURNS TABLE(Id INTEGER, Code Integer ) AS
$BODY$
   DECLARE UserId Integer;
   DECLARE Code_max Integer;   
   
BEGIN
 
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_MarginReport());
   UserId := inSession;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   Code_max := lfGet_ObjectCode(inCode, zc_Object_MarginReport());
   
   -- �������� ���� ������������ ��� �������� <������������ ���� ����� ������>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_MarginReport(), inName);
   -- �������� ���� ������������ ��� �������� <��� ���� ����� ������>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_MarginReport(), Code_max);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_MarginReport(), Code_max, inName);
   
   
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
 05.04.16         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_MarginReport(0, 2,'��','2'); 
