-- Function: gpGet_Movement_Layout()

DROP FUNCTION IF EXISTS gpGet_Movement_Layout (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Layout(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime, -- дата Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , TotalCount TFloat
             , LayoutId Integer, LayoutName TVarChar
             , Comment TVarChar
             , isPharmacyItem Boolean
             , isNotMoveRemainder6 Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     vbUserId := inSession;

     IF COALESCE (inMovementId, 0) = 0
     THEN
     RETURN QUERY
         SELECT
               0 AS Id
             , CAST (NEXTVAL ('Movement_Layout_seq') AS TVarChar) AS InvNumber
             , CURRENT_DATE::TDateTime                          AS OperDate
             , Object_Status.Code                               AS StatusCode
             , Object_Status.Name                               AS StatusName
             , CAST (0 AS TFloat)                               AS TotalCount
             , 0                     	            			AS LayoutId
             , CAST ('' AS TVarChar) 				            AS LayoutName
             , CAST ('' AS TVarChar) 		                    AS Comment
             , False                                            AS isPharmacyItem
             , False                                            AS isNotMoveRemainder6
          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status;
     ELSE
     RETURN QUERY
       SELECT
             Movement.Id                                        AS Id
           , Movement.InvNumber                                 AS InvNumber
           , Movement.OperDate                                  AS OperDate
           , Object_Status.ObjectCode                           AS StatusCode
           , Object_Status.ValueData                            AS StatusName
           , MovementFloat_TotalCount.ValueData                 AS TotalCount
           , Object_Layout.Id                                   AS LayoutId
           , Object_Layout.ValueData                            AS LayoutName
           , COALESCE (MovementString_Comment.ValueData,'')     ::TVarChar AS Comment
           , COALESCE(MovementBoolean_PharmacyItem.ValueData, FALSE)       AS isPharmacyItem
           , COALESCE(MovementBoolean_NotMoveRemainder6.ValueData, FALSE)  AS isNotMoveRemainder6
       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Layout
                                         ON MovementLinkObject_Layout.MovementId = Movement.Id
                                        AND MovementLinkObject_Layout.DescId = zc_MovementLinkObject_Layout()
            LEFT JOIN Object AS Object_Layout ON Object_Layout.Id = MovementLinkObject_Layout.ObjectId

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementBoolean AS MovementBoolean_PharmacyItem
                                      ON MovementBoolean_PharmacyItem.MovementId = Movement.Id
                                     AND MovementBoolean_PharmacyItem.DescId = zc_MovementBoolean_PharmacyItem()

            LEFT JOIN MovementBoolean AS MovementBoolean_NotMoveRemainder6
                                      ON MovementBoolean_NotMoveRemainder6.MovementId = Movement.Id
                                     AND MovementBoolean_NotMoveRemainder6.DescId = zc_MovementBoolean_NotMoveRemainder6()

       WHERE Movement.Id = inMovementId
         AND Movement.DescId = zc_Movement_Layout();

       END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 27.08.20         *
 */

-- тест
-- select * from gpGet_Movement_Layout(inMovementId := 18340672 , inOperDate := ('23.04.2020')::TDateTime ,  inSession := '3');