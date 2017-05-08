-- ����� ���������

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_LineFabrica (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_LineFabrica(
 INOUT ioId           Integer,       -- ���� ������� <����� ���������>    
 INOUT ioCode         Integer,       -- ��� ������� <����� ���������>     
    IN inName         TVarChar,      -- �������� ������� <����� ���������>
    IN inSession      TVarChar       -- ������ ������������
)
RETURNS record
AS
$BODY$
  DECLARE vbUserId integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_LineFabrica());
   vbUserId:= lpGetUserBySession (inSession);

   -- ����� ��� �������� �� Sybase �.�. ��� ��� = 0 
   IF COALESCE (ioId, 0) = 0 AND COALESCE(ioCode,0) = 0  THEN  ioCode := NEXTVAL ('Object_LineFabrica_seq'); 
   ELSEIF ioCode = 0
         THEN ioCode := coalesce((SELECT ObjectCode FROM Object WHERE Id = ioId),0);
   END IF; 

   -- ����� ������- ��� ����� ����� � ioCode -> ioCode
   IF COALESCE (ioId, 0) = 0 THEN  ioCode := NEXTVAL ('Object_LineFabrica_seq'); 
   END IF; 

   -- �������� ������������ ��� �������� <������������>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_LineFabrica(), inName); 

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_LineFabrica(), ioCode, inName);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;



/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
08.05.17                                                          *
06.03.17                                                          *
22.02.17                                                          *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_LineFabrica()
