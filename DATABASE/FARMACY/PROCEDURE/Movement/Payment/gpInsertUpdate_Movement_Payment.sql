-- Function: gpInsertUpdate_Movement_Payment()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Payment (Integer, TVarChar, TDateTime, Integer, Boolean, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Payment(
 INOUT ioId                    Integer    , -- Ключ объекта <Документ Оплаты приходов>
    IN inInvNumber             TVarChar   , -- Номер документа
    IN inOperDate              TDateTime  , -- Дата документа
    IN inJuridicalId           Integer    , -- Юрлицо плательщик
    IN inisPaymentFormed       Boolean    , -- Платеж сформирован 
    IN inComment               TVarChar   , -- Комментарий
    IN inSession               TVarChar     -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Payment());
    vbUserId := inSession;
    --проверили заполнение юрлица
    IF COALESCE(inJuridicalId,0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка. Не заполнено юрлицо.';
    END IF;
    --Проверили наличие расчетного счета у юрлица
    IF NOT EXISTS (SELECT 1 FROM Object_BankAccount_View WHERE JuridicalId = inJuridicalId AND isErased = FALSE)
    THEN
        RAISE EXCEPTION 'Ошибка. Для выбранного юрлица не создано ни одного расчетного счета.';
    END IF;
    
    --поискали такой документ в указаном дне
/*     IF EXISTS(SELECT 1 
              FROM Movement_Payment_View AS Movement
              WHERE
                  Movement.OperDate = inOperdate
                  AND
                  Movement.JuridicalId = inJuridicalId
                  AND
                  Movement.StatusId <> zc_Enum_Status_Erased()
                  AND
                  Movement.Id <> COALESCE(ioId,0))
    THEN
        RAISE EXCEPTION 'Ошибка. В одной дате <%>, по одному юрлицу <%> может быть только один документ оплаты.', inOperDate,(Select ValueData from Object Where Id = inJuridicalId);
    END IF; */
    -- сохранили <Документ>
    ioId := lpInsertUpdate_Movement_Payment (ioId              := ioId
                                           , inInvNumber       := inInvNumber
                                           , inOperDate        := inOperDate
                                           , inJuridicalId     := inJuridicalId
                                           , inisPaymentFormed := inisPaymentFormed
                                           , inComment         := inComment
                                           , inUserId          := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Movement_Payment (Integer, TVarChar, TDateTime, Integer, Boolean, TVarChar) OWNER TO postgres;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.  Воробкало А.А.
 29.10.15                                                                    *
*/