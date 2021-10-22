   -- Function: gpUpdate_MovementIten_Check_PriceSale()

DROP FUNCTION IF EXISTS gpUpdate_MovementIten_Check_PriceSale (Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementIten_Check_PriceSale(
    IN inMovementId          Integer   , -- Ключ объекта <строка документа>
    IN inMovementItemID      Integer   , -- Ключ объекта <Документ>
    IN inPriceSale           TFloat    , -- Цена отпускная без скидки
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbPrice TFloat;
   DECLARE vbPriceSale TFloat;
   DECLARE vbChangePercent TFloat;
   DECLARE vbAmount TFloat;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
    vbUserId := lpGetUserBySession (inSession);

    IF inSession::Integer NOT IN (3, 375661, 235009, 4183126, 8001630, 9560329, 8051421, 14080152 )
    THEN
      RAISE EXCEPTION 'Изменение <Цены> вам запрещено.';
    END IF;

    SELECT
      StatusId
    INTO
      vbStatusId
    FROM Movement
    WHERE Id = inMovementId;

    IF COALESCE(inMovementId,0) = 0
    THEN
        RAISE EXCEPTION 'Документ не записан.';
    END IF;

    IF vbStatusId <> zc_Enum_Status_UnComplete()
    THEN
        RAISE EXCEPTION 'Ошибка.Изменение Цены в статусе <%> не возможно.', lfGet_Object_ValueData (vbStatusId);
    END IF;

    -- Провкряем элемент по документу
    IF COALESCE (inMovementItemID, 0) = 0
       OR NOT EXISTS (SELECT 1 FROM MovementItem WHERE Id = inMovementItemID)
    THEN
        RAISE EXCEPTION 'Не найден элемент по документe';
    END IF;

    -- Находим элемент по документу и товару
    IF COALESCE (inMovementId, 0) = 0
       OR NOT EXISTS (SELECT 1 FROM MovementItem WHERE Id = inMovementItemID)
    THEN
        RAISE EXCEPTION 'Не задан документ или неправельная связь';
    END IF;

    SELECT MovementItem.Amount, MIFloat_Price.ValueData AS Price, MIFloat_PriceSale.ValueData AS PriceSale, MIFloat_ChangePercent.ValueData AS ChangePercent
    INTO vbAmount, vbPrice, vbPriceSale, vbChangePercent
    FROM MovementItem

         LEFT JOIN MovementItemFloat AS MIFloat_Price
                                     ON MIFloat_Price.MovementItemID = MovementItem.ID
                                    AND MIFloat_Price.DescId = zc_MIFloat_Price()

         LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                     ON MIFloat_PriceSale.MovementItemID = MovementItem.ID
                                    AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()

         LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                     ON MIFloat_ChangePercent.MovementItemID = MovementItem.ID
                                    AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()

    WHERE MovementItem.ID = inMovementItemID;


    -- сохранили свойство <Цена>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceSale(), inMovementItemID, inPriceSale);

    -- сохранили свойство <% Скидки>
    IF vbChangePercent NOT IN (50, 100)
    THEN
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ChangePercent(), inMovementItemID, 0);
    END IF;

    -- сохранили свойство <>
    IF COALESCE(vbPrice, 0) = COALESCE(inPriceSale, 0)
    THEN
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummChangePercent(), inMovementItemID, 0);
    ELSE
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummChangePercent(), inMovementItemID, CASE WHEN vbAmount = 0 THEN 0.0
          ELSE ROUND(ROUND(vbAmount, 3) * COALESCE(inPriceSale, 0), 2) - ROUND(ROUND(vbAmount, 3) * vbPrice, 2) END);
    END IF;

    -- пересчитали Итоговые суммы
    PERFORM lpInsertUpdate_MovementFloat_TotalSummCheck (inMovementId);

    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (inMovementId, vbUserId, False);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpUpdate_MovementIten_Check_PriceSale (Integer, Integer, TFloat, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 22.12.20                                                       *
*/


-- select * from gpUpdate_MovementIten_Check_PriceSale(inMovementId := 21296096 , inMovementItemID := 394839117 , inPrice := 500 ,  inSession := '3');