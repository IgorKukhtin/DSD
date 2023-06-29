-- Function: gpUpdate_MI_Reestr()

DROP FUNCTION IF EXISTS gpUpdate_MI_Reestr (TVarChar, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_Reestr(
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
   DECLARE vbMovementId_sale Integer;
   DECLARE vbMovementId_reestr Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Reestr());
     

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


     -- Проверка
     IF inMemberId = 0 AND inReestrKindId IN (zc_Enum_ReestrKind_PartnerIn(), zc_Enum_ReestrKind_RemakeIn())
     THEN
         -- должен быть кто сдал документ для визы
         RAISE EXCEPTION 'Ошибка.Для визы <%> не определен <Экспедитор / Водитель (от кого получена накладная)>.', lfGet_Object_ValueData (inReestrKindId);
     ELSEIF inMemberId <> 0 AND inReestrKindId NOT IN (zc_Enum_ReestrKind_PartnerIn(), zc_Enum_ReestrKind_RemakeIn())
     THEN
         -- НЕ должно быть кто сдал документ для визы
         RAISE EXCEPTION 'Ошибка.Для визы <%> значение <Экспедитор / Водитель (от кого получена накладная)> должно быть пустым.', lfGet_Object_ValueData (inReestrKindId);
     END IF;


     -- 1. найдем Продажу покупателю
     IF CHAR_LENGTH (inBarCode) >= 13
     THEN -- по штрих коду, но для "проверки" ограничение - 4 MONTH
          vbMovementId_sale:= (SELECT Movement.Id
                               FROM (SELECT zfConvert_StringToNumber (SUBSTR (inBarCode, 4, 13-4)) AS MovementId
                                    ) AS tmp
                                    INNER JOIN Movement ON Movement.Id     = tmp.MovementId
                                                       AND Movement.DescId IN (zc_Movement_Sale(), zc_Movement_SendOnPrice())
                                                       AND Movement.OperDate >= CURRENT_DATE - INTERVAL '12 MONTH'
                                                       AND Movement.StatusId <> zc_Enum_Status_Erased()
                              );
          -- продолжаем поиск - еще 12 MONTH
          IF COALESCE (vbMovementId_sale, 0) = 0
          THEN -- по штрих коду, но для "проверки" ограничение - 4 MONTH
               vbMovementId_sale:= (SELECT Movement.Id
                                    FROM (SELECT zfConvert_StringToNumber (SUBSTR (inBarCode, 4, 13-4)) AS MovementId
                                         ) AS tmp
                                         INNER JOIN Movement ON Movement.Id     = tmp.MovementId
                                                            AND Movement.DescId IN (zc_Movement_Sale(), zc_Movement_SendOnPrice())
                                                            AND Movement.OperDate BETWEEN CURRENT_DATE - INTERVAL '24 MONTH' AND CURRENT_DATE - INTERVAL '12 MONTH'
                                                            AND Movement.StatusId <> zc_Enum_Status_Erased()
                                   );
          END IF;

     ELSE -- по InvNumber, но для скорости ограничение - 12 MONTH
          vbMovementId_sale:= (SELECT Movement.Id
                               FROM Movement
                               WHERE Movement.InvNumber = TRIM (inBarCode)
                                 AND Movement.DescId    IN (zc_Movement_Sale(), zc_Movement_SendOnPrice())
                                 AND Movement.OperDate >= CURRENT_DATE - INTERVAL '12 MONTH'
                                 AND Movement.StatusId <> zc_Enum_Status_Erased()
                              );
          -- продолжаем поиск - еще 12 MONTH
          IF COALESCE (vbMovementId_sale, 0) = 0
          THEN -- по штрих коду, но для "проверки" ограничение - 12 MONTH
               vbMovementId_sale:= (SELECT Movement.Id
                                    FROM Movement
                                    WHERE Movement.InvNumber = TRIM (inBarCode)
                                      AND Movement.DescId    IN (zc_Movement_Sale(), zc_Movement_SendOnPrice())
                                      AND Movement.OperDate BETWEEN CURRENT_DATE - INTERVAL '24 MONTH' AND CURRENT_DATE - INTERVAL '12 MONTH'
                                      AND Movement.StatusId <> zc_Enum_Status_Erased()
                                   );
          END IF;
     END IF;

     -- 2. найдем Продажу покупателю
     IF CHAR_LENGTH (inBarCode) >= 13 AND COALESCE (vbMovementId_sale, 0) = 0
     THEN -- по штрих коду, но для "проверки" ограничение - 4 MONTH
          vbMovementId_sale:= (SELECT Movement.Id
                               FROM (SELECT zfConvert_StringToNumber (SUBSTR (inBarCode, 4, 13-4)) AS MovementId
                                    ) AS tmp
                                    INNER JOIN Movement ON Movement.Id     = tmp.MovementId
                                                       AND Movement.DescId IN (zc_Movement_Sale(), zc_Movement_SendOnPrice())
                                                       AND Movement.OperDate >= CURRENT_DATE - INTERVAL '24 MONTH'
                                                       AND Movement.StatusId <> zc_Enum_Status_Erased()
                              );
     ELSEIF COALESCE (vbMovementId_sale, 0) = 0
     THEN -- по InvNumber, но для скорости ограничение - 4 MONTH
          vbMovementId_sale:= (SELECT Movement.Id
                               FROM Movement
                               WHERE Movement.InvNumber = TRIM (inBarCode)
                                 AND Movement.DescId    IN (zc_Movement_Sale(), zc_Movement_SendOnPrice())
                                 AND Movement.OperDate >= CURRENT_DATE - INTERVAL '24 MONTH'
                                 AND Movement.StatusId <> zc_Enum_Status_Erased()
                              );
     END IF;


     -- Проверка
     IF COALESCE (vbMovementId_sale, 0) = 0
     THEN
         IF CHAR_LENGTH (inBarCode) >= 13 AND EXISTS (SELECT Movement.Id
                                                      FROM (SELECT zfConvert_StringToNumber (SUBSTR (inBarCode, 4, 13-4)) AS MovementId
                                                           ) AS tmp
                                                           INNER JOIN Movement ON Movement.Id     = tmp.MovementId
                                                                              AND Movement.DescId IN (zc_Movement_Sale(), zc_Movement_SendOnPrice())
                                                                              AND Movement.OperDate >= CURRENT_DATE - INTERVAL '24 MONTH'
                                                                              AND Movement.StatusId = zc_Enum_Status_Erased()
                                                     )
         THEN
             RAISE EXCEPTION 'Ошибка.Документ <Продажа покупателю> № <%> от <%> удален.(%)'
                           , inBarCode
                           , (SELECT Movement.InvNumber
                              FROM (SELECT zfConvert_StringToNumber (SUBSTR (inBarCode, 4, 13-4)) AS MovementId
                                   ) AS tmp
                                   INNER JOIN Movement ON Movement.Id     = tmp.MovementId
                                                      AND Movement.DescId IN (zc_Movement_Sale(), zc_Movement_SendOnPrice())
                                                      AND Movement.OperDate >= CURRENT_DATE - INTERVAL '24 MONTH'
                                                      AND Movement.StatusId = zc_Enum_Status_Erased()
                              ORDER BY Movement.OperDate DESC
                              LIMIT 1
                             )
                           , (SELECT zfConvert_DateToString (Movement.OperDate)
                              FROM (SELECT zfConvert_StringToNumber (SUBSTR (inBarCode, 4, 13-4)) AS MovementId
                                   ) AS tmp
                                   INNER JOIN Movement ON Movement.Id     = tmp.MovementId
                                                      AND Movement.DescId IN (zc_Movement_Sale(), zc_Movement_SendOnPrice())
                                                      AND Movement.OperDate >= CURRENT_DATE - INTERVAL '24 MONTH'
                                                      AND Movement.StatusId = zc_Enum_Status_Erased()
                              ORDER BY Movement.OperDate DESC
                              LIMIT 1
                             )
                            ;
         ELSE
             RAISE EXCEPTION 'Ошибка.Документ <Продажа покупателю> с Ш/К = <%> не найден.', inBarCode;
         END IF;

     END IF;

     -- найдем элемент
     vbId_mi:= (SELECT MF_MovementItemId.ValueData ::Integer AS Id
                FROM MovementFloat AS MF_MovementItemId 
                WHERE MF_MovementItemId.MovementId = vbMovementId_sale
                  AND MF_MovementItemId.DescId     = zc_MovementFloat_MovementItemId()
               );
     -- Проверка
     IF COALESCE (vbId_mi, 0) = 0
     THEN
         -- RAISE EXCEPTION 'Ошибка.Документ <Продажа покупателю> с № <%> не зарегистрирован в реестре.', inBarCode;
         --
         -- Попробуем найти "пустышку"
         vbMovementId_reestr:= (SELECT Movement.Id
                                FROM Movement
                                     LEFT JOIN MovementLinkMovement AS MLM_Transport
                                                                    ON MLM_Transport.MovementId = Movement.Id
                                                                   AND MLM_Transport.DescId = zc_MovementLinkMovement_Transport()
                                WHERE Movement.OperDate = CURRENT_DATE
                                  AND Movement.DescId = zc_Movement_Reestr()
                                  AND Movement.StatusId <> zc_Enum_Status_Erased()
                                  AND MLM_Transport.MovementId IS NULL
                                LIMIT 1 -- Прийдется так "криво" обойти вариант если вдруг парраллельно создадут новый док.
                               );

         -- Если не нашли "пустышку"
         IF COALESCE (vbMovementId_reestr, 0) = 0
         THEN
             -- создаем
             vbMovementId_reestr:=
                    lpInsertUpdate_Movement_Reestr (ioId               := vbMovementId_reestr
                                                  , inInvNumber        := NEXTVAL ('Movement_Reestr_seq') :: TVarChar
                                                  , inOperDate         := CURRENT_DATE
                                                  , inCarId            := NULL
                                                  , inPersonalDriverId := NULL
                                                  , inMemberId         := NULL
                                                  , inMovementId_Transport := NULL
                                                  , inUserId           := -1 * vbUserId -- !!! с минусом, значит "пустышка"!!!
                                                   );
         END IF;

         -- сохранили <Элемент документа> - но "криво" <кто сформировал визу "Вывезено со склада">
         vbId_mi := lpInsertUpdate_MovementItem (vbId_mi, zc_MI_Master(), vbMemberId_user, vbMovementId_reestr, 0, NULL);

         -- сохранили свойство у документа продажи <№ строчной части в Реестре накладных>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_MovementItemId(), vbMovementId_sale, vbId_mi);

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
       -- сохранили связь с <кто сдал документ для визы "Получено от клиента">
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartnerInFrom(), vbId_mi, inMemberId);
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

    -- <Экономисты>
    IF inReestrKindId = zc_Enum_ReestrKind_Econom()
    THEN 
       -- сохранили <когда сформирована виза>
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Econom(), vbId_mi, CURRENT_TIMESTAMP);
       -- сохранили связь с <кто сформировал визу>
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Econom(), vbId_mi, vbMemberId_user);
    END IF;

    -- <Бухгалтерия>
    IF inReestrKindId = zc_Enum_ReestrKind_Buh()
    THEN 
       -- сохранили <когда сформирована виза>
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Buh(), vbId_mi, CURRENT_TIMESTAMP);
       -- сохранили связь с <кто сформировал визу>
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Buh(), vbId_mi, vbMemberId_user);
    END IF;

    -- <Транзит получен>
    IF inReestrKindId = zc_Enum_ReestrKind_TransferIn()
    THEN 
       -- сохранили <когда сформирована виза>
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_TransferIn(), vbId_mi, CURRENT_TIMESTAMP);
       -- сохранили связь с <кто сформировал визу>
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_TransferIn(), vbId_mi, vbMemberId_user);
    END IF;

    -- <Транзит возвращен>
    IF inReestrKindId = zc_Enum_ReestrKind_TransferOut()
    THEN 
       -- сохранили <когда сформирована виза>
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_TransferOut(), vbId_mi, CURRENT_TIMESTAMP);
       -- сохранили связь с <кто сформировал визу>
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_TransferOut(), vbId_mi, vbMemberId_user);
    END IF;

    -- <Выведен дубликат>
    IF inReestrKindId = zc_Enum_ReestrKind_Double()
    THEN 
       -- сохранили <когда сформирована виза>
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Double(), vbId_mi, CURRENT_TIMESTAMP);
       -- сохранили связь с <кто сформировал визу>
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Double(), vbId_mi, vbMemberId_user);
    END IF;

    -- <В наличии скан>
    IF inReestrKindId = zc_Enum_ReestrKind_Scan()
    THEN 
       -- сохранили <когда сформирована виза>
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Scan(), vbId_mi, CURRENT_TIMESTAMP);
       -- сохранили связь с <кто сформировал визу>
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Scan(), vbId_mi, vbMemberId_user);
    END IF;

    -- Установили "последнее" значение визы - <Состояние по реестру>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ReestrKind(), vbMovementId_sale, inReestrKindId);

    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (vbId_mi, vbUserId, FALSE);

    IF vbUserId = '5'
    THEN
        RAISE EXCEPTION 'Запретили Админу :)';
    END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 05.05.22         *
 17.11.20         *
 22.07.20         *
 20.07.17         *
 23.10.16         *
*/

-- тест
-- SELECT * FROM gpUpdate_MI_Reestr (inBarCode:= '4323306', inOperDate:= '23.10.2016', inCarId:= 340655, inPersonalDriverId:= 0, inMemberId:= 0, inDocumentId_Transport:= 2298218, inSession:= '5');
