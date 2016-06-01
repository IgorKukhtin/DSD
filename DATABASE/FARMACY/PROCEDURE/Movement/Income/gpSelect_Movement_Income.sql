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
             , PriceWithVAT Boolean
             , FromId Integer, FromName TVarChar, FromOKPO TVarChar
             , ToId Integer, ToName TVarChar, JuridicalName TVarChar
             , NDSKindId Integer, NDSKindName TVarChar
             , ContractId Integer, ContractName TVarChar
             , PaymentDate TDateTime, PaySumm TFloat, SaleSumm TFloat
             , InvNumberBranch TVarChar, BranchDate TDateTime
             , Checked Boolean, isDocument Boolean 
             , PayColor Integer
             , DateLastPay TDateTime
             , Movement_OrderId Integer, Movement_OrderInvNumber TVarChar, Movement_OrderInvNumber_full TVarChar
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime
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
        , Movement_Income AS (
                               SELECT
                                     Movement_Income_View.Id
                                   , Movement_Income_View.InvNumber
                                   , Movement_Income_View.OperDate
                                   , Movement_Income_View.StatusCode
                                   , Movement_Income_View.StatusName
                                   , Movement_Income_View.TotalCount
                                   , Movement_Income_View.TotalSummMVAT
                                   , Movement_Income_View.TotalSumm
                                   , Movement_Income_View.PriceWithVAT
                                   , Movement_Income_View.FromId
                                   , Movement_Income_View.FromName 
                                   , ObjectHistoryString_JuridicalDetails_OKPO.ValueData AS FromOKPO
                                   , Movement_Income_View.ToId
                                   , Movement_Income_View.ToName
                                   , Movement_Income_View.JuridicalName
                                   , Movement_Income_View.NDSKindId
                                   , Movement_Income_View.NDSKindName
                                   , Movement_Income_View.ContractId
                                   , Movement_Income_View.ContractName
                                   , CASE WHEN Movement_Income_View.PaySumm > 0.01
                                            OR Movement_Income_View.StatusId <> zc_Enum_Status_Complete()
                                          THEN Movement_Income_View.PaymentDate 
                                     END::TDateTime AS PaymentDate
                                   , Movement_Income_View.PaySumm
                                   , Movement_Income_View.SaleSumm
                                   , Movement_Income_View.InvNumberBranch
                                   , Movement_Income_View.BranchDate
                                   , Movement_Income_View.Checked
                                   , Movement_Income_View.isDocument
                                   , CASE WHEN Movement_Income_View.PaySumm <= 0.01 THEN zc_Color_Goods_Additional() END::Integer AS PayColor
                                   , Movement_Income_View.PaymentContainerId
                                   , MLM_Order.MovementChildId          AS Movement_OrderId
                               FROM tmpUnit
                                     LEFT JOIN Movement_Income_View ON Movement_Income_View.ToId = tmpUnit.UnitId
                                                                   AND Movement_Income_View.OperDate BETWEEN inStartDate AND inEndDate
                                     JOIN tmpStatus ON tmpStatus.StatusId = Movement_Income_View.StatusId 

                                     LEFT OUTER JOIN ObjectHistory AS ObjectHistory_Juridical
                                                                   ON ObjectHistory_Juridical.ObjectId = Movement_Income_View.FromId
                                                                  AND ObjectHistory_Juridical.DescId = zc_ObjectHistory_JuridicalDetails()
                                                                  AND Movement_Income_View.OperDate >= ObjectHistory_Juridical.StartDate AND Movement_Income_View.OperDate < ObjectHistory_Juridical.EndDate
                                     LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_OKPO
                                                                   ON ObjectHistoryString_JuridicalDetails_OKPO.ObjectHistoryId = ObjectHistory_Juridical.Id
                                                                  AND ObjectHistoryString_JuridicalDetails_OKPO.DescId = zc_ObjectHistoryString_JuridicalDetails_OKPO()

                                     LEFT JOIN MovementLinkMovement AS MLM_Order
                                                                    ON MLM_Order.MovementId = Movement_Income_View.Id
                                                                   AND MLM_Order.DescId = zc_MovementLinkMovement_Order()
                              )

        SELECT 
            Movement_Income.Id
          , Movement_Income.InvNumber
          , Movement_Income.OperDate
          , Movement_Income.StatusCode
          , Movement_Income.StatusName
          , Movement_Income.TotalCount
          , Movement_Income.TotalSummMVAT
          , Movement_Income.TotalSumm
          , Movement_Income.PriceWithVAT
          , Movement_Income.FromId
          , Movement_Income.FromName
          , Movement_Income.FromOKPO
          , Movement_Income.ToId
          , Movement_Income.ToName
          , Movement_Income.JuridicalName
          , Movement_Income.NDSKindId
          , Movement_Income.NDSKindName
          , Movement_Income.ContractId
          , Movement_Income.ContractName
          , Movement_Income.PaymentDate
          , Movement_Income.PaySumm
          , Movement_Income.SaleSumm
          , Movement_Income.InvNumberBranch
          , Movement_Income.BranchDate
          , Movement_Income.Checked
          , Movement_Income.isDocument
          , Movement_Income.PayColor
          , MAX(MovementItemContainer.OperDate)::TDateTime AS LastDatePay

          , Movement_Order.Id                    AS Movement_OrderId
          , Movement_Order.InvNumber             AS Movement_OrderInvNumber
          , ('№ ' || Movement_Order.InvNumber ||' от '||TO_CHAR(Movement_Order.OperDate , 'DD.MM.YYYY') ) :: TVarChar AS Movement_OrderInvNumber_full

          , Object_Insert.ValueData              AS InsertName
          , ObjectDate_Protocol_Insert.ValueData AS InsertDate
          , Object_Update.ValueData              AS UpdateName
          , ObjectDate_Protocol_Update.ValueData AS UpdateDate


        FROM
            Movement_Income
            LEFT JOIN Movement AS Movement_Order ON Movement_Order.Id = Movement_Income.Movement_OrderId

            LEFT OUTER JOIN MovementItemContainer ON MovementItemContainer.ContainerId = Movement_Income.PaymentContainerId
                                                 AND MovementItemContainer.MovementDescId in (zc_Movement_BankAccount(), zc_Movement_Payment())

            LEFT JOIN ObjectDate AS ObjectDate_Protocol_Insert
                                 ON ObjectDate_Protocol_Insert.ObjectId = Movement_Income.Id
                                AND ObjectDate_Protocol_Insert.DescId = zc_ObjectDate_Protocol_Insert()
            LEFT JOIN ObjectLink AS ObjectLink_Insert
                                 ON ObjectLink_Insert.ObjectId = Movement_Income.Id
                                AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId  

            LEFT JOIN ObjectDate AS ObjectDate_Protocol_Update
                                 ON ObjectDate_Protocol_Update.ObjectId = Movement_Income.Id
                                AND ObjectDate_Protocol_Update.DescId = zc_ObjectDate_Protocol_Update()
            LEFT JOIN ObjectLink AS ObjectLink_Update
                                 ON ObjectLink_Update.ObjectId = Movement_Income.Id
                                AND ObjectLink_Update.DescId = zc_ObjectLink_Protocol_Update()
            LEFT JOIN Object AS Object_Update ON Object_Update.Id = ObjectLink_Update.ChildObjectId  
        GROUP BY
            Movement_Income.Id
          , Movement_Income.InvNumber
          , Movement_Income.OperDate
          , Movement_Income.StatusCode
          , Movement_Income.StatusName
          , Movement_Income.TotalCount
          , Movement_Income.TotalSummMVAT
          , Movement_Income.TotalSumm
          , Movement_Income.PriceWithVAT
          , Movement_Income.FromId
          , Movement_Income.FromName
          , Movement_Income.FromOKPO
          , Movement_Income.ToId
          , Movement_Income.ToName
          , Movement_Income.JuridicalName
          , Movement_Income.NDSKindId
          , Movement_Income.NDSKindName
          , Movement_Income.ContractId
          , Movement_Income.ContractName
          , Movement_Income.PaymentDate
          , Movement_Income.PaySumm
          , Movement_Income.SaleSumm
          , Movement_Income.InvNumberBranch
          , Movement_Income.BranchDate
          , Movement_Income.Checked
          , Movement_Income.isDocument
          , Movement_Income.PayColor
          , Movement_Order.InvNumber
          , Movement_Order.Id 
          , Object_Insert.ValueData
          , ObjectDate_Protocol_Insert.ValueData
          , Object_Update.ValueData
          , ObjectDate_Protocol_Update.ValueData
;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_Income (TDateTime, TDateTime, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.
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
--where Movement_OrderId<>0