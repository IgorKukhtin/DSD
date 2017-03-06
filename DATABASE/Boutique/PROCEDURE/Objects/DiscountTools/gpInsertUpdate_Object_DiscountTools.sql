-- Function: gpInsertUpdate_Object_DiscountTools (Integer,  TFloat, TFloat, TTFloat, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_DiscountTools (Integer,  TFloat, TFloat, TTFloat, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_DiscountTools(
 INOUT ioId           Integer,       -- ���� ������� 
    IN inStartSumm    TFloat,        -- ��������� ����� ������
    IN inEndSumm      TFloat,        -- �������� ����� ������
    IN inDiscountTax  TFloat,        -- ������� ������
    IN inDiscountId   Integer,       -- ����� �������� ������������� ������
    IN inSession      TVarChar       -- ������ ������������
)
RETURNS integer
AS
$BODY$
  DECLARE UserId Integer;
  DECLARE Code_max Integer;

BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_DiscountTools());
   UserId := inSession;



   -- �������� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_DiscountTools(), Code_max);



   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_DiscountTools(), 0, '');
   
   -- ��������� ����� � <�������� ������������� ������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_DiscountTools_Discount(), ioId, inDiscountId);

   -- ��������� ��������
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_DiscountTools_StartSumm(), ioId, inStartSumm);
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_DiscountTools_EndSumm(), ioId, inEndSumm);
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_DiscountTools_DiscountTax(), ioId, inDiscountTax);


   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, UserId);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;



/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
23.02.17                                                          *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_DiscountTools()
