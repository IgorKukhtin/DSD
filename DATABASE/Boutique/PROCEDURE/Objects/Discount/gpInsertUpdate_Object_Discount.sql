-- Function: gpInsertUpdate_Object_Discount (Integer, Integer, TVarChar, TFloat,  TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Discount (Integer, Integer, TVarChar, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Discount(
 INOUT ioId           Integer,       -- ���� ������� <�������� ������������� ������>            
    IN inCode         Integer,       -- ��� ������� <�������� ������������� ������>             
    IN inName         TVarChar,      -- �������� ������� <�������� ������������� ������>        
    IN inKindDiscount TFloat,        -- ���� ������� <��� ������>
    IN inSession      TVarChar       -- ������ ������������                     
)
  RETURNS integer
  AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbCode_max Integer;

BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Discount());
   vbUserId:= lpGetUserBySession (inSession);

   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

    -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_max:=lfGet_ObjectCode (inCode, zc_Object_Discount()); 

   -- �������� ������������ ��� �������� <������������>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Discount(), inName); 
   -- �������� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Discount(), vbCode_max);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Discount(), vbCode_max, inName);
   -- ��������� <��� ������>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Discount_KindDiscount(), ioId, inKindDiscount);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;



/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
22.02.17                                                          *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Discount(0, 1000, 'testdb',)
