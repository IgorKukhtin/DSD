-- Function: gpInsert_MovementItem_Reprice()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_RepriceChange (Integer, Integer, Integer, Integer, TFloat, Integer, Integer, TDateTime, TDateTime, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_RepriceChange (Integer, Integer, Integer, Integer, TFloat, Integer, Integer, TDateTime, TDateTime, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_RepriceChange(
 INOUT ioId                  Integer   , -- Ключ записи
    IN inGoodsId             Integer   , -- Товары
    IN inRetailId            Integer   , -- подразделение
    IN inRetailId_Forwarding Integer   , -- Подразделения(основание для равенства цен)
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
                                          AND MS_GUID.DescId    = zc_MovementString_Comment()
                                       )
                      ,  tmpMLO_Retail AS (SELECT MLO_Retail.MovementId
                                         FROM MovementLinkObject AS MLO_Retail
                                         WHERE MLO_Retail.MovementId IN (SELECT DISTINCT tmpMS_GUID.MovementId FROM tmpMS_GUID)
                                           AND MLO_Retail.DescId     = zc_MovementLinkObject_Retail()
                                           AND MLO_Retail.ObjectId   = inRetailId
                                        )
                      ,  tmpMovement AS (SELECT Movement.Id, Movement.OperDate, Movement.DescId
                                         FROM Movement
                                         WHERE Movement.Id IN (SELECT DISTINCT tmpMLO_Retail.MovementId FROM tmpMLO_Retail)
                                        )
                    -- Результат
                    SELECT Movement.Id AS MovementId
                    FROM tmpMovement AS Movement
                    WHERE Movement.OperDate = CURRENT_DATE
                      AND Movement.DescId   = zc_Movement_RepriceChange()
                   );

    IF COALESCE (vbMovementId, 0) = 0
    THEN
        --
        vbMovementId := lpInsertUpdate_Movement_RepriceChange(ioId        := COALESCE (vbMovementId,0),
                                                              inInvNumber := CAST (NEXTVAL('movement_repricechange_seq') AS TVarChar),
                                                              inOperDate  := CURRENT_DATE::TDateTime,
                                                              inRetailId  := inRetailId,
                                                              inGUID      := inGUID,
                                                              inUserId    := vbUserId
                                                             );

        -- сохранили связь с <Подразделения(основание для равенства цен)>
        PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_RetailForwarding(), vbMovementId, inRetailId_Forwarding);
        -- сохранили <(-)% Скидки (+)% Наценки (основание для равенства цен)>
        PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercent(), vbMovementId, inTax);


    ELSE
        -- сохранили связь с <Подразделения(основание для равенства цен)>
        PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_RetailForwarding(), vbMovementId, inRetailId_Forwarding);
        -- сохранили <(-)% Скидки (+)% Наценки (основание для равенства цен)>
        PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercent(), vbMovementId, inTax);

    END IF;

    -- переоценить товар
    PERFORM lpInsertUpdate_Object_PriceChange(inGoodsId     := inGoodsId,
                                              inRetailId    := inRetailId,
                                              inPriceChange := inPriceNew,
                                              inDate        := CURRENT_DATE::TDateTime,
                                              inUserId      := vbUserId);

    -- сохранить запись
    ioId := lpInsertUpdate_MovementItem_RepriceChange (ioId                 := COALESCE (ioId, 0)
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
                                                     , inUserId             := vbUserId
                                                      );


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.08.18         *
*/
-- SELECT COUNT(*) FROM Log_RepriceChange
-- SELECT * FROM Log_RepriceChange WHERE TextValue NOT LIKE '%InsertUpdate%' ORDER BY Id DESC LIMIT 100
-- SELECT * FROM Log_RepriceChange ORDER BY Id DESC LIMIT 100
