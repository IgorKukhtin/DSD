-- Function: gpInsertUpdate_Object_DiscountExternalSupplier()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_DiscountExternalSupplier (Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_DiscountExternalSupplier(
 INOUT ioId                            Integer   , -- ���� �������
    IN inCode                          Integer   , -- ��� ������� 
    IN inDiscountExternalId            Integer   , -- 
    IN inJuridicalId                   Integer   , -- 	����������� ���� (����������)
    IN inSupplierID                    Integer   , -- ID - ���������� � �������
    IN inSession                       TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_DiscountExternalSupplier());
   vbUserId := inSession;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_DiscountExternalSupplier());
   
   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_DiscountExternalSupplier(), vbCode_calc, '');

 
   -- ��������� ����� � <������� (���������� �����)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_DiscountExternalSupplier_DiscountExternal(), ioId, inDiscountExternalId);
   -- ��������� ����� � <	����������� ���� (����������)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_DiscountExternalSupplier_Juridical(), ioId, inJuridicalId);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_DiscountExternalSupplier_SupplierID(), ioId, inSupplierID);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*---------------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ������ �.�.
 11.03.21                                                       *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_DiscountExternalSupplier (ioId:=0, inCode:=0, inDiscountExternalSupplierKindId:=0, inSession:='2')