 -- Function: gpInsertUpdate_Object_Receipt_ReceiptCost_From_Excel()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Receipt_ReceiptCost_From_Excel (Integer, TVarChar, Integer, TVarChar, TVarChar, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Receipt_ReceiptCost_From_Excel(
    IN inReceiptCode         Integer   ,
    IN inReceiptName         TVarChar   ,
    IN inGoodsCode           Integer   , -- Код объекта <Товар>
    IN inGoodsName           TVarChar   , -- Код объекта <Товар> 
    IN inGoodsKindName       TVarChar  ,
    IN inReceiptCostName     TVarChar  ,
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbGoodsId Integer;
   DECLARE vbReceiptId Integer; 
   DECLARE vbGoodsKindId Integer;
   DECLARE vbReceiptCostId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId:= lpGetUserBySession (inSession); 
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Receipt());

    
     -- !!!
     --IF inGoodsKindName ILIKE 'Б/В*' THEN inGoodsKindName:= 'Б/В'; END IF;

     -- !!!Пустая рецептура- Пропустили!!!
     IF COALESCE (inReceiptCode, 0) = 0 THEN
        RETURN; -- !!!ВЫХОД!!!
     END IF;

     -- !!!поиск ИД рецептуры!!!
     vbReceiptId:= (SELECT Object.Id
                    FROM Object
                    WHERE Object.ObjectCode = inReceiptCode
                      AND Object.DescId     = zc_Object_Receipt()
                      AND Object.isErased   = FALSE
                      AND inReceiptCode > 0
                   );
     -- Проверка
     IF COALESCE (vbReceiptId, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Не найдена Рецептура <(%) %> .', inReceiptCode, inReceiptName;
     END IF;

     -- !!!поиск ИД товара!!!
     vbGoodsId:= (SELECT Object.Id
                  FROM Object
                  WHERE Object.ObjectCode = inGoodsCode
                    AND Object.DescId     = zc_Object_Goods()
                    AND Object.isErased   = FALSE
                    AND inGoodsCode > 0
                 );
     -- Проверка
     IF COALESCE (vbGoodsId, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Не найден Товар <(%) %>.', inGoodsCode, inGoodsName;
     END IF;

     -- !!!поиск ИД вид товара!!!
     vbGoodsKindId:= (SELECT Object.Id
                      FROM Object
                      WHERE TRIM (Object.ValueData) ILIKE TRIM (inGoodsKindName)
                        AND Object.DescId     = zc_Object_GoodsKind()
                        --AND Object.isErased   = FALSE
                        AND TRIM (inGoodsKindName) <> ''
                     );
     -- Проверка
     IF COALESCE (vbGoodsKindId, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Не найден Вид товара <%>.', inGoodsKindName;
     END IF;
  
     -- !!!поиск ИД затраты!!!
     vbReceiptCostId:= (SELECT Object.Id
                        FROM Object
                        WHERE TRIM (Object.ValueData) ILIKE TRIM (inReceiptCostName)
                          AND Object.DescId     = zc_Object_Goods()
                          AND Object.isErased   = FALSE
                          AND TRIM (inReceiptCostName) <> ''
                       );
     -- Проверка
     IF COALESCE (vbReceiptCostId, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Не найдено название Затрат <%>.', inReceiptCostName;
     END IF;

   --
   IF EXISTS (SELECT 1
              FROM Object AS Object_Receipt
                   INNER JOIN ObjectLink AS ObjectLink_Receipt_Goods
                                         ON ObjectLink_Receipt_Goods.ObjectId      = Object_Receipt.Id
                                        AND ObjectLink_Receipt_Goods.DescId        = zc_ObjectLink_Receipt_Goods()
                                        AND ObjectLink_Receipt_Goods.ChildObjectId = vbGoodsId
                   INNER JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                         ON ObjectLink_Receipt_GoodsKind.ObjectId      = Object_Receipt.Id
                                        AND ObjectLink_Receipt_GoodsKind.DescId        = zc_ObjectLink_Receipt_GoodsKind()
                                        AND ObjectLink_Receipt_GoodsKind.ChildObjectId = vbGoodsKindId
              WHERE Object_Receipt.Id = vbReceiptId
             )
   THEN 
        -- сохранили связь с <Затраты в рецептурах>
        PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Receipt_ReceiptCost(), vbReceiptId, vbReceiptCostId); 
   ELSE
       RAISE EXCEPTION 'Ошибка.Рецептура <(%) %> для товара <(%) %> + <%> не найдена.', inReceiptCode, inReceiptName, inGoodsCode, inGoodsName, inGoodsKindName;
   END IF;
   
   IF vbUserId = 5 AND 1=0
   THEN
         RAISE EXCEPTION 'Тест. Ок. <%> <%>', vbReceiptCostId, inReceiptCostName; 
   END IF;   
   

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.09.23         *
*/

-- тест
--