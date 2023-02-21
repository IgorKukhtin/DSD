-- Function: zfCalc_Order_State (TVarChar, Boolean)

DROP FUNCTION IF EXISTS zfCalc_Order_State_color (Boolean, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION zfCalc_Order_State_color(
    IN inIsSale                       Boolean , --
    IN inNPP                          Integer , --
    IN inMovementId_OrderInternal     Integer , --
    IN inMovementId_ProductionUnion   Integer , --
    IN inObjectDescId_OrderInternal   Integer , --
    IN inObjectDescId_ProductionUnion Integer   --
)
RETURNS Integer
AS
$BODY$
BEGIN
      RETURN (CASE WHEN inIsSale = TRUE
                   THEN zc_Color_Lime() --'�������'

                   WHEN inNPP > 0 AND inMovementId_ProductionUnion > 0
                    AND inObjectDescId_ProductionUnion = zc_Object_Product()
                   THEN zc_Color_GreenL() --'������'

                   WHEN inNPP > 0 AND inMovementId_OrderInternal > 0
                    AND inObjectDescId_OrderInternal = zc_Object_Product()
                   THEN zc_Color_Cyan() --'� ������ (�����)'

                   WHEN inNPP > 0 AND inMovementId_ProductionUnion > 0
                    AND inObjectDescId_ProductionUnion = zc_Object_Goods()
                   THEN zc_Color_Blue() --'� ������ (����)'

                   WHEN inNPP > 0 AND inMovementId_OrderInternal > 0
                    AND inObjectDescId_OrderInternal = zc_Object_Goods()
                   THEN zc_Color_Cyan() --'� ������ (����)'

                   WHEN inNPP > 0
                   THEN zc_Color_Pink() --'�����������'

                   ELSE zc_Color_White() --''

               END
            );

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 21.02.23         *
*/

-- ����
-- SELECT zfCalc_Order_State_color (FALSE, 1, 1, 2, zc_Object_Product(), zc_Object_Product())--, zfCalc_Order_State (FALSE, 1, 1, 2, zc_Object_Goods(), zc_Object_Goods())