-- Function: gpUpdate_Object_Partner_PriceList()

DROP FUNCTION IF EXISTS gpUpdate_Object_Partner_PriceList (Integer, TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_Partner_PriceList (Integer, TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_Partner_PriceList (Integer, TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Partner_PriceList(
 INOUT ioId                  Integer   ,    -- ���� ������� <����������> 
    IN inStartPromo          TDateTime ,    -- ���� ������ �����
    IN inEndPromo            TDateTime ,    -- ���� ��������� �����
    IN inRouteId             Integer   ,    -- 
    IN inRouteSortingId      Integer   ,    -- 
    IN inMemberId            Integer   ,    -- 
    IN inPriceListId         Integer   ,    -- �����-����
    IN inPriceListPromoId    Integer   ,    -- �����-����(���������)
    IN inPersonalId          Integer   ,    -- ��������� (�����������)
    IN inPersonalTradeId     Integer   ,    -- ��������� (��������)
    IN inUnitId              Integer   ,    -- 
    IN inSession             TVarChar       -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_Partner_PriceList());


   -- ��������� �������� <>
--   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Partner_StartPromo(), ioId, inStartPromo);
      -- ��������� �������� <>
--   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Partner_EndPromo(), ioId, inEndPromo);

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_Route(), ioId, inRouteId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_RouteSorting(), ioId, inRouteSortingId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_MemberTake(), ioId, inMemberId);
 
   -- ��������� ����� � <>
--   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Partner_PriceList(), ioId, inPriceListId);
   -- ��������� ����� � <>
--   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Partner_PriceListPromo(), ioId, inPriceListPromoId);

   -- ��������� ����� � <��������� (�����������)>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_Personal(), ioId, inPersonalId);
   -- ��������� ����� � <��������� (��������)>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_PersonalTrade(), ioId, inPersonalTradeId);

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_Unit(), ioId, inUnitId);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 16.03.15                                        * all
 27.10.14                                        *
*/

-- ����
-- SELECT * FROM gpUpdate_Object_Partner_PriceList()
