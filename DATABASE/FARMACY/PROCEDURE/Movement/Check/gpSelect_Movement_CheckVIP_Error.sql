DROP FUNCTION IF EXISTS gpSelect_Movement_CheckVIP_Error(Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_CheckVIP_Error(
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (
  Id Integer, 
  InvNumber TVarChar, 
  OperDate TDateTime, 
  StatusId Integer,
  StatusCode Integer, 
  TotalCount TFloat, 
  TotalSumm TFloat, 
  UnitId Integer,
  UnitName TVarChar, 
  CashRegisterName TVarChar,
  CashMemberId Integer,
  CashMember TVarCHar,
  CommentError TVarChar,
  ManualDiscount Integer
 )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);

     vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
     IF vbUnitKey = '' THEN
        vbUnitKey := '0';
     END IF;   
     vbUnitId := CASE WHEN vbUserId = 3 THEN 0 ELSE vbUnitKey::Integer END;

     RETURN QUERY
       WITH tmpMov AS(SELECT Movement.Id
                           , MovementString_CommentError.ValueData AS CommentError
                      FROM Movement
                        INNER JOIN MovementString AS MovementString_CommentError
                                                  ON MovementString_CommentError.MovementId = Movement.Id
                                                 AND MovementString_CommentError.DescId = zc_MovementString_CommentError()
                                                 AND MovementString_CommentError.ValueData <> ''
                        INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                      ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                       WHERE Movement.DescId = zc_Movement_Check()
                         AND (Movement.StatusId = zc_Enum_Status_UnComplete()/* OR (Movement.StatusId = zc_Enum_Status_Erased() AND inIsErased = TRUE)*/) 
                         AND (MovementLinkObject_Unit.ObjectId = vbUnitId OR vbUnitId = 0)
                       )
         
       SELECT Movement.Id
            , Movement.InvNumber
            , Movement.OperDate
            , Movement.StatusId
            , Object_Status.ObjectCode                   AS StatusCode
            , MovementFloat_TotalCount.ValueData         AS TotalCount
            , MovementFloat_TotalSumm.ValueData          AS TotalSumm
            , Object_Unit.Id                             AS UnitId
            , Object_Unit.ValueData                      AS UnitName
            , Object_CashRegister.ValueData              AS CashRegisterName
            , MovementLinkObject_CheckMember.ObjectId    AS CashMemberId
            , CASE WHEN COALESCE (Object_CashMember.ValueData, '') = '' THEN zc_Member_Site() ELSE Object_CashMember.ValueData END :: TVarChar AS CashMember

            , tmpMov.CommentError
            , MovementFloat_ManualDiscount.ValueData::Integer AS ManualDiscount
       FROM tmpMov
            LEFT JOIN Movement ON Movement.Id = tmpMov.Id 

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                          ON MovementLinkObject_Unit.MovementId = Movement.Id
                                         AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                        
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
				      
            LEFT JOIN MovementLinkObject AS MovementLinkObject_CashRegister
                                         ON MovementLinkObject_CashRegister.MovementId = Movement.Id
                                        AND MovementLinkObject_CashRegister.DescId = zc_MovementLinkObject_CashRegister()
            LEFT JOIN Object AS Object_CashRegister ON Object_CashRegister.Id = MovementLinkObject_CashRegister.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_CheckMember
                                         ON MovementLinkObject_CheckMember.MovementId = Movement.Id
                                        AND MovementLinkObject_CheckMember.DescId = zc_MovementLinkObject_CheckMember()
    	    LEFT JOIN Object AS Object_CashMember ON Object_CashMember.Id = MovementLinkObject_CheckMember.ObjectId
  	    
            LEFT JOIN MovementFloat AS MovementFloat_ManualDiscount
                                    ON MovementFloat_ManualDiscount.MovementId =  Movement.Id
                                   AND MovementFloat_ManualDiscount.DescId = zc_MovementFloat_ManualDiscount()
   
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.  Шаблий О.В.
 30.06.18                                                                                    *
 30.10.16         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_CheckVIP_Error (inIsErased := FALSE, inSession:= '3')
