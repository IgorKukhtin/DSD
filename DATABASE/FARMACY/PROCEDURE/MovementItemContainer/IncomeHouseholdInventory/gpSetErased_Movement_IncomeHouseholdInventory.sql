-- Function: gpSetErased_Movement_IncomeHouseholdInventory (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_IncomeHouseholdInventory (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_IncomeHouseholdInventory(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbStatusId Integer;
  DECLARE vbGoodsName TVarChar;
  DECLARE vbInvNumber Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_SetErased_IncomeHouseholdInventory());


    SELECT Movement.StatusId
    INTO vbStatusId
    FROM Movement
    WHERE Movement.ID = inMovementId;

    -- проверка - проведенные/удаленные документы Изменять нельзя
    IF vbStatusId <> zc_Enum_Status_UnComplete()
    THEN
        RAISE EXCEPTION 'Ошибка.Удаление документа в статусе <%> не возможно.', lfGet_Object_ValueData (vbStatusId);
    END IF;

    -- Удаляем Документ
    PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 30.07.20                                                       *
 09.07.20                                                       *
*/

-- тест
-- SELECT * FROM gpSetErased_Movement_IncomeHouseholdInventory (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
