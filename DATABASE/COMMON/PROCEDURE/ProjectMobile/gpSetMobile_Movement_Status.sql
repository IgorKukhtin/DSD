-- Function: gpSetMobile_Movement_Status

DROP FUNCTION IF EXISTS gpSetMobile_Movement_Status (TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetMobile_Movement_Status (
    IN inMovementGUID TVarChar , -- глобальный идентификатор документа
    IN inStatusId     Integer  , -- новый статус документа
    IN inSession      TVarChar   -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbId Integer;
  DECLARE vbDescId Integer;
  DECLARE vbDescCode TVarChar;
  DECLARE vbDescName TVarChar;
  DECLARE vbStatusId Integer;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...);
      vbUserId:= lpGetUserBySession (inSession);
      
      -- определение идентификатора документа по глобальному уникальному идентификатору
      SELECT MovementString_GUID.MovementId 
           , Movement.DescId
           , Movement.StatusId
      INTO vbId 
         , vbDescId
         , vbStatusId
      FROM MovementString AS MovementString_GUID
           JOIN Movement ON Movement.Id = MovementString_GUID.MovementId
      WHERE MovementString_GUID.DescId = zc_MovementString_GUID() 
        AND MovementString_GUID.ValueData = inMovementGUID;

      vbDescId:= COALESCE (vbDescId, 0);
      vbStatusId:= COALESCE (vbStatusId, 0);

      -- если документ нашелся
      IF COALESCE (vbId, 0) <> 0
      THEN
           IF vbDescId NOT IN (zc_Movement_OrderExternal(), zc_Movement_ReturnIn(), zc_Movement_StoreReal(), zc_Movement_RouteMember())
           THEN
                SELECT Code, ItemName INTO vbDescCode, vbDescName FROM MovementDesc WHERE Id = vbDescId;

                RAISE EXCEPTION 'Тип документа % (%) данной функцией не поддерживается', vbDescCode, vbDescName;
           END IF;

           IF COALESCE (inStatusId, 0) NOT IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
           THEN
                RAISE EXCEPTION 'Задан неверный статус документа = <%>', inStatusId;
           END IF;

           IF vbStatusId <> inStatusId
           THEN 
                -- если заявка или возврат уже проведены, а их пытаются удалить, то ничего не делаем
                IF vbDescId IN (zc_Movement_OrderExternal(), zc_Movement_ReturnIn()) 
                   AND vbStatusId = zc_Enum_Status_Complete() AND inStatusId = zc_Enum_Status_Erased()
                THEN
                     RETURN;  
                END IF;

                IF vbStatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_Erased())
                THEN 
                     IF vbDescId = zc_Movement_OrderExternal()
                     THEN
                          -- если заявка проведена, то распроводим
                          PERFORM lpUnComplete_Movement_OrderExternal (inMovementId:= vbId, inUserId:= vbUserId);

                     ELSIF vbDescId = zc_Movement_ReturnIn()
                     THEN
                          -- Распроводим Документ
                          PERFORM lpUnComplete_Movement (inMovementId:= vbId, inUserId:= vbUserId);

                     ELSIF vbDescId = zc_Movement_StoreReal()
                     THEN
                          -- если фактический остаток проведен, то распроводим    
                          PERFORM lpUnComplete_Movement (inMovementId := vbId, inUserId:= vbUserId);
                     END IF;

                END IF;

                IF inStatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_Erased())
                THEN 
                     IF vbDescId = zc_Movement_OrderExternal()
                     THEN  
                          CASE inStatusId
                              WHEN zc_Enum_Status_Complete() THEN
                                 PERFORM lpComplete_Movement_OrderExternal (inMovementId:= vbId, inUserId:= vbUserId);

                              WHEN zc_Enum_Status_Erased() THEN
                                 PERFORM lpSetErased_Movement (inMovementId := vbId, inUserId:= vbUserId);
                          END CASE;

                     ELSIF vbDescId = zc_Movement_ReturnIn()
                     THEN 
                          CASE inStatusId
                              WHEN zc_Enum_Status_Complete() THEN
                                 PERFORM gpComplete_Movement_ReturnIn (inMovementId:= vbId, inStartDateSale:= NULL, inIsLastComplete:= FALSE, inSession:= inSession);

                              WHEN zc_Enum_Status_Erased() THEN
                                 PERFORM lpSetErased_Movement (inMovementId := vbId, inUserId:= vbUserId);
                          END CASE;

                     ELSIF vbDescId = zc_Movement_StoreReal()
                     THEN 
                          CASE inStatusId
                              WHEN zc_Enum_Status_Complete() THEN
                                 PERFORM lpComplete_Movement (inMovementId:= vbId, inDescId:= vbDescId, inUserId:= vbUserId);

                              WHEN zc_Enum_Status_Erased() THEN
                                 PERFORM lpSetErased_Movement (inMovementId := vbId, inUserId:= vbUserId);
                          END CASE;
                     END IF;

                END IF;
           END IF;
      ELSE
           RAISE EXCEPTION 'Документ по глобальному идентификатору % не найден', inMovementGUID;
      END IF;
      
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Ярошенко Р.Ф.
 14.07.17                                                       *
*/

-- тест
-- SELECT * FROM gpSetMobile_Movement_Status (inMovementGUID:= '{A539F063-B6B2-4089-8741-B40014ED51D7}', inStatusId:= zc_Enum_Status_Erased(), inSession:= zfCalc_UserAdmin())
