-- �������� �����

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Brand (Integer, Integer, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Brand(
 INOUT ioId              Integer,       -- ���� ������� <�����>
 INOUT ioCode            Integer,       -- �������� <��� ������>
    IN inName            TVarChar,      -- ������� �������� ������
    IN inCountryBrandId  Integer,       -- ���� ������� <������ �������������> 
    IN inSession         TVarChar       -- ������ ������������
)
RETURNS record
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Brand());
   vbUserId:= lpGetUserBySession (inSession);

   -- ����� ������- ��� ����� ����� � ioCode -> ioCode
   IF COALESCE (ioId, 0) = 0 AND COALESCE (ioCode,0) <> 0 THEN  ioCode := NEXTVAL ('Object_Brand_seq'); 
   END IF; 

   -- ����� ��� �������� �� Sybase �.�. ��� ��� = 0 
   IF COALESCE (ioId, 0) = 0 AND COALESCE (ioCode,0) = 0  THEN  ioCode := NEXTVAL ('Object_Brand_seq'); 
   ELSEIF ioCode = 0
         THEN ioCode := COALESCE ((SELECT ObjectCode FROM Object WHERE Id = ioId),0);
   END IF; 

   -- �������� ������������ ��� �������� <������������ ������>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Brand(), inName); 

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Brand(), ioCode, inName);

   -- ��������� ����� � <������ �������������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Brand_CountryBrand(), ioId, inCountryBrandId);

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
02.03.17                                                          *
19.02.17                                                          *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Brand()
