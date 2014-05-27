-- Function: gpUpdate_Object_Juridical_Params()

DROP FUNCTION IF EXISTS gpUpdate_Object_Juridical_Params (Integer, Integer, Integer, Integer, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Juridical_Params(
 INOUT ioId                  Integer   ,    -- ���� ������� <����������� ����>
    IN inRetailId            Integer   ,    -- �������� ����
    IN inPriceListId         Integer   ,    -- �����-����
    IN inPriceListPromoId    Integer   ,    -- �����-����(���������)
    IN inStartPromo          TDateTime ,    -- ���� ������ �����
    IN inEndPromo            TDateTime ,    -- ���� ��������� �����
    IN inSession             TVarChar       -- ������� ������������
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Juridical());
   vbUserId := inSession;

    -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Juridical_Retail(), ioId, inRetailId);

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Juridical_PriceList(), ioId, inPriceListId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Juridical_PriceListPromo(), ioId, inPriceListPromoId);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Juridical_StartPromo(), ioId, inStartPromo);
      -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Juridical_EndPromo(), ioId, inEndPromo);
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_Object_Juridical_Params  (Integer, Integer, Integer, Integer, TDateTime, TDateTime, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 25.05.14                                        *
*/

-- ����
-- SELECT * FROM gpUpdate_Object_Juridical_Params()
