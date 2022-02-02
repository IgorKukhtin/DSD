-- Function: qpMovement_TestSend_RemainsSunSupplement

DROP FUNCTION IF EXISTS qpMovement_TestSend_RemainsSunSupplement (TDateTime, Integer, Integer);

CREATE OR REPLACE FUNCTION qpMovement_TestSend_RemainsSunSupplement(
    IN inOperDate            TDateTime , -- Дата начала отчета
    IN inDriverId            Integer   , -- Водитель, распределяем только по аптекам этого
    IN inUserId              Integer     -- пользователь
)
RETURNS TABLE (
               UnitId Integer,
               UnitName TVarChar,
               GoodsId Integer,
               GoodsCode Integer,
               GoodsName TVarChar,
               MCS TFloat,
               AmountRemains TFloat,
               AmountSalesDay TFloat,
               AmountSalesMonth TFloat,
               AverageSalesMonth TFloat,
               SupplementMin Integer,
               Need TFloat
              )
AS
$BODY$
   DECLARE vbObjectId Integer;
BEGIN
     --
     vbObjectId := lpGet_DefaultValue ('zc_Object_Retail', inUserId);

     PERFORM lpInsert_Movement_Send_RemainsSun_Supplement (inOperDate:= inOperDate, inDriverId:= inDriverId, inUserId:= inUserId);

  -- raise notice 'Value 05: %', (SELECT COUNT(*) FROM _tmpUnit_SUN);

     -- Результат
     RETURN QUERY
       SELECT _tmpRemains_all_Supplement.UnitId,
              Object_Unit.valuedata,
              _tmpRemains_all_Supplement.GoodsId,
              Object_Goods.objectcode,
              Object_Goods.valuedata,
              _tmpRemains_all_Supplement.MCS,
              _tmpRemains_all_Supplement.AmountRemains,
              _tmpRemains_all_Supplement.AmountSalesDay,
              _tmpRemains_all_Supplement.AmountSalesMonth,
              _tmpRemains_all_Supplement.AverageSalesMonth,
              _tmpRemains_all_Supplement.SupplementMin,
              _tmpRemains_all_Supplement.Need
       FROM _tmpRemains_all_Supplement

            LEFT JOIN _tmpGoods_SUN_Supplement ON _tmpGoods_SUN_Supplement.GoodsID = _tmpRemains_all_Supplement.GoodsId

            LEFT JOIN _tmpUnit_SUN_Supplement ON _tmpUnit_SUN_Supplement.UnitId = _tmpRemains_all_Supplement.UnitId

            LEFT JOIN Object AS Object_Unit  ON Object_Unit.Id  = _tmpRemains_all_Supplement.UnitId
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = _tmpRemains_all_Supplement.GoodsId
       WHERE _tmpUnit_SUN_Supplement.isSUN_Supplement_in = True
       ;



END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
*/
-- тест


select * from qpMovement_TestSend_RemainsSunSupplement(inOperDate:= CURRENT_DATE + INTERVAL '1 DAY', inDriverId:= 0, inUserId:= 3);
