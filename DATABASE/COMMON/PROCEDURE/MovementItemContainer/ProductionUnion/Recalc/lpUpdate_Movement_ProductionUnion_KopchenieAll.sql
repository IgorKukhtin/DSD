-- Function: lpUpdate_Movement_ProductionUnion_KopchenieAll (Boolean, TDateTime, TDateTime, Integer, Integer)

DROP FUNCTION IF EXISTS lpUpdate_Movement_ProductionUnion_KopchenieAll (Boolean, TDateTime, TDateTime, Integer, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_Movement_ProductionUnion_KopchenieAll(
    IN inIsUpdate     Boolean   , --
    IN inStartDate    TDateTime , --
    IN inEndDate      TDateTime , --
    IN inUnitId       Integer,    --
    IN inUserId       Integer     -- Пользователь
)
RETURNS TABLE (MovementId Integer, OperDate TDateTime, InvNumber TVarChar, DescId Integer, Id_calc Integer, ContainerId Integer
             , Amnount TFloat
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
         /*PERFORM lpSetErased_Movement (inMovementId:= tmp.MovementId
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
              ) AS tmp;*/

         -- !!!Выход!!!
         RETURN;
     ELSE
         -- !!!Меняем период - на 1 месяц!!!
         inStartDate:= DATE_TRUNC ('MONTH', inEndDate);
     END IF;


     -- таблица -
     CREATE TEMP TABLE _tmpResult (MovementId Integer, DescId Integer, Id_calc Integer, ContainerId Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;

     -- данные по движению "Цех Копчения" + найденные MovementItemId
     INSERT INTO _tmpResult (MovementId, DescId, Id_calc, ContainerId, GoodsId, Amount)
             WITH tmpMI AS (-- получаем движение
                            SELECT MIContainer.ContainerId, MIContainer.ObjectId_Analyzer AS GoodsId
                                   -- приход, он будет zc_MI_Child в zc_Movement_ProductionUnion
                                 , SUM (CASE WHEN MIContainer.isActive = TRUE  AND MIContainer.MovementDescId = zc_Movement_Send() THEN  1 * MIContainer.Amount ELSE 0 END) AS Amount_child
                                   -- расход, он будет zc_MI_Master в zc_Movement_ProductionUnion
                                 , SUM (CASE WHEN MIContainer.isActive = FALSE AND MIContainer.MovementDescId = zc_Movement_Send() THEN -1 * MIContainer.Amount ELSE 0 END) AS Amount_master
                                   -- здесь внутренний расход на пр-во, вычитаем из будущего zc_MI_Child
                                 , SUM (CASE WHEN MIContainer.isActive = FALSE AND MIContainer.ObjectExtId_Analyzer = inUnitId AND COALESCE (MB_isAuto.ValueData, FALSE) = FALSE AND MIContainer.MovementDescId = zc_Movement_ProductionUnion() THEN -1 * MIContainer.Amount ELSE 0 END) AS Amount_child_minus
                                   -- здесь внутренний приход с пр-ва, вычитаем из будущего zc_MI_Master
                                 , SUM (CASE WHEN MIContainer.isActive = TRUE  AND MIContainer.ObjectExtId_Analyzer = inUnitId AND COALESCE (MB_isAuto.ValueData, FALSE) = FALSE AND MIContainer.MovementDescId = zc_Movement_ProductionUnion() THEN  1 * MIContainer.Amount ELSE 0 END) AS Amount_master_minus
                            FROM MovementItemContainer AS MIContainer
                                 LEFT JOIN MovementBoolean AS MB_isAuto ON MB_isAuto.MovementId = MIContainer.MovementId AND MB_isAuto.DescId = zc_MovementBoolean_isAuto()
                            WHERE MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                              AND MIContainer.DescId                 = zc_MIContainer_Count()
                              AND MIContainer.WhereObjectId_Analyzer = inUnitId
                              AND MIContainer.MovementDescId         IN (zc_Movement_Send(), zc_Movement_ProductionUnion())
                            GROUP BY MIContainer.ContainerId, MIContainer.ObjectId_Analyzer
                           )
           , tmpRemains AS (-- остатки
                            SELECT tmpMI.ContainerId
                                 , Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS Amount
                            FROM tmpMI
                                 INNER JOIN Container ON Container.Id = tmpMI.ContainerId
                                 LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.ContainerId = tmpMI.ContainerId
                                                                               AND MIContainer.OperDate >= inStartDate
                            WHERE tmpMI.Amount_master - COALESCE (tmpMI.Amount_master_minus) > 0 AND tmpMI.Amount_child - COALESCE (tmpMI.Amount_child_minus) > 0
                            GROUP BY tmpMI.ContainerId, Container.Amount
                           )
         , tmpMI_Master AS (-- данные по Master
                            SELECT tmpMI.ContainerId
                                 , tmpMI.GoodsId
                                 , tmpMI.Amount_master - COALESCE (tmpMI.Amount_master_minus) AS Amount
                            FROM tmpMI
                            WHERE -- если есть приход
                                  tmpMI.Amount_master - COALESCE (tmpMI.Amount_master_minus) > 0
                              -- если расход и приход отличаются
                              AND tmpMI.Amount_child - COALESCE (tmpMI.Amount_child_minus) <> tmpMI.Amount_master - COALESCE (tmpMI.Amount_master_minus)
                           )
         , tmpMI_Child AS (-- данные по Child
                            SELECT tmpMI.ContainerId
                                 , tmpMI.GoodsId
                                 , tmpMI.Amount_child - COALESCE (tmpMI.Amount_child_minus) + COALESCE (tmpRemains.Amount, 0) AS Amount -- !!!добавили остаток!!!
                            FROM tmpMI
                                 LEFT JOIN tmpRemains ON tmpRemains.ContainerId = tmpMI.ContainerId
                            WHERE (tmpMI.Amount_child - COALESCE (tmpMI.Amount_child_minus) + COALESCE (tmpRemains.Amount, 0)) > 0
                              -- НЕ ОГРАНИЧИВАЕМ если есть приход
                              -- AND tmpMI.Amount_master - COALESCE (tmpMI.Amount_master_minus) > 0
                              -- если расход и приход отличаются
                              AND tmpMI.Amount_child - COALESCE (tmpMI.Amount_child_minus) <> tmpMI.Amount_master - COALESCE (tmpMI.Amount_master_minus)
                           )
      , tmpMI_Child_res AS (-- распределили
                            SELECT tmpMI_Master.ContainerId AS ContainerId_master
                                 , tmpMI_Child.ContainerId
                                 , tmpMI_Child.GoodsId
                                 , tmpMI_Child.Amount * tmpMI_Master.Amount / tmpGroup.Amount AS Amount
                            FROM tmpMI_Child
                                 JOIN tmpMI_Master ON tmpMI_Master.GoodsId = tmpMI_Child.GoodsId
                                 JOIN (SELECT tmpMI_Master.GoodsId, SUM (tmpMI_Master.Amount) AS Amount FROM tmpMI_Master GROUP BY tmpMI_Master.GoodsId
                                      ) AS tmpGroup ON tmpGroup.GoodsId = tmpMI_Child.GoodsId
                           )
           , tmpMI_find AS (-- существующие "пересортицы" где isAuto = TRUE - !!!за 1 День!!!
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
                            SELECT MAX (tmpMI_find.MovementId) AS MovementId
                            FROM tmpMI_find
                            WHERE tmpMI_find.OperDate = inEndDate
                           )
          -- Результат
          -- данные по Master
          SELECT COALESCE (tmpMovement.MovementId, 0) AS MovementId
               , zc_MI_Master() AS DescId
                 -- потом запишем сюда MovementItem.Id
               , 0 AS Id_calc
               , tmpMI_Master.ContainerId
               , tmpMI_Master.GoodsId
               , tmpMI_Master.Amount
          FROM tmpMI_Master
               CROSS JOIN tmpMovement
          WHERE tmpMI_Master.ContainerId IN (SELECT tmpMI_Child_res.ContainerId_master FROM tmpMI_Child_res)

         UNION ALL
          -- данные по Child
          SELECT COALESCE (tmpMovement.MovementId, 0) AS MovementId
               , zc_MI_Child() AS DescId
                 -- для связи с Master
               , tmpMI_Child_res.ContainerId_master AS Id_calc
               , tmpMI_Child_res.ContainerId
               , tmpMI_Child_res.GoodsId
                 -- уменьшаем на разницу
               , tmpMI_Child_res.Amount - COALESCE (tmp_diff.Amount_diff, 0) AS Amount
          FROM tmpMI_Child_res
               CROSS JOIN tmpMovement
               LEFT JOIN (SELECT tmpMI_Child_res.ContainerId
                               , tmp_res.Amount - tmp_Child.Amount AS Amount_diff
                                 -- № п/п
                               , ROW_NUMBER() OVER (PARTITION BY tmpMI_Child_res.GoodsId ORDER BY tmpMI_Child_res.Amount DESC) AS Ord
                          FROM -- сумма того что получилось при распределении
                               (SELECT tmpMI_Child_res.GoodsId, SUM (tmpMI_Child_res.Amount) AS Amount FROM tmpMI_Child_res GROUP BY tmpMI_Child_res.GoodsId
                               ) AS tmp_res
                               -- сумма того что было
                               INNER JOIN (SELECT tmpMI_Child.GoodsId, SUM (tmpMI_Child.Amount) AS Amount FROM tmpMI_Child GROUP BY tmpMI_Child.GoodsId
                                          ) AS tmp_Child ON tmp_Child.GoodsId = tmp_res.GoodsId
                                                        AND tmp_Child.Amount  <> tmp_res.Amount
                               -- здесь будем искать 1 элемент куда попадет разница из-за округлений
                               INNER JOIN tmpMI_Child_res ON tmp_Child.GoodsId = tmp_res.GoodsId
                         ) AS tmp_diff ON tmp_diff.ContainerId = tmpMI_Child_res.ContainerId
                                      AND tmp_diff.Ord         = 1

         UNION ALL
          -- документы которые надо удалить
          SELECT DISTINCT tmpMI_find.MovementId AS MovementId
               , 0 AS DescId
               , 0 AS Id_calc
               , 0 AS ContainerId
               , 0 AS GoodsId
               , 0 AS Amount
          FROM tmpMI_find
               LEFT JOIN tmpMovement ON tmpMovement.MovementId = tmpMI_find.MovementId
          WHERE tmpMovement.MovementId IS NULL
         -- AND tmpMI_find.OperDate = inEndDate
         ;


    RAISE EXCEPTION 'ok.  <%>  %'
      , (SELECT SUM (_tmpResult.Amount) FROM _tmpResult WHERE _tmpResult.GoodsId = 4597067 and _tmpResult.DescId = zc_MI_Master())
      , (SELECT SUM (_tmpResult.Amount) FROM _tmpResult WHERE _tmpResult.GoodsId = 4597067 and _tmpResult.DescId = zc_MI_Child())
      ;

    -- Проверка
    IF EXISTS (SELECT 1 FROM _tmpResult WHERE _tmpResult.Amount < 0)
    THEN             RAISE EXCEPTION 'Error. Amount < 0 find <%> Amount = <%> (<%>)'
                                   , lfGet_Object_ValueData ((SELECT _tmpResult.GoodsId FROM _tmpResult WHERE _tmpResult.Amount < 0 ORDER BY _tmpResult.ContainerId LIMIT 1))
                                   , (SELECT _tmpResult.Amount FROM _tmpResult WHERE _tmpResult.Amount < 0 ORDER BY _tmpResult.ContainerId LIMIT 1)
                                   , (SELECT _tmpResult.ContainerId FROM _tmpResult WHERE _tmpResult.Amount < 0 ORDER BY _tmpResult.ContainerId LIMIT 1)
                                    ;
    END IF;

     -- !!!не всегда!!!
     IF inIsUpdate = TRUE
     THEN
         -- Распроводим !!!важно DescId <> 0!!!
         PERFORM lpUnComplete_Movement (inMovementId     := tmp.MovementId
                                      , inUserId         := inUserId)
         FROM (SELECT DISTINCT _tmpResult.MovementId FROM _tmpResult WHERE _tmpResult.DescId <> 0 AND _tmpResult.MovementId <> 0) AS tmp
              INNER JOIN Movement ON Movement.Id       = tmp.MovementId
                                 AND Movement.StatusId = zc_Enum_Status_Complete();

         -- удаляются документы !!!важно DescId = 0!!!
         PERFORM lpSetErased_Movement (inMovementId:= tmp.MovementId
                                     , inUserId    := inUserId
                                      )
         FROM (SELECT _tmpResult.MovementId FROM _tmpResult WHERE _tmpResult.DescId = 0) AS tmp
        ;
         -- удаляются элементы
         PERFORM lpSetErased_MovementItem (inMovementItemId:= MovementItem.Id
                                         , inUserId        := inUserId
                                          )
         FROM MovementItem
         WHERE MovementItem.MovementId = (SELECT DISTINCT _tmpResult.MovementId FROM _tmpResult WHERE _tmpResult.DescId <> 0 AND _tmpResult.MovementId <> 0)
           AND MovementItem.isErased   = FALSE
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
               FROM (SELECT DISTINCT inEndDate AS OperDate
                     FROM _tmpResult
                     WHERE _tmpResult.MovementId = 0
                       AND _tmpResult.DescId     <> 0
                     LIMIT 1
                     ) AS tmp
              ) AS tmp
         WHERE _tmpResult.MovementId = 0;

         -- !!!только при создании!!!
         IF inUserId NOT IN (zc_Enum_Process_Auto_Defroster(), zc_Enum_Process_Auto_Pack(), zc_Enum_Process_Auto_Kopchenie())
         THEN
             -- сохранили свойство <автоматически сформирован>
             PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isAuto()
                                                   , (SELECT DISTINCT _tmpResult.MovementId FROM _tmpResult WHERE _tmpResult.DescId <> 0)
                                                   , TRUE);
             -- сохранили связь с <Пользователь>
             PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_User()
                                                      , (SELECT DISTINCT _tmpResult.MovementId FROM _tmpResult WHERE _tmpResult.DescId <> 0)
                                                      , inUserId);
         END IF;


        -- Проверка
        IF EXISTS (SELECT COUNT(*) FROM (SELECT _tmpResult.MovementId FROM _tmpResult WHERE _tmpResult.MovementId <> 0 AND _tmpResult.DescId <> 0 GROUP BY _tmpResult.MovementId) AS tmp HAVING COUNT(*) > 1)
        THEN             RAISE EXCEPTION 'Error.Many find MovementId: Min = <%>  Max = <%> Count = <%>', (SELECT MIN (_tmpResult.MovementId) FROM _tmpResult WHERE _tmpResult.MovementId <> 0 AND _tmpResult.DescId <> 0)
                                                                                                       , (SELECT MAX (_tmpResult.MovementId) FROM _tmpResult WHERE _tmpResult.MovementId <> 0 AND _tmpResult.DescId <> 0)
                                                                                                       , (SELECT COUNT(*) FROM (SELECT _tmpResult.MovementId FROM _tmpResult WHERE _tmpResult.MovementId <> 0 AND _tmpResult.DescId <> 0 GROUP BY _tmpResult.MovementId) AS tmp)
            ;
        END IF;

         -- сохраняются элементы
         UPDATE _tmpResult SET Id_calc = tmp.MovementItemId
         FROM (SELECT lpInsertUpdate_MI_ProductionUnion_Master (ioId               := 0
                                                              , inMovementId       := _tmpResult.MovementId
                                                              , inGoodsId          := _tmpResult.GoodsId
                                                              , inAmount           := _tmpResult.Amount
                                                              , inCount            := 0
                                                              , inCuterWeight      := 0
                                                              , inPartionGoodsDate := NULL
                                                              , inPartionGoods     := NULL
                                                              , inPartNumber       := NULL 
                                                              , inModel            := NULL
                                                              , inGoodsKindId      := CLO_GoodsKind.ObjectId
                                                              , inGoodsKindId_Complete   := NULL
                                                              , inStorageId        := NULL
                                                              , inUserId           := inUserId
                                                               ) AS MovementItemId
                    , _tmpResult.ContainerId
               FROM _tmpResult
                    LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                                  ON CLO_GoodsKind.ContainerId = _tmpResult.ContainerId
                                                 AND CLO_GoodsKind.DescId      = zc_ContainerLinkObject_GoodsKind()
               WHERE _tmpResult.DescId = zc_MI_Master()
              ) AS tmp
         WHERE _tmpResult.ContainerId = tmp.ContainerId
           AND _tmpResult.DescId      = zc_mi_master()
         ;

         -- сохраняются элементы
         PERFORM lpInsertUpdate_MI_ProductionUnion_Child(ioId               := 0
                                                       , inMovementId       := _tmpResult.MovementId
                                                       , inGoodsId          := _tmpResult.GoodsId
                                                       , inAmount           := _tmpResult.Amount
                                                       , inParentId         := _tmpResult_master.Id_calc
                                                       , inPartionGoodsDate := NULL
                                                       , inPartionGoods     := NULL
                                                       , inPartNumber       := NULL
                                                       , inModel            := NULL
                                                       , inGoodsKindId      := CLO_GoodsKind.ObjectId
                                                       , inGoodsKindCompleteId := NULL
                                                       , inStorageId        := NULL
                                                       , inCount_onCount    := 0
                                                       , inUserId           := inUserId
                                                        )
         FROM _tmpResult
              LEFT JOIN _tmpResult AS _tmpResult_master ON _tmpResult_master.ContainerId = _tmpResult.Id_calc
                                                       AND _tmpResult_master.DescId      = zc_MI_Master()
              LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                            ON CLO_GoodsKind.ContainerId = _tmpResult.ContainerId
                                           AND CLO_GoodsKind.DescId      = zc_ContainerLinkObject_GoodsKind()
         WHERE _tmpResult.DescId = zc_MI_Child();


         -- создаются временные таблицы - для формирование данных для проводок
         PERFORM lpComplete_Movement_ProductionUnion_CreateTemp();
         -- !!!Проводим но не ВСЁ!!!
         PERFORM lpComplete_Movement_ProductionUnion (inMovementId     := tmp.MovementId
                                                    , inIsHistoryCost  := TRUE
                                                    , inUserId         := inUserId)
         FROM (SELECT DISTINCT _tmpResult.MovementId FROM _tmpResult WHERE _tmpResult.DescId <> 0) AS tmp
              INNER JOIN Movement ON Movement.Id       = tmp.MovementId
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
             , _tmpResult.DescId
             , _tmpResult.Id_calc, _tmpResult.ContainerId
             , _tmpResult.Amount
             , Object_Goods.ObjectCode AS GoodsCode
             , Object_Goods.ValueData  AS GoodsName
             , Object_GoodsKind.ValueData AS GoodsKindName
        FROM _tmpResult
             LEFT JOIN Movement ON Movement.Id = _tmpResult.MovementId
             LEFT JOIN Object AS Object_Goods on Object_Goods.Id = _tmpResult.GoodsId
             LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                           ON CLO_GoodsKind.ContainerId = _tmpResult.ContainerId
                                          AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
             LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = CLO_GoodsKind.ObjectId
        ORDER BY _tmpResult.MovementId, _tmpResult.Id_calc, _tmpResult.ContainerId, _tmpResult.DescId
        ;
    END IF;



END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.05.23         *
 30.06.19                                        *
*/

-- тест
-- SELECT * FROM lpUpdate_Movement_ProductionUnion_KopchenieAll (inIsUpdate:= FALSE, inStartDate:= '30.06.2019', inEndDate:= '30.06.2019', inUnitId:= 8450, inUserId:= zfCalc_UserAdmin() :: Integer) -- ЦЕХ копчения -- where ContainerId = 568111
-- SELECT * FROM gpUpdate_Movement_ProductionUnion_Kopchenie(inStartDate:= '30.09.2023', inEndDate:= '30.09.2023', inUnitId:= 8450, inSession:= zfCalc_UserAdmin() :: TvarChar) -- ЦЕХ копчения
