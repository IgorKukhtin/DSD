-- Function: gpInsertUpdate_MI_ReestrReturnStart()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ReestrReturnStart (Integer, TDateTime, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_ReestrReturnStart(
 INOUT ioMovementId               Integer   , -- Ключ объекта <Документ>
    IN inOperDate                 TDateTime , -- Дата документа
    IN inBarCode                  TVarChar  , -- Ш/к документа <возврат>
    IN inSession                  TVarChar    -- сессия пользователя
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbIsFindOnly      Boolean;
   DECLARE vbIsInsert        Boolean;
   DECLARE vbId_mi           Integer;
   DECLARE vbMovementId_ReturnIn Integer;
   DECLARE vbMovementDescId_TransportTop Integer;
   DECLARE vbMemberId        Integer; -- <Физическое лицо> - кто сформировал визу ""
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ReestrReturn());
     
     -- определяется что это режим Find ioMovementId, и если не нашли, тогда будет Insert
     vbIsFindOnly:= COALESCE (ioMovementId, 0) = 0 AND TRIM (inBarCode) = '';

     -- если меняется Путевой лист - будет режим Find !!!другой!!! ioMovementId
     IF ioMovementId > 0 AND NOT EXISTS (SELECT 1 FROM MovementLinkObject AS MLО WHERE MLО.MovementId = ioMovementId AND MLО.DescId = zc_MovementLinkObject_Insert() /*AND COALESCE (MLM.MovementChildId, 0) = COALESCE (ioMovementId_TransportTop, 0)*/)
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
                                                            AND Movement.DescId   = zc_Movement_ReestrReturn()
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

     -- найдем Возврат
     IF TRIM (inBarCode) <> ''
     THEN
         IF CHAR_LENGTH (inBarCode) >= 13
         THEN -- по штрих коду, но для "проверки" ограничение - 33 DAY
              vbMovementId_ReturnIn:= (SELECT Movement.Id
                                       FROM (SELECT zfConvert_StringToNumber (SUBSTR (inBarCode, 4, 13-4)) AS MovementId
                                             ) AS tmp
                                         INNER JOIN Movement ON Movement.Id = tmp.MovementId
                                                            AND Movement.DescId = zc_Movement_ReturnIn()
                                                            AND Movement.OperDate BETWEEN CURRENT_DATE - INTERVAL '33 DAY' AND CURRENT_DATE + INTERVAL '8 DAY'
                                                            AND Movement.StatusId <> zc_Enum_Status_Erased()
                                       );

              -- продолжаем поиск - еще 100 DAY
              IF COALESCE (vbMovementId_ReturnIn, 0) = 0
              THEN
              vbMovementId_ReturnIn:= (SELECT Movement.Id
                                       FROM (SELECT zfConvert_StringToNumber (SUBSTR (inBarCode, 4, 13-4)) AS MovementId
                                             ) AS tmp
                                         INNER JOIN Movement ON Movement.Id = tmp.MovementId
                                                            AND Movement.DescId = zc_Movement_ReturnIn()
                                                            AND Movement.OperDate BETWEEN CURRENT_DATE - INTERVAL '133 DAY' AND CURRENT_DATE - INTERVAL '33 DAY'
                                                            AND Movement.StatusId <> zc_Enum_Status_Erased()
                                       );
              END IF;
              
              -- продолжаем поиск - еще 100 DAY
              IF COALESCE (vbMovementId_ReturnIn, 0) = 0
              THEN
              vbMovementId_ReturnIn:= (SELECT Movement.Id
                                       FROM (SELECT zfConvert_StringToNumber (SUBSTR (inBarCode, 4, 13-4)) AS MovementId
                                             ) AS tmp
                                         INNER JOIN Movement ON Movement.Id = tmp.MovementId
                                                            AND Movement.DescId = zc_Movement_ReturnIn()
                                                            AND Movement.OperDate BETWEEN CURRENT_DATE - INTERVAL '233 DAY' AND CURRENT_DATE - INTERVAL '133 DAY'
                                                            AND Movement.StatusId <> zc_Enum_Status_Erased()
                                       );
              END IF;

              -- продолжаем поиск - еще 100 DAY
              IF COALESCE (vbMovementId_ReturnIn, 0) = 0
              THEN
              vbMovementId_ReturnIn:= (SELECT Movement.Id
                                       FROM (SELECT zfConvert_StringToNumber (SUBSTR (inBarCode, 4, 13-4)) AS MovementId
                                             ) AS tmp
                                         INNER JOIN Movement ON Movement.Id = tmp.MovementId
                                                            AND Movement.DescId = zc_Movement_ReturnIn()
                                                            AND Movement.OperDate BETWEEN CURRENT_DATE - INTERVAL '333 DAY' AND CURRENT_DATE - INTERVAL '233 DAY'
                                                            AND Movement.StatusId <> zc_Enum_Status_Erased()
                                       );
              END IF;

              -- продолжаем поиск - еще 100 DAY
              IF COALESCE (vbMovementId_ReturnIn, 0) = 0
              THEN
              vbMovementId_ReturnIn:= (SELECT Movement.Id
                                       FROM (SELECT zfConvert_StringToNumber (SUBSTR (inBarCode, 4, 13-4)) AS MovementId
                                             ) AS tmp
                                         INNER JOIN Movement ON Movement.Id = tmp.MovementId
                                                            AND Movement.DescId = zc_Movement_ReturnIn()
                                                            AND Movement.OperDate BETWEEN CURRENT_DATE - INTERVAL '433 DAY' AND CURRENT_DATE - INTERVAL '333 DAY'
                                                            AND Movement.StatusId <> zc_Enum_Status_Erased()
                                       );
              END IF;

         ELSE -- по InvNumber, но для скорости ограничение - 8 DAY
              vbMovementId_ReturnIn:= (SELECT Movement.Id
                                       FROM Movement
                                       WHERE Movement.InvNumber = TRIM (inBarCode)
                                         AND Movement.DescId = zc_Movement_ReturnIn()
                                         AND Movement.OperDate BETWEEN CURRENT_DATE - INTERVAL '8 DAY' AND CURRENT_DATE + INTERVAL '8 DAY'
                                         AND Movement.StatusId <> zc_Enum_Status_Erased()
                                       );
         END IF;

         -- Проверка
         IF COALESCE (vbMovementId_ReturnIn, 0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Документ <Возврат покупателя> с № <%> не найден.', inBarCode;
         END IF;

     END IF;


     -- только в этом случае - ничего не делаем
     IF vbIsFindOnly = TRUE
     THEN
         RETURN; -- !!!выход!!!
     END IF;

     -- ВСЕГДА - сохранение Movement
     ioMovementId:= lpInsertUpdate_Movement_ReestrReturn (ioId               := ioMovementId
                                                        , inInvNumber        := CASE WHEN ioMovementId <> 0 THEN (SELECT InvNumber FROM Movement WHERE Id = ioMovementId) ELSE CAST (NEXTVAL ('Movement_ReestrReturn_seq') AS TVarChar) END
                                                        -- меняется дата как в Scale для BranchCode = 1
                                                        , inOperDate         := -- CASE WHEN ioMovementId <> 0 THEN (SELECT OperDate  FROM Movement WHERE Id = ioMovementId) ELSE CURRENT_DATE :: TDateTime END
                                                                               gpGet_Scale_OperDate (inIsCeh      := FALSE
                                                                                                   , inBranchCode := 1
                                                                                                   , inSession    := inSession
                                                                                                   )
                                                        , inUserId           := vbUserId
                                                        );

      -- Только если есть возврат
      IF vbMovementId_ReturnIn <> 0
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
              RAISE EXCEPTION 'Ошибка.У пользователя <%> не определно значение <Физ.лицо>.', lfGet_Object_ValueData (vbUserId);
          END IF;

          -- Поиск элемента для документа <возврат>
          vbId_mi:= (SELECT MF_MovementItemId.ValueData :: Integer
                     FROM MovementFloat AS MF_MovementItemId
                     WHERE MF_MovementItemId.MovementId = vbMovementId_ReturnIn
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
              -- ВСЕГДА - сохранили <Элемент документа> - <кто сформировал визу "">
              vbId_mi := lpInsertUpdate_MovementItem (vbId_mi, zc_MI_Master(), vbMemberId, ioMovementId, 0, NULL);

              -- !!!т.к. может измениться MovementId!!!
              UPDATE MovementItem SET MovementId = ioMovementId WHERE Id = vbId_mi;

          END IF;

          -- сохранили <когда сформирована виза "">   
          PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), vbId_mi, CURRENT_TIMESTAMP);


          -- сохранили свойство у документа возврата <№ строчной части в Реестре накладных>
          PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_MovementItemId(), vbMovementId_ReturnIn, vbId_mi);
          -- сохранили у документа продажи связь с <Состояние по реестру>
          PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ReestrKind(), vbMovementId_ReturnIn, zc_Enum_ReestrKind_PartnerIn());


          -- сохранили протокол
          PERFORM lpInsert_MovementItemProtocol (vbId_mi, vbUserId, vbIsInsert);

      END IF; -- if Только если есть продажа

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.03.17         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MI_ReestrReturnStart (inBarCode:= '4323306', inOperDate:= '23.10.2016', inCarId:= 340655, inPersonalDriverId:= 0, inMemberId:= 0, ioMovementId_TransportTop:= 2298218, inSession:= '5');
