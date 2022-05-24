-- Function: gpGet_Movement_Cash_Child()

DROP FUNCTION IF EXISTS gpGet_Movement_Cash_Child (Integer, Integer, Integer, TDateTime, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Cash_Child(
    IN inMovementId        Integer  , -- ключ Документа+
    IN inMI_Id             Integer  , --Мастер
    IN inMI_Id_child       Integer  ,
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
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Cash());
     vbUserId:= lpGetUserBySession (inSession);

     IF COALESCE (inMI_Id_child, 0) = 0
     THEN

     RETURN QUERY
       SELECT
             Movement.Id                        AS Id
           , Movement.InvNumber                 AS InvNumber
           , Movement.OperDate  ::TDateTime     AS OperDate
           , MIDate_ServiceDate.ValueData  ::TDateTime AS ServiceDate
           , COALESCE (MovementBoolean_Sign.ValueData, FALSE) :: Boolean AS isSign
           , ((MovementItem.Amount - COALESCE (tmpChild.Amount,0) ) * CASE WHEN MovementItem.Amount < 0 THEN  (-1) ELSE 1 END)::TFloat AS Amount
           , MovementItem.Id                    AS MI_Id
           , CASE WHEN TRIM (Object_Cash.ValueData) <> '' THEN Object_Cash.Id ELSE 0 END :: Integer AS CashId
           , Object_Cash.ValueData                                                                  AS CashName
           , CASE WHEN TRIM (Object_Unit.ValueData) <> '' THEN Object_Unit.Id ELSE 0 END           :: Integer AS UnitId
           , TRIM (COALESCE (ObjectString_GroupNameFull.ValueData,'')||' '||Object_Unit.ValueData) ::TVarChar AS UnitName
           , CASE WHEN TRIM (Object_Parent.ValueData) <> '' THEN Object_Parent.Id ELSE 0 END :: Integer AS ParentId_InfoMoney
           , Object_Parent.ValueData                                                                    AS ParentName_InfoMoney
           , CASE WHEN TRIM (Object_InfoMoney.ValueData) <> '' THEN Object_InfoMoney.Id ELSE 0 END :: Integer AS InfoMoneyId
           , Object_InfoMoney.ValueData                                                                       AS InfoMoneyName
           , CASE WHEN TRIM (Object_InfoMoneyDetail.ValueData) <> '' THEN Object_InfoMoneyDetail.Id ELSE 0 END :: Integer AS InfoMoneyDetailId
           , Object_InfoMoneyDetail.ValueData                                                                             AS InfoMoneyDetailName
           , CASE WHEN TRIM (Object_CommentInfoMoney.ValueData) <> '' THEN Object_CommentInfoMoney.Id ELSE 0 END :: Integer AS CommentInfoMoneyId
           , Object_CommentInfoMoney.ValueData                                                                              AS CommentInfoMoneyName
       FROM Movement
            LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                  AND MovementItem.DescId = zc_MI_Master()
                                  AND MovementItem.Id = inMI_Id
            LEFT JOIN (SELECT SUM (MovementItem.Amount) AS Amount
                       FROM MovementItem
                       WHERE MovementItem.MovementId = inMovementId
                         AND MovementItem.DescId = zc_MI_Child()
                       ) AS tmpChild On 1= 1

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

       WHERE Movement.Id = inMovementId;

     ELSE

     RETURN QUERY
       SELECT
             Movement.Id                        AS Id
           , Movement.InvNumber                 AS InvNumber
           , Movement.OperDate  ::TDateTime     AS OperDate
           , MIDate_ServiceDate.ValueData  ::TDateTime AS ServiceDate
           , COALESCE (MovementBoolean_Sign.ValueData, FALSE) :: Boolean AS isSign
           , CASE WHEN MovementItem.Amount < 0 THEN MovementItem.Amount * (-1) ELSE MovementItem.Amount END  ::TFloat AS Amount
           , MovementItem.Id                                                                                  AS MI_Id
           , CASE WHEN TRIM (Object_Cash.ValueData) <> '' THEN Object_Cash.Id ELSE 0 END :: Integer           AS CashId
           , Object_Cash.ValueData                                                                            AS CashName
           , CASE WHEN TRIM (Object_Unit.ValueData) <> '' THEN Object_Unit.Id ELSE 0 END :: Integer           AS UnitId
           , TRIM (COALESCE (ObjectString_GroupNameFull.ValueData,'')||' '||Object_Unit.ValueData) ::TVarChar AS UnitName
           , CASE WHEN TRIM (Object_Parent.ValueData) <> '' THEN Object_Parent.Id ELSE 0 END       :: Integer AS ParentId_InfoMoney
           , Object_Parent.ValueData                                                                          AS ParentName_InfoMoney
           , CASE WHEN TRIM (Object_InfoMoney.ValueData) <> '' THEN Object_InfoMoney.Id ELSE 0 END :: Integer AS InfoMoneyId
           , Object_InfoMoney.ValueData                                                                       AS InfoMoneyName
           , CASE WHEN TRIM (Object_InfoMoneyDetail.ValueData) <> '' THEN Object_InfoMoneyDetail.Id ELSE 0 END   :: Integer AS InfoMoneyDetailId
           , Object_InfoMoneyDetail.ValueData                                                                               AS InfoMoneyDetailName
           , CASE WHEN TRIM (Object_CommentInfoMoney.ValueData) <> '' THEN Object_CommentInfoMoney.Id ELSE 0 END :: Integer AS CommentInfoMoneyId
           , Object_CommentInfoMoney.ValueData  AS CommentInfoMoneyName
       FROM Movement
            LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                  AND MovementItem.DescId = zc_MI_Child()
                                  AND MovementItem.Id = inMI_Id_child

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

       WHERE Movement.Id = inMovementId;

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
-- select * from gpGet_Movement_Cash_Child(inMovementId := 608 , inMI_Id := 0 ,inMI_Id_child := 0, inOperDate := ('31.01.2022')::TDateTime , inKindName := 'zc_Enum_InfoMoney_In' ,  inSession := '5');
