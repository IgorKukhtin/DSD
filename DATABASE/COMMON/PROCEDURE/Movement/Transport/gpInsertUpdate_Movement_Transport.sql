-- Function: gpInsertUpdate_Movement_Transport (Integer, TVarChar, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Transport (Integer, TVarChar, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Transport (Integer, TVarChar, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TFloat,  TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Transport (Integer, TVarChar, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TFloat,  TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Transport (Integer, TVarChar, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TFloat,  TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Transport(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    
    IN inStartRunPlan        TDateTime , -- Дата/Время выезда план
    IN inEndRunPlan          TDateTime , -- Дата/Время возвращения план
    IN inStartRun            TDateTime , -- Дата/Время выезда факт
    IN inEndRun              TDateTime , -- Дата/Время возвращения факт

    IN inStartStop           TDateTime , -- Дата/Время начала простоя
    IN inEndStop             TDateTime , -- Дата/Время окончания простоя

    IN inHoursAdd            TFloat    , -- Кол-во добавленных рабочих часов
   OUT outHoursWork          TFloat    , -- Кол-во рабочих часов
   OUT outHoursStop          TFloat    , -- кол-во часов простоя
   OUT outHoursMove          TFloat    , -- кол-во часов движения

    IN inComment             TVarChar  , -- Примечание
    IN inCommentStop         TVarChar  , -- Примечание причина простоя
    
    IN inCarId                Integer   , -- Автомобиль
    IN inCarTrailerId         Integer   , -- Автомобиль (прицеп)
    IN inPersonalDriverId     Integer   , -- Сотрудник (водитель)
    IN inPersonalDriverMoreId Integer   , -- Сотрудник (водитель, дополнительный)
    IN inPersonalId           Integer   , -- Сотрудник (экспедитор)
    IN inUnitForwardingId     Integer   , -- Подразделение (Место отправки)

    IN inSession              TVarChar    -- сессия пользователя

)                              
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyId Integer;
   DECLARE vbChild_byMaster Boolean;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Transport());
     -- определяем ключ доступа
     vbAccessKeyId:= lpGetAccessKey (vbUserId, zc_Enum_Process_InsertUpdate_Movement_Transport());


     -- проверка
     IF inHoursAdd > 0
     THEN
         RAISE EXCEPTION 'Ошибка.Проверьте знак для <Кол-во добавленных рабочих часов>.';
     END IF;

     -- определяем - если Автомобиль изменился, надо в конце пересчитать Child - Заправка авто
     IF ioId <> 0 AND NOT EXISTS (SELECT MovementId FROM MovementLinkObject WHERE MovementId = ioId AND DescId = zc_MovementLinkObject_Car() AND ObjectId = inCarId)
     THEN vbChild_byMaster:= TRUE;
     ELSE vbChild_byMaster:= FALSE;
     END IF;


     -- !!!В этом случае сохраняем много свойств и выходим!!!
     IF ioId <> 0 AND EXISTS (SELECT Id
                              FROM gpGet_Movement_Transport (inMovementId:= ioId, inSession:= inSession)
                              WHERE InvNumber = inInvNumber
                                AND OperDate = inOperDate
                                -- AND StartRunPlan = inStartRunPlan
                                -- AND EndRunPlan = inEndRunPlan
                                -- AND StartRun = inStartRun
                                -- AND EndRun = inEndRun
                                -- AND COALESCE (HoursAdd, 0) = inHoursAdd
                                -- AND COALESCE (Comment, '') = inComment
                                AND COALESCE (CarId, 0) = inCarId
                                -- AND COALESCE (CarTrailerId, 0) = inCarTrailerId
                                AND COALESCE (PersonalDriverId, 0) = inPersonalDriverId
                                -- AND COALESCE (PersonalDriverMoreId, 0) = inPersonalDriverMoreId
                                -- AND COALESCE (PersonalId, 0) = inPersonalId
                                AND COALESCE (UnitForwardingId, 0) = inUnitForwardingId
                             )
     THEN
         -- сохранили связь с <Дата/Время выезда план>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_StartRunPlan(), ioId, inStartRunPlan);
         -- сохранили связь с <Дата/Время возвращения план>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndRunPlan(), ioId, inEndRunPlan);
         -- сохранили связь с <Дата/Время выезда факт>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_StartRun(), ioId, inStartRun);
         -- сохранили связь с <Дата/Время возвращения факт>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndRun(), ioId, inEndRun);

         -- сохранили связь с <Дата/Время начала простоя>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_StartStop(), ioId, inStartStop);
         -- сохранили связь с <Дата/Время окончания простоя>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndStop(), ioId, inEndStop);

         -- расчитали свойство <Кол-во рабочих часов>
         outHoursWork := EXTRACT (DAY FROM (inEndRun - inStartRun)) * 24 + EXTRACT (HOUR FROM (inEndRun - inStartRun)) + CAST (EXTRACT (MIN FROM (inEndRun - inStartRun)) / 60 AS NUMERIC (16, 2));
         -- сохранили свойство <Кол-во рабочих часов>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_HoursWork(), ioId, outHoursWork);

         -- расчитали свойство <Кол-во часов простоя / ремонта>
         outHoursStop := EXTRACT (DAY FROM (inEndStop - inStartStop)) * 24 + EXTRACT (HOUR FROM (inEndStop - inStartStop)) + CAST (EXTRACT (MIN FROM (inEndStop - inStartStop)) / 60 AS NUMERIC (16, 2));
         -- сохранили свойство <Кол-во часов простоя>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_HoursStop(), ioId, outHoursStop);

         -- досчитали что б правильно вернул в контрол свойство <Кол-во рабочих часов> !!!с учетом добавленных!!!
         outHoursWork := outHoursWork + COALESCE (inHoursAdd, 0);
         -- сохранили свойство <Кол-во добавленных рабочих часов>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_HoursAdd(), ioId, inHoursAdd);

         --время движения
         outHoursMove := (COALESCE (outHoursWork,0) - COALESCE (outHoursStop,0)) :: TFloat;
         
         -- сохранили свойство <Примечание>
         PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

         -- сохранили свойство <Примечание причина простоя>
         PERFORM lpInsertUpdate_MovementString (zc_MovementString_CommentStop(), ioId, inCommentStop);

         -- сохранили связь с <Автомобиль (прицеп)>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_CarTrailer(), ioId, inCarTrailerId);

         -- сохранили связь с <Сотрудник (водитель, дополнительный)>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PersonalDriverMore(), ioId, inPersonalDriverMoreId);

         -- сохранили связь с <Сотрудник (экспедитор)>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Personal(), ioId, inPersonalId);
         -- сохранили протокол
         PERFORM lpInsert_MovementProtocol (ioId, vbUserId, FALSE);
         --
         -- !!!ВЫХОД!!!
         RETURN;
     END IF;


     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Transport(), inInvNumber, inOperDate, NULL, vbAccessKeyId);

     -- сохранили связь с <Дата/Время выезда план>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_StartRunPlan(), ioId, inStartRunPlan);
     -- сохранили связь с <Дата/Время возвращения план>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndRunPlan(), ioId, inEndRunPlan);
     -- сохранили связь с <Дата/Время выезда факт>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_StartRun(), ioId, inStartRun);
     -- сохранили связь с <Дата/Время возвращения факт>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndRun(), ioId, inEndRun);

     -- сохранили связь с <Дата/Время начала простоя>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_StartStop(), ioId, inStartStop);
     -- сохранили связь с <Дата/Время окончания простоя>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndStop(), ioId, inEndStop);

     -- расчитали свойство <Кол-во рабочих часов>
     outHoursWork := EXTRACT (DAY FROM (inEndRun - inStartRun)) * 24 + EXTRACT (HOUR FROM (inEndRun - inStartRun)) + CAST (EXTRACT (MIN FROM (inEndRun - inStartRun)) / 60 AS NUMERIC (16, 2));
     -- сохранили свойство <Кол-во рабочих часов>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_HoursWork(), ioId, outHoursWork);

     -- досчитали что б правильно вернул в контрол свойство <Кол-во рабочих часов> !!!с учетом добавленных!!!
     outHoursWork := outHoursWork + COALESCE (inHoursAdd, 0);

     -- расчитали свойство <Кол-во часов простоя / ремонта>
     outHoursStop := EXTRACT (DAY FROM (inEndStop - inStartStop)) * 24 + EXTRACT (HOUR FROM (inEndStop - inStartStop)) + CAST (EXTRACT (MIN FROM (inEndStop - inStartStop)) / 60 AS NUMERIC (16, 2));
     -- сохранили свойство <Кол-во часов простоя>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_HoursStop(), ioId, outHoursStop);

     -- время движения
     outHoursMove := (COALESCE (outHoursWork,0) - COALESCE (outHoursStop,0)) :: TFloat;

     -- сохранили свойство <Кол-во добавленных рабочих часов>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_HoursAdd(), ioId, inHoursAdd);

     -- сохранили свойство <Примечание>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

     -- сохранили свойство <Примечание причина простоя>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_CommentStop(), ioId, inCommentStop);

     -- сохранили связь с <Автомобиль>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Car(), ioId, inCarId);
     -- сохранили связь с <Автомобиль (прицеп)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_CarTrailer(), ioId, inCarTrailerId);

     -- сохранили связь с <Сотрудник (водитель)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PersonalDriver(), ioId, inPersonalDriverId);
     -- сохранили связь с <Сотрудник (водитель, дополнительный)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PersonalDriverMore(), ioId, inPersonalDriverMoreId);
     -- сохранили связь с <Сотрудник (экспедитор)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Personal(), ioId, inPersonalId);
     
     -- сохранили связь с <Подразделение (Место отправки)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_UnitForwarding(), ioId, inUnitForwardingId);


     -- Изменили свойства у подчиненных Документов
     PERFORM lpInsertUpdate_Movement (ioId:= Movement.Id, inDescId:=zc_Movement_Income(), inInvNumber:= Movement.InvNumber, inOperDate:= inOperDate, inParentId:= Movement.ParentId)
           , lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), Movement.Id, inCarId)
           , lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PersonalDriver(), Movement.Id, inPersonalDriverId)
     FROM Movement
     WHERE Movement.ParentId = ioId
       AND Movement.DescId   = zc_Movement_Income();


     -- !!!обязательно!!! пересчитали Child
     IF vbChild_byMaster = TRUE
     THEN PERFORM lpInsertUpdate_MI_Transport_Child_byMaster (inMovementId := ioId, inParentId := MovementItem.Id, inRouteKindId:= MILinkObject_RouteKind.ObjectId, inUserId := vbUserId)
          FROM MovementItem
               LEFT JOIN MovementItemLinkObject AS MILinkObject_RouteKind
                                                ON MILinkObject_RouteKind.MovementItemId = MovementItem.Id
                                               AND MILinkObject_RouteKind.DescId = zc_MILinkObject_RouteKind()
          WHERE MovementItem.MovementId = ioId
            AND MovementItem.DescId = zc_MI_Master();
     END IF;


     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.04.21         *
 23.03.14                                        * add vbIsInsert
 23.03.14                                        * add В этом случае сохраняем много свойств и выходим
 04.03.14                                        * add В этом случае сохраняем одно свойство и выходим
 07.12.13                                        * add lpGetAccessKey
 02.12.13         * add Personal (changes in wiki)
 31.10.13                                        * add lpInsertUpdate_Movement - Изменили свойства у подчиненных Документов
 24.10.13                                        * add !!!с учетом добавленных!!!
 24.10.13                                        * add min to outHoursWork
 13.10.13                                        * add lpInsertUpdate_MI_Transport_Child_byMaster
 12.10.13                                        * add IF inHoursAdd > 0
 06.10.13                                        * add zc_Movement_Income
 26.09.13                                        * changes in wiki                 
 25.09.13         * changes in wiki                 
 20.08.13         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_Transport (ioId:= 149691, inInvNumber:= '1', inOperDate:= '01.10.2013 3:00:00', inStartRunPlan:= '30.09.2013 3:00:00', inEndRunPlan:= '30.09.2013 3:00:00', inStartRun:= '30.09.2013 3:00:00', inEndRun:= '30.09.2013 3:00:00', inHoursAdd:= 0, inComment:= ''    , inCarId:= 67657, inCarTrailerId:= 0, inPersonalDriverId:= 19476, inPersonalDriverMoreId:= 19476, inUnitForwardingId:= 1000, inSession:= '2')
