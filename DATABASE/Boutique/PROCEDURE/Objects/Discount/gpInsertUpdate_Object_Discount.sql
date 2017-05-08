-- �������� ������������� ������

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Discount (Integer, Integer, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Discount(
 INOUT ioId             Integer,       -- ���� ������� <�������� ������������� ������>            
 INOUT ioCode           Integer,       -- ��� ������� <�������� ������������� ������>             
    IN inName           TVarChar,      -- �������� ������� <�������� ������������� ������>        
    IN inDiscountKindId Integer,       -- ���� ������� <��� ������>
    IN inSession        TVarChar       -- ������ ������������                     
)
RETURNS record
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Discount());
   vbUserId:= lpGetUserBySession (inSession);

   -- ����� ��� �������� �� Sybase �.�. ��� ��� = 0 
   IF COALESCE (ioId, 0) = 0 AND COALESCE(ioCode,0) = 0  THEN  ioCode := NEXTVAL ('Object_Discount_seq'); 
   ELSEIF ioCode = 0
         THEN ioCode := coalesce((SELECT ObjectCode FROM Object WHERE Id = ioId),0);
   END IF; 

   -- ����� ������- ��� ����� ����� � ioCode -> ioCode
   IF COALESCE (ioId, 0) = 0 THEN  ioCode := NEXTVAL ('Object_Discount_seq'); 
   END IF; 

   -- �������� ������������ ��� �������� <������������>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Discount(), inName); 
   -- �������� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Discount(), ioCode);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Discount(), ioCode, inName);
  
   -- ��������� ����� � <��� ������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Discount_DiscountKind(), ioId, inDiscountKindId);


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
-- SELECT * FROM gpInsertUpdate_Object_Discount(0, 1000, 'testdb',)
