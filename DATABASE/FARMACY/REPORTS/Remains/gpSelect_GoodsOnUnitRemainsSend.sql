 -- Function: gpSelect_GoodsOnUnitRemainsSend()

DROP FUNCTION IF EXISTS gpSelect_GoodsOnUnitRemainsSend (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsOnUnitRemainsSend(
    IN inMovementId        Integer  ,  -- Перемещение
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (ContainerId Integer
             , Id Integer, GoodsCode Integer, GoodsName TVarChar, GoodsGroupName TVarChar
             , NDSKindName TVarChar, NDS TFloat
             , isSP Boolean, isPromo boolean
             , ConditionsKeepName TVarChar
             , Amount TFloat, Price TFloat, PriceWithVAT TFloat, PriceWithOutVAT TFloat, PriceSale  TFloat

             , Summa TFloat, SummaWithVAT TFloat, SummaWithOutVAT TFloat, SummaSale TFloat
             , MinExpirationDate TDateTime
             , PartionDescName TVarChar, PartionInvNumber TVarChar, PartionOperDate TDateTime
             , PartionPriceDescName TVarChar, PartionPriceInvNumber TVarChar, PartionPriceOperDate TDateTime

             , UnitName TVarChar, OurJuridicalName TVarChar
             , JuridicalCode  Integer, JuridicalName  TVarChar
             , MP_JuridicalName TVarChar
             , MP_ContractName TVarChar
             , MinPriceOnDate TFloat, MP_Summa TFloat
             , MinPriceOnDateVAT TFloat, MP_SummaVAT TFloat

             , MakerName  TVarChar, BarCode TVarChar, MorionCode Integer, BadmCode TVarChar, OptimaCode TVarChar, AccommodationName TVarChar
             , CodeUKTZED TVarChar, FormDispensingName TVarChar
             )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
BEGIN


    --определяем подразделение получателя
    SELECT MovementLinkObject_From.ObjectId                             AS UnitId
    INTO vbUnitId
    FROM Movement

          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                               
    WHERE Movement.Id = inMovementId;
    
    -- Результат
    RETURN QUERY
    WITH tmpMI AS (SELECT DISTINCT MovementItem.ObjectId AS GoodsId
                   FROM MovementItem
                   WHERE MovementItem.MovementId = inMovementId
                     AND MovementItem.DescId = zc_MI_Master()
                     AND MovementItem.isErased = FALSE)
    
    SELECT UnitRemains.ContainerId
         , UnitRemains.Id, UnitRemains.GoodsCode, UnitRemains.GoodsName, UnitRemains.GoodsGroupName
         , UnitRemains.NDSKindName, UnitRemains.NDS
         , UnitRemains.isSP, UnitRemains.isPromo
         , UnitRemains.ConditionsKeepName
         , UnitRemains.Amount, UnitRemains.Price, UnitRemains.PriceWithVAT, UnitRemains.PriceWithOutVAT, UnitRemains.PriceSale

         , UnitRemains.Summa, UnitRemains.SummaWithVAT, UnitRemains.SummaWithOutVAT, UnitRemains.SummaSale
         , UnitRemains.MinExpirationDate
         , UnitRemains.PartionDescName, UnitRemains.PartionInvNumber, UnitRemains.PartionOperDate
         , UnitRemains.PartionPriceDescName, UnitRemains.PartionPriceInvNumber, UnitRemains.PartionPriceOperDate

         , UnitRemains.UnitName, UnitRemains.OurJuridicalName
         , UnitRemains.JuridicalCode, UnitRemains.JuridicalName
         , UnitRemains.MP_JuridicalName
         , UnitRemains.MP_ContractName
         , UnitRemains.MinPriceOnDate, UnitRemains.MP_Summa
         , UnitRemains.MinPriceOnDateVAT, UnitRemains.MP_SummaVAT

         , UnitRemains.MakerName, UnitRemains.BarCode, UnitRemains.MorionCode, UnitRemains.BadmCode, UnitRemains.OptimaCode, UnitRemains.AccommodationName
         , UnitRemains.CodeUKTZED, UnitRemains.FormDispensingName
    FROM gpSelect_GoodsOnUnitRemains(inUnitId := vbUnitId , inRemainsDate := CURRENT_DATE + INTERVAL '1 DAY' , inIsPartion := 'True' , inisPartionPrice := 'False' , inisJuridical := 'False' , inisVendorminPrices := 'False' ,  inSession := inSession) AS UnitRemains
    
         INNER JOIN tmpMI ON tmpMI.GoodsId = UnitRemains.Id
    ;


END;

$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 18.10.23                                                       *
*/

-- тест
--

SELECT * FROM gpSelect_GoodsOnUnitRemainsSend(inMovementId := 33727578 ,  inSession := '3');
