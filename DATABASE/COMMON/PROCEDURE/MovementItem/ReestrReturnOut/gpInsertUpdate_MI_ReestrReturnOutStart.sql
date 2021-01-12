-- Function: gpInsertUpdate_MI_ReestrReturnOutStart()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ReestrReturnOutStart (Integer, TDateTime, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_ReestrReturnOutStart(
 INOUT ioMovementId               Integer   , -- Ключ объекта <Документ>
    IN inOperDate                 TDateTime , -- Дата документа
    IN inBarCode                  TVarChar  , -- Ш/к документа <Приход>
    IN inSession                  TVarChar    -- сессия пользователя
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbIsFindOnly      Boolean;
   DECLARE vbIsInsert        Boolean;
   DECLARE vbId_mi           Integer;
   DECLARE vbMovementId_ReturnOut Integer;
   DECLARE vbMemberId        Integer; -- <Физическое лицо> - кто сформировал визу "Вывезено со склада"
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ReestrReturnOut());
     
     -- определяется что это режим Find ioMovementId, и если не нашли, тогда будет Insert
     vbIsFindOnly:= COALESCE (ioMovementId, 0) = 0 AND TRIM (inBarCode) = '';


     -- если меняется Путевой лист - будет режим Find !!!другой!!! ioMovementId
     IF ioMovementId > 0 AND NOT EXISTS (SELECT 1 FROM MovementLinkObject AS MLО WHERE MLО.MovementId = ioMovementId AND MLО.DescId = zc_MovementLinkObject_Insert())
     THEN
         ioMovementId:= 0;
         vbIsFindOnly:= TRUE;
     END IF;


     -- найдем Документ <Реестр накладных>
     IF COALESCE (ioMovementId, 0) = 0
     THEN
          ioMovementId:= COALESCE ((SELECT MLО.MovementId
                                    FROM MovementLinkObject AS MLО
                                         INNER JOIN Movement ON Movement.Id       = MLО.MovementId
                                                            AND Movement.DescId   = zc_Movement_ReestrReturnOut()
                                                            AND Movement.StatusId = zc_Enum_Status_Erased()
                                                            AND Movement.OperDate = inoperdate
                                    WHERE MLО.ObjectId = vbUserId
                                      AND MLО.DescId = zc_MovementLinkObject_Insert()
                                   ), 0);
          -- криво, но если не нашли - сделаем Insert
          IF ioMovementId = 0
          THEN
              vbIsFindOnly:= FALSE;
          END IF;
     END IF;


     -- найдем приход
     IF TRIM (inBarCode) <> ''
     THEN
         IF CHAR_LENGTH (inBarCode) >= 13
         THEN -- по штрих коду, но для "проверки" ограничение - 33 DAY
              vbMovementId_ReturnOut:= (SELECT Movement.Id
                                     FROM (SELECT zfConvert_StringToNumber (SUBSTR (inBarCode, 4, 13-4)) AS MovementId
                                          ) AS tmp
                                          INNER JOIN Movement ON Movement.Id = tmp.MovementId
                                                             AND Movement.DescId IN (zc_Movement_ReturnOut(), zc_Movement_ReturnOut())
                                                             AND Movement.OperDate BETWEEN CURRENT_DATE - INTERVAL '270 DAY' AND CURRENT_DATE + INTERVAL '8 DAY'
                                                             AND Movement.StatusId <> zc_Enum_Status_Erased()
                                    );
         ELSE -- по InvNumber, но для скорости ограничение - 8 DAY
              vbMovementId_ReturnOut:= (SELECT Movement.Id
                                     FROM Movement
                                     WHERE Movement.InvNumber = TRIM (inBarCode)
                                       AND Movement.DescId    IN (zc_Movement_ReturnOut(), zc_Movement_ReturnOut())
                                       AND Movement.OperDate BETWEEN CURRENT_DATE - INTERVAL '70 DAY' AND CURRENT_DATE + INTERVAL '8 DAY'
                                       AND Movement.StatusId <> zc_Enum_Status_Erased()
                                    );
         END IF;

         -- Проверка
         IF COALESCE (vbMovementId_ReturnOut, 0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Документ <Приход от поставщика> с № <%> не найден.', inBarCode;
         END IF;

         -- Проверка
         IF EXISTS (SELECT Object_Route.ValueData
                    FROM MovementLinkMovement AS MLM_Order
                         LEFT JOIN MovementLinkObject AS MLO_Route
                                                      ON MLO_Route.MovementId = MLM_Order.MovementChildId
                                                     AND MLO_Route.DescId     = zc_MovementLinkObject_Route()
                         LEFT JOIN Object AS Object_Route ON Object_Route.Id = MLO_Route.ObjectId
                    WHERE MLM_Order.MovementId = vbMovementId_ReturnOut
                      AND MLM_Order.DescId     = zc_MovementLinkMovement_Order()
                      AND Object_Route.ValueData ILIKE '%самовывоз%'
                   )
         THEN
             RAISE EXCEPTION 'Ошибка.Документ <Приход от поставщика> № <%> от <%> привязан к маршруту <%>.Добавление в реестр запрещено.'
                           , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = vbMovementId_ReturnOut)
                           , zfConvert_DateToString ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = vbMovementId_ReturnOut))
                           , (SELECT Object_Route.ValueData
                              FROM MovementLinkMovement AS MLM_Order
                                   LEFT JOIN MovementLinkObject AS MLO_Route
                                                                ON MLO_Route.MovementId = MLM_Order.MovementChildId
                                                               AND MLO_Route.DescId     = zc_MovementLinkObject_Route()
                                   LEFT JOIN Object AS Object_Route ON Object_Route.Id = MLO_Route.ObjectId
                              WHERE MLM_Order.MovementId = vbMovementId_ReturnOut
                                AND MLM_Order.DescId     = zc_MovementLinkMovement_Order()
                                AND Object_Route.ValueData ILIKE '%самовывоз%'
                             )
                           ;
         END IF;

     END IF;


     -- только в этом случае - ничего не делаем
     IF vbIsFindOnly                   = TRUE
     THEN
         RETURN; -- !!!выход!!!
     END IF;


     -- ВСЕГДА - сохранение Movement
     ioMovementId:= lpInsertUpdate_Movement_ReestrReturnOut (ioId               := ioMovementId
                                                        , inInvNumber        := CASE WHEN ioMovementId <> 0 THEN (SELECT InvNumber FROM Movement WHERE Id = ioMovementId) ELSE CAST (NEXTVAL ('Movement_ReestrReturnOut_seq') AS TVarChar) END
                                                          -- меняется дата как в Scale для BranchCode = 1
                                                        , inOperDate         := -- CASE WHEN ioMovementId <> 0 THEN (SELECT OperDate  FROM Movement WHERE Id = ioMovementId) ELSE CURRENT_DATE :: TDateTime END
                                                                                gpGet_Scale_OperDate (inIsCeh      := FALSE
                                                                                                    , inBranchCode := 1
                                                                                                    , inSession    := inSession
                                                                                                     )
                                                        , inUserId           := vbUserId
                                                         );

      -- Только если есть Приход
      IF vbMovementId_ReturnOut <> 0
      THEN
          -- Определяется <Физическое лицо> - кто сформировал визу "Получено от клиента"
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
              RAISE EXCEPTION 'Ошибка.У пользователя <%> не определно значение <Физ.лицо>.', lfGet_Object_ValueData (vbUserId);
          END IF;

          -- Поиск элемента для документа <приход>
          vbId_mi:= (SELECT MF_MovementItemId.ValueData :: Integer
                     FROM MovementFloat AS MF_MovementItemId
                     WHERE MF_MovementItemId.MovementId = vbMovementId_ReturnOut
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
              -- ВСЕГДА - сохранили <Элемент документа> - <кто сформировал визу "Получено от клиента">
              vbId_mi := lpInsertUpdate_MovementItem (vbId_mi, zc_MI_Master(), vbMemberId, ioMovementId, 0, NULL);

              -- !!!т.к. может измениться MovementId!!!
              UPDATE MovementItem SET MovementId = ioMovementId WHERE Id = vbId_mi;

          END IF;

          -- сохранили <когда сформирована виза "Получено от клиента>   
          PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), vbId_mi, CURRENT_TIMESTAMP);


          -- сохранили свойство у документа Прихода <№ строчной части в Реестре накладных>
          PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_MovementItemId(), vbMovementId_ReturnOut, vbId_mi);
          -- сохранили у документа Прихода связь с <Состояние по реестру>
          PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ReestrKind(), vbMovementId_ReturnOut, zc_Enum_ReestrKind_PartnerIn());


          -- сохранили протокол
          PERFORM lpInsert_MovementItemProtocol (vbId_mi, vbUserId, vbIsInsert);

      END IF; -- if Только если есть продажа

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.01.21         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MI_ReestrReturnOutStart (inBarCode:= '4323306', inOperDate:= '23.10.2016', inCarId:= 340655, inPersonalDriverId:= 0, inMemberId:= 0, ioMovementId_TransportTop:= 2298218, inSession:= '5');
