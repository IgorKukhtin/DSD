-- ������� �������������

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Fabrika (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Fabrika(
 INOUT ioId           Integer,       -- ���� ������� <������� �������������>             
 INOUT ioCode         Integer,       -- ��� ������� <������� �������������>              
    IN inName         TVarChar,      -- �������� ������� <������� �������������>         
    IN inSession      TVarChar       -- ������ ������������                      
)                                    
RETURNS record
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Fabrika());
   vbUserId:= lpGetUserBySession (inSession);

   -- ����� ������- ��� ����� ����� � ioCode -> ioCode
   IF COALESCE (ioId, 0) = 0 AND COALESCE(ioCode,0) <> 0 THEN  ioCode := NEXTVAL ('Object_Fabrika_seq'); 
   END IF; 

   -- ����� ��� �������� �� Sybase �.�. ��� ��� = 0 
   IF COALESCE (ioId, 0) = 0 AND COALESCE(ioCode,0) = 0  THEN  ioCode := NEXTVAL ('Object_Fabrika_seq'); 
   ELSEIF ioCode = 0
         THEN ioCode := COALESCE((SELECT ObjectCode FROM Object WHERE Id = ioId),0);
   END IF; 
 
   -- �������� ������������ ��� �������� <������������ Fabrika>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Fabrika(), inName); 
   -- �������� ������������ ��� �������� <��� Fabrika>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Fabrika(), ioCode);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Fabrika(), ioCode, inName);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;



/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
13.05.17                                                          *
08.05.17                                                          *
19.02.17                                                          *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Fabrika()
