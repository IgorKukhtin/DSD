 -- Function: gpGet_GoodsPriceLastIncome()

DROP FUNCTION IF EXISTS gpGet_GoodsPriceLastIncome (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_GoodsPriceLastIncome(
    IN inUnitId           Integer  ,  -- Подразделение
    IN inGoodsId          Integer  ,  -- Товар
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (ID  Integer
             , InvNumber  TVarChar
             , OperDate TDateTime
             , DescId Integer
             , Amount TFloat
             , PriceWithVAT TFloat
             , isPromo boolean
             , PriceSaleMin TFloat
             , isErased boolean
             )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbPriceSamples TFloat;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);

    SELECT COALESCE(ObjectFloat_CashSettings_PriceSamples.ValueData, 0)                          AS PriceSamples
    INTO vbPriceSamples
    FROM Object AS Object_CashSettings

         LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_PriceSamples
                               ON ObjectFloat_CashSettings_PriceSamples.ObjectId = Object_CashSettings.Id 
                              AND ObjectFloat_CashSettings_PriceSamples.DescId = zc_ObjectFloat_CashSettings_PriceSamples()

    WHERE Object_CashSettings.DescId = zc_Object_CashSettings()
    LIMIT 1;    

    -- Результат
    RETURN QUERY
    WITH  GoodsPromo AS (SELECT DISTINCT tmp.GoodsId
                         FROM lpSelect_MovementItem_Promo_onDate (inOperDate:= CURRENT_DATE) AS tmp   --CURRENT_DATE
                         )
                           
    SELECT Movement.ID
         , Movement.InvNumber
         , Movement.OperDate
         , Movement.DescId
         , MovementItem.Amount
         , Round(CASE WHEN COALESCE(MovementBoolean_PriceWithVAT.ValueData, False) THEN MIFloat_Price.ValueData
                      ELSE MIFloat_Price.ValueData * (1 + COALESCE(ObjectFloat_NDSKind_NDS.ValueData, 7)/100)
                      END, 2) ::TFloat  AS PriceWithVAT
         , CASE WHEN COALESCE(GoodsPromo.GoodsId,0) <> 0 THEN TRUE ELSE FALSE END AS isPromo
         , Round(CASE WHEN COALESCE(MovementBoolean_PriceWithVAT.ValueData, False) THEN MIFloat_Price.ValueData
                      ELSE MIFloat_Price.ValueData * (1 + COALESCE(ObjectFloat_NDSKind_NDS.ValueData, 7)/100)
                      END * CASE WHEN COALESCE(GoodsPromo.GoodsId,0) <> 0 THEN 1.03 ELSE 1.045 END, 1) ::TFloat  AS PriceSaleMin
         
         , MovementItem.IsErased

    FROM MovementItem

       INNER JOIN Movement ON Movement.ID = MovementItem.MovementId
                          AND Movement.DescId = zc_Movement_Income()
                          AND Movement.StatusId = zc_Enum_Status_Complete()


       INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                     ON MovementLinkObject_Unit.MovementId = Movement.Id
                                    AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_To()
                                    AND MovementLinkObject_Unit.ObjectId = inUnitId

       LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                 ON MovementBoolean_PriceWithVAT.MovementId = Movement.Id
                                AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()

       LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                    ON MovementLinkObject_NDSKind.MovementId = Movement.Id
                                   AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()
       LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                             ON ObjectFloat_NDSKind_NDS.ObjectId = MovementLinkObject_NDSKind.ObjectId
                            AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()

       LEFT JOIN MovementItemFloat AS MIFloat_Price
                                   ON MIFloat_Price.MovementItemId = MovementItem.Id
                                  AND MIFloat_Price.DescId = zc_MIFloat_Price()

       LEFT JOIN GoodsPromo ON GoodsPromo.GoodsId = MovementItem.ObjectId
                                  
    WHERE MovementItem.ObjectId = inGoodsId
      AND MovementItem.IsErased = False
      AND MovementItem.Amount > 0
    ORDER BY ROW_NUMBER() OVER (ORDER BY Round(CASE WHEN COALESCE(MovementBoolean_PriceWithVAT.ValueData, False) THEN MIFloat_Price.ValueData
                      ELSE MIFloat_Price.ValueData * (1 + COALESCE(ObjectFloat_NDSKind_NDS.ValueData, 7)/100)
                      END, 2) ::TFloat < vbPriceSamples, Movement.OperDate DESC)
    LIMIT 1
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 30.11.21                                                       *
*/

-- тест
-- 

select * from gpGet_GoodsPriceLastIncome(inUnitId := 377605 , inGoodsId := 55051 ,  inSession := '3');