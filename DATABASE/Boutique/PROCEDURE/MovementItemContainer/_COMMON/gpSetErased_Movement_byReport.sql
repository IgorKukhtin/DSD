-- Function: gpSetErased_Movement_byReport (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_byReport (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_byReport(
    IN inMovementId   Integer    , -- ключ объекта <Документ>
   OUT outStatusCode  Integer    , --
    IN inSession      TVarChar     -- текущий пользователь
)                              
AS
$BODY$
  DECLARE vbUserId   Integer;
  DECLARE vbDescId   Integer;
  DECLARE vbOperDate TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


     -- определяем параметры Документа
     SELECT Movement.DescId, Movement.OperDate INTO vbDescId, vbOperDate FROM Movement WHERE Movement.Id = inMovementId;
     

     -- Проверка - Дата Документа
     PERFORM lpCheckOperDate_byUnit (inUnitId_by:= lpGetUnit_byUser (vbUserId), inOperDate:= vbOperDate, inUserId:= vbUserId);


     -- сохранили свойство <Дата Корректировки> - по Дате Удаления
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Update(), inMovementId, CURRENT_TIMESTAMP);
     -- сохранили свойство <Пользователь (Корректировка)> - по Пользователю Удаления
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Update(), inMovementId, vbUserId);


     -- Удалили
     PERFORM CASE WHEN vbDescId = zc_Movement_Sale()         THEN gpSetErased_Movement_Sale         (inMovementId, inSession)
                  WHEN vbDescId = zc_Movement_ReturnIn()     THEN gpSetErased_Movement_ReturnIn     (inMovementId, inSession)
                  WHEN vbDescId = zc_Movement_GoodsAccount() THEN gpSetErased_Movement_GoodsAccount (inMovementId, inSession)
             END;
     
     -- вернули
     outStatusCode := (SELECT Object_Status.ObjectCode  AS StatusCode
                       FROM Movement 
                            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
                       WHERE Movement.Id = inMovementId
                      );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.01.18         *
*/

-- тест
-- SELECT * FROM gpSetErased_Movement_byReport (inMovementId:= 55, inSession:= '2')
