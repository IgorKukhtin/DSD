-- Function: gpComplete_Movement_StaffListMember()

DROP FUNCTION IF EXISTS gpComplete_Movement_StaffListMember (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_StaffListMember(
    IN inMovementId        Integer                , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''      -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbMemberId Integer;
  DECLARE vbMovementId_last Integer;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_StaffList());
      vbUserId:= lpGetUserBySession (inSession);

     -- проверить нет ли документа после 
     SELECT Movement.OperDate
          , MovementLinkObject_Member.ObjectId AS MemberId
    INTO vbOperDate, vbMemberId
     FROM Movement
          INNER JOIN MovementLinkObject AS MovementLinkObject_Member
                                        ON MovementLinkObject_Member.MovementId = Movement.Id
                                       AND MovementLinkObject_Member.DescId = zc_MovementLinkObject_Member()
     WHERE Movement.Id = inMovementId
     ;

     vbMovementId_last := (--проверка на наличие хоть одного документа после текущего
                           SELECT Movement.*
                           FROM Movement 
                                INNER JOIN MovementLinkObject AS MovementLinkObject_Member
                                                              ON MovementLinkObject_Member.MovementId = Movement.Id
                                                             AND MovementLinkObject_Member.DescId = zc_MovementLinkObject_Member()
                                                             AND MovementLinkObject_Member.ObjectId = vbMemberId
                           WHERE Movement.DescId = zc_Movement_StaffListMember()
                             AND Movement.OperDate >= vbOperDate
                             AND Movement.StatusId = zc_Enum_Status_Complete()
                             AND Movement.Id <> inMovementId
                           LIMIT 1
                           );

     IF COALESCE (vbMovementId_last,0) <> 0
     THEN
          RAISE EXCEPTION 'Ошибка.Проведение запрещено. Есть более поздние документы. ';  
     END IF;  


      -- проводим Документ + сохранили протокол
      PERFORM lpComplete_Movement (inMovementId := inMovementId
                                 , inDescId     := zc_Movement_StaffListMember()
                                 , inUserId     := vbUserId
                                  );

     if vbUserId = 9457 then RAISE EXCEPTION 'Админ.Test Ok.';  end if;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.09.25         *
 */

-- тест
--