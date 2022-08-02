-- Function: lpDelete_ObjectHistory(Integer, tvarchar)

DROP FUNCTION IF EXISTS lpDelete_ObjectHistory (Integer, tvarchar);
DROP FUNCTION IF EXISTS lpDelete_ObjectHistory (Integer, Integer);

CREATE OR REPLACE FUNCTION lpDelete_ObjectHistory(
    IN inId         Integer, 
    IN inUserId     Integer
)
RETURNS VOID
AS
$BODY$
DECLARE
  lEndDate TDateTime;
  lStartDate TDateTime;
  lDescId Integer;
  lObjectId Integer;
  vbId_find Integer;
BEGIN
   -- ��������� 
   SELECT EndDate, StartDate, DescId, ObjectId 
          INTO lEndDate, lStartDate, lDescId, lObjectId
   FROM ObjectHistory WHERE Id = inId;

   -- ����� ������ ������ �������, ����� �������� ��� EndDate = EndDate ���������� ��������
   vbId_find:= (SELECT Id FROM ObjectHistory 
                WHERE ObjectHistory.DescId = lDescId 
                  AND ObjectHistory.ObjectId = lObjectId
                  AND ObjectHistory.StartDate < lStartDate
                ORDER BY ObjectHistory.StartDate DESC
                LIMIT 1);

   -- ��������
   IF COALESCE (vbId_find, 0) = 0
   THEN
       RAISE EXCEPTION '������.������� �� ������.';
   END IF;

   -- ��������� �������� - "��������"
   PERFORM lpInsert_ObjectHistoryProtocol (ObjectHistory.ObjectId, inUserId, ObjectHistory.StartDate, ObjectHistory.EndDate, ObjectHistoryFloat_Value.ValueData, TRUE, TRUE)
   FROM ObjectHistory
        LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Value
                                     ON ObjectHistoryFloat_Value.ObjectHistoryId = ObjectHistory.Id
                                    AND ObjectHistoryFloat_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
   WHERE ObjectHistory.Id = inId;

   -- ��������
   DELETE FROM ObjectHistoryLink WHERE ObjectHistoryId = inId;
   DELETE FROM ObjectHistoryString WHERE ObjectHistoryId = inId;
   DELETE FROM ObjectHistoryFloat WHERE ObjectHistoryId = inId;
   -- ��������
   DELETE FROM ObjectHistory WHERE Id = inId;


   -- �������� ��� ����� ������� �������� ��������� EndDate = EndDate ���������� ��������
   UPDATE ObjectHistory SET EndDate = lEndDate 
   WHERE Id = vbId_find;

   -- ��������� �������� - "��������� EndDate"
   PERFORM lpInsert_ObjectHistoryProtocol (ObjectHistory.ObjectId, inUserId, StartDate, EndDate, ObjectHistoryFloat_Value.ValueData)
   FROM ObjectHistory
        LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Value
                                     ON ObjectHistoryFloat_Value.ObjectHistoryId = ObjectHistory.Id
                                    AND ObjectHistoryFloat_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
   WHERE ObjectHistory.Id = vbId_find;


   -- �� ������ - c�������� ��������� ���� � �������
   IF zc_PriceList_Basis() = (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = lObjectId AND OL.DescId = zc_ObjectLink_PriceListItem_PriceList())
   THEN
       PERFORM lpUpdate_Object_PartionGoods_OperPriceList (inGoodsId:= (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = lObjectId AND OL.DescId = zc_ObjectLink_PriceListItem_Goods())
                                                         , inUserId := inUserId
                                                          );
   END IF;


   -- ��������
   IF inUserId = zfCalc_UserAdmin() :: Integer 
   THEN
       RAISE EXCEPTION '������.Admin.';
   END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 21.08.15         *
*/

/*
update Object_PartionGoods set OperPriceList    = a.OperPriceList  
from (

select Object_PartionGoods.MovementItemId, Object_PartionGoods.OperPriceList   as errPrice
, COALESCE (OHF_PriceListItem_Value.ValueData, 0) as OperPriceList   
from Object_PartionGoods

             INNER JOIN ObjectLink AS OL_PriceListItem_Goods on OL_PriceListItem_Goods.ChildObjectId = Object_PartionGoods.GoodsId
                                                            AND OL_PriceListItem_Goods.DescId        = zc_ObjectLink_PriceListItem_Goods()
            INNER JOIN ObjectLink AS OL_PriceListItem_PriceList
                                  ON OL_PriceListItem_PriceList.ObjectId      = OL_PriceListItem_Goods.ObjectId
                                 AND OL_PriceListItem_PriceList.DescId        = zc_ObjectLink_PriceListItem_PriceList()
                                 AND OL_PriceListItem_PriceList.ChildObjectId = zc_PriceList_Basis() -- !!!������� �����!!!
            LEFT JOIN ObjectHistory AS OH_PriceListItem
                                    ON OH_PriceListItem.ObjectId = OL_PriceListItem_Goods.ObjectId
                                   AND OH_PriceListItem.DescId   = zc_ObjectHistory_PriceListItem()
                                   AND OH_PriceListItem.EndDate  = zc_DateEnd() -- !!!��������� ��������!!!
            LEFT JOIN ObjectHistoryFloat AS OHF_PriceListItem_Value
                                         ON OHF_PriceListItem_Value.ObjectHistoryId = OH_PriceListItem.Id
                                        AND OHF_PriceListItem_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
       

where Object_PartionGoods.OperPriceList   <> COALESCE (OHF_PriceListItem_Value.ValueData, 0)                     -- ������ - ������ ���� �������� ����������
) as a where a.MovementItemId = Object_PartionGoods.MovementItemId
*/