-- Function: gpUpdate_MI_ReestrTransportGoods()

DROP FUNCTION IF EXISTS gpUpdate_MI_ReestrTransportGoods (TVarChar, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_ReestrTransportGoods(
    IN inBarCode              TVarChar  , -- штрихкод документа продажи 
    IN inReestrKindId         Integer   , -- Тип состояния по реестру
    IN inMemberId             Integer   , -- Физические лица(водитель/экспедитор) кто сдал документ для визы
    IN inSession              TVarChar    -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbMemberId_user Integer;
   DECLARE vbId_mi Integer;
   DECLARE vbId_mi_find Integer;
   DECLARE vbMovementId_TTN Integer;
   DECLARE vbMovementId_reestr Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ReestrTransportGoods());
     

     -- только в этом случае - ничего не делаем, т.к. из дельфи вызывается "лишний" раз
     IF COALESCE (TRIM (inBarCode), '') = ''
     THEN
         RETURN; -- !!!выход!!!
     END IF;


     -- если 
     IF NOT EXISTS (SELECT 1 FROM Object WHERE Object.Id = inReestrKindId AND Object.DescId = zc_Object_ReestrKind())
     THEN
          RAISE EXCEPTION 'Ошибка.zc_Object_ReestrKind = <%> не определно значение.', lfGet_Object_ValueData (inReestrKindId);
     END IF;


     -- Определяется <Физическое лицо> - кто сформировал визу inReestrKindId
     vbMemberId_user:= CASE WHEN vbUserId = 5 THEN 9457 ELSE
                       (SELECT ObjectLink_User_Member.ChildObjectId
                        FROM ObjectLink AS ObjectLink_User_Member
                        WHERE ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                          AND ObjectLink_User_Member.ObjectId = vbUserId)
                       END
                      ;
     -- Проверка
     IF COALESCE (vbMemberId_user, 0) = 0
     THEN 
          RAISE EXCEPTION 'Ошибка.У пользователя <%> не определно значение <Физ.лицо>.', lfGet_Object_ValueData (vbUserId);
     END IF;

     -- найдем Возврат от покупателя
     IF CHAR_LENGTH (inBarCode) >= 13
     THEN -- по штрих коду, но для "проверки" ограничение - 4 MONTH
          vbMovementId_TTN:= (SELECT Movement.Id
                                   FROM (SELECT zfConvert_StringToNumber (SUBSTR (inBarCode, 4, 13-4)) AS MovementId
                                         ) AS tmp
                                       INNER JOIN Movement ON Movement.Id = tmp.MovementId
                                                          AND Movement.DescId = zc_Movement_TransportGoods()
                                                          AND Movement.OperDate >= CURRENT_DATE - INTERVAL '4 MONTH'
                                                          AND Movement.StatusId <> zc_Enum_Status_Erased()
                                   );
          -- продолжаем поиск - еще 4 MONTH
          IF COALESCE (vbMovementId_TTN, 0) = 0
          THEN
          vbMovementId_TTN:= (SELECT Movement.Id
                                   FROM (SELECT zfConvert_StringToNumber (SUBSTR (inBarCode, 4, 13-4)) AS MovementId
                                         ) AS tmp
                                       INNER JOIN Movement ON Movement.Id = tmp.MovementId
                                                          AND Movement.DescId = zc_Movement_TransportGoods()
                                                          AND Movement.OperDate BETWEEN CURRENT_DATE - INTERVAL '8 MONTH' AND CURRENT_DATE - INTERVAL '4 MONTH'
                                                          AND Movement.StatusId <> zc_Enum_Status_Erased()
                                   );
          END IF;

          -- продолжаем поиск - еще 4 MONTH
          IF COALESCE (vbMovementId_TTN, 0) = 0
          THEN
          vbMovementId_TTN:= (SELECT Movement.Id
                                   FROM (SELECT zfConvert_StringToNumber (SUBSTR (inBarCode, 4, 13-4)) AS MovementId
                                         ) AS tmp
                                       INNER JOIN Movement ON Movement.Id = tmp.MovementId
                                                          AND Movement.DescId = zc_Movement_TransportGoods()
                                                          AND Movement.OperDate BETWEEN CURRENT_DATE - INTERVAL '12 MONTH' AND CURRENT_DATE - INTERVAL '8 MONTH'
                                                          AND Movement.StatusId <> zc_Enum_Status_Erased()
                                   );
          END IF;

          -- продолжаем поиск - еще 12 MONTH
          IF COALESCE (vbMovementId_TTN, 0) = 0
          THEN
          vbMovementId_TTN:= (SELECT Movement.Id
                                   FROM (SELECT zfConvert_StringToNumber (SUBSTR (inBarCode, 4, 13-4)) AS MovementId
                                         ) AS tmp
                                       INNER JOIN Movement ON Movement.Id = tmp.MovementId
                                                          AND Movement.DescId = zc_Movement_TransportGoods()
                                                          AND Movement.OperDate BETWEEN CURRENT_DATE - INTERVAL '24 MONTH' AND CURRENT_DATE - INTERVAL '12 MONTH'
                                                          AND Movement.StatusId <> zc_Enum_Status_Erased()
                                   );
          END IF;

     ELSE -- проверка - т.к. InvNumber повторяется
          IF 1 < (SELECT COUNT(*)
                  FROM Movement
                  WHERE Movement.InvNumber = TRIM (inBarCode)
                    AND Movement.DescId = zc_Movement_TransportGoods()
                    AND Movement.OperDate >= CURRENT_DATE - INTERVAL '4 MONTH'
                    AND Movement.StatusId <> zc_Enum_Status_Erased()
                 )
          THEN
              RAISE EXCEPTION 'Ошибка.Нельзя однозначно определить по № <%> , т.к. с таким № несколько документов .', inBarCode;
          END IF;
          -- по InvNumber, но для скорости ограничение - 4 MONTH
          vbMovementId_TTN:= (SELECT Movement.Id
                                   FROM Movement
                                   WHERE Movement.InvNumber = TRIM (inBarCode)
                                     AND Movement.DescId = zc_Movement_TransportGoods()
                                     AND Movement.OperDate >= CURRENT_DATE - INTERVAL '4 MONTH'
                                     AND Movement.StatusId <> zc_Enum_Status_Erased()
                                  );
     END IF;

     -- Проверка
     IF COALESCE (vbMovementId_TTN, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Документ <Товаро-транспортная накладная> с № <%> не найден.', inBarCode;
     END IF;

     -- найдем элемент
     vbId_mi:= (SELECT MF_MovementItemId.ValueData ::Integer AS Id
                FROM MovementFloat AS MF_MovementItemId 
                WHERE MF_MovementItemId.MovementId = vbMovementId_TTN
                  AND MF_MovementItemId.DescId     = zc_MovementFloat_MovementItemId()
               );

     -- !!!ДОБАВИМ!!! элемент - через Parent
     IF COALESCE (vbId_mi, 0) = 0
     THEN
         vbId_mi_find:= (SELECT MF_MovementItemId.ValueData :: Integer AS Id
                         FROM MovementFloat AS MF_MovementItemId 
                         WHERE MF_MovementItemId.MovementId = (SELECT Movement.ParentId FROM Movement WHERE Movement.Id = vbMovementId_TTN)
                           AND MF_MovementItemId.DescId     = zc_MovementFloat_MovementItemId()
                        );
         -- если Parent существует
         IF vbId_mi_find > 0
         THEN
              -- сохранили <Элемент документа> - <кто сформировал визу "">
              vbId_mi := lpInsertUpdate_MovementItem (0, zc_MI_Master(), vbMemberId_user, (SELECT MovementItem.MovementId FROM MovementItem WHERE MovementItem.Id = vbId_mi_find), 0, NULL);
              -- сохранили <когда сформирована виза "">   
              PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), vbId_mi, CURRENT_TIMESTAMP);
              -- сохранили свойство у документа возврата <№ строчной части в Реестре накладных>
              PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_MovementItemId(), vbMovementId_TTN, vbId_mi);
         END IF;

     END IF;

     -- Проверка
     IF COALESCE (vbId_mi, 0) = 0
     THEN
         -- RAISE EXCEPTION 'Ошибка..', inBarCode;
         --
         -- Попробуем найти "пустышку"
         vbMovementId_reestr:= (SELECT Movement.Id
                                FROM Movement
                                     LEFT JOIN MovementLinkObject AS MLО
                                                                  ON MLО.MovementId = Movement.Id 
                                                                 AND MLО.DescId = zc_MovementLinkObject_Insert()
                                                                -- AND MLО.ObjectId = vbUserId
                                WHERE Movement.OperDate = CURRENT_DATE
                                  AND Movement.DescId = zc_Movement_ReestrTransportGoods()
                                  AND Movement.StatusId <> zc_Enum_Status_Erased()
                                  AND MLО.MovementId IS NULL
                                LIMIT 1 -- Прийдется так "криво" обойти вариант если вдруг парраллельно создадут новый док.
                               );

         -- Если не нашли "пустышку"
         IF COALESCE (vbMovementId_reestr, 0) = 0
         THEN
             -- создаем
             vbMovementId_reestr:=
              lpInsertUpdate_Movement_ReestrTransportGoods (ioId               := COALESCE (vbMovementId_reestr, 0)
                                                  , inInvNumber        := NEXTVAL ('Movement_ReestrTransportGoods_seq') :: TVarChar
                                                  , inOperDate         := CURRENT_DATE
                                                  , inUserId           := -1 * vbUserId -- !!! с минусом, значит "пустышка"!!!
                                                   );
         END IF;

         -- сохранили <Элемент документа> - но "криво" <кто сформировал визу "Вывезено со склада">
         vbId_mi := lpInsertUpdate_MovementItem (vbId_mi, zc_MI_Master(), vbMemberId_user, vbMovementId_reestr, 0, NULL);

         -- сохранили свойство у документа ТТН <№ строчной части в Реестре накладных>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_MovementItemId(), vbMovementId_TTN, vbId_mi);

     END IF; -- if COALESCE (vbId_mi, 0) = 0

    -- <Отдел логистики>
    IF inReestrKindId = zc_Enum_ReestrKind_Log()
    THEN 
       -- сохранили <когда сформирована виза>
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Log(), vbId_mi, CURRENT_TIMESTAMP);
       -- сохранили связь с <кто сформировал визу>
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Log(), vbId_mi, vbMemberId_user);
    END IF;
    
    -- <Получено от клиента>
    IF inReestrKindId = zc_Enum_ReestrKind_PartnerIn()
    THEN 
       -- сохранили <когда сформирована виза>
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartnerIn(), vbId_mi, CURRENT_TIMESTAMP);
       -- сохранили связь с <кто сформировал визу>
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartnerInTo(), vbId_mi, vbMemberId_user);
    END IF;

    -- <Получено для переделки>
    IF inReestrKindId = zc_Enum_ReestrKind_RemakeIn()
    THEN 
       -- сохранили <когда сформирована виза>
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_RemakeIn(), vbId_mi, CURRENT_TIMESTAMP);
       -- сохранили связь с <кто сформировал визу>
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_RemakeInTo(), vbId_mi, vbMemberId_user);
       -- сохранили связь с <кто сдал документ для визы "Получено для переделки">
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_RemakeInFrom(), vbId_mi, inMemberId);
    END IF;
    

    -- <Бухгалтерия для исправления>
    IF inReestrKindId = zc_Enum_ReestrKind_RemakeBuh()
    THEN 
       -- сохранили <когда сформирована виза>
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_RemakeBuh(), vbId_mi, CURRENT_TIMESTAMP);
       -- сохранили связь с <кто сформировал визу>
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_RemakeBuh(), vbId_mi, vbMemberId_user);
    END IF;


    -- <Документ исправлен>
    IF inReestrKindId = zc_Enum_ReestrKind_Remake()
    THEN 
       -- сохранили <когда сформирована виза>
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Remake(), vbId_mi, CURRENT_TIMESTAMP);
       -- сохранили связь с <кто сформировал визу>
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Remake(), vbId_mi, vbMemberId_user);
    END IF;


    -- <Бухгалтерия>
    IF inReestrKindId = zc_Enum_ReestrKind_Buh()
    THEN 
       -- сохранили <когда сформирована виза>
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Buh(), vbId_mi, CURRENT_TIMESTAMP);
       -- сохранили связь с <кто сформировал визу>
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Buh(), vbId_mi, vbMemberId_user);
    END IF;

    -- Установили "последнее" значение визы - <Состояние по реестру>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ReestrKind(), vbMovementId_TTN, inReestrKindId);

    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (vbId_mi, vbUserId, FALSE);

    /*IF vbUserId = 5
    THEN
        RAISE EXCEPTION 'Запретили Админу :)';
    END IF;
*/

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.07.20         *
 01.02.20         *
*/

-- тест
-- SELECT * FROM gpUpdate_MI_ReestrTransportGoods (inBarCode:= '4323306', inOperDate:= '23.10.2016', inCarId:= 340655, inPersonalDriverId:= 0, inMemberId:= 0, inDocumentId_Transport:= 2298218, inSession:= '5');
