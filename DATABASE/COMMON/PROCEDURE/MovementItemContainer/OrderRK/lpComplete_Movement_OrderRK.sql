-- Function: lpComplete_Movement_OrderRK()

DROP FUNCTION IF EXISTS lpComplete_Movement_OrderRK (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_OrderRK(
    IN inMovementId        Integer   , -- ключ Документа
   OUT outPrinted          Boolean   ,
   OUT outMessageText      Text      ,
    IN inUserId            Integer     -- пользователь
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbOperDate       TDateTime;
   DECLARE vbUnitId_From    Integer;
   DECLARE vbPartnerId_To   Integer;
   DECLARE vbMovementDescId Integer;
   DECLARE vbMovementId_CarInfo Integer;

BEGIN
     -- определили признак
     outPrinted := gpUpdate_Movement_OrderExternal_Print(inId := inMovementId , inNewPrinted := FALSE,  inSession := lfGet_User_Session (inUserId));


     -- Эти параметры нужны
     SELECT Movement.OperDate
          , Movement.DescId
            -- Склад
          , MovementLinkObject_From.ObjectId AS UnitId_From
            -- Кому
          , MovementLinkObject_To.ObjectId   AS PartnerId_To
            INTO vbOperDate, vbMovementDescId, vbUnitId_From, vbPartnerId_To
     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
     WHERE Movement.Id = inMovementId
       AND Movement.DescId = zc_Movement_OrderRK()
       AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
      ;


     -- !!! Розподільчий комплекс
     IF COALESCE (vbUnitId_From, 0) <> zc_Unit_RK()
     THEN
         RAISE EXCEPTION 'Ошибка.Не выбрано подразделение <%>.', lfGet_Object_ValueData_sh (zc_Unit_RK());
         -- RETURN;
     END IF;



     -- заполняем
     IF EXISTS (SELECT 1
                FROM MovementDate
                WHERE MovementDate.MovementId = inMovementId AND MovementDate.DescId = zc_MovementDate_CarInfo()
                  AND (DATE_TRUNC ('DAY', MovementDate.ValueData) = MovementDate.ValueData
                    OR EXTRACT (HOUR FROM MovementDate.ValueData) = 0
                      )
               )
        AND vbUnitId_From = zc_Unit_RK()
        AND inUserId = 5
        AND 1=0
     THEN
         -- Нашли
         vbMovementId_CarInfo:= 0; /*(SELECT MAX (Movement.Id)
                                 FROM Movement
                                      -- Склад такой же
                                      INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                    ON MovementLinkObject_To.MovementId = Movement.Id
                                                                   AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                                                   AND MovementLinkObject_To.ObjectId   = vbUnitId_From
                                      -- Маршрут такой же
                                      INNER JOIN MovementLinkObject AS MovementLinkObject_Route
                                                                    ON MovementLinkObject_Route.MovementId = Movement.Id
                                                                   AND MovementLinkObject_Route.DescId     = zc_MovementLinkObject_Route()
                                                                   AND MovementLinkObject_Route.ObjectId   = vbRouteId
                                      -- установлена дата
                                      INNER JOIN MovementDate AS MovementDate_CarInfo
                                                              ON MovementDate_CarInfo.MovementId = Movement.Id
                                                             AND MovementDate_CarInfo.DescId     = zc_MovementDate_CarInfo()
                                                             AND (MovementDate_CarInfo.ValueData <> DATE_TRUNC ('DAY', MovementDate_CarInfo.ValueData)
                                                               OR EXTRACT (HOUR FROM MovementDate_CarInfo.ValueData) <> 0
                                                                 )
                                      -- Дата такая же
                                      INNER JOIN MovementDate AS MovementDate_OperDatePartner
                                                              ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                                             AND MovementDate_OperDatePartner.DescId     = zc_MovementDate_OperDatePartner()
                                                             AND MovementDate_OperDatePartner.ValueData  = vbOperDatePartner
                                      INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                                   ON MovementLinkObject_From.MovementId = Movement.Id
                                                                  AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                                      LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                           ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                                                          AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                      LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                           ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                                          AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()

                                 WHERE Movement.OperDate = vbOperDate
                                   AND Movement.StatusId = zc_Enum_Status_Complete()
                                   AND Movement.DescId   = zc_Movement_OrderExternal()
                                   AND (ObjectLink_Juridical_Retail.ChildObjectId = vbRetailId    OR COALESCE (vbRetailId, 0)    = 0)
                                   AND (MovementLinkObject_From.ObjectId          = vbUnitId_From OR COALESCE (vbUnitId_From, 0) = 0)
                                );*/

         -- RAISE EXCEPTION 'Ошибка.%', vbMovementId_CarInfo;

         -- Если нашли
       /*IF vbMovementId_CarInfo > 0
         THEN
             -- заполняем
             PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_CarInfo(), inMovementId, tmp.OperDate_CarInfo)        -- Дата/время отгрузки
                   , lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_CarInfo(), inMovementId, tmp.CarInfoId)   -- Информация по отгрузке
                   , lpInsertUpdate_MovementString (zc_MovementString_CarComment(), inMovementId, tmp.CarComment)       -- примечание к отгрузке
             FROM (SELECT MovementDate_CarInfo.ValueData      AS OperDate_CarInfo
                        , MovementLinkObject_CarInfo.ObjectId AS CarInfoId
                        , MovementString_CarComment.ValueData AS CarComment
                   FROM MovementDate AS MovementDate_CarInfo

                        LEFT JOIN MovementLinkObject AS MovementLinkObject_CarInfo
                                                     ON MovementLinkObject_CarInfo.MovementId = MovementDate_CarInfo.MovementId
                                                    AND MovementLinkObject_CarInfo.DescId     = zc_MovementLinkObject_CarInfo()
                        LEFT JOIN MovementString AS MovementString_CarComment
                                                 ON MovementString_CarComment.MovementId = MovementDate_CarInfo.MovementId
                                                AND MovementString_CarComment.DescId     = zc_MovementString_CarComment()

                   WHERE MovementDate_CarInfo.MovementId = vbMovementId_CarInfo
                     AND MovementDate_CarInfo.DescId     = zc_MovementDate_CarInfo()
                  ) AS tmp;
         ELSE
             -- заполняем
             PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_CarInfo(), inMovementId, tmp.OperDate_CarInfo)        -- Дата/время отгрузки
             FROM (SELECT COALESCE (
                                    (SELECT -- !!!Дата/время отгрузки - Расчет!!!
                                           (vbOperDatePartner
                                          + ((CASE WHEN ObjectFloat_Days.ValueData > 0 THEN  1 * ObjectFloat_Days.ValueData ELSE 0 END :: Integer) :: TVarChar || ' DAY') :: INTERVAL
                                          - ((CASE WHEN ObjectFloat_Days.ValueData < 0 THEN -1 * ObjectFloat_Days.ValueData ELSE 0 END :: Integer) :: TVarChar || ' DAY') :: INTERVAL
                                          + ((COALESCE (ObjectFloat_Hour.ValueData, 0) :: Integer) :: TVarChar || ' HOUR')   :: INTERVAL
                                          + ((COALESCE (ObjectFloat_Min.ValueData, 0)  :: Integer) :: TVarChar || ' MINUTE') :: INTERVAL
                                           ) :: TDateTime
                                    FROM Object AS Object_OrderCarInfo
                                         LEFT JOIN ObjectLink AS ObjectLink_Route
                                                              ON ObjectLink_Route.ObjectId = Object_OrderCarInfo.Id
                                                             AND ObjectLink_Route.DescId   = zc_ObjectLink_OrderCarInfo_Route()
                                         LEFT JOIN ObjectLink AS ObjectLink_Retail
                                                              ON ObjectLink_Retail.ObjectId = Object_OrderCarInfo.Id
                                                             AND ObjectLink_Retail.DescId   = zc_ObjectLink_OrderCarInfo_Retail()

                                         INNER JOIN ObjectLink AS ObjectLink_Unit
                                                               ON ObjectLink_Unit.ObjectId      = Object_OrderCarInfo.Id
                                                              AND ObjectLink_Unit.DescId        = zc_ObjectLink_OrderCarInfo_Unit()
                                                              AND ObjectLink_Unit.ChildObjectId = vbUnitId_from

                                         INNER JOIN ObjectFloat AS ObjectFloat_OperDate
                                                                ON ObjectFloat_OperDate.ObjectId  = Object_OrderCarInfo.Id
                                                               AND ObjectFloat_OperDate.DescId    = zc_ObjectFloat_OrderCarInfo_OperDate()
                                                               AND ObjectFloat_OperDate.ValueData =  zfCalc_DayOfWeekNumber (vbOperDate)
                                         INNER JOIN ObjectFloat AS ObjectFloat_OperDatePartner
                                                                ON ObjectFloat_OperDatePartner.ObjectId  = Object_OrderCarInfo.Id
                                                               AND ObjectFloat_OperDatePartner.DescId    = zc_ObjectFloat_OrderCarInfo_OperDatePartner()
                                                               AND ObjectFloat_OperDatePartner.ValueData = zfCalc_DayOfWeekNumber (vbOperDatePartner)

                                         LEFT JOIN ObjectFloat AS ObjectFloat_Days
                                                               ON ObjectFloat_Days.ObjectId = Object_OrderCarInfo.Id
                                                              AND ObjectFloat_Days.DescId = zc_ObjectFloat_OrderCarInfo_Days()
                                         LEFT JOIN ObjectFloat AS ObjectFloat_Hour
                                                               ON ObjectFloat_Hour.ObjectId = Object_OrderCarInfo.Id
                                                              AND ObjectFloat_Hour.DescId = zc_ObjectFloat_OrderCarInfo_Hour()
                                         LEFT JOIN ObjectFloat AS ObjectFloat_Min
                                                               ON ObjectFloat_Min.ObjectId = Object_OrderCarInfo.Id
                                                              AND ObjectFloat_Min.DescId = zc_ObjectFloat_OrderCarInfo_Min()
                                    WHERE Object_OrderCarInfo.DescId   = zc_Object_OrderCarInfo()
                                      AND Object_OrderCarInfo.isErased = FALSE
                                      AND COALESCE (ObjectLink_Route.ChildObjectId, 0)  = COALESCE (vbRouteId, 0)
                                      AND (ObjectLink_Retail.ChildObjectId = vbRetailId    OR COALESCE (vbRetailId, 0) = 0)
                                      AND (ObjectLink_Retail.ChildObjectId = vbUnitId_From OR COALESCE (vbUnitId_From, 0) = 0)
                                    ORDER BY ObjectFloat_Hour.ValueData DESC
                                    LIMIT 1
                                   )
                                 , MovementDate_CarInfo.ValueData
                                  ) AS OperDate_CarInfo
                   FROM MovementDate AS MovementDate_CarInfo
                   WHERE MovementDate_CarInfo.MovementId = inMovementId
                     AND MovementDate_CarInfo.DescId     = zc_MovementDate_CarInfo()
                  ) AS tmp;
         END IF;*/

     END IF;

     -- заполняем
     IF vbUnitId_From = zc_Unit_RK()
 --AND vbOperDate = (SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = inMovementId AND MD.DescId = zc_MovementDate_CarInfo())
     THEN
         IF 1=0 --vbIsSamoV = TRUE
         THEN
             -- Дата/время отгрузки
             PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_CarInfo(), inMovementId, vbOperDate + INTERVAL '1 DAY' + INTERVAL '0 MIN');
       /*ELSE
             -- Дата/время отгрузки
             PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_CarInfo(), inMovementId, vbOperDate + INTERVAL '1 DAY' + INTERVAL '0 MIN');*/
         END IF;
     END IF;


     -- Если надо "выровнять" остатки = после инвентаризации, или ....
     IF vbUnitId_From = vbPartnerId_To
     THEN
         WITH tmpGoods AS (SELECT Object_Goods.Id AS GoodsId
                           FROM ObjectLink AS ObjectLink_Goods_InfoMoney
                                JOIN Object AS Object_Goods ON Object_Goods.Id       = ObjectLink_Goods_InfoMoney.ObjectId
                                                           AND Object_Goods.isErased = FALSE
                                INNER JOIN Object_InfoMoney_View AS View_InfoMoney
                                                                 ON View_InfoMoney.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
                                                                AND View_InfoMoney.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900() -- Ирна
                                                                                                            , zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                                                                                             )

                           WHERE ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                          )
              -- Остатки Факт
            , tmpRem_real AS (SELECT tmpRem.GoodsId
                                   , tmpRem.GoodsKindId
                                   , SUM (tmpRem.Amount) AS Amount
                              FROM (SELECT Container.ObjectId     AS GoodsId
                                         , COALESCE (CLO_GoodsKind.ObjectId, 0) AS GoodsKindId
                                         , Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS Amount
                                    FROM ContainerLinkObject
                                         INNER JOIN Container ON Container.Id       = ContainerLinkObject.ContainerId
                                                             AND Container.DescId   = zc_Container_Count()
                                                             AND Container.ObjectId IN (SELECT DISTINCT tmpGoods.GoodsId FROM tmpGoods)
                                         LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                                                       ON CLO_GoodsKind.ContainerId = Container.Id
                                                                      AND CLO_GoodsKind.DescId      = zc_ContainerLinkObject_GoodsKind()
                                         LEFT JOIN MovementItemContainer AS MIContainer
                                                                         ON MIContainer.ContainerId = Container.Id
                                                                        -- Обязательно дата в док inMovementId = дате в док.Инвент.
                                                                        AND MIContainer.OperDate    > vbOperDate
                                    WHERE ContainerLinkObject.ObjectId = vbUnitId_From
                                      AND ContainerLinkObject.DescId = zc_ContainerLinkObject_Unit()
                                    GROUP BY Container.Id
                                           , Container.ObjectId
                                           , CLO_GoodsKind.ObjectId
                                           , Container.Amount
                                    HAVING Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0
                                   ) AS tmpRem
                              GROUP BY tmpRem.GoodsId
                                     , tmpRem.GoodsKindId
                              HAVING  SUM (tmpRem.Amount) <> 0
                             )

              -- Остатки Вирт
            , tmpRem_virt AS (SELECT tmpRem.GoodsId
                                   , tmpRem.GoodsKindId
                                   , SUM (tmpRem.Amount) AS Amount
                              FROM (SELECT Container.ObjectId     AS GoodsId
                                         , COALESCE (CLO_GoodsKind.ObjectId, 0) AS GoodsKindId
                                         , Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS Amount
                                    FROM ContainerLinkObject
                                         INNER JOIN Container ON Container.Id       = ContainerLinkObject.ContainerId
                                                             AND Container.DescId   = zc_Container_CountVirt()
                                                             AND Container.ObjectId IN (SELECT DISTINCT tmpGoods.GoodsId FROM tmpGoods)
                                         LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                                                       ON CLO_GoodsKind.ContainerId = Container.Id
                                                                      AND CLO_GoodsKind.DescId      = zc_ContainerLinkObject_GoodsKind()
                                         LEFT JOIN MovementItemContainer AS MIContainer
                                                                         ON MIContainer.ContainerId = Container.Id
                                                                        -- Обязательно дата в док inMovementId = дате в док.Инвент.
                                                                        AND MIContainer.OperDate    > vbOperDate
                                    WHERE ContainerLinkObject.ObjectId = vbUnitId_From
                                      AND ContainerLinkObject.DescId = zc_ContainerLinkObject_Unit()
                                    GROUP BY Container.Id
                                           , Container.ObjectId
                                           , CLO_GoodsKind.ObjectId
                                           , Container.Amount
                                    HAVING Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0
                                   ) AS tmpRem
                              GROUP BY tmpRem.GoodsId
                                     , tmpRem.GoodsKindId
                              HAVING  SUM (tmpRem.Amount) <> 0
                             )
         -- Результат
         INSERT INTO _tmpItem (MovementItemId, ContainerId_Goods, GoodsId, GoodsKindId, OperCount)
            SELECT 0                                                                   AS MovementItemId
                 , 0                                                                   AS ContainerId_Goods
                 , COALESCE (tmpRem_real.GoodsId, tmpRem_virt.GoodsId)                 AS GoodsId
                 , COALESCE (tmpRem_real.GoodsKindId, tmpRem_virt.GoodsKindId)         AS GoodsKindId
                 , -1 * (COALESCE (tmpRem_real.Amount, 0) - COALESCE (tmpRem_virt.Amount, 0)) AS OperCount
            FROM tmpRem_real
                 FULL JOIN tmpRem_virt ON tmpRem_virt.GoodsId     = tmpRem_real.GoodsId
                                      AND tmpRem_virt.GoodsKindId = tmpRem_real.GoodsKindId
                                     ;
         -- Результат
         UPDATE _tmpItem SET MovementItemId = lpInsertUpdate_MovementItem_OrderRK (ioId           := 0
                                                                                 , inMovementId   := inMovementId
                                                                                 , inGoodsId      := _tmpItem.GoodsId
                                                                                 , inGoodsKindId  := _tmpItem.GoodsKindId
                                                                                 , inAmount       := _tmpItem.OperCount
                                                                                 , inUserId       := inUserId
                                                                                  );



     ELSE
         -- заполняем таблицу - количественные элементы документа, со всеми свойствами
         INSERT INTO _tmpItem (MovementItemId, ContainerId_Goods, GoodsId, GoodsKindId, OperCount)
            SELECT MovementItem.Id                                                                   AS MovementItemId
                 , 0                                                                                 AS ContainerId_Goods
                 , COALESCE (MILinkObject_Goods_in.ObjectId, MovementItem.ObjectId)                  AS GoodsId
                 , COALESCE (MILinkObject_GoodsKind_in.ObjectId, MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                 , (MovementItem.Amount)                                                             AS OperCount
            FROM Movement
                 JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master() AND MovementItem.isErased = FALSE
                 LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                  ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                 AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                 LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods_in
                                                  ON MILinkObject_Goods_in.MovementItemId = MovementItem.Id
                                                 AND MILinkObject_Goods_in.DescId         = zc_MILinkObject_Goods_in()
                 LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind_in
                                                  ON MILinkObject_GoodsKind_in.MovementItemId = MovementItem.Id
                                                 AND MILinkObject_GoodsKind_in.DescId         = zc_MILinkObject_GoodsKind_in()

            WHERE Movement.Id = inMovementId
              AND Movement.DescId = zc_Movement_OrderRK()
              AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
           ;

     END IF;


     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     -- !!! Ну а теперь - ПРОВОДКИ !!!
     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

     -- 1.1. определяется ContainerId_Goods для количественного учета
     UPDATE _tmpItem SET ContainerId_Goods = lpInsertUpdate_ContainerCount_Virt (inOperDate               := vbOperDate
                                                                               , inUnitId                 := vbUnitId_From
                                                                               , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                               , inInfoMoneyId            := _tmpItem.InfoMoneyId
                                                                               , inGoodsId                := _tmpItem.GoodsId
                                                                               , inGoodsKindId            := _tmpItem.GoodsKindId
                                                                                 );


     -- 1.2. формируются Проводки для количественного учета, !!!после прибыли, т.к. нужен ContainerId_ProfitLoss!!!
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId --, ParentId, Amount, OperDate, IsActive)
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       -- это обычная проводка - zc_Container_CountVirt
       SELECT 0, zc_MIContainer_CountVirt() AS DescId, vbMovementDescId, inMovementId, _tmpItem.MovementItemId
            , _tmpItem.ContainerId_Goods
            , 0                                       AS AccountId              -- нет счета
            , 0                                       AS AnalyzerId             -- нет аналитика
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer      -- Товар
            , vbUnitId_From                           AS WhereObjectId_Analyzer -- Подраделение или...
              -- Контейнер ОПиУ - ИЛИ Контейнер Юр.Лицо - перевыставление
            , 0                                       AS ContainerId_Analyzer
            , _tmpItem.GoodsKindId                    AS ObjectIntId_Analyzer   -- вид товара
            , vbPartnerId_To                          AS ObjectExtId_Analyzer   -- Филиал кому или Покупатель
            , 0                                       AS ParentId
            , -1 * _tmpItem.OperCount
            , vbOperDate
            , FALSE
       FROM _tmpItem
      ;


     -- RAISE EXCEPTION 'Ошибка.<%>', (select COUNT(*) from _tmpItem where ContainerId_Goods > 0);


     -- 6.1. ФИНИШ - Обязательно сохраняем Проводки
     PERFORM lpInsertUpdate_MovementItemContainer_byTable();


     -- ФИНИШ - Обязательно меняем статус документа + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_OrderRK()
                                , inUserId     := inUserId
                                 );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 21.04.17                                        *
*/

-- тест
-- SELECT * FROM gpUpdate_Status_OrderRK(inMovementId := 35201623 , inStatusCode := 2 ,  inSession := '5');
