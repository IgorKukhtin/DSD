-- Function: gpGet_Movement_Service()

DROP FUNCTION IF EXISTS gpGet_Movement_Service (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_Service (Integer, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_Service (Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Service(
    IN inMovementId        Integer   , -- ключ Документа
    IN inMovementId_Value  Integer   ,
    IN inOperDate          TDateTime , --
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , OperDatePartner TDateTime, InvNumberPartner TVarChar
             , AmountIn TFloat, AmountOut TFloat
             , AmountCurrencyDebet TFloat, AmountCurrencyKredit TFloat
             , CurrencyPartnerValue TFloat, ParPartnerValue TFloat
             , CountDebet TFloat, CountKredit TFloat, Price TFloat, Summa_calc TFloat
             , Comment TVarChar
             , JuridicalBasisId Integer, JuridicalBasisName TVarChar
             , JuridicalId Integer, JuridicalName TVarChar
             , PartnerId Integer, PartnerName TVarChar
             , InfoMoneyId Integer, InfoMoneyName TVarChar
             , ContractId Integer, ContractInvNumber TVarChar
             , ContractChildId Integer, ContractChildInvNumber TVarChar
             , UnitId Integer, UnitName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , CostMovementId TVarChar, CostMovementInvNumber TVarChar
             , MovementId_Invoice Integer, InvNumber_Invoice TVarChar
             , AssetId Integer, AssetName TVarChar
             , CurrencyPartnerId Integer, CurrencyPartnerName TVarChar
             , TradeMarkId Integer, TradeMarkName TVarChar
             , MovementId_doc Integer, InvNumber_doc TVarChar, InvNumber_full_doc TVarChar
             , InvNumberInvoice TVarChar
             )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Service());
     vbUserId := lpGetUserBySession (inSession);

     -- замена
     IF inMovementId_Value = 0 THEN inMovementId_Value:= inMovementId; END IF;

     IF COALESCE (inMovementId_Value, 0) = 0
     THEN

     RETURN QUERY
       SELECT
             0 AS Id
           , CAST (NEXTVAL ('Movement_Service_seq') AS TVarChar) AS InvNumber
--           , CAST (CURRENT_DATE AS TDateTime) AS OperDate
           , inOperDate AS OperDate
           , lfObject_Status.Code             AS StatusCode
           , lfObject_Status.Name             AS StatusName

           , CAST (CURRENT_DATE AS TDateTime) AS OperDatePartner
           , ''::TVarChar                     AS InvNumberPartner

           , 0::TFloat                        AS AmountIn
           , 0::TFloat                        AS AmountOut

           , 0::TFloat                        AS AmountCurrencyDebet
           , 0::TFloat                        AS AmountCurrencyKredit

           , CAST (0 AS TFloat)               AS CurrencyPartnerValue
           , CAST (0 AS TFloat)               AS ParPartnerValue

           , CAST (0 AS TFloat)               AS CountDebet
           , CAST (0 AS TFloat)               AS CountKredit
           , CAST (0 AS TFloat)               AS Price
           , CAST (0 AS TFloat)               AS Summa_calc

           , ''::TVarChar                     AS Comment

           , 0                                AS JuridicalBasisId
           , CAST ('' AS TVarChar)            AS JuridicalBasisName

           , 0                                AS JuridicalId
           , CAST ('' AS TVarChar)            AS JuridicalName
           , 0                                AS PartnerId
           , CAST ('' AS TVarChar)            AS PartnerName
           , 0                                AS InfoMoneyId
           , CAST ('' AS TVarChar)            AS InfoMoneyName
           , 0                                AS ContractId
           , ''::TVarChar                     AS ContractInvNumber
           , 0                                AS ContractChildId
           , ''::TVarChar                     AS ContractChildInvNumber
           , 0                                AS UnitId
           , CAST ('' AS TVarChar)            AS UnitName
           , 0                                AS PaidKindId
           , CAST ('' AS TVarChar)            AS PaidKindName
           , CAST ('' AS TVarChar)            AS CostMovementId
           , CAST ('' AS TVarChar)            AS CostMovementInvNumber

           , 0                                AS MovementId_Invoice
           , CAST ('' AS TVarChar)            AS InvNumber_Invoice

           , 0                                AS AssetId
           , CAST ('' AS TVarChar)            AS AssetName

           , Object_Currency.Id               AS CurrencyPartnerId
           , Object_Currency.ValueData        AS CurrencyPartnerName

           , 0                                AS TradeMarkId
           , CAST ('' as TVarChar)            AS TradeMarkName
           , 0                                AS MovementId_doc
           , CAST ('' as TVarChar)            AS InvNumber_doc
           , CAST ('' as TVarChar)            AS InvNumber_full_doc
             -- Счет(клиента)
           , CAST ('' AS TVarChar)            AS InvNumberInvoice

       FROM lfGet_Object_Status (zc_Enum_Status_UnComplete()) AS lfObject_Status
            LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = zc_Enum_Currency_Basis();

     ELSE

     RETURN QUERY
       WITH tmpCost AS (SELECT MovementFloat.ValueData AS MovementServiceId
                             , STRING_AGG ('№ ' ||CAST(Movement_Income.InvNumber AS TVarChar) || ' oт '|| TO_CHAR(Movement_Income.Operdate , 'DD.MM.YYYY')|| '.' , ', ')  AS strInvNumber
                        FROM MovementFloat
                             LEFT JOIN Movement AS Movement_Cost on Movement_Cost.Id = MovementFloat.Movementid
                                               AND Movement_Cost.StatusId            <> zc_Enum_Status_Erased()
                             LEFT JOIN Movement AS Movement_Income on Movement_Income.Id = Movement_Cost.ParentId
                        WHERE MovementFloat.DescId    = zc_MovementFloat_MovementId()
                          AND MovementFloat.ValueData = inMovementId_Value
                        GROUP BY MovementFloat.ValueData
                       )


     , tmpMovementFloat AS (SELECT MovementFloat.*
                            FROM MovementFloat
                            WHERE MovementFloat.MovementId = inMovementId_Value
                            )

     , tmpMovementString AS (SELECT MovementString.*
                             FROM MovementString
                             WHERE MovementString.MovementId = inMovementId_Value
                            )

     , tmpMovementDate AS (SELECT MovementDate.*
                           FROM MovementDate
                           WHERE MovementDate.MovementId = inMovementId_Value
                          )

     , tmpMovementLinkObject AS (SELECT MovementLinkObject.*
                                 FROM MovementLinkObject
                                 WHERE MovementLinkObject.MovementId = inMovementId_Value
                                   AND MovementLinkObject.DescId IN (zc_MovementLinkObject_CurrencyPartner()
                                                                   , zc_MovementLinkObject_TradeMark()
                                                                    )
                               )

     , tmpMovementLinkMovement AS (SELECT MovementLinkMovement.*
                                   FROM MovementLinkMovement
                                   WHERE MovementLinkMovement.MovementId = inMovementId_Value
                                     AND MovementLinkMovement.DescId IN (zc_MovementLinkMovement_Invoice()
                                                                       , zc_MovementLinkMovement_Doc()
                                                                        )
                                 )

     , tmpMI AS (SELECT MovementItem.*
                 FROM MovementItem 
                 WHERE MovementItem.MovementId = inMovementId_Value 
                   AND MovementItem.DescId = zc_MI_Master()
                 )

     , tmpMIString AS (SELECT MovementItemString.*
                       FROM MovementItemString
                       WHERE MovementItemString.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                         AND MovementItemString.DescId IN (zc_MIString_Comment())
                      )
     , tmpMIFloat AS (SELECT MovementItemFloat.*
                      FROM MovementItemFloat
                      WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                        AND MovementItemFloat.DescId IN (zc_MIFloat_Count(), zc_MIFloat_Price())
                     )

     , tmpMILO AS (SELECT MovementItemLinkObject.*
                   FROM MovementItemLinkObject
                   WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                     AND MovementItemLinkObject.DescId IN (zc_MILinkObject_InfoMoney()
                                                         , zc_MILinkObject_Contract()
                                                         , zc_MILinkObject_Unit()
                                                         , zc_MILinkObject_PaidKind()
                                                         , zc_MILinkObject_Asset()
                                                         , zc_MILinkObject_JuridicalBasis()
                                                         , zc_MILinkObject_ContractChild()
                                                         )
                  )


       SELECT
             inMovementId                        AS Id
           , CASE WHEN inMovementId = 0 THEN CAST (NEXTVAL ('Movement_Service_seq') AS TVarChar) ELSE Movement.InvNumber END AS InvNumber
           , CASE WHEN inMovementId = 0 THEN inOperDate ELSE Movement.OperDate END                                           AS OperDate
           , Object_Status.ObjectCode            AS StatusCode
           , Object_Status.ValueData             AS StatusName

           , COALESCE (MovementDate_OperDatePartner.ValueData, zc_DateStart()) AS OperDatePartner
           , MovementString_InvNumberPartner.ValueData                         AS InvNumberPartner

           , CASE WHEN inMovementId = 0
                       THEN 0
                  WHEN MovementItem.Amount > 0 AND COALESCE (MIFloat_Count.ValueData, 0) = 0
                       THEN MovementItem.Amount
                  ELSE 0
             END                       :: TFloat AS AmountIn
           , CASE WHEN inMovementId = 0
                       THEN 0
                  WHEN MovementItem.Amount < 0 AND COALESCE (MIFloat_Count.ValueData, 0) = 0
                       THEN -1 * MovementItem.Amount
                  ELSE 0
             END                       :: TFloat AS AmountOut

           , CASE WHEN MovementFloat_AmountCurrency.ValueData > 0
                  THEN MovementFloat_AmountCurrency.ValueData
                  ELSE 0
             END                                  :: TFloat AS AmountCurrencyDebet

           , CASE WHEN MovementFloat_AmountCurrency.ValueData < 0
                  THEN -1 * MovementFloat_AmountCurrency.ValueData
                  ELSE 0
             END                                  :: TFloat AS AmountCurrencyKredit

           , MovementFloat_CurrencyPartnerValue.ValueData   AS CurrencyPartnerValue
           , MovementFloat_ParPartnerValue.ValueData        AS ParPartnerValue

           , CASE WHEN MIFloat_Count.ValueData > 0 THEN MIFloat_Count.ValueData ELSE 0 END :: TFloat AS CountDebet
           , CASE WHEN MIFloat_Count.ValueData < 0 THEN -1 * MIFloat_Count.ValueData ELSE 0 END :: TFloat AS CountKredit
           , MIFloat_Price.ValueData :: TFloat AS Price
           , (MIFloat_Price.ValueData * CASE WHEN MIFloat_Count.ValueData < 0 THEN -1 * MIFloat_Count.ValueData ELSE MIFloat_Count.ValueData END) :: TFloat AS Summa_calc

           , MIString_Comment.ValueData          AS Comment

           , Object_JuridicalBasis.Id            AS JuridicalBasisId
           , Object_JuridicalBasis.ValueData     AS JuridicalBasisName

           , Object_Juridical.Id                 AS JuridicalId
           , Object_Juridical.ValueData          AS JuridicalName

           , Object_Partner.Id                   AS PartnerId
           , Object_Partner.ValueData            AS PartnerName

           , View_InfoMoney.InfoMoneyId
           , View_InfoMoney.InfoMoneyName_all    AS InfoMoneyName
           , View_Contract_InvNumber.ContractId  AS ContractId
           , View_Contract_InvNumber.InvNumber   AS ContractInvNumber
           , Object_ContractChild.Id             AS ContractChildId
           , Object_ContractChild.ValueData      AS ContractChildInvNumber
           , Object_Unit.Id                      AS UnitId
           , Object_Unit.ValueData               AS UnitName
           , Object_PaidKind.Id                  AS PaidKindId
           , Object_PaidKind.ValueData           AS PaidKindName

           , MovementString_MovementId.ValueData AS CostMovementId
           , tmpCost.strInvNumber    ::TVarChar  AS CostMovementInvNumber

           , Movement_Invoice.Id                 AS MovementId_Invoice
           , zfCalc_PartionMovementName (Movement_Invoice.DescId, MovementDesc_Invoice.ItemName, COALESCE(MovementString_InvNumberPartner_Invoice.ValueData,'') || '/' || Movement_Invoice.InvNumber, Movement_Invoice.OperDate) AS InvNumber_Invoice

           , Object_Asset.Id                     AS AssetId
           , Object_Asset.ValueData              AS AssetName

           , Object_CurrencyPartner.Id           AS CurrencyPartnerId
           , Object_CurrencyPartner.ValueData    AS CurrencyPartnerName

           , Object_TradeMark.Id                 AS TradeMarkId
           , Object_TradeMark.ValueData          AS TradeMarkName
           , Movement_Doc.Id                     AS MovementId_doc
           , Movement_Doc.InvNumber              AS InvNumber_doc
           , zfCalc_PartionMovementName (Movement_Doc.DescId, MovementDesc_Doc.ItemName, Movement_Doc.InvNumber, Movement_Doc.OperDate) :: TVarChar AS InvNumber_full_doc
             -- Счет(клиента)
           , MovementString_InvNumberInvoice.ValueData ::TVarChar AS InvNumberInvoice

       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = CASE WHEN inMovementId = 0 THEN zc_Enum_Status_UnComplete() ELSE Movement.StatusId END

            LEFT JOIN tmpMovementDate AS MovementDate_OperDatePartner
                                      ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                     AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

            LEFT JOIN tmpMovementFloat AS MovementFloat_AmountCurrency
                                    ON MovementFloat_AmountCurrency.MovementId = Movement.Id
                                   AND MovementFloat_AmountCurrency.DescId = zc_MovementFloat_AmountCurrency()

            LEFT JOIN tmpMovementFloat AS MovementFloat_CurrencyPartnerValue
                                    ON MovementFloat_CurrencyPartnerValue.MovementId = Movement.Id
                                   AND MovementFloat_CurrencyPartnerValue.DescId = zc_MovementFloat_CurrencyPartnerValue()
            LEFT JOIN tmpMovementFloat AS MovementFloat_ParPartnerValue
                                    ON MovementFloat_ParPartnerValue.MovementId = Movement.Id
                                   AND MovementFloat_ParPartnerValue.DescId = zc_MovementFloat_ParPartnerValue()

            LEFT JOIN tmpMovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId = Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN tmpMovementString AS MovementString_MovementId
                                     ON MovementString_MovementId.MovementId = Movement.Id
                                    AND MovementString_MovementId.DescId = zc_MovementString_MovementId()

             -- Счет(клиента)
            LEFT JOIN tmpMovementString AS MovementString_InvNumberInvoice
                                     ON MovementString_InvNumberInvoice.MovementId = Movement.Id
                                    AND MovementString_InvNumberInvoice.DescId = zc_MovementString_InvNumberInvoice()

            LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_CurrencyPartner
                                         ON MovementLinkObject_CurrencyPartner.MovementId = Movement.Id
                                        AND MovementLinkObject_CurrencyPartner.DescId = zc_MovementLinkObject_CurrencyPartner()
            LEFT JOIN Object AS Object_CurrencyPartner ON Object_CurrencyPartner.Id = MovementLinkObject_CurrencyPartner.ObjectId

            LEFT JOIN tmpMovementLinkMovement AS MLM_Invoice
                                           ON MLM_Invoice.MovementId = Movement.Id
                                          AND MLM_Invoice.DescId = zc_MovementLinkMovement_Invoice()
            LEFT JOIN Movement AS Movement_Invoice ON Movement_Invoice.Id = MLM_Invoice.MovementChildId
            LEFT JOIN MovementDesc AS MovementDesc_Invoice ON MovementDesc_Invoice.Id = Movement_Invoice.DescId
            LEFT JOIN MovementString AS MovementString_InvNumberPartner_Invoice
                                     ON MovementString_InvNumberPartner_Invoice.MovementId =  Movement_Invoice.Id
                                    AND MovementString_InvNumberPartner_Invoice.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_TradeMark
                                         ON MovementLinkObject_TradeMark.MovementId = Movement.Id
                                        AND MovementLinkObject_TradeMark.DescId = zc_MovementLinkObject_TradeMark()
            LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = MovementLinkObject_TradeMark.ObjectId

            LEFT JOIN tmpMovementLinkMovement AS MLM_Doc
                                           ON MLM_Doc.MovementId = Movement.Id
                                          AND MLM_Doc.DescId = zc_MovementLinkMovement_Doc()
            LEFT JOIN Movement AS Movement_Doc ON Movement_Doc.Id = MLM_Doc.MovementChildId
            LEFT JOIN MovementDesc AS MovementDesc_Doc ON MovementDesc_Doc.Id = Movement_Doc.DescId

           --
            LEFT JOIN tmpMI AS MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()

            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId = MovementItem.ObjectId
                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = ObjectLink_Partner_Juridical.ObjectId
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MovementItem.ObjectId)

            LEFT JOIN tmpMIString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = MovementItem.Id
                                        AND MIString_Comment.DescId = zc_MIString_Comment()

            LEFT JOIN tmpMIFloat AS MIFloat_Count
                                 ON MIFloat_Count.MovementItemId = MovementItem.Id
                                AND MIFloat_Count.DescId = zc_MIFloat_Count()
            LEFT JOIN tmpMIFloat AS MIFloat_Price
                                 ON MIFloat_Price.MovementItemId = MovementItem.Id
                                AND MIFloat_Price.DescId = zc_MIFloat_Price()

            LEFT JOIN tmpMILO AS MILinkObject_InfoMoney
                                             ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                            AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = MILinkObject_InfoMoney.ObjectId

            LEFT JOIN tmpMILO AS MILinkObject_Contract
                                             ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
            --LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MILinkObject_Contract.ObjectId
            LEFT JOIN Object_Contract_View AS View_Contract_InvNumber                                                       --Object_Contract_InvNumber_View
                                           ON View_Contract_InvNumber.ContractId = MILinkObject_Contract.ObjectId

            LEFT JOIN tmpMILO AS MILinkObject_Unit
                                             ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MILinkObject_Unit.ObjectId

            LEFT JOIN tmpMILO AS MILinkObject_PaidKind
                                             ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PaidKind.DescId = zc_MILinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MILinkObject_PaidKind.ObjectId

            LEFT JOIN tmpMILO AS MILinkObject_Asset
                                             ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()
            LEFT JOIN Object AS Object_Asset ON Object_Asset.Id = MILinkObject_Asset.ObjectId

            LEFT JOIN tmpMILO AS MILinkObject_JuridicalBasis
                                             ON MILinkObject_JuridicalBasis.MovementItemId = MovementItem.Id
                                            AND MILinkObject_JuridicalBasis.DescId = zc_MILinkObject_JuridicalBasis()
            LEFT JOIN Object AS Object_JuridicalBasis ON Object_JuridicalBasis.Id = CASE WHEN MILinkObject_JuridicalBasis.ObjectId > 0
                                                                                         THEN MILinkObject_JuridicalBasis.ObjectId
                                                                                         ELSE COALESCE (View_Contract_InvNumber.JuridicalBasisId, zc_Juridical_Basis())
                                                                                    END

            LEFT JOIN tmpCost ON tmpCost.MovementServiceId = Movement.Id

            LEFT JOIN tmpMILO AS MILinkObject_ContractChild
                                             ON MILinkObject_ContractChild.MovementItemId = MovementItem.Id
                                            AND MILinkObject_ContractChild.DescId = zc_MILinkObject_ContractChild()
            LEFT JOIN Object AS Object_ContractChild ON Object_ContractChild.Id = MILinkObject_ContractChild.ObjectId

       WHERE Movement.Id = inMovementId_Value;

   END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_Movement_Service (Integer, Integer, TDateTime, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.08.24         *
 24.02.20         *
 01.08.17         *
 21.07.16         *
 30.04.16         *
 17.03.14         * add zc_MovementDate_OperDatePartner, zc_MovementString_InvNumberPartner
 19.02.14         * del ContractConditionKind )))
 28.01.14         * add ContractConditionKind
 22.01.14                                        * add inOperDate
 28.12.13                                        * add View_InfoMoney
 24.12.13                         * -- MovItem
 18.11.13                         * -- Add other properties
 07.11.13                         * -- Default on Get
 11.08.13         *

*/

-- тест
-- SELECT * FROM gpGet_Movement_Service (inMovementId:= 1, inMovementId_Value:= 0, inOperDate:= CURRENT_DATE,  inSession:= zfCalc_UserAdmin());
