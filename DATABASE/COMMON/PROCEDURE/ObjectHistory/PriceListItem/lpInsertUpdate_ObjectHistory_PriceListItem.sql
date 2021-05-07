-- Function: lpInsertUpdate_ObjectHistory_PriceListItem()

DROP FUNCTION IF EXISTS lpInsertUpdate_ObjectHistory_PriceListItem (Integer,Integer,Integer,TDateTime,TFloat,Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_ObjectHistory_PriceListItem (Integer,Integer,Integer,Integer,TDateTime,TFloat,Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_ObjectHistory_PriceListItem(
 INOUT ioId                     Integer,    -- ���� ������� <������� �����-�����>
    IN inPriceListId            Integer,    -- �����-����
    IN inGoodsId                Integer,    -- �����
    IN inGoodsKindId            Integer,    -- ��� ������
    IN inOperDate               TDateTime,  -- ���� �������� �����-�����
    IN inValue                  TFloat,     -- �������� ����
    IN inUserId                 Integer    -- ������ ������������
)
  RETURNS integer AS
$BODY$
DECLARE
   DECLARE vbPriceListItemId Integer;
BEGIN

   -- ���� �� ��������� ���� <�����-���� - ��������� � ����� ������>
   IF (NOT EXISTS (SELECT 1 FROM Object_Role_Process_View WHERE ProcessId = zc_Enum_Process_Update_PriceListItem() AND UserId = inUserId)
       OR EXISTS (SELECT 1 FROM Object_MemberPriceList_View AS MemberPriceList_View WHERE MemberPriceList_View.UserId = inUserId)
      )
      --
      AND inUserId <> zc_Enum_Process_Auto_PrimeCost()
   THEN
       -- ����� � ���������� "������ � ������"
       IF NOT EXISTS (SELECT 1 FROM Object_MemberPriceList_View AS MemberPriceList_View WHERE MemberPriceList_View.UserId = inUserId)
       THEN
           RAISE EXCEPTION '������. ��� ���� �������������� ����� <%>', lfGet_Object_ValueData (inPriceListId);

       -- �������� � ���������� "������ � ������" - ��� ��� ������ ��� �����
       ELSEIF NOT EXISTS (SELECT 1 FROM Object_MemberPriceList_View AS MemberPriceList_View WHERE MemberPriceList_View.UserId = inUserId AND MemberPriceList_View.PriceListId = inPriceListId)
       THEN
           RAISE EXCEPTION '������. � ������������ <%>.%��� ���� �������������� ����� <%>.%����� �������������� ������ ����� ������:% %'
                         , lfGet_Object_ValueData (inUserId)
                         , CHR (13)
                         , lfGet_Object_ValueData (inPriceListId)
                         , CHR (13)
                         , CHR (13)
                         , (SELECT STRING_AGG ('< ' || MemberPriceList_View.PriceListName || ' >', '; ') FROM Object_MemberPriceList_View AS MemberPriceList_View WHERE MemberPriceList_View.UserId = inUserId)
                          ;
       END IF;
   END IF;



   -- �������� ������ �� ������ ���
   vbPriceListItemId := lpGetInsert_Object_PriceListItem (inPriceListId, inGoodsId, inGoodsKindId, inUserId);
 
   -- ��������� ��� ������ ������ ������� ���
   ioId := lpInsertUpdate_ObjectHistory (ioId, zc_ObjectHistory_PriceListItem(), vbPriceListItemId, inOperDate, inUserId);
   -- ������������� ����
   PERFORM lpInsertUpdate_ObjectHistoryFloat (zc_ObjectHistoryFloat_PriceListItem_Value(), ioId, inValue);

   -- ��������� ��������
   PERFORM lpInsert_ObjectHistoryProtocol (inObjectId:= ObjectHistory.ObjectId, inUserId:= inUserId, inStartDate:= StartDate, inEndDate:= EndDate, inPrice:= inValue, inIsUpdate:= TRUE, inIsErased:= FALSE)
   FROM ObjectHistory WHERE Id = ioId;


END;$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  
 28.11.19         * inGoodsKindId
 21.08.15         *
*/
