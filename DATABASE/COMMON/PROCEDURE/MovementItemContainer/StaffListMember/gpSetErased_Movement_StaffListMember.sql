-- Function: gpSetErased_Movement_StaffListMember (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_StaffListMember (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_StaffListMember(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbMemberId Integer;
  DECLARE vbMovementId_last Integer;
  DECLARE vbOperDate TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_StaffListMember());

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
                           SELECT Movement.Id
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
          RAISE EXCEPTION 'Ошибка.Удаление запрещено. Есть более поздние документы.';  
     END IF;  
     
     IF COALESCE (vbMovementId_last,0) = 0
     THEN
         --пересохраняем предыдущее значение должности и пр. из предыдущего документа
         PERFORM lpUpate_Object_Personal_Old (inMovementId, inSession);
     
     
         -- Удаляем Документ
         PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                     , inUserId     := vbUserId);

     END IF;

     --if vbUserId = 9457 then RAISE EXCEPTION 'Админ.Test Ok.';  end if;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.09.25         *
*/

-- тест
-- SELECT * FROM gpSetErased_Movement_StaffListMember (inMovementId:= 0, inSession:= zfCalc_UserAdmin())
