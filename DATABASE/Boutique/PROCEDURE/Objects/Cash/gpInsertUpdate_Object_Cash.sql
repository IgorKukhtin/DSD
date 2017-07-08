-- Function: gpInsertUpdate_Object_Cash (Integer, Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Cash (Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Cash (Integer, Integer, TVarChar, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Cash(
 INOUT ioId           Integer,       -- ���� ������� <�����>         
 INOUT ioCode         Integer,       -- ��� ������� <�����>          
    IN inName         TVarChar,      -- �������� ������� <�����> 
    IN inCurrencyId   Integer,       -- ������
    IN inUnitId       Integer,       -- �������������  
    IN inSession      TVarChar       -- ������ ������������
)
RETURNS record
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Cash());
   vbUserId:= lpGetUserBySession (inSession);

   -- ����� ������- ��� ����� ����� � ioCode -> ioCode
   IF COALESCE (ioId, 0) = 0 AND COALESCE (ioCode,0) <> 0 THEN  ioCode := NEXTVAL ('Object_Cash_seq'); 
   END IF; 

   -- ����� ��� �������� �� Sybase �.�. ��� ��� = 0 
   IF COALESCE (ioId, 0) = 0 AND COALESCE (ioCode,0) = 0  THEN  ioCode := NEXTVAL ('Object_Cash_seq'); 
   ELSEIF ioCode = 0
         THEN ioCode := COALESCE ((SELECT ObjectCode FROM Object WHERE Id = ioId),0);
   END IF; 

   -- �������� ������������ ��� �������� <������������ Cash>
--   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Cash(), inName); 
   -- �������� ������������ ��� �������� <��� Cash>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Cash(), ioCode);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Cash(), ioCode, inName);
   -- ��������� ����� � <������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Cash_Currency(), ioId, inCurrencyId);
   -- ��������� ����� � <�������������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Cash_Unit(), ioId, inUnitId);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;



/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
23.05.17                                                          *
13.05.17                                                          *
09.05.17                                                          *
06.03.17                                                          *
20.02.17                                                          *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Cash()
