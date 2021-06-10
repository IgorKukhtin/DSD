-- Function: gpUpdate_MovementItem_RepriceSite()

DROP FUNCTION IF EXISTS gpUpdate_MovementItem_RepriceSite(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_RepriceSite(
    IN inMovementItemID Integer,
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbMovementID Integer;
   DECLARE vbGoodsId Integer;
   DECLARE vbPriceNew TFloat;
   DECLARE vbUserId Integer;
   DECLARE vbClippedReprice boolean;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ImportType());

  -- Определяем пользователя
  vbUserId := inSession;

  IF COALESCE (inMovementItemID, 0) = 0
  THEN
    RAISE EXCEPTION 'Ошибка. Документ не сохранен';
  END IF;

  SELECT
     Movement.ID,
     COALESCE(MIBoolean_ClippedReprice.ValueData, False),
     MovementItem.ObjectId,
     MIFloat_PriceSale.ValueData
  INTO
    vbMovementID,
    vbClippedReprice,
    vbGoodsId,
    vbPriceNew
  FROM MovementItem

       INNER JOIN Movement ON Movement.ID = MovementItem.MovementId

       LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                   ON MIFloat_PriceSale.MovementItemId = MovementItem.Id
                                  AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()

       LEFT JOIN MovementItemBoolean AS MIBoolean_ClippedReprice
                                     ON MIBoolean_ClippedReprice.MovementItemId = MovementItem.Id
                                    AND MIBoolean_ClippedReprice.DescId         = zc_MIBoolean_ClippedReprice()

  WHERE MovementItem.ID = inMovementItemID;

  IF COALESCE (vbClippedReprice, FALSE) <> TRUE
  THEN
    RAISE EXCEPTION 'Ошибка. Переоценить можно только отсеченные при переоценке позиции';
  END IF;

  IF EXISTS(SELECT 1 FROM Movement
            WHERE Movement.ID > vbMovementID
              AND Movement.DescId = zc_Movement_RepriceSite())
  THEN
    RAISE EXCEPTION 'Ошибка. Переоценить позиции только в последней переоценке';
  END IF;

    -- переоценить товар
  PERFORM lpInsertUpdate_Object_PriceSite(inGoodsId := vbGoodsId,
                                          inPrice   := vbPriceNew,
                                          inDate    := CURRENT_DATE::TDateTime,
                                          inUserId  := vbUserId);
                                      
    -- сохранили <Признак лог отсечения>
  PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_ClippedReprice(), inMovementItemID, False);

    -- Пересчитали суммы
  PERFORM lpInsertUpdate_MovementFloat_TotalSummRepriceSite(vbMovementID);                                      

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_MovementItem_RepriceSite(Integer, TVarChar) OWNER TO postgres;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 10.06.21                                                       *  
*/

-- тест
-- SELECT * FROM gpUpdate_MovementItem_RepriceSite (8563866, '3')