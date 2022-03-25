-- Function: gpInsertUpdate_MovementItem_IncomeAsset()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_IncomeAsset (Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_IncomeAsset (Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_IncomeAsset (Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_IncomeAsset(
 INOUT ioId                    Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inGoodsId               Integer   , -- Товары
    IN inUnitId                Integer   , -- Подразделение
    IN inAssetId               Integer   , -- Для ОС
    IN inMIId_Invoice          Integer   , -- элемент документа Cчет
 INOUT ioAmount                TFloat    , -- Количество
    IN inPrice                 TFloat    , -- Цена
 INOUT ioCountForPrice         TFloat    , -- Цена за количество
   OUT outAmountSumm           TFloat    , -- Сумма расчетная
 INOUT ioInvNumber_Asset       TVarChar  , -- 
 INOUT ioInvNumber_Asset_save  TVarChar  , -- 
   OUT outCurrencyDocumentId   Integer   ,
   OUT outCurrencyDocumentName TVarChar  ,
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCurrencyId Integer;              --валюта тек.документа
   DECLARE vbCurrencyId_Invoice Integer;      --валюта счета
   DECLARE vbMovementId_Invoice Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_IncomeAsset());
     vbUserId:= lpGetUserBySession (inSession);


     --определяем валюту по Счету, если выбраны счета с разной валютой , тогда ошибка
     --валюта из шапки док.
     vbCurrencyId := (SELECT MovementLinkObject_CurrencyDocument.ObjectId
                      FROM MovementLinkObject AS MovementLinkObject_CurrencyDocument
                      WHERE MovementLinkObject_CurrencyDocument.MovementId = inMovementId
                        AND MovementLinkObject_CurrencyDocument.DescId = zc_MovementLinkObject_CurrencyDocument()
                      );
     --валюта из док. счет
     vbCurrencyId_Invoice := (SELECT MovementLinkObject_CurrencyDocument.ObjectId
                              FROM MovementLinkObject AS MovementLinkObject_CurrencyDocument
                              WHERE MovementLinkObject_CurrencyDocument.MovementId = (SELECT MovementItem.MovementId
                                                                                      FROM MovementItem
                                                                                      WHERE MovementItem.Id = inMIId_Invoice 
                                                                                        AND MovementItem.DescId = zc_MI_Master()
                                                                                      )
                                AND MovementLinkObject_CurrencyDocument.DescId = zc_MovementLinkObject_CurrencyDocument()
                              );

     --если выбраны счета с разной валютой , тогда ошибка
     IF COALESCE (vbCurrencyId,0) <> 0 AND COALESCE (vbCurrencyId_Invoice,0) <> COALESCE (vbCurrencyId,0)
     THEN
         RAISE EXCEPTION 'Ошибка.Валюта выбранного счета не совпадает с валютой текущего документа.';
     END IF;
 
     --возвращаем в шапку валюту док. из счета
     outCurrencyDocumentId := vbCurrencyId_Invoice;
     outCurrencyDocumentName := lfGet_Object_ValueData_sh (outCurrencyDocumentId);

     --сохраняем валюту в шаке док.
     /*IF COALESCE (vbCurrencyId,0) = 0 OR (SELECT COUNT (*)
                                          FROM MovementItem
                                          WHERE MovementItem.MovementId = inMovementId
                                            AND MovementItem.DescId = zc_MI_Master()
                                            AND MovementItem.isErased = FALSE
                                          ) = 1
     THEN
          -- сохранили связь с <Валюта (документа)>
          PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_CurrencyDocument(), inMovementId, outCurrencyDocumentId);
     END IF;
     */
     --


     -- Заменили свойство <Цена за количество>
     IF COALESCE (ioCountForPrice, 0) = 0 THEN ioCountForPrice := 1; END IF;

     -- сохранили
     ioId:= lpInsertUpdate_MovementItem_IncomeAsset (ioId                 := ioId
                                                   , inMovementId         := inMovementId
                                                   , inGoodsId            := inGoodsId
                                                   , inUnitId             := inUnitId
                                                   , inAssetId            := inAssetId
                                                   , inMIId_Invoice       := inMIId_Invoice
                                                   , inAmount             := ioAmount
                                                   , inPrice              := inPrice
                                                   , inCountForPrice      := ioCountForPrice
                                                   , inUserId             := vbUserId
                                                    );


     -- сохранили свойство справочника <Основные средства>
     IF ioInvNumber_Asset <> ioInvNumber_Asset_save AND EXISTS (SELECT 1 FROM Object WHERE Object.Id = inGoodsId AND Object.DescId = zc_Object_Asset())
     THEN
         -- проверка уникальности для свойства <Инвентарный номер> 
         PERFORM lpCheckUnique_ObjectString_ValueData (inGoodsId, zc_ObjectString_Asset_InvNumber(), ioInvNumber_Asset);
         -- сохранили
         PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Asset_InvNumber(), inGoodsId, ioInvNumber_Asset);
         -- сохранили протокол
         PERFORM lpInsert_ObjectProtocol (inGoodsId, vbUserId);
     ELSEIF NOT EXISTS (SELECT 1 FROM Object WHERE Object.Id = inGoodsId AND Object.DescId = zc_Object_Asset())
     THEN
         ioInvNumber_Asset:= '';
     END IF;
     -- синхронизируем
     ioInvNumber_Asset_save:= ioInvNumber_Asset;


     -- расчитали сумму по элементу, для грида
     outAmountSumm := CASE WHEN ioCountForPrice > 0
                                THEN CAST (ioAmount * inPrice / ioCountForPrice AS NUMERIC (16, 2))
                           ELSE CAST (ioAmount * inPrice AS NUMERIC (16, 2))
                      END;



END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.03.22         *
 27.08.16         * add AssetId
 06.08.16         *
 29.07.16         *
*/

-- тест
-- 