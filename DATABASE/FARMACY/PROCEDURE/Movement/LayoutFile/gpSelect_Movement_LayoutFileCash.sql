-- Function: gpSelect_Movement_LayoutFileCash()

DROP FUNCTION IF EXISTS gpSelect_Movement_LayoutFileCash (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_LayoutFileCash(
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StartPromo TDateTime, EndPromo TDateTime
             , Comment TVarChar
             , FileName TVarChar
              )

AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_LayoutFile());
     vbUserId:= lpGetUserBySession (inSession);
     vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
     IF vbUnitKey = '' THEN
        vbUnitKey := '0';
     END IF;
     vbUnitId := vbUnitKey::Integer;
   
     RETURN QUERY
       SELECT
             Movement.Id                        AS Id
           , Movement.InvNumber                 AS InvNumber
           , Movement.OperDate                  AS OperDate
           , MovementDate_StartPromo.ValueData  AS StartPromo
           , MovementDate_EndPromo.ValueData    AS EndPromo
           , COALESCE (MovementString_Comment.ValueData,'') :: TVarChar AS Comment
           , COALESCE (MovementString_FileName.ValueData,'') :: TVarChar AS FileName

       FROM Movement

            INNER JOIN MovementDate AS MovementDate_StartPromo
                                   ON MovementDate_StartPromo.MovementId = Movement.Id
                                  AND MovementDate_StartPromo.DescId = zc_MovementDate_StartPromo()

            INNER JOIN MovementDate AS MovementDate_EndPromo
                                   ON MovementDate_EndPromo.MovementId = Movement.Id
                                  AND MovementDate_EndPromo.DescId = zc_MovementDate_EndPromo()

            INNER JOIN MovementItem AS MI_LayoutFile
                                    ON MI_LayoutFile.MovementId = Movement.Id
                                   AND MI_LayoutFile.DescId = zc_MI_Master()
                                   AND MI_LayoutFile.Amount = 1
                                   AND MI_LayoutFile.ObjectId = vbUnitId
                                   
            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementString AS MovementString_FileName
                                     ON MovementString_FileName.MovementId = Movement.Id
                                    AND MovementString_FileName.DescId = zc_MovementString_FileName()
                                    
       WHERE Movement.DescId = zc_Movement_LayoutFile()
         AND Movement.StatusId = zc_Enum_Status_Complete()
         AND MovementDate_StartPromo.ValueData <= CURRENT_DATE
         AND MovementDate_EndPromo.ValueData >= CURRENT_DATE

            ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 05.02.22                                                       *
*/

-- тест
-- 
SELECT * FROM gpSelect_Movement_LayoutFileCash (inSession:= '3')
