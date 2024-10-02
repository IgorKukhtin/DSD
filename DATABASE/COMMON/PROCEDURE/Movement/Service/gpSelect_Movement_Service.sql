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
             , JuridicalBasisId Integer, JuridicalBasisCode Integer, JuridicalBasisName TVarChar
             , JuridicalCode Integer, JuridicalName TVarChar, ItemName TVarChar, OKPO TVarChar
             , InfoMoneyGroupName TVarChar
             , InfoMoneyDestinationName TVarChar
             , InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , ContractCode Integer, ContractInvNumber TVarChar, ContractTagName TVarChar
             , ContractChildId Integer, ContractChildCode Integer, ContractChildInvNumber TVarChar
             , UnitName TVarChar
             , PaidKindName TVarChar
             , CostMovementId TVarChar, CostMovementInvNumber TVarChar
             , MovementId_Invoice Integer, InvNumber_Invoice TVarChar
             , AssetId Integer, AssetCode Integer, AssetName TVarChar
             , ProfitLossGroupName     TVarChar
             , ProfitLossDirectionName TVarChar
             , ProfitLossName          TVarChar
             , ProfitLossName_all      TVarChar
             , TradeMarkId Integer, TradeMarkName TVarChar
             , MovementId_doc Integer, InvNumber_doc TVarChar, InvNumber_full_doc TVarChar, DescName_doc TVarChar
             , InvNumberInvoice TVarChar
             )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInfoMoneyDestination_21500 Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Service());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

     -- Разрешен просмотр долги Маркетинг - НАЛ
     vbIsInfoMoneyDestination_21500:= EXISTS (SELECT 1 FROM ObjectLink_UserRole_View AS tmp WHERE tmp.UserId = vbUserId AND tmp.RoleId = 8852398);


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
             -- НЕ Разрешен просмотр долги Маркетинг - НАЛ
           , tmpInfoMoney_not AS (SELECT Object_InfoMoney_View.*
                                  FROM Object_InfoMoney_View
                                  WHERE Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_21500() -- Маркетинг
                                    AND vbIsInfoMoneyDestination_21500 = FALSE
                                 )

           , tmpInfoMoney_View AS (SELECT Object_InfoMoney_View.*
                                   FROM Object_InfoMoney_View
                                        LEFT JOIN tmpInfoMoneyDestination ON tmpInfoMoneyDestination.InfoMoneyDestinationId = Object_InfoMoney_View.InfoMoneyDestinationId
                                   WHERE (COALESCE (tmpInfoMoneyDestination.InfoMoneyDestinationId,0) <> 0 AND inSettingsServiceId > 0)
                                      OR (COALESCE (tmpInfoMoneyDestination.InfoMoneyDestinationId,0) = 0 AND inSettingsServiceId < 0)
                                      OR inSettingsServiceId = 0
                                   )
           , tmpMovement AS (SELECT Movement.*
                             FROM tmpStatus
                                  JOIN Movement ON Movement.DescId = zc_Movement_Service()
                                               AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                                               AND Movement.StatusId = tmpStatus.StatusId
                                  JOIN (SELECT DISTINCT Object_RoleAccessKey_View.AccessKeyId FROM Object_RoleAccessKey_View WHERE Object_RoleAccessKey_View.UserId = vbUserId) AS tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = Movement.AccessKeyId

                             )

         --ProfitLoss определяем через проводки
         , tmpMIС_ProfitLoss AS (SELECT DISTINCT MovementItemContainer.MovementId
                                      , CLO_ProfitLoss.ObjectId AS ProfitLossId
                                 FROM MovementItemContainer
                                      INNER JOIN ContainerLinkObject AS CLO_ProfitLoss
                                                                     ON CLO_ProfitLoss.ContainerId = MovementItemContainer.ContainerId
                                                                    AND CLO_ProfitLoss.DescId      = zc_ContainerLinkObject_ProfitLoss()
                                 WHERE MovementItemContainer.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                   AND MovementItemContainer.DescId     = zc_MIContainer_Summ()
                                   AND MovementItemContainer.AccountId  = zc_Enum_Account_100301()   -- прибыль текущего периода
                                   -- !!! временно, т.к. долго!!!
                                   AND 1=0
                                )
         , tmpProfitLoss_View AS (SELECT * FROM Object_ProfitLoss_View WHERE Object_ProfitLoss_View.ProfitLossId IN (SELECT tmpMIС_ProfitLoss.ProfitLossId FROM tmpMIС_ProfitLoss))


         , tmpMovementString AS (SELECT *
                                 FROM MovementString
                                 WHERE MovementString.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                   AND MovementString.DescId IN (zc_MovementString_InvNumberInvoice() 
                                                               , zc_MovementString_MovementId()
                                                               , zc_MovementString_InvNumberPartner()
                                                              )
                                )
         , tmpMovementFloat AS (SELECT *
                                FROM MovementFloat
                                WHERE MovementFloat.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                  AND MovementFloat.DescId IN (zc_MovementFloat_AmountCurrency()
                                                             , zc_MovementFloat_CurrencyPartnerValue()
                                                             , zc_MovementFloat_ParPartnerValue()
                                                             )
                               )
         , tmpMI AS (SELECT MovementItem.*
                     FROM MovementItem
                     WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                       AND MovementItem.DescId = zc_MI_Master()
                     )
         , tmpMIFloat AS (SELECT *
                          FROM MovementItemFloat
                          WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                            AND MovementItemFloat.DescId IN (zc_MIFloat_Count()
                                                           , zc_MIFloat_Price()
                                                           )
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

           , Object_JuridicalBasis.Id                       AS JuridicalBasisId
           , Object_JuridicalBasis.ObjectCode               AS JuridicalBasisCode
           , Object_JuridicalBasis.ValueData                AS JuridicalBasisName

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
           , Object_ContractChild.Id                        AS ContractChildId
           , Object_ContractChild.ObjectCode                AS ContractChildCode
           , Object_ContractChild.ValueData                 AS ContractChildInvNumber
           
           , Object_Unit.ValueData                          AS UnitName
           , Object_PaidKind.ValueData                      AS PaidKindName
           , MovementString_MovementId.ValueData            AS CostMovementId
           , tmpCost.strInvNumber               :: TVarChar AS CostMovementInvNumber

           , Movement_Invoice.Id                            AS MovementId_Invoice
           , zfCalc_PartionMovementName (Movement_Invoice.DescId, MovementDesc_Invoice.ItemName, COALESCE (MovementString_InvNumberPartner_Invoice.ValueData,'') || '/' || Movement_Invoice.InvNumber, Movement_Invoice.OperDate) AS InvNumber_Invoice

           , Object_Asset.Id                                AS AssetId
           , Object_Asset.ObjectCode                        AS AssetCode
           , Object_Asset.ValueData                         AS AssetName

           , tmpProfitLoss_View.ProfitLossGroupName     ::TVarChar
           , tmpProfitLoss_View.ProfitLossDirectionName ::TVarChar
           , tmpProfitLoss_View.ProfitLossName          ::TVarChar
           , tmpProfitLoss_View.ProfitLossName_all      ::TVarChar  
           
           , Object_TradeMark.Id                    AS TradeMarkId
           , Object_TradeMark.ValueData             AS TradeMarkName
           , COALESCE (Movement_Doc.Id, -1) ::Integer  AS MovementId_doc
           , Movement_Doc.InvNumber                 AS InvNumber_doc
           , zfCalc_PartionMovementName (Movement_Doc.DescId, MovementDesc_Doc.ItemName, Movement_Doc.InvNumber, Movement_Doc.OperDate) :: TVarChar AS InvNumber_full_doc
           , MovementDesc_Doc.ItemName              AS DescName_doc
           , MovementString_InvNumberInvoice.ValueData ::TVarChar AS InvNumberInvoice
       FROM tmpMovement AS Movement

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN tmpMovementString AS MovementString_MovementId
                                        ON MovementString_MovementId.MovementId = Movement.Id
                                       AND MovementString_MovementId.DescId = zc_MovementString_MovementId()

            LEFT JOIN tmpMovementFloat AS MovementFloat_AmountCurrency
                                    ON MovementFloat_AmountCurrency.MovementId = Movement.Id
                                   AND MovementFloat_AmountCurrency.DescId = zc_MovementFloat_AmountCurrency()
                                   
            LEFT JOIN MovementLinkObject AS MovementLinkObject_CurrencyPartner
                                         ON MovementLinkObject_CurrencyPartner.MovementId = Movement.Id
                                        AND MovementLinkObject_CurrencyPartner.DescId = zc_MovementLinkObject_CurrencyPartner()
            LEFT JOIN Object AS Object_CurrencyPartner ON Object_CurrencyPartner.Id = MovementLinkObject_CurrencyPartner.ObjectId

            LEFT JOIN tmpMovementFloat AS MovementFloat_CurrencyPartnerValue
                                       ON MovementFloat_CurrencyPartnerValue.MovementId = Movement.Id
                                      AND MovementFloat_CurrencyPartnerValue.DescId = zc_MovementFloat_CurrencyPartnerValue()
            LEFT JOIN tmpMovementFloat AS MovementFloat_ParPartnerValue
                                       ON MovementFloat_ParPartnerValue.MovementId = Movement.Id
                                      AND MovementFloat_ParPartnerValue.DescId = zc_MovementFloat_ParPartnerValue()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_TradeMark
                                         ON MovementLinkObject_TradeMark.MovementId = Movement.Id
                                        AND MovementLinkObject_TradeMark.DescId = zc_MovementLinkObject_TradeMark()
            LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = MovementLinkObject_TradeMark.ObjectId

            LEFT JOIN MovementLinkMovement AS MLM_Doc
                                           ON MLM_Doc.MovementId = Movement.Id
                                          AND MLM_Doc.DescId = zc_MovementLinkMovement_Doc()
            LEFT JOIN Movement AS Movement_Doc ON Movement_Doc.Id = MLM_Doc.MovementChildId
            LEFT JOIN MovementDesc AS MovementDesc_Doc ON MovementDesc_Doc.Id = Movement_Doc.DescId

            --ProfitLoss
            LEFT JOIN tmpMIС_ProfitLoss ON tmpMIС_ProfitLoss.MovementId = Movement.Id
            LEFT JOIN tmpProfitLoss_View ON tmpProfitLoss_View.ProfitLossId = tmpMIС_ProfitLoss.ProfitLossId

            LEFT JOIN tmpMI AS MovementItem ON MovementItem.MovementId = Movement.Id
                                 -- AND MovementItem.DescId = zc_MI_Master()
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MovementItem.ObjectId
            LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Juridical.DescId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                             ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                            AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()

            INNER JOIN tmpInfoMoney_View AS Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = MILinkObject_InfoMoney.ObjectId
            
            LEFT JOIN tmpInfoMoney_not ON tmpInfoMoney_not.InfoMoneyId = MILinkObject_InfoMoney.ObjectId
            
            
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

            LEFT JOIN tmpMovementString AS MovementString_InvNumberPartner
                                        ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                       AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN tmpMovementString AS MovementString_InvNumberInvoice
                                        ON MovementString_InvNumberInvoice.MovementId = Movement.Id
                                       AND MovementString_InvNumberInvoice.DescId = zc_MovementString_InvNumberInvoice()

            LEFT JOIN tmpMIFloat AS MIFloat_Count
                                 ON MIFloat_Count.MovementItemId = MovementItem.Id
                                AND MIFloat_Count.DescId = zc_MIFloat_Count()
            LEFT JOIN tmpMIFloat AS MIFloat_Price
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
            LEFT JOIN Object_Contract_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MILinkObject_Contract.ObjectId  --Object_Contract_InvNumber_View

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

            LEFT JOIN MovementItemLinkObject AS MILinkObject_JuridicalBasis
                                             ON MILinkObject_JuridicalBasis.MovementItemId = MovementItem.Id
                                            AND MILinkObject_JuridicalBasis.DescId = zc_MILinkObject_JuridicalBasis()            
            LEFT JOIN Object AS Object_JuridicalBasis ON Object_JuridicalBasis.Id = CASE WHEN MILinkObject_JuridicalBasis.ObjectId > 0
                                                                                         THEN MILinkObject_JuridicalBasis.ObjectId
                                                                                         ELSE COALESCE (View_Contract_InvNumber.JuridicalBasisId, zc_Juridical_Basis()) 
                                                                                    END

            LEFT JOIN MovementItemLinkObject AS MILinkObject_ContractChild
                                             ON MILinkObject_ContractChild.MovementItemId = MovementItem.Id
                                            AND MILinkObject_ContractChild.DescId = zc_MILinkObject_ContractChild()
            LEFT JOIN Object AS Object_ContractChild ON Object_ContractChild.Id = MILinkObject_ContractChild.ObjectId

            LEFT JOIN tmpCost ON tmpCost.MovementServiceId = Movement.Id 

       -- НЕ Разрешен просмотр долги Маркетинг - НАЛ
       WHERE tmpInfoMoney_not.InfoMoneyId IS NULL OR COALESCE (MILinkObject_PaidKind.ObjectId, 0) <> zc_Enum_PaidKind_SecondForm()
      ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 08.08.24         *
 20.10.22         * JuridicalBasis
 04.10.21         * ProfitLoss...
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
-- SELECT * FROM gpSelect_Movement_Service (inStartDate:= '01.09.2021'::TDateTime, inEndDate:= '03.09.2021'::TDateTime, inJuridicalBasisId:=0, inSettingsServiceId := 3175171, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())

--3175171