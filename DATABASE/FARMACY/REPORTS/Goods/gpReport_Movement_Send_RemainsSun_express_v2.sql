-- Function: gpReport_Send_RemainsSun_express_v2()

DROP FUNCTION IF EXISTS gpReport_Send_RemainsSun_express_v2 (TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Send_RemainsSun_express_v2 (TDateTime, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Movement_Send_RemainsSun_express_v2 (TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Movement_Send_RemainsSun_express_v2(
    IN inOperDate      TDateTime,
    IN inGoodsId       Integer,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
  DECLARE vbUserId     Integer;

  DECLARE vbDriverId_1 Integer;
  DECLARE vbDriverId_2 Integer;

  DECLARE Cursor1 refcursor;
  DECLARE Cursor2 refcursor;

BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId:= lpGetUserBySession (inSession);
     vbUserId := inSession;


     -- !!!первый водитель!!!
     vbDriverId_1 := (SELECT MAX (ObjectLink_Unit_Driver.ChildObjectId)
                      FROM ObjectLink AS ObjectLink_Unit_Driver
                           JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Unit_Driver.ObjectId AND Object_Unit.isErased = FALSE
                      WHERE ObjectLink_Unit_Driver.DescId        = zc_ObjectLink_Unit_Driver()
                     );
     -- !!!второй водитель!!!
     vbDriverId_2 := (SELECT MAX (ObjectLink_Unit_Driver.ChildObjectId)
                      FROM ObjectLink AS ObjectLink_Unit_Driver
                           JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Unit_Driver.ObjectId AND Object_Unit.isErased = FALSE
                      WHERE ObjectLink_Unit_Driver.DescId        = zc_ObjectLink_Unit_Driver()
                        AND ObjectLink_Unit_Driver.ChildObjectId <> vbDriverId_1
                     );


     -- все Подразделения для схемы SUN-EXPRESS
     CREATE TEMP TABLE _tmpUnit_SUN   (UnitId Integer, KoeffInSUN TFloat, KoeffOutSUN TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpUnit_SUN_a (UnitId Integer, KoeffInSUN TFloat, KoeffOutSUN TFloat) ON COMMIT DROP;
     -- Товары дисконтных проектов
     CREATE TEMP TABLE _tmpGoods_DiscountExternal  (UnitId Integer, GoodsId Integer) ON COMMIT DROP;

     -- 1. все остатки, НТЗ => получаем кол-ва излишек/потребность у Отправителя/Получателя
     CREATE TEMP TABLE _tmpRemains_all   (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, Amount_sale TFloat, Summ_sale TFloat, AmountResult_in TFloat, AmountResult_out TFloat, AmountRemains TFloat, AmountRemains_calc_in TFloat, AmountRemains_calc_out TFloat, AmountIncome TFloat, AmountSend_in TFloat, AmountSend_out TFloat, AmountOrderExternal TFloat, AmountReserve TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpRemains_all_a (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, Amount_sale TFloat, Summ_sale TFloat, AmountResult_in TFloat, AmountResult_out TFloat, AmountRemains TFloat, AmountRemains_calc_in TFloat, AmountRemains_calc_out TFloat, AmountIncome TFloat, AmountSend_in TFloat, AmountSend_out TFloat, AmountOrderExternal TFloat, AmountReserve TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpRemains   (UnitId Integer, GoodsId Integer, Price TFloat, AmountResult TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpRemains_a (UnitId Integer, GoodsId Integer, Price TFloat, AmountResult TFloat) ON COMMIT DROP;
     -- Исключения по техническим переучетам по Аптекам - если есть в непроведенных ТП то исключаем из распределения
     CREATE TEMP TABLE _tmpGoods_TP_exception   (UnitId Integer, GoodsId Integer) ON COMMIT DROP;

     -- 2.1. вся статистика продаж - EXPRESS
     CREATE TEMP TABLE _tmpSale_express   (DayOrd Integer, DayOrd_real Integer, UnitId Integer, GoodsId Integer, Amount TFloat, Amount_sum TFloat, Summ TFloat, Summ_sum TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpSale_express_a (DayOrd Integer, DayOrd_real Integer, UnitId Integer, GoodsId Integer, Amount TFloat, Amount_sum TFloat, Summ TFloat, Summ_sum TFloat) ON COMMIT DROP;
     -- 2.3. все товары для статистики продаж - EXPRESS + Кратность
     CREATE TEMP TABLE _tmpGoods_SUN  (GoodsId Integer, KoeffSUN TFloat) ON COMMIT DROP;

     -- 3.2. остатки, СРОК - для распределения
     CREATE TEMP TABLE _tmpRemains_Partion   (UnitId Integer, GoodsId Integer, AmountRemains TFloat, AmountResult TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpRemains_Partion_a (UnitId Integer, GoodsId Integer, AmountRemains TFloat, AmountResult TFloat) ON COMMIT DROP;

     -- 5. из каких аптек остатки со сроками "полностью" закрывают АВТОЗАКАЗ
     CREATE TEMP TABLE _tmpSumm_limit   (UnitId_from Integer, UnitId_to Integer, Summ TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpSumm_limit_a (UnitId_from Integer, UnitId_to Integer, Summ TFloat) ON COMMIT DROP;

     -- 6.1. распределяем-1 остатки со сроками - по всем аптекам - здесь только >= vbSumm_limit
     CREATE TEMP TABLE _tmpResult_Partion   (DriverId Integer, UnitId_from Integer, UnitId_to Integer, GoodsId Integer, Amount TFloat, Summ TFloat, MovementId Integer, MovementItemId Integer) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpResult_Partion_a (DriverId Integer, UnitId_from Integer, UnitId_to Integer, GoodsId Integer, Amount TFloat, Summ TFloat, MovementId Integer, MovementItemId Integer) ON COMMIT DROP;


     -- Результат
     CREATE TEMP TABLE _tmpResult (DriverId Integer, DriverName TVarChar
                                 , UnitId Integer, UnitName TVarChar
                                 , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
                                 , Amount_sale         TFloat -- Кол-во продажа у Получателя (статистика за Х*24 часов)
                                 , Summ_sale           TFloat -- Сумма  продажа у Получателя (статистика за Х*24 часов)
                                 , AmountSun_summ      TFloat -- Итого кол-во для распределения по всем точкам отправителям
                                 , AmountResult        TFloat -- Потребность у точки получателя
                                 , AmountResult_summ   TFloat -- Итого потребность у ВСЕХ точек получателей --инф
                                 , AmountRemains       TFloat -- Остаток
                                 , AmountRemains_calc  TFloat -- Остаток
                                 , AmountIncome        TFloat -- Приход (ожидаемый) --инф
                                 , AmountSend_in       TFloat -- Перемещение - приход (ожидается) --инф
                                 , AmountSend_out      TFloat -- Перемещение - расход (ожидается) --инф
                                 , AmountOrderExternal TFloat -- Заказ (ожидаемый) --инф
                                 , AmountReserve       TFloat -- Резерв по чекам --инф
                                 , Price               TFloat -- Цена
                                 , MCS                 TFloat -- НТЗ
                                 , Summ_min            TFloat -- информативно - мнимальн сумма
                                 , Summ_max            TFloat -- информативно - максимальн сумма
                                 , Unit_count          TFloat -- информативно - кол-во таких накл.
                                 , Summ_min_1          TFloat -- информативно - после распределения-1: мнимальн сумма
                                 , Summ_max_1          TFloat -- информативно - после распределения-1: максимальн сумма
                                 , Unit_count_1        TFloat -- информативно - после распределения-1: кол-во таких накл.
                                 , Summ_str            TVarChar
                                 , UnitName_str        TVarChar
                                   -- !!!результат!!!
                                 , Amount_res          TFloat
                                 , Summ_res            TFloat
                                 ) ON COMMIT DROP;
     -- Результат - ПЕРВЫЙ водитель
     INSERT INTO _tmpResult (DriverId, DriverName
                           , UnitId, UnitName
                           , GoodsId, GoodsCode, GoodsName
                           , Amount_sale
                           , Summ_sale
                           , AmountSun_summ
                           , AmountResult
                           , AmountResult_summ
                           , AmountRemains
                           , AmountRemains_calc
                           , AmountIncome
                           , AmountSend_in
                           , AmountSend_out
                           , AmountOrderExternal
                           , AmountReserve
                           , Price
                           , MCS
                           , Summ_min
                           , Summ_max
                           , Unit_count
                           , Summ_min_1
                           , Summ_max_1
                           , Unit_count_1
                           , Summ_str
                           , UnitName_str
                           , Amount_res
                           , Summ_res
                            )
          SELECT COALESCE (vbDriverId_1, 0)                              :: Integer  AS DriverId
               , COALESCE (lfGet_Object_ValueData_sh (vbDriverId_1), '') :: TVarChar AS DriverName
               , COALESCE (tmp.UnitId, 0)      :: Integer  AS UnitId
               , COALESCE (tmp.UnitName, '')   :: TVarChar AS UnitName
               , COALESCE (tmp.GoodsId, 0)     :: Integer  AS GoodsId
               , COALESCE (tmp.GoodsCode, 0)   :: Integer  AS GoodsCode
               , COALESCE (tmp.GoodsName, '')  :: TVarChar AS GoodsName
               , tmp.Amount_sale
               , tmp.Summ_sale
               , tmp.AmountSun_summ
               , COALESCE (tmp.AmountResult, 0)        :: TFloat AS AmountResult
               , tmp.AmountResult_summ
               , COALESCE (tmp.AmountRemains, 0)       :: TFloat AS AmountRemains
               , COALESCE (tmp.AmountRemains_calc, 0)  :: TFloat AS AmountRemains_calc
               , COALESCE (tmp.AmountIncome, 0)        :: TFloat AS AmountIncome
               , COALESCE (tmp.AmountSend_in, 0)       :: TFloat AS AmountSend_in
               , COALESCE (tmp.AmountSend_out, 0)      :: TFloat AS AmountSend_out
               , COALESCE (tmp.AmountOrderExternal, 0) :: TFloat AS AmountOrderExternal
               , COALESCE (tmp.AmountReserve, 0)       :: TFloat AS AmountReserve
               , COALESCE (tmp.Price, 0)   :: TFloat AS Price
               , COALESCE (tmp.MCS, 0)     :: TFloat AS MCS
               , tmp.Summ_min
               , tmp.Summ_max
               , tmp.Unit_count
               , tmp.Summ_min_1
               , tmp.Summ_max_1
               , tmp.Unit_count_1
               , tmp.Summ_str
               , tmp.UnitName_str
               , tmp.Amount_res
               , tmp.Summ_res
          FROM lpInsert_Movement_Send_RemainsSun_express22 (inOperDate := inOperDate   
                                                        , inDriverId := 0 -- vbDriverId_1
                                                        , inStep     := 1
                                                        , inUserId   := vbUserId
                                                         ) AS tmp
          WHERE COALESCE (tmp.GoodsId, 0) = inGoodsId OR COALESCE (inGoodsId, 0) = 0
         ;
     -- !!!1 - перенесли данные
     INSERT INTO _tmpUnit_SUN_a SELECT * FROM _tmpUnit_SUN;
     -- 1. все остатки, НТЗ => получаем кол-ва автозаказа
     INSERT INTO _tmpRemains_all_a SELECT * FROM _tmpRemains_all;
     INSERT INTO _tmpRemains_a     SELECT * FROM _tmpRemains;
     -- 2. вся статистика продаж
     INSERT INTO _tmpSale_express_a SELECT * FROM _tmpSale_express;
     -- 3.2. остатки, СРОК - для распределения
     INSERT INTO _tmpRemains_Partion_a SELECT * FROM _tmpRemains_Partion;
     -- 5. из каких аптек остатки со сроками "полностью" закрывают АВТОЗАКАЗ
     INSERT INTO _tmpSumm_limit_a SELECT * FROM _tmpSumm_limit;
     -- 6.1. распределяем-1 остатки со сроками - по всем аптекам - здесь только >= vbSumm_limit
     INSERT INTO _tmpResult_Partion_a SELECT * FROM _tmpResult_Partion;



     IF EXISTS (SELECT COUNT(*) FROM _tmpResult_Partion_a AS tmpRes GROUP BY tmpRes.UnitId_from, tmpRes.UnitId_to, tmpRes.GoodsId HAVING COUNT(*) > 1)
        AND 1=1
     THEN
         RAISE EXCEPTION 'Ошибка.Дублируется товар: % %(%) % %(%) % %(%)'
                       , CHR (13)
                       , lfGet_Object_ValueData_sh ((SELECT tmpRes.UnitId_from FROM _tmpResult_Partion_a AS tmpRes GROUP BY tmpRes.UnitId_from, tmpRes.UnitId_to, tmpRes.GoodsId HAVING COUNT(*) > 1 ORDER BY tmpRes.UnitId_from, tmpRes.UnitId_to, tmpRes.GoodsId LIMIT 1))
                       ,                            (SELECT tmpRes.UnitId_from FROM _tmpResult_Partion_a AS tmpRes GROUP BY tmpRes.UnitId_from, tmpRes.UnitId_to, tmpRes.GoodsId HAVING COUNT(*) > 1 ORDER BY tmpRes.UnitId_from, tmpRes.UnitId_to, tmpRes.GoodsId LIMIT 1)
                       , CHR (13)
                       , lfGet_Object_ValueData_sh ((SELECT tmpRes.UnitId_to   FROM _tmpResult_Partion_a AS tmpRes GROUP BY tmpRes.UnitId_from, tmpRes.UnitId_to, tmpRes.GoodsId HAVING COUNT(*) > 1 ORDER BY tmpRes.UnitId_from, tmpRes.UnitId_to, tmpRes.GoodsId LIMIT 1))
                       ,                            (SELECT tmpRes.UnitId_to   FROM _tmpResult_Partion_a AS tmpRes GROUP BY tmpRes.UnitId_from, tmpRes.UnitId_to, tmpRes.GoodsId HAVING COUNT(*) > 1 ORDER BY tmpRes.UnitId_from, tmpRes.UnitId_to, tmpRes.GoodsId LIMIT 1)
                       , CHR (13)
                       , lfGet_Object_ValueData    ((SELECT tmpRes.GoodsId     FROM _tmpResult_Partion_a AS tmpRes GROUP BY tmpRes.UnitId_from, tmpRes.UnitId_to, tmpRes.GoodsId HAVING COUNT(*) > 1 ORDER BY tmpRes.UnitId_from, tmpRes.UnitId_to, tmpRes.GoodsId LIMIT 1))
                       ,                            (SELECT tmpRes.GoodsId     FROM _tmpResult_Partion_a AS tmpRes GROUP BY tmpRes.UnitId_from, tmpRes.UnitId_to, tmpRes.GoodsId HAVING COUNT(*) > 1 ORDER BY tmpRes.UnitId_from, tmpRes.UnitId_to, tmpRes.GoodsId LIMIT 1)
                        ;
     END IF;


     -- получаем данные по перемещению
     CREATE TEMP TABLE _tmpSend (UnitId_from Integer, UnitId_to Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;
     INSERT INTO _tmpSend (UnitId_from, UnitId_to, GoodsId, Amount)
           SELECT MovementLinkObject_From.ObjectId AS UnitId_from
                , MovementLinkObject_To.ObjectId   AS UnitId_to
                , MovementItem.ObjectId            AS GoodsId
                , SUM (MovementItem.Amount)        AS Amount
           FROM Movement AS Movement_Send
                 INNER JOIN MovementBoolean AS MovementBoolean_SUN_v3
                                            ON MovementBoolean_SUN_v3.MovementId = Movement_Send.Id
                                           AND MovementBoolean_SUN_v3.DescId = zc_MovementBoolean_SUN_v3()
                                           AND MovementBoolean_SUN_v3.ValueData = TRUE
     
                 LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                              ON MovementLinkObject_From.MovementId = Movement_Send.Id
                                             AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                 
                 LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                              ON MovementLinkObject_To.MovementId = Movement_Send.Id
                                             AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                 
                 INNER JOIN MovementItem ON MovementItem.MovementId = Movement_Send.Id
                                        AND MovementItem.DescId     = zc_MI_Master()
                                        AND MovementItem.isErased   = FALSE
                                        AND (MovementItem.ObjectId = inGoodsId OR inGoodsId =0)
     
           WHERE Movement_Send.DescId = zc_Movement_Send()
             AND Movement_Send.StatusId <> zc_Enum_Status_Erased()
             AND Movement_Send.OperDate > inOperDate - INTERVAL '1 DAY'
           GROUP BY MovementLinkObject_From.ObjectId
                  , MovementLinkObject_To.ObjectId
                  , MovementItem.ObjectId
      ;



     OPEN Cursor1 FOR
          SELECT Object_Unit.Id            AS UnitId
               , Object_Unit.ValueData     AS UnitName
               , _tmpRemains.GoodsId

                 -- Статистика за Х*24 часов в точке Отправителя
               , _tmpRemains.Amount_sale
               , _tmpRemains.Summ_sale

                 -- Остаток без корректировки
               , _tmpRemains.AmountRemains
                 -- Остаток - для расчета "кол-во для распределения"
               , _tmpRemains.AmountRemains_calc_out AS AmountRemains_calc
                 -- Остаток - расчет "после" всех оперций
               , _tmpRemains.AmountRemains_calc_in  AS AmountRemains_calc_all

                 -- Приход (ожидаемый)--инф
               , _tmpRemains.AmountIncome
                 -- Перемещение - приход (ожидается)--инф
               , _tmpRemains.AmountSend_in
                 -- Перемещение - расход (ожидается)--инф
               , _tmpRemains.AmountSend_out
                 -- Заказ (ожидаемый)--инф
               , _tmpRemains.AmountOrderExternal
                 -- Резерв по чекам + не проведенные с CommentError--инф
               , _tmpRemains.AmountReserve

               , _tmpRemains.Price
               , _tmpRemains.MCS
               
               , _tmpRemains.AmountResult_in                     AS Amount_res
               , _tmpRemains.AmountResult_in * _tmpRemains.Price AS Summ_res
               
               , COALESCE (_tmpRemains.AmountResult_in, 0) - COALESCE (_tmpRemains.AmountSend_in, 0) AS AmountNeed  -- потребность
          FROM _tmpRemains_all_a AS _tmpRemains
              LEFT JOIN Object AS Object_Unit ON Object_Unit.Id  = _tmpRemains.UnitId
              
          WHERE (COALESCE (_tmpRemains.GoodsId, 0) = inGoodsId OR COALESCE (inGoodsId, 0) = 0)
--          AND COALESCE (_tmpRemains.AmountResult_in,0) > 0
         ;
     RETURN NEXT Cursor1;


/*
 (UnitId, GoodsId, Price, MCS, Amount_sale, Summ_sale
, AmountResult_in, AmountResult_out
, AmountRemains, AmountRemains_calc_in, AmountRemains_calc_out
, AmountIncome, AmountSend_in, AmountSend_out, AmountOrderExternal, AmountReserve)

*/
     OPEN Cursor2 FOR
          SELECT 
             --, tmp.UnitId_to
             --, tmp.UnitId_from
             --, tmp.GoodsId
                 Object_UnitFrom.Id        AS UnitId_from
               , Object_UnitFrom.ValueData AS FromName
               , _tmpRemains.GoodsId
               , Object_Goods.ObjectCode   AS GoodsCode
               , Object_Goods.ValueData    AS GoodsName

                 -- Итого кол-во для распределения в точке Отправителя
               , tmp_sum.AmountResult AS AmountSun_summ

                 -- Статистика за Х*24 часов в точке Отправителя
               , _tmpRemains.Amount_sale
               , _tmpRemains.Summ_sale

                 -- Остаток без корректировки
               , _tmpRemains.AmountRemains
                 -- Остаток - для расчета "кол-во для распределения"
               , _tmpRemains.AmountRemains_calc_out AS AmountRemains_calc
                 -- Остаток - расчет "после" всех оперций
               , _tmpRemains.AmountRemains_calc_in  AS AmountRemains_calc_all

                 -- Приход (ожидаемый)--инф
               , _tmpRemains.AmountIncome
                 -- Перемещение - приход (ожидается)--инф
               , _tmpRemains.AmountSend_in
                 -- Перемещение - расход (ожидается)--инф
               , _tmpRemains.AmountSend_out
                 -- Заказ (ожидаемый)--инф
               , _tmpRemains.AmountOrderExternal
                 -- Резерв по чекам + не проведенные с CommentError--инф
               , _tmpRemains.AmountReserve

               , _tmpRemains.Price
               , _tmpRemains.MCS

                 -- Результат - Кол-во распределено - перемещение расход
               , _tmpRemains.AmountResult_out    AS Amount_res
               , _tmpRemains.AmountResult_out * _tmpRemains.Price AS Summ_res
               -- факт. излишек после перемещения
               , COALESCE (_tmpRemains.AmountResult_out,0) - COALESCE (_tmpRemains.AmountSend_out,0)   AS AmountExcess   --избыток
          FROM _tmpRemains_all AS _tmpRemains
               LEFT JOIN Object AS Object_UnitFrom  ON Object_UnitFrom.Id  = _tmpRemains.UnitId
               LEFT JOIN  Object AS Object_Goods ON Object_Goods.Id  = _tmpRemains.GoodsId

               -- Итого кол-во для распределения по точкам отправителям
               INNER JOIN (SELECT _tmpRemains_all_a.UnitId, _tmpRemains_all_a.GoodsId
                                , SUM (_tmpRemains_all_a.AmountResult_in) AS AmountResult
                          FROM _tmpRemains_all_a
                          GROUP BY _tmpRemains_all_a.UnitId, _tmpRemains_all_a.GoodsId
                         ) AS tmp_sum ON tmp_sum.UnitId  = _tmpRemains.UnitId
                                     AND tmp_sum.GoodsId = _tmpRemains.GoodsId
               
          WHERE COALESCE (_tmpRemains.AmountResult_out,0) > 0
          AND (COALESCE (_tmpRemains.GoodsId, 0) = inGoodsId OR COALESCE (inGoodsId, 0) = 0)
               
           ;
     RETURN NEXT Cursor2;
     
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.04.20         *
*/

-- тест
-- SELECT * FROM gpReport_Movement_Send_RemainsSun_express_v2 (inOperDate:= CURRENT_DATE + INTERVAL '3 DAY', inGoodsId:= 0, inSession:= '3'); -- FETCH ALL "<unnamed portal 1>";
