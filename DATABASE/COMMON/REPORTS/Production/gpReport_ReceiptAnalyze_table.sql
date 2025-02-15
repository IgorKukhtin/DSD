-- Function: gpReport_ReceiptAnalyze_table ()

DROP FUNCTION IF EXISTS gpReport_ReceiptAnalyze_table (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_ReceiptAnalyze_table (Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_ReceiptAnalyze_table (
    IN inGoodsGroupId     Integer   ,
    IN inGoodsId          Integer   ,
    IN inPriceListId_1    Integer,
    IN inPriceListId_2    Integer,
    IN inPriceListId_3    Integer,
    IN inPriceListId_sale Integer,
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (ReceiptId_parent Integer, ReceiptId_from Integer, ReceiptId Integer, GoodsId_in Integer, GoodsKindId_in Integer, Amount_in TFloat
             , ReceiptId_calc Integer, Amount_in_calc TFloat, Amount_in_calc_two TFloat, Amount_out_calc TFloat
             , ReceiptChildId integer, GoodsId_out Integer, GoodsKindId_out Integer, Amount_out TFloat, Amount_out_start TFloat, isStart Integer, isCost Boolean
             , Price1 TFloat, Price2 TFloat, Price3 TFloat
             , Price1_calc TFloat, Price2_calc TFloat, Price3_calc TFloat
             , Koeff1_bon TFloat, Koeff2_bon TFloat, Koeff3_bon TFloat, Price1_bon TFloat, Price2_bon TFloat, Price3_bon TFloat
              )

AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);
     
     
     CREATE TEMP TABLE tmpChildReceiptTable (ReceiptId_parent Integer, ReceiptId_from Integer, ReceiptId Integer, GoodsId_in Integer, GoodsKindId_in Integer, Amount_in TFloat
                                           , ReceiptId_calc Integer, Amount_in_calc TFloat, Amount_in_calc_two TFloat, Amount_out_calc TFloat
                                           , ReceiptChildId integer, GoodsId_out Integer, GoodsKindId_out Integer, Amount_out TFloat, Amount_out_start TFloat, isStart Integer, isCost Boolean
                                           , Price1 TFloat, Price2 TFloat, Price3 TFloat
                                           , Price1_calc TFloat, Price2_calc TFloat, Price3_calc TFloat
                                           , Koeff1_bon TFloat, Koeff2_bon TFloat, Koeff3_bon TFloat, Price1_bon TFloat, Price2_bon TFloat, Price3_bon TFloat
                                            ) ON COMMIT DROP;

     PERFORM gpReport_ReceiptAnalyze (inGoodsGroupId, inGoodsId, inPriceListId_1, inPriceListId_2, inPriceListId_3, inPriceListId_sale, inSession);


     RETURN QUERY
       SELECT tmpChildReceiptTable.ReceiptId_parent, tmpChildReceiptTable.ReceiptId_from, tmpChildReceiptTable.ReceiptId, tmpChildReceiptTable.GoodsId_in, tmpChildReceiptTable.GoodsKindId_in, tmpChildReceiptTable.Amount_in
            , tmpChildReceiptTable.ReceiptId_calc, tmpChildReceiptTable.Amount_in_calc, tmpChildReceiptTable.Amount_in_calc_two, tmpChildReceiptTable.Amount_out_calc
            , tmpChildReceiptTable.ReceiptChildId, tmpChildReceiptTable.GoodsId_out, tmpChildReceiptTable.GoodsKindId_out, tmpChildReceiptTable.Amount_out, tmpChildReceiptTable.Amount_out_start, tmpChildReceiptTable.isStart, tmpChildReceiptTable.isCost
            , tmpChildReceiptTable.Price1, tmpChildReceiptTable.Price2, tmpChildReceiptTable.Price3
            , tmpChildReceiptTable.Price1_calc, tmpChildReceiptTable.Price2_calc, tmpChildReceiptTable.Price3_calc
            , tmpChildReceiptTable.Koeff1_bon, tmpChildReceiptTable.Koeff2_bon, tmpChildReceiptTable.Koeff3_bon, tmpChildReceiptTable.Price1_bon, tmpChildReceiptTable.Price2_bon, tmpChildReceiptTable.Price3_bon
       FROM tmpChildReceiptTable
                 /*INNER JOIN ObjectLink AS ObjectLink_Receipt_Goods
                                       ON ObjectLink_Receipt_Goods.ObjectId = tmpChildReceiptTable.ReceiptId
                                      AND ObjectLink_Receipt_Goods.DescId = zc_ObjectLink_Receipt_Goods()
                                      AND ObjectLink_Receipt_Goods.ChildObjectId = inGoodsId */
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------

 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.02.24                                        *
*/

-- тест
-- SELECT * FROM gpReport_ReceiptAnalyze_table (inGoodsGroupId := 1945 , inGoodsId := 2894 , inPriceListId_1 := 18886 , inPriceListId_2 := 18887 , inPriceListId_3 := 18873 , inPriceListId_sale := 18840 ,  inSession := '378f6845-ef70-4e5b-aeb9-45d91bd5e82e');
