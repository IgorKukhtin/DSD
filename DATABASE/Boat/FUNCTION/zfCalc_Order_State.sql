-- Function: zfCalc_Order_State (TVarChar, Boolean)

DROP FUNCTION IF EXISTS zfCalc_Order_State (Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS zfCalc_Order_State (Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS zfCalc_Order_State (Boolean, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION zfCalc_Order_State(
    IN inIsSale                       Boolean , --
    IN inNPP                          Integer , --
    IN inMovementId_OrderInternal     Integer , --
    IN inMovementId_ProductionUnion   Integer , --
    IN inObjectDescId_OrderInternal   Integer , --
    IN inObjectDescId_ProductionUnion Integer   --
)
RETURNS TVarChar
AS
$BODY$
BEGIN
      RETURN (CASE WHEN inIsSale = TRUE
                   THEN 'Продана'

                   WHEN inNPP > 0 AND inMovementId_ProductionUnion > 0
                    AND inObjectDescId_ProductionUnion = zc_Object_Product()
                   THEN 'Готова'

                   WHEN inNPP > 0 AND inMovementId_OrderInternal > 0
                    AND inObjectDescId_OrderInternal = zc_Object_Product()
                   THEN 'В заказе (лодка)'

                   WHEN inNPP > 0 AND inMovementId_ProductionUnion > 0
                    AND inObjectDescId_ProductionUnion = zc_Object_Goods()
                   THEN 'В работе (узлы)'

                   WHEN inNPP > 0 AND inMovementId_OrderInternal > 0
                    AND inObjectDescId_OrderInternal = zc_Object_Goods()
                   THEN 'В заказе (узлы)'

                   WHEN inNPP > 0
                   THEN 'Планируется'

                   ELSE ''

               END
--          || CASE WHEN inMovementId_OrderInternal   > 0 THEN ' ' || (SELECT zfCalc_InvNumber_isErased (MovementDesc.ItemName, Movement.InvNumber, Movement.OperDate, Movement.StatusId) FROM Movement JOIN MovementDesc ON MovementDesc.Id = Movement.DescId WHERE Movement.Id = inMovementId_OrderInternal)   ELSE '' END
--          || CASE WHEN inMovementId_ProductionUnion > 0 THEN ' ' || (SELECT zfCalc_InvNumber_isErased (MovementDesc.ItemName, Movement.InvNumber, Movement.OperDate, Movement.StatusId) FROM Movement JOIN MovementDesc ON MovementDesc.Id = Movement.DescId WHERE Movement.Id = inMovementId_ProductionUnion) ELSE '' END
            );

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.05.21                                        *
*/

-- тест
-- SELECT zfCalc_Order_State (FALSE, 1, 1, 2, zc_Object_Product(), zc_Object_Product()), zfCalc_Order_State (FALSE, 1, 1, 2, zc_Object_Goods(), zc_Object_Goods())
