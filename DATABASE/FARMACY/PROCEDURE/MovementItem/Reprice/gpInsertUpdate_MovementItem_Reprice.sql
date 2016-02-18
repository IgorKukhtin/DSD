--select * from gpInsertUpdate_MovementItem_Reprice(ioID := 0 , inGoodsId := 7720 , inUnitId := 183292 , inAmount := 4 , inPriceOld := 242.3 , inPriceNew := 112.7 , inGUID := '{B473589E-37CE-4285-8FBA-76A588750F63}' ,  inSession := '3');

-- Function: gpInsert_MovementItem_Reprice()

DROP FUNCTION IF EXISTS gpInsert_MovementItem_Reprice (Integer, Integer, TFloat, TFloat, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsert_MovementItem_Reprice (integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, TVarChar);

DROP FUNCTION IF EXISTS gpInsert_MovementItem_Reprice (integer, Integer, Integer, Integer, TDateTime,TDateTime, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Reprice(
 INOUT ioId                  Integer   , -- Ключ записи
    IN inGoodsId             Integer   , -- Товары
    IN inUnitId              Integer   , -- подразделение
    IN inJuridicalId         Integer   , -- поставщик
    IN inExpirationDate      TDateTime , -- Срок годности 
    IN inMinExpirationDate   TDateTime , -- Срок годности остатка
    IN inAmount              TFloat    , -- Количество (Остаток)
    IN inPriceOld            TFloat    , -- Цена старая
    IN inPriceNew            TFloat    , -- Цена новая
    IN inJuridical_Price     TFloat    , -- Цена поставщика
    IN inGUID                TVarChar  , -- GUID для определения текущей переоценки
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer 
AS 
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;
    -- найти документ
    SELECT
        Movement_Reprice.Id
    INTO
        vbMovementId
    FROM
        Movement_Reprice_View AS Movement_Reprice
    WHERE
        DATE_TRUNC ('DAY', Movement_Reprice.OperDate) = DATE_TRUNC ('DAY', CURRENT_DATE)
        AND
        Movement_Reprice.UnitId = inUnitId
        AND
        Movement_Reprice.GUID = inGUID;
    IF COALESCE(vbMovementId,0) = 0
    THEN
        vbMovementId := lpInsertUpdate_Movement_Reprice(ioId        := COALESCE(vbMovementId,0),
                                                        inInvNumber := CAST(NEXTVAL('movement_sale_seq') AS TVarChar),
                                                        inOperDate  := CURRENT_DATE::TDateTime,
                                                        inUnitId    := inUnitId,
                                                        inGUID      := inGUID,
                                                        inUserId    := vbUserId);
    END IF;
    --переоценить товар
    PERFORM lpInsertUpdate_Object_Price(inGoodsId := inGoodsId,
                                        inUnitId  := inUnitId,
                                        inPrice   := inPriceNew,
                                        inDate    := CURRENT_DATE::TDateTime,
                                        inUserId  := vbUserId);

    -- сохранить запись
    ioId := lpInsertUpdate_MovementItem_Reprice (ioId                 := COALESCE(ioId,0)
                                               , inMovementId         := vbMovementId
                                               , inGoodsId            := inGoodsId
                                               , inJuridicalId        := inJuridicalId
                                               , inExpirationDate  := inExpirationDate
                                               , inMinExpirationDate  := inMinExpirationDate
                                               , inAmount             := inAmount
                                               , inPriceOld           := inPriceOld
                                               , inPriceNew           := inPriceNew
                                               , inUserId             := vbUserId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpInsertUpdate_MovementItem_Reprice (Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, TVarChar) OWNER TO postgres;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.    Воробкало А.А.
 27.11.15                                                                       *
*/