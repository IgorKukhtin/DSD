-- Function: gpInsertUpdate_Movement_EDI_Send()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_EDI_Send (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_EDI_Send(
 INOUT ioId                    Integer    , -- Ключ объекта <Документ для отправки в EDI>
    IN inParentId              Integer    , -- Документ - Продажа покупателю
    IN inDescCode              TVarChar  , --
    IN inSession               TVarChar     -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId       Integer;
   DECLARE vbIsInsert     Boolean;
   DECLARE vbDescId       Integer;
   DECLARE vbJuridicalId  Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_EDI_Send());
     vbUserId:= lpGetUserBySession (inSession);


     -- Поиск
     vbDescId := (SELECT Id FROM MovementBooleanDesc WHERE Code ILIKE inDescCode);
     -- проверка
     IF COALESCE (vbDescId, 0) = 0 THEN
         RAISE EXCEPTION 'Ошибка.Неверно значение св-ва <Вид отправки> = <%>.', inDescCode;
     END IF;


     -- Поиск
     ioId:=  (SELECT Movement.Id
              FROM Movement
                   INNER JOIN MovementBoolean ON MovementBoolean.MovementId = Movement.Id
                                             AND MovementBoolean.DescId     = vbDescId
                                             AND MovementBoolean.ValueData  = TRUE
              WHERE Movement.ParentId = inParentId
                AND Movement.DescId   = zc_Movement_EDI_Send()
             );


     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;


     IF ioId > 0
     THEN
         -- вернули статус, Не проведен - значит Не отправлен
         UPDATE Movement SET StatusId = zc_Enum_Status_UnComplete(), StatusId_next = zc_Enum_Status_UnComplete() WHERE Id = ioId AND StatusId <> zc_Enum_Status_UnComplete();

         -- сохранили свойство <Дата/Время изменения>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Update(), ioId, CURRENT_TIMESTAMP);

     ELSE
         -- сохранили <Документ>
         ioId := lpInsertUpdate_Movement (ioId, zc_Movement_EDI_Send(), CAST (NEXTVAL (LOWER ('Movement_EDI_Send_seq')) AS TVarChar) , CURRENT_TIMESTAMP, inParentId);

         -- сохранили свойство <Вид отправки> - Только одно из св-в будет заполнено, т.е. для каждой отправки будет отдельная запись
         PERFORM lpInsertUpdate_MovementBoolean (vbDescId, ioId, TRUE);

     END IF;

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (ioId, vbUserId, vbIsInsert);
     
     
     -- Еще может быть схема ВЧАСНО, если Desadv
     IF EXISTS (SELECT 1 FROM MovementBooleanDesc WHERE Code ILIKE inDescCode AND Id = zc_MovementBoolean_EdiDesadv())
     THEN
         -- из Продажи
         vbJuridicalId:= (SELECT ObjectLink_Partner_Juridical.ChildObjectId
                          FROM Movement
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                            ON MovementLinkObject_To.MovementId = Movement.Id
                                                           AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                               LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                    ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                                   AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()
                          WHERE Movement.Id = inParentId
                         );

         -- если схема Vchasno - EDI
         IF EXISTS (SELECT 1 FROM ObjectBoolean AS OB WHERE OB.ObjectId  = vbJuridicalId AND OB.DescId = zc_ObjectBoolean_Juridical_VchasnoEdi() AND OB.ValueData = TRUE)
         -- этим никогда
         --AND NOT EXISTS (SELECT 1
         --                FROM ObjectLink AS OL
         --                WHERE OL.ObjectId  = vbJuridicalId AND OL.DescId = zc_ObjectLink_Juridical_Retail()
         --                  AND OL.ChildObjectId IN (8873723 -- Кошик
         --                                          )
         --               )
         THEN
             -- Если Delnot
             IF EXISTS (SELECT 1 FROM ObjectBoolean AS OB WHERE OB.ObjectId  = vbJuridicalId AND OB.DescId = zc_ObjectBoolean_Juridical_isEdiDelnot() AND OB.ValueData = TRUE)
             THEN
                 -- Добавили Отправку Delnot
                 PERFORM gpInsertUpdate_Movement_EDI_Send (ioId       := 0
                                                         , inParentId := inParentId
                                                         , inDescCode := 'zc_MovementBoolean_EdiDelnot'
                                                         , inSession  := inSession
                                                          );
             END IF;

             -- Если Comdoc
             IF EXISTS (SELECT 1 FROM ObjectBoolean AS OB WHERE OB.ObjectId  = vbJuridicalId AND OB.DescId = zc_ObjectBoolean_Juridical_isEdiComdoc() AND OB.ValueData = TRUE)
             THEN
                 -- Добавили Отправку Comdoc
                 PERFORM gpInsertUpdate_Movement_EDI_Send (ioId       := 0
                                                         , inParentId := inParentId
                                                         , inDescCode := 'zc_MovementBoolean_EdiComdoc'
                                                         , inSession  := inSession
                                                          );
             END IF;

         END IF; -- если схема Vchasno - EDI

     END IF; -- если Desadv

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 04.02.18                                        *

*/
-- тест
-- SELECT * FROM gpInsertUpdate_Movement_EDI_Send (ioId:= 0, inParentId:= 1, inDescCode:= '', inSession:= '2')
