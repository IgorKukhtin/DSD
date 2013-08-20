-- Function: gpSelect_MI_TransportFuelIn()

-- DROP FUNCTION gpSelect_MI_TransportFuelIn (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_TransportFuelIn(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , -- 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, FuelId Integer, FuelCode Integer, FuelName TVarChar
             , Amount TFloat
             , FromId Integer, FromName TVarChar
             , GoodsId Integer, GoodsName TVarChar
             , isErased Boolean
              )
AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_TransportFuelIn());

     -- inShowAll:= TRUE;

    RETURN QUERY 
       SELECT
             MovementItem.Id
           , Object_Fuel.Id          AS FuelId
           , Object_Fuel.ObjectCode  AS FuelCode
           , Object_Fuel.ValueData   AS FuelName

           , MovementItem.Amount     AS Amount
           
           , Object_From.Id          AS FromId
           , Object_From.ValueData   AS FromName

           , Object_Goods.Id         AS GoodsId
           , Object_Goods.ValueData  AS GoodsName
         
           , MovementItem.isErased

       FROM MovementItem
            LEFT JOIN Object AS Object_Fuel ON Object_Fuel.Id = MovementItem.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_From
                                             ON MILinkObject_From.MovementItemId = MovementItem.Id
                                            AND MILinkObject_From.DescId = zc_MILinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MILinkObject_From.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                             ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MILinkObject_Goods.ObjectId

       WHERE MovementItem.MovementId = inMovementId
         AND MovementItem.DescId =  zc_MI_Master();

END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MI_TransportFuelIn (Integer, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.08.13         * 
*/

-- тест
-- SELECT * FROM gpSelect_MI_TransportFuelIn (inMovementId:= 25173, inShowAll:= TRUE, inSession:= '2')
-- SELECT * FROM gpSelect_MI_TransportFuelIn (inMovementId:= 25173, inShowAll:= FALSE, inSession:= '2')
