-- Function: gpInsertUpdate_MI_ReestrStart()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ReestrStart (Integer, TDateTime, Integer, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_ReestrStart(
 INOUT ioMovementId               Integer   , -- Ключ объекта <Документ>
    IN inOperDate                 TDateTime , -- Дата документа
    IN inCarId                    Integer   , -- Автомобиль
    IN inPersonalDriverId         Integer   , -- Сотрудник (водитель)
    IN inMemberId                 Integer   , -- Физические лица(экспедитор)
 INOUT ioMovementId_TransportTop  Integer   , -- Ключ документа Путевой лист/Начисления наемный транспорт - в шапке
    IN inBarCode_Transport        TVarChar  , -- Ш/к документа Путевой лист/Начисления наемный транспорт - в гриде
    IN inBarCode                  TVarChar  , -- Ш/к документа <Продажа>
    IN inSession                  TVarChar    -- сессия пользователя
)                              
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbIsInsert Boolean;
   DECLARE vbId_mi Integer;
   DECLARE vbMovementId_sale Integer;
   DECLARE vbMemberId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Reestr());
     

     -- только в этом случае - ничего не делаем
     IF ioMovementId = 0
        AND inCarId  = 0
        AND inPersonalDriverId = 0
        AND inMemberId          = 0
        AND ioMovementId_TransportTop  = 0
        AND TRIM (inBarCode_Transport)        = ''
        AND TRIM (inBarCode)                  = ''
     THEN
         RETURN; -- !!!выход!!!
     END IF;


     -- найдем Путевой лист
     IF TRIM (inBarCode_Transport) <> ''
     THEN
         IF CHAR_LENGTH (inBarCode_Transport) >= 13
         THEN -- по штрих коду, но для "проверки" ограничение - 8 DAY
              ioMovementId_TransportTop:= (SELECT Movement.Id
                                           FROM (SELECT zfConvert_StringToNumber (SUBSTR (inBarCode_Transport, 4, 13-4)) AS MovementId
                                                ) AS tmp
                                                INNER JOIN Movement ON Movement.Id = tmp.MovementId
                                                                   AND Movement.DescId IN (zc_Movement_Transport(), zc_Movement_TransportService())
                                                                   AND Movement.OperDate BETWEEN CURRENT_DATE - INTERVAL '8 DAY' AND CURRENT_DATE + INTERVAL '8 DAY'
                                                                   AND Movement.StatusId <> zc_Enum_Status_Erased()
                                          );
         ELSE -- по InvNumber, но для скорости ограничение - 8 DAY
              ioMovementId_TransportTop:= (SELECT Movement.Id
                                           FROM Movement
                                           WHERE Movement.InvNumber = TRIM (inBarCode_Transport)
                                             AND Movement.DescId IN (zc_Movement_Transport(), zc_Movement_TransportService())
                                             AND Movement.OperDate BETWEEN CURRENT_DATE - INTERVAL '8 DAY' AND CURRENT_DATE + INTERVAL '8 DAY'
                                             AND Movement.StatusId <> zc_Enum_Status_Erased()
                                          );
         END IF;

         -- Проверка
         IF COALESCE (ioMovementId_TransportTop, 0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Документ <Путевой лист> с № <%> не найден.', inBarCode_Transport;
         END IF;

     END IF;


     -- найдем Продажу покупателю
     IF TRIM (inBarCode) <> ''
     THEN
         IF CHAR_LENGTH (inBarCode) >= 13
         THEN -- по штрих коду, но для "проверки" ограничение - 33 DAY
              vbMovementId_sale:= (SELECT Movement.Id
                                   FROM (SELECT zfConvert_StringToNumber (SUBSTR (inBarCode, 4, 13-4)) AS MovementId
                                        ) AS tmp
                                        INNER JOIN Movement ON Movement.Id = tmp.MovementId
                                                           AND Movement.DescId = zc_Movement_Sale()
                                                           AND Movement.OperDate BETWEEN CURRENT_DATE - INTERVAL '33 DAY' AND CURRENT_DATE + INTERVAL '8 DAY'
                                                           AND Movement.StatusId <> zc_Enum_Status_Erased()
                                  );
         ELSE -- по InvNumber, но для скорости ограничение - 8 DAY
              vbMovementId_sale:= (SELECT Movement.Id
                                   FROM Movement
                                   WHERE Movement.InvNumber = TRIM (inBarCode)
                                     AND Movement.DescId = zc_Movement_Sale()
                                     AND Movement.OperDate BETWEEN CURRENT_DATE - INTERVAL '8 DAY' AND CURRENT_DATE + INTERVAL '8 DAY'
                                     AND Movement.StatusId <> zc_Enum_Status_Erased()
                                  );
         END IF;

         -- Проверка
         IF COALESCE (vbMovementId_sale, 0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Документ <Продажа покупателю> с № <%> не найден.', inBarCode;
         END IF;

     END IF;


     -- ВСЕГДА - сохранение Movement
     ioMovementId:= lpInsertUpdate_Movement_Reestr (ioId               := ioMovementId
                                                  , inInvNumber        := CASE WHEN ioMovementId <> 0 THEN (SELECT InvNumber FROM Movement WHERE Id = ioMovementId) ELSE CAST (NEXTVAL ('Movement_Reestr_seq') AS TVarChar) END
                                                  , inOperDate         := CASE WHEN ioMovementId <> 0 THEN (SELECT OperDate  FROM Movement WHERE Id = ioMovementId) ELSE CURRENT_DATE :: TDateTime END
                                                    -- если есть - Определили по путевому, надо будет еще сделать для Начисления наемный транспорт
                                                  , inCarId            := CASE WHEN ioMovementId_TransportTop > 0 THEN (SELECT ObjectId FROM MovementLinkObject WHERE MovementId = ioMovementId_TransportTop AND DescId = zc_MovementLinkObject_Car())            ELSE inCarId            END
                                                    -- если есть - Определили по путевому, надо будет еще сделать для Начисления наемный транспорт
                                                  , inPersonalDriverId := CASE WHEN ioMovementId_TransportTop > 0 THEN (SELECT ObjectId FROM MovementLinkObject WHERE MovementId = ioMovementId_TransportTop AND DescId = zc_MovementLinkObject_PersonalDriver()) ELSE inPersonalDriverId END
                                                    -- можно будет найти из Заявки
                                                  , inMemberId         := inMemberId
                                                  , inMovementId_Transport := ioMovementId_TransportTop
                                                  , inUserId           := vbUserId
                                                   );

      -- Только если есть продажа
      IF vbMovementId_sale <> 0
      THEN
          -- Определяется <Физическое лицо> - кто сформировал визу "Вывезено со склада"
          vbMemberId:= CASE WHEN vbUserId = 5 THEN 9457 ELSE
                       (SELECT ObjectLink_User_Member.ChildObjectId
                        FROM ObjectLink AS ObjectLink_User_Member
                        WHERE ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                          AND ObjectLink_User_Member.ObjectId = vbUserId)
                       END
                      ;
          -- Проверка
          IF COALESCE (vbMemberId, 0) = 0
          THEN 
              RAISE EXCEPTION 'Ошибка.У пользователя <%> не назначено значение <Физ.лицо>.', lfGet_Object_ValueData (vbUserId);
          END IF;

          -- Поиск элемента для документа <Продажа>
          vbId_mi:= (SELECT MF_MovementItemId.ValueData :: Integer
                     FROM MovementFloat AS MF_MovementItemId
                     WHERE MF_MovementItemId.MovementId = vbMovementId_sale
                       AND MF_MovementItemId.DescId = zc_MovementFloat_MovementItemId()
                    );

       
          -- определяем признак Создание/Корректировка
          vbIsInsert:= COALESCE (vbId_mi, 0) = 0;

          -- если был удален
          IF EXISTS (SELECT 1 FROM MovementItem WHERE Id = vbId_mi AND isErased = TRUE)
          THEN
              -- восстановим + изменение !!!т.к. может измениться ObjectId + MovementId!!!
              UPDATE MovementItem SET isErased = FALSE, ObjectId = vbMemberId, MovementId = ioMovementId WHERE Id = vbId_mi;
          ELSE
              -- ВСЕГДА - сохранили <Элемент документа> - <кто сформировал визу "Вывезено со склада">
              vbId_mi := lpInsertUpdate_MovementItem (vbId_mi, zc_MI_Master(), vbMemberId, ioMovementId, 0, NULL);

              -- !!!т.к. может измениться MovementId!!!
              UPDATE MovementItem SET MovementId = ioMovementId WHERE Id = vbId_mi;

          END IF;

          -- сохранили <когда сформирована виза "Вывезено со склада">   
          PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), vbId_mi, CURRENT_TIMESTAMP);


          -- сохранили свойство у документа продажи <№ строчной части в Реестре накладных>
          PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_MovementItemId(), vbMovementId_sale, vbId_mi);
          -- сохранили у документа продажи связь с <Состояние по реестру>
          PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ReestrKind(), vbMovementId_sale, zc_Enum_ReestrKind_PartnerOut());


          -- сохранили протокол
          PERFORM lpInsert_MovementItemProtocol (vbId_mi, vbUserId, vbIsInsert);

      END IF; -- if Только если есть продажа

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 22.10.16         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MI_ReestrStart (inBarCode:= '4323306', inOperDate:= '23.10.2016', inCarId:= 340655, inPersonalDriverId:= 0, inMemberId:= 0, ioMovementId_TransportTop:= 2298218, inSession:= '5');
