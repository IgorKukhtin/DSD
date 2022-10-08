-- Function: gpUpdate_Movement_Check_SiteWhoUpdate()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_SiteWhoUpdate (Integer, TVarChar, TDateTime, TVarChar);
        
CREATE OR REPLACE FUNCTION gpUpdate_Movement_Check_SiteWhoUpdate(
    IN inMovementId        Integer   , -- Ключ объекта <Документ ЧЕК>
    IN inSiteWhoUpdate     TVarChar  , -- Кто изменил на сайте
    IN inSiteDateUpdate    TDateTime , -- Дата изменение на сайте
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_...());
    vbUserId := lpGetUserBySession (inSession);

    -- сохранили связь с менеджером
    IF EXISTS(SELECT 1
              FROM Movement 
                   INNER JOIN MovementString AS MovementString_InvNumberOrder
                                             ON MovementString_InvNumberOrder.MovementId = Movement.Id
                                            AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()
                                            AND COALESCE(MovementString_InvNumberOrder.ValueData, '') <> ''
              WHERE Id = inMovementId)
    THEN
      -- сохранили Кто изменил на сайте
      PERFORM lpInsertUpdate_MovementString (zc_MovementString_SiteWhoUpdate(), inMovementId, inSiteWhoUpdate);
      -- сохранили Дата изменение на сайте
      PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_SiteDateUpdate(), inMovementId, inSiteDateUpdate);

      -- сохранили протокол
      PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, False);

      -- !!!ВРЕМЕННО для ТЕСТА!!!
      IF inSession = zfCalc_UserAdmin()
      THEN
          RAISE EXCEPTION 'Тест прошел успешно для <%>', inSession;
      END IF;
      
    END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.  Шаблий О.В.
 29.01.19                                                                                      *
 17.12.15                                                                       *
*/

-- тест
-- 
SELECT * FROM gpUpdate_Movement_Check_SiteWhoUpdate (29565513 , 'fgdsgdf', CURRENT_TIMESTAMP::TDateTime, '3'); 

