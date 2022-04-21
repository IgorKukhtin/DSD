-- Function: gpGet_Movement_Cash()

DROP FUNCTION IF EXISTS gpGet_Movement_Service (Integer, Integer, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_Service (Integer, Integer, Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Service(
    IN inMovementId        Integer  , -- ключ Документа
    IN inMovementId_Value  Integer   ,    
    IN inUnitId            Integer  , -- отдел
    IN inInfoMoneyId       Integer  , -- статья
    IN inOperDate          TDateTime , -- 
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar
             , OperDate TDateTime
             , ServiceDate TDateTime
             , Amount TFloat
             , UnitId Integer, UnitName TVarChar
             , ParentId_InfoMoney Integer, ParentName_InfoMoney TVarChar
             , InfoMoneyId Integer, InfoMoneyName TVarChar
             , CommentInfoMoneyId Integer, CommentInfoMoneyName TVarChar
             , isAuto Boolean
             )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Cash());
     vbUserId := lpGetUserBySession (inSession);

     IF COALESCE (inMovementId_Value, 0) = 0
     THEN

     RETURN QUERY 
       SELECT
             0 AS Id
           , CAST (NEXTVAL ('movement_Service_seq') AS TVarChar)  AS InvNumber
           , tmp.OperDate                     :: TDateTime     AS OperDate
           , DATE_TRUNC ('MONTH', inOperDate) :: TDateTime     AS ServiceDate
           
           , 0::TFloat                                         AS Amount
           , Object_Unit.Id                                    AS UnitId
           , Object_Unit.ValueData            ::TVarChar       AS UnitName
           , Object_Parent.Id                                  AS ParentId_InfoMoney
           , Object_Parent.ValueData          ::TVarChar       AS ParentName_InfoMoney
           , Object_InfoMoney.Id                               AS InfoMoneyId
           , Object_InfoMoney.ValueData       ::TVarChar       AS InfoMoneyName
           , 0                                                 AS CommentInfoMoneyId
           , ''::TVarChar                                      AS CommentInfoMoneyName
           , FALSE ::Boolean                                   AS isAuto  
       FROM (SELECT CAST (CURRENT_DATE AS TDateTime) AS OperDate) AS tmp
           LEFT JOIN Object AS Object_Unit
                            ON Object_Unit.DescId = zc_Object_Unit()
                           AND Object_Unit.Id = inUnitId
           LEFT JOIN Object AS Object_InfoMoney
                            ON Object_InfoMoney.DescId = zc_Object_InfoMoney()
                           AND Object_InfoMoney.Id = inInfoMoneyId    
           LEFT JOIN ObjectLink AS ObjectLink_Parent
                                ON ObjectLink_Parent.ObjectId = Object_InfoMoney.Id
                               AND ObjectLink_Parent.DescId = zc_ObjectLink_InfoMoney_Parent()
           LEFT JOIN Object AS Object_Parent ON Object_Parent.Id = ObjectLink_Parent.ChildObjectId
      ;
     ELSE
     
     RETURN QUERY 
       SELECT
             inMovementId AS Id
           , CASE WHEN inMovementId = 0 THEN CAST (NEXTVAL ('movement_service_seq') AS TVarChar) ELSE Movement.InvNumber END AS InvNumber
           , CASE WHEN inMovementId = 0 THEN CAST (CURRENT_DATE AS TDateTime) ELSE Movement.OperDate END ::TDateTime AS OperDate
           , CASE WHEN inMovementId = 0 THEN DATE_TRUNC ('MONTH', inOperDate - INTERVAL '1 MONTH') ELSE MIDate_ServiceDate.ValueData END ::TDateTime AS ServiceDate
           , MovementItem.Amount  ::TFloat      AS Amount
           , Object_Unit.Id                     AS UnitId
           , Object_Unit.ValueData              AS UnitName
           , Object_Parent.Id                   AS ParentId_InfoMoney
           , Object_Parent.ValueData            AS ParentName_InfoMoney
           , Object_InfoMoney.Id                AS InfoMoneyId
           , Object_InfoMoney.ValueData         AS InfoMoneyName
           , Object_CommentInfoMoney.Id         AS CommentInfoMoneyId
           , Object_CommentInfoMoney.ValueData  AS CommentInfoMoneyName
           , COALESCE (MovementBoolean_isAuto.ValueData, FALSE) ::Boolean AS isAuto
       FROM Movement
            LEFT JOIN MovementBoolean AS MovementBoolean_isAuto
                                      ON MovementBoolean_isAuto.MovementId = Movement.Id
                                     AND MovementBoolean_isAuto.DescId = zc_MovementBoolean_isAuto()

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
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.04.22         *
 14.01.22         *
 */

-- тест
-- SELECT * FROM gpGet_Movement_Service (inMovementId:= 0, inOperDate:= NULL :: TDateTime, inSession:= zfCalc_UserAdmin());
