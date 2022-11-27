-- Function: gpInsertUpdate_Movement_SalePromoGoods()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_SalePromoGoods (Integer, TVarChar, TDateTime, Integer, TDateTime, TDateTime, TVarChar, Boolean, TFloat, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_SalePromoGoods(
 INOUT ioId                    Integer    , -- Ключ объекта <Документ продажи>
    IN inInvNumber             TVarChar   , -- Номер документа
    IN inOperDate              TDateTime  , -- Дата документа
    IN inRetailID              Integer    , -- Торговая сеть
    IN inStartPromo            TDateTime  , -- Дата начала погашения
    IN inEndPromo              TDateTime  , -- Дата окончания погашения
    IN inComment               TVarChar   , -- Примечание
    IN inisAmountCheck         Boolean    , -- Акция от суммы чека
    IN inAmountCheck           TFloat     , -- От суммы чека
    IN inSession               TVarChar     -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Promo());
    vbUserId := inSession;
    
    IF (COALESCE (inisAmountCheck, False) = TRUE OR COALESCE (inAmountCheck, 0) <> 0) AND
       EXISTS (SELECT 1
               FROM MovementItem AS MI_PromoCode
               WHERE MI_PromoCode.MovementId = ioId
                 AND MI_PromoCode.DescId = zc_MI_Master()
                 AND MI_PromoCode.isErased = FALSE)
    THEN
      RAISE EXCEPTION 'Для отпуского "Акционный товар от суммы чека" не надо зполнять основные товары.';
    END IF;
    
    -- сохранили <Документ>
    ioId := lpInsertUpdate_Movement_SalePromoGoods (ioId            := ioId
                                                  , inInvNumber     := inInvNumber
                                                  , inOperDate      := inOperDate
                                                  , inRetailID      := inRetailID
                                                  , inStartPromo    := inStartPromo
                                                  , inEndPromo      := inEndPromo
                                                  , inComment       := inComment
                                                  , inisAmountCheck := inisAmountCheck
                                                  , inAmountCheck   := inAmountCheck
                                                  , inUserId        := vbUserId
                                                  );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.  Шаблий О.В.
 07.09.22                                                       *
*/