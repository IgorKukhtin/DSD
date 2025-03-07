-- Function: lpUpdate_Movement_ProductionUnion_Defroster (Boolean, TDateTime, TDateTime, Integer, Integer, Integer)

DROP FUNCTION IF EXISTS lpUpdate_Movement_ProductionUnion_Defroster (Boolean, TDateTime, TDateTime, Integer, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_Movement_ProductionUnion_Defroster(
    IN inIsUpdate     Boolean   , --
    IN inStartDate    TDateTime , --
    IN inEndDate      TDateTime , --
    IN inUnitId       Integer,    -- 
    IN inUserId       Integer     -- Пользователь
)                              
RETURNS TABLE (MovementId Integer, OperDate TDateTime, InvNumber TVarChar, isDelete Boolean, MovementItemId_child Integer, MovementItemId_master Integer, ContainerId Integer
             , OperCount_child TFloat, OperCount_master TFloat
             , GoodsCode Integer, GoodsName TVarChar
             , PartionGoods TVarChar
              )
AS
$BODY$
BEGIN
     -- таблица - 
     CREATE TEMP TABLE _tmpResult (MovementId Integer, OperDate TDateTime, MovementItemId_child Integer, MovementItemId_master Integer, ContainerId Integer, OperCount_child TFloat, OperCount_master TFloat, isDelete Boolean) ON COMMIT DROP;

     -- данные по движению "схема Дефростер" + найденные MovementItemId
     INSERT INTO _tmpResult (MovementId, OperDate, MovementItemId_child, MovementItemId_master, ContainerId, OperCount_child, OperCount_master, isDelete)
             WITH tmpMI AS (-- получаем движение
                            SELECT MIContainer.ContainerId
                                   -- группируется все в дату "прихода"
                                 , CASE WHEN MIContainer.isActive = TRUE THEN MIContainer.OperDate ELSE MIContainer.OperDate - INTERVAL '1 DAY' END AS OperDate
                                   -- приход за OperDate, он будет zc_MI_Child в zc_Movement_ProductionUnion
                                 , SUM (CASE WHEN MIContainer.isActive = TRUE  AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount ELSE 0 END) AS OperCount_child
                                   -- расход за OperDate + 1, он будет zc_MI_Master в zc_Movement_ProductionUnion
                                 , SUM (CASE WHEN MIContainer.isActive = FALSE AND MIContainer.OperDate BETWEEN inStartDate + INTERVAL '1 DAY' AND inEndDate + INTERVAL '1 DAY' THEN -1 * MIContainer.Amount ELSE 0 END) AS OperCount_master
                            FROM (SELECT zc_Movement_ProductionSeparate() AS MovementDescId UNION SELECT zc_Movement_Send() AS MovementDescId
                                 ) AS tmpDesc
                                 INNER JOIN MovementItemContainer AS MIContainer ON MIContainer.OperDate BETWEEN inStartDate AND inEndDate + INTERVAL '1 DAY'
                                                                                AND MIContainer.DescId                 = zc_MIContainer_Count()
                                                                                AND MIContainer.WhereObjectId_Analyzer = inUnitId
                                                                                AND MIContainer.MovementDescId         = tmpDesc.MovementDescId
                            GROUP BY MIContainer.ContainerId
                                   , CASE WHEN MIContainer.isActive = TRUE THEN MIContainer.OperDate ELSE MIContainer.OperDate - INTERVAL '1 DAY' END
                           )
            , tmpMI_all AS (-- существующие "пересортицы" для isAuto = TRUE
                            SELECT MIContainer.MovementId
                                 , MIContainer.ContainerId
                                 , MIContainer.MovementItemId
                                 , MIContainer.OperDate
                                 , MIContainer.isActive
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
          , tmpMovement AS (-- поиск одного документа за OperDate
                            SELECT tmpMI_all.OperDate
                                 , MAX (tmpMI_all.MovementId) AS MovementId
                            FROM tmpMI_all
                            GROUP BY tmpMI_all.OperDate
                           )
           , tmpMI_find AS (-- нужен только один из элементов (по нему будет Update, иначе Insert, остальные Delete)
                            SELECT tmpMI_all.ContainerId
                                 , tmpMI_all.OperDate
                                 , MAX (tmpMI_all.MovementItemId) AS MovementItemId
                            FROM tmpMovement
                                 INNER JOIN tmpMI_all ON tmpMI_all.MovementId = tmpMovement.MovementId
                            WHERE tmpMI_all.isActive = FALSE
                            GROUP BY tmpMI_all.ContainerId
                                   , tmpMI_all.OperDate
                           )
         , tmpMI_result AS (-- данные по движению "схема Дефростер"
                            SELECT COALESCE (tmpMovement.MovementId, 0)  AS MovementId
                                 , COALESCE (MovementItem.ParentId, 0)   AS MovementItemId_master
                                 , COALESCE (MovementItem.Id, 0)         AS MovementItemId_child
                                 , tmpMI.OperDate
                                 , tmpMI.ContainerId
                                 , tmpMI.OperCount_child
                                 , tmpMI.OperCount_master
                            FROM tmpMI
                                 LEFT JOIN tmpMovement ON tmpMovement.OperDate = tmpMI.OperDate
                                 LEFT JOIN tmpMI_find ON tmpMI_find.ContainerId = tmpMI.ContainerId
                                                     AND tmpMI_find.OperDate    = tmpMI.OperDate
                                 LEFT JOIN MovementItem ON MovementItem.Id = tmpMI_find.MovementItemId
                            WHERE tmpMI.OperCount_child <> 0 AND tmpMI.OperCount_master <> 0
                              AND tmpMI.OperCount_child <> tmpMI.OperCount_master
                           )
          , tmpMI_list AS (-- список найденных элементов
                            SELECT tmpMI_result.MovementId, 0                                  AS MovementItemId FROM tmpMI_result WHERE tmpMI_result.MovementId <> 0
                      UNION SELECT 0         AS MovementId, tmpMI_result.MovementItemId_master AS MovementItemId FROM tmpMI_result WHERE tmpMI_result.MovementItemId_master <> 0
                      UNION SELECT 0         AS MovementId, tmpMI_result.MovementItemId_child  AS MovementItemId FROM tmpMI_result WHERE tmpMI_result.MovementItemId_child <> 0
                           )
          -- Результат:
          -- "схема Дефростер"
          SELECT tmpMI_result.MovementId
               , tmpMI_result.OperDate
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
               , zc_DateStart() AS OperDate
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
               , zc_DateStart()           AS OperDate
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
                                  , inUserId         := inUserId
                                   )
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
                                     , inUserId        := zc_Enum_Process_Auto_Defroster() :: Integer
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
     FROM (SELECT tmp.OperDate
                , lpInsertUpdate_Movement_ProductionUnion (ioId                    := 0
                                                         , inInvNumber             := CAST (NEXTVAL ('movement_ProductionUnion_seq') AS TVarChar)
                                                         , inOperDate              := tmp.OperDate
                                                         , inFromId                := inUnitId
                                                         , inToId                  := inUnitId
                                                         , inDocumentKindId        := 0
                                                         , inIsPeresort            := FALSE
                                                         , inUserId                := zc_Enum_Process_Auto_Defroster() :: Integer
                                                          ) AS MovementId
           FROM (SELECT _tmpResult.OperDate
                 FROM _tmpResult
                 WHERE _tmpResult.MovementId = 0 AND _tmpResult.isDelete = FALSE
                 GROUP BY _tmpResult.OperDate
                 ) AS tmp
          ) AS tmp
     WHERE _tmpResult.OperDate = tmp.OperDate
       AND _tmpResult.MovementId = 0
       AND _tmpResult.isDelete = FALSE;


    -- Проверка
    IF EXISTS (SELECT tmp.OperDate FROM (SELECT _tmpResult.MovementId, _tmpResult.OperDate FROM _tmpResult WHERE _tmpResult.MovementId <> 0 AND _tmpResult.isDelete = FALSE GROUP BY _tmpResult.MovementId, _tmpResult.OperDate) AS tmp GROUP BY tmp.OperDate HAVING COUNT(*) > 1)
    THEN RAISE EXCEPTION 'Error.Many find MovementId: Date = <%>  Min = <%>  Max = <%> Count = <%>', (SELECT tmp.OperDate FROM (SELECT _tmpResult.MovementId, _tmpResult.OperDate FROM _tmpResult WHERE _tmpResult.MovementId <> 0 AND _tmpResult.isDelete = FALSE GROUP BY _tmpResult.MovementId, _tmpResult.OperDate) AS tmp
                                                                               WHERE tmp.OperDate IN (SELECT tmp.OperDate FROM (SELECT _tmpResult.MovementId, _tmpResult.OperDate FROM _tmpResult WHERE _tmpResult.MovementId <> 0 AND _tmpResult.isDelete = FALSE GROUP BY _tmpResult.MovementId, _tmpResult.OperDate) AS tmp GROUP BY tmp.OperDate HAVING COUNT(*) > 1)
                                                                                                      ORDER BY tmp.OperDate LIMIT 1)
                                                                                                   , (SELECT tmp.MovementId FROM (SELECT _tmpResult.MovementId, _tmpResult.OperDate FROM _tmpResult WHERE _tmpResult.MovementId <> 0 AND _tmpResult.isDelete = FALSE GROUP BY _tmpResult.MovementId, _tmpResult.OperDate) AS tmp
                                                                               WHERE tmp.OperDate IN (SELECT tmp.OperDate FROM (SELECT _tmpResult.MovementId, _tmpResult.OperDate FROM _tmpResult WHERE _tmpResult.MovementId <> 0 AND _tmpResult.isDelete = FALSE GROUP BY _tmpResult.MovementId, _tmpResult.OperDate) AS tmp GROUP BY tmp.OperDate HAVING COUNT(*) > 1)
                                                                                                      ORDER BY tmp.OperDate, tmp.MovementId LIMIT 1)
                                                                                                   , (SELECT tmp.MovementId FROM (SELECT _tmpResult.MovementId, _tmpResult.OperDate FROM _tmpResult WHERE _tmpResult.MovementId <> 0 AND _tmpResult.isDelete = FALSE GROUP BY _tmpResult.MovementId, _tmpResult.OperDate) AS tmp
                                                                               WHERE tmp.OperDate IN (SELECT tmp.OperDate FROM (SELECT _tmpResult.MovementId, _tmpResult.OperDate FROM _tmpResult WHERE _tmpResult.MovementId <> 0 AND _tmpResult.isDelete = FALSE GROUP BY _tmpResult.MovementId, _tmpResult.OperDate) AS tmp GROUP BY tmp.OperDate HAVING COUNT(*) > 1)
                                                                                                      ORDER BY tmp.OperDate, tmp.MovementId DESC LIMIT 1)
                                                                                                   , (SELECT COUNT(*) FROM (SELECT _tmpResult.MovementId, _tmpResult.OperDate FROM _tmpResult WHERE _tmpResult.MovementId <> 0 AND _tmpResult.isDelete = FALSE GROUP BY _tmpResult.MovementId, _tmpResult.OperDate) AS tmp
                                                                               WHERE tmp.OperDate IN (SELECT tmp.OperDate FROM (SELECT _tmpResult.MovementId, _tmpResult.OperDate FROM _tmpResult WHERE _tmpResult.MovementId <> 0 AND _tmpResult.isDelete = FALSE GROUP BY _tmpResult.MovementId, _tmpResult.OperDate) AS tmp GROUP BY tmp.OperDate HAVING COUNT(*) > 1)
                                                                                                     )
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
                                                 , inPartionGoods           := Object_PartionGoods.ValueData
                                                 , inPartionGoods_child     := Object_PartionGoods.ValueData
                                                 , inPartionGoodsDate       := NULL
                                                 , inPartionGoodsDate_child := NULL
                                                 , inUserId                 := zc_Enum_Process_Auto_Defroster() :: Integer
                                                  )
     FROM _tmpResult
          LEFT JOIN Container ON Container.Id = _tmpResult.ContainerId
          LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                        ON CLO_GoodsKind.ContainerId = _tmpResult.ContainerId
                                       AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
          LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                        ON CLO_PartionGoods.ContainerId = _tmpResult.ContainerId
                                       AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
          LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = CLO_PartionGoods.ObjectId
     WHERE _tmpResult.isDelete = FALSE;


     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_ProductionUnion_CreateTemp();
     -- !!!Проводим но не ВСЁ!!!
     PERFORM lpComplete_Movement_ProductionUnion (inMovementId     := tmp.MovementId
                                                , inIsHistoryCost  := TRUE
                                                , inUserId         := inUserId
                                                 )
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
             , _tmpResult.OperDate
             , Movement.InvNumber
             , _tmpResult.isDelete
             , _tmpResult.MovementItemId_child, _tmpResult.MovementItemId_master, _tmpResult.ContainerId
             , _tmpResult.OperCount_child
             , _tmpResult.OperCount_master
             , Object_Goods.ObjectCode AS GoodsCode
             , Object_Goods.ValueData  AS GoodsName
             , Object_PartionGoods.ValueData AS PartionGoods
        FROM _tmpResult
             LEFT JOIN Movement ON Movement.Id = _tmpResult.MovementId
             LEFT JOIN Container ON Container.Id = _tmpResult.ContainerId
             LEFT JOIN Object AS Object_Goods on Object_Goods.Id = Container.ObjectId
             LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                           ON CLO_PartionGoods.ContainerId = _tmpResult.ContainerId
                                          AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
             LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = CLO_PartionGoods.ObjectId
        ;
    END IF;


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.07.15                                        *
*/

-- тест
-- SELECT * FROM lpUpdate_Movement_ProductionUnion_Defroster (inIsUpdate:= TRUE, inStartDate:= '01.07.2015', inEndDate:= '19.07.2015', inUnitId:= 8440, inUserId:= zfCalc_UserAdmin() :: Integer) -- Дефростер
-- where ContainerId = 568111
