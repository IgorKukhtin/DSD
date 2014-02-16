-- Function: gpInsertUpdate_Object_RouteSorting(Integer, Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_RouteSorting (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_RouteSorting(
 INOUT ioId             Integer,       -- ���� ������� <���������� ���������>
    IN inCode           Integer,       -- �������� <��� ���������� ���������>
    IN inName           TVarChar,      -- �������� <������������ ���������� ���������>
    IN inSession        TVarChar       -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId  Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId  := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_RouteSorting());
   vbUserId  := inSession;

   -- �������� ���� ������������ ��� �������� <������������ ���������� ���������>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_RouteSorting(), inName);
   -- �������� ���� ������������ ��� �������� <��� ���������� ���������>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_RouteSorting(), inCode);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_RouteSorting(), inCode, inName);
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId );

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_RouteSorting (Integer, Integer, TVarChar, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 04.06.13          *

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_RouteSorting(1,1,'1','1')
