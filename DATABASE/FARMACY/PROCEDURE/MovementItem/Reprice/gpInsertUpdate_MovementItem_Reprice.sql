-- Function: gpInsert_MovementItem_Reprice()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Reprice (Integer, Integer, Integer, Integer, TFloat, Integer, Integer, TDateTime, TDateTime, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean, Integer, Integer, TFloat, TDateTime, Boolean, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Reprice(
 INOUT ioId                  Integer   , -- Ключ записи
    IN inGoodsId             Integer   , -- Товары
    IN inUnitId              Integer   , -- подразделение
    IN inUnitId_Forwarding   Integer   , -- Подразделения(основание для равенства цен)
    IN inTax                 TFloat    , -- % +/-
    IN inJuridicalId         Integer   , -- поставщик
    IN inContractId          Integer   , -- Договор
    IN inExpirationDate      TDateTime , -- Срок годности
    IN inMinExpirationDate   TDateTime , -- Срок годности остатка
    IN inAmount              TFloat    , -- Количество (Остаток)

    IN inPriceOld            TFloat    , -- Цена старая
    IN inPriceNew            TFloat    , -- Цена новая
    IN inJuridical_Price     TFloat    , -- Цена поставщика
    IN inJuridical_Percent   TFloat    , -- % Корректировки наценки поставщика
    IN inContract_Percent    TFloat    , -- % Корректировки наценки Договора

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
   DECLARE vbOperDate_StartBegin TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;

    -- !!!Протокол - отладка Скорости!!!
    vbOperDate_StartBegin:= CLOCK_TIMESTAMP();


    -- найти документ
    vbMovementId:= (/*SELECT Movement.Id
                    FROM Movement
                        INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                      ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                     AND MovementLinkObject_Unit.DescId     = zc_MovementLinkObject_Unit()
                                                     AND MovementLinkObject_Unit.ObjectId   = inUnitId
                        INNER JOIN MovementString AS MovementString_GUID
                                                  ON MovementString_GUID.MovementId = Movement.Id
                                                 AND MovementString_GUID.DescId     = zc_MovementString_Comment()
                                                 AND MovementString_GUID.ValueData  = inGUID
                    WHERE Movement.DescId   = zc_Movement_Reprice()
                      -- AND Movement.OperDate >= CURRENT_DATE AND Movement.OperDate < CURRENT_DATE + INTERVAL '1 DAY'
                      AND Movement.OperDate = CURRENT_DATE*/
                    WITH tmpMS_GUID AS (SELECT MS_GUID.MovementId
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
                      AND Movement.DescId   = zc_Movement_Reprice()
                      -- AND Movement.OperDate >= CURRENT_DATE AND Movement.OperDate < CURRENT_DATE + INTERVAL '1 DAY'
                   );


    IF COALESCE (vbMovementId, 0) = 0
    THEN
        --
        vbMovementId := lpInsertUpdate_Movement_Reprice(ioId        := COALESCE (vbMovementId,0),
                                                        inInvNumber := CAST (NEXTVAL('movement_sale_seq') AS TVarChar),
                                                        inOperDate  := CURRENT_DATE::TDateTime,
                                                        inUnitId    := inUnitId,
                                                        inGUID      := inGUID,
                                                        inUserId    := vbUserId);
        -- сохранили связь с <Подразделения(основание для равенства цен)>
        PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_UnitForwarding(), vbMovementId, inUnitId_Forwarding);
        -- сохранили <(-)% Скидки (+)% Наценки (основание для равенства цен)>
        PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercent(), vbMovementId, inTax);


    ELSE
        -- сохранили связь с <Подразделения(основание для равенства цен)>
        PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_UnitForwarding(), vbMovementId, inUnitId_Forwarding);
        -- сохранили <(-)% Скидки (+)% Наценки (основание для равенства цен)>
        PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercent(), vbMovementId, inTax);

    END IF;

    -- переоценить товар
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
                                               , inContractId         := inContractId
                                               , inExpirationDate  := inExpirationDate
                                               , inMinExpirationDate  := inMinExpirationDate
                                               , inAmount             := inAmount
                                               , inPriceOld           := inPriceOld
                                               , inPriceNew           := inPriceNew
                                               , inJuridical_Price    := inJuridical_Price
                                               , inJuridical_Percent  := inJuridical_Percent
                                               , inContract_Percent   := inContract_Percent
                                               , inisJuridicalTwo     := inisJuridicalTwo
                                               , inJuridicalTwoId     := inJuridicalTwoId
                                               , inContractTwoId      := inContractTwoId
                                               , inJuridical_PriceTwo := inJuridical_PriceTwo
                                               , inExpirationDateTwo  := inExpirationDateTwo
                                               , inUserId             := vbUserId);

    -- сохранили <По маркетинговому бонусу >
    IF COALESCE (inisPromoBonus, False) = TRUE
    THEN
      PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PromoBonus(), ioId, inisPromoBonus);
    END IF;

    -- if inSession = zfCalc_UserAdmin() then
    --
    -- !!!Протокол - отладка Скорости!!!
    /*INSERT INTO Log_Reprice (InsertDate, StartDate, EndDate, MovementId, UserId, TextValue)
      VALUES (CURRENT_TIMESTAMP, vbOperDate_StartBegin, CLOCK_TIMESTAMP(), vbMovementId, vbUserId
            , ioId                  :: TVarChar
    || ',' || inGoodsId             :: TVarChar
    || ',' || inUnitId              :: TVarChar
    || ',' || inUnitId_Forwarding   :: TVarChar
    || ',' || zfConvert_FloatToString (inTax)
    || ',' || inJuridicalId         :: TVarChar
    || ',' || inContractId          :: TVarChar
    || ',' || CHR (39) || zfConvert_DateToString (inExpirationDate)    || CHR (39)
    || ',' || CHR (39) || zfConvert_DateToString (inMinExpirationDate) || CHR (39)
    || ',' || zfConvert_FloatToString (inAmount)
    || ',' || zfConvert_FloatToString (inPriceOld)
    || ',' || zfConvert_FloatToString (inPriceNew)
    || ',' || zfConvert_FloatToString (inJuridical_Price)
    || ',' || zfConvert_FloatToString (inJuridical_Percent)
    || ',' || zfConvert_FloatToString (inContract_Percent)
    || ',' || CHR (39) || inGUID    || CHR (39)
    || ',' || CHR (39) || inSession || CHR (39)
             );*/
    -- end If;

    /*if inSession = zfCalc_UserAdmin() then
      RAISE EXCEPTION ' %  %', vbOperDate_StartBegin, CLOCK_TIMESTAMP();
    end If;*/

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.    Воробкало А.А.
 18.02.16         *
 27.11.15                                                                       *
*/
-- SELECT COUNT(*) FROM Log_Reprice
-- SELECT * FROM Log_Reprice WHERE TextValue NOT LIKE '%InsertUpdate%' ORDER BY Id DESC LIMIT 100
-- SELECT * FROM Log_Reprice ORDER BY Id DESC LIMIT 100