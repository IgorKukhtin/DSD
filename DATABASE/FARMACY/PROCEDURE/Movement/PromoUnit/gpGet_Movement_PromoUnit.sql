-- Function: gpGet_Movement_PromoUnit()

DROP FUNCTION IF EXISTS gpGet_Movement_PromoUnit (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_PromoUnit(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , UnitCategoryId Integer, UnitCategoryName TVarChar
             , PersonalId Integer,  PersonalName TVarChar
             , Comment TVarChar
)
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_PromoUnit());
     vbUserId := inSession;

     IF COALESCE (inMovementId, 0) = 0
     THEN
     RETURN QUERY
         SELECT
               0                                                AS Id
             , CAST (NEXTVAL ('movement_PromoUnit_seq') AS TVarChar) AS InvNumber
             , current_date::TDateTime                          AS OperDate
             , Object_Status.Code                               AS StatusCode
             , Object_Status.Name                               AS StatusName
             , 0                     		                AS UnitId
             , CAST ('' AS TVarChar) 		                AS UnitName
             , 0                     		                AS PersonalId
             , CAST ('' AS TVarChar) 			        AS PersonalName
             , CAST ('' AS TVarChar)                            AS Comment
          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status;

     ELSE

     RETURN QUERY
      SELECT Movement.Id                                AS Id
           , Movement.InvNumber                         AS InvNumber
           , Movement.OperDate                          AS OperDate
           , Object_Status.ObjectCode                   AS StatusCode
           , Object_Status.ValueData                    AS StatusName
           , Object_UnitCategory.Id                     AS UnitCategoryId
           , Object_UnitCategory.ValueData              AS UnitCategoryName
           , Object_Personal.Id                         AS PersonalId
           , Object_Personal.ValueData                  AS PersonalName
           , MovementString_Comment.ValueData           AS Comment
       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Personal
                                         ON MovementLinkObject_Personal.MovementId = Movement.Id
                                        AND MovementLinkObject_Personal.DescId = zc_MovementLinkObject_Personal()
            LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = MovementLinkObject_Personal.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_UnitCategory
                                         ON MovementLinkObject_UnitCategory.MovementId = Movement.Id
                                        AND MovementLinkObject_UnitCategory.DescId = zc_MovementLinkObject_UnitCategory()
            LEFT JOIN Object AS Object_UnitCategory ON Object_UnitCategory.Id = MovementLinkObject_UnitCategory.ObjectId

       WHERE Movement.Id = inMovementId;

       END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 08.05.18                                                                     *
 04.02.17         *
*/

-- тест
-- SELECT * FROM gpGet_Movement_PromoUnit (inMovementId:= 5068415, inSession:= '3')