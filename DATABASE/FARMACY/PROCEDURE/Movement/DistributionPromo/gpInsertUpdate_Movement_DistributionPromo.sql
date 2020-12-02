-- Function: gpInsertUpdate_Movement_DistributionPromo()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_DistributionPromo (Integer, TVarChar, TDateTime, Integer, TDateTime, TDateTime, Integer, TFloat, TVarChar, TBlob, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_DistributionPromo(
 INOUT ioId                    Integer    , -- Ключ объекта <Документ продажи>
    IN inInvNumber             TVarChar   , -- Номер документа
    IN inOperDate              TDateTime  , -- Дата документа
    IN inRetailID              Integer    , -- Торговая сеть
    IN inStartPromo            TDateTime  , -- Дата начала действия
    IN inEndPromo              TDateTime  , -- Дата окончания действия
    IN inAmount                Integer    , -- Выдовать от количества товара
    IN inSummRepay             Tfloat     , -- Выдовать от суммы товара 
    IN inComment               TVarChar   , -- Примечание
    IN inMessage               TBlob      , -- Сообщение
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
    ioId := lpInsertUpdate_Movement_DistributionPromo (ioId            := ioId
                                                     , inInvNumber     := inInvNumber
                                                     , inOperDate      := inOperDate
                                                     , inRetailID      := inRetailID
                                                     , inStartPromo    := inStartPromo
                                                     , inEndPromo      := inEndPromo
                                                     , inAmount        := inAmount                                       
                                                     , inSummRepay     := inSummRepay
                                                     , inComment       := inComment
                                                     , inMessage       := inMessage
                                                     , inUserId        := vbUserId
                                                     );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 02.12.20                                                       *
*/