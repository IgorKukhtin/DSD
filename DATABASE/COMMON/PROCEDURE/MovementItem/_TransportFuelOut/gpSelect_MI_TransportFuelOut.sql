-- Function: gpSelect_MI_TransportFuelOut()

-- DROP FUNCTION gpSelect_MI_TransportFuelOut (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_TransportFuelOut(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , -- 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, FuelId Integer, FuelCode Integer, FuelName TVarChar
             , Amount TFloat
             , AmountNorm TFloat
             , isErased Boolean
              )
AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_TransportFuelOut());

     -- inShowAll:= TRUE;

    RETURN QUERY 
       SELECT
             MovementItem.Id
           , Object_Fuel.Id          AS FuelId
           , Object_Fuel.ObjectCode  AS FuelCode
           , Object_Fuel.ValueData   AS FuelName

           , MovementItem.Amount     AS Amount
           
           , Object_AmountNorm.Id    AS AmountNorm
         
           , MovementItem.isErased

       FROM MovementItem
            LEFT JOIN Object AS Object_Fuel ON Object_Fuel.Id = MovementItem.ObjectId

            LEFT JOIN MovementItemFloat AS MIFloat_AmountNorm
                                        ON MIFloat_AmountNorm.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountNorm.DescId = zc_MIFloat_AmountNorm()

       WHERE MovementItem.MovementId = inMovementId
         AND MovementItem.DescId =  zc_MI_Master();

END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MI_TransportFuelOut (Integer, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.08.13         * 
*/

-- тест
-- SELECT * FROM gpSelect_MI_TransportFuelOut (inMovementId:= 25173, inShowAll:= TRUE, inSession:= '2')
-- SELECT * FROM gpSelect_MI_TransportFuelOut (inMovementId:= 25173, inShowAll:= FALSE, inSession:= '2')
