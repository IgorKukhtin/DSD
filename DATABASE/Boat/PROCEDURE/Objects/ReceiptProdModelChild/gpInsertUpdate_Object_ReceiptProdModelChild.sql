-- Function: gpInsertUpdate_Object_ReceiptProdModelChild()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptProdModelChild (Integer, TVarChar, Integer, Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptProdModelChild (Integer, TVarChar, Integer, Integer, Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptProdModelChild (Integer, TVarChar, Integer, Integer, Integer, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptProdModelChild (Integer, TVarChar, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ReceiptProdModelChild(
 INOUT ioId                  Integer   ,    -- ключ объекта <>
    IN inComment             TVarChar  ,    -- Название объекта
    IN inReceiptProdModelId  Integer   ,
    IN inObjectId            Integer   ,
    IN inReceiptLevelId_top  Integer   ,
    IN inReceiptLevelId      Integer   ,
 INOUT ioValue               TFloat    , 
 INOUT ioValue_service       TFloat    , 
   OUT outEKPrice_summ       TFloat    ,
   OUT outEKPriceWVAT_summ   TFloat    ,
--   OUT outBasis_summ         TFloat    ,
--   OUT outBasisWVAT_summ     TFloat    ,
   OUT outReceiptLevelName   TVarChar  ,
    IN inSession             TVarChar       -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbPriceWithVAT Boolean;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_ReceiptProdModelChild());
   vbUserId:= lpGetUserBySession (inSession);


   -- замена
   IF ioValue = 0 AND EXISTS (SELECT FROM Object WHERE Object.Id = inObjectId AND Object.DescId =  zc_Object_ReceiptService())
   THEN
       ioValue:= ioValue_service;
   ELSE
       -- замена
       IF ioValue = 0 THEN ioValue:= 1; END IF;
       --
       ioValue_service:= 0;
   END IF;


   -- Проверка
   IF COALESCE (inReceiptProdModelId, 0) = 0
   THEN
       RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.ReceiptProdModelId не установлен.'
                                             , inProcedureName := 'gpInsertUpdate_Object_ReceiptProdModelChild'
                                             , inUserId        := vbUserId
                                              );
   END IF;
   -- Проверка
 /*  IF COALESCE (inObjectId, 0) = 0
   THEN
       RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.Элемент не установлен.'
                                             , inProcedureName := 'gpInsertUpdate_Object_ReceiptProdModelChild'
                                             , inUserId        := vbUserId
                                              );
   END IF;
*/
   -- переопределяем
   IF COALESCE (inReceiptLevelId, 0) = 0
   THEN
       inReceiptLevelId := inReceiptLevelId_top;
   END IF;

   -- определяем признак Создание/Корректировка
   vbIsInsert:= COALESCE (ioId, 0) = 0;

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_ReceiptProdModelChild(), 0, inComment);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_ReceiptProdModelChild_Value(), ioId, ioValue);
      
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReceiptProdModelChild_ReceiptProdModel(), ioId, inReceiptProdModelId);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReceiptProdModelChild_Object(), ioId, inObjectId);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReceiptProdModelChild_ReceiptLevel(), ioId, inReceiptLevelId);
   
   
   IF vbIsInsert = TRUE THEN
      -- сохранили свойство <Дата создания>
      PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), ioId, CURRENT_TIMESTAMP);
      -- сохранили свойство <Пользователь (создание)>
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), ioId, vbUserId);
   ELSE
      -- сохранили свойство <Дата корр>
      PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Update(), ioId, CURRENT_TIMESTAMP);
      -- сохранили свойство <Пользователь (корр)>
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Update(), ioId, vbUserId);
   END IF;


   -- замена
   IF EXISTS (SELECT 1 FROM Object WHERE Object.Id = inObjectId AND Object.DescId =  zc_Object_ReceiptService())
   THEN
       ioValue_service:= ioValue;
       ioValue:= 0;
   END IF;


   -- Определили
   vbPriceWithVAT:= (SELECT ObjectBoolean.ValueData FROM ObjectBoolean WHERE ObjectBoolean.ObjectId = zc_PriceList_Basis() AND ObjectBoolean.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT());

   -- если выбран товар получаем цены и возвращаем суммы
   SELECT (ioValue * ObjectFloat_EKPrice.ValueData) :: TFloat AS EKPrice_summ
        , (ioValue
             * CAST (COALESCE (ObjectFloat_EKPrice.ValueData, 0)
                    * (1 + (COALESCE (ObjectFloat_TaxKind_Value.ValueData, 0) / 100)) AS NUMERIC (16, 2))) :: TFloat AS EKPriceWVAT_summ
                    
       /* , (ioValue
            * CASE WHEN vbPriceWithVAT = FALSE
                   THEN COALESCE (tmpPriceBasis.ValuePrice, 0)
                   ELSE CAST (COALESCE (tmpPriceBasis.ValuePrice, 0) * ( 1 - COALESCE (ObjectFloat_TaxKind_Value.ValueData,0) / 100)  AS NUMERIC (16, 2))
              END)  :: TFloat AS Basis_summ

        , (ioValue
            * CASE WHEN vbPriceWithVAT = FALSE
                    THEN CAST ( COALESCE (tmpPriceBasis.ValuePrice, 0) * ( 1 + COALESCE (ObjectFloat_TaxKind_Value.ValueData,0) / 100)  AS NUMERIC (16, 2))
                    ELSE COALESCE (tmpPriceBasis.ValuePrice, 0) 
               END) ::TFloat BasisWVAT_summ
               */
 INTO outEKPrice_summ, outEKPriceWVAT_summ     --, outBasis_summ, outBasisWVAT_summ
   FROM Object
        LEFT JOIN ObjectLink AS ObjectLink_Goods
                             ON ObjectLink_Goods.ObjectId = Object.Id
                            AND ObjectLink_Goods.DescId = zc_ObjectLink_ProdColorPattern_Goods()

        LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice
                              ON ObjectFloat_EKPrice.ObjectId = COALESCE (ObjectLink_Goods.ChildObjectId, Object.Id)
                             AND ObjectFloat_EKPrice.DescId = zc_ObjectFloat_Goods_EKPrice()

        LEFT JOIN ObjectLink AS ObjectLink_Goods_TaxKind
                             ON ObjectLink_Goods_TaxKind.ObjectId = COALESCE (ObjectLink_Goods.ChildObjectId, Object.Id)
                            AND ObjectLink_Goods_TaxKind.DescId = zc_ObjectLink_Goods_TaxKind()
        LEFT JOIN Object AS Object_TaxKind ON Object_TaxKind.Id = ObjectLink_Goods_TaxKind.ChildObjectId

        LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                              ON ObjectFloat_TaxKind_Value.ObjectId = Object_TaxKind.Id
                             AND ObjectFloat_TaxKind_Value.DescId = zc_ObjectFloat_TaxKind_Value()

        LEFT JOIN (SELECT tmp.GoodsId
                        , tmp.ValuePrice
                   FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= zc_PriceList_Basis()
                                                            , inOperDate   := CURRENT_DATE) AS tmp
                  ) AS tmpPriceBasis ON tmpPriceBasis.GoodsId = COALESCE (ObjectLink_Goods.ChildObjectId, Object.Id)
   WHERE Object.Id = inObjectId;


   outReceiptLevelName :=  (SELECT Object.ValueData FROM Object WHERE Object.Id = inReceiptLevelId); 

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.12.20         * ReceiptLevel
 01.12.20         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_ReceiptProdModelChild()
