-- Function: gpGet_Movement_Check_ConfirmedKind()

DROP FUNCTION IF EXISTS gpGet_Movement_Check_ConfirmedKind (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Check_ConfirmedKind(
   OUT outMovementId_list  TVarChar,  -- 
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TVarChar
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_...());
    vbUserId := lpGetUserBySession (inSession);


    vbUnitKey := COALESCE (lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    vbUnitId  := CASE WHEN vbUnitKey = '' THEN '0' ELSE vbUnitKey END :: Integer;


    -- Результат - ВСЕ документы - с типом "Не подтвержден"
    outMovementId_list:= 
       (SELECT STRING_AGG (COALESCE (Movement.Id :: TVarChar, ''), ';') AS RetV
        FROM (SELECT 0 AS x) AS tmp
             LEFT JOIN (SELECT Movement.Id
                             , Movement.InvNumber
                             , Movement.OperDate
                        FROM Movement
                             INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                           ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                          AND MovementLinkObject_Unit.DescId     = zc_MovementLinkObject_Unit()
                                                          AND MovementLinkObject_Unit.ObjectId   = vbUnitId
                             INNER JOIN MovementLinkObject AS MovementLinkObject_ConfirmedKind
                                                           ON MovementLinkObject_ConfirmedKind.MovementId = Movement.Id
                                                          AND MovementLinkObject_ConfirmedKind.DescId     = zc_MovementLinkObject_ConfirmedKind()
                                                          AND MovementLinkObject_ConfirmedKind.ObjectId   = zc_Enum_ConfirmedKind_UnComplete()
                        WHERE Movement.DescId =  zc_Movement_Check()
                          AND Movement.StatusId =  zc_Enum_Status_UnComplete()
                        ORDER BY Movement.Id DESC
                        -- LIMIT 1
                       ) AS Movement ON 1=1
       );

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 18.08.16                                        *
*/

-- тест
-- SELECT * FROM gpGet_Movement_Check_ConfirmedKind (inSession:= zfCalc_UserAdmin())
