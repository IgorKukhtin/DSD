-- Function: gpInsertUpdate_MI_ReestrStart()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ReestrStart (TVarChar, TDateTime, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_ReestrStart(
   OUT outId                      Integer   , -- Ключ объекта <Документ>
   --OUT outInvNumber             TVarChar  , -- Номер документа
    IN inBarCode                  TVarChar  , 
    IN inOperDate                 TDateTime , -- Дата документа
    IN inCarId                    Integer   , -- Автомобиль
    IN inPersonalDriverId         Integer   , -- Сотрудник (водитель)
    IN inMemberId                 Integer   , -- Физические лица(экспедитор)
    IN inDocumentId_TransportTop  Integer   , -- Путевой лист/Начисления наемный транспорт
    IN inDocumentId_Transport     Integer   , -- Путевой лист/Начисления наемный транспорт
   OUT outDocumentId_Transport    Integer   , -- Путевой лист/Начисления наемный транспорт
   OUT outInvNumber_Transport     TVarChar   , -- Путевой лист/Начисления наемный транспорт
    IN inSession                  TVarChar    -- сессия пользователя
)                              
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMIId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Reestr());
     
    IF COALESCE (inBarCode, '') = '' THEN 
	Return;
    END IF;
  
    IF COALESCE (inDocumentId_TransportTop, 0) = 0 AND COALESCE (inDocumentId_Transport, 0) = 0 AND COALESCE (inCarId, 0) = 0 THEN 
        RAISE EXCEPTION 'Ошибка. Параметр Путевой лист или Автомобиль должен быть определен.';
    END IF;

         -- ищем док Реестр 
         IF COALESCE (inDocumentId_Transport, COALESCE (inDocumentId_TransportTop,0)) <> 0 THEN 
           outId := ( SELECT MLM_Transport.MovementId AS Id
                     FROM MovementLinkMovement AS MLM_Transport
                     WHERE MLM_Transport.DescId = zc_MovementLinkMovement_Transport()
                       AND MLM_Transport.MovementChildId = COALESCE (inDocumentId_Transport, COALESCE (inDocumentId_TransportTop,0)));
         ELSE
           IF COALESCE (inCarId, 0) <> 0 THEN 
              outId := ( SELECT Movement.Id AS Id
                        FROM Movement
                             INNER JOIN MovementLinkObject AS MovementLinkObject_Car
                                     ON MovementLinkObject_Car.MovementId = Movement.Id
                                    AND MovementLinkObject_Car.DescId = zc_MovementLinkObject_Car()
                                    AND MovementLinkObject_Car.ObjectId = inCarId
                        WHERE Movement.OperDate = inOperDate  AND Movement.DescId = zc_Movement_Reestr()
                        );
           END IF;
         END IF;

         -- если док.реест не найден создаем новый документ
         IF COALESCE (outId, 0) = 0 THEN 
           outId:= lpInsertUpdate_Movement_Reestr (ioId               := 0
                                                 , inInvNumber        := CAST (NEXTVAL ('Movement_Reestr_seq') AS TVarChar) 
                                                 , inOperDate         := CURRENT_DATE::TDateTime 
                                                 , inCarId            := inCarId
                                                 , inPersonalDriverId := inPersonalDriverId
                                                 , inMemberId         := inMemberId
                                                 , inDocumentId_Transport := COALESCE (inDocumentId_Transport, COALESCE (inDocumentId_TransportTop,0))
                                                 , inUserId           := vbUserId
                                                 ) AS tmp;
         ELSE
           outId:= lpInsertUpdate_Movement_Reestr (ioId               := outId
                                                 , inInvNumber        := Movement.InvNumber
                                                 , inOperDate         := Movement.OperDate
                                                 , inCarId            := COALESCE (MovementLinkObject_Car.ObjectId, inCarId)
                                                 , inPersonalDriverId := COALESCE (MovementLinkObject_PersonalDriver.ObjectId, inPersonalDriverId)
                                                 , inMemberId         := COALESCE (MovementLinkObject_Member.ObjectId, inMemberId)
                                                 , inDocumentId_Transport := COALESCE (MovementLinkMovement_Transport.MovementChildId, COALESCE (inDocumentId_Transport, COALESCE (inDocumentId_TransportTop,0))) 
                                                 , inUserId           := vbUserId
                                                  ) 
                   FROM Movement
                       LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Transport
                                                      ON MovementLinkMovement_Transport.MovementId = Movement.Id
                                                     AND MovementLinkMovement_Transport.DescId = zc_MovementLinkMovement_Transport()
                       LEFT JOIN MovementLinkObject AS MovementLinkObject_Car
                                                    ON MovementLinkObject_Car.MovementId = Movement.Id
                                                   AND MovementLinkObject_Car.DescId = zc_MovementLinkObject_Car()
                       LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalDriver
                                                    ON MovementLinkObject_PersonalDriver.MovementId = Movement.Id
                                                   AND MovementLinkObject_PersonalDriver.DescId = zc_MovementLinkObject_PersonalDriver()
                       LEFT JOIN MovementLinkObject AS MovementLinkObject_Member
                                                    ON MovementLinkObject_Member.MovementId = Movement.Id
                                                   AND MovementLinkObject_Member.DescId = zc_MovementLinkObject_Member()
                   WHERE  Movement.id = outId;
         END IF;

       -- пытаемся найти строку с таким док продажи
       vbMIId:= (SELECT MovementItem.Id
                 FROM MovementItem 
                     INNER JOIN MovementFloat AS MF_MovementItemId 
                             ON MF_MovementItemId.ValueData ::integer = MovementItem.Id
                            AND MF_MovementItemId.DescId = zc_MovementFloat_MovementItemId()
                            AND MF_MovementItemId.MovementId = CAST (inBarCode AS integer) --saleid
                 WHERE MovementItem.MovementId= outId 
                   AND MovementItem.DescId = zc_MI_Master() );
       

       -- сохранили <Элемент документа>
       vbMIId := lpInsertUpdate_MovementItem (vbMIId, zc_MI_Master(), vbUserId, outId, 0, NULL);
       -- сохранили <когда сформирована виза "Вывезено со склада">   
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), vbMIId, CURRENT_TIMESTAMP);

       -- сохранили свойство документа продажи <№ строчной части в Реестре накладных>
       PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_MovementItemId(), CAST (inBarCode AS integer), vbMIId);
       -- сохранили связь с <Состояние по реестру>
       PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ReestrKind(), CAST (inBarCode AS integer), zc_Enum_ReestrKind_PartnerOut());

       -- возвращаем параметры путевого листа
       SELECT Movement.Id, Movement.Invnumber
      INTO outDocumentId_Transport, outInvNumber_Transport
       FROM Movement
       WHERE Movement.Id = COALESCE (inDocumentId_Transport, COALESCE (inDocumentId_TransportTop,0));

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 22.10.16         *
*/

-- тест
----RAISE EXCEPTION 'Ошибка.%, %', outId, vbMIId;
--select * from gpInsertUpdate_MI_ReestrStart(inBarCode := '4323306' , inOperDate := ('23.10.2016')::TDateTime , inCarId := 340655 , inPersonalDriverId := 0 , inMemberId := 0 , inDocumentId_TransportTop := 2298218 ,  inSession := '5');
