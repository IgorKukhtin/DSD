-- View: Recipe_byGoodsKind_View
DROP VIEW IF EXISTS Recipe_byGoodsKind_View;

CREATE OR REPLACE VIEW Recipe_byGoodsKind_View AS
     SELECT
           Object_Receipt.Id                            AS Id
         , Object_Receipt.ValueData                     AS NAME

         , OL_Receipt_Goods.ChildObjectId               AS GoodsId
--         , Object_Goods.ObjectCode                  AS GoodsCode
--         , Object_Goods.ValueData                   AS GoodsName
         , OL_ReceiptChild_Goods.ChildObjectId          AS ChildGoodsId
         , OL_Receipt_GoodsKind.ChildObjectId           AS GoodsKindId
--         , Object_GoodsKind.ValueData                   AS GoodsKindName

         , OL_ReceiptChild_GoodsKind.ChildObjectId      AS ChildGoodsKindId
--         , Object_GoodsKindChild.ValueData              AS ChildGoodsKindName

     FROM Object AS Object_Receipt

         INNER JOIN ObjectBoolean AS ObjectBoolean_Main
                                  ON ObjectBoolean_Main.ObjectId = Object_Receipt.Id
                                 AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_Receipt_Main()
                                 AND ObjectBoolean_Main.ValueData = True

          LEFT JOIN ObjectLink AS OL_Receipt_Goods
                               ON OL_Receipt_Goods.ObjectId = Object_Receipt.Id
                              AND OL_Receipt_Goods.DescId = zc_ObjectLink_Receipt_Goods()

          LEFT JOIN ObjectLink AS OL_Receipt_GoodsKind
                               ON OL_Receipt_GoodsKind.ObjectId = Object_Receipt.Id
                              AND OL_Receipt_GoodsKind.DescId = zc_ObjectLink_Receipt_GoodsKind()

          LEFT JOIN ObjectDate AS ObjectDate_StartDate
                               ON ObjectDate_StartDate.ObjectId = Object_Receipt.Id
                              AND ObjectDate_StartDate.DescId = zc_ObjectDate_Receipt_Start()

          LEFT JOIN ObjectDate AS ObjectDate_EndDate
                               ON ObjectDate_EndDate.ObjectId = Object_Receipt.Id
                              AND ObjectDate_EndDate.DescId = zc_ObjectDate_Receipt_End()
--CHILD

          INNER JOIN ObjectLink AS ObjectLink_ReceiptChild_Receipt
                               ON ObjectLink_ReceiptChild_Receipt.ChildObjectId = Object_Receipt.Id
                               AND ObjectLink_ReceiptChild_Receipt.DescId = zc_ObjectLink_ReceiptChild_Receipt()


          INNER JOIN ObjectLink AS OL_ReceiptChild_Goods
                                ON OL_ReceiptChild_Goods.ObjectId = ObjectLink_ReceiptChild_Receipt.ObjectId
                               AND OL_ReceiptChild_Goods.ChildObjectId = OL_Receipt_Goods.ChildObjectId
                               AND OL_ReceiptChild_Goods.DescId = zc_ObjectLink_ReceiptChild_Goods()

          LEFT JOIN ObjectLink AS OL_ReceiptChild_GoodsKind
                               ON OL_ReceiptChild_GoodsKind.ObjectId = ObjectLink_ReceiptChild_Receipt.ObjectId
                              AND OL_ReceiptChild_GoodsKind.DescId = zc_ObjectLink_ReceiptChild_GoodsKind()


--          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Receipt_Goods.ChildObjectId
--          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = ObjectLink_Receipt_GoodsKind.ChildObjectId
--          LEFT JOIN Object AS Object_GoodsKindChild ON Object_GoodsKindChild.Id = OL_ReceiptChild_GoodsKind.ChildObjectId


     WHERE Object_Receipt.DescId = zc_Object_Receipt()
       AND Object_Receipt.isErased = False
     ;




ALTER TABLE Recipe_byGoodsKind_View  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 25.12.14                                                       *
*/

-- тест
-- SELECT * FROM Recipe_byGoodsKind_View
