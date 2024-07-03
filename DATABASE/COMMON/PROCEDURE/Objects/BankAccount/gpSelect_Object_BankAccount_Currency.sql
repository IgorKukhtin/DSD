-- Function: gpSelect_Object_BankAccount_Currency(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_BankAccount_Currency (TDateTime, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_BankAccount_Currency (TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_BankAccount_Currency (TDateTime, Boolean, TVarChar);



CREATE OR REPLACE FUNCTION gpSelect_Object_BankAccount_Currency(
    IN inOperDate    TDateTime ,    -- 
    IN inIsShowAll   Boolean,    --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, NameAll TVarChar, isErased Boolean
             , BankId Integer, BankName TVarChar, CurrencyId Integer, CurrencyName TVarChar
             , CurrencyValue TFloat, ParValue TFloat, JuridicalId Integer, JuridicalName TVarChar
              )
AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

     RETURN QUERY
      WITH tmpCurrencyGuide_All AS (SELECT zc_Enum_Currency_Basis() AS CurrencyFromId, Object_Currency.Id AS CurrencyToId
                                    FROM Object AS Object_Currency
                                    WHERE Object_Currency.DescId = zc_Object_Currency()
                                      AND Object_Currency.Id <> zc_Enum_Currency_Basis()
                                   ) 
         , tmpCurrencyGuide AS (SELECT CurrencyFromId, CurrencyToId FROM tmpCurrencyGuide_All UNION SELECT CurrencyToId, CurrencyFromId FROM tmpCurrencyGuide_All
                          ) 
          , tmpMovement AS (SELECT Movement.Id                    AS MovementId
                                 , Movement.OperDate              AS OperDate
                                 , MovementItem.Id                AS MovementItemId
                                 , MovementItem.ObjectId          AS CurrencyFromId
                                 , MovementItem.Amount            AS Amount
                                 , MILinkObject_Currency.ObjectId AS CurrencyToId
                                 , CASE WHEN MovementItem.ObjectId = zc_Enum_Currency_Basis() THEN MILinkObject_Currency.ObjectId ELSE MovementItem.ObjectId END AS CurrencyToId_calc
                                 , MILinkObject_PaidKind.ObjectId AS PaidKindId
                            FROM Movement
                                 INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                        AND MovementItem.DescId = zc_MI_Master()
                                 INNER JOIN MovementItemLinkObject AS MILinkObject_PaidKind
                                                                   ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_PaidKind.DescId = zc_MILinkObject_PaidKind()
                                                                  AND MILinkObject_PaidKind.ObjectId = zc_Enum_PaidKind_FirstForm()
                                 INNER JOIN MovementItemLinkObject AS MILinkObject_Currency
                                                                   ON MILinkObject_Currency.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_Currency.DescId = zc_MILinkObject_Currency()
                                 INNER JOIN tmpCurrencyGuide ON tmpCurrencyGuide.CurrencyFromId = MovementItem.ObjectId
                                                            AND tmpCurrencyGuide.CurrencyToId = MILinkObject_Currency.ObjectId
                            WHERE Movement.DescId = zc_Movement_Currency()
                              AND Movement.OperDate <= inOperDate
                              AND Movement.StatusId = zc_Enum_Status_Complete()
                           )
         , tmpCurrency AS (SELECT zc_Enum_Currency_Basis() AS CurrencyFromId
                                , tmpMovement.CurrencyToId_calc AS CurrencyToId
                                , CASE WHEN tmpMovement.CurrencyFromId = zc_Enum_Currency_Basis()
                                            THEN tmpMovement.Amount
                                       WHEN tmpMovement.CurrencyToId = zc_Enum_Currency_Basis()
                                            THEN CASE WHEN MIFloat_ParValue.ValueData > 0 THEN MIFloat_ParValue.ValueData ELSE 1 END / tmpMovement.Amount
                                               * CASE WHEN MIFloat_ParValue.ValueData > 0 THEN MIFloat_ParValue.ValueData ELSE 1 END
                                  END AS Amount

                                , CASE WHEN MIFloat_ParValue.ValueData > 0
                                            THEN MIFloat_ParValue.ValueData
                                       ELSE 1
                                  END AS ParValue

                           FROM (SELECT tmpMovement.CurrencyToId_calc AS CurrencyToId_calc
                                      , MAX (tmpMovement.OperDate)    AS OperDate
                                 FROM tmpMovement
                                 GROUP BY tmpMovement.CurrencyToId_calc
                                ) AS tmpMovement_find
                                INNER JOIN tmpMovement ON tmpMovement.OperDate = tmpMovement_find.OperDate
                                                      AND tmpMovement.CurrencyToId_calc = tmpMovement_find.CurrencyToId_calc
                                LEFT JOIN MovementItemFloat AS MIFloat_ParValue
                                                            ON MIFloat_ParValue.MovementItemId = tmpMovement.MovementItemId
                                                           AND MIFloat_ParValue.DescId = zc_MIFloat_ParValue()
                          )
      SELECT Object_BankAccount_View.Id
           , Object_BankAccount_View.Code
           , Object_BankAccount_View.Name
           , (Object_BankAccount_View.BankName || '' || Object_BankAccount_View.Name) :: TVarChar AS NameAll
           , Object_BankAccount_View.isErased
           , Object_BankAccount_View.BankId
           , Object_BankAccount_View.BankName
           , Object_BankAccount_View.CurrencyId
           , Object_BankAccount_View.CurrencyName
           , tmpCurrency.Amount   :: TFloat AS CurrencyValue
           , tmpCurrency.ParValue :: TFloat AS ParValue
           , Object_BankAccount_View.JuridicalId
           , Object_BankAccount_View.JuridicalName
     FROM Object_BankAccount_View
          -- Покажем счета только по внутренним фирмам
          INNER JOIN ObjectBoolean AS ObjectBoolean_isCorporate
                                   ON ObjectBoolean_isCorporate.ObjectId = Object_BankAccount_View.JuridicalId
                                  AND ObjectBoolean_isCorporate.DescId = zc_ObjectBoolean_Juridical_isCorporate()
                                  AND (ObjectBoolean_isCorporate.ValueData = TRUE
                                    OR Object_BankAccount_View.JuridicalId = 15505 -- ДУКО ТОВ 
                                    OR Object_BankAccount_View.JuridicalId = 15512 -- Ірна-1 Фірма ТОВ
                                    OR Object_BankAccount_View.isCorporate = TRUE
                                      )
          LEFT JOIN tmpCurrency ON tmpCurrency.CurrencyToId = Object_BankAccount_View.CurrencyId
     WHERE Object_BankAccount_View.isErased = FALSE
        OR (Object_BankAccount_View.isErased = TRUE AND inIsShowAll = TRUE)

    ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 13.11.14                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Object_BankAccount_Currency (inOperDate:= CURRENT_DATE, inIsShowAll:= FALSE, inSession:= zfCalc_UserAdmin())
