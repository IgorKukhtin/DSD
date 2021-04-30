-- Function: gpUpdate_OH_PriceListItem_Currency (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_OH_PriceListItem_Currency (Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_OH_PriceListItem_Currency (Integer, Integer, Integer, Integer, TDateTime, TFloat, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_OH_PriceListItem_Currency(
    IN inId                     Integer,    -- ���� ������� <������� �������>
    IN inCurrencyId             Integer,    -- ������
    IN inPriceListId            Integer,    -- �����-����
    IN inGoodsId                Integer,    -- �����
    IN inOperDate               TDateTime,  -- ���� �������� ����
   OUT outStartDate             TDateTime,  -- ���� �������� ����
   OUT outEndDate               TDateTime,  -- ���� �������� ����
 INOUT ioValue                  TFloat,     -- ����
    IN inIsLast                 Boolean,    -- 
    IN inisChangePrice          Boolean,    -- ������������� ���� ��/���
    IN inSession                TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
DECLARE
   DECLARE vbUserId Integer;
   DECLARE vbPriceListItemId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_ObjectHistory_PriceListItem());

   -- ��������� ������
 --PERFORM lpInsertUpdate_ObjectHistoryLink (zc_ObjectHistoryLink_PriceListItem_Currency(), OH_PriceListItem.Id, inCurrencyId)
   PERFORM lpInsertUpdate_ObjectHistoryLink (zc_ObjectHistoryLink_PriceListItem_Currency(), OH_PriceListItem_find.Id, inCurrencyId)
   FROM ObjectHistory AS OH_PriceListItem
        INNER JOIN ObjectHistory AS OH_PriceListItem_find
                                 ON OH_PriceListItem_find.ObjectId = OH_PriceListItem.ObjectId
   WHERE OH_PriceListItem.Id = inId
  ;

   -- �������� �� ���� ������� ������
   PERFORM lpUpdate_Object_PartionGoods_OperPriceList (inGoodsId:= ObjectLink_PriceListItem_Goods.ChildObjectId, inUserId:= vbUserId)
   FROM ObjectHistory AS OH_PriceListItem
        LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_Goods
                             ON ObjectLink_PriceListItem_Goods.ObjectId = OH_PriceListItem.ObjectId
                            AND ObjectLink_PriceListItem_Goods.DescId   = zc_ObjectLink_PriceListItem_Goods()
   WHERE OH_PriceListItem.Id = inId
  ;


  -- ���� ���������� ����� ��������� ���� ����
  IF COALESCE (inisChangePrice,FALSE) = TRUE
  THEN
      SELECT tmp.outStartDate, tmp.outEndDate
     INTO outStartDate, outEndDate
      FROM gpInsertUpdate_ObjectHistory_PriceListItemLast(ioId          := inId          ::Integer    -- ���� ������� <������� �������>
                                                        , inPriceListId := inPriceListId ::Integer    -- �����-����
                                                        , inGoodsId     := inGoodsId     ::Integer    -- �����
                                                        , inOperDate    := inOperDate    ::TDateTime  -- ���� �������� ����
                                                        , inValue       := ioValue       ::TFloat     -- ����
                                                        , inIsLast      := inIsLast      ::Boolean    -- 
                                                        , inSession     := inSession     ::TVarChar    -- ������ ������������
                                                        ) AS tmp;
  ELSE
     -- ������� ��� ��������
    
     -- ����� <������� ����>
     vbPriceListItemId := lpGetInsert_Object_PriceListItem (inPriceListId, inGoodsId, vbUserId);
 
     SELECT ObjectHistory.StartDate, ObjectHistory.EndDate, ObjectHistoryFloat_Value.ValueData
    INTO outStartDate, outEndDate, ioValue
     FROM ObjectHistory
          LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Value
                                       ON ObjectHistoryFloat_Value.ObjectHistoryId = ObjectHistory.Id
                                      AND ObjectHistoryFloat_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
     WHERE ObjectHistory.DescId = zc_ObjectHistory_PriceListItem()
       AND ObjectHistory.ObjectId = vbPriceListItemId
       AND ObjectHistory.StartDate <= inOperDate
       AND ObjectHistory.EndDate >= inOperDate
     ;

  END IF;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 30.04.21         *
 25.02.20         *
*/

-- ����
--