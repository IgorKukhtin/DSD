-- Function: gpSelect_Object_Currency_Value()

DROP FUNCTION IF EXISTS gpSelect_Object_Currency_Value (TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Currency_Value(
    IN inOperDate        TDateTime ,    --
    IN inCurrencyFromId  Integer   ,    --
    IN inSession         TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased Boolean
             , InternalName TVarChar
             , CurrencyValue TFloat, ParValue TFloat
              )
AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   RETURN QUERY
      WITH tmpCurrencyGuide_All AS (SELECT inCurrencyFromId AS CurrencyFromId, Object_Currency.Id AS CurrencyToId
                                    FROM Object AS Object_Currency
                                    WHERE Object_Currency.DescId = zc_Object_Currency()
                                      AND Object_Currency.Id     <> inCurrencyFromId
                                      AND inCurrencyFromId       = zc_Enum_Currency_Basis()
                                   )
         , tmpCurrencyGuide AS (SELECT CurrencyFromId, CurrencyToId FROM tmpCurrencyGuide_All UNION SELECT CurrencyToId, CurrencyFromId FROM tmpCurrencyGuide_All
                          )
          , tmpMovement AS (SELECT MovementItem.ObjectId          AS CurrencyFromId
                                 , MovementItem.Amount            AS Amount
                                 , MILinkObject_Currency.ObjectId AS CurrencyToId
                                 , CASE WHEN MIFloat_ParValue.ValueData > 0
                                             THEN MIFloat_ParValue.ValueData
                                        ELSE 1
                                   END AS ParValue
                                   --  № п/п
                                 , ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId, MILinkObject_Currency.ObjectId ORDER BY Movement.OperDate DESC) AS Ord
                            FROM Movement
                                 INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                        AND MovementItem.DescId     = zc_MI_Master()
                                 INNER JOIN MovementItemLinkObject AS MILinkObject_PaidKind
                                                                   ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_PaidKind.DescId         = zc_MILinkObject_PaidKind()
                                                                  AND MILinkObject_PaidKind.ObjectId       = zc_Enum_PaidKind_FirstForm() -- !!!БН!!!
                                 INNER JOIN MovementItemLinkObject AS MILinkObject_Currency
                                                                   ON MILinkObject_Currency.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_Currency.DescId        = zc_MILinkObject_Currency()
                                 INNER JOIN tmpCurrencyGuide ON tmpCurrencyGuide.CurrencyFromId = MovementItem.ObjectId
                                                            AND tmpCurrencyGuide.CurrencyToId   = MILinkObject_Currency.ObjectId
                                 LEFT JOIN MovementItemFloat AS MIFloat_ParValue
                                                             ON MIFloat_ParValue.MovementItemId = MovementItem.Id
                                                            AND MIFloat_ParValue.DescId         = zc_MIFloat_ParValue()
                            WHERE Movement.DescId   = zc_Movement_Currency()
                              AND Movement.OperDate <= inOperDate
                              AND Movement.StatusId = zc_Enum_Status_Complete()
                           )
         , tmpCurrency AS (SELECT inCurrencyFromId AS CurrencyFromId
                                , CASE WHEN tmpMovement.CurrencyFromId = inCurrencyFromId THEN tmpMovement.CurrencyToId ELSE tmpMovement.CurrencyFromId END AS CurrencyToId
                                , CASE WHEN tmpMovement.CurrencyFromId = inCurrencyFromId
                                            THEN tmpMovement.Amount
                                       WHEN tmpMovement.CurrencyToId = inCurrencyFromId
                                            THEN tmpMovement.ParValue / tmpMovement.Amount
                                  END AS Amount
                                , tmpMovement.ParValue
                           FROM tmpMovement
                           WHERE tmpMovement.Ord = 1 -- !!!берется Последний!!!
                          )
      -- Результат
      SELECT Object_Currency_View.Id
           , Object_Currency_View.Code
           , Object_Currency_View.Name
           , Object_Currency_View.isErased
           , Object_Currency_View.InternalName
           , tmpCurrency.Amount   :: TFloat AS CurrencyValue
           , tmpCurrency.ParValue :: TFloat AS ParValue
      FROM Object_Currency_View
           LEFT JOIN tmpCurrency ON tmpCurrency.CurrencyToId = Object_Currency_View.Id
     ;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 15.11.14                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Currency_Value (inOperDate:= CURRENT_DATE,  inCurrencyFromId:= zc_Enum_Currency_Basis(), inSession:= zfCalc_UserAdmin())
