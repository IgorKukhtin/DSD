-- Function: gpGet_Movement_Cash()

DROP FUNCTION IF EXISTS gpGet_Movement_Cash (Integer, Integer, TDateTime, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpGet_Movement_Cash (Integer, Integer, Integer, TDateTime, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_Cash (Integer, Integer, Integer, Integer, Integer, TDateTime, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Cash(
    IN inMovementId        Integer  , -- ключ Документа
    IN inMovementId_Value  Integer  ,
    IN inMI_Id             Integer  , --Мастер
    IN inUnitId            Integer  , -- отдел
    IN inInfoMoneyId       Integer  , -- статья
    IN inOperDate          TDateTime, -- дата Документа
    IN inKindName          TVarChar  , --
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar
             , OperDate TDateTime, ServiceDate TDateTime
             , isSign Boolean
             , Amount TFloat
             , MI_Id Integer
             , CashId Integer, CashName TVarChar
             , UnitId Integer, UnitName TVarChar
             , ParentId_InfoMoney Integer, ParentName_InfoMoney TVarChar
             , InfoMoneyId Integer, InfoMoneyName TVarChar
             , InfoMoneyDetailId Integer, InfoMoneyDetailName TVarChar
             , CommentInfoMoneyId Integer, CommentInfoMoneyName TVarChar
              )
AS
$BODY$
  DECLARE vbUserId     Integer;
  DECLARE vbUser_isAll Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Cash());
     vbUserId:= lpGetUserBySession (inSession);

     -- 
     vbUser_isAll:= lpCheckUser_isAll (vbUserId);

     IF COALESCE (inMovementId_Value, 0) = 0
     THEN

     RETURN QUERY
       SELECT
             0 AS Id
           , CAST (NEXTVAL ('movement_cash_seq') AS TVarChar)  AS InvNumber
           , tmp.OperDate                     :: TDateTime     AS OperDate
           , DATE_TRUNC ('MONTH', inOperDate) :: TDateTime     AS ServiceDate
           , FALSE :: Boolean                                  AS isSign
           , 0::TFloat                                         AS Amount
           , 0                                                 AS MI_Id
           , Object_Cash.Id                                    AS CashId
           , Object_Cash.ValueData                             AS CashName
           , Object_Unit.Id                                    AS UnitId
           , TRIM (COALESCE (ObjectString_GroupNameFull.ValueData,'')||' '||Object_Unit.ValueData) ::TVarChar AS UnitName
           , Object_Parent.Id                                  AS ParentId_InfoMoney
           , Object_Parent.ValueData          ::TVarChar       AS ParentName_InfoMoney
           , Object_InfoMoney.Id                               AS InfoMoneyId
           , Object_InfoMoney.ValueData       ::TVarChar       AS InfoMoneyName
           , 0                                                 AS InfoMoneyDetailId
           , CAST ('' as TVarChar)                             AS InfoMoneyDetailName
           , 0                                                 AS CommentInfoMoneyId
           , ''::TVarChar                                      AS CommentInfoMoneyName
       FROM (SELECT CAST (CURRENT_DATE AS TDateTime) AS OperDate) AS tmp
           LEFT JOIN Object AS Object_Cash
                            ON Object_Cash.DescId = zc_Object_Unit()
                           AND Object_Cash.Id     = CASE WHEN vbUser_isAll = FALSE THEN 102964 ELSE 0 END -- Бухгалтерия
           LEFT JOIN Object AS Object_Unit
                            ON Object_Unit.DescId = zc_Object_Unit()
                           AND Object_Unit.Id = inUnitId
           LEFT JOIN ObjectString AS ObjectString_GroupNameFull
                                  ON ObjectString_GroupNameFull.ObjectId = Object_Unit.Id
                                 AND ObjectString_GroupNameFull.DescId = zc_ObjectString_Unit_GroupNameFull()
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

           , CASE WHEN inMovementId = 0 THEN DATE_TRUNC ('MONTH', inOperDate)
                  WHEN ObjectBoolean_Service.ValueData = TRUE THEN MIDate_ServiceDate.ValueData
                  ELSE DATE_TRUNC ('MONTH', Movement.OperDate)
             END ::TDateTime AS ServiceDate

           , COALESCE (MovementBoolean_Sign.ValueData, FALSE) :: Boolean AS isSign
           , CASE WHEN MovementItem.Amount < 0 THEN MovementItem.Amount * (-1) ELSE MovementItem.Amount END  ::TFloat AS Amount
           , CASE WHEN inMovementId = 0 THEN 0 ELSE MovementItem.Id END AS MI_Id
           , Object_Cash.Id                     AS CashId
           , Object_Cash.ValueData              AS CashName
           , CASE WHEN TRIM (Object_Unit.ValueData) <> '' THEN Object_Unit.Id ELSE 0 END :: Integer AS UnitId
           , TRIM (COALESCE (ObjectString_GroupNameFull.ValueData,'')||' '||Object_Unit.ValueData) ::TVarChar AS UnitName
           , Object_Parent.Id                   AS ParentId_InfoMoney
           , Object_Parent.ValueData            AS ParentName_InfoMoney
           , Object_InfoMoney.Id                AS InfoMoneyId
           , Object_InfoMoney.ValueData         AS InfoMoneyName
           , CASE WHEN TRIM (Object_InfoMoneyDetail.ValueData) <> '' THEN Object_InfoMoneyDetail.Id ELSE 0 END :: Integer AS InfoMoneyDetailId
           , Object_InfoMoneyDetail.ValueData   AS InfoMoneyDetailName
           , CASE WHEN TRIM (Object_CommentInfoMoney.ValueData) <> '' THEN Object_CommentInfoMoney.Id ELSE 0 END :: Integer AS CommentInfoMoneyId
           , Object_CommentInfoMoney.ValueData  AS CommentInfoMoneyName
       FROM Movement
            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                   AND MovementItem.DescId = zc_MI_Master()
                                   AND MovementItem.Id = inMI_Id
            LEFT JOIN Object AS Object_Cash ON Object_Cash.Id = MovementItem.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                             ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MILinkObject_Unit.ObjectId

            LEFT JOIN ObjectString AS ObjectString_GroupNameFull
                                   ON ObjectString_GroupNameFull.ObjectId = Object_Unit.Id
                                  AND ObjectString_GroupNameFull.DescId = zc_ObjectString_Unit_GroupNameFull()

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

            LEFT JOIN MovementBoolean AS MovementBoolean_Sign
                                      ON MovementBoolean_Sign.MovementId = Movement.Id
                                     AND MovementBoolean_Sign.DescId = zc_MovementBoolean_Sign()

            LEFT JOIN ObjectBoolean AS ObjectBoolean_Service
                                    ON ObjectBoolean_Service.ObjectId = Object_InfoMoney.Id
                                   AND ObjectBoolean_Service.DescId = zc_ObjectBoolean_InfoMoney_Service()

       WHERE Movement.Id = inMovementId_Value;

   END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.01.22         * add inMI_Id
 15.01.22         *
*/

-- тест
-- SELECT * FROM gpGet_Movement_Cash (inMovementId:= 608, inMovementId_Value:= 608, inMI_Id:= 1, inUnitId:= 1, inInfoMoneyId:= 1, inOperDate:= '31.01.2022' , inKindName := 'zc_Enum_InfoMoney_In' ,  inSession := '5');
