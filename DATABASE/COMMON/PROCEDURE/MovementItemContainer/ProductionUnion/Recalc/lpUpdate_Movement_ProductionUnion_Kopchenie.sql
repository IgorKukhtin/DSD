-- Function: lpUpdate_Movement_ProductionUnion_Kopchenie (Boolean, TDateTime, TDateTime, Integer, Integer)

DROP FUNCTION IF EXISTS lpUpdate_Movement_ProductionUnion_Kopchenie (Boolean, TDateTime, TDateTime, Integer, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_Movement_ProductionUnion_Kopchenie(
    IN inIsUpdate     Boolean   , --
    IN inStartDate    TDateTime , --
    IN inEndDate      TDateTime , --
    IN inUnitId       Integer,    -- 
    IN inUserId       Integer     -- Пользователь
)                              
RETURNS TABLE (MovementId Integer, OperDate TDateTime, InvNumber TVarChar, isDelete Boolean, MovementItemId_child Integer, MovementItemId_master Integer, ContainerId Integer
             , OperCount_child TFloat, OperCount_master TFloat
             , GoodsCode Integer, GoodsName TVarChar, GoodsKindName TVarChar
              )
AS
$BODY$
BEGIN
     IF inStartDate <> inEndDate
     THEN
         RAISE EXCEPTION 'Ошибка. Период должен быть за 1 день. <%>  <%>', inStartDate, inEndDate;

     ELSEIF DATE_TRUNC ('MONTH', inEndDate) = DATE_TRUNC ('MONTH', inEndDate + INTERVAL '1 DAY')
     THEN
         -- !!!Удаляем ВСЁ!!!
         PERFORM lpSetErased_Movement (inMovementId:= tmp.MovementId
                                     , inUserId    := inUserId)
         FROM (WITH -- существующие "пересортицы" для isAuto = TRUE
                    tmpMI_all AS (SELECT DISTINCT MIContainer.MovementId
                                  FROM MovementItemContainer AS MIContainer
                                       INNER JOIN MovementBoolean AS MovementBoolean_isAuto ON MovementBoolean_isAuto.MovementId = MIContainer.MovementId
                                                                                           AND MovementBoolean_isAuto.DescId     = zc_MovementBoolean_isAuto()
                                                                                           AND MovementBoolean_isAuto.ValueData  = TRUE
                                  WHERE MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                    AND MIContainer.DescId                 = zc_MIContainer_Count()
                                    AND MIContainer.WhereObjectId_Analyzer = inUnitId
                                    AND MIContainer.AnalyzerId             = inUnitId
                                    AND MIContainer.MovementDescId         = zc_Movement_ProductionUnion()
                                 )
               -- результат
               SELECT tmpMI_all.MovementId FROM tmpMI_all
              ) AS tmp;

         -- !!!Выход!!!
         RETURN;
     ELSE
         -- !!!Меняем период - на 1 месяц!!!
         inStartDate:= DATE_TRUNC ('MONTH', inEndDate);
     END IF;



     -- таблица - 
     CREATE TEMP TABLE _tmpResult (MovementId Integer, MovementItemId_child Integer, MovementItemId_master Integer, ContainerId Integer, OperCount_child TFloat, OperCount_master TFloat, isDelete Boolean) ON COMMIT DROP;

     -- данные по движению "Цех Копчения" + найденные MovementItemId
     INSERT INTO _tmpResult (MovementId, MovementItemId_child, MovementItemId_master, ContainerId, OperCount_child, OperCount_master, isDelete)
             WITH tmpMI AS (-- получаем движение
                            SELECT MIContainer.ContainerId, MIContainer.ObjectId_Analyzer AS GoodsId
                                   -- приход, он будет zc_MI_Child в zc_Movement_ProductionUnion
                                 , SUM (CASE WHEN MIContainer.isActive = TRUE  THEN MIContainer.Amount ELSE 0 END) AS OperCount_child
                                   -- расход, он будет zc_MI_Master в zc_Movement_ProductionUnion
                                 , SUM (CASE WHEN MIContainer.isActive = FALSE THEN -1 * MIContainer.Amount ELSE 0 END) AS OperCount_master
                            FROM MovementItemContainer AS MIContainer
                            WHERE MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                              AND MIContainer.DescId                 = zc_MIContainer_Count()
                              AND MIContainer.WhereObjectId_Analyzer = inUnitId
                              AND MIContainer.MovementDescId         = zc_Movement_Send()
                            GROUP BY MIContainer.ContainerId, MIContainer.ObjectId_Analyzer
                           )
           , tmpRemains AS (-- остатки
                            SELECT tmpMI.ContainerId
                                 , Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS Amount
                            FROM tmpMI
                                 INNER JOIN Container ON Container.Id = tmpMI.ContainerId
                                 LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.ContainerId = tmpMI.ContainerId
                                                                               AND MIContainer.OperDate >= inStartDate
                            WHERE tmpMI.OperCount_master <> 0
                            GROUP BY tmpMI.ContainerId, Container.Amount
                           )
            , tmpMI_all AS (-- существующие "пересортицы" где isAuto = TRUE - !!!за 1 День!!!
                            SELECT MIContainer.MovementId
                                 , MIContainer.ContainerId
                                 , MIContainer.MovementItemId
                                 , MIContainer.OperDate
                                 , MIContainer.isActive
                            FROM MovementItemContainer AS MIContainer
                                 INNER JOIN MovementBoolean AS MovementBoolean_isAuto ON MovementBoolean_isAuto.MovementId = MIContainer.MovementId
                                                                                     AND MovementBoolean_isAuto.DescId     = zc_MovementBoolean_isAuto()
                                                                                     AND MovementBoolean_isAuto.ValueData  = TRUE
                            -- WHERE MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                            WHERE MIContainer.OperDate               = inEndDate
                              AND MIContainer.DescId                 = zc_MIContainer_Count()
                              AND MIContainer.WhereObjectId_Analyzer = inUnitId
                              AND MIContainer.AnalyzerId             = inUnitId
                              AND MIContainer.MovementDescId         = zc_Movement_ProductionUnion()
                           )
          , tmpMovement AS (-- поиск одного документа за inEndDate
                            SELECT MAX (tmpMI_all.MovementId) AS MovementId
                            FROM tmpMI_all
                            WHERE tmpMI_all.OperDate = inEndDate
                           )
           , tmpMI_find AS (-- нужен только один из элементов (по нему будет Update, иначе Insert, остальные Delete)
                            SELECT tmpMI_all.ContainerId
                                 , MAX (tmpMI_all.MovementItemId) AS MovementItemId
                            FROM tmpMovement
                                 INNER JOIN tmpMI_all ON tmpMI_all.MovementId = tmpMovement.MovementId
                            WHERE tmpMI_all.isActive = FALSE
                            GROUP BY tmpMI_all.ContainerId
                           )
         , tmpMI_result AS (-- данные по движению "Цех Копчения"
                            SELECT COALESCE (MovementItem.MovementId, COALESCE (tmpMovement.MovementId, 0)) AS MovementId
                                 , COALESCE (MovementItem.ParentId, 0)   AS MovementItemId_master
                                 , COALESCE (MovementItem.Id, 0)         AS MovementItemId_child
                                 , tmpMI.ContainerId
                                 , tmpMI.OperCount_child + COALESCE (tmpRemains.Amount) AS OperCount_child -- !!!добавили остаток!!!
                                 , tmpMI.OperCount_master
                            FROM tmpMI
                                 LEFT JOIN tmpRemains ON tmpRemains.ContainerId = tmpMI.ContainerId
                                 LEFT JOIN tmpMI_find ON tmpMI_find.ContainerId = tmpMI.ContainerId
                                 LEFT JOIN MovementItem ON MovementItem.Id = tmpMI_find.MovementItemId
                                 LEFT JOIN tmpMovement ON 1 = 1
                            WHERE (tmpMI.OperCount_child + COALESCE (tmpRemains.Amount)) > 0 AND tmpMI.OperCount_master <> 0
                              AND tmpMI.OperCount_child <> tmpMI.OperCount_master
                           )
          , tmpMI_list AS (-- список найденных элементов
                            SELECT tmpMI_result.MovementId, 0                                  AS MovementItemId FROM tmpMI_result WHERE tmpMI_result.MovementId <> 0
                      UNION SELECT 0         AS MovementId, tmpMI_result.MovementItemId_master AS MovementItemId FROM tmpMI_result WHERE tmpMI_result.MovementItemId_master <> 0
                      UNION SELECT 0         AS MovementId, tmpMI_result.MovementItemId_child  AS MovementItemId FROM tmpMI_result WHERE tmpMI_result.MovementItemId_child <> 0
                           )
          -- Результат:
          -- движение "Цех Копчения"
          SELECT tmpMI_result.MovementId
               , tmpMI_result.MovementItemId_child
               , tmpMI_result.MovementItemId_master
               , tmpMI_result.ContainerId
               , tmpMI_result.OperCount_child
               , tmpMI_result.OperCount_master
               , FALSE AS isDelete
          FROM tmpMI_result
         UNION
          -- документы которые надо удалить
          SELECT tmpMI_all.MovementId
               , 0 AS MovementItemId_child
               , 0 AS MovementItemId_master
               , 0 AS ContainerId
               , 0 AS OperCount_child
               , 0 AS OperCount_master
               , TRUE AS isDelete
          FROM tmpMI_all
               LEFT JOIN tmpMI_list ON tmpMI_list.MovementId = tmpMI_all.MovementId
          WHERE tmpMI_list.MovementId IS NULL
         UNION
          -- элементы которые надо удалить
          SELECT tmpMI_all.MovementId     AS MovementId
               , tmpMI_all.MovementItemId AS MovementItemId_child -- !!!т.е. не в MovementItemId_master!!!
               , 0 AS MovementItemId_master
               , 0 AS ContainerId
               , 0 AS OperCount_child
               , 0 AS OperCount_master
               , TRUE AS isDelete
          FROM tmpMI_all
               LEFT JOIN tmpMI_list ON tmpMI_list.MovementItemId = tmpMI_all.MovementItemId
          WHERE tmpMI_list.MovementItemId IS NULL
         ;


     -- !!!не всегда!!!
     IF inIsUpdate = TRUE
     THEN

     -- Распроводим
     PERFORM lpUnComplete_Movement (inMovementId     := tmp.MovementId
                                  , inUserId         := inUserId)
     FROM (SELECT _tmpResult.MovementId FROM _tmpResult WHERE _tmpResult.isDelete = FALSE AND _tmpResult.MovementId <> 0 GROUP BY _tmpResult.MovementId) AS tmp
          INNER JOIN Movement ON Movement.Id = tmp.MovementId
                             AND Movement.StatusId = zc_Enum_Status_Complete();

     -- удаляются документы !!!важно MovementItemId_child = 0!!!
     PERFORM lpSetErased_Movement (inMovementId:= tmp.MovementId
                                 , inUserId    := inUserId
                                  )
     FROM (SELECT _tmpResult.MovementId FROM _tmpResult WHERE _tmpResult.isDelete = TRUE AND _tmpResult.MovementId <> 0 AND _tmpResult.MovementItemId_child = 0 GROUP BY _tmpResult.MovementId) AS tmp
    ;
     -- удаляются элементы, !!!т.е. не по MovementItemId_master!!!
     PERFORM lpSetErased_MovementItem (inMovementItemId:= _tmpResult.MovementItemId_child
                                     , inUserId        := inUserId
                                      )
     FROM _tmpResult
          LEFT JOIN _tmpResult AS _tmpResult_movement ON _tmpResult_movement.MovementId           = _tmpResult.MovementId
                                                     AND _tmpResult_movement.isDelete             = TRUE
                                                     AND _tmpResult_movement.MovementItemId_child = 0 -- !!!важно MovementItemId_child = 0!!!
     WHERE _tmpResult.isDelete = TRUE AND _tmpResult.MovementItemId_child <> 0
       AND _tmpResult_movement.MovementId IS NULL -- т.е. только те которые не попали в удаление документов
    ;


     -- создаются документы - <Производство смешивание>
     UPDATE _tmpResult SET MovementId = tmp.MovementId
     FROM (SELECT lpInsertUpdate_Movement_ProductionUnion (ioId                    := 0
                                                         , inInvNumber             := CAST (NEXTVAL ('movement_ProductionUnion_seq') AS TVarChar)
                                                         , inOperDate              := tmp.OperDate
                                                         , inFromId                := inUnitId
                                                         , inToId                  := inUnitId
                                                         , inDocumentKindId        := 0
                                                         , inIsPeresort            := FALSE
                                                         , inUserId                := inUserId
                                                          ) AS MovementId
           FROM (SELECT inEndDate AS OperDate
                 FROM _tmpResult
                 WHERE _tmpResult.MovementId = 0 AND _tmpResult.isDelete = FALSE
                 LIMIT 1
                 ) AS tmp
          ) AS tmp
     WHERE _tmpResult.MovementId = 0
       AND _tmpResult.isDelete = FALSE;


    -- Проверка
    IF EXISTS (SELECT COUNT(*) FROM (SELECT _tmpResult.MovementId FROM _tmpResult WHERE _tmpResult.MovementId <> 0 AND _tmpResult.isDelete = FALSE GROUP BY _tmpResult.MovementId) AS tmp HAVING COUNT(*) > 1)
    THEN             RAISE EXCEPTION 'Error.Many find MovementId: Min = <%>  Max = <%> Count = <%>', (SELECT MIN (_tmpResult.MovementId) FROM _tmpResult WHERE _tmpResult.MovementId <> 0 AND _tmpResult.isDelete = FALSE)
                                                                                                   , (SELECT MAX (_tmpResult.MovementId) FROM _tmpResult WHERE _tmpResult.MovementId <> 0 AND _tmpResult.isDelete = FALSE)
                                                                                                   , (SELECT COUNT(*) FROM (SELECT _tmpResult.MovementId FROM _tmpResult WHERE _tmpResult.MovementId <> 0 AND _tmpResult.isDelete = FALSE GROUP BY _tmpResult.MovementId) AS tmp)
        ;
    END IF;

     -- сохраняются элементы
     PERFORM lpInsertUpdate_MI_ProductionPeresort (ioId                     := _tmpResult.MovementItemId_master
                                                 , inMovementId             := _tmpResult.MovementId
                                                 , inGoodsId                := Container.ObjectId
                                                 , inGoodsId_child          := Container.ObjectId
                                                 , inGoodsKindId            := CLO_GoodsKind.ObjectId
                                                 , inGoodsKindId_child      := CLO_GoodsKind.ObjectId
                                                 , inAmount                 := _tmpResult.OperCount_master
                                                 , inAmount_child           := _tmpResult.OperCount_child
                                                 , inPartionGoods           := NULL
                                                 , inPartionGoods_child     := NULL
                                                 , inPartionGoodsDate       := NULL
                                                 , inPartionGoodsDate_child := NULL
                                                 , inUserId                 := inUserId
                                                  )
     FROM _tmpResult
          LEFT JOIN Container ON Container.Id = _tmpResult.ContainerId
          LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                        ON CLO_GoodsKind.ContainerId = _tmpResult.ContainerId
                                       AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
     WHERE _tmpResult.isDelete = FALSE;


     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_ProductionUnion_CreateTemp();
     -- !!!Проводим но не ВСЁ!!!
     PERFORM lpComplete_Movement_ProductionUnion (inMovementId     := tmp.MovementId
                                                , inIsHistoryCost  := TRUE
                                                , inUserId         := inUserId)
     FROM (SELECT _tmpResult.MovementId FROM _tmpResult WHERE _tmpResult.isDelete = FALSE AND _tmpResult.MovementId <> 0 GROUP BY _tmpResult.MovementId) AS tmp
          INNER JOIN Movement ON Movement.Id = tmp.MovementId
                             AND Movement.StatusId = zc_Enum_Status_UnComplete()
    ;

     END IF; -- if inIsUpdate = TRUE -- !!!т.е. не всегда!!!


    IF inUserId = zfCalc_UserAdmin() :: Integer
    THEN
        -- Результат
        RETURN QUERY
        SELECT _tmpResult.MovementId
             , Movement.OperDate
             , Movement.InvNumber
             , _tmpResult.isDelete
             , _tmpResult.MovementItemId_child, _tmpResult.MovementItemId_master, _tmpResult.ContainerId
             , _tmpResult.OperCount_child
             , _tmpResult.OperCount_master
             , Object_Goods.ObjectCode AS GoodsCode
             , Object_Goods.ValueData  AS GoodsName
             , Object_GoodsKind.ValueData AS GoodsKindName
        FROM _tmpResult
             LEFT JOIN Movement ON Movement.Id = _tmpResult.MovementId
             LEFT JOIN Container ON Container.Id = _tmpResult.ContainerId
             LEFT JOIN Object AS Object_Goods on Object_Goods.Id = Container.ObjectId
             LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                           ON CLO_GoodsKind.ContainerId = _tmpResult.ContainerId
                                          AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
             LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = CLO_GoodsKind.ObjectId
        ;
    END IF;



END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.08.15                                        *
*/

-- тест
-- SELECT * FROM lpUpdate_Movement_ProductionUnion_Kopchenie (inIsUpdate:= FALSE, inStartDate:= '01.07.2015', inEndDate:= '31.07.2015', inUnitId:= 8450, inUserId:= zfCalc_UserAdmin() :: Integer) -- ЦЕХ копчения
-- where ContainerId = 568111
