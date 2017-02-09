-- Function: gpUpdate_Object_Partner_PriceList()

DROP FUNCTION IF EXISTS gpUpdate_Object_Partner_PriceList (Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Partner_PriceList(
 INOUT ioId                  Integer   ,    -- ���� ������� <����������� ����>
    IN inPriceListId         Integer   ,    -- �����-����
    IN inPriceListPromoId    Integer   ,    -- �����-����(���������)
    IN inPriceListId_Prior   Integer   ,    -- �����-����
    IN inPriceListId_30103   Integer   ,    -- �����-����
    IN inPriceListId_30201   Integer   ,    -- �����-����
    IN inStartPromo          TDateTime ,    -- ���� ������ �����
    IN inEndPromo            TDateTime ,    -- ���� ��������� �����
    IN inSession             TVarChar       -- ������� ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_Partner_PriceList());

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Partner_PriceList(), ioId, inPriceListId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Partner_PriceListPromo(), ioId, inPriceListPromoId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Partner_PriceListPrior(), ioId, inPriceListId_Prior);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Partner_PriceList30103(), ioId, inPriceListId_30103);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Partner_PriceList30201(), ioId, inPriceListId_30201);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Partner_StartPromo(), ioId, DATE (inStartPromo));
      -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Partner_EndPromo(), ioId, DATE (inEndPromo));
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_Object_Partner_PriceList  (Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 22.06.15                                        *
*/

-- ����
-- SELECT * FROM gpUpdate_Object_Partner_PriceList()
