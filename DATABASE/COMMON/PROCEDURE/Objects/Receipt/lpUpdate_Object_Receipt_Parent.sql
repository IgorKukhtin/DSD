-- Function: lpUpdate_Object_Receipt_Parent()

DROP FUNCTION IF EXISTS lpUpdate_Object_Receipt_Parent (Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_Object_Receipt_Parent(
    IN inReceiptId                  Integer   , -- ключ объекта
    IN inGoodsId                    Integer   , -- ключ объекта
    IN inUserId                     Integer   
)
RETURNS VOID
AS
$BODY$
BEGIN

    -- Список
    CREATE TEMP TABLE _tmpListMaster (ReceiptId Integer, GoodsId Integer, GoodsKindId Integer, GoodsKindCompleteId Integer) ON COMMIT DROP;
    -- Список
    INSERT INTO _tmpListMaster (ReceiptId, GoodsId, GoodsKindId, GoodsKindCompleteId)
       SELECT ObjectLink_Receipt_Goods.ObjectId                                                   AS ReceiptId
            , COALESCE (ObjectLink_Receipt_Goods.ChildObjectId, 0)                                AS GoodsId
            , COALESCE (ObjectLink_Receipt_GoodsKind.ChildObjectId, 0)                            AS GoodsKindId
            , COALESCE (ObjectLink_Receipt_GoodsKindComplete.ChildObjectId, zc_GoodsKind_Basis()) AS GoodsKindCompleteId
       FROM ObjectLink AS ObjectLink_Receipt_Goods
            INNER JOIN ObjectBoolean AS ObjectBoolean_Main
                                     ON ObjectBoolean_Main.ObjectId = ObjectLink_Receipt_Goods.ObjectId
                                    AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_Receipt_Main()
                                    AND ObjectBoolean_Main.ValueData = TRUE
            INNER JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                  ON ObjectLink_Receipt_GoodsKind.ObjectId = ObjectLink_Receipt_Goods.ObjectId
                                 AND ObjectLink_Receipt_GoodsKind.DescId = zc_ObjectLink_Receipt_GoodsKind()
                                 AND ObjectLink_Receipt_GoodsKind.ChildObjectId > 0 -- zc_GoodsKind_Basis()
            LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKindComplete
                                 ON ObjectLink_Receipt_GoodsKindComplete.ObjectId = ObjectLink_Receipt_Goods.ObjectId
                                AND ObjectLink_Receipt_GoodsKindComplete.DescId = zc_ObjectLink_Receipt_GoodsKindComplete()
       WHERE /*(ObjectLink_Receipt_Goods.ObjectId = inReceiptId
           OR ObjectLink_Receipt_Goods.ObjectId = inGoodsId
           OR COALESCE (inGoodsId, 0) = 0 OR COALESCE (inReceiptId, 0) = 0
             )
         AND*/ ObjectLink_Receipt_Goods.DescId = zc_ObjectLink_Receipt_Goods();

   -- сохранили свойство
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Receipt_Parent(), ObjectLink_Receipt_Goods.ObjectId, tmp.ReceiptId_parent)
   FROM ObjectLink AS ObjectLink_Receipt_Goods
        LEFT JOIN ObjectLink AS ObjectLink_Receipt_Parent
                             ON ObjectLink_Receipt_Parent.ObjectId = ObjectLink_Receipt_Goods.ObjectId
                            AND ObjectLink_Receipt_Parent.DescId = zc_ObjectLink_Receipt_Parent()
        LEFT JOIN (SELECT ObjectLink_Receipt_Goods.ObjectId                                               AS ReceiptId
                        , COALESCE (_tmpListMaster.ReceiptId, COALESCE (_tmpListMaster_two.ReceiptId, 0)) AS ReceiptId_parent
                   FROM ObjectLink AS ObjectLink_Receipt_Goods
                        INNER JOIN ObjectLink AS ObjectLink_ReceiptChild_Receipt
                                              ON ObjectLink_ReceiptChild_Receipt.ChildObjectId = ObjectLink_Receipt_Goods.ObjectId
                                             AND ObjectLink_ReceiptChild_Receipt.DescId = zc_ObjectLink_ReceiptChild_Receipt()

                        INNER JOIN Object AS Object_ReceiptChild ON Object_ReceiptChild.Id = ObjectLink_ReceiptChild_Receipt.ObjectId
                                                                AND Object_ReceiptChild.isErased = FALSE
                        INNER JOIN ObjectFloat AS ObjectFloat_Value 
                                               ON ObjectFloat_Value.ObjectId = ObjectLink_ReceiptChild_Receipt.ObjectId
                                              AND ObjectFloat_Value.DescId = zc_ObjectFloat_ReceiptChild_Value()
                                              AND ObjectFloat_Value.ValueData <> 0
                        LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                             ON ObjectLink_Receipt_GoodsKind.ObjectId = ObjectLink_Receipt_Goods.ObjectId
                                            AND ObjectLink_Receipt_GoodsKind.DescId = zc_ObjectLink_Receipt_GoodsKind()

                        LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_Goods
                                             ON ObjectLink_ReceiptChild_Goods.ObjectId = ObjectLink_ReceiptChild_Receipt.ObjectId
                                            AND ObjectLink_ReceiptChild_Goods.DescId = zc_ObjectLink_ReceiptChild_Goods()
                        INNER JOIN ObjectLink AS ObjectLink_ReceiptChild_GoodsKind
                                              ON ObjectLink_ReceiptChild_GoodsKind.ObjectId = ObjectLink_ReceiptChild_Receipt.ObjectId
                                             AND ObjectLink_ReceiptChild_GoodsKind.DescId = zc_ObjectLink_ReceiptChild_GoodsKind()
                                             AND ObjectLink_ReceiptChild_GoodsKind.ChildObjectId = zc_GoodsKind_WorkProgress()

                        LEFT JOIN _tmpListMaster ON _tmpListMaster.GoodsId = ObjectLink_ReceiptChild_Goods.ChildObjectId
                                                AND _tmpListMaster.GoodsKindId = ObjectLink_ReceiptChild_GoodsKind.ChildObjectId
                                                AND _tmpListMaster.GoodsKindCompleteId = ObjectLink_Receipt_GoodsKind.ChildObjectId

                        LEFT JOIN _tmpListMaster AS _tmpListMaster_two
                                                 ON _tmpListMaster_two.GoodsId = ObjectLink_ReceiptChild_Goods.ChildObjectId
                                                AND _tmpListMaster_two.GoodsKindId = ObjectLink_ReceiptChild_GoodsKind.ChildObjectId
                                                AND _tmpListMaster_two.GoodsKindCompleteId = zc_GoodsKind_Basis()
                                                AND _tmpListMaster.GoodsId IS NULL

                   WHERE (ObjectLink_Receipt_Goods.ObjectId = inReceiptId
                       OR ObjectLink_Receipt_Goods.ObjectId = inGoodsId
                       OR COALESCE (inGoodsId, 0) = 0 OR COALESCE (inReceiptId, 0) = 0
                         )
                      AND ObjectLink_Receipt_Goods.DescId = zc_ObjectLink_Receipt_Goods()
                  UNION
                   SELECT ObjectLink_Receipt_Goods.ObjectId      AS ReceiptId
                        , COALESCE (_tmpListMaster.ReceiptId, 0) AS ReceiptId_parent
                   FROM ObjectLink AS ObjectLink_Receipt_Goods
                        INNER JOIN ObjectLink AS ObjectLink_ReceiptChild_Receipt
                                              ON ObjectLink_ReceiptChild_Receipt.ChildObjectId = ObjectLink_Receipt_Goods.ObjectId
                                             AND ObjectLink_ReceiptChild_Receipt.DescId = zc_ObjectLink_ReceiptChild_Receipt()

                        INNER JOIN Object AS Object_ReceiptChild ON Object_ReceiptChild.Id = ObjectLink_ReceiptChild_Receipt.ObjectId
                                                                AND Object_ReceiptChild.isErased = FALSE
                        INNER JOIN ObjectFloat AS ObjectFloat_Value 
                                               ON ObjectFloat_Value.ObjectId = ObjectLink_ReceiptChild_Receipt.ObjectId
                                              AND ObjectFloat_Value.DescId = zc_ObjectFloat_ReceiptChild_Value()
                                              AND ObjectFloat_Value.ValueData <> 0
                        LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                             ON ObjectLink_Receipt_GoodsKind.ObjectId = ObjectLink_Receipt_Goods.ObjectId
                                            AND ObjectLink_Receipt_GoodsKind.DescId = zc_ObjectLink_Receipt_GoodsKind()

                        LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_Goods
                                             ON ObjectLink_ReceiptChild_Goods.ObjectId = ObjectLink_ReceiptChild_Receipt.ObjectId
                                            AND ObjectLink_ReceiptChild_Goods.DescId = zc_ObjectLink_ReceiptChild_Goods()
                        INNER JOIN ObjectLink AS ObjectLink_ReceiptChild_GoodsKind
                                              ON ObjectLink_ReceiptChild_GoodsKind.ObjectId = ObjectLink_ReceiptChild_Receipt.ObjectId
                                             AND ObjectLink_ReceiptChild_GoodsKind.DescId = zc_ObjectLink_ReceiptChild_GoodsKind()
                                             AND ObjectLink_ReceiptChild_GoodsKind.ChildObjectId <> zc_GoodsKind_WorkProgress()
                                             AND ObjectLink_ReceiptChild_GoodsKind.ChildObjectId > 0

                        LEFT JOIN _tmpListMaster ON _tmpListMaster.GoodsId = ObjectLink_ReceiptChild_Goods.ChildObjectId
                                                AND _tmpListMaster.GoodsKindId = ObjectLink_ReceiptChild_GoodsKind.ChildObjectId
                                                AND _tmpListMaster.GoodsKindCompleteId = zc_GoodsKind_Basis()

                   WHERE (ObjectLink_Receipt_Goods.ObjectId = inReceiptId
                       OR ObjectLink_Receipt_Goods.ObjectId = inGoodsId
                       OR COALESCE (inGoodsId, 0) = 0 OR COALESCE (inReceiptId, 0) = 0
                         )
                      AND ObjectLink_Receipt_Goods.DescId = zc_ObjectLink_Receipt_Goods()
                  ) AS tmp ON tmp.ReceiptId = ObjectLink_Receipt_Goods.ObjectId
   WHERE (ObjectLink_Receipt_Goods.ObjectId = inReceiptId
       OR ObjectLink_Receipt_Goods.ObjectId = inGoodsId
       OR COALESCE (inGoodsId, 0) = 0 OR COALESCE (inReceiptId, 0) = 0
         )
      AND ObjectLink_Receipt_Goods.DescId = zc_ObjectLink_Receipt_Goods()
      AND COALESCE (ObjectLink_Receipt_Parent.ObjectId, 0) <> COALESCE (tmp.ReceiptId_parent, 0);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpUpdate_Object_Receipt_Parent (Integer, Integer, Integer) OWNER TO postgres;
  
/*---------------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 15.03.15                                        *
*/

-- тест
-- SELECT * FROM lpUpdate_Object_Receipt_Parent (355308, 0, 0)
