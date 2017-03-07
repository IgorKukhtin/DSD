-- Function: gpInsertUpdate_Object_LineFabrica (Integer, Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_LineFabrica (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_LineFabrica(
 INOUT ioId           Integer,       -- ���� ������� <����� ���������>    
    IN inCode         Integer,       -- ��� ������� <����� ���������>     
    IN inName         TVarChar,      -- �������� ������� <����� ���������>
    IN inSession      TVarChar       -- ������ ������������
)
RETURNS integer
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_LineFabrica());
   vbUserId:= lpGetUserBySession (inSession);

   -- ����� ��� �������� �� Sybase �.�. ��� ��� = 0 
   IF inCode = 0 THEN  inCode := NEXTVAL ('Object_LineFabrica_seq'); END IF; 
   -- �������� ������������ ��� �������� <������������>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_LineFabrica(), inName); 
   -- �������� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_LineFabrica(), inCode);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_LineFabrica(), inCode, inName);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;



/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
06.03.17                                                          *
22.02.17                                                          *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_LineFabrica()
