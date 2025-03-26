     CREATE  TABLE _calcChildReceiptTable (ReceiptId_parent Integer, ReceiptId_from Integer, ReceiptId Integer, GoodsId_in Integer, GoodsKindId_in Integer, Amount_in TFloat
                                           , ReceiptId_calc Integer, Amount_in_calc TFloat, Amount_in_calc_two TFloat, Amount_out_calc TFloat
                                           , ReceiptChildId integer, GoodsId_out Integer, GoodsKindId_out Integer, Amount_out TFloat, Amount_out_start TFloat, isStart Integer, isCost Boolean
                                           , Price1 TFloat, Price2 TFloat, Price3 TFloat
                                           , Price1_calc TFloat, Price2_calc TFloat, Price3_calc TFloat
                                           , Koeff1_bon TFloat, Koeff2_bon TFloat, Koeff3_bon TFloat, Price1_bon TFloat, Price2_bon TFloat, Price3_bon TFloat
                                            );

insert into _calcChildReceiptTable (ReceiptId_parent, ReceiptId_from, ReceiptId, GoodsId_in, GoodsKindId_in, Amount_in
            , ReceiptId_calc, Amount_in_calc, Amount_in_calc_two, Amount_out_calc
            , ReceiptChildId, GoodsId_out, GoodsKindId_out, Amount_out, Amount_out_start, isStart, isCost
            , Price1, Price2, Price3
            , Price1_calc, Price2_calc, Price3_calc
            , Koeff1_bon, Koeff2_bon, Koeff3_bon, Price1_bon, Price2_bon, Price3_bon
                                            ) 

SELECT tmp.ReceiptId_parent, tmp.ReceiptId_from, tmp.ReceiptId, tmp.GoodsId_in, tmp.GoodsKindId_in, tmp.Amount_in
            , tmp.ReceiptId_calc, tmp.Amount_in_calc, tmp.Amount_in_calc_two, tmp.Amount_out_calc
            , tmp.ReceiptChildId, tmp.GoodsId_out, tmp.GoodsKindId_out, tmp.Amount_out, tmp.Amount_out_start, tmp.isStart, tmp.isCost
            , tmp.Price1, tmp.Price2, tmp.Price3
            , tmp.Price1_calc, tmp.Price2_calc, tmp.Price3_calc
            , tmp.Koeff1_bon, tmp.Koeff2_bon, tmp.Koeff3_bon, tmp.Price1_bon, tmp.Price2_bon, tmp.Price3_bon
 FROM gpReport_ReceiptAnalyze_table (inGoodsGroupId := 1945 , inGoodsId := 2894 , inPriceListId_1 := 18886 , inPriceListId_2 := 18887 , inPriceListId_3 := 18873 , inPriceListId_sale := 18840 ,  inSession := '378f6845-ef70-4e5b-aeb9-45d91bd5e82e')
as tmp 



