-- Function: zfCalc_QTY_toWMS

DROP FUNCTION IF EXISTS zfCalc_QTY_toWMS (Integer, Integer, TFloat, TFloat, TFloat, TFloat);
DROP FUNCTION IF EXISTS zfCalc_QTY_toWMS (Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat);

CREATE OR REPLACE FUNCTION zfCalc_QTY_toWMS(
     IN inGoodsTypeKindId Integer,
     IN inMeasureId       Integer,
     IN inAmount          TFloat, -- Кол-во в MeasureId
     IN inRealWeight      TFloat, -- реальный вес
     IN inCount           TFloat, -- если точно известно сколько Шт-WMS
     IN inWeightMin       TFloat,
     IN inWeightMax       TFloat
 )
RETURNS TFloat
AS
$BODY$
BEGIN
  RETURN (CASE -- для весового количество передается в гр.
               WHEN inGoodsTypeKindId = zc_Enum_GoodsTypeKind_Ves()
                    THEN inAmount * 1000.0
               -- если точно известно Шт-WMS тогда их и отдаем
               WHEN inCount > 0
                    THEN inCount
               -- если Шт. тогда их и отдаем
               WHEN inMeasureId = zc_Measure_Sh()
                    THEN inAmount
               -- err
               WHEN COALESCE (inWeightMin, 0) = 0 OR COALESCE (inWeightMax, 0) = 0
                    THEN -1
               -- так переводим Вес в Шт-WMS
               ELSE ROUND (inAmount / ((inWeightMin + inWeightMax) / 2), 0)
          END);

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.08.19                                        *
*/

-- тест
-- SELECT * FROM zfCalc_QTY_toWMS (inGoodsTypeKindId:= zc_Enum_GoodsTypeKind_Sh(),  inMeasureId:= zc_Measure_Kg(), inAmount:= 1, inRealWeight:= 1, inCount:= 10, inWeightMin:= 0.1, inWeightMax:= 0.1)
-- SELECT * FROM zfCalc_QTY_toWMS (inGoodsTypeKindId:= zc_Enum_GoodsTypeKind_Nom(), inMeasureId:= zc_Measure_Kg(), inAmount:= 1, inRealWeight:= 1, inCount:= 10, inWeightMin:= 0.1, inWeightMax:= 0.1)
-- SELECT * FROM zfCalc_QTY_toWMS (inGoodsTypeKindId:= zc_Enum_GoodsTypeKind_Ves(), inMeasureId:= zc_Measure_Kg(), inAmount:= 1, inRealWeight:= 1, inCount:= 10, inWeightMin:= 0.1, inWeightMax:= 0.1)
