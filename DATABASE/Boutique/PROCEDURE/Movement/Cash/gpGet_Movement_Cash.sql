-- Function: gpGet_Movement_Cash (Integer, TDateTime, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Movement_Cash (Integer, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_Cash (Integer, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Cash(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime, -- ключ Документа
    IN inCashId            Integer  ,
    IN inCurrencyId        Integer  ,
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , CurrencyValue TFloat, ParValue TFloat
             , CurrencyPartnerValue TFloat, ParPartnerValue TFloat
             , AmountOut TFloat, AmountIn  TFloat
             , CashId Integer, CashName TVarChar
             , MoneyPlaceId Integer, MoneyPlaceName TVarChar
             , InfoMoneyId Integer, InfoMoneyName TVarChar
             , UnitId Integer, UnitName TVarChar
             , CurrencyId Integer, CurrencyName TVarChar
             , Comment TVarChar
               )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCurrencyValue TFloat;
   DECLARE vbParValue TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Cash());
     vbUserId:= lpGetUserBySession (inSession);

     -- Если НЕ Базовая Валюта
     IF inCurrencyId <> zc_Currency_Basis()
     THEN
         -- Определили курс на Дату документа
         SELECT COALESCE (tmp.Amount, 1), COALESCE (tmp.ParValue,0)
                INTO vbCurrencyValue, vbParValue
         FROM lfSelect_Movement_Currency_byDate (inOperDate      := inOperDate
                                               , inCurrencyFromId:= zc_Currency_Basis()
                                               , inCurrencyToId  := inCurrencyId
                                                ) AS tmp;
     ELSE
         -- курс не нужен
         vbCurrencyValue:= 0;
         vbParValue     := 0;

     END IF;

     IF COALESCE (inMovementId, 0) = 0
     THEN
         RETURN QUERY
         SELECT
               0 AS Id
             , CAST (lfGet_InvNumber (0, zc_Movement_Cash()) AS TVarChar) AS InvNumber
             , CURRENT_DATE  :: TDateTime AS OperDate
             , lfGet.Code            AS StatusCode
             , lfGet.Name            AS StatusName

             , vbCurrencyValue       AS CurrencyValue
             , vbParValue            AS ParValue
             , CAST (0 AS TFloat)    AS CurrencyPartnerValue
             , CAST (1 AS TFloat)    AS ParPartnerValue

             , CAST (0 AS TFloat)    AS AmountOut
             , CAST (0 AS TFloat)    AS AmountIn

             , Object_Cash.Id        AS CashId
             , Object_Cash.ValueData AS CashName
             , 0                     AS MoneyPlaceId
             , CAST ('' AS TVarChar) AS MoneyPlaceName
             , 0                     AS InfoMoneyId
             , CAST ('' AS TVarChar) AS InfoMoneyName
             , Object_Unit.Id        AS UnitId
             , Object_Unit.ValueData AS UnitName

             , Object_Currency.Id        AS CurrencyId
             , Object_Currency.ValueData AS CurrencyName

             , CAST ('' AS TVarChar) AS Comment

          FROM lfGet_Object_Status (zc_Enum_Status_UnComplete()) AS lfGet
            LEFT JOIN ObjectLink AS ObjectLink_User_Unit
                                 ON ObjectLink_User_Unit.ObjectId = vbUserId
                                AND ObjectLink_User_Unit.DescId = zc_ObjectLink_User_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_User_Unit.ChildObjectId
            
            LEFT JOIN Object AS Object_Cash ON Object_Cash.Id = inCashId
            LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = inCurrencyId
         ;
     ELSE

       RETURN QUERY
         SELECT
               Movement.Id
             , Movement.InvNumber
             , Movement.OperDate
             , Object_Status.ObjectCode              AS StatusCode
             , Object_Status.ValueData               AS StatusName

             , MovementFloat_CurrencyValue.ValueData AS CurrencyValue
             , MovementFloat_ParValue.ValueData      AS ParValue
             , MovementFloat_CurrencyPartnerValue.ValueData AS CurrencyPartnerValue
             , MovementFloat_ParPartnerValue.ValueData      AS ParPartnerValue
             
             , CASE WHEN COALESCE (MovementItem.Amount,0) < 0 THEN -1 * MovementItem.Amount ELSE 0 END :: TFloat AS AmountOut
             , CASE WHEN COALESCE (MovementItem.Amount,0) > 0 THEN MovementItem.Amount ELSE 0 END      :: TFloat AS AmountIn
             
             , Object_Cash.Id                        AS CashId
             , Object_Cash.ValueData                 AS CashName
             , Object_MoneyPlace.Id                  AS MoneyPlaceId
             , Object_MoneyPlace.ValueData           AS MoneyPlaceName

             , Object_InfoMoney.Id                   AS InfoMoneyId
             , Object_InfoMoney.ValueData            AS InfoMoneyName
             , Object_Unit.Id                        AS UnitId
             , Object_Unit.ValueData                 AS UnitName

             , Object_Currency.Id                        AS CurrencyId
             , Object_Currency.ValueData                 AS CurrencyName

             , MIString_Comment.ValueData  ::TVarChar    AS Comment

       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementFloat AS MovementFloat_ParValue
                                    ON MovementFloat_ParValue.MovementId = Movement.Id
                                   AND MovementFloat_ParValue.DescId = zc_MovementFloat_ParValue()
            LEFT JOIN MovementFloat AS MovementFloat_CurrencyValue
                                    ON MovementFloat_CurrencyValue.MovementId =  Movement.Id
                                   AND MovementFloat_CurrencyValue.DescId = zc_MovementFloat_CurrencyValue()

            LEFT JOIN MovementFloat AS MovementFloat_ParPartnerValue
                                    ON MovementFloat_ParPartnerValue.MovementId = Movement.Id
                                   AND MovementFloat_ParValue.DescId = zc_MovementFloat_ParPartnerValue()
            LEFT JOIN MovementFloat AS MovementFloat_CurrencyPartnerValue
                                    ON MovementFloat_CurrencyPartnerValue.MovementId =  Movement.Id
                                   AND MovementFloat_CurrencyPartnerValue.DescId = zc_MovementFloat_CurrencyPartnerValue()

            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                   AND MovementItem.DescId     = zc_MI_Master()
                                   
            LEFT JOIN Object AS Object_Cash ON Object_Cash.Id = MovementItem.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Cash_Currency
                                 ON ObjectLink_Cash_Currency.ObjectId = Object_Cash.Id
                                AND ObjectLink_Cash_Currency.DescId = zc_ObjectLink_Cash_Currency()
            LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = ObjectLink_Cash_Currency.ChildObjectId

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
            LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = MILinkObject_InfoMoney.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                             ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MILinkObject_Unit.ObjectId

       WHERE Movement.Id     = inMovementId
         AND Movement.DescId = zc_Movement_Cash()
       ;

     END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.07.18         *
*/

-- тест
-- SELECT * FROM gpGet_Movement_Cash (inMovementId:= 1, inOperDate:= CURRENT_DATE, inSession:= zfCalc_UserAdmin())
