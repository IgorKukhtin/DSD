-- Function: gpInsert_MovementItem_RepriceSite()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_RepriceSite (Integer, Integer, Integer, Integer, TDateTime, TDateTime, TFloat, TFloat, TFloat, TFloat, Boolean, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_RepriceSite(
 INOUT ioId                  Integer   , -- Ключ записи
    IN inGoodsId             Integer   , -- Товары
    IN inJuridicalId         Integer   , -- поставщик
    IN inContractId          Integer   , -- Договор
    IN inExpirationDate      TDateTime , -- Срок годности
    IN inMinExpirationDate   TDateTime , -- Срок годности остатка
    IN inAmount              TFloat    , -- Количество (Остаток)

    IN inPriceOld            TFloat    , -- Цена старая
    IN inPriceNew            TFloat    , -- Цена новая
    IN inJuridical_Price     TFloat    , -- Цена поставщика
    IN inisPromoBonus        Boolean   , -- По маркетинговому бонусу  
    IN inGUID                TVarChar  , -- GUID для определения текущей переоценки
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbOperDate_StartBegin TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;

    -- !!!Протокол - отладка Скорости!!!
    vbOperDate_StartBegin:= CLOCK_TIMESTAMP();


    -- найти документ
    vbMovementId:= (WITH tmpMS_GUID AS (SELECT MS_GUID.MovementId
                                        FROM MovementString AS MS_GUID
                                        WHERE MS_GUID.ValueData = inGUID
                                          AND MS_GUID.DescId    = zc_MovementString_Comment())
                      ,  tmpMLO_Unit AS (SELECT MLO_Unit.MovementId
                                         FROM MovementLinkObject AS MLO_Unit
                                         WHERE MLO_Unit.MovementId IN (SELECT DISTINCT tmpMS_GUID.MovementId FROM tmpMS_GUID)
                                           AND MLO_Unit.DescId     = zc_MovementLinkObject_Unit()
                                           AND MLO_Unit.ObjectId   = inUnitId
                                        )
                      ,  tmpMovement AS (SELECT Movement.Id, Movement.OperDate, Movement.DescId
                                         FROM Movement
                                         WHERE Movement.Id IN (SELECT DISTINCT tmpMLO_Unit.MovementId FROM tmpMLO_Unit)
                                        )
                    -- Результат
                    SELECT Movement.Id AS MovementId
                    FROM tmpMovement AS Movement
                    WHERE Movement.OperDate = CURRENT_DATE
                      AND Movement.DescId   = zc_Movement_RepriceSite()
                   );


    IF COALESCE (vbMovementId, 0) = 0
    THEN
        --
        vbMovementId := lpInsertUpdate_Movement_RepriceSite(ioId        := COALESCE (vbMovementId,0),
                                                        inInvNumber := CAST (NEXTVAL('movement_RepriceSite_seq') AS TVarChar),
                                                        inOperDate  := CURRENT_DATE::TDateTime,
                                                        inGUID      := inGUID,
                                                        inUserId    := vbUserId);

    END IF;

    -- переоценить товар
    PERFORM lpInsertUpdate_Object_PriceSite(inGoodsId := inGoodsId,
                                            inPrice   := inPriceNew,
                                            inDate    := CURRENT_DATE::TDateTime,
                                            inUserId  := vbUserId);

    -- сохранить запись
    ioId := lpInsertUpdate_MovementItem_RepriceSite (ioId                 := COALESCE(ioId,0)
                                                   , inMovementId         := vbMovementId
                                                   , inGoodsId            := inGoodsId
                                                   , inJuridicalId        := inJuridicalId
                                                   , inContractId         := inContractId
                                                   , inExpirationDate  := inExpirationDate
                                                   , inMinExpirationDate  := inMinExpirationDate
                                                   , inAmount             := inAmount
                                                   , inPriceOld           := inPriceOld
                                                   , inPriceNew           := inPriceNew
                                                   , inJuridical_Price    := inJuridical_Price
                                                   , inUserId             := vbUserId);

    -- сохранили <По маркетинговому бонусу >
    IF COALESCE (inisPromoBonus, False) = TRUE
    THEN
      PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PromoBonus(), ioId, inisPromoBonus);
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 10.06.21                                                      *  
*/
-- SELECT COUNT(*) FROM Log_RepriceSite
-- SELECT * FROM Log_RepriceSite WHERE TextValue NOT LIKE '%InsertUpdate%' ORDER BY Id DESC LIMIT 100
-- SELECT * FROM Log_RepriceSite ORDER BY Id DESC LIMIT 100