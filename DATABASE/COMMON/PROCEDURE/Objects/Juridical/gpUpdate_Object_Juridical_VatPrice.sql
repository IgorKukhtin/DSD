-- Function: gpUpdate_Object_Juridical_VatPrice()

DROP FUNCTION IF EXISTS gpUpdate_Object_Juridical_VatPrice (Integer, TDateTime, boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Object_Juridical_VatPrice(
    IN inId                  Integer   ,  -- ���� ������� <> 
    IN inVatPriceDate        TDateTime , 
    IN inIsVatPrice          Boolean   , 
    IN inSession             TVarChar     -- ������ ������������
)
  RETURNS void AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_Juridical_VatPrice());


   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Juridical_isVatPrice(), inId, inIsVatPrice);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectDate(zc_ObjectDate_Juridical_VatPrice(), inId, inVatPriceDate);



   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 06.05.20         *
*/

-- ����
--