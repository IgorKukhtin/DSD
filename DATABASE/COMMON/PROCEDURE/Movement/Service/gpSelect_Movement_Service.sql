-- Function: gpSelect_Movement_Service()

DROP FUNCTION IF EXISTS gpSelect_Movement_Service (TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_Service (TDateTime, TDateTime, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_Service (TDateTime, TDateTime, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_Service (TDateTime, TDateTime, Integer, Integer, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_Service (TDateTime, TDateTime, Integer, Integer, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpSelect_Movement_Service(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inJuridicalBasisId  Integer   , -- Главное юр.лицо
    IN inSettingsServiceId Integer   , --  inSettingsServiceId > 0 тогда ограничение, если < 0 - тогда исключение
    --IN inIsWith            Boolean   , -- исключать inSettingsServiceId Да/Нет
    IN inIsErased          Boolean   ,
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , OperDatePartner TDateTime, InvNumberPartner TVarChar
             , AmountIn TFloat, AmountOut TFloat
             , AmountCurrencyDebet TFloat, AmountCurrencyKredit TFloat
             , CountDebet TFloat, CountKredit TFloat, Price TFloat, Summa_calc TFloat
             , CurrencyPartnerValue TFloat, ParPartnerValue TFloat
             , CurrencyPartnerName TVarChar
             , Comment TVarChar
             , RetailId Integer, RetailName TVarChar
             , JuridicalCode Integer, JuridicalName TVarChar, ItemName TVarChar, OKPO TVarChar
             , InfoMoneyGroupName TVarChar
             , InfoMoneyDestinationName TVarChar
             , InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , ContractCode Integer, ContractInvNumber TVarChar, ContractTagName TVarChar
             , UnitName TVarChar
             , PaidKindName TVarChar
             , CostMovementId TVarChar, CostMovementInvNumber TVarChar
             , MovementId_Invoice Integer, InvNumber_Invoice TVarChar
             , AssetId Integer, AssetCode Integer, AssetName TVarChar
             )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Service());
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY 
       WITH tmpStatus AS (SELECT zc_Enum_Status_Complete() AS StatusId
                         UNION
                          SELECT zc_Enum_Status_UnComplete() AS StatusId
                         UNION
                          SELECT zc_Enum_Status_Erased() AS StatusId WHERE inIsErased = TRUE
                         )
           , tmpCost AS (SELECT MovementFloat.ValueData :: Integer AS MovementServiceId
                              , STRING_AGG ( '№ '|| Movement_Income.InvNumber || ' oт '|| TO_CHAR (Movement_Income.Operdate , 'DD.MM.YYYY')|| '. ' , ', ') AS strInvNumber
                         FROM MovementFloat
                              INNER JOIN Movement AS Movement_Cost
                                                  ON Movement_Cost.Id = MovementFloat.MovementId :: Integer
                                                 AND Movement_Cost.StatusId <> zc_Enum_Status_Erased()
                              INNER JOIN Movement AS Movement_Income
                                                  ON Movement_Income.Id = Movement_Cost.ParentId
                                                 --AND Movement_Income.DescId = zc_Movement_Income()

                              JOIN Movement ON Movement.Id     = MovementFloat.ValueData :: Integer
                                           AND Movement.DescId = zc_Movement_Service()
                                           AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                                           --AND Movement.StatusId = tmpStatus.StatusId
                              JOIN (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = vbUserId GROUP BY AccessKeyId) AS tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = Movement.AccessKeyId
                  
                         WHERE MovementFloat.DescId = zc_MovementFloat_MovementId()
                         GROUP BY MovementFloat.ValueData
                        )

           , tmpInfoMoneyDestination AS (SELECT DISTINCT ObjectLink_InfoMoneyDestination.ChildObjectId  AS InfoMoneyDestinationId
                                    FROM Object AS Object_SettingsService
                                        INNER JOIN ObjectLink AS ObjectLink_SettingsService
                                                              ON ObjectLink_SettingsService.ChildObjectId = Object_SettingsService.Id
                                                             AND ObjectLink_SettingsService.DescId = zc_ObjectLink_SettingsServiceItem_SettingsService()
                                        INNER JOIN ObjectLink AS ObjectLink_InfoMoneyDestination
                                                              ON ObjectLink_InfoMoneyDestination.DescId = zc_ObjectLink_SettingsServiceItem_InfoMoneyDestination()
                                                             AND ObjectLink_InfoMoneyDestination.ObjectId = ObjectLink_SettingsService.ObjectId
                                        INNER JOIN Object AS Object_SettingsServiceItem 
                                                          ON Object_SettingsServiceItem.Id = ObjectLink_SettingsService.ObjectId
                                                         AND Object_SettingsServiceItem.isErased = FALSE
                                    WHERE Object_SettingsService.DescId = zc_Object_SettingsService()
                                      AND (Object_SettingsService.Id = ABS(inSettingsServiceId) AND inSettingsServiceId <> 0) --3175171 --
                                      AND Object_SettingsService.isErased = FALSE
                                    )

           , tmpInfoMoney_View AS (SELECT Object_InfoMoney_View.*
                                   FROM Object_InfoMoney_View
                                        LEFT JOIN tmpInfoMoneyDestination ON tmpInfoMoneyDestination.InfoMoneyDestinationId = Object_InfoMoney_View.InfoMoneyDestinationId
                                   WHERE (COALESCE (tmpInfoMoneyDestination.InfoMoneyDestinationId,0) <> 0 AND inSettingsServiceId > 0)
                                      OR (COALESCE (tmpInfoMoneyDestination.InfoMoneyDestinationId,0) = 0 AND inSettingsServiceId < 0)
                                      OR inSettingsServiceId = 0
                                   )

       SELECT
             Movement.Id                                    AS Id
           , Movement.InvNumber                             AS InvNumber
           , Movement.OperDate                              AS OperDate
           , Object_Status.ObjectCode                       AS StatusCode
           , Object_Status.ValueData                        AS StatusName

           , MovementDate_OperDatePartner.ValueData         AS OperDatePartner
           , MovementString_InvNumberPartner.ValueData      AS InvNumberPartner

           , CASE WHEN MovementItem.Amount > 0
                       THEN MovementItem.Amount
                  ELSE 0
             END                                  :: TFloat AS AmountIn
           , CASE WHEN MovementItem.Amount < 0
                       THEN -1 * MovementItem.Amount
                  ELSE 0
             END                                  :: TFloat AS AmountOut

           , CASE WHEN MovementFloat_AmountCurrency.ValueData > 0
                  THEN MovementFloat_AmountCurrency.ValueData 
                  ELSE 0
             END                                  :: TFloat AS AmountCurrencyDebet
             
           , CASE WHEN MovementFloat_AmountCurrency.ValueData < 0
                  THEN -1 * MovementFloat_AmountCurrency.ValueData 
                  ELSE 0
             END                                  :: TFloat AS AmountCurrencyKredit
             
           , CASE WHEN MIFloat_Count.ValueData > 0 THEN MIFloat_Count.ValueData ELSE 0 END :: TFloat AS CountDebet
           , CASE WHEN MIFloat_Count.ValueData < 0 THEN -1* MIFloat_Count.ValueData ELSE 0 END :: TFloat AS CountKredit
           , MIFloat_Price.ValueData :: TFloat AS Price
           , (MIFloat_Price.ValueData * CASE WHEN MIFloat_Count.ValueData < 0 THEN -1 * MIFloat_Count.ValueData ELSE MIFloat_Count.ValueData END) :: TFloat AS Summa_calc

           , MovementFloat_CurrencyPartnerValue.ValueData   AS CurrencyPartnerValue
           , MovementFloat_ParPartnerValue.ValueData        AS ParPartnerValue
           , Object_CurrencyPartner.ValueData               AS CurrencyPartnerName
           
           , MIString_Comment.ValueData                     AS Comment

           , Object_Retail.Id                               AS RetailId
           , Object_Retail.ValueData                        AS RetailName
           , Object_Juridical.ObjectCode                    AS JuridicalCode
           , Object_Juridical.ValueData                     AS JuridicalName
           , ObjectDesc.ItemName                            AS ItemName
           , ObjectHistory_JuridicalDetails_View.OKPO
           , Object_InfoMoney_View.InfoMoneyGroupName
           , Object_InfoMoney_View.InfoMoneyDestinationName
           , Object_InfoMoney_View.InfoMoneyCode
           , Object_InfoMoney_View.InfoMoneyName
           , Object_InfoMoney_View.InfoMoneyName_all
           , View_Contract_InvNumber.ContractCode
           , View_Contract_InvNumber.InvNumber              AS ContractInvNumber
           , View_Contract_InvNumber.ContractTagName        AS ContractTagName
           , Object_Unit.ValueData                          AS UnitName
           , Object_PaidKind.ValueData                      AS PaidKindName
           , MovementString_MovementId.ValueData            AS CostMovementId
           , tmpCost.strInvNumber               :: TVarChar AS CostMovementInvNumber

           , Movement_Invoice.Id                            AS MovementId_Invoice
           , zfCalc_PartionMovementName (Movement_Invoice.DescId, MovementDesc_Invoice.ItemName, COALESCE (MovementString_InvNumberPartner_Invoice.ValueData,'') || '/' || Movement_Invoice.InvNumber, Movement_Invoice.OperDate) AS InvNumber_Invoice

           , Object_Asset.Id                                AS AssetId
           , Object_Asset.ObjectCode                        AS AssetCode
           , Object_Asset.ValueData                         AS AssetName

       FROM tmpStatus
            JOIN Movement ON Movement.DescId = zc_Movement_Service()
                         AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                         AND Movement.StatusId = tmpStatus.StatusId
            JOIN (SELECT DISTINCT Object_RoleAccessKey_View.AccessKeyId FROM Object_RoleAccessKey_View WHERE Object_RoleAccessKey_View.UserId = vbUserId) AS tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = Movement.AccessKeyId

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementString AS MovementString_MovementId
                                     ON MovementString_MovementId.MovementId = Movement.Id
                                    AND MovementString_MovementId.DescId = zc_MovementString_MovementId()

            LEFT JOIN MovementFloat AS MovementFloat_AmountCurrency
                                    ON MovementFloat_AmountCurrency.MovementId = Movement.Id
                                   AND MovementFloat_AmountCurrency.DescId = zc_MovementFloat_AmountCurrency()
                                   
            LEFT JOIN MovementLinkObject AS MovementLinkObject_CurrencyPartner
                                         ON MovementLinkObject_CurrencyPartner.MovementId = Movement.Id
                                        AND MovementLinkObject_CurrencyPartner.DescId = zc_MovementLinkObject_CurrencyPartner()
            LEFT JOIN Object AS Object_CurrencyPartner ON Object_CurrencyPartner.Id = MovementLinkObject_CurrencyPartner.ObjectId

            LEFT JOIN MovementFloat AS MovementFloat_CurrencyPartnerValue
                                    ON MovementFloat_CurrencyPartnerValue.MovementId = Movement.Id
                                   AND MovementFloat_CurrencyPartnerValue.DescId = zc_MovementFloat_CurrencyPartnerValue()
            LEFT JOIN MovementFloat AS MovementFloat_ParPartnerValue
                                    ON MovementFloat_ParPartnerValue.MovementId = Movement.Id
                                   AND MovementFloat_ParPartnerValue.DescId = zc_MovementFloat_ParPartnerValue()

            LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MovementItem.ObjectId
            LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Juridical.DescId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                             ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                            AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()

            INNER JOIN tmpInfoMoney_View AS Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = MILinkObject_InfoMoney.ObjectId
            
            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId = MovementItem.ObjectId
                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
            LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MovementItem.ObjectId)

            LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                 ON ObjectLink_Juridical_Retail.ObjectId = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MovementItem.ObjectId)
                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
            LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

            LEFT JOIN MovementItemString AS MIString_Comment 
                                         ON MIString_Comment.MovementItemId = MovementItem.Id
                                        AND MIString_Comment.DescId = zc_MIString_Comment()

            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementItemFloat AS MIFloat_Count
                                        ON MIFloat_Count.MovementItemId = MovementItem.Id
                                       AND MIFloat_Count.DescId = zc_MIFloat_Count()
            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()

            LEFT JOIN MovementLinkMovement AS MLM_Invoice
                                           ON MLM_Invoice.MovementId = Movement.Id
                                          AND MLM_Invoice.DescId = zc_MovementLinkMovement_Invoice()
            LEFT JOIN Movement AS Movement_Invoice ON Movement_Invoice.Id = MLM_Invoice.MovementChildId
            LEFT JOIN MovementDesc AS MovementDesc_Invoice ON MovementDesc_Invoice.Id = Movement_Invoice.DescId
            LEFT JOIN MovementString AS MovementString_InvNumberPartner_Invoice
                                     ON MovementString_InvNumberPartner_Invoice.MovementId =  Movement_Invoice.Id
                                    AND MovementString_InvNumberPartner_Invoice.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                         ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                        AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MILinkObject_Contract.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                             ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MILinkObject_Unit.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PaidKind
                                             ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PaidKind.DescId = zc_MILinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MILinkObject_PaidKind.ObjectId
 
            LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                             ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset() 
            LEFT JOIN Object AS Object_Asset ON Object_Asset.Id = MILinkObject_Asset.ObjectId

            LEFT JOIN tmpCost ON tmpCost.MovementServiceId = Movement.Id 
      ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 24.02.20         *
 28.01.19         * add inSettingsServiceId
 01.08.17         *
 06.10.16         * add inJuridicalBasisId
 27.08.16         * add MILinkObject_Asset
 21.07.16         *
 30.04.16         *
 17.03.14         * add zc_MovementDate_OperDatePartner, zc_MovementString_InvNumberPartner
 14.01.14         * del ContractConditionKind
 31.01.14                                        * add inIsErased
 28.01.14         * add ContractConditionKind
 14.01.14                                        * add Object_Contract_InvNumber_View
 28.12.13                                        * add Object_InfoMoney_View
 28.12.13                                        * add Object_RoleAccessKey_View
 27.12.13                         *
 11.08.13         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Service (inStartDate:= '30.01.2016', inEndDate:= '01.02.2016', inJuridicalBasisId:=0, inSettingsServiceId := 3175171, inIsWith:= FALSE, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())
--3175171

