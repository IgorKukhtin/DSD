-- Function: gpSelect_Movement_ChoiceLayout()

DROP FUNCTION IF EXISTS gpSelect_Movement_ChoiceLayout (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_ChoiceLayout(
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , TotalCount TFloat
             , LayoutId Integer, LayoutName TVarChar
             , Comment TVarChar
             , isPharmacyItem Boolean
              )

AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Layout());
     vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY
       SELECT
             Movement.Id                        AS Id
           , Movement.InvNumber                 AS InvNumber
           , Movement.OperDate                  AS OperDate
           , Object_Status.ObjectCode           AS StatusCode
           , Object_Status.ValueData            AS StatusName
           , MovementFloat_TotalCount.ValueData AS TotalCount
           , Object_Layout.Id                   AS LayoutId
           , Object_Layout.ValueData            AS LayoutName
           , COALESCE (MovementString_Comment.ValueData,'') :: TVarChar AS Comment
           , COALESCE(MovementBoolean_PharmacyItem.ValueData, FALSE)    AS isPharmacyItem

       FROM Movement

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId = Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementBoolean AS MovementBoolean_PharmacyItem
                                      ON MovementBoolean_PharmacyItem.MovementId = Movement.Id
                                     AND MovementBoolean_PharmacyItem.DescId = zc_MovementBoolean_PharmacyItem()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Layout
                                         ON MovementLinkObject_Layout.MovementId = Movement.Id
                                        AND MovementLinkObject_Layout.DescId = zc_MovementLinkObject_Layout()
            LEFT JOIN Object AS Object_Layout ON Object_Layout.Id = MovementLinkObject_Layout.ObjectId
            
       WHERE Movement.DescId = zc_Movement_Layout()
         AND Movement.StatusId = zc_Enum_Status_Complete()
       ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 27.08.20         *
*/

-- тест
-- 
SELECT * FROM gpSelect_Movement_ChoiceLayout (inSession:= '3')

