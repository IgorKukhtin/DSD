-- Function: gpInsertUpdate_MovementItem_ContractGoods()

--DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ContractGoods (Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ContractGoods (Integer, Integer, Integer, Integer, Boolean, Boolean, TFloat, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ContractGoods (Integer, Integer, Integer, Integer, Boolean, Boolean, TFloat, TFloat, TFloat, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ContractGoods (Integer, Integer, Integer, Integer, Boolean, Boolean, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ContractGoods (Integer, Integer, Integer, Integer, Boolean, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_ContractGoods(
 INOUT ioId                     Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId             Integer   , -- Ключ объекта <Документ Возврат покупателя>
    IN inGoodsId                Integer   , -- Товары
    IN inGoodsKindId            Integer   , -- Виды товаров
    IN inisBonusNo              Boolean   , -- нет начисления по бонусам
    IN inisSave                 Boolean   , -- cохранить да/нет
    IN inPrice                  TFloat    , --
    IN inChangePrice            TFloat    , -- Скидка в цене
    IN inChangePercent          TFloat    , -- % Скидки 
    IN inCountForAmount         TFloat    , -- Коэфф перевода из кол-ва поставщика
    IN inCountForPrice          TFloat    , -- Цена за количество
    IN inComment                TVarChar  , -- 
    IN inSession                TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId          Integer;
   DECLARE vbContractId      Integer;
   DECLARE vbPriceListId     Integer;
   DECLARE vbOperDate        TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ContractGoods());
 
     --проверка если был сохранен а теперь сняли галку то удаляем, если и не был то пропускаем
     IF COALESCE (inisSave,FALSE) = FALSE
     THEN
         IF COALESCE (ioId,0) = 0 
         THEN 
             RETURN; 
         ELSE
             PERFORM lpSetErased_MovementItem (inMovementItemId:= ioId, inUserId:= vbUserId);
             RETURN;
         END IF;
     END IF;

     --проверка если хотят удаленному поставить Сохранить Да то снимаем удаление
     IF EXISTS (SELECT 1 FROM MovementItem WHERE MovementItem.Id = ioId AND MovementItem.isErased = TRUE) AND  COALESCE (inisSave,FALSE) = TRUE
     THEN
         PERFORM lpSetUnErased_MovementItem (inMovementItemId:= ioId, inUserId:= vbUserId);
     END IF;

      --проверка должно біть внесено только 1 значение    или inChangePrice или inChangePercent
     IF COALESCE (inChangePrice,0) <> 0 AND COALESCE (inChangePercent,0) <> 0
     THEN
          RAISE EXCEPTION 'Ошибка.Можно установить только 1 параметр - Процент скидки или Скидка в цене.';
     END IF;

     -- если цена 0 пробуем найти
     IF COALESCE (inPrice,0) = 0
     THEN
         -- Данные документа
         SELECT Movement.OperDate
              , COALESCE (MovementLinkObject_Contract.ObjectId, 0) AS ContractId
                INTO vbOperDate, vbContractId
         FROM Movement
              LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                           ON MovementLinkObject_Contract.MovementId = Movement.Id
                                          AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
         WHERE Movement.Id = inMovementId
           AND Movement.DescId = zc_Movement_ContractGoods();

         vbPriceListId := (SELECT ObjectLink_ContractPriceList_PriceList.ChildObjectId AS PriceListId
                           FROM (SELECT vbContractId AS ContractId) AS tmp
                            
                                 INNER JOIN ObjectLink AS ObjectLink_ContractPriceList_Contract
                                                       ON ObjectLink_ContractPriceList_Contract.ChildObjectId = tmp.ContractId
                                                      AND ObjectLink_ContractPriceList_Contract.DescId = zc_ObjectLink_ContractPriceList_Contract()
                       
                                 INNER JOIN Object AS Object_ContractPriceList
                                                   ON Object_ContractPriceList.Id = ObjectLink_ContractPriceList_Contract.ObjectId
                                                  AND Object_ContractPriceList.DescId = zc_Object_ContractPriceList()
                                                  AND Object_ContractPriceList.isErased = FALSE

                                 INNER JOIN ObjectDate AS ObjectDate_StartDate
                                                       ON ObjectDate_StartDate.ObjectId = ObjectLink_ContractPriceList_Contract.ObjectId
                                                      AND ObjectDate_StartDate.DescId = zc_ObjectDate_ContractPriceList_StartDate()
                                                      AND ObjectDate_StartDate.ValueData <= vbOperDate
                                 INNER JOIN ObjectDate AS ObjectDate_EndDate
                                                       ON ObjectDate_EndDate.ObjectId = ObjectLink_ContractPriceList_Contract.ObjectId
                                                      AND ObjectDate_EndDate.DescId = zc_ObjectDate_ContractPriceList_EndDate()
                                                      AND ObjectDate_EndDate.ValueData >= vbOperDate

                                 LEFT JOIN ObjectLink AS ObjectLink_ContractPriceList_PriceList
                                                      ON ObjectLink_ContractPriceList_PriceList.ObjectId = ObjectLink_ContractPriceList_Contract.ObjectId
                                                     AND ObjectLink_ContractPriceList_PriceList.DescId = zc_ObjectLink_ContractPriceList_PriceList()
                       );
         
         inPrice := COALESCE ( (SELECT lfSelect.ValuePrice  AS Price_PriceList
                                FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= vbPriceListId, inOperDate:= vbOperDate) AS lfSelect
                                WHERE lfSelect.GoodsId = inGoodsId AND COALESCE(lfSelect.GoodsKindId,0) = COALESCE (inGoodsKindId,0) LIMIT 1)
                             , (SELECT lfSelect.ValuePrice  AS Price_PriceList
                                FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= vbPriceListId, inOperDate:= vbOperDate) AS lfSelect
                                WHERE lfSelect.GoodsId = inGoodsId LIMIT 1)
                             ,0 )::TFloat;

     END IF;

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem_ContractGoods (ioId            := ioId
                                                      , inMovementId    := inMovementId
                                                      , inGoodsId       := inGoodsId
                                                      , inGoodsKindId   := inGoodsKindId
                                                      , inisBonusNo     := inisBonusNo
                                                      , inPrice         := inPrice
                                                      , inChangePrice   := inChangePrice
                                                      , inChangePercent := inChangePercent
                                                      , inCountForAmount:= inCountForAmount
                                                      , inCountForPrice := inCountForPrice
                                                      , inComment       := inComment
                                                      , inUserId        := vbUserId
                                                       ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.11.24         *
 08.11.23         *
 28.07.22         *
 05.07.21         *
*/

-- тест
--