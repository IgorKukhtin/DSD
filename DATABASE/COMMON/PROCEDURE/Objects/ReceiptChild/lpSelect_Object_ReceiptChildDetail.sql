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

WHERE ObjectFloat_Value.ValueData<>0 AND (ReceiptCount = 1 OR GoodsKindCompleteEqual) )
  ,

ReceiptDetail AS (select * from temp1)

SELECT ReceiptDetail.MainParentId
     , ReceiptDetail.GoodsId
     , ReceiptDetail.GoodsKindId
     , (ReceiptDetail.Amount * ReceiptDetail.AmountReceiptParent / ReceiptDetail.AmountReceipt)::TFloat
     , ReceiptDetail.ReceiptChildId 
     , ReceiptDetail.goodsIdParent, ReceiptDetail.goodsKindIdParent
FROM ReceiptDetail 
  WHERE (ReceiptDetail.goodsId, ReceiptDetail.goodsKindId) NOT 
     IN (SELECT ReceiptDetail.goodsIdParent, ReceiptDetail.goodsKindIdParent FROM  ReceiptDetail);
  
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
