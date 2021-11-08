-- Function: gpGet_Movement_Income()

DROP FUNCTION IF EXISTS gpGet_Movement_Income (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_Movement_Income(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , PriceWithVAT Boolean
             , FromId Integer, FromName TVarChar
             , ToId Integer, ToName TVarChar
             , NDSKindId Integer, NDSKindName TVarChar
             , ContractId Integer, ContractName TVarChar
             , PaymentDate TDateTime
             , InvNumberBranch TVarChar, BranchDate TDateTime
             , Checked Boolean, isDocument Boolean, isRegistered Boolean
             , JuridicalId Integer, JuridicalName TVarChar
             , MemberIncomeCheckId Integer, MemberIncomeCheckName TVarChar, CheckDate TDateTime
             , IsPay Boolean, DateLastPay TDateTime
             , Movement_OrderId Integer, Movement_OrderInvNumber TVarChar, Movement_OrderInvNumber_full TVarChar
             , isDeferred Boolean
             , isDifferent Boolean
             , UpdateDate_Order TDateTime
             , OrderKindId Integer, OrderKindName TVarChar
             , Comment TVarChar, isUseNDSKind Boolean
             , isConduct Boolean, DateConduct TDateTime
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Income());
     vbUserId := inSession;

     IF COALESCE (inMovementId, 0) = 0
     THEN
     RETURN QUERY
         SELECT
               0                                                AS Id
             , CAST (NEXTVAL ('movement_Income_seq') AS TVarChar) AS InvNumber
             , CURRENT_DATE::TDateTime                          AS OperDate
             , Object_Status.Code                               AS StatusCode
             , Object_Status.Name                               AS StatusName
             , CAST (False as Boolean)                          AS PriceWithVAT
             , 0                                                AS FromId
             , CAST ('' AS TVarChar)                            AS FromName
             , 0                                                AS ToId
             , CAST ('' AS TVarChar)                            AS ToName
             , 0                                                AS NDSKindId
             , CAST ('' AS TVarChar)                            AS NDSKindName
             , 0                                                AS ContractId
             , CAST ('' AS TVarChar)                            AS ContractName
             , CURRENT_DATE::TDateTime                          AS PaymentDate
             , ''::TVarChar                                     AS InvNumberBranch
             , CURRENT_DATE::TDateTime                          AS BranchDate
             , false                                            AS Checked
             , false                                            AS isDocument  
             , false                                            AS isRegistered  
             , 0                                                AS JuridicalId
             , CAST('' as TVarChar)                             AS JuridicalName

             , 0                                                AS MemberIncomeCheckId 
             , CAST('' as TVarChar)                             AS MemberIncomeCheckName
             , NULL ::TDateTime                                 AS CheckDate

             , False                                            AS isPay
             , NULL::TDateTime                                  AS DateLastPay
    
             , 0                                                AS Movement_OrderId
             , CAST('' as TVarChar)                             AS Movement_OrderInvNumber
             , CAST('' as TVarChar)                             AS Movement_OrderInvNumber_full
             , false                                            AS isDeferred 
             , false                                            AS isDifferent

             , NULL ::TDateTime                                 AS UpdateDate_Order
             , 0                                                AS OrderKindId
             , CAST('' as TVarChar)                             AS OrderKindName
             , CAST ('' AS TVarChar) 		                    AS Comment
             , false                                            AS isUseNDSKind  
             , false                                            AS isConduct 
             , NULL ::TDateTime                                 AS DateConduct
             
          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status;

     ELSE

     RETURN QUERY
        WITH 
        Movement_Income AS (
                        SELECT
                             Movement_Income_View.Id
                           , Movement_Income_View.InvNumber
                           , Movement_Income_View.OperDate
                           , Movement_Income_View.StatusCode
                           , Movement_Income_View.StatusName
                           , Movement_Income_View.PriceWithVAT
                           , Movement_Income_View.FromId
                           , Movement_Income_View.FromName
                           , Movement_Income_View.ToId
                           , Movement_Income_View.ToName
                           , Movement_Income_View.NDSKindId
                           , Movement_Income_View.NDSKindName
                           , Movement_Income_View.ContractId
                           , Movement_Income_View.ContractName
                           , CASE WHEN Movement_Income_View.PaySumm > 0.01 
                                    OR Movement_Income_View.StatusId <> zc_Enum_Status_Complete() 
                                  THEN Movement_Income_View.PaymentDate 
                             END::TDateTime AS PaymentDate
                           , Movement_Income_View.InvNumberBranch
                           , Movement_Income_View.BranchDate
                           , COALESCE(Movement_Income_View.Checked, false)      AS Checked
                           , COALESCE(Movement_Income_View.isDocument, false)   AS isDocument
                           , COALESCE(Movement_Income_View.isRegistered, false) AS isRegistered
                           , Movement_Income_View.JuridicalId
                           , Movement_Income_View.JuridicalName
                           , Movement_Income_View.MemberIncomeCheckId 
                           , Movement_Income_View.MemberIncomeCheckName
                           , Movement_Income_View.CheckDate
                           , CASE WHEN Movement_Income_View.PaySumm <= 0.01 then TRUE ELSE FALSE END AS isPay
                           , Movement_Income_View.PaymentContainerId
                           , MLM_Order.MovementChildId          AS Movement_OrderId
                        FROM Movement_Income_View
                           LEFT JOIN MovementLinkMovement AS MLM_Order
                                                          ON MLM_Order.MovementId = Movement_Income_View.Id
                                                         AND MLM_Order.DescId = zc_MovementLinkMovement_Order()

                        WHERE Movement_Income_View.Id = inMovementId
                    )
        SELECT 
            Movement_Income.Id
          , Movement_Income.InvNumber
          , Movement_Income.OperDate
          , Movement_Income.StatusCode
          , Movement_Income.StatusName
          , Movement_Income.PriceWithVAT
          , Movement_Income.FromId
          , Movement_Income.FromName
          , Movement_Income.ToId
          , Movement_Income.ToName
          , Movement_Income.NDSKindId
          , Movement_Income.NDSKindName
          , Movement_Income.ContractId
          , Movement_Income.ContractName
          , Movement_Income.PaymentDate
          , Movement_Income.InvNumberBranch
          , Movement_Income.BranchDate
          , Movement_Income.Checked
          , Movement_Income.isDocument
          , Movement_Income.isRegistered
          , Movement_Income.JuridicalId
          , Movement_Income.JuridicalName
          , Movement_Income.MemberIncomeCheckId 
          , Movement_Income.MemberIncomeCheckName
          , Movement_Income.CheckDate
          , Movement_Income.isPay
          , MAX(MovementItemContainer.OperDate)::TDateTime AS LastDatePay

          , Movement_Order.Id                              AS Movement_OrderId
          , Movement_Order.InvNumber                       AS Movement_OrderInvNumber
          , ('№ ' || Movement_Order.InvNumber ||' от '||TO_CHAR(Movement_Order.OperDate , 'DD.MM.YYYY') ) :: TVarChar AS Movement_OrderInvNumber_full
          , COALESCE (MovementBoolean_Deferred.ValueData, FALSE)  :: Boolean  AS isDeferred
          , COALESCE (MovementBoolean_Different.ValueData, FALSE) :: Boolean  AS isDifferent

          , COALESCE (MovementDate_Update_Order.ValueData, NULL) :: TDateTime AS UpdateDate_Order
          , Object_OrderKind.Id                            AS OrderKindId
          , Object_OrderKind.ValueData                     AS OrderKindName
          , COALESCE (MovementString_Comment.ValueData,'')        :: TVarChar AS Comment
          , COALESCE (MovementBoolean_UseNDSKind.ValueData, FALSE)            AS isUseNDSKind 

          , COALESCE (MovementBoolean_Conduct.ValueData, FALSE)               AS isConduct
          , MovementDate_Conduct.ValueData                                    AS DateConduct

        FROM Movement_Income
             LEFT JOIN Movement AS Movement_Order ON Movement_Order.Id = Movement_Income.Movement_OrderId
             LEFT OUTER JOIN MovementItemContainer ON MovementItemContainer.ContainerId = Movement_Income.PaymentContainerId
                                                  AND MovementItemContainer.MovementDescId in (zc_Movement_BankAccount(), zc_Movement_Payment())
             -- заказ отложен
             LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                       ON MovementBoolean_Deferred.MovementId = Movement_Order.Id
                                      AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
             -- точка другого юр.лица
             LEFT JOIN MovementBoolean AS MovementBoolean_Different
                                       ON MovementBoolean_Different.MovementId = Movement_Income.Id
                                      AND MovementBoolean_Different.DescId = zc_MovementBoolean_Different()

             LEFT JOIN MovementBoolean AS MovementBoolean_UseNDSKind
                                       ON MovementBoolean_UseNDSKind.MovementId = Movement_Income.Id
                                      AND MovementBoolean_UseNDSKind.DescId = zc_MovementBoolean_UseNDSKind()

             LEFT JOIN MovementString AS MovementString_Comment
                                      ON MovementString_Comment.MovementId = Movement_Income.Id
                                     AND MovementString_Comment.DescId = zc_MovementString_Comment()

             LEFT JOIN MovementLinkMovement AS MLM_Master
                                            ON MLM_Master.MovementId = Movement_Order.Id
                                           AND MLM_Master.DescId = zc_MovementLinkMovement_Master()
             LEFT JOIN MovementLinkObject AS MovementLinkObject_OrderKind
                                          ON MovementLinkObject_OrderKind.MovementId = MLM_Master.MovementChildId
                                         AND MovementLinkObject_OrderKind.DescId = zc_MovementLinkObject_OrderKind()
             LEFT JOIN Object AS Object_OrderKind ON Object_OrderKind.Id = MovementLinkObject_OrderKind.ObjectId

             LEFT JOIN MovementDate AS MovementDate_Update_Order
                                    ON MovementDate_Update_Order.MovementId = Movement_Order.Id
                                   AND MovementDate_Update_Order.DescId = zc_MovementDate_Update()

            LEFT JOIN MovementBoolean AS MovementBoolean_Conduct
                                      ON MovementBoolean_Conduct.MovementId = Movement_Income.Id
                                     AND MovementBoolean_Conduct.DescId = zc_MovementBoolean_Conduct()
            LEFT JOIN MovementDate AS MovementDate_Conduct
                                   ON MovementDate_Conduct.MovementId = Movement_Income.Id
                                  AND MovementDate_Conduct.DescId = zc_MovementDate_Conduct()

        GROUP BY
            Movement_Income.Id
          , Movement_Income.InvNumber
          , Movement_Income.OperDate
          , Movement_Income.StatusCode
          , Movement_Income.StatusName
          , Movement_Income.PriceWithVAT
          , Movement_Income.FromId
          , Movement_Income.FromName
          , Movement_Income.ToId
          , Movement_Income.ToName
          , Movement_Income.NDSKindId
          , Movement_Income.NDSKindName
          , Movement_Income.ContractId
          , Movement_Income.ContractName
          , Movement_Income.PaymentDate
          , Movement_Income.InvNumberBranch
          , Movement_Income.BranchDate
          , Movement_Income.Checked
          , Movement_Income.isDocument
          , Movement_Income.isRegistered
          , Movement_Income.JuridicalId
          , Movement_Income.JuridicalName
          , Movement_Income.MemberIncomeCheckId 
          , Movement_Income.MemberIncomeCheckName
          , Movement_Income.CheckDate
          , Movement_Income.isPay
          , Movement_Order.InvNumber
          , Movement_Order.Id  
          , COALESCE (MovementBoolean_Deferred.ValueData, FALSE)
          , COALESCE (MovementBoolean_Different.ValueData, FALSE)
          , COALESCE (MovementDate_Update_Order.ValueData, NULL)
          , Object_OrderKind.Id
          , Object_OrderKind.ValueData
          , COALESCE (MovementString_Comment.ValueData,'')
          , COALESCE (MovementBoolean_UseNDSKind.ValueData, FALSE)
          , COALESCE (MovementBoolean_Conduct.ValueData, FALSE)
          , MovementDate_Conduct.ValueData
          ;
    END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_Movement_Income (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.  Шаблий О.В.
 14.04.20                                                                                    * UseNDSKind
 09.09.19         * isDifferent
 23.07.19         *
 18.10.16         * add isRegistered
 22.04.16         *
 30.01.16         *
 21.12.15                                                                       *
 07.12.15                                                                       *
 21.05.15                         *
 03.07.14                                                        *
*/

-- тест
-- SELECT * FROM gpGet_Movement_Income (inMovementId:= 25560862, inSession:= '9818')
