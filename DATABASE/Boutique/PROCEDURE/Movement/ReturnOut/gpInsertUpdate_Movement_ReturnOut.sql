-- Function: gpInsertUpdate_Movement_ReturnOut()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ReturnOut 
                (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ReturnOut 
                (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ReturnOut(
 INOUT ioId                   Integer   , -- Ключ объекта <Документ>
 INOUT ioInvNumber            TVarChar  , -- Номер документа
    IN inOperDate             TDateTime , -- Дата документа
    IN inFromId               Integer   , -- От кого (в документе)
    IN inToId                 Integer   , -- Кому (в документе)
    IN inCurrencyDocumentId   Integer   , -- Валюта (документа)
    IN inCurrencyPartnerId    Integer   , -- Валюта (контрагента)
   OUT outCurrencyValue       TFloat    , -- курс валюты
   OUT outParValue            TFloat    , -- Номинал для перевода в валюту баланса
    IN inCurrencyPartnerValue TFloat    , -- Курс для расчета суммы операции
    IN inParPartnerValue      TFloat    , -- Номинал для расчета суммы операции
    IN inComment              TVarChar  , -- Примечание
    IN inSession              TVarChar    -- сессия пользователя
)                              
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbOperDate TDateTime;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ReturnOut());

     IF COALESCE (ioId, 0) = 0 THEN
         ioInvNumber:= CAST (NEXTVAL ('movement_returnout_seq') AS TVarChar);  
     END IF;

     -- данные из шапки
     SELECT Movement.OperDate
    INTO vbOperDate
     FROM Movement 
     WHERE Movement.Id = ioId;

    IF inCurrencyDocumentId <> zc_Currency_Basis() THEN
        SELECT COALESCE (tmp.Amount,1), COALESCE (tmp.ParValue,0)
       INTO outCurrencyValue, outParValue
        FROM lfSelect_Movement_Currency_byDate (inOperDate:= vbOperDate, inCurrencyFromId:= zc_Currency_Basis(), inCurrencyToId:= inCurrencyDocumentId ) AS tmp;
    END IF;
     
     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement_ReturnOut (ioId                := ioId
                                              , inInvNumber         := ioInvNumber
                                              , inOperDate          := inOperDate
                                              , inFromId            := inFromId
                                              , inToId              := inToId
                                              , inCurrencyDocumentId:= inCurrencyDocumentId
                                              , inCurrencyPartnerId := inCurrencyPartnerId
                                              , inCurrencyValue     := outCurrencyValue
                                              , inParValue          := outParValue
                                              , inCurrencyPartnerValue := inCurrencyPartnerValue
                                              , inParPartnerValue   := inParPartnerValue
                                              , inComment           := inComment
                                              , inUserId            := vbUserId
                                              );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 08.05.17         *
 24.04.17         *
 */

-- тест
-- select * from gpInsertUpdate_Movement_ReturnOut(ioId := 7 , ioInvNumber := '4' , inOperDate := ('01.01.2017')::TDateTime , inFromId := 230 , inToId := 229 , inCurrencyDocumentId := 0 , inCurrencyPartnerId := 0 , inCurrencyPartnerValue := 1 , inParPartnerValue := 0 , inComment := 'df' ,  inSession := '2');