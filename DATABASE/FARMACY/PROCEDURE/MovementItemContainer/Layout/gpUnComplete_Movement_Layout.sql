-- Function: gpUnComplete_Movement_Layout (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_Layout (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_Layout(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbLayoutId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpCheckRight(inSession, zc_Enum_Process_UnComplete_Layout());

     -- проверка если, например, док. был удален , то старый запретить распроводить если есть новый с такой выкладкой
     vbLayoutId := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.DescId = zc_MovementLinkObject_Layout() AND MLO.MovementId = inMovementId);

     IF EXISTS (SELECT 1
                FROM Movement
                     INNER JOIN MovementLinkObject AS MovementLinkObject_Layout
                                                   ON MovementLinkObject_Layout.MovementId = Movement.Id
                                                  AND MovementLinkObject_Layout.DescId = zc_MovementLinkObject_Layout()
                                                  AND MovementLinkObject_Layout.ObjectId = vbLayoutId
                WHERE Movement.DescId = zc_Movement_Layout()
                  AND Movement.StatusId <> zc_Enum_Status_Erased()
                  AND Movement.Id <> inMovementId)
     THEN
          RAISE EXCEPTION 'Ошибка.Документ для выкладки <%> уже существует.', lfGet_Object_ValueData (vbLayoutId);
     END IF;

    -- проверка - если <Master> Удален, то <Ошибка>
    PERFORM lfCheck_Movement_ParentStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_UnComplete(), inComment:= 'распровести');

     -- Распроводим Документ
     PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);

    --пересчитываем сумму документа по приходным ценам
    --PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);    
    

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.08.20         *
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement_Layout (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
