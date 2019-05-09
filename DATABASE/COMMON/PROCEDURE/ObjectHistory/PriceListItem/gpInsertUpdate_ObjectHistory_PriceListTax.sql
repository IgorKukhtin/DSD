-- Function: gpInsertUpdate_ObjectHistory_PriceListItem()

DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_PriceListTax(Integer, Integer, Integer, TDateTime, TDateTime, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_ObjectHistory_PriceListTax(
    IN inId                         Integer,    -- ���� ������� <������� �����-�����>
    IN inPriceListFromId            Integer,    -- �����-����
    IN inPriceListToId              Integer,    -- �����-����
    IN inOperDate                   TDateTime,  -- ��������� ���� �
    IN inOperDateFrom               TDateTime,  -- ���� ���� ���������
    IN inTax                        TFloat,     -- (-)% ������ (+)% �������
    IN inSession                    TVarChar    -- ������ ������������
)
  RETURNS VOID AS
$BODY$
DECLARE
   DECLARE vbUserId Integer;
   DECLARE vbPriceListItemId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_ObjectHistory_PriceListItem());

   -- ��������
   IF COALESCE (inPriceListFromId, 0) = 0
   THEN
       RAISE EXCEPTION '������.�� ���������� �������� <�����-���� ���������>.';
   END IF;

   -- ��������
   IF COALESCE (inPriceListToId, 0) = 0
   THEN
       RAISE EXCEPTION '������.�� ���������� �������� <�����-���� ���������>.';
   END IF;

   -- ��������
   IF inOperDate < DATE_TRUNC ('MONTH', CURRENT_DATE) - INTERVAL '1 MONTH'
   THEN
       RAISE EXCEPTION '������.�������� <��������� ���� �> �� ����� ���� ������ ��� <%>.', DATE (DATE_TRUNC ('MONTH', CURRENT_DATE) - INTERVAL '1 MONTH');
   END IF;

   -- ��������
   IF inOperDateFrom < DATE_TRUNC ('MONTH', CURRENT_DATE) - INTERVAL '1 MONTH'
   THEN
       RAISE EXCEPTION '������.�������� <���� ���� ���������> �� ����� ���� ������ ��� <%>.', DATE (DATE_TRUNC ('MONTH', CURRENT_DATE) - INTERVAL '1 MONTH');
   END IF;


   -- ��������� ���� ���
   PERFORM  lpInsertUpdate_ObjectHistory_PriceListItem (ioId         := 0
                                                     , inPriceListId := inPriceListToId
                                                     , inGoodsId     := ObjectLink_PriceListItem_Goods.ChildObjectId
                                                     , inOperDate    := inOperDate
                                                     , inValue       := zfCalc_PriceTruncate (inOperDate     := CURRENT_DATE
                                                                                            , inChangePercent:= inTax
                                                                                            , inPrice        := ObjectHistoryFloat_PriceListItem_Value.ValueData
                                                                                            , inIsWithVAT    := ObjectBoolean_PriceWithVAT.ValueData
                                                                                             )
                                                     , inUserId      := vbUserId)
   /*PERFORM  gpInsertUpdate_ObjectHistory_PriceListItemLast
                                                      (ioId          := inId
                                                     , inPriceListId := inPriceListToId
                                                     , inGoodsId     := ObjectLink_PriceListItem_Goods.ChildObjectId
                                                     , inOperDate    := inOperDate
                                                     , inValue       := CAST (ObjectHistoryFloat_PriceListItem_Value.ValueData
                                                                           + (ObjectHistoryFloat_PriceListItem_Value.ValueData * inTax / 100) AS Numeric (16,2)) ::TFloat
                                                     , inIsLast      := TRUE
                                                     , inSession     := inSession)*/
              FROM ObjectLink AS ObjectLink_PriceListItem_PriceList
                  LEFT JOIN ObjectBoolean AS ObjectBoolean_PriceWithVAT
                                          ON ObjectBoolean_PriceWithVAT.ObjectId = ObjectLink_PriceListItem_PriceList.ChildObjectId
                                         AND ObjectBoolean_PriceWithVAT.DescId   = zc_ObjectBoolean_PriceList_PriceWithVAT()
                  LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_Goods
                                 ON ObjectLink_PriceListItem_Goods.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                AND ObjectLink_PriceListItem_Goods.DescId = zc_ObjectLink_PriceListItem_Goods()

                  LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                          ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                         AND ObjectHistory_PriceListItem.DescId = zc_ObjectHistory_PriceListItem()
                                         AND inOperDateFrom >= ObjectHistory_PriceListItem.StartDate AND inOperDateFrom < ObjectHistory_PriceListItem.EndDate
                  LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value
                                               ON ObjectHistoryFloat_PriceListItem_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                              AND ObjectHistoryFloat_PriceListItem_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()

              WHERE ObjectLink_PriceListItem_PriceList.DescId = zc_ObjectLink_PriceListItem_PriceList()
                AND ObjectLink_PriceListItem_PriceList.ChildObjectId = inPriceListFromId
                AND (ObjectHistoryFloat_PriceListItem_Value.ValueData <> 0 OR ObjectHistory_PriceListItem.StartDate <> zc_DateStart())
             ;

-- !!! �������� !!!
if inSession = '5' AND 1=1
then
    RAISE EXCEPTION 'Admin - Test = OK';
    -- '��������� �������� ����� 3 ���.'
end if;


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 21.08.15         *
*/
