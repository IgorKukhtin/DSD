-- Function: gpGet_Movement_Cash()

DROP FUNCTION IF EXISTS gpGet_Movement_Cash_Bonus (Integer, TDateTime, Integer, Integer, Integer, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Cash_Bonus(
    IN inMovementId        Integer   , -- ключ Документа
    IN inOperDate          TDateTime , -- 
    IN inCashId            Integer   , -- 
    IN inCurrencyId        Integer   , --
    IN inContractId        Integer   , --
    IN inInfoMoneyId       Integer   , --
    IN inMoneyPlaceId      Integer   , --
    IN inAmountOut         TFloat   , --
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , AmountIn TFloat 
             , AmountOut TFloat 
             , AmountSumm TFloat 
             , ServiceDate TDateTime
             , Comment TVarChar
             , CashId Integer, CashName TVarChar
             , MoneyPlaceId Integer, MoneyPlaceName TVarChar
             , InfoMoneyId Integer, InfoMoneyName TVarChar
             , MemberId Integer, MemberName TVarChar
             , PositionId Integer, PositionName TVarChar
             , ContractId Integer, ContractInvNumber TVarChar
             , UnitId Integer, UnitName TVarChar
             , CarId Integer, CarName TVarChar
             , CurrencyId Integer, CurrencyName TVarChar
             , CurrencyPartnerId Integer, CurrencyPartnerName TVarChar
             , CurrencyValue TFloat, ParValue TFloat
             , CurrencyPartnerValue TFloat, ParPartnerValue TFloat
             , MovementId_Partion Integer, PartionMovementName TVarChar
             , MovementId_Invoice Integer, InvNumber_Invoice TVarChar, Comment_Invoice TVarChar
             )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Cash());
     vbUserId := lpGetUserBySession (inSession);

     IF COALESCE (inMovementId, 0) = 0
     THEN

     RETURN QUERY 
        WITH -- ОДИН Курс валют из ГРН в inCurrencyId - документы только НАЛ zc_Movement_Currency 
             tmpCurrency2 AS (SELECT MovementItem.Amount AS Amount -- Курс
                                  , CASE WHEN MIFloat_ParValue.ValueData > 0
                                              THEN MIFloat_ParValue.ValueData
                                         ELSE 1
                                    END AS ParValue -- Номинал
                                  , MovementItem.ObjectId   
                                  , Movement.OperDate 
                             FROM Movement
                                  INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                         AND MovementItem.DescId     = zc_MI_Master()
                                                        -- AND MovementItem.ObjectId   = zc_Enum_Currency_Basis()
                                  INNER JOIN MovementItemLinkObject AS MILinkObject_PaidKind
                                                                    ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id
                                                                   AND MILinkObject_PaidKind.DescId         = zc_MILinkObject_PaidKind()
                                                                   AND MILinkObject_PaidKind.ObjectId       = zc_Enum_PaidKind_SecondForm() -- !!!здесь НАЛ!!!
                                  INNER JOIN MovementItemLinkObject AS MILinkObject_Currency
                                                                    ON MILinkObject_Currency.MovementItemId = MovementItem.Id
                                                                   AND MILinkObject_Currency.DescId         = zc_MILinkObject_Currency()
                                                                   AND MILinkObject_Currency.ObjectId       = inCurrencyId
                                  LEFT JOIN MovementItemFloat AS MIFloat_ParValue
                                                              ON MIFloat_ParValue.MovementItemId = MovementItem.Id
                                                             AND MIFloat_ParValue.DescId         = zc_MIFloat_ParValue()
                             WHERE Movement.DescId   = zc_Movement_Currency()
                               AND Movement.OperDate <= inOperDate
                               AND Movement.StatusId = zc_Enum_Status_Complete()
                               AND inCurrencyId <> zc_Enum_Currency_Basis()
                            )
           , tmpCurrency AS (SELECT -- Курс
                                    tmpCurrency2.Amount
                                  , tmpCurrency2.ParValue
                             FROM tmpCurrency2
                             WHERE tmpCurrency2.ObjectId = zc_Enum_Currency_Basis()
                             ORDER BY tmpCurrency2.OperDate DESC
                             LIMIT 1
                            )
         -- ОДИН Курс валют из ГРН в inCurrencyId - документы zc_Movement_Cash
      ,  tmpMovementCash2 AS (SELECT MovementFloat_CurrencyValue.ValueData       AS CurrencyValue
                                  , MovementFloat_ParValue.ValueData             AS ParValue
                                  , MovementFloat_CurrencyPartnerValue.ValueData AS CurrencyPartnerValue
                                  , MovementFloat_ParPartnerValue.ValueData      AS ParPartnerValue
                                  , Movement.OperDate
                                  , Movement.Id
                                  , MovementItem.ObjectId
                             FROM Movement
                                  INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                         AND MovementItem.DescId     = zc_MI_Master()
                                                      -- AND MovementItem.ObjectId   = inCashId
                                  INNER JOIN MovementItemLinkObject AS MILinkObject_Currency
                                                                    ON MILinkObject_Currency.MovementItemId = MovementItem.Id
                                                                   AND MILinkObject_Currency.DescId         = zc_MILinkObject_Currency()
                                                                   AND MILinkObject_Currency.ObjectId       = inCurrencyId
                
                                  LEFT JOIN MovementFloat AS MovementFloat_CurrencyValue
                                                          ON MovementFloat_CurrencyValue.MovementId = Movement.Id
                                                         AND MovementFloat_CurrencyValue.DescId     = zc_MovementFloat_CurrencyValue()
                                  LEFT JOIN MovementFloat AS MovementFloat_ParValue
                                                          ON MovementFloat_ParValue.MovementId = Movement.Id
                                                         AND MovementFloat_ParValue.DescId     = zc_MovementFloat_ParValue()
                                  LEFT JOIN MovementFloat AS MovementFloat_CurrencyPartnerValue
                                                          ON MovementFloat_CurrencyPartnerValue.MovementId = Movement.Id
                                                         AND MovementFloat_CurrencyPartnerValue.DescId     = zc_MovementFloat_CurrencyPartnerValue()
                                  LEFT JOIN MovementFloat AS MovementFloat_ParPartnerValue
                                                          ON MovementFloat_ParPartnerValue.MovementId = Movement.Id
                                                         AND MovementFloat_ParPartnerValue.DescId     = zc_MovementFloat_ParPartnerValue()
                             WHERE Movement.DescId   = zc_Movement_Cash()
                               AND Movement.OperDate BETWEEN inOperDate - INTERVAL '10 DAY' AND inOperDate
                               AND Movement.StatusId = zc_Enum_Status_Complete()
                               AND inCurrencyId <> zc_Enum_Currency_Basis()
                            )
      ,  tmpMovementCash AS (SELECT tmpMovementCash2.CurrencyValue
                                  , tmpMovementCash2.ParValue
                                  , tmpMovementCash2.CurrencyPartnerValue
                                  , tmpMovementCash2.ParPartnerValue
                             FROM tmpMovementCash2
                             WHERE tmpMovementCash2.ObjectId = inCashId
                             ORDER BY tmpMovementCash2.OperDate DESC, tmpMovementCash2.Id DESC
                             LIMIT 1
                            )
       SELECT
             0 AS Id
           , CAST (NEXTVAL ('Movement_Cash_seq') AS TVarChar)  AS InvNumber
--           , CAST (CURRENT_DATE AS TDateTime)                  AS OperDate
           , inOperDate                                        AS OperDate
           , lfObject_Status.Code                              AS StatusCode
           , lfObject_Status.Name                              AS StatusName
           
           , 0::TFloat                                         AS AmountIn
           , COALESCE (inAmountOut,0) ::TFloat                 AS AmountOut
           , 0::TFloat                                         AS AmountSumm

           , DATE_TRUNC ('MONTH', inOperDate - INTERVAL '1 MONTH') :: TDateTime AS ServiceDate
           , ''::TVarChar                                      AS Comment
           , COALESCE (Object_Cash.Id, 0)                      AS CashId
           , COALESCE (Object_Cash.ValueData, '') :: TVarChar  AS CashName
           , COALESCE (Object_MoneyPlace.Id,0)                    AS MoneyPlaceId
           , COALESCE (Object_MoneyPlace.ValueData,'')::TVarChar  AS MoneyPlaceName
           , COALESCE (Object_InfoMoney.Id,0)                     AS InfoMoneyId
           , COALESCE (Object_InfoMoney.ValueData,'') ::TVarChar  AS InfoMoneyName
           , 0                                                 AS MemberId
           , CAST ('' as TVarChar)                             AS MemberName
           , 0                                                 AS PositionId
           , CAST ('' as TVarChar)                             AS PositionName
           , COALESCE (Object_Contract.Id,0)                   AS ContractId
           , COALESCE (Object_Contract.ValueData,'')::TVarChar AS ContractInvNumber
           , 0                                                 AS UnitId
           , CAST ('' as TVarChar)                             AS UnitName

           , 0                                                 AS CarId
           , CAST ('' as TVarChar)                             AS CarName

           , Object_Currency.Id                                AS CurrencyId
           , Object_Currency.ValueData                         AS CurrencyName
           , 0                                                 AS CurrencyPartnerId
           , CAST ('' as TVarChar)                             AS CurrencyPartnerName
           , COALESCE (tmpMovementCash.CurrencyValue,        COALESCE (tmpCurrency.Amount,0))   :: TFloat AS CurrencyValue
           , COALESCE (tmpMovementCash.ParValue,             COALESCE (tmpCurrency.ParValue,0)) :: TFloat AS ParValue
           , COALESCE (tmpMovementCash.CurrencyPartnerValue, COALESCE (tmpCurrency.Amount,0))   :: TFloat AS CurrencyPartnerValue
           , COALESCE (tmpMovementCash.ParPartnerValue,      COALESCE (tmpCurrency.ParValue,0)) :: TFloat AS ParPartnerValue

           , 0                          AS MovementId_Partion
           , CAST ('' AS TVarChar)  	AS PartionMovementName

           , 0                                                 AS MovementId_Invoice
           , CAST ('' as TVarChar)                             AS InvNumber_Invoice
           , CAST ('' as TVarChar)                             AS Comment_Invoice

       FROM lfGet_Object_Status (zc_Enum_Status_UnComplete()) AS lfObject_Status
            LEFT JOIN Object AS Object_Cash ON Object_Cash.Id = inCashId -- IN (SELECT MIN (Object.Id) FROM Object WHERE Object.AccessKeyId IN (SELECT MIN (lpGetAccessKey) FROM lpGetAccessKey (vbUserId, zc_Enum_Process_Get_Movement_Cash())))
            LEFT JOIN ObjectLink AS ObjectLink_Cash_Currency
                   ON ObjectLink_Cash_Currency.ObjectId = Object_Cash.Id
                  AND ObjectLink_Cash_Currency.DescId = zc_ObjectLink_Cash_Currency()
            LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = CASE WHEN COALESCE (inCurrencyId,0) = 0 THEN ObjectLink_Cash_Currency.ChildObjectId ELSE inCurrencyId END
            LEFT JOIN tmpMovementCash ON 1=1
            LEFT JOIN tmpCurrency ON 1=1
            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = inContractId
            LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = inInfoMoneyId
            LEFT JOIN Object AS Object_MoneyPlace ON Object_MoneyPlace.Id = inMoneyPlaceId
      ;
     ELSE
          -- проверка
          IF EXISTS (SELECT Movement.Id FROM Movement WHERE Movement.Id = inMovementId AND Movement.ParentId >0)
          THEN
              RAISE EXCEPTION 'Ошибка.Документ может быть изменен только через <Касса, выплата по ведомости>.';
          END IF;
     
     RETURN QUERY 
       SELECT
             Movement.Id
           , Movement.InvNumber
           , Movement.OperDate
           , Object_Status.ObjectCode   AS StatusCode
           , Object_Status.ValueData    AS StatusName
                      
--           , CASE WHEN MovementItem.Amount > 0 THEN MovementItem.Amount ELSE 0 END::TFloat AS AmountIn
--           , CASE WHEN MovementItem.Amount < 0 THEN -1 * MovementItem.Amount ELSE 0 END::TFloat AS AmountOut
           , CASE WHEN MILinkObject_Currency.ObjectId <> zc_Enum_Currency_Basis() AND MovementFloat_AmountCurrency.ValueData > 0 THEN
                       MovementFloat_AmountCurrency.ValueData
                  WHEN MovementItem.Amount > 0 THEN
                       MovementItem.Amount
                  ELSE
                      0
                  END::TFloat AS AmountIn
           , CASE WHEN MILinkObject_Currency.ObjectId <> zc_Enum_Currency_Basis() AND MovementFloat_AmountCurrency.ValueData < 0 THEN
                       -1 * MovementFloat_AmountCurrency.ValueData
                  WHEN MovementItem.Amount < 0 THEN
                       -1 * MovementItem.Amount
                  ELSE
                      0
                  END::TFloat AS AmountOut
           
           , MovementFloat_Amount.ValueData    AS AmountSumm

           , COALESCE (MIDate_ServiceDate.ValueData, Movement.OperDate) AS ServiceDate
           , MIString_Comment.ValueData        AS Comment

           , Object_Cash.Id                    AS CashId
           , Object_Cash.ValueData             AS CashName
           , Object_MoneyPlace.Id              AS MoneyPlaceId
           , Object_MoneyPlace.ValueData       AS MoneyPlaceName
           , View_InfoMoney.InfoMoneyId
           , View_InfoMoney.InfoMoneyName_all   AS InfoMoneyName
           , Object_Member.Id                   AS MemberId
           , Object_Member.ValueData            AS MemberName
           , Object_Position.Id                 AS PositionId
           , Object_Position.ValueData          AS PositionName
           , View_Contract_InvNumber.ContractId AS ContractId
           , View_Contract_InvNumber.InvNumber  AS ContractInvNumber
           , Object_Unit.Id                     AS UnitId
           , Object_Unit.ValueData              AS UnitName

           , Object_Car.Id                      AS CarId
           , Object_Car.ValueData               AS CarName

           , Object_Currency.Id                 AS CurrencyId
           , Object_Currency.ValueData          AS CurrencyName
           , Object_CurrencyPartner.Id                    AS CurrencyPartnerId
           , Object_CurrencyPartner.ValueData             AS CurrencyPartnerName
           , MovementFloat_CurrencyValue.ValueData        AS CurrencyValue
           , MovementFloat_ParValue.ValueData             AS ParValue
           , MovementFloat_CurrencyPartnerValue.ValueData AS CurrencyPartnerValue
           , MovementFloat_ParPartnerValue.ValueData      AS ParPartnerValue
           
           , MIFloat_MovementId.ValueData :: Integer AS MovementId_Partion
           , zfCalc_PartionMovementName (Movement_PartionMovement.DescId, MovementDesc_PartionMovement.ItemName, Movement_PartionMovement.InvNumber, MovementDate_OperDatePartner_PartionMovement.ValueData) AS PartionMovementName

           , Movement_Invoice.Id                 AS MovementId_Invoice
           , zfCalc_PartionMovementName (Movement_Invoice.DescId, MovementDesc_Invoice.ItemName, COALESCE (MovementString_InvNumberPartner.ValueData,'') || '/' || Movement_Invoice.InvNumber, Movement_Invoice.OperDate) AS InvNumber_Invoice
           , MS_Comment_Invoice.ValueData        AS Comment_Invoice

       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementItem ON MovementItem.MovementId = inMovementId AND MovementItem.DescId = zc_MI_Master()

            LEFT JOIN MovementFloat AS MovementFloat_Amount
                                    ON MovementFloat_Amount.MovementId = Movement.Id
                                   AND MovementFloat_Amount.DescId = zc_MovementFloat_Amount()

            LEFT JOIN MovementFloat AS MovementFloat_CurrencyValue
                                    ON MovementFloat_CurrencyValue.MovementId = Movement.Id
                                   AND MovementFloat_CurrencyValue.DescId = zc_MovementFloat_CurrencyValue()
            LEFT JOIN MovementFloat AS MovementFloat_ParValue
                                    ON MovementFloat_ParValue.MovementId = Movement.Id
                                   AND MovementFloat_ParValue.DescId = zc_MovementFloat_ParValue()
            LEFT JOIN MovementFloat AS MovementFloat_CurrencyPartnerValue
                                    ON MovementFloat_CurrencyPartnerValue.MovementId = Movement.Id
                                   AND MovementFloat_CurrencyPartnerValue.DescId = zc_MovementFloat_CurrencyPartnerValue()
            LEFT JOIN MovementFloat AS MovementFloat_ParPartnerValue
                                    ON MovementFloat_ParPartnerValue.MovementId = Movement.Id
                                   AND MovementFloat_ParPartnerValue.DescId = zc_MovementFloat_ParPartnerValue()

            LEFT JOIN MovementLinkMovement AS MLM_Invoice
                                           ON MLM_Invoice.MovementId = Movement.Id
                                          AND MLM_Invoice.DescId = zc_MovementLinkMovement_Invoice()
            LEFT JOIN Movement AS Movement_Invoice ON Movement_Invoice.Id = MLM_Invoice.MovementChildId
            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId =  Movement_Invoice.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
            LEFT JOIN MovementDesc AS MovementDesc_Invoice ON MovementDesc_Invoice.Id = Movement_Invoice.DescId
            LEFT JOIN MovementString AS MS_Comment_Invoice
                                     ON MS_Comment_Invoice.MovementId = Movement_Invoice.Id
                                    AND MS_Comment_Invoice.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                        ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                       AND MIFloat_MovementId.DescId = zc_MIFloat_MovementId()
            LEFT JOIN Movement AS Movement_PartionMovement ON Movement_PartionMovement.Id = MIFloat_MovementId.ValueData :: Integer
            LEFT JOIN MovementDesc AS MovementDesc_PartionMovement ON MovementDesc_PartionMovement.Id = Movement_PartionMovement.DescId
            LEFT JOIN MovementDate AS MovementDate_OperDatePartner_PartionMovement
                                   ON MovementDate_OperDatePartner_PartionMovement.MovementId =  Movement_PartionMovement.Id
                                  AND MovementDate_OperDatePartner_PartionMovement.DescId = zc_MovementDate_OperDatePartner()

            LEFT JOIN Object AS Object_Cash ON Object_Cash.Id = MovementItem.ObjectId
 
            LEFT JOIN MovementItemDate AS MIDate_ServiceDate
                                       ON MIDate_ServiceDate.MovementItemId = MovementItem.Id
                                      AND MIDate_ServiceDate.DescId = zc_MIDate_ServiceDate()
            LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = MovementItem.Id
                                        AND MIString_Comment.DescId = zc_MIString_Comment()
            
            LEFT JOIN MovementItemLinkObject AS MILinkObject_MoneyPlace
                                             ON MILinkObject_MoneyPlace.MovementItemId = MovementItem.Id
                                            AND MILinkObject_MoneyPlace.DescId = zc_MILinkObject_MoneyPlace()
            LEFT JOIN Object AS Object_MoneyPlace ON Object_MoneyPlace.Id = MILinkObject_MoneyPlace.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                             ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                            AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = MILinkObject_InfoMoney.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Member
                                             ON MILinkObject_Member.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Member.DescId = zc_MILinkObject_Member()
            LEFT JOIN Object AS Object_Member ON Object_Member.Id = MILinkObject_Member.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Position
                                             ON MILinkObject_Position.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Position.DescId = zc_MILinkObject_Position()
            LEFT JOIN Object AS Object_Position ON Object_Position.Id = MILinkObject_Position.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                             ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MILinkObject_Contract.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                             ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MILinkObject_Unit.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Currency
                                             ON MILinkObject_Currency.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Currency.DescId = zc_MILinkObject_Currency()
            LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = MILinkObject_Currency.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_CurrencyPartner
                                             ON MILinkObject_CurrencyPartner.MovementItemId = MovementItem.Id
                                            AND MILinkObject_CurrencyPartner.DescId = zc_MILinkObject_CurrencyPartner()
            LEFT JOIN Object AS Object_CurrencyPartner ON Object_CurrencyPartner.Id = MILinkObject_CurrencyPartner.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Car
                                             ON MILinkObject_Car.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Car.DescId = zc_MILinkObject_Car()
            LEFT JOIN Object AS Object_Car ON Object_Car.Id = MILinkObject_Car.ObjectId

            LEFT JOIN MovementFloat AS MovementFloat_AmountCurrency
                                    ON MovementFloat_AmountCurrency.MovementId = Movement.Id
                                   AND MovementFloat_AmountCurrency.DescId = zc_MovementFloat_AmountCurrency()

       WHERE Movement.Id =  inMovementId;

   END IF;  
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.08.20         *
*/

-- тест
-- SELECT * FROM gpGet_Movement_Cash_Bonus (inMovementId:= 1, inOperDate:= '31.08.2017', inCashId:= 1, inCurrencyId:= 76965, inSession:= zfCalc_UserAdmin());
