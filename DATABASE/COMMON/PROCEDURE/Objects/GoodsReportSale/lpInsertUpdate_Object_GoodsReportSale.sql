-- Function: lpInsertUpdate_Object_GoodsReportSale  (Integer,Integer,TVarChar,TVarChar,TVarChar,TVarChar,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_GoodsReportSale (Integer, TDateTime, TDateTime, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_GoodsReportSaleInf(
    IN inId                       Integer       -- ключ объекта <> 
  , IN inUnitId       Integer 
  , IN inGoodsId      Integer
  , IN inGoodsKindId  Integer
  
  , IN inAmount1      TFloat
  , IN inAmount2      TFloat
  , IN inAmount3      TFloat
  , IN inAmount4      TFloat
  , IN inAmount5      TFloat
  , IN inAmount6      TFloat
  , IN inAmount7      TFloat
  
  , IN inPromo1       TFloat
  , IN inPromo2       TFloat
  , IN inPromo3       TFloat
  , IN inPromo4       TFloat
  , IN inPromo5       TFloat
  , IN inPromo6       TFloat
  , IN inPromo7       TFloat
  
  , IN inBranch1      TFloat
  , IN inBranch2      TFloat
  , IN inBranch3      TFloat
  , IN inBranch4      TFloat
  , IN inBranch5      TFloat
  , IN inBranch6      TFloat
  , IN inBranch7      TFloat
  
  , IN inOrder1       TFloat
  , IN inOrder2       TFloat
  , IN inOrder3       TFloat
  , IN inOrder4       TFloat
  , IN inOrder5       TFloat
  , IN inOrder6       TFloat
  , IN inOrder7       TFloat
  
  , IN inOrderPromo1  TFloat
  , IN inOrderPromo2  TFloat
  , IN inOrderPromo3  TFloat
  , IN inOrderPromo4  TFloat
  , IN inOrderPromo5  TFloat
  , IN inOrderPromo6  TFloat
  , IN inOrderPromo7  TFloat
    
  , IN inOrderBranch1 TFloat
  , IN inOrderBranch2 TFloat
  , IN inOrderBranch3 TFloat
  , IN inOrderBranch4 TFloat
  , IN inOrderBranch5 TFloat
  , IN inOrderBranch6 TFloat
  , IN inOrderBranch7 TFloat
  
  , IN inUserId       Integer        -- сессия пользователя
)
 RETURNS VOID AS
$BODY$
BEGIN
   
   -- сохранили <Объект>
   inId := lpInsertUpdate_Object (inId, zc_Object_GoodsReportSale(), 0, '');

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsReportSale_Unit(), inId, inUnitId);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsReportSale_Goods(), inId, inGoodsId);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsReportSale_GoodsKind(), inId, inGoodsKindId);
   
   
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_GoodsReportSale_Amount1(), inId, inAmount1);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_GoodsReportSale_Amount2(), inId, inAmount2);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_GoodsReportSale_Amount3(), inId, inAmount3);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_GoodsReportSale_Amount4(), inId, inAmount4);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_GoodsReportSale_Amount5(), inId, inAmount5);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_GoodsReportSale_Amount6(), inId, inAmount6);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_GoodsReportSale_Amount7(), inId, inAmount7); 

   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_GoodsReportSale_Promo1(), inId, inPromo1);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_GoodsReportSale_Promo2(), inId, inPromo2);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_GoodsReportSale_Promo3(), inId, inPromo3);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_GoodsReportSale_Promo4(), inId, inPromo4);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_GoodsReportSale_Promo5(), inId, inPromo5);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_GoodsReportSale_Promo6(), inId, inPromo6);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_GoodsReportSale_Promo7(), inId, inPromo7); 

   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_GoodsReportSale_Branch1(), inId, inBranch1);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_GoodsReportSale_Branch2(), inId, inBranch2);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_GoodsReportSale_Branch3(), inId, inBranch3);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_GoodsReportSale_Branch4(), inId, inBranch4);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_GoodsReportSale_Branch5(), inId, inBranch5);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_GoodsReportSale_Branch6(), inId, inBranch6);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_GoodsReportSale_Branch7(), inId, inBranch7); 

   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_GoodsReportSale_Order1(), inId, inOrder1);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_GoodsReportSale_Order2(), inId, inOrder2);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_GoodsReportSale_Order3(), inId, inOrder3);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_GoodsReportSale_Order4(), inId, inOrder4);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_GoodsReportSale_Order5(), inId, inOrder5);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_GoodsReportSale_Order6(), inId, inOrder6);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_GoodsReportSale_Order7(), inId, inOrder7); 

   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_GoodsReportSale_OrderPromo1(), inId, inOrderPromo1);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_GoodsReportSale_OrderPromo2(), inId, inOrderPromo2);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_GoodsReportSale_OrderPromo3(), inId, inOrderPromo3);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_GoodsReportSale_OrderPromo4(), inId, inOrderPromo4);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_GoodsReportSale_OrderPromo5(), inId, inOrderPromo5);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_GoodsReportSale_OrderPromo6(), inId, inOrderPromo6);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_GoodsReportSale_OrderPromo7(), inId, inOrderPromo7); 

   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_GoodsReportSale_OrderBranch1(), inId, inOrderBranch1);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_GoodsReportSale_OrderBranch2(), inId, inOrderBranch2);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_GoodsReportSale_OrderBranch3(), inId, inOrderBranch3);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_GoodsReportSale_OrderBranch4(), inId, inOrderBranch4);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_GoodsReportSale_OrderBranch5(), inId, inOrderBranch5);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_GoodsReportSale_OrderBranch6(), inId, inOrderBranch6);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_GoodsReportSale_OrderBranch7(), inId, inOrderBranch7); 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 02.11.17         *
*/

-- тест
-- 