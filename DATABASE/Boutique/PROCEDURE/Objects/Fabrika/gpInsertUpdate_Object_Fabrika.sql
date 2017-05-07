-- ������� �������������

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Fabrika (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Fabrika(
 INOUT ioId           Integer,       -- ���� ������� <������� �������������>             
    IN inCode         Integer,       -- ��� ������� <������� �������������>              
    IN inName         TVarChar,      -- �������� ������� <������� �������������>         
    IN inSession      TVarChar       -- ������ ������������                      
)                                    
RETURNS integer
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Fabrika());
   vbUserId:= lpGetUserBySession (inSession);

    -- ����� ��� �������� �� Sybase �.�. ��� ��� = 0 
   IF inCode = 0 THEN  inCode := NEXTVAL ('Object_Fabrika_seq'); END IF; 
 
   -- �������� ������������ ��� �������� <������������ Fabrika>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Fabrika(), inName); 
   -- �������� ������������ ��� �������� <��� Fabrika>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Fabrika(), inCode);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Fabrika(), inCode, inName);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;



/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
19.02.17                                                          *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Fabrika()
