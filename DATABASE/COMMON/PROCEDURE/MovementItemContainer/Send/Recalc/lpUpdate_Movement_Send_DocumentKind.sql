-- Function: lpUpdate_Movement_Send_DocumentKind (Boolean, TDateTime, TDateTime, Integer, Integer, Integer)

DROP FUNCTION IF EXISTS lpUpdate_Movement_Send_DocumentKind (Boolean, TDateTime, TDateTime, Integer, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_Movement_Send_DocumentKind(
    IN inIsUpdate     Boolean   , --
    IN inStartDate    TDateTime , --
    IN inEndDate      TDateTime , --
    IN inUnitId       Integer,    -- Подразделение с которого факт расход (а приход на него формируем автоматом)
    IN inUserId       Integer     -- Пользователь
)                              
RETURNS TABLE (MovementId Integer, OperDate TDateTime, InvNumber TVarChar, isDelete Boolean, MovementItemId Integer, ContainerId_to Integer
             , OperCount TFloat
             , FromName TVarChar, ToName TVarChar, DocumentKindName TVarChar
             , GoodsCode Integer, GoodsName TVarChar
             , GoodsKindName TVarChar
              )
AS
$BODY$
BEGIN
     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpResult'))
     THEN
         DELETE FROM _tmpResult;
     ELSE
         -- таблица - 
         CREATE TEMP TABLE _tmpResult (MovementId Integer, OperDate TDateTime, FromId Integer, ToId Integer, DocumentKindId Integer, MovementItemId Integer, ContainerId_to Integer, OperCount TFloat, isDelete Boolean) ON COMMIT DROP;
     END IF;

     -- данные по приход/расход перемещение + найденные MovementItemId
     INSERT INTO _tmpResult (MovementId, OperDate, FromId, ToId, DocumentKindId, MovementItemId, ContainerId_to, OperCount, isDelete)
         WITH tmpMI_all AS (-- получаем движение: приход/расход, с заменой "от кого" - !!!всегда!!! "нужное" подразделение (потом приход корректируем и получаем то что в расходе)
                            SELECT COALESCE (MLO_DocumentKind.ObjectId, 0) AS DocumentKindId
                                 , MIContainer.MovementId
                                 , MIContainer.MovementItemId
                                 , MIContainer.OperDate
                                 , CASE WHEN MovementBoolean_isAuto.ValueData = TRUE THEN MIContainer.ObjectExtId_Analyzer   ELSE MIContainer.WhereObjectId_Analyzer    END AS FromId
                                 , CASE WHEN MovementBoolean_isAuto.ValueData = TRUE THEN MIContainer.WhereObjectId_Analyzer ELSE MIContainer.ObjectExtId_Analyzer      END AS ToId
                                 , CASE WHEN MovementBoolean_isAuto.ValueData = TRUE THEN MIContainer.ContainerIntId_Analyzer   ELSE MIContainer.ContainerId            END AS ContainerId_from
                                 , CASE WHEN MovementBoolean_isAuto.ValueData = TRUE THEN MIContainer.ContainerId            ELSE MIContainer.ContainerIntId_Analyzer   END AS ContainerId_to
                                 , COALESCE (MovementBoolean_isAuto.ValueData, FALSE) AS isAuto -- для TRUE - приходы на "нужное" подразделение, для FALSE - расходы с "нужного" подразделение
                                 , CASE WHEN MovementBoolean_isAuto.ValueData = TRUE THEN 1 ELSE -1 END * MIContainer.Amount AS OperCount
                            FROM Movement
                                 INNER JOIN MovementLinkObject AS MLO_DocumentKind
                                                               ON MLO_DocumentKind.MovementId = Movement.Id
                                                              AND MLO_DocumentKind.DescId     = zc_MovementLinkObject_DocumentKind()
                                                              AND MLO_DocumentKind.ObjectId   > 0
                                 LEFT JOIN MovementBoolean AS MovementBoolean_isAuto
                                                           ON MovementBoolean_isAuto.MovementId = Movement.Id
                                                          AND MovementBoolean_isAuto.DescId = zc_MovementBoolean_isAuto()
                                 INNER JOIN MovementItemContainer AS MIContainer
                                                                  ON MIContainer.MovementId             = Movement.Id
                                                                 AND MIContainer.DescId                 = zc_MIContainer_Count()
                                                                 AND (MIContainer.WhereObjectId_Analyzer = inUnitId OR inUnitId = 0)
                                                                 AND MIContainer.isActive = FALSE
                            WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                              AND Movement.DescId = zc_Movement_Send()
                              AND Movement.StatusId = zc_Enum_Status_Complete()
                           )
          , tmpMovement AS (-- поиск одного документа за OperDate - Приход перемещение на "нужное" подразделение
                            SELECT tmpMI_all.OperDate
                                 , tmpMI_all.ToId
                                 , tmpMI_all.DocumentKindId
                                 , MAX (tmpMI_all.MovementId) AS MovementId
                            FROM tmpMI_all
                            WHERE tmpMI_all.isAuto = TRUE -- !!!приходы на "нужное" подразделение!!!
                            GROUP BY tmpMI_all.OperDate
                                   , tmpMI_all.ToId
                                   , tmpMI_all.DocumentKindId
                           )
           , tmpMI_find AS (-- нужен только один из элементов Прихода перемещение (по нему будет Update, иначе Insert, остальные Delete)
                            SELECT tmpMI_all.ContainerId_from
                                 , tmpMI_all.OperDate
                                 , tmpMI_all.ToId
                                 , tmpMI_all.DocumentKindId
                                 , MAX (tmpMI_all.MovementItemId) AS MovementItemId
                            FROM tmpMovement
                                 INNER JOIN tmpMI_all ON tmpMI_all.MovementId = tmpMovement.MovementId
                            GROUP BY tmpMI_all.ContainerId_from
                                   , tmpMI_all.ToId
                                   , tmpMI_all.OperDate
                                   , tmpMI_all.DocumentKindId
                           )
         , tmpMI_result AS (-- данные по элементам Приход перемещение
                            SELECT COALESCE (tmpMovement.MovementId, 0)    AS MovementId
                                 , COALESCE (tmpMI_find.MovementItemId, 0) AS MovementItemId
                                 , tmpMI.OperDate
                                 , tmpMI.FromId
                                 , tmpMI.ToId
                                 , tmpMI.DocumentKindId
                                 , tmpMI.ContainerId_to
                                 , SUM (tmpMI.OperCount) AS OperCount
                            FROM tmpMI_all AS tmpMI
                                 LEFT JOIN tmpMovement ON tmpMovement.OperDate       = tmpMI.OperDate
                                                      AND tmpMovement.ToId           = tmpMI.ToId
                                                      AND tmpMovement.DocumentKindId = tmpMI.DocumentKindId
                                 LEFT JOIN tmpMI_find ON tmpMI_find.ContainerId_from = tmpMI.ContainerId_from
                                                     AND tmpMI_find.OperDate         = tmpMI.OperDate
                                                     AND tmpMI_find.ToId             = tmpMI.ToId
                                                     AND tmpMI_find.DocumentKindId   = tmpMI.DocumentKindId
                            WHERE tmpMI.isAuto = FALSE -- !!!расходы с "нужного" подразделение!!!
                              AND tmpMI.OperCount <> 0
                            GROUP BY COALESCE (tmpMovement.MovementId, 0)
                                   , COALESCE (tmpMI_find.MovementItemId, 0)
                                   , tmpMI.OperDate
                                   , tmpMI.FromId
                                   , tmpMI.ToId
                                   , tmpMI.DocumentKindId
                                   , tmpMI.ContainerId_to
                           )
          , tmpMI_list AS (-- список найденных элементов Прихода перемещение
                            SELECT tmpMI_result.MovementId, 0                           AS MovementItemId FROM tmpMI_result WHERE tmpMI_result.MovementId     <> 0
                      UNION SELECT 0         AS MovementId, tmpMI_result.MovementItemId AS MovementItemId FROM tmpMI_result WHERE tmpMI_result.MovementItemId <> 0
                           )
          -- Результат:
          -- элементы Прихода перемещение
          SELECT tmpMI_result.MovementId
               , tmpMI_result.OperDate
               , tmpMI_result.ToId    AS FromId -- !!!опять заменили!!!
               , tmpMI_result.FromId  AS ToId   -- !!!опять заменили!!!
               , tmpMI_result.DocumentKindId
               , tmpMI_result.MovementItemId
               , tmpMI_result.ContainerId_to
               , tmpMI_result.OperCount
               , FALSE AS isDelete
          FROM tmpMI_result
        UNION
          -- документы которые надо удалить
          SELECT tmpMI_all.MovementId
               , zc_DateStart() AS OperDate
               , 0 AS FromId
               , 0 AS ToId
               , 0 AS DocumentKindId
               , 0 AS MovementItemId
               , 0 AS ContainerId_to
               , 0 AS OperCount
               , TRUE AS isDelete
          FROM tmpMI_all
               LEFT JOIN tmpMI_list ON tmpMI_list.MovementId = tmpMI_all.MovementId
          WHERE tmpMI_all.isAuto = TRUE -- !!!приходы на "нужное" подразделение!!!
            AND tmpMI_list.MovementId IS NULL
         UNION
          -- элементы которые надо удалить
          SELECT tmpMI_all.MovementId     AS MovementId
               , zc_DateStart()           AS OperDate
               , 0 AS FromId
               , 0 AS ToId
               , 0 AS DocumentKindId
               , tmpMI_all.MovementItemId AS MovementItemId
               , 0 AS ContainerId_to
               , 0 AS OperCount
               , TRUE AS isDelete -- !!!приходы на "нужное" подразделение!!!
          FROM tmpMI_all
               LEFT JOIN tmpMI_list ON tmpMI_list.MovementItemId = tmpMI_all.MovementItemId
          WHERE tmpMI_all.isAuto = TRUE
            AND tmpMI_list.MovementItemId IS NULL
         ;


     -- !!!не всегда!!!
     IF inIsUpdate = TRUE
     THEN

     -- Проверка - элементы - Master
     IF EXISTS (SELECT 1 FROM _tmpResult WHERE _tmpResult.isDelete = FALSE AND _tmpResult.OperCount < 0)
     THEN
         RAISE EXCEPTION 'Error. Amount < 0 : (%) Amount = <%> Count = <%> <%>'
                               , (SELECT _tmpResult.ContainerId_to   FROM _tmpResult WHERE _tmpResult.isDelete = FALSE AND _tmpResult.OperCount < 0 ORDER BY _tmpResult.ContainerId_to LIMIT 1)
                               , (SELECT _tmpResult.OperCount        FROM _tmpResult WHERE _tmpResult.isDelete = FALSE AND _tmpResult.OperCount < 0 ORDER BY _tmpResult.ContainerId_to LIMIT 1)
                               , (SELECT COUNT (*) FROM _tmpResult WHERE _tmpResult.isDelete = FALSE AND _tmpResult.OperCount < 0)
                               , DATE (inStartDate)
                                ;
     END IF;

     -- Распроводим
     PERFORM lpUnComplete_Movement (inMovementId     := tmp.MovementId
                                  , inUserId         := inUserId)
     FROM (SELECT DISTINCT _tmpResult.MovementId FROM _tmpResult WHERE _tmpResult.isDelete = FALSE AND _tmpResult.MovementId <> 0) AS tmp
          INNER JOIN Movement ON Movement.Id = tmp.MovementId
                             AND Movement.StatusId = zc_Enum_Status_Complete();

     -- удаляются документы !!!важно MovementItemId = 0!!!
     PERFORM lpSetErased_Movement (inMovementId:= tmp.MovementId
                                 , inUserId    := inUserId
                                  )
     FROM (SELECT DISTINCT _tmpResult.MovementId FROM _tmpResult WHERE _tmpResult.isDelete = TRUE AND _tmpResult.MovementId <> 0 AND _tmpResult.MovementItemId = 0) AS tmp
    ;
     -- удаляются элементы
     PERFORM lpSetErased_MovementItem (inMovementItemId:= _tmpResult.MovementItemId
                                     , inUserId        := inUserId
                                      )
     FROM _tmpResult
     WHERE _tmpResult.isDelete = TRUE
       AND _tmpResult.MovementItemId <> 0
       -- т.е. только те которые НЕ попали в удаление документов
       AND _tmpResult.MovementId NOT IN (SELECT DISTINCT _tmpResult.MovementId FROM _tmpResult WHERE _tmpResult.isDelete = TRUE AND _tmpResult.MovementId <> 0 AND _tmpResult.MovementItemId = 0)
    ;

     -- создаются документы - <Перемещение> + отдельно св-во "автоматически сформирован"
     UPDATE _tmpResult SET MovementId = tmp.MovementId
     FROM (SELECT tmp.OperDate, tmp.FromId, tmp.ToId, tmp.DocumentKindId, tmp.MovementId
                , lpInsertUpdate_MovementBoolean (inDescId              := zc_MovementBoolean_isAuto()
                                                , inMovementId          := tmp.MovementId
                                                , inValueData           := TRUE
                                                 )
           FROM
          (SELECT tmp.OperDate, tmp.FromId, tmp.ToId, tmp.DocumentKindId
                , lpInsertUpdate_Movement_Send (ioId                    := 0
                                              , inInvNumber             := CAST (NEXTVAL ('Movement_Send_seq') AS TVarChar)
                                              , inOperDate              := tmp.OperDate
                                              , inFromId                := tmp.FromId
                                              , inToId                  := tmp.ToId
                                              , inDocumentKindId        := tmp.DocumentKindId
                                              , inSubjectDocId          := 0
                                              , inComment               := '' :: TvarChar
                                              , inUserId                := inUserId
                                               ) AS MovementId
           FROM (SELECT DISTINCT _tmpResult.OperDate, _tmpResult.FromId, _tmpResult.ToId, _tmpResult.DocumentKindId
                 FROM _tmpResult
                 WHERE _tmpResult.MovementId = 0 AND _tmpResult.isDelete = FALSE
                 ) AS tmp
          ) AS tmp
          ) AS tmp
     WHERE _tmpResult.OperDate       = tmp.OperDate
       AND _tmpResult.FromId         = tmp.FromId
       AND _tmpResult.ToId           = tmp.ToId
       AND _tmpResult.DocumentKindId = tmp.DocumentKindId
       AND _tmpResult.isDelete       = FALSE
    ;


     -- сохраняются элементы
     UPDATE _tmpResult SET MovementItemId = lpInsertUpdate_MovementItem_Send_Value
                                                  (ioId                     := _tmpResult.MovementItemId
                                                 , inMovementId             := _tmpResult.MovementId
                                                 , inGoodsId                := tmp.GoodsId
                                                 , inAmount                 := _tmpResult.OperCount
                                                 , inPartionGoodsDate       := NULL
                                                 , inCount                  := 0
                                                 , inHeadCount              := 0
                                                 , inPartionGoods           := NULL
                                                 , inGoodsKindId            := tmp.GoodsKindId
                                                 , inAssetId                := NULL
                                                 , inAssetId_two            := NULL
                                                 , inUnitId                 := NULL
                                                 , inStorageId              := NULL
                                                 , inPartionGoodsId         := NULL
                                                 , inUserId                 := inUserId
                                                  )
     FROM (SELECT _tmpResult.MovementId, _tmpResult.MovementItemId
                , _tmpResult.ContainerId_to, Container.ObjectId AS GoodsId, CLO_GoodsKind.ObjectId AS GoodsKindId
           FROM _tmpResult
                LEFT JOIN Container ON Container.Id = _tmpResult.ContainerId_to
                LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                              ON CLO_GoodsKind.ContainerId = _tmpResult.ContainerId_to
                                             AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
           WHERE _tmpResult.isDelete    = FALSE
          ) AS tmp
     WHERE _tmpResult.ContainerId_to = tmp.ContainerId_to
       AND _tmpResult.MovementId     = tmp.MovementId
       AND _tmpResult.isDelete       = FALSE;



     -- !!!Проводим но не ВСЁ!!!
     PERFORM gpComplete_Movement_Send (inMovementId     := tmp.MovementId
                                     , inIsLastComplete := NULL
                                     , inSession        := lfGet_User_Session (inUserId))
     FROM (SELECT DISTINCT _tmpResult.MovementId FROM _tmpResult WHERE _tmpResult.isDelete = FALSE AND _tmpResult.MovementId <> 0) AS tmp
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
         , _tmpResult.MovementItemId, _tmpResult.ContainerId_to
         , _tmpResult.OperCount
         , Object_From.ValueData         AS FromName
         , Object_To.ValueData           AS ToName
         , Object_DocumentKind.ValueData AS DocumentKindName
         , Object_Goods.ObjectCode       AS GoodsCode
         , Object_Goods.ValueData        AS GoodsName
         , Object_GoodsKind.ValueData    AS GoodsKindName

    FROM _tmpResult
         LEFT JOIN Movement ON Movement.Id = _tmpResult.MovementId
         LEFT JOIN Container ON Container.Id = _tmpResult.ContainerId_to
         LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                       ON CLO_GoodsKind.ContainerId = _tmpResult.ContainerId_to
                                      AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
         LEFT JOIN Object AS Object_Goods        ON Object_Goods.Id        = Container.ObjectId
         LEFT JOIN Object AS Object_GoodsKind    ON Object_GoodsKind.Id    = CLO_GoodsKind.ObjectId
         LEFT JOIN Object AS Object_From         ON Object_From.Id         = _tmpResult.FromId
         LEFT JOIN Object AS Object_To           ON Object_To.Id           = _tmpResult.ToId
         LEFT JOIN Object AS Object_DocumentKind ON Object_DocumentKind.Id = _tmpResult.DocumentKindId
    ;
    END IF;


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.07.16                                        *
*/

-- тест
-- SELECT * FROM lpUpdate_Movement_Send_DocumentKind (inIsUpdate:= FALSE, inStartDate:= '26.04.2017', inEndDate:= '26.04.2017', inUnitId:= 635388 , inUserId:= zfCalc_UserAdmin() :: Integer) -- Участок нарезки
-- SELECT * FROM lpUpdate_Movement_Send_DocumentKind (inIsUpdate:= TRUE, inStartDate:= '26.04.2017', inEndDate:= '26.04.2017', inUnitId:= 635388 , inUserId:= zfCalc_UserAdmin() :: Integer) -- Участок нарезки
