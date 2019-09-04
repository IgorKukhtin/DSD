-- Function: gpUpdate_MovementItemContainer_Promo (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_MovementItemContainer_Promo (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItemContainer_Promo (
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId     Integer;
  DECLARE vbStatusID   Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_UnComplete_Promo());
    vbUserId:= lpGetUserBySession (inSession);
    
    -- Запрет запуска второй копии
    PERFORM  zfCheckRunProc ('gpUpdate_MovementItemContainer_Promo', 1);

    SELECT StatusId
    INTO vbStatusID
    FROM Movement
    WHERE Movement.Id = inMovementId;

    IF vbStatusId = zc_Enum_Status_Complete()
    THEN

      -- 1. поставим ObjectIntId_analyzer = NULL, для zc_MIContainer_Count() + zc_MIContainer_Summ() по удаленным позициям
      UPDATE MovementItemContainer SET ObjectIntId_analyzer = NULL
      FROM MovementItem
      WHERE MovementItem.MovementId = inMovementId
        AND MovementItem.DescId     = zc_MI_Master()
        AND MovementItem.IsErased = TRUE
        AND MovementItemContainer.ObjectIntId_analyzer = MovementItem.Id
        AND MovementItemContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_Check());

      -- 2. Обязательно заполняем ObjectIntId_analyzer
      PERFORM  lpReComplete_Movement_Promo_All(inMovementId, vbUserId);

    ELSE

      -- 1. поставим ObjectIntId_analyzer = NULL, для zc_MIContainer_Count() + zc_MIContainer_Summ()
      UPDATE MovementItemContainer SET ObjectIntId_analyzer = NULL
      FROM MovementItem
      WHERE MovementItem.MovementId = inMovementId
        AND MovementItem.DescId     = zc_MI_Master()
        AND MovementItemContainer.ObjectIntId_analyzer = MovementItem.Id
        AND MovementItemContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_Check());
     END IF;

    -- сохранили <Статус надо прописать ObjectIntId_analyzer>
    PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Promo_Prescribe(), inMovementId, FALSE);

    -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 04.09.19        *
 16.10.18        *
*/