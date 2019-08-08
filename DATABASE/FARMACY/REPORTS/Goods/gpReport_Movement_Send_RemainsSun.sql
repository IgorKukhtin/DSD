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
  DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId:= lpGetUserBySession (inSession);
    vbUserId := inSession;


     -- все Подразделения для схемы SUN
     CREATE TEMP TABLE _tmpUnit_SUN (UnitId Integer) ON COMMIT DROP;

     -- 1. все остатки, НТЗ => получаем кол-ва автозаказа
     CREATE TEMP TABLE _tmpRemains (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, AmountResult TFloat, AmountRemains TFloat, AmountIncome TFloat, AmountSend TFloat, AmountOrderExternal TFloat, AmountReserve TFloat) ON COMMIT DROP;

     -- 2. вся статистика продаж
     CREATE TEMP TABLE _tmpSale (UnitId Integer, GoodsId Integer, Amount TFloat, Summ TFloat) ON COMMIT DROP;

     -- 3.1. все остатки, СРОК
     CREATE TEMP TABLE _tmpRemains_Partion_all (UnitId Integer, ContainerId_Parent Integer, ContainerId Integer, GoodsId Integer, Amount TFloat, PartionDateKindId Integer, ExpirationDate TDateTime) ON COMMIT DROP;
     -- 3.2. остатки, СРОК - для распределения
     CREATE TEMP TABLE _tmpRemains_Partion (UnitId Integer, GoodsId Integer, Amount TFloat, Amount_save TFloat, Amount_real TFloat) ON COMMIT DROP;


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
                                 , AmountSun_summ      TFloat -- сумма сроковых, которые будем распределять
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
                                 , UnitName_next_str   TVarChar) ON COMMIT DROP;
                                 
     INSERT INTO _tmpResult (UnitId, UnitName
                           , GoodsId, GoodsCode, GoodsName
                           , Amount_sale         
                           , Summ_sale           
                           , AmountSun_real      
                           , AmountSun_summ_save 
                           , AmountSun_summ      
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
                           , UnitName_next_str)
          SELECT *
          FROM lpInsert_Movement_Send_RemainsSun (inOperDate := inOperDate
                                                , inStep     := 1
                                                , inUserId   := vbUserId) AS tmp;

     

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
          FROM _tmpResult_Partion AS tmp
          LEFT JOIN Object AS Object_UnitFrom  ON Object_UnitFrom.Id  = tmp.UnitId_from
          LEFT JOIN Object AS Object_UnitTo  ON Object_UnitTo.Id  = tmp.UnitId_to
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