-- Function: gpInsertUpdate_Movement_PUSH()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PUSH (Integer, TVarChar, TDateTime, TDateTime, Integer, Boolean, TBlob, TVarChar, Boolean, Boolean, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_PUSH(
 INOUT ioId                    Integer    , -- Ключ объекта <Документ продажи>
    IN inInvNumber             TVarChar   , -- Номер документа
    IN inOperDate              TDateTime  , -- Дата документа
    IN inDateEndPUSH           TDateTime  ,
    IN inReplays               Integer    , -- Количество повторов  
    IN inDaily                 Boolean    , -- Повт. ежедневно
    IN inMessage               TBlob      , -- Сообщение
    IN inFunction              TVarChar   , -- Функция
    IN inisPoll                Boolean    , -- Опрос
    IN inisPharmacist          Boolean    , -- Только фармацевтам
    IN inRetailId              Integer    , -- Только для торговая сети 
    IN inForm                  TVarChar   , -- Открывать форму если функция возвращает не пусто
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
                                        , inDaily           := inDaily 
                                        , inMessage         := inMessage
                                        , inFunction        := inFunction
                                        , inisPoll          := inisPoll
                                        , inisPharmacist    := inisPharmacist
                                        , inRetailId        := inRetailId
                                        , inForm            := inForm
                                        , inUserId          := vbUserId
                                        );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 05.03.20        *
 19.02.20        *
 11.05.19        *
 13.03.19        *
 10.03.19        *
*/