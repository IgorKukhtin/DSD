-- Function: gpReport_Movement_Send_RemainsSun()

DROP FUNCTION IF EXISTS gpReport_Movement_Send_RemainsSun (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Movement_Send_RemainsSun(
    IN inOperDate      TDateTime,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
  DECLARE Cursor1 refcursor;
  DECLARE Cursor2 refcursor;
  DECLARE Cursor3 refcursor;
  DECLARE Cursor4 refcursor;
  DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId:= lpGetUserBySession (inSession);
    vbUserId := inSession;


     -- все Подразделения для схемы SUN
     CREATE TEMP TABLE _tmpUnit_SUN (UnitId Integer) ON COMMIT DROP;

     -- 1. все остатки, НТЗ => получаем кол-ва автозаказа
     CREATE TEMP TABLE _tmpRemains_all (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, AmountResult TFloat, AmountRemains TFloat, AmountIncome TFloat, AmountSend TFloat, AmountOrderExternal TFloat, AmountReserve TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpRemains (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, AmountResult TFloat, AmountRemains TFloat, AmountIncome TFloat, AmountSend TFloat, AmountOrderExternal TFloat, AmountReserve TFloat) ON COMMIT DROP;

     -- 2. вся статистика продаж
     CREATE TEMP TABLE _tmpSale (UnitId Integer, GoodsId Integer, Amount TFloat, Summ TFloat) ON COMMIT DROP;

     -- 3.1. все остатки, СРОК
     CREATE TEMP TABLE _tmpRemains_Partion_all (ContainerDescId Integer, UnitId Integer, ContainerId_Parent Integer, ContainerId Integer, GoodsId Integer, Amount TFloat, PartionDateKindId Integer, ExpirationDate TDateTime, Amount_sun TFloat, Amount_notSold TFloat) ON COMMIT DROP;
     -- 3.2. остатки, СРОК - для распределения
     CREATE TEMP TABLE _tmpRemains_Partion (ContainerDescId Integer, UnitId Integer, GoodsId Integer, MCSValue TFloat, Amount_sale TFloat, Amount TFloat, Amount_save TFloat, Amount_real TFloat, Amount_sun TFloat, Amount_notSold TFloat) ON COMMIT DROP;


     -- 4. Остатки по которым есть Автозаказ и срок
     CREATE TEMP TABLE _tmpRemains_calc (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, AmountResult TFloat, AmountRemains TFloat, AmountIncome TFloat, AmountSend TFloat, AmountOrderExternal TFloat, AmountReserve TFloat, AmountSun_real TFloat, AmountSun_summ TFloat, AmountSun_summ_save TFloat, AmountSun_unit TFloat, AmountSun_unit_save TFloat) ON COMMIT DROP;

     -- 5. из каких аптек остатки со сроками "полностью" закрывают АВТОЗАКАЗ
     CREATE TEMP TABLE _tmpSumm_limit (UnitId_from Integer, UnitId_to Integer, Summ TFloat) ON COMMIT DROP;

     -- 6.1. распределяем-1 остатки со сроками - по всем аптекам - здесь только >= vbSumm_limit
     CREATE TEMP TABLE _tmpResult_Partion (UnitId_from Integer, UnitId_to Integer, GoodsId Integer, Amount TFloat, Summ TFloat, Amount_next TFloat, Summ_next TFloat, MovementId Integer, MovementItemId Integer) ON COMMIT DROP;
     -- 6.2. !!!товары - DefSUN - если 2 дня есть в перемещении, т.к. < vbSumm_limit - тогда они участвовать не будут !!!
     CREATE TEMP TABLE _tmpList_DefSUN (UnitId_from Integer, UnitId_to Integer, GoodsId Integer) ON COMMIT DROP;

     -- 7.1. распределяем перемещения - по партиям со сроками
     CREATE TEMP TABLE _tmpResult_child (MovementId Integer, UnitId_from Integer, UnitId_to Integer, ParentId Integer, ContainerId Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;

     -- Результат
     CREATE TEMP TABLE _tmpResult (UnitId Integer, UnitName TVarChar
                                 , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
                                 , Amount_sale         TFloat --
                                 , Summ_sale           TFloat --
                                 , AmountSun_real      TFloat -- сумма сроковых по реальным остаткам, должно сходиться с AmountSun_summ_save
                                 , AmountSun_summ_save TFloat -- сумма сроковых, без учета изменения
                                 , AmountSun_summ      TFloat -- сумма сроковых + notSold, которые будем распределять
                                 , AmountSunOnly_summ  TFloat -- сумма сроковых, которые будем распределять
                                 , Amount_notSold_summ TFloat -- сумма notSold, которые будем распределять
                                 , AmountResult        TFloat -- Автозаказ
                                 , AmountResult_summ   TFloat -- итого Автозаказ по всем Аптекам
                                 , AmountRemains       TFloat -- Остаток
                                 , AmountIncome        TFloat -- Приход (ожидаемый)
                                 , AmountSend          TFloat -- Перемещение (ожидается)
                                 , AmountOrderExternal TFloat -- Заказ (ожидаемый)
                                 , AmountReserve       TFloat -- Резерв по чекам
                                 , AmountSun_unit      TFloat -- инф.=0, сроковые на этой аптеке, тогда перемещения с других аптек не будет, т.е. этот Автозаказ не учитываем
                                 , AmountSun_unit_save TFloat -- инф.=0, сроковые на этой аптеке, без учета изменения
                                 , Price               TFloat -- Цена
                                 , MCS                 TFloat -- НТЗ
                                 , Summ_min            TFloat -- информативно - мнимальн сумма
                                 , Summ_max            TFloat -- информативно - максимальн сумма
                                 , Unit_count          TFloat -- информативно - кол-во таких накл.
                                 , Summ_min_1          TFloat -- информативно - после распределения-1: мнимальн сумма
                                 , Summ_max_1          TFloat -- информативно - после распределения-1: максимальн сумма
                                 , Unit_count_1        TFloat -- информативно - после распределения-1: кол-во таких накл.
                                 , Summ_min_2          TFloat -- информативно - после распределения-2: мнимальн сумма
                                 , Summ_max_2          TFloat -- информативно - после распределения-2: максимальн сумма
                                 , Unit_count_2        TFloat -- информативно - после распределения-2: кол-во таких накл.
                                 , Summ_str            TVarChar
                                 , Summ_next_str       TVarChar
                                 , UnitName_str        TVarChar
                                 , UnitName_next_str   TVarChar
                                   -- !!!результат!!!
                                 , Amount_res          TFloat
                                 , Summ_res            TFloat
                                 , Amount_next_res     TFloat
                                 , Summ_next_res       TFloat
                                 ) ON COMMIT DROP;

     INSERT INTO _tmpResult (UnitId, UnitName
                           , GoodsId, GoodsCode, GoodsName
                           , Amount_sale
                           , Summ_sale
                           , AmountSun_real
                           , AmountSun_summ_save
                           , AmountSun_summ
                           , AmountSunOnly_summ
                           , Amount_notSold_summ
                           , AmountResult
                           , AmountResult_summ
                           , AmountRemains
                           , AmountIncome
                           , AmountSend
                           , AmountOrderExternal
                           , AmountReserve
                           , AmountSun_unit
                           , AmountSun_unit_save
                           , Price
                           , MCS
                           , Summ_min
                           , Summ_max
                           , Unit_count
                           , Summ_min_1
                           , Summ_max_1
                           , Unit_count_1
                           , Summ_min_2
                           , Summ_max_2
                           , Unit_count_2
                           , Summ_str
                           , Summ_next_str
                           , UnitName_str
                           , UnitName_next_str
                           , Amount_res
                           , Summ_res
                           , Amount_next_res
                           , Summ_next_res
                            )
          SELECT COALESCE (tmp.UnitId, 0)      :: Integer  AS UnitId
               , COALESCE (tmp.UnitName, '')   :: TVarChar AS UnitName
               , COALESCE (tmp.GoodsId, 0)     :: Integer  AS GoodsId
               , COALESCE (tmp.GoodsCode, 0)   :: Integer  AS GoodsCode
               , COALESCE (tmp.GoodsName, '')  :: TVarChar AS GoodsName
               , tmp.Amount_sale
               , tmp.Summ_sale
               , tmp.AmountSun_real
               , tmp.AmountSun_summ_save
               , tmp.AmountSun_summ
               , tmp.AmountSunOnly_summ
               , tmp.Amount_notSold_summ
               , COALESCE (tmp.AmountResult, 0)   :: TFloat AS AmountResult
               , tmp.AmountResult_summ
               , COALESCE (tmp.AmountRemains, 0) :: TFloat AS AmountRemains
               , COALESCE (tmp.AmountIncome, 0)   :: TFloat AS AmountIncome
               , COALESCE (tmp.AmountSend, 0)       :: TFloat AS AmountSend
               , COALESCE (tmp.AmountOrderExternal, 0) :: TFloat AS AmountOrderExternal
               , COALESCE (tmp.AmountReserve, 0) :: TFloat AS AmountReserve
               , tmp.AmountSun_unit
               , tmp.AmountSun_unit_save
               , COALESCE (tmp.Price, 0) :: TFloat AS Price
               , COALESCE (tmp.MCS, 0)     :: TFloat AS MCS
               , tmp.Summ_min
               , tmp.Summ_max
               , tmp.Unit_count
               , tmp.Summ_min_1
               , tmp.Summ_max_1
               , tmp.Unit_count_1
               , tmp.Summ_min_2
               , tmp.Summ_max_2
               , tmp.Unit_count_2
               , tmp.Summ_str
               , tmp.Summ_next_str
               , tmp.UnitName_str
               , tmp.UnitName_next_str
               , tmp.Amount_res
               , tmp.Summ_res
               , tmp.Amount_next_res
               , tmp.Summ_next_res
          FROM lpInsert_Movement_Send_RemainsSun (inOperDate := inOperDate
                                                , inStep     := 1
                                                , inUserId   := vbUserId
                                                 ) AS tmp
         ;
      -- добавили ВСЕ остатки
     /*INSERT INTO _tmpResult (UnitId, UnitName
                           , GoodsId, GoodsCode, GoodsName
                           , Amount_sale
                           , Summ_sale
                           , AmountSun_real
                           , AmountSun_summ_save
                           , AmountSun_summ
                           , AmountSunOnly_summ
                           , Amount_notSold_summ
                           , AmountResult
                           , AmountResult_summ
                           , AmountRemains
                           , AmountIncome
                           , AmountSend
                           , AmountOrderExternal
                           , AmountReserve
                           , AmountSun_unit
                           , AmountSun_unit_save
                           , Price
                           , MCS
                           , Summ_min
                           , Summ_max
                           , Unit_count
                           , Summ_min_1
                           , Summ_max_1
                           , Unit_count_1
                           , Summ_min_2
                           , Summ_max_2
                           , Unit_count_2
                           , Summ_str
                           , Summ_next_str
                           , UnitName_str
                           , UnitName_next_str
                           , Amount_res
                           , Summ_res
                           , Amount_next_res
                           , Summ_next_res
                            )
          SELECT COALESCE (tmp.UnitId, _tmpRemains_all.UnitId)     :: Integer  AS UnitId
               , COALESCE (tmp.UnitName, Object_Unit.ValueData)    :: TVarChar AS UnitName
               , COALESCE (tmp.GoodsId, _tmpRemains_all.GoodsId)   :: Integer  AS GoodsId
               , COALESCE (tmp.GoodsCode, Object_Goods.ObjectCode) :: Integer  AS GoodsCode
               , COALESCE (tmp.GoodsName, Object_Goods.ValueData)  :: TVarChar AS GoodsName
               , tmp.Amount_sale
               , tmp.Summ_sale
               , tmp.AmountSun_real
               , tmp.AmountSun_summ_save
               , tmp.AmountSun_summ
               , tmp.AmountSunOnly_summ
               , tmp.Amount_notSold_summ
               , COALESCE (tmp.AmountResult, _tmpRemains_all.AmountResult)   :: TFloat AS AmountResult
               , tmp.AmountResult_summ
               , COALESCE (tmp.AmountRemains, _tmpRemains_all.AmountRemains) :: TFloat AS AmountRemains
               , COALESCE (tmp.AmountIncome, _tmpRemains_all.AmountIncome)   :: TFloat AS AmountIncome
               , COALESCE (tmp.AmountSend, _tmpRemains_all.AmountSend)       :: TFloat AS AmountSend
               , COALESCE (tmp.AmountOrderExternal, _tmpRemains_all.AmountOrderExternal) :: TFloat AS AmountOrderExternal
               , COALESCE (tmp.AmountReserve, _tmpRemains_all.AmountReserve) :: TFloat AS AmountReserve
               , tmp.AmountSun_unit
               , tmp.AmountSun_unit_save
               , COALESCE (tmp.Price, _tmpRemains_all.Price) :: TFloat AS Price
               , COALESCE (tmp.MCS, _tmpRemains_all.MCS)     :: TFloat AS MCS
               , tmp.Summ_min
               , tmp.Summ_max
               , tmp.Unit_count
               , tmp.Summ_min_1
               , tmp.Summ_max_1
               , tmp.Unit_count_1
               , tmp.Summ_min_2
               , tmp.Summ_max_2
               , tmp.Unit_count_2
               , tmp.Summ_str
               , tmp.Summ_next_str
               , tmp.UnitName_str
               , tmp.UnitName_next_str
               , tmp.Amount_res
               , tmp.Summ_res
               , tmp.Amount_next_res
               , tmp.Summ_next_res
          FROM _tmpRemains_all
               LEFT JOIN _tmpResult AS tmp
                                    ON tmp.UnitId  = _tmpRemains_all.UnitId
                                   AND tmp.GoodsId = _tmpRemains_all.GoodsId
               LEFT JOIN Object AS Object_Unit  ON Object_Unit.Id  = _tmpRemains_all.UnitId
               LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = _tmpRemains_all.GoodsId
          WHERE tmp.GoodsId IS NULL;
          */

     OPEN Cursor1 FOR
          SELECT *
          FROM _tmpResult AS tmp;
     RETURN NEXT Cursor1;

     OPEN Cursor2 FOR
          SELECT tmp.*
               , tmp.UnitId_from
               , Object_UnitFrom.ValueData AS FromName
               , tmp.UnitId_to
               , Object_UnitTo.ValueData   AS ToName
                 -- сумма сроковых, без учета изменения
               , tmpRemains_Partion_sum.AmountSun_summ_save
                 -- сумма сроковых + notSold, которые будем распределять
               , tmpRemains_Partion_sum.AmountSun_summ
                 -- сумма только сроковых, которые будем распределять
               , tmpRemains_Partion_sum.AmountSunOnly_summ
                 -- сумма только notSold, которые будем распределять
               , tmpRemains_Partion_sum.Amount_notSold_summ
                 --
               , tmpRemains_Partion_sum.Amount_sale
               , tmpRemains_Partion_sum.MCSValue AS MCS
               , _tmpRemains.AmountResult
               , _tmpRemains.AmountRemains
               , _tmpRemains.Price
          FROM _tmpResult_Partion AS tmp
               LEFT JOIN Object AS Object_UnitFrom  ON Object_UnitFrom.Id  = tmp.UnitId_from
               LEFT JOIN Object AS Object_UnitTo  ON Object_UnitTo.Id  = tmp.UnitId_to
               -- итого сроковые + notSold которые будем распределять
               LEFT JOIN (SELECT _tmpRemains_Partion.UnitId, _tmpRemains_Partion.GoodsId, _tmpRemains_Partion.MCSValue, _tmpRemains_Partion.Amount_sale
                                , SUM (_tmpRemains_Partion.Amount_save)    AS AmountSun_summ_save
                                , SUM (_tmpRemains_Partion.Amount)         AS AmountSun_summ
                                , SUM (_tmpRemains_Partion.Amount_sun)     AS AmountSunOnly_summ
                                , SUM (_tmpRemains_Partion.Amount_notSold) AS Amount_notSold_summ
                          FROM _tmpRemains_Partion
                          GROUP BY _tmpRemains_Partion.UnitId, _tmpRemains_Partion.GoodsId, _tmpRemains_Partion.MCSValue, _tmpRemains_Partion.Amount_sale
                         ) AS tmpRemains_Partion_sum ON tmpRemains_Partion_sum.UnitId  = tmp.UnitId_from
                                                    AND tmpRemains_Partion_sum.GoodsId = tmp.GoodsId
               -- все остатки, НТЗ
               LEFT JOIN _tmpRemains_all AS _tmpRemains
                                         ON _tmpRemains.UnitId  = tmp.UnitId_from
                                        AND _tmpRemains.GoodsId = tmp.GoodsId
               
          ;
     RETURN NEXT Cursor2;

     OPEN Cursor3 FOR
          SELECT tmp.*
               , tmp.UnitId_from
               , Object_UnitFrom.ValueData     AS FromName
               , tmp.UnitId_to
               , Object_UnitTo.ValueData       AS ToName
               , Movement_Income.Id            AS MovementId
               , Movement_Income.OperDate      AS OperDate
               , Movement_Income.Invnumber     AS Invnumber
               , tmp.ContainerId
               , tmp.MovementId
               , COALESCE (MIDate_ExpirationDate_in.ValueData, zc_DateEnd())  AS ExpirationDate_in


          FROM _tmpResult_child AS tmp
          LEFT JOIN Object AS Object_UnitFrom ON Object_UnitFrom.Id = tmp.UnitId_from
          LEFT JOIN Object AS Object_UnitTo   ON Object_UnitTo.Id   = tmp.UnitId_to
          LEFT JOIN Movement ON Movement.Id  = tmp.MovementId

          -- находим срок годности из прихода
          LEFT JOIN ContainerlinkObject AS CLO_PartionMovementItem
                                        ON CLO_PartionMovementItem.ContainerId = tmp.ContainerId
                                       AND CLO_PartionMovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
          LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLO_PartionMovementItem.ObjectId
          -- элемент прихода
          LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
          -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
          LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                      ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                     AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
          -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
          LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)

          LEFT OUTER JOIN MovementItemDate  AS MIDate_ExpirationDate_in
                                            ON MIDate_ExpirationDate_in.MovementItemId = COALESCE (MI_Income_find.Id,MI_Income.Id)  --Object_PartionMovementItem.ObjectCode
                                           AND MIDate_ExpirationDate_in.DescId = zc_MIDate_PartionGoods()

          LEFT JOIN Movement AS Movement_Income ON Movement_Income.Id = COALESCE (MI_Income_find.MovementId,MI_Income.MovementId)
          ;
     RETURN NEXT Cursor3;

     OPEN Cursor4 FOR
          SELECT Object_Goods.Id           AS GoodsId
               , Object_Goods.ObjectCode   AS GoodsCode
               , Object_Goods.ValueData    AS GoodsName
               , Object_UnitFrom.Id        AS FrimId
               , Object_UnitFrom.ValueData AS FromName
               , Object_UnitTo.Id          AS ToId
               , Object_UnitTo.ValueData   AS ToName
          FROM _tmpList_DefSUN AS tmp
          LEFT JOIN Object AS Object_UnitFrom ON Object_UnitFrom.Id = tmp.UnitId_from
          LEFT JOIN Object AS Object_UnitTo   ON Object_UnitTo.Id   = tmp.UnitId_to
          LEFT JOIN Object AS Object_Goods    ON Object_Goods.Id    = tmp.GoodsId
          ;
     RETURN NEXT Cursor4;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.08.19         *
*/

-- тест
-- FETCH ALL "<unnamed portal 1>";