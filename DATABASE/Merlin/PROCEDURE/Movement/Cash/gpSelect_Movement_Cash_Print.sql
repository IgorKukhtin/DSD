-- Function: gpSelect_Movement_Cash_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_Cash_Print (TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_Cash_Print (TDateTime, TDateTime, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Cash_Print(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --  
    IN inKindName          TVarChar   , --
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (OperDate TDateTime, ServiceDate TDateTime
             , Amount TFloat
             , CashId Integer, CashName TVarChar
             , UnitId Integer, UnitName TVarChar
             , InfoMoneyCode Integer, InfoMoneyName TVarChar
             , InfoMoneyDetailId Integer, InfoMoneyDetailCode Integer, InfoMoneyDetailName TVarChar
             , CommentInfoMoneyId Integer, CommentInfoMoneyCode Integer, CommentInfoMoneyName TVarChar    
             , KindName TVarChar
               )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Cash());
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId --WHERE inIsErased = TRUE
                       )

        , tmpMovement AS (SELECT Movement.*
                          FROM tmpStatus
                               INNER JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate
                                                  AND Movement.DescId = zc_Movement_Cash()
                                                  AND Movement.StatusId = tmpStatus.StatusId
                          )

        , tmpData AS (SELECT tmpMovement.OperDate
                           , tmpMovement.StatusId
                           , MovementItem.Id       AS MI_Id
                           , MovementItem.ObjectId AS ObjectId
                           , MovementItem.Amount   AS Amount
                      FROM tmpMovement
                           INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement.Id
                                                  AND MovementItem.DescId = zc_MI_Master()
                                                  AND MovementItem.isErased = FALSE
                                                  AND ((MovementItem.Amount < 0 AND inKindName = 'zc_Enum_InfoMoney_Out')
                                                    OR (MovementItem.Amount > 0 AND inKindName = 'zc_Enum_InfoMoney_In'))
                      )
        -- 

       SELECT
             tmpData.OperDate                     AS OperDate
           , MIDate_ServiceDate.ValueData ::TDateTime AS ServiceDate
           , CASE WHEN tmpData.Amount < 0 THEN tmpData.Amount * (-1) ELSE tmpData.Amount END  ::TFloat AS Amount
           , Object_Cash.Id                     AS CashId
           , Object_Cash.ValueData              AS CashName
           , Object_Unit.Id                     AS UnitId
           , Object_Unit.ValueData              AS UnitName
           , Object_InfoMoney.ObjectCode        AS InfoMoneyCode
           , Object_InfoMoney.ValueData         AS InfoMoneyName
           , Object_InfoMoney.Id                AS InfoMoneyDetailId
           , Object_InfoMoney.ObjectCode        AS InfoMoneyDetailCode
           , Object_InfoMoney.ValueData         AS InfoMoneyDetailName
           , Object_CommentInfoMoney.Id         AS CommentInfoMoneyId
           , Object_CommentInfoMoney.ObjectCode AS CommentInfoMoneyCode
           , Object_CommentInfoMoney.ValueData  AS CommentInfoMoneyName 
           , CASE WHEN inKindName = 'zc_Enum_InfoMoney_Out' THEN 'Расход' ELSE 'Приход' END ::TVarChar AS KindName
           
       FROM tmpData
            LEFT JOIN Object AS Object_Cash ON Object_Cash.Id = tmpData.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                             ON MILinkObject_Unit.MovementItemId = tmpData.MI_Id
                                            AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MILinkObject_Unit.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                             ON MILinkObject_InfoMoney.MovementItemId = tmpData.MI_Id
                                            AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
            LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = MILinkObject_InfoMoney.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoneyDetail
                                             ON MILinkObject_InfoMoneyDetail.MovementItemId = tmpData.MI_Id
                                            AND MILinkObject_InfoMoneyDetail.DescId = zc_MILinkObject_InfoMoneyDetail()
            LEFT JOIN Object AS Object_InfoMoneyDetail ON Object_InfoMoneyDetail.Id = MILinkObject_InfoMoneyDetail.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_CommentInfoMoney
                                             ON MILinkObject_CommentInfoMoney.MovementItemId = tmpData.MI_Id
                                            AND MILinkObject_CommentInfoMoney.DescId         = zc_MILinkObject_CommentInfoMoney()
            LEFT JOIN Object AS Object_CommentInfoMoney ON Object_CommentInfoMoney.Id = MILinkObject_CommentInfoMoney.ObjectId

            LEFT JOIN MovementItemDate AS MIDate_ServiceDate
                                       ON MIDate_ServiceDate.MovementItemId = tmpData.MI_Id
                                      AND MIDate_ServiceDate.DescId = zc_MIDate_ServiceDate()

     ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.04.22         *
*/

-- тест
--