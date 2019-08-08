-- Function: lpInsertUpdate_MovementItem_Send()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Send (Integer, Integer, Integer, TFloat, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Send (Integer, Integer, Integer, TFloat, TFloat, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Send (Integer, Integer, Integer, TFloat, TFloat, Integer, Integer);


CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_Send(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inAmountManual        TFloat    , -- Кол-во ручное
    IN inAmountStorage       TFloat    , --
    IN inReasonDifferencesId Integer   , -- Причина разногласия
    IN inUserId              Integer     -- пользователь
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
   DECLARE vbAmount TFloat;
   DECLARE vbReasonDifferencesId Integer;
   DECLARE vbIsSUN       Boolean;
   DECLARE vbUnitId_from Integer;
   DECLARE vbUnitId_to   Integer;
BEGIN
     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- определяются данные из документа
     SELECT MovementLinkObject_From.ObjectId
          , MovementLinkObject_To.ObjectId
          , COALESCE (MovementBoolean_isAuto.ValueData, FALSE) :: Boolean
          , (COALESCE (MovementBoolean_SUN.ValueData, FALSE) = TRUE OR COALESCE (MovementBoolean_DefSUN.ValueData, FALSE) = TRUE) :: Boolean
            INTO vbUnitFromId
               , vbUnitToId 
               , vbIsSUN
     FROM Movement
          INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                        ON MovementLinkObject_From.MovementId = Movement.ID
                                       AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                        ON MovementLinkObject_To.MovementId = Movement.ID
                                       AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN MovementBoolean AS MovementBoolean_SUN
                                    ON MovementBoolean_SUN.MovementId = Movement.Id
                                   AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()
          LEFT JOIN MovementBoolean AS MovementBoolean_DefSUN
                                    ON MovementBoolean_DefSUN.MovementId = Movement.Id
                                   AND MovementBoolean_DefSUN.DescId = zc_MovementBoolean_DefSUN()
     WHERE Movement.Id = inMovementId;

     -- определяются данные из MovementItem
     SELECT MI.Amount 
          , MILinkObject_ReasonDifferences.ObjectId AS ReasonDifferencesId
        INTO vbAmount, vbReasonDifferencesId
     FROM MovementItem AS MI 
          LEFT JOIN MovementItemLinkObject AS MILinkObject_ReasonDifferences
                                           ON MILinkObject_ReasonDifferences.MovementItemId = MI.Id
                                          AND MILinkObject_ReasonDifferences.DescId = zc_MILinkObject_ReasonDifferences()
                                            
     WHERE MI.Id = ioId;


     -- проверка
     IF EXISTS (SELECT MIC.Id FROM MovementItemContainer AS MIC WHERE MIC.Movementid = inMovementId) AND ((inAmount <> vbAmount) OR (inReasonDifferencesId <> vbReasonDifferencesId))
     THEN
          RAISE EXCEPTION 'Ошибка.Документ отложен, корректировка запрещена!';
     END IF;
     
     
     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);

     -- Сохранили <кол-во ручное>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountManual(), ioId, inAmountManual);
     -- Сохранили <кол-во ручное>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountStorage(), ioId, inAmountStorage);
 
     -- Сохранили <причину разногласия>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ReasonDifferences(), ioId, inReasonDifferencesId);
     
     -- Только для IsSUN
     IF vbIsSUN = TRUE
     THEN
         -- Сохранили PriceFrom + Price_To
         PERFORM lpInsertUpdate_MovementItemFloat (CASE WHEN tmpPrice.UnitId = vbUnitId_from THEN zc_MIFloat_PriceFrom()
                                                        WHEN tmpPrice.UnitId = vbUnitId_to   THEN zc_MIFloat_PriceTo()
                                                   END
                                                 , ioId
                                                 , COALESCE (tmpPrice.Price, 0)
                                                  )
         FROM (WITH tmpPrice AS (SELECT ObjectLink_Unit.ChildObjectId                AS UnitId
                                      , ROUND (ObjectFloat_Price_Value.ValueData, 2) AS Price
                                  FROM ObjectLink AS ObjectLink_Goods
                                       INNER JOIN ObjectLink AS ObjectLink_Unit
                                                             ON ObjectLink_Unit.ObjectId = ObjectLink_Goods.ObjectId
                                                            AND ObjectLink_Unit.ChildObjectId IN (vbUnitId_from, vbUnitId_to)
                                                            AND ObjectLink_Unit.DescId = zc_ObjectLink_Price_Unit()
                                       LEFT JOIN ObjectFloat AS ObjectFloat_Price_Value
                                                             ON ObjectFloat_Price_Value.ObjectId = ObjectLink_Goods.ObjectId
                                                            AND ObjectFloat_Price_Value.DescId = zc_ObjectFloat_Price_Value()
                                  WHERE ObjectLink_Goods.ChildObjectId = inGoodsId
                                    AND ObjectLink_Goods.DescId        = zc_ObjectLink_Price_Goods()
                                 )
               SELECT tmpPrice.UnitId, tmpPrice.Price FROM tmpPrice
              ) AS tmpPrice
     END IF;


     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSummSend (inMovementId);
     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 05.02.19         * add inAmountStorage
 28.06.16         *
 29.07.15                                                                       *
 */

-- тест
-- SELECT * FROM lpInsertUpdate_MovementItem_Send (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inSession:= '3')
