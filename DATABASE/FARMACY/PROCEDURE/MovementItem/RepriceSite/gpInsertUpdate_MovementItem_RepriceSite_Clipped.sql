-- Function: gpInsertUpdate_MovementItem_RepriceSite_Clipped()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_RepriceSite_Clipped (Integer, Integer, Integer, Integer, TDateTime, TDateTime, TFloat, TFloat, TFloat, TFloat, Boolean, Integer, Integer, TFloat, TDateTime, Boolean, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_RepriceSite_Clipped(
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

    IN inisJuridicalTwo      Boolean   , -- Расчет по 2 поставщикам  
    IN inJuridicalTwoId      Integer   , -- поставщик
    IN inContractTwoId       Integer   , -- Договор
    IN inJuridical_PriceTwo  TFloat    , -- Цена поставщика
    IN inExpirationDateTwo   TDateTime , -- Срок годности

    IN inisPromoBonus        Boolean   , -- По маркетинговому бонусу  
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
    vbMovementId:= (WITH tmpMS_GUID AS (SELECT MS_GUID.MovementId
                                        FROM MovementString AS MS_GUID
                                        WHERE MS_GUID.ValueData = inGUID
                                          AND MS_GUID.DescId    = zc_MovementString_Comment())
                      ,  tmpMovement AS (SELECT Movement.Id, Movement.OperDate, Movement.DescId
                                         FROM Movement
                                         WHERE Movement.Id IN (SELECT DISTINCT tmpMS_GUID.MovementId FROM tmpMS_GUID)
                                        )
                    -- Результат
                    SELECT Movement.Id AS MovementId
                    FROM tmpMovement AS Movement
                    WHERE Movement.OperDate = CURRENT_DATE
                      AND Movement.DescId   = zc_Movement_RepriceSite()
                      -- AND Movement.OperDate >= CURRENT_DATE AND Movement.OperDate < CURRENT_DATE + INTERVAL '1 DAY'
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
                                                   , inisJuridicalTwo     := inisJuridicalTwo
                                                   , inJuridicalTwoId     := inJuridicalTwoId
                                                   , inContractTwoId      := inContractTwoId
                                                   , inJuridical_PriceTwo := inJuridical_PriceTwo
                                                   , inExpirationDateTwo  := inExpirationDateTwo
                                                   , inUserId             := vbUserId);

    -- сохранили <Признак лог отсечения>
    PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_ClippedReprice(), ioId, True);
    
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