-- Function: gpSelect_Object_ReceiptChild()

DROP FUNCTION IF EXISTS lpSelect_Object_ReceiptChildDetail (integer);

CREATE OR REPLACE FUNCTION lpSelect_Object_ReceiptChildDetail(
in UserId integer
)
RETURNS TABLE (MainReceiptId Integer, GoodsId Integer, GoodsKindId Integer, Value TFloat, ReceiptChildId Integer, goodsIdParent Integer, goodsKindIdParent Integer) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ReceiptChild());

   RETURN QUERY 
WITH RECURSIVE temp1 ( GoodsId, GoodsKindId, GoodsIdParent, GoodsKindIdParent, GoodsKindCompleteId, Amount, MainParentId, ReceiptChildId, AmountReceipt, AmountReceiptParent ) AS (
          SELECT 
           Object_Goods.Id          AS GoodsId
         , COALESCE(ObjectLink_ReceiptChild_GoodsKind.ChildObjectId,0)         AS GoodsKindId
         , 0 , 0 , COALESCE(ObjectLink_Receipt_GoodsKindComplete.ChildObjectId, 0)
         , ObjectFloat_Value.ValueData AS Value  
         , ObjectLink_ReceiptChild_Receipt.ChildObjectId
         , Object_ReceiptChild.Id
         , ObjectFloatReceipt_Value.valuedata
         , ObjectFloatReceipt_Value.valuedata
 FROM Object AS Object_ReceiptChild

 
                  LEFT JOIN ObjectFloat AS ObjectFloat_Value 
                                ON ObjectFloat_Value.ObjectId = Object_ReceiptChild.Id 
                               AND ObjectFloat_Value.DescId = zc_ObjectFloat_ReceiptChild_Value()
   LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_Receipt
                               ON ObjectLink_ReceiptChild_Receipt.ObjectId = Object_ReceiptChild.Id
                              AND ObjectLink_ReceiptChild_Receipt.DescId = zc_ObjectLink_ReceiptChild_Receipt()

                    LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKindComplete
                               ON ObjectLink_Receipt_GoodsKindComplete.ObjectId = ObjectLink_ReceiptChild_Receipt.ChildObjectId
                              AND ObjectLink_Receipt_GoodsKindComplete.DescId = zc_ObjectLink_Receipt_GoodsKindComplete()

          LEFT JOIN ObjectFloat AS ObjectFloatReceipt_Value
                                ON ObjectFloatReceipt_Value.ObjectId = ObjectLink_ReceiptChild_Receipt.ChildObjectId
                               AND ObjectFloatReceipt_Value.DescId = zc_ObjectFloat_Receipt_Value()

          LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_Goods
                               ON ObjectLink_ReceiptChild_Goods.ObjectId = Object_ReceiptChild.Id
                              AND ObjectLink_ReceiptChild_Goods.DescId = zc_ObjectLink_ReceiptChild_Goods()
               LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_ReceiptChild_Goods.ChildObjectId
          
          LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_GoodsKind
                              ON ObjectLink_ReceiptChild_GoodsKind.ObjectId = Object_ReceiptChild.Id
                             AND ObjectLink_ReceiptChild_GoodsKind.DescId = zc_ObjectLink_ReceiptChild_GoodsKind()
          
WHERE ObjectLink_ReceiptChild_Receipt.ChildObjectId IN (SELECT Id FROM tmpReceiptTable)

UNION 
SELECT 
           ObjectLink_ReceiptChild_Goods.ChildObjectId          AS GoodsId
         , coalesce(ObjectLink_ReceiptChild_GoodsKind.ChildObjectId, 0)         AS GoodsKindId
         , DD.GoodsId , DD.GoodsKindId, DD.GoodsKindCompleteId
         , ObjectFloat_Value.ValueData::TFloat AS VALUE
         , DD.MainParentId
         , ObjectLink_ReceiptChild_Receipt.ObjectId AS ChildReceiptId
         , (DD.ReceiptValue * DD.AmountReceipt / DD.AmountReceiptParent)::TFloat
         , DD.Amount 
      FROM 
         (SELECT ObjectFloatReceipt_Value.valuedata AS ReceiptValue, Object_Receipt.Id, temp1.MainParentId, temp1.GoodsId , 
                 temp1.GoodsKindId, 
                 temp1.GoodsKindCompleteId, 
                 temp1.Amount, temp1.AmountReceipt, temp1.AmountReceiptParent,
                 (COALESCE(ObjectLink_Receipt_GoodsKindComplete.ChildObjectId, 0) = temp1.GoodsKindCompleteId) AS GoodsKindCompleteEqual, 
                 COUNT(*) OVER (Partition by temp1.MainParentId, 
                 temp1.GoodsId, 
                 temp1.GoodsKindId) AS ReceiptCount
          
          FROM Object AS Object_Receipt

          LEFT JOIN ObjectFloat AS ObjectFloatReceipt_Value
                                ON ObjectFloatReceipt_Value.ObjectId = Object_Receipt.Id
                               AND ObjectFloatReceipt_Value.DescId = zc_ObjectFloat_Receipt_Value()

                   LEFT JOIN ObjectBoolean AS ObjectBoolean_Main_Parent
                                  ON ObjectBoolean_Main_Parent.ObjectId = Object_Receipt.Id
                                 AND ObjectBoolean_Main_Parent.DescId = zc_ObjectBoolean_Receipt_Main()

          LEFT JOIN ObjectLink AS ObjectLink_Receipt_Goods
                               ON ObjectLink_Receipt_Goods.ObjectId = Object_Receipt.Id
                              AND ObjectLink_Receipt_Goods.DescId = zc_ObjectLink_Receipt_Goods()

          LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                               ON ObjectLink_Receipt_GoodsKind.ObjectId = Object_Receipt.Id
                              AND ObjectLink_Receipt_GoodsKind.DescId = zc_ObjectLink_Receipt_GoodsKind()
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = ObjectLink_Receipt_GoodsKind.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKindComplete
                               ON ObjectLink_Receipt_GoodsKindComplete.ObjectId = Object_Receipt.Id
                              AND ObjectLink_Receipt_GoodsKindComplete.DescId = zc_ObjectLink_Receipt_GoodsKindComplete()

          JOIN temp1 ON temp1.GoodsId = ObjectLink_Receipt_Goods.ChildObjectId AND temp1.GoodsKindId = COALESCE(ObjectLink_Receipt_GoodsKind.ChildObjectId, 0)
         
          WHERE Object_Receipt.descid = zc_Object_Receipt() AND ObjectBoolean_Main_Parent.valuedata = TRUE 
   
         ) AS DD
          

          LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_Receipt
                               ON ObjectLink_ReceiptChild_Receipt.ChildObjectId = DD.Id
                              AND ObjectLink_ReceiptChild_Receipt.DescId = zc_ObjectLink_ReceiptChild_Receipt()
          
          LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_Goods
                               ON ObjectLink_ReceiptChild_Goods.ObjectId = ObjectLink_ReceiptChild_Receipt.ObjectId
                              AND ObjectLink_ReceiptChild_Goods.DescId = zc_ObjectLink_ReceiptChild_Goods()
               LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_ReceiptChild_Goods.ChildObjectId
          
          LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_GoodsKind
                              ON ObjectLink_ReceiptChild_GoodsKind.ObjectId = ObjectLink_ReceiptChild_Receipt.ObjectId
                             AND ObjectLink_ReceiptChild_GoodsKind.DescId = zc_ObjectLink_ReceiptChild_GoodsKind()

                 LEFT JOIN ObjectFloat AS ObjectFloat_Value 
                                ON ObjectFloat_Value.ObjectId = ObjectLink_ReceiptChild_Receipt.ObjectId 
                               AND ObjectFloat_Value.DescId = zc_ObjectFloat_ReceiptChild_Value()

WHERE ObjectFloat_Value.ValueData<>0 AND (ReceiptCount = 1 OR GoodsKindCompleteEqual)  AND DD.AmountReceiptParent <> 0 )
  ,

ReceiptDetail AS (select * from temp1)

SELECT ReceiptDetail.MainParentId
     , ReceiptDetail.GoodsId
     , ReceiptDetail.GoodsKindId
     , (ReceiptDetail.Amount * ReceiptDetail.AmountReceiptParent / ReceiptDetail.AmountReceipt)::TFloat
     , ReceiptDetail.ReceiptChildId 
     , ReceiptDetail.goodsIdParent, ReceiptDetail.goodsKindIdParent
FROM ReceiptDetail 
  WHERE (ReceiptDetail.goodsId, ReceiptDetail.goodsKindId, MainParentId) NOT 
     IN (SELECT ReceiptDetail.goodsIdParent, ReceiptDetail.goodsKindIdParent, MainParentId FROM  ReceiptDetail);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpSelect_Object_ReceiptChildDetail (integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 16.03.15                        *
*/

-- тест
--  CREATE TEMP TABLE tmpReceiptTable(id Integer) ON COMMIT DROP;  INSERT INTO tmpReceiptTable (Id) VALUES(355009 ); SELECT * FROM lpSelect_Object_ReceiptChildDetail (2)


-- Function: gpReport_GoodsMI_ProductionUnion_Tax ()

DROP FUNCTION IF EXISTS gpReport_ReceiptProductionAnalyze (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_ReceiptProductionAnalyze (
    IN inStartDate        TDateTime ,  
    IN inEndDate          TDateTime ,
    IN inUnitFromId       Integer   , 
    IN inUnitToId         Integer   , 
    IN inGoodsGroupId     Integer   ,
    IN inPriceListId_1    Integer, 
    IN inPriceListId_2    Integer, 
    IN inPriceListId_3    Integer, 
    IN inPriceListId_sale Integer, 
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor

AS
$BODY$
  DECLARE Cursor1 refcursor;
  DECLARE Cursor2 refcursor;
BEGIN


     CREATE TEMP TABLE tmpReceiptTable(id Integer) ON COMMIT DROP;
     CREATE TEMP TABLE tmpChildReceiptTable(MainReceiptid Integer, GoodsId Integer, GoodsKindId Integer, Value TFloat, 
            ReceiptChildId integer, GoodsIdParent integer, GoodsKindIdParent INTEGER, 
            Price1 TFloat, Price2 TFloat, Price3 TFloat) ON COMMIT DROP;

     WITH RECURSIVE temp1 (GoodsGroupId, GoodsGroupParentId, GoodsName)  AS
          (SELECT Id, NULL::Integer, OBJECT.valuedata AS GoodsName
             FROM OBJECT 
            WHERE OBJECT.Id = inGoodsGroupId
       UNION 
           SELECT Goods.Id, temp1.GoodsGroupId, Goods.valuedata AS GoodsName        
             FROM temp1, OBJECT AS Goods , ObjectLink AS ObjectLink_GoodsGroup
   
                  WHERE ObjectLink_GoodsGroup.ChildObjectId = temp1.GoodsGroupId
                    AND ObjectLink_GoodsGroup.ObjectId = Goods.Id 
                    AND ObjectLink_GoodsGroup.DescId = zc_ObjectLink_GoodsGroup_Parent()) 
                               
           INSERT INTO tmpReceiptTable (Id) SELECT Object_Receipt.Id from temp1 --LIMIT 100
                                            JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                  ON ObjectLink_Goods_GoodsGroup.ChildObjectId = temp1.GoodsGroupId
                                 AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                                 JOIN OBJECT AS Goods ON Goods.Id = ObjectLink_Goods_GoodsGroup.ObjectId

                             JOIN ObjectLink AS ObjectLink_Receipt_Goods
                               ON ObjectLink_Receipt_Goods.DescId = zc_ObjectLink_Receipt_Goods()
                              AND ObjectLink_Receipt_Goods.ChildObjectId = ObjectLink_Goods_GoodsGroup.ObjectId
                              
       JOIN Object AS Object_Receipt ON ObjectLink_Receipt_Goods.ObjectId = Object_Receipt.Id
                                  WHERE Object_Receipt.isErased = FALSE;
                               
   INSERT INTO tmpChildReceiptTable(MainReceiptid, GoodsId, GoodsKindId, Value, 
            ReceiptChildId, GoodsIdParent, GoodsKindIdParent, Price1, Price2, Price3)
   SELECT DD.MainReceiptid, DD.GoodsId, DD.GoodsKindId, DD.Value, 
            DD.ReceiptChildId, DD.GoodsIdParent, DD.GoodsKindIdParent,
            COALESCE(PriceList1.Price, 0),  COALESCE(PriceList2.Price, 0), COALESCE(PriceList3.Price, 0)
     FROM lpSelect_Object_ReceiptChildDetail(0) AS DD
               LEFT JOIN ObjectHistory_PriceListItem_View AS PriceList1 ON PriceList1.PriceListId = inPriceListId_1
                                                                  AND PriceList1.GoodsId = DD.GoodsId
                                                                  AND inEndDate BETWEEN PriceList1.StartDate AND PriceList1.EndDate
               LEFT JOIN ObjectHistory_PriceListItem_View AS PriceList2 ON PriceList2.PriceListId = inPriceListId_2
                                                                  AND PriceList2.GoodsId = DD.GoodsId
                                                                  AND inEndDate BETWEEN PriceList2.StartDate AND PriceList2.EndDate                               
               LEFT JOIN ObjectHistory_PriceListItem_View AS PriceList3 ON PriceList3.PriceListId = inPriceListId_3
                                                                  AND PriceList3.GoodsId = DD.GoodsId
                                                                  AND inEndDate BETWEEN PriceList3.StartDate AND PriceList3.EndDate;                               


    -- Результат


     OPEN Cursor1 FOR
     
     WITH GoodsMIContainer AS 
        ( SELECT MIContainer.MovementItemId, MIContainer.Amount, MIReceipt.ObjectId AS ReceiptId 
            FROM MovementItemContainer AS MIContainer
                  INNER JOIN MovementLinkObject AS MLO_From
                          ON MLO_From.MovementId = MIContainer.MovementId
                         AND MLO_From.DescId = zc_MovementLinkObject_From()
                         AND MLO_From.ObjectId = inUnitFromId
                         
                        JOIN MovementItemLinkObject AS MIReceipt 
                          ON MIReceipt.MovementItemId = MIContainer.MovementItemId 
                         AND MIReceipt.DescId = zc_MILinkObject_Receipt()

                      WHERE MIContainer.OperDate BETWEEN inStartDate AND inEndDate 
                        AND MIContainer.DescId = zc_MIContainer_Count()
                        AND MIContainer.WhereObjectId_Analyzer = inUnitToId
                        AND MIContainer.MovementDescId = zc_Movement_ProductionUnion()
                        AND MIContainer.IsActive = TRUE
                        AND MIContainer.Amount <> 0)
   , GoodsReceiptAmount AS (SELECT sum(GoodsMIContainer.Amount) AS Amount, ReceiptId
                               FROM GoodsMIContainer
                           GROUP BY ReceiptId)
   , SummMIReceiptAmount  AS (SELECT SUM(MIContainer.Amount) AS AmountSumm, GoodsMIContainer.ReceiptId 
                               FROM GoodsMIContainer
                               JOIN MovementItemContainer AS MIContainer 
                                 ON MIContainer.MovementItemId = GoodsMIContainer.MovementItemId
                                AND MIContainer.DescId = zc_MIContainer_Summ()
                           GROUP BY GoodsMIContainer.ReceiptId)

     SELECT  DD.MainReceiptid AS Receiptid, ObjectFloat_Value.valuedata AS VALUE, ObjectString_Goods_GoodsGroupFull.valuedata AS GoodsGroupNameFull,
               
             Object_Goods.ObjectCode AS GoodsCode, Object_Goods.ValueData AS GoodsName, MainReceipt.ValueData  AS  ReceiptCode,
             Object_GoodsKind.ValueData AS GoodsKindName, Object_Measure.valuedata AS MeasureName, 
             Price1/ObjectFloat_Value.valuedata AS Price1, 
             Price2/ObjectFloat_Value.valuedata AS Price2, 
             Price3/ObjectFloat_Value.valuedata AS Price3,
             PriceListSale.Price AS PriceSale,
             GoodsReceiptAmount.Amount,
             SummMIReceiptAmount.AmountSumm
             
       FROM
     (SELECT MainReceiptid, 
             SUM(tmpChildReceiptTable.VALUE * tmpChildReceiptTable.Price1) AS Price1, 
             SUM(tmpChildReceiptTable.VALUE * tmpChildReceiptTable.Price2) AS Price2, 
             SUM(tmpChildReceiptTable.VALUE * tmpChildReceiptTable.Price3) AS Price3
        FROM tmpChildReceiptTable GROUP BY MainReceiptid) AS DD
          LEFT JOIN GoodsReceiptAmount ON GoodsReceiptAmount.ReceiptId = DD.MainReceiptid
          LEFT JOIN SummMIReceiptAmount ON SummMIReceiptAmount.ReceiptId = DD.MainReceiptid

          LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                ON ObjectFloat_Value.ObjectId = DD.MainReceiptid
                               AND ObjectFloat_Value.DescId = zc_ObjectFloat_Receipt_Value()

          LEFT JOIN ObjectLink AS ObjectLink_Receipt_Goods
                               ON ObjectLink_Receipt_Goods.ObjectId = DD.MainReceiptId
                              AND ObjectLink_Receipt_Goods.DescId = zc_ObjectLink_Receipt_Goods()
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Receipt_Goods.ChildObjectId

          LEFT JOIN ObjectHistory_PriceListItem_View AS PriceListSale ON PriceListSale.PriceListId = inPriceListId_sale
                                                                  AND PriceListSale.GoodsId = ObjectLink_Receipt_Goods.ChildObjectId
                                                                  AND inEndDate BETWEEN PriceListSale.StartDate AND PriceListSale.EndDate

          LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                 ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                               ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id 
                              AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                               ON ObjectLink_Receipt_GoodsKind.ObjectId = DD.MainReceiptid
                              AND ObjectLink_Receipt_GoodsKind.DescId = zc_ObjectLink_Receipt_GoodsKind()
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = ObjectLink_Receipt_GoodsKind.ChildObjectId
               JOIN OBJECT AS MainReceipt ON MainReceipt.ID =  DD.MainReceiptid;
         -- приходы п/ф ГП
          RETURN NEXT Cursor1;

     OPEN Cursor2 FOR
       SELECT 
              Object_Goods.objectcode AS GoodsCode,
              Object_Goods.valuedata AS GoodsName,  
              MainReceiptid AS Receiptid, Value, Price1, Price2, Price3,
              VALUE * Price1 AS Sum1, VALUE * Price2 AS Sum2, VALUE * Price3 AS Sum3
         FROM tmpChildReceiptTable

          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpChildReceiptTable.GoodsId

          LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                 ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                               ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id 
                              AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpChildReceiptTable.GoodsKindId;
     
     RETURN NEXT Cursor2;
   
         
         
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_ReceiptProductionAnalyze (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.03.15                        *
*/

-- тест
-- SELECT * FROM gpReport_GoodsMI_ProductionUnion_Tax (inStartDate:= '01.06.2014', inEndDate:= '01.06.2014', inUnitId:= 8447, inSession:= zfCalc_UserAdmin()) ORDER BY 2;
