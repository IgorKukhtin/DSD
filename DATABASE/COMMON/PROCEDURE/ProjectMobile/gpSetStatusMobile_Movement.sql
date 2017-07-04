-- Function: gpSetStatusMobile_Movement

DROP FUNCTION IF EXISTS gpSetStatusMobile_Movement (TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetStatusMobile_Movement (
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

      -- !!! ВРЕМЕННО !!!
      RETURN;
      -- !!! ВРЕМЕННО !!!

      
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


      -- если документ нашелся
      IF vbId <> 0
      THEN
           IF vbDescId NOT IN (zc_Movement_OrderExternal(), zc_Movement_ReturnIn(), zc_Movement_StoreReal())
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
                          PERFORM gpUnComplete_Movement_StoreReal (inMovementId:= vbId, inSession:= inSession);
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
                                 -- PERFORM gpSetErased_Movement_OrderExternal (vbId, inSession);
                                 PERFORM lpSetErased_Movement (inMovementId := vbId, inUserId:= vbUserId);
                          END CASE;

                     ELSIF vbDescId = zc_Movement_ReturnIn()
                     THEN 
                          CASE inStatusId
                              WHEN zc_Enum_Status_Complete() THEN
                                 PERFORM gpComplete_Movement_ReturnIn (inMovementId:= vbId, inStartDateSale:= NULL, inIsLastComplete:= FALSE, inSession:= inSession);

                              WHEN zc_Enum_Status_Erased() THEN
                                 -- PERFORM gpSetErased_Movement_ReturnIn (inMovementId:= vbId, inSession:= inSession);
                                 PERFORM lpSetErased_Movement (inMovementId := vbId, inUserId:= vbUserId);
                          END CASE;

                     ELSIF vbDescId = zc_Movement_StoreReal()
                     THEN 
                          CASE inStatusId
                              WHEN zc_Enum_Status_Complete() THEN
                                 PERFORM gpComplete_Movement_StoreReal (inMovementId:= vbId, inSession:= inSession);

                              WHEN zc_Enum_Status_Erased() THEN
                                 PERFORM lpSetErased_Movement (inMovementId := vbId, inUserId:= vbUserId);

                          END CASE;
                     END IF;

                END IF;
           END IF;
      END IF;
      
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Ярошенко Р.Ф.
 27.06.17                                                       *
*/

-- тест
-- SELECT * FROM gpSetStatusMobile_Movement (inMovementGUID:= '{A539F063-B6B2-4089-8741-B40014ED51D7}', inStatusId:= zc_Enum_Status_Erased(), inSession:= zfCalc_UserAdmin())
