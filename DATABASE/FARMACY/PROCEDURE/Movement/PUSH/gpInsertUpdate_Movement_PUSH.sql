-- Function: gpInsertUpdate_Movement_PUSH()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PUSH (Integer, TVarChar, TDateTime, TBlob, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PUSH (Integer, TVarChar, TDateTime, Integerб TBlob, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_PUSH(
 INOUT ioId                    Integer    , -- Ключ объекта <Документ продажи>
    IN inInvNumber             TVarChar   , -- Номер документа
    IN inOperDate              TDateTime  , -- Дата документа
    IN inDateEndPUSH           TDateTime  ,
    IN inReplays               Integer    , -- Количество повторов  
    IN inMessage               TBlob      , -- Сообщение
    IN inSession               TVarChar     -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_UnnamedEnterprises());
    vbUserId := inSession;

    -- сохранили <Документ>
    ioId := lpInsertUpdate_Movement_PUSH (ioId              := ioId
                                        , inInvNumber       := inInvNumber
                                        , inOperDate        := inOperDate
                                        , inDateEndPUSH     := inDateEndPUSH
                                        , inReplays         := inReplays 
                                        , inMessage         := inMessage
                                        , inUserId          := vbUserId
                                        );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 13.03.19         *
 10.03.19         *
*/