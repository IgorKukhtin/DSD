-- Function: gpGet_Movement_Check_CommentError()

DROP FUNCTION IF EXISTS gpGet_Movement_Check_CommentError (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Check_CommentError(
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


    -- Результат - ВСЕ документы - с "ошибка - расч/факт остаток"
    outMovementId_list:= 
       (SELECT STRING_AGG (COALESCE (Movement.Id :: TVarChar, ''), ';') AS RetV
        FROM (SELECT 0 AS x) AS tmp
             LEFT JOIN (WITH
                              tmpMovementCheck AS (SELECT Movement.*
                                                   FROM Movement
                                                   WHERE Movement.DescId = zc_Movement_Check()
                                                     AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                                     AND Movement.OperDate >= CURRENT_DATE - INTERVAL '1 MONTH')
                        SELECT Movement.Id
                             , Movement.InvNumber
                             , Movement.OperDate
                             , Movement.StatusId
                        FROM tmpMovementCheck AS Movement
                             INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                           ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                          AND MovementLinkObject_Unit.DescId     = zc_MovementLinkObject_Unit()
                                                          AND MovementLinkObject_Unit.ObjectId   = vbUnitId
                             INNER JOIN MovementString AS MovementString_CommentError
                                      ON MovementString_CommentError.MovementId = Movement.Id
                                     AND MovementString_CommentError.DescId     = zc_MovementString_CommentError()
                                     AND MovementString_CommentError.ValueData  > ''
                        ORDER BY Movement.Id DESC
                        -- LIMIT 1
                       ) AS Movement ON Movement.StatusId =  zc_Enum_Status_UnComplete()
       );

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 29.10.16                                        *
*/

-- тест
-- SELECT * FROM gpGet_Movement_Check_CommentError (inSession:= zfCalc_UserAdmin())
