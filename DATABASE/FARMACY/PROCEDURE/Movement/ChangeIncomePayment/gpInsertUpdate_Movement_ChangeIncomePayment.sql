-- Function: gpInsertUpdate_Movement_ChangeIncomePayment()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ChangeIncomePayment(Integer, TVarChar, TDateTime, TFloat, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ChangeIncomePayment(Integer, TVarChar, TDateTime, TFloat, Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ChangeIncomePayment(
 INOUT ioId                                 Integer   , -- Ключ объекта <Документ изменения долга по приходам>
    IN inInvNumber                          TVarChar  , -- Номер документа
    IN inOperDate                           TDateTime , -- Дата документа
    IN inTotalSumm                          TFloat    , -- Сумма изменения долга
    IN inFromId                             Integer   , -- От кого (в документе)
    IN inJuridicalId                        Integer   , -- Для какого юрлица
    IN inChangeIncomePaymentKindId          Integer   , -- Типы изменения суммы долга
    IN inComment                            TVarChar  , -- Комментарий
    IN inSession                            TVarChar    -- сессия пользователя
)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ChangeIncomePayment());
    vbUserId := inSession;
    
    ioId := lpInsertUpdate_Movement_ChangeIncomePayment(ioId, inInvNumber, inOperDate, inTotalSumm
                                         , inFromId, inJuridicalId, inChangeIncomePaymentKindId 
                                         , inComment, vbUserId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpInsertUpdate_Movement_ChangeIncomePayment (Integer, TVarChar, TDateTime, TFloat, Integer, Integer, Integer, TVarChar, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 10.12.15                                                                       *
*/