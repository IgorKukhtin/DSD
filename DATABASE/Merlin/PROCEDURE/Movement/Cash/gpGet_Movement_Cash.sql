-- Function: gpGet_Movement_Cash()

DROP FUNCTION IF EXISTS gpGet_Movement_Cash (Integer, Integer, TDateTime, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Cash(
    IN inMovementId        Integer  , -- ключ Документа
    IN inMovementId_Value  Integer  ,
    IN inOperDate          TDateTime, -- дата Документа
    IN inKindName          TVarChar  , --
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar
             , OperDate TDateTime, ServiceDate TDateTime
             , isSign Boolean, isChild Boolean
             , Amount TFloat
             , UnitId Integer, UnitName TVarChar
             , ParentId_InfoMoney Integer, ParentName_InfoMoney TVarChar
             , InfoMoneyId Integer, InfoMoneyName TVarChar
             , InfoMoneyDetailId Integer, InfoMoneyDetailName TVarChar
             , CommentInfoMoneyId Integer, CommentInfoMoneyName TVarChar
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Cash());
     vbUserId:= lpGetUserBySession (inSession);

     IF COALESCE (inMovementId_Value, 0) = 0
     THEN

     RETURN QUERY 
       SELECT
             0 AS Id
           , CAST (NEXTVAL ('movement_Service_seq') AS TVarChar)  AS InvNumber
           , CAST (CURRENT_DATE AS TDateTime)                  AS OperDate
           , DATE_TRUNC ('MONTH', inOperDate) :: TDateTime     AS ServiceDate
           , FALSE :: Boolean                                  AS isSign
           , FALSE :: Boolean                                  AS isChild
           , 0::TFloat                                         AS Amount
           , 0                                                 AS UnitId
           , CAST ('' as TVarChar)                             AS UnitName
           , 0                                                 AS ParentId_InfoMoney
           , CAST ('' as TVarChar)                             AS ParentName_InfoMoney
           , 0                                                 AS InfoMoneyId
           , CAST ('' as TVarChar)                             AS InfoMoneyName
           , 0                                                 AS InfoMoneyDetailId
           , CAST ('' as TVarChar)                             AS InfoMoneyDetailName
           , 0                                                 AS CommentInfoMoneyId
           , ''::TVarChar                                      AS CommentInfoMoneyName
      ;
     ELSE
     
     RETURN QUERY 
       SELECT
             inMovementId AS Id
           , CASE WHEN inMovementId = 0 THEN CAST (NEXTVAL ('movement_service_seq') AS TVarChar) ELSE Movement.InvNumber END AS InvNumber
           , CASE WHEN inMovementId = 0 THEN CAST (CURRENT_DATE AS TDateTime) ELSE Movement.OperDate END ::TDateTime AS OperDate
           , CASE WHEN inMovementId = 0 THEN DATE_TRUNC ('MONTH', inOperDate - INTERVAL '1 MONTH') ELSE MIDate_ServiceDate.ValueData END ::TDateTime AS ServiceDate
           , COALESCE (MovementBoolean_Sign.ValueData, FALSE) :: Boolean AS isSign
           , COALESCE (MIBoolean_Child.ValueData, FALSE)      :: Boolean AS isChild
           , MovementItem.Amount  ::TFloat      AS Amount
           , Object_Unit.Id                     AS UnitId
           , Object_Unit.ValueData              AS UnitName
           , Object_Parent.Id                   AS ParentId_InfoMoney
           , Object_Parent.ValueData            AS ParentName_InfoMoney
           , Object_InfoMoney.Id                AS InfoMoneyId
           , Object_InfoMoney.ValueData         AS InfoMoneyName
           , Object_InfoMoney.Id                AS InfoMoneyDetailId
           , Object_InfoMoney.ValueData         AS InfoMoneyDetailName
           , Object_CommentInfoMoney.Id         AS CommentInfoMoneyId
           , Object_CommentInfoMoney.ValueData  AS CommentInfoMoneyName
       FROM Movement
            LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementItem.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                             ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                            AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
            LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = MILinkObject_InfoMoney.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Parent
                                 ON ObjectLink_Parent.ObjectId = Object_InfoMoney.Id
                                AND ObjectLink_Parent.DescId = zc_ObjectLink_InfoMoney_Parent()
            LEFT JOIN Object AS Object_Parent ON Object_Parent.Id = ObjectLink_Parent.ChildObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoneyDetail
                                             ON MILinkObject_InfoMoneyDetail.MovementItemId = MovementItem.Id
                                            AND MILinkObject_InfoMoneyDetail.DescId = zc_MILinkObject_InfoMoneyDetail()
            LEFT JOIN Object AS Object_InfoMoneyDetail ON Object_InfoMoneyDetail.Id = MILinkObject_InfoMoneyDetail.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_CommentInfoMoney
                                             ON MILinkObject_CommentInfoMoney.MovementItemId = MovementItem.Id
                                            AND MILinkObject_CommentInfoMoney.DescId         = zc_MILinkObject_CommentInfoMoney()
            LEFT JOIN Object AS Object_CommentInfoMoney ON Object_CommentInfoMoney.Id = MILinkObject_CommentInfoMoney.ObjectId

            LEFT JOIN MovementItemDate AS MIDate_ServiceDate
                                       ON MIDate_ServiceDate.MovementItemId = MovementItem.Id
                                      AND MIDate_ServiceDate.DescId = zc_MIDate_ServiceDate()

       WHERE Movement.Id = inMovementId_Value;

   END IF; 

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.01.22         * 
*/

-- тест
-- SELECT * FROM gpGet_Movement_Cash (inMovementId:= 40874, inOperDate:= CURRENT_DATE, inSession := zfCalc_UserAdmin());
