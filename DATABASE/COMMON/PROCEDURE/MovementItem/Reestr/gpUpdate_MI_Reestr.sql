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
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Reestr());
     

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


     -- Проверка - должен быть кто сдал документ для визы
     IF inMemberId = 0 AND inReestrKindId IN (zc_Enum_ReestrKind_PartnerIn(), zc_Enum_ReestrKind_RemakeIn())
     THEN
         RAISE EXCEPTION 'Ошибка.Для визы <%> не определен <Экспедитор / Водитель (от кого получена накладная)>.', lfGet_Object_ValueData (inReestrKindId);
     ELSEIF inMemberId <> 0 AND inReestrKindId NOT IN (zc_Enum_ReestrKind_PartnerIn(), zc_Enum_ReestrKind_RemakeIn())
     THEN
         RAISE EXCEPTION 'Ошибка.Для визы <%> значение <Экспедитор / Водитель (от кого получена накладная)> должно быть пустым.', lfGet_Object_ValueData (inReestrKindId);
     END IF;


     -- найдем Продажу покупателю
     IF CHAR_LENGTH (inBarCode) >= 13
     THEN -- по штрих коду, но для "проверки" ограничение - 4 MONTH
          vbMovementId_sale:= (SELECT Movement.Id
                               FROM (SELECT zfConvert_StringToNumber (SUBSTR (inBarCode, 4, 13-4)) AS MovementId
                                    ) AS tmp
                                    INNER JOIN Movement ON Movement.Id = tmp.MovementId
                                                       AND Movement.DescId = zc_Movement_Sale()
                                                       AND Movement.OperDate >= CURRENT_DATE - INTERVAL '4 MONTH'
                                                       AND Movement.StatusId <> zc_Enum_Status_Erased()
                              );
     ELSE -- по InvNumber, но для скорости ограничение - 4 MONTH
          vbMovementId_sale:= (SELECT Movement.Id
                               FROM Movement
                               WHERE Movement.InvNumber = TRIM (inBarCode)
                                 AND Movement.DescId = zc_Movement_Sale()
                                 AND Movement.OperDate >= CURRENT_DATE - INTERVAL '4 MONTH'
                                 AND Movement.StatusId <> zc_Enum_Status_Erased()
                              );
     END IF;

     -- Проверка
     IF COALESCE (vbMovementId_sale, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Документ <Продажа покупателю> с № <%> не найден.', inBarCode;
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
         RAISE EXCEPTION 'Ошибка.Документ <Продажа покупателю> с № <%> не зарегистрирован в реестре.', inBarCode;
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


    -- <Бухгалтерия>
    IF inReestrKindId = zc_Enum_ReestrKind_Buh()
    THEN 
       -- сохранили <когда сформирована виза>
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Buh(), vbId_mi, CURRENT_TIMESTAMP);
       -- сохранили связь с <кто сформировал визу>
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Buh(), vbId_mi, vbMemberId_user);
    END IF;

    -- Установили "последнее" значение визы - <Состояние по реестру>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ReestrKind(), vbMovementId_sale, inReestrKindId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 23.10.16         *
*/

-- тест
-- SELECT * FROM gpUpdate_MI_Reestr (inBarCode:= '4323306', inOperDate:= '23.10.2016', inCarId:= 340655, inPersonalDriverId:= 0, inMemberId:= 0, inDocumentId_Transport:= 2298218, inSession:= '5');
