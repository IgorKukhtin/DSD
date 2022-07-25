-- Function: gpInsertUpdate_Object_ProdOptItems()

--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ProdOptItems(Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ProdOptItems(Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ProdOptItems(Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ProdOptItems(
 INOUT ioId                     Integer   , -- Ключ
    IN inCode                   Integer   , -- Код
    IN inProductId              Integer   ,
 INOUT ioProdOptionsId          Integer   ,
    IN inProdOptPatternId       Integer   ,
    IN inProdColorPatternId     Integer   ,
    IN inMaterialOptionsId      Integer   ,
    IN inMovementId_OrderClient Integer   ,
 INOUT ioGoodsId                Integer   ,
   OUT outGoodsName             TVarChar  ,
    IN inAmount                 TFloat    ,
    IN inPriceIn                TFloat    ,
    IN inPriceOut               TFloat    ,
    IN inDiscountTax            TFloat    ,
    IN inPartNumber             TVarChar  ,
    IN inComment                TVarChar  ,
    IN inSession                TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
   DECLARE vbProdOptionsId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbMI_Id Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_ProdOptItems());
   vbUserId:= lpGetUserBySession (inSession);


   -- Проверка
   IF COALESCE (ioProdOptionsId, 0) = 0
   THEN
       RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.Значение <Опция> не установлено.'
                                             , inProcedureName := 'gpInsertUpdate_Object_ProdOptItems'
                                             , inUserId        := vbUserId
                                              );
   END IF;
   -- Проверка
   IF COALESCE (inProductId, 0) = 0
   THEN
       RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.Значение <Лодка> не установлен.'
                                             , inProcedureName := 'gpInsertUpdate_Object_ProdOptItems'
                                             , inUserId        := vbUserId
                                              );
   END IF;
   -- Проверка
   IF COALESCE (inMovementId_OrderClient, 0) = 0
   THEN
       RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.Документ <Заказ Клиента> не установлен.'
                                             , inProcedureName := 'gpInsertUpdate_Object_ProdOptItems'
                                             , inUserId        := vbUserId
                                              );
   END IF;

   -- Поиск - строка inMovementId_OrderClient с Лодкой
   vbMI_Id := (SELECT MI.Id FROM MovementItem AS MI WHERE MI.MovementId = inMovementId_OrderClient AND MI.ObjectId = inProductId AND MI.isErased = FALSE AND MI.DescId = zc_MI_Master());
   -- Проверка
   IF COALESCE (vbMI_Id, 0) = 0
   THEN
       RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.В Документе <Заказ Клиента> не найден главный элемент.'
                                             , inProcedureName := 'gpInsertUpdate_Object_ProdOptItems'
                                             , inUserId        := vbUserId
                                              );
   END IF;

   -- Проверка - нельзя дублировать опции
   IF EXISTS (SELECT 1
              FROM ObjectLink AS OL
                   -- Не удален
                   JOIN Object AS Object_ProdOptItems ON Object_ProdOptItems.Id       = OL.ObjectId
                                                     AND Object_ProdOptItems.isErased = FALSE
                   -- Опция
                   JOIN ObjectLink AS OL_ProdOptions
                                   ON OL_ProdOptions.ObjectId = OL.ObjectId
                                  AND OL_ProdOptions.DescId   = zc_ObjectLink_ProdOptItems_ProdOptions()
                   LEFT JOIN ObjectLink AS OL_ProdColorPattern
                                        ON OL_ProdColorPattern.ObjectId = OL_ProdOptions.ChildObjectId
                                       AND OL_ProdColorPattern.DescId   = zc_ObjectLink_ProdOptions_ProdColorPattern()
                                       -- с таким Boat Structure
                                       AND OL_ProdColorPattern.ChildObjectId = (SELECT OL_find.ChildObjectId FROM ObjectLink AS OL_find WHERE OL_find.ObjectId = ioProdOptionsId AND OL_find.DescId = zc_ObjectLink_ProdOptions_ProdColorPattern())
                   LEFT JOIN ObjectFLoat AS OF_CodeVergl
                                         ON OF_CodeVergl.ObjectId = OL_ProdOptions.ChildObjectId
                                        AND OF_CodeVergl.DescId   = zc_ObjectFloat_ProdOptions_CodeVergl()
                                        -- с таким CodeVergl
                                        AND OF_CodeVergl.ValueData = (SELECT OF_find.ValueData FROM ObjectFLoat AS OF_find WHERE OF_find.ObjectId = ioProdOptionsId AND OF_find.DescId = zc_ObjectFloat_ProdOptions_CodeVergl())
              WHERE OL.ChildObjectId = inProductId AND OL.DescId = zc_ObjectLink_ProdOptItems_Product()
                AND OL.ObjectId <> COALESCE (ioId, 0)
                AND (OL_ProdColorPattern.ChildObjectId > 0 OR OF_CodeVergl.ValueData > 0)
             )
   THEN
       RAISE EXCEPTION 'Ошибка.Дублирование опции <%> запрещено.'
                      , lfGet_Object_ValueData_sh (ioProdOptionsId)
                       ;
   END IF;

   -- Проверка MaterialOptions
   IF COALESCE (inMaterialOptionsId, 0) = 0 AND EXISTS (SELECT 1 FROM ObjectLink AS OL WHERE OL.ObjectId = ioProdOptionsId AND OL.DescId = zc_ObjectLink_ProdOptions_MaterialOptions() AND OL.ChildObjectId > 0)
   THEN
       RAISE EXCEPTION 'Ошибка.Для опции <%> необходимо выбрать Категорию.'
                      , lfGet_Object_ValueData_sh (ioProdOptionsId)
                       ;
   END IF;
   -- Проверка MaterialOptions
   IF inMaterialOptionsId > 0 AND NOT EXISTS (SELECT 1 FROM ObjectLink AS OL WHERE OL.ObjectId = ioProdOptionsId AND OL.DescId = zc_ObjectLink_ProdOptions_MaterialOptions() AND OL.ChildObjectId > 0)
   THEN
       RAISE EXCEPTION 'Ошибка.Для опции <%> не предусмотрен выбор Категории <%>.'
                      , lfGet_Object_ValueData_sh (ioProdOptionsId)
                      , lfGet_Object_ValueData_sh (inMaterialOptionsId)
                       ;
   END IF;

   -- Замена, т.к. подменили MaterialOptions
   IF inMaterialOptionsId > 0 AND NOT EXISTS (SELECT 1 FROM ObjectLink AS OL WHERE OL.ObjectId = ioProdOptionsId AND OL.DescId = zc_ObjectLink_ProdOptions_MaterialOptions() AND OL.ChildObjectId = inMaterialOptionsId)
   THEN
       -- Проверка
       IF 1 < (SELECT COUNT(*)
               FROM ObjectLink AS OL
                    JOIN ObjectLink AS OL_ProdColorPattern
                                    ON OL_ProdColorPattern.ObjectId = OL.ObjectId
                                   AND OL_ProdColorPattern.DescId   = zc_ObjectLink_ProdOptions_ProdColorPattern()
                                   -- с таким Boat Structure
                                   AND OL_ProdColorPattern.ChildObjectId = (SELECT OL_find.ChildObjectId FROM ObjectLink AS OL_find WHERE OL_find.ObjectId = ioProdOptionsId AND OL_find.DescId = zc_ObjectLink_ProdOptions_ProdColorPattern())
               WHERE OL.ChildObjectId = inMaterialOptionsId AND OL.DescId = zc_ObjectLink_ProdOptions_MaterialOptions()
              )
       THEN
           RAISE EXCEPTION 'Ошибка.Найдено несколько опций <%> с Категорией <%>.'
                          , lfGet_Object_ValueData_sh (ioProdOptionsId)
                          , lfGet_Object_ValueData_sh (inMaterialOptionsId)
                           ;
       END IF;

       -- Нашли
       vbProdOptionsId:= COALESCE ((SELECT OL.ObjectId
                                    FROM ObjectLink AS OL
                                         JOIN ObjectLink AS OL_ProdColorPattern
                                                         ON OL_ProdColorPattern.ObjectId      = OL.ObjectId
                                                        AND OL_ProdColorPattern.DescId        = zc_ObjectLink_ProdOptions_ProdColorPattern()
                                                        -- с таким Boat Structure
                                                        AND OL_ProdColorPattern.ChildObjectId = (SELECT OL_find.ChildObjectId FROM ObjectLink AS OL_find WHERE OL_find.ObjectId = ioProdOptionsId AND OL_find.DescId = zc_ObjectLink_ProdOptions_ProdColorPattern())
                                    WHERE OL.ChildObjectId = inMaterialOptionsId AND OL.DescId = zc_ObjectLink_ProdOptions_MaterialOptions()
                                   ), 0);
       -- Проверка
       IF COALESCE (vbProdOptionsId, 0) = 0
       THEN
           RAISE EXCEPTION 'Ошибка.Для опции <%> не существует Категории <%>.'
                          , lfGet_Object_ValueData_sh (ioProdOptionsId)
                          , lfGet_Object_ValueData_sh (inMaterialOptionsId)
                           ;
       ELSE 
           -- !!!Замена
           ioProdOptionsId:= vbProdOptionsId;

       END IF;

   END IF;



   -- Проверка/Поиск
   IF COALESCE (inProdOptPatternId, 0) = 0
   THEN
       -- найдем "свободный"
       inProdOptPatternId:= (SELECT MIN (Object.Id) FROM Object WHERE Object.DescId = zc_Object_ProdOptPattern() AND Object.isErased = FALSE
                             AND Object.Id NOT IN (-- если нет среди существующих
                                                   SELECT ObjectLink_ProdOptPattern.ChildObjectId
                                                   FROM Object AS Object_ProdOptItems
                                                        INNER JOIN ObjectLink AS ObjectLink_Product
                                                                             ON ObjectLink_Product.ObjectId      = Object_ProdOptItems.Id
                                                                            AND ObjectLink_Product.DescId        = zc_ObjectLink_ProdOptItems_Product()
                                                                            -- для єтой лодки
                                                                            AND ObjectLink_Product.ChildObjectId = inProductId

                                                        INNER JOIN ObjectLink AS ObjectLink_ProdOptPattern
                                                                              ON ObjectLink_ProdOptPattern.ObjectId = Object_ProdOptItems.Id
                                                                             AND ObjectLink_ProdOptPattern.DescId   = zc_ObjectLink_ProdOptItems_ProdOptPattern()
                                                   WHERE Object_ProdOptItems.DescId = zc_Object_ProdOptItems()
                                                     AND Object_ProdOptItems.isErased = FALSE
                                                  ));
     --RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.Элемент не установлен.'
     --                                      , inProcedureName := 'gpInsertUpdate_Object_ProdOptItems'
     --                                      , inUserId        := vbUserId
     --                                       );
   END IF;


   -- если эта опция из Boat Structure или есть inProdColorPatternId
 --IF EXISTS (SELECT 1 FROM ObjectLink WHERE ObjectLink.DescId = zc_ObjectLink_ProdColorPattern_ProdOptions() AND ObjectLink.ChildObjectId = ioProdOptionsId)
   IF EXISTS (SELECT 1 FROM ObjectLink WHERE ObjectLink.DescId = zc_ObjectLink_ProdOptions_ProdColorPattern() AND ObjectLink.ObjectId = ioProdOptionsId)
      OR inProdColorPatternId > 0
   THEN
        -- Проверка inProdColorPatternId - заполнен
        IF COALESCE (inProdColorPatternId, 0) = 0
        THEN
            RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.inProdColorPatternId не установлен.'
                                                  , inProcedureName := 'gpInsertUpdate_Object_ProdOptItems'
                                                  , inUserId        := vbUserId
                                                   );
        END IF;
        -- Проверка ioProdOptionsId - из Boat Structure
        IF NOT EXISTS (SELECT 1 FROM ObjectLink AS OL WHERE OL.DescId = zc_ObjectLink_ProdOptions_ProdColorPattern() AND OL.ObjectId = ioProdOptionsId AND OL.ChildObjectId = inProdColorPatternId)
        THEN
            RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.Не найден ioProdOptionsId + inProdColorPatternId.'
                                                  , inProcedureName := 'gpInsertUpdate_Object_ProdOptItems'
                                                  , inUserId        := vbUserId
                                                   );
        END IF;

        -- сохраняем в Items Boat Structure
        PERFORM gpInsertUpdate_Object_ProdColorItems(ioId                     := tmp.Id
                                                   , inCode                   := tmp.Code
                                                   , inProductId              := inProductId
                                                   , inGoodsId                := ioGoodsId
                                                   , inProdColorPatternId     := tmp.ProdColorPatternId
                                                   , inMaterialOptionsId      := inMaterialOptionsId
                                                   , inMovementId_OrderClient := inMovementId_OrderClient
                                                   , inComment                := inComment
                                                   , inIsEnabled              := TRUE :: Boolean
                                                   , ioIsProdOptions          := CASE WHEN tmp.GoodsId_Receipt <> ioGoodsId THEN TRUE ELSE FALSE END
                                                   , inSession                := inSession
                                                    )
                                                   
        FROM gpSelect_Object_ProdColorItems (COALESCE (inMovementId_OrderClient,0),FALSE,FALSE,FALSE, inSession) as tmp
        WHERE tmp.ProductId = inProductId
          AND tmp.ProdColorPatternId = inProdColorPatternId
        ;
   
        -- !!! ВЫХОД !!!
        -- RETURN;
        
    END IF;


   -- определяем признак Создание/Корректировка
   vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- Если код не установлен, определяем его как последний+1, для каждой лодки начиная с 1
   IF COALESCE (ioId,0) = 0 AND inCode = 0
   THEN
       vbCode_calc:= COALESCE ((SELECT MAX (Object_ProdOptItems.ObjectCode) AS ObjectCode
                                FROM Object AS Object_ProdOptItems
                                     INNER JOIN ObjectLink AS ObjectLink_Product
                                                           ON ObjectLink_Product.ObjectId = Object_ProdOptItems.Id
                                                          AND ObjectLink_Product.DescId = zc_ObjectLink_ProdOptItems_Product()
                                                          AND ObjectLink_Product.ChildObjectId = inProductId AND COALESCE (inProductId,0) <> 0
                                WHERE Object_ProdOptItems.DescId = zc_Object_ProdOptItems())
                               , 0) + 1;
   ELSE
        vbCode_calc:= inCode;
   END IF;

   -- проверка прав уникальности для свойства <Наименование >
   --PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_ProdOptItems(), inName, vbUserId);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_ProdOptItems(), vbCode_calc, '');

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_ProdOptItems_PartNumber(), ioId, inPartNumber);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_ProdOptItems_Comment(), ioId, inComment);

   -- сохранили свойство <Кол опций>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ProdOptItems_Count(), ioId, inAmount);

   -- сохранили свойство <PriceIn> - временно убрал, может потом понадобится
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ProdOptItems_PriceIn(), ioId, 0);
   -- сохранили свойство <PriceOut> - временно убрал, может потом понадобится
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ProdOptItems_PriceOut(), ioId, inPriceOut);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ProdOptItems_DiscountTax(), ioId, inDiscountTax);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ProdOptItems_Product(), ioId, inProductId);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ProdOptItems_ProdOptions(), ioId, ioProdOptionsId);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ProdOptItems_ProdOptPattern(), ioId, inProdOptPatternId);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ProdOptItems_Goods(), ioId, ioGoodsId);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ProdOptItems_OrderClient(), ioId, inMovementId_OrderClient);


   IF vbIsInsert = TRUE THEN
      -- сохранили свойство <Дата создания>
      PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), ioId, CURRENT_TIMESTAMP);
      -- сохранили свойство <Пользователь (создание)>
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), ioId, vbUserId);
   END IF;

   outGoodsName := (SELECT Object.ValueData FROM Object WHERE Object.Id = ioGoodsId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);


   -- пересохраняем - элемент  - Заказ Клиента
   vbMI_Id:= (WITH gpSelect AS (SELECT gpSelect.Basis_summ, gpSelect.Basis_summ_orig, gpSelect.Basis_summ1_orig
                                FROM gpSelect_Object_Product (FALSE, FALSE, vbUserId :: TVarChar) AS gpSelect
                                WHERE gpSelect.MovementId_OrderClient = inMovementId_OrderClient
                               )
              -- Результат
              SELECT tmp.ioId
              FROM lpInsertUpdate_MovementItem_OrderClient (ioId            := vbMI_Id
                                                          , inMovementId    := inMovementId_OrderClient
                                                          , inGoodsId       := inProductId
                                                          , inAmount        := (SELECT MovementItem.Amount FROM MovementItem WHERE MovementItem.Id = vbMI_Id)
                                                            -- ИТОГО Сумма продажи без НДС - со ВСЕМИ Скидками (Basis+options)
                                                          , ioOperPrice     := (SELECT gpSelect.Basis_summ       FROM gpSelect)
                                                            -- ИТОГО Сумма продажи без НДС - без Скидки (Basis+options)
                                                          , inOperPriceList := (SELECT gpSelect.Basis_summ_orig  FROM gpSelect)
                                                            -- ИТОГО Сумма продажи без НДС - без Скидки (Basis)
                                                          , inBasisPrice    := (SELECT gpSelect.Basis_summ1_orig FROM gpSelect)
                                                            -- 
                                                          , inCountForPrice := 1  ::TFloat
                                                          , inComment       := '' ::TVarChar
                                                          , inUserId        := vbUserId
                                                           ) AS tmp
             );


   -- Проверка - нельзя дублировать опции
   IF EXISTS (SELECT 1
              FROM ObjectLink AS OL
                   -- Не удален
                   JOIN Object AS Object_ProdOptItems ON Object_ProdOptItems.Id       = OL.ObjectId
                                                     AND Object_ProdOptItems.isErased = FALSE
                   -- Опция
                   JOIN ObjectLink AS OL_ProdOptions
                                   ON OL_ProdOptions.ObjectId      = OL.ObjectId
                                  AND OL_ProdOptions.DescId        = zc_ObjectLink_ProdOptItems_ProdOptions()
                                  AND OL_ProdOptions.ChildObjectId = ioProdOptionsId
              WHERE OL.ChildObjectId = inProductId AND OL.DescId = zc_ObjectLink_ProdOptItems_Product()
                AND OL.ObjectId <> COALESCE (ioId, 0)
             )
   THEN
       RAISE EXCEPTION 'Ошибка.Дублирование опции <%> запрещено.'
                      , lfGet_Object_ValueData_sh (ioProdOptionsId)
                       ;
   END IF;

   -- сохранили протокол
   PERFORM lpInsert_MovementItemProtocol (vbMI_Id, vbUserId, FALSE);
   -- пересчитали Итоговые суммы - Заказ Клиента
   PERFORM lpInsertUpdate_MovementFloat_TotalSumm_order (inMovementId_OrderClient);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.04.21         * inAmount
 04.01.21         * inDiscountTax
 09.10.20         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_ProdOptItems()
