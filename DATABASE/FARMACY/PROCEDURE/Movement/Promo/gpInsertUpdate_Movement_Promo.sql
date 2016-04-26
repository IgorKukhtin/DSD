-- Function: gpInsertUpdate_Movement_Promo()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Promo (Integer, TVarChar, TDateTime, TDateTime, TDateTime, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Promo (Integer, TVarChar, TDateTime, TDateTime, TDateTime, Tfloat, Tfloat, Integer, Integer, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Promo(
 INOUT ioId                    Integer    , -- Ключ объекта <Документ продажи>
    IN inInvNumber             TVarChar   , -- Номер документа
    IN inOperDate              TDateTime  , -- Дата документа
    IN inStartPromo            TDateTime  , -- Дата начала контракта
    IN inEndPromo              TDateTime  , -- Дата окончания контракта
    IN inAmount                Tfloat     , -- 
    IN inChangePercent         Tfloat     , --
    IN inMakerId               Integer    , -- Производитель
    IN inPersonalId            Integer    , -- Ответственный представитель маркетингового отдела
    IN inComment               TVarChar   , -- Примечание
    IN inSession               TVarChar     -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Promo());
    vbUserId := inSession;
    -- сохранили <Документ>
    ioId := lpInsertUpdate_Movement_Promo (ioId            := ioId
                                         , inInvNumber     := inInvNumber
                                         , inOperDate      := inOperDate
                                         , inStartPromo    := inStartPromo
                                         , inEndPromo      := inEndPromo
                                         , inAmount        := inAmount
                                         , inChangePercent := inChangePercent
                                         , inMakerId       := inMakerId
                                         , inPersonalId    := inPersonalId
                                         , inComment       := inComment
                                         , inUserId        := vbUserId
                                         );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.  Воробкало А.А.
 24.04.16         *
*/