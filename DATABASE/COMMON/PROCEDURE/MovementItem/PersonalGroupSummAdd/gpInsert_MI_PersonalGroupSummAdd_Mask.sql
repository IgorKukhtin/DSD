-- Function: gpInsert_MI_PersonalGroupSummAdd_Last()

DROP FUNCTION IF EXISTS gpInsert_MI_PersonalGroupSummAdd_Last (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MI_PersonalGroupSummAdd_Last(
    IN inMovementId          Integer   , -- Ключ объекта <Документ >
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Void AS
$BODY$
   DECLARE vbMovementId_mask Integer;
   DECLARE vbUserId Integer;
   DECLARE vbOperDate TDateTime;
   DECLARE vbUnitId Integer; 
   DECLARE vbPersonalServiceListId Integer;
   DECLARE vbPersonalGroupId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_PersonalGroupSummAdd());
      
 
     IF EXISTS (SELECT 1 FROM MovementItem WHERE MovementItem.MovementId = inMovementId AND MovementItem.isErased = False)
     THEN
           RAISE EXCEPTION 'Ошибка.Документ уже заполнен.';
     END IF;

     
     --Получаем данные тек. документа
     SELECT Movement.OperDate
          , MovementLinkObject_PersonalServiceList.ObjectId
          , MovementLinkObject_Unit.ObjectId
          , COALESCE (MovementLinkObject_PersonalGroup.ObjectId,0) 
    INTO vbOperDate, vbPersonalServiceListId, vbUnitId, vbPersonalGroupId 
     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalServiceList
                                       ON MovementLinkObject_PersonalServiceList.MovementId = Movement.Id
                                      AND MovementLinkObject_PersonalServiceList.DescId = zc_MovementLinkObject_PersonalServiceList()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                       ON MovementLinkObject_Unit.MovementId = Movement.Id
                                      AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalGroup
                                       ON MovementLinkObject_PersonalGroup.MovementId = Movement.Id
                                      AND MovementLinkObject_PersonalGroup.DescId = zc_MovementLinkObject_PersonalGroup()
      WHERE Movement.Id = inMovementId
      ;

     --ищем документ прошлого месяца
     SELECT Movement.Id
    INTO vbMovementId_mask
     FROM Movement
          INNER JOIN MovementLinkObject AS MovementLinkObject_PersonalServiceList
                                        ON MovementLinkObject_PersonalServiceList.MovementId = Movement.Id
                                       AND MovementLinkObject_PersonalServiceList.DescId = zc_MovementLinkObject_PersonalServiceList() 
                                       AND MovementLinkObject_PersonalServiceList.ObjectId = vbPersonalServiceListId
          INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                        ON MovementLinkObject_Unit.MovementId = Movement.Id
                                       AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                       AND MovementLinkObject_Unit.ObjectId = vbUnitId
          LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalGroup
                                       ON MovementLinkObject_PersonalGroup.MovementId = Movement.Id
                                      AND MovementLinkObject_PersonalGroup.DescId = zc_MovementLinkObject_PersonalGroup()
     WHERE Movement.DescId = zc_Movement_PersonalGroupSummAdd()
       AND Movement.OperDate = DATE_TRUNC ('MONTH', vbOperDate) - INTERVAL '1 Month'
    --   AND Movement.StatusId = zc_Enum_Status_Complete() 
       AND COALESCE (MovementLinkObject_PersonalGroup.ObjectId,0) = COALESCE (vbPersonalGroupId,0)
     ;

     -- записываем строки PersonalGroupSummAddGoods документа
     PERFORM lpInsertUpdate_MovementItem_PersonalGroupSummAdd (ioId          := 0        
                                                             , inMovementId  := inMovementId
                                                             , inPositionId  := tmp.PositionId
                                                             , inPositionLevelId := tmp.PositionLevelId
                                                             , inAmount      := tmp.Amount
                                                             , inComment     := tmp.Comment
                                                             , inUserId      := vbUserId
                                                              ) 
   FROM gpSelect_MovementItem_PersonalGroupSummAdd (vbMovementId_mask, False, False, inSession)  AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.02.24         *
*/

-- тест
--