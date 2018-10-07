-- Function: gpSelect_Movement_Income()

DROP FUNCTION IF EXISTS gpSelect_Movement_Income (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Income(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , TotalCount TFloat, TotalSummMVAT TFloat, TotalSumm TFloat
             , TotalSummSample TFloat, TotalSummSampleWithVAT TFloat
             , PriceWithVAT Boolean
             , FromId Integer, FromName TVarChar, FromOKPO TVarChar
             , ToId Integer, ToName TVarChar, JuridicalName TVarChar
             , NDSKindId Integer, NDSKindName TVarChar, NDS TFloat
             , ContractId Integer, ContractName TVarChar
             , PaymentDate TDateTime, PaySumm TFloat, SaleSumm TFloat
             , InvNumberBranch TVarChar, BranchDate TDateTime
             , Checked Boolean, isDocument Boolean, isRegistered Boolean
             , PayColor Integer
             , DateLastPay TDateTime
             , Movement_OrderId Integer, Movement_OrderInvNumber TVarChar, Movement_OrderInvNumber_full TVarChar
             , isDeferred Boolean
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime
             , PaymentDays TFloat
             , MemberIncomeCheckId Integer, MemberIncomeCheckName TVarChar, CheckDate TDateTime
             )

AS
$BODY$
   DECLARE vbObjectId Integer;
   DECLARE vbUserId Integer;
BEGIN

-- inStartDate:= '01.01.2013';
-- inEndDate:= '01.01.2100';

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());

     vbUserId:= lpGetUserBySession (inSession);
     -- определяется <Торговая сеть>
     IF vbUserId = 3 THEN vbObjectId:= 0;
     ELSE vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', vbUserId);
     END IF;

     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )
        , tmpUserAdmin AS (SELECT UserId FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = vbUserId)
        , tmpRoleAccessKey AS (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = vbUserId AND NOT EXISTS (SELECT UserId FROM tmpUserAdmin) GROUP BY AccessKeyId
                         UNION SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE EXISTS (SELECT UserId FROM tmpUserAdmin) GROUP BY AccessKeyId
                              )
        , tmpUnit  AS  (SELECT ObjectLink_Unit_Juridical.ObjectId AS UnitId
                        FROM ObjectLink AS ObjectLink_Unit_Juridical
                           INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                 ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                AND (ObjectLink_Juridical_Retail.ChildObjectId = vbObjectId OR vbObjectId = 0)
                        WHERE  ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                        )
        , Movement_Income AS ( SELECT Movement_Income.Id
                                    , Movement_Income.InvNumber
                                    , Movement_Income.OperDate
                                    , Movement_Income.StatusId
                                    , MovementLinkObject_To.ObjectId        AS ToId
                                    , MovementLinkObject_From.ObjectId      AS FromId
                                    , MovementLinkObject_Juridical.ObjectId AS JuridicalId
                                    , Container.Id                   AS PaymentContainerId
                                    , Container.Amount               AS PaySumm
                                    , CASE WHEN Container.Amount <= 0.01 THEN zc_Color_Goods_Additional() END::Integer AS PayColor
                                    , CASE WHEN Container.Amount > 0.01
                                             OR Movement_Income.StatusId <> zc_Enum_Status_Complete()
                                           THEN MovementDate_Payment.ValueData
                                      END::TDateTime AS PaymentDate
                               FROM tmpStatus
                                    LEFT JOIN Movement AS Movement_Income ON Movement_Income.StatusId = tmpStatus.StatusId
                                                                         AND Movement_Income.OperDate >= inStartDate AND Movement_Income.OperDate <inEndDate + interval '1 day'
                                                                         AND Movement_Income.DescId = zc_Movement_Income()
                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                                 ON MovementLinkObject_To.MovementId = Movement_Income.Id
                                                                AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                    INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_To.ObjectId

                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                                 ON MovementLinkObject_From.MovementId = Movement_Income.Id
                                                                AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                                                 ON MovementLinkObject_Juridical.MovementId = Movement_Income.Id
                                                                AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()

                                    LEFT JOIN MovementDate AS MovementDate_Payment
                                                           ON MovementDate_Payment.MovementId =  Movement_Income.Id
                                                          AND MovementDate_Payment.DescId = zc_MovementDate_Payment()
                                    -- Партия накладной
                                    LEFT JOIN Object AS Object_Movement
                                                     ON Object_Movement.ObjectCode = Movement_Income.Id 
                                                    AND Object_Movement.DescId = zc_Object_PartionMovement()
                                    LEFT JOIN Container ON Container.DescId = zc_Container_SummIncomeMovementPayment()
                                                       AND Container.ObjectId = Object_Movement.Id
                                                       AND Container.KeyValue like '%,'||MovementLinkObject_Juridical.ObjectId||';%'
                                    
                            UNION ALL
                               SELECT Movement_Income.Id
                                    , Movement_Income.InvNumber
                                    , Movement_Income.OperDate
                                    , Movement_Income.StatusId
                                    , MovementLinkObject_To.ObjectId        AS ToId
                                    , MovementLinkObject_From.ObjectId      AS FromId
                                    , MovementLinkObject_Juridical.ObjectId AS JuridicalId
                                    , Container.Id                          AS PaymentContainerId
                                    , Container.Amount                      AS PaySumm
                                    , CASE WHEN Container.Amount <= 0.01 THEN zc_Color_Goods_Additional() END::Integer AS PayColor
                                    , CASE WHEN Container.Amount > 0.01
                                             OR Movement_Income.StatusId <> zc_Enum_Status_Complete()
                                           THEN MovementDate_Payment.ValueData
                                      END::TDateTime AS PaymentDate
                               FROM tmpStatus
                                    LEFT JOIN Movement AS Movement_Income ON Movement_Income.StatusId = tmpStatus.StatusId
                                                                         AND Movement_Income.OperDate >= inStartDate AND Movement_Income.OperDate <inEndDate + interval '1 day'
                                                                         AND Movement_Income.DescId = zc_Movement_Income()
                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                                 ON MovementLinkObject_To.MovementId = Movement_Income.Id
                                                                AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                    LEFT JOIN Object ON Object.Id = MovementLinkObject_To.ObjectId AND Object.DescId = zc_Object_Unit()
           
                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                                 ON MovementLinkObject_From.MovementId = Movement_Income.Id
                                                                AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                                                 ON MovementLinkObject_Juridical.MovementId = Movement_Income.Id
                                                                AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
                                    -- Партия накладной

                                    LEFT JOIN MovementDate AS MovementDate_Payment
                                                           ON MovementDate_Payment.MovementId = Movement_Income.Id
                                                          AND MovementDate_Payment.DescId = zc_MovementDate_Payment()

                                    LEFT JOIN Object AS Object_Movement
                                                     ON Object_Movement.ObjectCode = Movement_Income.Id 
                                                    AND Object_Movement.DescId = zc_Object_PartionMovement()
                                    LEFT JOIN Container ON Container.DescId = zc_Container_SummIncomeMovementPayment()
                                                       AND Container.ObjectId = Object_Movement.Id
                                                       AND Container.KeyValue like '%,'||MovementLinkObject_Juridical.ObjectId||';%'
                               WHERE Object.Id IS NULL
                              )
 
        SELECT Movement_Income.Id
             , Movement_Income.InvNumber
             , Movement_Income.OperDate
             , Object_Status.ObjectCode                   AS StatusCode
             , Object_Status.ValueData                    AS StatusName
             , MovementFloat_TotalCount.ValueData         AS TotalCount
             , MovementFloat_TotalSummMVAT.ValueData      AS TotalSummMVAT
             , MovementFloat_TotalSumm.ValueData          AS TotalSumm
             --, MovementFloat_TotalSummSample.ValueData    AS TotalSummSample
             , CASE WHEN MovementBoolean_PriceWithVAT.ValueData
                    THEN (MovementFloat_TotalSummSample.ValueData *100 / (100 + ObjectFloat_NDSKind_NDS.ValueData))
                    ELSE MovementFloat_TotalSummSample.ValueData
               END                               ::TFloat AS TotalSummSample
             , CASE WHEN MovementBoolean_PriceWithVAT.ValueData
                   THEN MovementFloat_TotalSummSample.ValueData
                   ELSE (MovementFloat_TotalSummSample.ValueData * (1 + ObjectFloat_NDSKind_NDS.ValueData/100))
               END                               ::TFloat AS TotalSummSampleWithVAT
             , MovementBoolean_PriceWithVAT.ValueData     AS PriceWithVAT
             , Object_From.Id                             AS FromId
             , Object_From.ValueData                      AS FromName
             , ObjectHistoryString_JuridicalDetails_OKPO.ValueData AS FromOKPO
             , Object_To.Id                               AS ToId      
             , Object_To.Name                             AS ToName
             , Object_Juridical.ValueData                 AS JuridicalName
             , MovementLinkObject_NDSKind.ObjectId        AS NDSKindId
             , Object_NDSKind.ValueData                   AS NDSKindName
             , ObjectFloat_NDSKind_NDS.ValueData          AS NDS
             , MovementLinkObject_Contract.ObjectId       AS ContractId
             , Object_Contract.ValueData                  AS ContractName
             , Movement_Income.PaymentDate 
             , Movement_Income.PaySumm
             , MovementFloat_TotalSummSale.ValueData      AS SaleSumm
             , MovementString_InvNumberBranch.ValueData   AS InvNumberBranch
             , MovementDate_Branch.ValueData              AS BranchDate
             , COALESCE(MovementBoolean_Checked.ValueData, false)     AS Checked
             , COALESCE(MovementBoolean_Document.ValueData, false)    AS isDocument
             , MovementBoolean_Registered.ValueData                   AS isRegistered -- !!!иногда будем возвращать NULL!!!
             , Movement_Income.PayColor
             , MAX(MovementItemContainer.OperDate)::TDateTime AS LastDatePay
             , Movement_Order.Id                    AS Movement_OrderId
             , Movement_Order.InvNumber             AS Movement_OrderInvNumber
             , ('№ ' || Movement_Order.InvNumber ||' от '||TO_CHAR(Movement_Order.OperDate , 'DD.MM.YYYY') ) :: TVarChar AS Movement_OrderInvNumber_full
             , COALESCE (MovementBoolean_Deferred.ValueData, FALSE) :: Boolean  AS isDeferred

             , Object_Insert.ValueData              AS InsertName
             , MovementDate_Insert.ValueData        AS InsertDate
             , Object_Update.ValueData              AS UpdateName
             , MovementDate_Update.ValueData        AS UpdateDate

             , (Movement_Income.PaymentDate::Date - Movement_Income.OperDate::Date) ::TFloat AS PaymentDays 

             , Object_MemberIncomeCheck.Id          AS MemberIncomeCheckId
             , Object_MemberIncomeCheck.ValueData   AS MemberIncomeCheckName
             , MovementDate_Check.ValueData         AS CheckDate
        FROM Movement_Income

        LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement_Income.StatusId
        LEFT JOIN Object_Unit_View AS Object_To ON Object_To.Id = Movement_Income.ToId
        LEFT JOIN Object AS Object_From ON Object_From.Id = Movement_Income.FromId
        LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = Movement_Income.JuridicalId

        LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                ON MovementFloat_TotalCount.MovementId = Movement_Income.Id
                               AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

        LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                ON MovementFloat_TotalSumm.MovementId = Movement_Income.Id
                               AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

        LEFT JOIN MovementFloat AS MovementFloat_TotalSummSale
                                ON MovementFloat_TotalSummSale.MovementId = Movement_Income.Id
                               AND MovementFloat_TotalSummSale.DescId = zc_MovementFloat_TotalSummSale()

        LEFT JOIN MovementFloat AS MovementFloat_TotalSummSample
                                ON MovementFloat_TotalSummSample.MovementId = Movement_Income.Id
                               AND MovementFloat_TotalSummSample.DescId = zc_MovementFloat_TotalSummSample()

        LEFT JOIN MovementFloat AS MovementFloat_TotalSummMVAT
                                ON MovementFloat_TotalSummMVAT.MovementId = Movement_Income.Id
                               AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()

        LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                     ON MovementLinkObject_NDSKind.MovementId = Movement_Income.Id
                                    AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()
        LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = MovementLinkObject_NDSKind.ObjectId

        LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                              ON ObjectFloat_NDSKind_NDS.ObjectId = MovementLinkObject_NDSKind.ObjectId 
                             AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()   
                             
        LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                     ON MovementLinkObject_Contract.MovementId = Movement_Income.Id
                                    AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
        LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId

        LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                  ON MovementBoolean_PriceWithVAT.MovementId = Movement_Income.Id
                                 AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()

        LEFT JOIN MovementBoolean AS MovementBoolean_Checked
                                  ON MovementBoolean_Checked.MovementId = Movement_Income.Id
                                 AND MovementBoolean_Checked.DescId = zc_MovementBoolean_Checked()

        LEFT JOIN MovementBoolean AS MovementBoolean_Registered
                                  ON MovementBoolean_Registered.MovementId = Movement_Income.Id
                                 AND MovementBoolean_Registered.DescId = zc_MovementBoolean_Registered()

        LEFT JOIN MovementBoolean AS MovementBoolean_Document
                                  ON MovementBoolean_Document.MovementId = Movement_Income.Id
                                 AND MovementBoolean_Document.DescId = zc_MovementBoolean_Document()

        LEFT JOIN MovementDate    AS MovementDate_Payment
                                  ON MovementDate_Payment.MovementId = Movement_Income.Id
                                 AND MovementDate_Payment.DescId = zc_MovementDate_Payment()

        LEFT JOIN MovementDate    AS MovementDate_Branch
                                  ON MovementDate_Branch.MovementId = Movement_Income.Id
                                 AND MovementDate_Branch.DescId = zc_MovementDate_Branch()

        LEFT JOIN MovementDate    AS MovementDate_Check
                                  ON MovementDate_Check.MovementId = Movement_Income.Id
                                 AND MovementDate_Check.DescId = zc_MovementDate_Check()

        LEFT JOIN MovementString  AS MovementString_InvNumberBranch
                                  ON MovementString_InvNumberBranch.MovementId = Movement_Income.Id
                                 AND MovementString_InvNumberBranch.DescId = zc_MovementString_InvNumberBranch()

        LEFT JOIN MovementItemContainer ON MovementItemContainer.ContainerId = Movement_Income.PaymentContainerId
                                       AND MovementItemContainer.MovementDescId in (zc_Movement_BankAccount(), zc_Movement_Payment())

        LEFT JOIN MovementDate AS MovementDate_Insert
                               ON MovementDate_Insert.MovementId = Movement_Income.Id
                              AND MovementDate_Insert.DescId = zc_MovementDate_Insert()

        LEFT JOIN MovementLinkObject AS MLO_Insert
                                     ON MLO_Insert.MovementId = Movement_Income.Id
                                    AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
        LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId  

        LEFT JOIN MovementDate AS MovementDate_Update
                               ON MovementDate_Update.MovementId = Movement_Income.Id
                              AND MovementDate_Update.DescId = zc_MovementDate_Update()
        LEFT JOIN MovementLinkObject AS MLO_Update
                                     ON MLO_Update.MovementId = Movement_Income.Id
                                    AND MLO_Update.DescId = zc_MovementLinkObject_Update()
        LEFT JOIN Object AS Object_Update ON Object_Update.Id = MLO_Update.ObjectId  

        LEFT OUTER JOIN ObjectHistory AS ObjectHistory_Juridical
                                      ON ObjectHistory_Juridical.ObjectId = Object_From.Id
                                     AND ObjectHistory_Juridical.DescId = zc_ObjectHistory_JuridicalDetails()
                                     AND Movement_Income.OperDate >= ObjectHistory_Juridical.StartDate AND Movement_Income.OperDate < ObjectHistory_Juridical.EndDate
        LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_OKPO
                                      ON ObjectHistoryString_JuridicalDetails_OKPO.ObjectHistoryId = ObjectHistory_Juridical.Id
                                     AND ObjectHistoryString_JuridicalDetails_OKPO.DescId = zc_ObjectHistoryString_JuridicalDetails_OKPO()

        LEFT JOIN MovementLinkMovement AS MLM_Order
                                       ON MLM_Order.MovementId = Movement_Income.Id
                                      AND MLM_Order.DescId = zc_MovementLinkMovement_Order()
        LEFT JOIN Movement AS Movement_Order ON Movement_Order.Id = MLM_Order.MovementChildId
        -- заказ отложен
        LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                  ON MovementBoolean_Deferred.MovementId = Movement_Order.Id
                                 AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()

        LEFT JOIN MovementLinkObject AS MLO_MemberIncomeCheck
                                     ON MLO_MemberIncomeCheck.MovementId = Movement_Income.Id
                                    AND MLO_MemberIncomeCheck.DescId = zc_MovementLinkObject_MemberIncomeCheck()
        LEFT JOIN Object AS Object_MemberIncomeCheck ON Object_MemberIncomeCheck.Id = MLO_MemberIncomeCheck.ObjectId 

        GROUP BY Movement_Income.Id
               , Movement_Income.InvNumber
               , Movement_Income.OperDate
               , Object_Status.ObjectCode              
               , Object_Status.ValueData               
               , MovementFloat_TotalCount.ValueData    
               , MovementFloat_TotalSummMVAT.ValueData 
               , MovementFloat_TotalSumm.ValueData 
               , MovementFloat_TotalSummSample.ValueData    
               , MovementBoolean_PriceWithVAT.ValueData
               , Object_From.Id      
               , Object_From.ValueData                  
               , ObjectHistoryString_JuridicalDetails_OKPO.ValueData 
               , Object_To.Id                             
               , Object_To.Name                           
               , Object_Juridical.ValueData               
               , MovementLinkObject_NDSKind.ObjectId      
               , Object_NDSKind.ValueData     
               , ObjectFloat_NDSKind_NDS.ValueData            
               , MovementLinkObject_Contract.ObjectId 
               , Object_Contract.ValueData    
               , Movement_Income.PaymentDate 
               , Movement_Income.PaySumm
               , MovementFloat_TotalSummSale.ValueData     
               , MovementString_InvNumberBranch.ValueData  
               , MovementDate_Branch.ValueData             
               , COALESCE(MovementBoolean_Checked.ValueData, false) 
               , COALESCE(MovementBoolean_Document.ValueData, false)
               , MovementBoolean_Registered.ValueData 
               , Movement_Income.PayColor
               , Movement_Order.Id              
               , Movement_Order.InvNumber  
               , COALESCE (MovementBoolean_Deferred.ValueData, FALSE)     
               , Object_Insert.ValueData        
               , MovementDate_Insert.ValueData  
               , Object_Update.ValueData        
               , MovementDate_Update.ValueData  
               , Object_MemberIncomeCheck.Id  
               , Object_MemberIncomeCheck.ValueData
               , MovementDate_Check.ValueData
;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_Income (TDateTime, TDateTime, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.
 24.09.18         *
 05.01.18         * add NDS
 15.01.17         * без вьюх
 18.10.16         * add isRegistered
 04.08.16         *
 04.05.16         *
 22.04.16         * 
 30.01.16         * 
 21.12.15                                                                        *
 10.12.15                                                                        *
 08.12.15                                                                        *
 28.04.15                        *
 11.02.15                        *
 23.12.14                        *
 15.07.14                                                        *
 10.07.14                                                        *

*/

-- тест
--SELECT * FROM gpSelect_Movement_Income (inStartDate:= '29.01.2016', inEndDate:= '01.02.2016', inIsErased := FALSE, inSession:= '2')
--where PaymentDate is not null