-- Function: gpGet_ObjectHistory_DiscountPeriodItem ()

DROP FUNCTION IF EXISTS gpGet_ObjectHistory_DiscountPeriodItem (TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_ObjectHistory_DiscountPeriodItem(
    IN inOperDate           TDateTime , -- ���� ��������
    IN inUnitId             Integer   , -- ���� 
    IN inGoodsId            Integer   , -- �����
    IN inSession            TVarChar    -- ������ ������������
)                              
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , StartDate TDateTime, EndDate TDateTime
             , ValuePrice TFloat
)
AS
$BODY$
BEGIN

     -- �������� ������
     RETURN QUERY 
       SELECT
             ObjectHistory_DiscountPeriodItem.Id
           , ObjectLink_DiscountPeriodItem_Goods.ChildObjectId AS GoodsId
           , Object_Goods.ObjectCode AS GoodsCode
           , Object_Goods.ValueData AS GoodsName

           , ObjectHistory_DiscountPeriodItem.StartDate
           , ObjectHistory_DiscountPeriodItem.EndDate
           , ObjectHistoryFloat_DiscountPeriodItem_Value.ValueData AS ValuePrice

       FROM ObjectLink AS ObjectLink_DiscountPeriodItem_Unit
            LEFT JOIN ObjectLink AS ObjectLink_DiscountPeriodItem_Goods
                                 ON ObjectLink_DiscountPeriodItem_Goods.ObjectId = ObjectLink_DiscountPeriodItem_Unit.ObjectId
                                AND ObjectLink_DiscountPeriodItem_Goods.DescId = zc_ObjectLink_DiscountPeriodItem_Goods()
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_DiscountPeriodItem_Goods.ChildObjectId

            LEFT JOIN ObjectHistory AS ObjectHistory_DiscountPeriodItem
                                    ON ObjectHistory_DiscountPeriodItem.ObjectId = ObjectLink_DiscountPeriodItem_Unit.ObjectId
                                   AND ObjectHistory_DiscountPeriodItem.DescId = zc_ObjectHistory_DiscountPeriodItem()
                                   AND inOperDate >= ObjectHistory_DiscountPeriodItem.StartDate AND inOperDate < ObjectHistory_DiscountPeriodItem.EndDate
            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_DiscountPeriodItem_Value
                                         ON ObjectHistoryFloat_DiscountPeriodItem_Value.ObjectHistoryId = ObjectHistory_DiscountPeriodItem.Id
                                        AND ObjectHistoryFloat_DiscountPeriodItem_Value.DescId = zc_ObjectHistoryFloat_DiscountPeriodItem_Value()

       WHERE ObjectLink_DiscountPeriodItem_Unit.DescId = zc_ObjectLink_DiscountPeriodItem_Unit()
         AND ObjectLink_DiscountPeriodItem_Unit.ChildObjectId = inUnitId
         AND ObjectLink_DiscountPeriodItem_Goods.ChildObjectId = inGoodsId
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 28.04.17         *
*/

-- ����
-- select * from gpGet_ObjectHistory_DiscountPeriodItem(inOperDate := ('01.09.2015')::TDateTime , inUnitId := 311 , inGoodsId := 271 ,  inSession := '2');
