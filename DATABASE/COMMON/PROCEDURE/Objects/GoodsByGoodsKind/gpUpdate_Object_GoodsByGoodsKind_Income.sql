-- Function: gpUpdate_Object_GoodsByGoodsKind_Income (Integer, Integer, Integer)

DROP FUNCTION IF EXISTS  gpUpdate_Object_GoodsByGoodsKind_Income (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_GoodsByGoodsKind_Income(
    IN inId                    Integer  , -- ключ объекта <>
    IN inGoodsIncomeId         Integer  , -- Товары факт приход
    IN inGoodsKindIncomeId     Integer  , -- Виды товаров факт приход
    IN inSession               TVarChar 
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_GoodsByGoodsKind());


   -- сохранили связь с <Товары  (факт приход)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_GoodsIncome(), inId, inGoodsIncomeId);
   -- сохранили связь с <Виды товаров  (факт приход)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_GoodsKindIncome(), inId, inGoodsKindIncomeId);



   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  
 11.12.24         *
*/

-- тест
-- 