-- Function: gpInsertUpdate_Object_City (Integer, Integer,  TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_City (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_City(
 INOUT ioId           Integer,       -- ���� ������� <���������� �����>
    IN inCode         Integer,       -- ��� ������� <���������� �����>     
    IN inName         TVarChar,      -- �������� ������� <���������� �����>
    IN inSession      TVarChar       -- ������ ������������
)
RETURNS integer 
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_City());
   vbUserId:= lpGetUserBySession (inSession);

   -- ����� ��� �������� �� Sybase �.�. ��� ��� = 0 
   IF inCode = 0 THEN  inCode := NEXTVAL ('Object_City_seq'); END IF; 

   -- �������� ������������ ��� �������� <������������ ���������� �����>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_City(), inName);
   -- �������� ������������ ��� �������� <��� ���������� �����>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_City(), inCode);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_City(), inCode, inName);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
06.03.2017                                                        *
28.02.2017                                                        *

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_City()
