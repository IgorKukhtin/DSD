-- Function: gpInsertUpdate_Object_DiscountExternalJuridical()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_DiscountExternalJuridical (Integer, Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_DiscountExternalJuridical(
 INOUT ioId                            Integer   , -- ���� �������
    IN inCode                          Integer   , -- ��� ������� 
    IN inDiscountExternalId            Integer   , -- 
    IN inJuridicalId                   Integer   , -- ����������� ����
    IN inExternalJuridical             TVarChar  , -- ����������� ���� �������, �������������, ������� ������������� �� ������� �������
    IN inSession                       TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_DiscountExternalJuridical());
   vbUserId := inSession;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_DiscountExternalJuridical());
   
   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_DiscountExternalJuridical(), vbCode_calc, '');

 
   -- ��������� ����� � <������� (���������� �����)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_DiscountExternalJuridical_DiscountExternal(), ioId, inDiscountExternalId);
   -- ��������� ����� � <����������� ����>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_DiscountExternalJuridical_Juridical(), ioId, inJuridicalId);

   -- ��������� �������� <����������� ���� �������>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_DiscountExternalJuridical_ExternalJuridical(), ioId, inExternalJuridical);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*---------------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  �������� �.�.
 16.05.17                                                       *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_DiscountExternalJuridical (ioId:=0, inCode:=0, inDiscountExternalJuridicalKindId:=0, inSession:='2')
