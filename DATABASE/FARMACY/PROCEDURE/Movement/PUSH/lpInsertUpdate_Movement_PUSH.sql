-- Function: lpInsertUpdate_Movement_PUSH()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_PUSH (Integer, TVarChar, TDateTime, TDateTime, Integer, Boolean, TBlob, TVarChar, Boolean, Boolean, Integer, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_PUSH(
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
    IN inisAtEveryEntry        Boolean    , -- При каждом входе в кассу
    IN inUserId                Integer     -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
    
    -- определяем признак Создание/Корректировка
    vbIsInsert:= COALESCE (ioId, 0) = 0;
    
    -- сохранили <Документ>
    ioId := lpInsertUpdate_Movement (ioId, zc_Movement_PUSH(), inInvNumber, inOperDate, NULL, 0);
    
    -- сохранили свойство <Сообщение>
    PERFORM lpInsertUpdate_MovementBlob (zc_MovementBlob_Message(), ioId, inMessage);

    -- сохранили свойство <Сообщение>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_Replays(), ioId, inReplays);

    -- сохранили свойство <Сообщение>
    PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PUSHDaily(), ioId, inDaily);

    -- сохранили свойство <Опрос>
    PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Poll(), ioId, inisPoll);

    -- сохранили свойство <Только фармацевтам>
    PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Pharmacist(), ioId, inisPharmacist);

    -- сохранили свойство <При каждом входе в кассу>
    PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_AtEveryEntry(), ioId, inisAtEveryEntry);

    -- сохранили свойство <Пользователь (Только для торговая сети )>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Retail(), ioId, inRetailId);

    -- сохранили свойство <Функция>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_Function(), ioId, inFunction);

    -- сохранили свойство <Открывать форму если функция возвращает не пусто>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_Form(), ioId, inForm);

    -- сохранили свойство <Дата окончания>
    IF inDateEndPUSH > inOperDate
    THEN
      PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_DateEndPUSH(), ioId, inDateEndPUSH);
    END IF;

    -- !!!протокол через свойства конкретного объекта!!!
     IF vbIsInsert = FALSE
     THEN
         -- сохранили свойство <Дата корректировки>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Update(), ioId, CURRENT_TIMESTAMP);
         -- сохранили свойство <Пользователь (корректировка)>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Update(), ioId, inUserId);
     ELSE
         IF vbIsInsert = TRUE
         THEN
             -- сохранили свойство <Дата создания>
             PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
             -- сохранили свойство <Пользователь (создание)>
             PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, inUserId);
         END IF;
     END IF;
     
    -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 05.03.20        *
 19.02.20        *
 11.05.19        *
 15.10.18        *
 11.09.18        *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_Movement_PUSH (ioId:= 0, inOperDate:= '01.09.2018', inSession:= '3')