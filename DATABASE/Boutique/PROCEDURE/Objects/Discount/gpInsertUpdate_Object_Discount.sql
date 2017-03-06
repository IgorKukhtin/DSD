-- Function: gpInsertUpdate_Object_Discount (Integer, Integer, TVarChar, Integer,  TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Discount (Integer, Integer, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Discount(
 INOUT ioId             Integer,       -- ���� ������� <�������� ������������� ������>            
    IN inCode           Integer,       -- ��� ������� <�������� ������������� ������>             
    IN inName           TVarChar,      -- �������� ������� <�������� ������������� ������>        
    IN inDiscountKindId Integer,       -- ���� ������� <��� ������>
    IN inSession        TVarChar       -- ������ ������������                     
)
RETURNS integer
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Discount());
   vbUserId:= lpGetUserBySession (inSession);

    -- ����� ��� �������� �� Sybase �.�. ��� ��� = 0 
   IF inCode = 0 THEN  inCode := NEXTVAL ('Object_Discount_seq'); END IF; 


   -- �������� ������������ ��� �������� <������������>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Discount(), inName); 
   -- �������� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Discount(), inCode);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Discount(), inCode, inName);
  
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
