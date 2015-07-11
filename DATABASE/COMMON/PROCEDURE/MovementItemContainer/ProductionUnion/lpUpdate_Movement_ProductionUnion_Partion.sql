-- Function: lpUpdate_Movement_ProductionUnion_Partion (TDateTime, TDateTime, Integer, Integer, Integer)

DROP FUNCTION IF EXISTS lpUpdate_Movement_ProductionUnion_Partion (TDateTime, TDateTime, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_Movement_ProductionUnion_Partion(
    IN inStartDate    TDateTime , --
    IN inEndDate      TDateTime , --
    IN inFromId       Integer,    -- 
    IN inToId         Integer,    -- 
    IN inUserId       Integer     -- Пользователь
)                              
RETURNS TABLE (MovementItemId_gp Integer, MovementItemId_out Integer, ContainerId Integer
             , OperCount TFloat, OperCount_GP TFloat, OperCount_PF_out TFloat, OperCount_PF_in TFloat
             , isPartionClose Boolean, PartionGoodsDate Date, PartionGoodsDateClose Date)
AS
$BODY$
BEGIN

     -- таблица - Приходы ГП с пр-ва
     CREATE TEMP TABLE _tmpItem_GP (MovementId Integer, MovementItemId_gp Integer, GoodsId Integer, OperCount TFloat) ON COMMIT DROP;
     -- таблица - Расходы ПФ(ГП) на пр-во ГП (без этикетки)
     CREATE TEMP TABLE _tmpItem_PF (MovementId Integer, MovementItemId_gp Integer, MovementItemId_out Integer, ContainerId Integer, GoodsId Integer, PartionGoodsId Integer, TermProduction TFloat, OperCount TFloat) ON COMMIT DROP;
     -- таблица - найденные партии пр-ва ПФ(ГП)
     CREATE TEMP TABLE _tmpItem_PF_find (ContainerId Integer, MovementItemId_in Integer, OperCount TFloat, isPartionClose Boolean, PartionGoodsDate TDateTime, PartionGoodsDateClose TDateTime) ON COMMIT DROP;
     -- таблица - распределение пр-во ПФ(ГП) -> Приходы ГП
     CREATE TEMP TABLE _tmpItem_Result (MovementId Integer, MovementItemId_gp Integer, MovementItemId_out Integer, ContainerId Integer, GoodsId Integer, OperCount TFloat) ON COMMIT DROP;


     -- Приходы ГП с пр-ва
     INSERT INTO _tmpItem_GP (MovementId, MovementItemId_gp, GoodsId, OperCount)
             -- !!!Товары временно захардкодил: Ковбаси сирокопчені!!!
        WITH tmpGoodsCK AS (SELECT ObjectId AS GoodsId FROM ObjectLink WHERE ObjectLink.DescId = zc_ObjectLink_Goods_GoodsGroupAnalyst() AND ObjectLink.ChildObjectId = 340591)
        SELECT MIContainer.MovementId
             , MIContainer.MovementItemId           AS MovementItemId_gp
             , MIContainer.ObjectId_Analyzer        AS GoodsId
             , MIContainer.Amount                   AS OperCount
        FROM MovementItemContainer AS MIContainer
             LEFT JOIN tmpGoodsCK ON tmpGoodsCK.GoodsId = MIContainer.ObjectId_Analyzer
        WHERE MIContainer.OperDate BETWEEN inStartDate AND inEndDate
          AND MIContainer.MovementDescId         = zc_Movement_ProductionUnion()
          AND MIContainer.DescId                 = zc_MIContainer_Count()
          AND MIContainer.isActive               = TRUE
          AND MIContainer.AnalyzerId             = inFromId
          AND MIContainer.WhereObjectId_Analyzer = inToId
          AND tmpGoodsCK.GoodsId IS NULL
       ;

     -- Расходы ПФ(ГП) на пр-во (без этикетки)
     INSERT INTO _tmpItem_PF (MovementId, MovementItemId_gp, MovementItemId_out, ContainerId, GoodsId, PartionGoodsId, TermProduction, OperCount)
        WITH tmpMIGoods AS (-- Товары ГП: важное св-во TermProduction
                            SELECT tmp.GoodsId, COALESCE (ObjectFloat_TermProduction.ValueData, 0) AS TermProduction
                            FROM (SELECT _tmpItem_GP.GoodsId FROM _tmpItem_GP GROUP BY _tmpItem_GP.GoodsId) AS tmp
                                 LEFT JOIN ObjectLink AS ObjectLink_OrderType_Goods
                                                      ON ObjectLink_OrderType_Goods.ChildObjectId = tmp.GoodsId
                                                     AND ObjectLink_OrderType_Goods.DescId = zc_ObjectLink_OrderType_Goods()
                                 LEFT JOIN ObjectFloat AS ObjectFloat_TermProduction
                                                       ON ObjectFloat_TermProduction.ObjectId = ObjectLink_OrderType_Goods.ObjectId
                                                      AND ObjectFloat_TermProduction.DescId = zc_ObjectFloat_OrderType_TermProduction() 
                           )
        SELECT _tmpItem_GP.MovementId                  AS MovementId
             , _tmpItem_GP.MovementItemId_gp           AS MovementItemId_gp
             , MIContainer.MovementItemId              AS MovementItemId_out
             , MIContainer.ContainerId                 AS ContainerId
             , MIContainer.ObjectId_Analyzer           AS GoodsId
             , CLO_PartionGoods.ObjectId               AS PartionGoodsId
             , COALESCE (tmpMIGoods.TermProduction, 0) AS TermProduction
             , MIContainer.Amount                      AS OperCount      -- !!не используется, только для теста!!!
        FROM _tmpItem_GP
             INNER JOIN MovementItem ON MovementItem.MovementId = _tmpItem_GP.MovementId
                                    AND MovementItem.ParentId   = _tmpItem_GP.MovementItemId_gp
                                    AND MovementItem.DescId     = zc_MI_Child()
                                    AND MovementItem.isErased   = FALSE
             INNER JOIN MovementItemBoolean AS MIBoolean_isAuto
                                            ON MIBoolean_isAuto.MovementItemId = MovementItem.Id
                                           AND MIBoolean_isAuto.DescId     = zc_MIBoolean_isAuto()
                                           AND MIBoolean_isAuto.ValueData = TRUE -- !!! только если сформирован пользователем zc_Enum_Process_Auto_PartionDate!!!
             INNER JOIN MovementItemContainer AS MIContainer
                                              ON MIContainer.MovementId = _tmpItem_GP.MovementId
                                             AND MIContainer.MovementItemId = MovementItem.Id
                                             AND MIContainer.DescId = zc_MIContainer_Count()
             INNER JOIN ContainerLinkObject AS CLO_GoodsKind
                                            ON CLO_GoodsKind.ContainerId = MIContainer.ContainerId
                                           AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                                           AND CLO_GoodsKind.ObjectId = zc_GoodsKind_WorkProgress() -- !!!ПФ(ГП)!!!
             INNER JOIN ContainerLinkObject AS CLO_PartionGoods
                                            ON CLO_PartionGoods.ContainerId = MIContainer.ContainerId
                                           AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
             LEFT JOIN tmpMIGoods ON tmpMIGoods.GoodsId = _tmpItem_GP.GoodsId
       ;


     -- Производство + Остатки партий, их и будем распределять
     INSERT INTO _tmpItem_PF_find (ContainerId, MovementItemId_In, OperCount, isPartionClose, PartionGoodsDate, PartionGoodsDateClose)
       WITH tmpContainer_PF AS (-- Партии ПФ(ГП)
                                SELECT tmp.ContainerId
                                     , CASE WHEN (ObjectDate_PartionGoods_Value.ValueData + (COALESCE (tmp.TermProduction, 0) :: TVarChar || ' DAY') :: INTERVAL) <= inEndDate
                                                 THEN TRUE
                                            ELSE FALSE
                                       END AS isPartionClose
                                     , ObjectDate_PartionGoods_Value.ValueData AS PartionGoodsDate
                                     , ObjectDate_PartionGoods_Value.ValueData + (COALESCE (tmp.TermProduction, 0) :: TVarChar || ' DAY') :: INTERVAL AS PartionGoodsDateClose
                                FROM (-- Расходы ПФ(ГП) + !!!минимальный TermProduction!!! т.к. их может быть несколько
                                      SELECT _tmpItem_PF.ContainerId
                                           , _tmpItem_PF.PartionGoodsId
                                           , MIN (_tmpItem_PF.TermProduction) AS TermProduction
                                      FROM _tmpItem_PF
                                      GROUP BY _tmpItem_PF.ContainerId
                                             , _tmpItem_PF.PartionGoodsId
                                     ) AS tmp
                                     INNER JOIN ObjectDate AS ObjectDate_PartionGoods_Value
                                                           ON ObjectDate_PartionGoods_Value.ObjectId = tmp.PartionGoodsId
                                                          AND ObjectDate_PartionGoods_Value.DescId = zc_ObjectDate_PartionGoods_Value()
                                     LEFT JOIN ObjectLink AS ObjectLink_PartionGoods_Unit
                                                          ON ObjectLink_PartionGoods_Unit.ObjectId = tmp.PartionGoodsId
                                                         AND ObjectLink_PartionGoods_Unit.DescId = zc_ObjectLink_PartionGoods_Unit()
                                WHERE ObjectLink_PartionGoods_Unit.ObjectId IS NULL -- т.е. вообще нет этого св-ва
                               )
        -- результат - ВСЕ партии которые надо закрыть/открыть
        SELECT tmpContainer_PF.ContainerId
             , CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.isActive = TRUE AND MIContainer.MovementDescId = zc_Movement_ProductionUnion()
                         THEN MIContainer.MovementItemId -- нужен только для zc_Movement_ProductionUnion, т.к. надо закрыть по нему партию
                    ELSE 0
               END AS MovementItemId_In
             , SUM (CASE WHEN tmpContainer_PF.isPartionClose = FALSE
                              THEN 0
                         WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.isActive = TRUE AND MIContainer.MovementDescId = zc_Movement_ProductionUnion()
                              THEN MIContainer.Amount
                         WHEN MIContainer.OperDate < inStartDate
                              THEN MIContainer.Amount
                         ELSE 0
                    END) AS Amount
             , tmpContainer_PF.isPartionClose
             , tmpContainer_PF.PartionGoodsDate      -- информативно
             , tmpContainer_PF.PartionGoodsDateClose -- информативно
        FROM tmpContainer_PF
             INNER JOIN MovementItemContainer AS MIContainer ON MIContainer.ContainerId = tmpContainer_PF.ContainerId
        GROUP BY tmpContainer_PF.ContainerId
               , CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.isActive = TRUE AND MIContainer.MovementDescId = zc_Movement_ProductionUnion()
                           THEN MIContainer.MovementItemId
                      ELSE 0
                 END
               , tmpContainer_PF.isPartionClose
               , tmpContainer_PF.PartionGoodsDate
               , tmpContainer_PF.PartionGoodsDateClose
        HAVING SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.isActive = TRUE AND MIContainer.MovementDescId = zc_Movement_ProductionUnion()
                              THEN MIContainer.Amount
                         WHEN MIContainer.OperDate < inStartDate
                              THEN MIContainer.Amount
                         ELSE 0
                    END) <> 0
       ;

     -- распределение Производство + Остатки партий ИТОГ ПФ(ГП) -> _tmpItem_PF
     INSERT INTO _tmpItem_Result (MovementId, MovementItemId_gp, MovementItemId_out, ContainerId, GoodsId, OperCount)
        WITH tmp_All AS (-- Эементы Приход ГП с пр-ва + Расход ПФ(ГП) в одну строку, если не 1:1 будет !!!ошибка, надо исправить!!!
                         SELECT _tmpItem_PF.MovementId
                              , _tmpItem_PF.MovementItemId_gp
                              , _tmpItem_PF.MovementItemId_out
                              , _tmpItem_PF.ContainerId
                              , _tmpItem_PF.GoodsId
                                -- переводится в вес
                              , _tmpItem_GP.OperCount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS OperCount_Weight
                         FROM _tmpItem_PF
                              INNER JOIN _tmpItem_GP ON _tmpItem_GP.MovementItemId_gp = _tmpItem_PF.MovementItemId_gp
                              LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                   ON ObjectLink_Goods_Measure.ObjectId = _tmpItem_GP.GoodsId
                                                  AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                              LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                    ON ObjectFloat_Weight.ObjectId = _tmpItem_GP.GoodsId
                                                   AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                        )
        -- результат - распределение
        SELECT tmp_All.MovementId
             , tmp_All.MovementItemId_gp
             , tmp_All.MovementItemId_out
             , tmp_All.ContainerId
             , tmp_All.GoodsId
             , CASE WHEN tmp_All_sum.OperCount_Weight > 0 THEN tmpPF_find.OperCount * tmp_All.OperCount_Weight / tmp_All_sum.OperCount_Weight ELSE 0 END AS OperCount
        FROM tmp_All
             LEFT JOIN (-- Итог по Производство + Остатки партий ПФ(ГП) !!!если надо закрыть!!!
                        SELECT _tmpItem_PF_find.ContainerId, SUM (_tmpItem_PF_find.OperCount) AS OperCount FROM _tmpItem_PF_find WHERE _tmpItem_PF_find.isPartionClose = TRUE GROUP BY _tmpItem_PF_find.ContainerId
                       ) AS tmpPF_find ON tmpPF_find.ContainerId = tmp_All.ContainerId
             LEFT JOIN (-- Итог по Приход ГП с пр-ва
                        SELECT tmp_All.ContainerId, SUM (tmp_All.OperCount_Weight) AS OperCount_Weight FROM tmp_All GROUP BY tmp_All.ContainerId
                       ) AS tmp_All_sum ON tmp_All_sum.ContainerId = tmp_All.ContainerId
       ;

     -- если распределение было с погрешностью, копейки добавим в MAX (OperCount)
     UPDATE _tmpItem_Result SET OperCount = _tmpItem_Result.OperCount + tmp_sum2.OperCount - tmp_sum1.OperCount
     FROM (-- находится MovementItemId_out с MAX (OperCount)
           SELECT _tmpItem_Result.ContainerId, MAX (_tmpItem_Result.MovementItemId_out) AS MovementItemId_out
           FROM (SELECT _tmpItem_Result.ContainerId, MAX (_tmpItem_Result.OperCount) AS OperCount FROM _tmpItem_Result GROUP BY _tmpItem_Result.ContainerId) AS tmp
                INNER JOIN _tmpItem_Result ON _tmpItem_Result.ContainerId = tmp.ContainerId
                                          AND _tmpItem_Result.OperCount   = tmp.OperCount
           GROUP BY _tmpItem_Result.ContainerId
          ) AS tmp_find
          -- Итог - сколько получилось после распределения
          INNER JOIN (SELECT _tmpItem_Result.ContainerId, SUM (_tmpItem_Result.OperCount) AS OperCount
                      FROM _tmpItem_Result
                      GROUP BY _tmpItem_Result.ContainerId
                     ) AS tmp_sum1 ON tmp_sum1.ContainerId = tmp_find.ContainerId
          -- Итог - сколько для распределения !!!если надо закрыть!!!
          INNER JOIN (SELECT _tmpItem_PF_find.ContainerId, SUM (_tmpItem_PF_find.OperCount) AS OperCount FROM _tmpItem_PF_find WHERE _tmpItem_PF_find.isPartionClose = TRUE GROUP BY _tmpItem_PF_find.ContainerId
                     ) AS tmp_sum2 ON tmp_sum2.ContainerId = tmp_find.ContainerId
                                  AND tmp_sum2.OperCount  <> tmp_sum1.OperCount -- !!!т.е. два итога не равны!!!
     WHERE _tmpItem_Result.MovementItemId_out = tmp_find.MovementItemId_out;


     -- Провека - не должно быть < 0
     IF EXISTS (SELECT _tmpItem_Result.OperCount FROM _tmpItem_Result WHERE _tmpItem_Result.OperCount < 0)
     THEN
         RAISE EXCEPTION 'Ошибка. Кол-во после распределения не может быть < 0  <%> <%>', (SELECT _tmpItem_Result.MovementItemId_out FROM _tmpItem_Result WHERE _tmpItem_Result.OperCount < 0 ORDER BY _tmpItem_Result.MovementItemId_out LIMIT 1), (SELECT _tmpItem_Result.OperCount FROM _tmpItem_Result WHERE _tmpItem_Result.OperCount < 0 ORDER BY _tmpItem_Result.MovementItemId_out LIMIT 1);
     END IF;

    -- Результат
    RETURN QUERY
    select COALESCE (_tmpItem_Result.MovementItemId_gp, _tmpItem_GP.MovementItemId_gp) :: Integer AS MovementItemId_gp
        , _tmpItem_Result.MovementItemId_out, _tmpItem_Result.ContainerId
        , _tmpItem_Result.OperCount
        , _tmpItem_GP.OperCount      AS OperCount_gp
        , _tmpItem_PF.OperCount      AS OperCount_PF_out
        , _tmpItem_PF_find.OperCount AS OperCount_PF_in
        , _tmpItem_PF_find.isPartionClose
        , DATE (_tmpItem_PF_find.PartionGoodsDate)
        , DATE (_tmpItem_PF_find.PartionGoodsDateClose)
    from _tmpItem_Result
         left join _tmpItem_PF on _tmpItem_PF.MovementItemId_out = _tmpItem_Result.MovementItemId_out
         left join _tmpItem_GP on _tmpItem_GP.MovementItemId_gp = _tmpItem_Result.MovementItemId_gp
         left join _tmpItem_PF_find on _tmpItem_PF_find.ContainerId = _tmpItem_PF.ContainerId
    ;

     -- Сохраненние что партия закрыта/открыта ЕСЛИ OperCount > 0 !!!для всех _tmpItem_GP!!!
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionClose(), _tmpItem_GP.MovementItemId_gp, CASE WHEN tmp.OperCount > 0 THEN TRUE ELSE FALSE END)
     FROM _tmpItem_GP
          LEFT JOIN (SELECT _tmpItem_Result.MovementItemId_gp, SUM (_tmpItem_Result.OperCount) AS OperCount FROM _tmpItem_Result GROUP BY _tmpItem_Result.MovementItemId_gp
                    ) AS tmp ON tmp.MovementItemId_gp = _tmpItem_GP.MovementItemId_gp
    ;

     -- Сохраненние что партия закрыта/открыта ЕСЛИ OperCount > 0 !!!для всех _tmpItem_PF_find!!! после корректировок не все парти удастся открыть (надо будет доделать)
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionClose(), _tmpItem_PF_find.MovementItemId_in, CASE WHEN tmp.OperCount > 0 THEN TRUE ELSE FALSE END)
     FROM _tmpItem_PF_find
          LEFT JOIN (SELECT _tmpItem_Result.ContainerId, SUM (_tmpItem_Result.OperCount) AS OperCount FROM _tmpItem_Result GROUP BY _tmpItem_Result.ContainerId
                    ) AS tmp ON tmp.ContainerId = _tmpItem_PF_find.ContainerId
     WHERE _tmpItem_PF_find.MovementItemId_in > 0
    ;

     -- сохраняются элементы - расход на производство
     PERFORM lpInsertUpdate_MI_ProductionUnion_Child (ioId                  := _tmpItem_Result.MovementItemId_out
                                                    , inMovementId          := _tmpItem_Result.MovementId
                                                    , inGoodsId             := _tmpItem_Result.GoodsId
                                                    , inAmount              := _tmpItem_Result.OperCount
                                                    , inParentId            := _tmpItem_Result.MovementItemId_gp
                                                    , inPartionGoodsDate    := MIDate_PartionGoods.ValueData
                                                    , inPartionGoods        := NULL
                                                    , inGoodsKindId         := zc_GoodsKind_WorkProgress() -- !!!ПФ(ГП)!!!
                                                    , inCount_onCount       := COALESCE (MIFloat_Count.ValueData, 0)
                                                    , inUserId              := zc_Enum_Process_Auto_PartionClose()
                                                     )
     FROM _tmpItem_Result
          LEFT JOIN MovementItemFloat AS MIFloat_Count
                                      ON MIFloat_Count.MovementItemId = _tmpItem_Result.MovementItemId_gp
                                     AND MIFloat_Count.DescId = zc_MIFloat_Count()
          LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                     ON MIDate_PartionGoods.MovementItemId = _tmpItem_Result.MovementItemId_gp
                                    AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
     WHERE _tmpItem_Result.OperCount > 0;


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.07.15                                        *
*/

-- тест
-- SELECT * FROM lpUpdate_Movement_ProductionUnion_Partion (inStartDate:= '01.07.2015', inEndDate:= '01.07.2015', inFromId:=8448, inToId:=8458, inUserId:= zfCalc_UserAdmin() :: Integer) -- ЦЕХ деликатесов + Склад База ГП
-- SELECT * FROM lpUpdate_Movement_ProductionUnion_Partion (inStartDate:= '01.07.2015', inEndDate:= '01.07.2015', inFromId:=8447, inToId:=8458, inUserId:= zfCalc_UserAdmin() :: Integer) -- ЦЕХ колбасный   + Склад База ГП


-- тест
-- SELECT * FROM lpUpdate_Movement_ProductionUnion_Partion (inStartDate:= '01.07.2015', inEndDate:= '01.07.2015', inFromId:=8447, inToId:=8458, inUserId:= zfCalc_UserAdmin() :: Integer) -- ЦЕХ колбасный   + Склад База ГП
-- where ContainerId = 568111
-- order by 3
-- select * from MovementItemContainer where ContainerId = 568111