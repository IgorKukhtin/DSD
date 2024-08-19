-- Function: gpSelect_Object_Currency_Value()

DROP FUNCTION IF EXISTS gpSelect_Object_Currency_ForCash (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Currency_ForCash(
    IN inOperDate        TDateTime ,    --
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
      WITH tmpCurrencyGuide_All AS (SELECT zc_Enum_Currency_Basis() AS CurrencyFromId, Object_Currency.Id AS CurrencyToId
                                    FROM Object AS Object_Currency
                                    WHERE Object_Currency.DescId = zc_Object_Currency()
                                      AND Object_Currency.Id     <> zc_Enum_Currency_Basis()
                                   )
         , tmpCurrencyGuide AS (SELECT CurrencyFromId, CurrencyToId FROM tmpCurrencyGuide_All UNION SELECT CurrencyToId, CurrencyFromId FROM tmpCurrencyGuide_All
                          )
          , tmpMovement AS (SELECT MovementItem.ObjectId          AS CurrencyFromId
                                 , MovementItem.Amount            AS Amount
                                 , MILinkObject_Currency.ObjectId AS CurrencyToId
                                 , MILinkObject_PaidKind.ObjectId AS PaidKindId
                                 , CASE WHEN MIFloat_ParValue.ValueData > 0
                                             THEN MIFloat_ParValue.ValueData
                                        ELSE 1
                                   END AS ParValue
                                   --  № п/п
                                 , ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId, MILinkObject_Currency.ObjectId, MILinkObject_PaidKind.ObjectId ORDER BY Movement.OperDate DESC) AS Ord
                            FROM Movement
                                 INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                        AND MovementItem.DescId     = zc_MI_Master()
                                 INNER JOIN MovementItemLinkObject AS MILinkObject_PaidKind
                                                                   ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_PaidKind.DescId         = zc_MILinkObject_PaidKind()
                                 INNER JOIN MovementItemLinkObject AS MILinkObject_Currency
                                                                   ON MILinkObject_Currency.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_Currency.DescId         = zc_MILinkObject_Currency()
                                 INNER JOIN tmpCurrencyGuide ON tmpCurrencyGuide.CurrencyFromId = MovementItem.ObjectId
                                                            AND tmpCurrencyGuide.CurrencyToId   = MILinkObject_Currency.ObjectId
                                 LEFT JOIN MovementItemFloat AS MIFloat_ParValue
                                                             ON MIFloat_ParValue.MovementItemId = MovementItem.Id
                                                            AND MIFloat_ParValue.DescId         = zc_MIFloat_ParValue()
                            WHERE Movement.DescId   = zc_Movement_Currency()
                              AND Movement.OperDate BETWEEN DATE_TRUNC ('MONTH', inOperDate) - INTERVAL '1 MONTH' AND inOperDate
                              AND Movement.StatusId = zc_Enum_Status_Complete()
                           )
      , tmpMovementCash AS (SELECT zc_Enum_Currency_Basis()          AS CurrencyFromId
                                 , MF_CurrencyPartnerValue.ValueData AS Amount
                                 , MILinkObject_Currency.ObjectId    AS CurrencyToId
                                 , CASE WHEN MF_ParPartnerValue.ValueData > 0
                                             THEN MF_ParPartnerValue.ValueData
                                        ELSE 1
                                   END AS ParValue
                                   --  № п/п
                                 , ROW_NUMBER() OVER (PARTITION BY MILinkObject_Currency.ObjectId ORDER BY Movement.OperDate DESC, Movement.Id DESC) AS Ord
                            FROM Movement
                                 INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                        AND MovementItem.DescId     = zc_MI_Master()
                                                        AND MovementItem.isErased   = FALSE
                                 INNER JOIN MovementItemLinkObject AS MILinkObject_Currency
                                                                   ON MILinkObject_Currency.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_Currency.DescId         = zc_MILinkObject_Currency()
                                                                  AND MILinkObject_Currency.ObjectId       <> zc_Enum_Currency_Basis()
                                 INNER JOIN MovementFloat AS MF_ParPartnerValue
                                                          ON MF_ParPartnerValue.MovementId = Movement.Id
                                                         AND MF_ParPartnerValue.DescId     = zc_MovementFloat_ParPartnerValue()
                                                         AND MF_ParPartnerValue.ValueData  > 0
                                 LEFT JOIN MovementFloat AS MF_CurrencyPartnerValue
                                                         ON MF_CurrencyPartnerValue.MovementId = Movement.Id
                                                        AND MF_CurrencyPartnerValue.DescId     = zc_MovementFloat_CurrencyPartnerValue()
                            WHERE Movement.DescId   = zc_Movement_Cash()
                              AND Movement.OperDate BETWEEN inOperDate - INTERVAL '1 MONTH' AND inOperDate -- !!!ограничим за 1 Месяц!!!
                              AND Movement.StatusId = zc_Enum_Status_Complete()
                              AND 1=0
                           )
         , tmpCurrency AS (SELECT tmpMovementCash.CurrencyFromId
                                , tmpMovementCash.CurrencyToId
                                , tmpMovementCash.Amount
                                , tmpMovementCash.ParValue
                           FROM tmpMovementCash
                           WHERE tmpMovementCash.Ord = 1 -- !!!берется Последний!!!
                          UNION ALL
                           SELECT zc_Enum_Currency_Basis()   AS CurrencyFromId
                                , CASE WHEN tmpMovement.CurrencyFromId = zc_Enum_Currency_Basis() THEN tmpMovement.CurrencyToId ELSE tmpMovement.CurrencyFromId END AS CurrencyToId
                                , CASE WHEN tmpMovement.CurrencyFromId = zc_Enum_Currency_Basis()
                                            THEN tmpMovement.Amount
                                       WHEN tmpMovement.CurrencyToId = zc_Enum_Currency_Basis()
                                            THEN tmpMovement.ParValue / tmpMovement.Amount
                                  END AS Amount
                                , tmpMovement.ParValue       AS ParValue
                           FROM tmpMovement
                                LEFT JOIN tmpMovementCash ON tmpMovementCash.CurrencyToId = CASE WHEN tmpMovement.CurrencyFromId = zc_Enum_Currency_Basis()
                                                                                                      THEN tmpMovement.CurrencyToId
                                                                                                 ELSE tmpMovement.CurrencyFromId
                                                                                            END
                           WHERE tmpMovement.Ord = 1 -- !!!берется Последний!!!
                             AND tmpMovementCash.CurrencyToId IS NULL
                             AND tmpMovement.PaidKindId = zc_Enum_PaidKind_SecondForm() -- !!!НАЛ!!!

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
 15.04.16         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Currency_ForCash (inOperDate:= CURRENT_DATE, inSession:= zfCalc_UserAdmin())
