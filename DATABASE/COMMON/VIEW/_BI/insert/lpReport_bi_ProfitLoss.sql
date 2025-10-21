-- Function: lpReport_bi_ProfitLoss()

DROP FUNCTION IF EXISTS lpReport_bi_ProfitLoss (TDateTime, TDateTime, Integer);

CREATE OR REPLACE FUNCTION lpReport_bi_ProfitLoss(
    IN inStartDate                TDateTime , --
    IN inEndDate                  TDateTime , --
    IN inUserId                   Integer     -- сессия пользователя
)
RETURNS TABLE (ContainerId_pl      Integer,
               -- Дата
               OperDate            TDateTime,
               -- Id документа
               MovementId          Integer,
               -- Вид документа
               MovementDescId      Integer,

               -- № документа
               -- InvNumber           Integer,

               -- Примечание документ
               MovementId_comment  Integer,

               -- Статья ОПиУ
               ProfitLossId            Integer,
               ProfitLossCode          Integer,
               ProfitLossGroupName     TVarChar,
               ProfitLossDirectionName TVarChar,
               ProfitLossName          TVarChar,

               -- Бизнес
               BusinessId         Integer,

               -- Филиал затрат (Філія)
               BranchId_pl         Integer,
               BranchCode_pl       Integer,
               BranchName_pl       TVarChar,

               -- Подразделение затрат (Підрозділ)
               UnitId_pl           Integer,
               UnitCode_pl         Integer,
               UnitName_pl         TVarChar,

               -- Статья УП
               InfoMoneyId Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar,


               -- Подразделение учета (Місце обліку)
               UnitId              Integer,
               -- Оборудование (Направление затрат)
               AssetId             Integer,
               -- Автомобиль (Направление затрат, место учета)
               CarId               Integer,
               -- Сотрудник (Направление затрат, место учета)
               MemberId            Integer,
               -- Статья списания (Стаття списання, Направление затрат)
               ArticleLossId       Integer,

               -- Об'єкт напрявлення
               DirectionId         Integer,
               DirectionCode       Integer,
               DirectionName       TVarChar,
               -- Об'єкт призначення
               DestinationId       Integer,
               DestinationCode     Integer,
               DestinationName     TVarChar,

               -- От кого (место учета) - информативно
               FromId              Integer,
               -- Кому (место учета, Направление затрат) - информативно
               ToId                Integer,

               -- Товар
               GoodsId    Integer,
               -- Вид Товара
               GoodsKindId         Integer,
               -- Вид Товара (только при производстве сырой ПФ)
               GoodsKindId_gp      Integer,

               -- Кол-во (вес)
               OperCount           TFloat,
               -- Кол-во (шт.)
               OperCount_sh        TFloat,
               -- Сумма
               OperSumm            TFloat
              )
AS
$BODY$
BEGIN
     -- Результат
     RETURN QUERY
     WITH --
         tmpMIContainer AS (SELECT MIContainer.ContainerId
                                   --
                                 , MIContainer.OperDate
                                 , MIContainer.MovementId
                                 , MIContainer.MovementItemId
                                 , MIContainer.MovementDescId

                                 , -1 * (MIContainer.Amount) AS Amount

                                   -- Подраделение (ОПиУ)
                                 , CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Transport(), zc_Movement_TransportService())
                                             -- Подраделение (ОПиУ), а могло быть UnitId_Route
                                             THEN MIContainer.ObjectIntId_Analyzer

                                        WHEN MIContainer.MovementDescId IN (zc_Movement_Loss(), zc_Movement_Send())
                                             -- Подраделение кому или...
                                             THEN MIContainer.ObjectExtId_Analyzer

                                        ELSE MIContainer.WhereObjectId_Analyzer

                                   END AS UnitId_pl

                                   -- Назначение (ОПиУ)
                                 , CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Transport())
                                             -- название ГСМ
                                             THEN MIContainer.ObjectIntId_Analyzer

                                        WHEN MIContainer.MovementDescId IN (zc_Movement_TransportService())
                                             -- Кто оказал транспорт-услуги
                                             THEN MovementItem_01.ObjectId

                                        WHEN MIContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_ReturnOut(), zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_SendOnPrice(), zc_Movement_Loss(), zc_Movement_Send(), zc_Movement_Inventory())
                                             -- Товар
                                             THEN MIContainer.ObjectId_Analyzer

                                        WHEN MIContainer.MovementDescId IN (zc_Movement_Cash(), zc_Movement_BankAccount())
                                             -- Касса/ р.счет
                                             THEN MovementItem_01.ObjectId

                                        WHEN MIContainer.MovementDescId IN (zc_Movement_Service(), zc_Movement_ProfitLossService())
                                             -- Кто оказал услуги
                                             THEN MovementItem_01.ObjectId

                                        WHEN MIContainer.MovementDescId IN (zc_Movement_PersonalService())
                                             -- Сотрудник
                                             THEN MIContainer.ObjectIntId_Analyzer

                                        WHEN MIContainer.MovementDescId IN (zc_Movement_PersonalReport())
                                             -- Сотрудник
                                             THEN MovementItem_01.ObjectId

                                        WHEN MIContainer.MovementDescId IN (zc_Movement_MobileBills())
                                             -- К кому привязан телефон
                                             THEN MILO_Employee_01.ObjectId

                                        ELSE 0

                                   END AS DestinationId

                                   -- Направление (ОПиУ)
                                 , CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Loss())
                                             -- Статья списания
                                             THEN MLO_ArticleLoss.ObjectId

                                        WHEN MIContainer.MovementDescId IN (zc_Movement_Transport())
                                             THEN 0

                                        WHEN MIContainer.MovementDescId IN (zc_Movement_TransportService())
                                             -- Маршрут
                                             THEN MILO_Route_01.ObjectId

                                        -- Прочее
                                        ELSE MIContainer.ObjectExtId_Analyzer

                                   END AS DirectionId
                               --, MIContainer.WhereObjectId_Analyzer AS DirectionId

                                   -- УП статья
                                 , MILO_InfoMoney_01.ObjectId AS InfoMoneyId

                                   -- Подразделение учета
                                 , MLO_From.ObjectId         AS UnitId

                                   -- Оборудование (Направление затрат)
                                 , COALESCE (MILO_Asset_1.ObjectId, MLO_Asset_2.ObjectId) AS AssetId

                                   -- Автомобиль (Направление затрат, место учета)
                                 , COALESCE (MILO_Car_1.ObjectId, MLO_Car_2.ObjectId
                                           , CASE WHEN Object_To.DescId   = zc_Object_Car() THEN Object_To.Id   END
                                           , CASE WHEN Object_From.DescId = zc_Object_Car() THEN Object_From.Id END
                                            ) AS CarId

                                   -- Сотрудник (Направление затрат, место учета)
                                 , COALESCE (MILO_Employee_01.ObjectId
                                           , CASE WHEN MIContainer.MovementDescId IN (zc_Movement_PersonalReport()) THEN MovementItem_01.ObjectId END
                                           , CASE WHEN Object_To.DescId   IN (zc_Object_Personal(), zc_Object_Member()) THEN Object_To.Id   END
                                           , CASE WHEN Object_From.DescId IN (zc_Object_Personal(), zc_Object_Member()) THEN Object_From.Id END
                                            ) AS MemberId

                                   -- Статья списания
                                 , MLO_ArticleLoss.ObjectId  AS ArticleLossId

                                   -- не ошибка, распределяется по строкам продажи
                                 , MIContainer.ContainerIntId_analyzer AS MovementItemId_sale_transport

                                 -- От кого
                                 , MLO_From.ObjectId AS FromId
                                 -- Кому
                                 , MLO_To.ObjectId   AS ToId

                                 , CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_ReturnOut(), zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_SendOnPrice(), zc_Movement_Loss(), zc_Movement_Send(), zc_Movement_Inventory())
                                             -- Товар
                                             THEN MIContainer.ObjectId_Analyzer
                                        ELSE 0
                                   END AS GoodsId

                                 , CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_ReturnOut(), zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_SendOnPrice(), zc_Movement_Loss(), zc_Movement_Send(), zc_Movement_Inventory())
                                             -- Товар
                                             THEN MIContainer.ObjectIntId_Analyzer
                                        ELSE 0
                                   END AS GoodsKindId

                                   -- Товар - транспорт
                                 /*, MovementItem_02.ObjectId       AS GoodsId_transport
                                   -- Вид Товара - транспорт
                                 , MILO_GoodsKind_02.ObjectId       AS GoodsKindId_transport*/

                            FROM MovementItemContainer AS MIContainer
                                 LEFT JOIN MovementItem AS MovementItem_01
                                                        ON MovementItem_01.Id = MIContainer.MovementItemId
                                                       AND MovementItem_01.DescId = zc_MI_Master()
                                                       AND MIContainer.MovementDescId IN (zc_Movement_Cash(), zc_Movement_BankAccount(), zc_Movement_Service(), zc_Movement_TransportService()
                                                                                        , zc_Movement_PersonalService(), zc_Movement_ProfitLossService(), zc_Movement_MobileBills()
                                                                                        , zc_Movement_PersonalReport(), zc_Movement_LossPersonal(), zc_Movement_LossDebt()
                                                                                         )
                                 LEFT JOIN MovementItemLinkObject AS MILO_InfoMoney_01
                                                                  ON MILO_InfoMoney_01.MovementItemId = MovementItem_01.Id
                                                                 AND MILO_InfoMoney_01.DescId         = zc_MILinkObject_InfoMoney()

                                 -- К кому привязан телефон
                                 LEFT JOIN MovementItemLinkObject AS MILO_Employee_01
                                                                  ON MILO_Employee_01.MovementItemId = MovementItem_01.Id
                                                                 AND MILO_Employee_01.DescId         = zc_MILinkObject_Employee()
                                                                 AND MIContainer.MovementDescId      IN (zc_Movement_MobileBills())
                                 -- Маршрут
                                 LEFT JOIN MovementItemLinkObject AS MILO_Route_01
                                                                  ON MILO_Route_01.MovementItemId = MovementItem_01.Id
                                                                 AND MILO_Route_01.DescId         = zc_MILinkObject_Route()
                                                                 AND MIContainer.MovementDescId   IN (zc_Movement_TransportService())

                                 -- если Транспорт привязан к продаже ГП
                                 /*LEFT JOIN MovementItem AS MovementItem_02
                                                        ON -- не ошибка, распределяется по строкам продажи
                                                           MovementItem_02.Id = MIContainer.ContainerIntId_analyzer
                                                       AND MovementItem_02.DescId = zc_MI_Master()
                                                       AND MIContainer.MovementDescId IN (zc_Movement_Transport(), zc_Movement_TransportService())
                                 LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind_02
                                                                  ON -- не ошибка, распределяется по строкам продажи
                                                                     MILO_GoodsKind_02.MovementItemId = MIContainer.ContainerIntId_analyzer
                                                                 AND MILO_GoodsKind_02.DescId         = zc_MILinkObject_GoodsKind()
                                                                 --AND 1=0
                                 -- если Транспорт привязан к продаже - Получатель в продаже
                                 LEFT JOIN MovementLinkObject AS MLO_To_02
                                                              ON MLO_To_02.MovementId = MovementItem_02.MovementId
                                                             AND MLO_To_02.DescId     = zc_MovementLinkObject_To()*/

                                 -- Оборудование (Направление затрат)
                                 LEFT JOIN MovementItemLinkObject AS MILO_Asset_1
                                                                  ON MILO_Asset_1.MovementItemId = MIContainer.MovementItemId
                                                                 AND MILO_Asset_1.DescId         = zc_MILinkObject_Asset()
                                 LEFT JOIN MovementLinkObject AS MLO_Asset_2
                                                              ON MLO_Asset_2.MovementId = MIContainer.MovementId
                                                             AND MLO_Asset_2.DescId     = NULL -- zc_MovementLinkObject_Asset()
                                 -- Автомобиль (Направление затрат, место учета)
                                 LEFT JOIN MovementItemLinkObject AS MILO_Car_1
                                                                  ON MILO_Car_1.MovementItemId = MIContainer.MovementItemId
                                                                 AND MILO_Car_1.DescId         = zc_MILinkObject_Car()
                                 LEFT JOIN MovementLinkObject AS MLO_Car_2
                                                              ON MLO_Car_2.MovementId = MIContainer.MovementId
                                                             AND MLO_Car_2.DescId     = zc_MovementLinkObject_Car()



                                 -- Статья списания (Стаття списання, Направление затрат)
                                 LEFT JOIN MovementLinkObject AS MLO_ArticleLoss
                                                              ON MLO_ArticleLoss.MovementId = MIContainer.MovementId
                                                             AND MLO_ArticleLoss.DescId     = zc_MovementLinkObject_ArticleLoss()

                                 -- От кого
                                 LEFT JOIN MovementLinkObject AS MLO_From
                                                              ON MLO_From.MovementId = MIContainer.MovementId
                                                             AND MLO_From.DescId     = zc_MovementLinkObject_From()
                                 LEFT JOIN Object AS Object_From ON Object_From.Id = MLO_From.ObjectId
                                 -- Кому
                                 LEFT JOIN MovementLinkObject AS MLO_To
                                                              ON MLO_To.MovementId = MIContainer.MovementId
                                                             AND MLO_To.DescId     = zc_MovementLinkObject_To()
                                 LEFT JOIN Object AS Object_To ON Object_To.Id = MLO_To.ObjectId

                            WHERE MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                              AND MIContainer.AccountId = zc_Enum_Account_100301()
                              AND MIContainer.isActive = FALSE
                            --AND (MIContainer.MovementId = 20615866 OR vbUserId <> 5)
                            --AND (MIContainer.MovementDescId = zc_Movement_Transport() OR vbUserId <> 5)
                            --AND (MIContainer.ObjectIntId_Analyzer = 8429 or vbUserId <> 5)
                            --AND (MIContainer.MovementId in (25881365, 25834263)  or vbUserId <> 5)
                           )

          , tmpMI_count AS (SELECT MAX (tmpMIContainer.ContainerId) AS ContainerId
                                   --
                                 , MAX (tmpMIContainer.OperDate) AS OperDate
                                 , tmpMIContainer.MovementId
                                 , tmpMIContainer.MovementItemId
                                 , MAX (tmpMIContainer.MovementDescId) AS MovementDescId

                                   -- Подраделение (ОПиУ)
                                 , MAX (tmpMIContainer.UnitId_pl) AS UnitId_pl

                                   -- Назначение (ОПиУ)
                                 , MAX (tmpMIContainer.DestinationId) AS DestinationId

                                   -- Направление (ОПиУ)
                                 , MAX (tmpMIContainer.DirectionId) AS DirectionId

                                   -- УП статья
                                 , MAX (tmpMIContainer.InfoMoneyId) AS InfoMoneyId

                                   -- Подразделение учета
                                 , MAX (tmpMIContainer.UnitId) AS UnitId

                                   -- Оборудование (Направление затрат)
                                 , MAX (tmpMIContainer.AssetId) AS AssetId

                                   -- Автомобиль (Направление затрат, место учета)
                                 , MAX (tmpMIContainer.CarId) AS CarId

                                   -- Сотрудник (Направление затрат, место учета)
                                 , MAX (tmpMIContainer.MemberId) AS MemberId

                                   -- Статья списания
                                 , MAX (tmpMIContainer.ArticleLossId) AS ArticleLossId

                                   -- От кого
                                 , MAX (tmpMIContainer.FromId) AS FromId
                                   -- Кому
                                 , MAX (tmpMIContainer.ToId) AS ToId

                                 , MAX (tmpMIContainer.GoodsId)     AS GoodsId
                                 , MAX (tmpMIContainer.GoodsKindId) AS GoodsKindId

                            FROM tmpMIContainer
                            WHERE tmpMIContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_ReturnOut(), zc_Movement_Sale(), zc_Movement_ReturnIn()
                                                                  , zc_Movement_SendOnPrice(), zc_Movement_Loss(), zc_Movement_Send(), zc_Movement_Inventory()
                                                                   )
                            GROUP BY tmpMIContainer.MovementId
                                   , tmpMIContainer.MovementItemId
                           )
             -- Результат
             SELECT
                     Operation.ContainerId AS ContainerId_pl
                     --
                   , Operation.OperDate :: TDateTime
                   , Operation.MovementId
                   , Operation.MovementDescId

                   , MS_Comment.MovementId AS MovementId_comment

                    -- Статья ОПиУ
                   , View_ProfitLoss.ProfitLossId
                   , View_ProfitLoss.ProfitLossCode
                   , View_ProfitLoss.ProfitLossGroupName
                   , View_ProfitLoss.ProfitLossDirectionName
                   , View_ProfitLoss.ProfitLossName

                     -- Бизнес
                   , CLO_Business.ObjectId AS BusinessId

                     -- Филиал затрат (Філія)
                   , Object_Branch.Id         AS BranchId_pl
                   , Object_Branch.ObjectCode AS BranchCode_pl
                   , Object_Branch.ValueData  AS BranchName_pl

                     -- Подразделение затрат (Підрозділ)
                   , Object_Unit_pl.Id         AS UnitId_pl
                   , Object_Unit_pl.ObjectCode AS UnitCode_pl
                   , Object_Unit_pl.ValueData  AS UnitName_pl

                     -- Статья УП
                   , Object_InfoMoney_View.InfoMoneyId
                   , Object_InfoMoney_View.InfoMoneyGroupName
                   , Object_InfoMoney_View.InfoMoneyDestinationName
                   , Object_InfoMoney_View.InfoMoneyCode
                   , Object_InfoMoney_View.InfoMoneyName
                   , Object_InfoMoney_View.InfoMoneyName_all

                     -- Подразделение учета
                   , Operation.UnitId
                     -- Оборудование (Направление затрат)
                   , Operation.AssetId
                     -- Автомобиль (Направление затрат, место учета)
                   , Operation.CarId
                     -- Сотрудник (Направление затрат, место учета)
                   , Operation.MemberId
                     -- Статья списания
                   , Operation.ArticleLossId

                     -- Направление (ОПиУ)
                   , Object_Direction.Id         AS DirectionId
                   , Object_Direction.ObjectCode AS DirectionCode
                   , Object_Direction.ValueData  AS DirectionName
                     -- Назначение (ОПиУ)
                   , Object_Direction.Id         AS DestinationId
                   , Object_Direction.ObjectCode AS DestinationCode
                   , Object_Direction.ValueData  AS DestinationName

                     -- От кого
                   , Operation.FromId
                     -- Кому
                   , Operation.ToId

                   , Operation.GoodsId
                   , Operation.GoodsKindId
                   , Operation.GoodsKindId_gp :: Integer

                     -- Кол-во (вес)
                   ,  (Operation.OperCount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS OperCount
                     -- Шт.
                   , (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                                THEN Operation.OperCount
                            ELSE 0
                      END) :: TFloat AS OperCount_sh

                     --
                   , Operation.OperSumm :: TFloat

             FROM
                  (-- Суммы
                   SELECT tmpMIContainer.ContainerId
                          --
                        , tmpMIContainer.OperDate
                        , tmpMIContainer.MovementId
                        , tmpMIContainer.MovementDescId

                        , SUM (tmpMIContainer.Amount) AS OperSumm
                        , 0                           AS OperCount

                          -- Подраделение (ОПиУ)
                        , tmpMIContainer.UnitId_pl

                          -- Назначение (ОПиУ)
                        , tmpMIContainer.DestinationId

                          -- Направление (ОПиУ)
                        , tmpMIContainer.DirectionId

                          -- УП статья
                        , tmpMIContainer.InfoMoneyId

                          -- Подразделение учета
                        , tmpMIContainer.UnitId

                          -- Оборудование (Направление затрат)
                        , tmpMIContainer.AssetId

                          -- Автомобиль (Направление затрат, место учета)
                        , tmpMIContainer.CarId

                          -- Сотрудник (Направление затрат, место учета)
                        , tmpMIContainer.MemberId

                          -- Статья списания
                        , tmpMIContainer.ArticleLossId

                          -- От кого
                        , tmpMIContainer.FromId
                          -- Кому
                        , tmpMIContainer.ToId

                        , tmpMIContainer.GoodsId
                        , tmpMIContainer.GoodsKindId
                        , 0 AS GoodsKindId_gp

                   FROM tmpMIContainer
                   GROUP BY tmpMIContainer.ContainerId
                            --
                          , tmpMIContainer.OperDate
                          , tmpMIContainer.MovementId
                          , tmpMIContainer.MovementDescId

                            -- Подраделение (ОПиУ)
                          , tmpMIContainer.UnitId_pl

                            -- Назначение (ОПиУ)
                          , tmpMIContainer.DestinationId

                            -- Направление (ОПиУ)
                          , tmpMIContainer.DirectionId

                            -- УП статья
                          , tmpMIContainer.InfoMoneyId

                            -- Подразделение учета
                          , tmpMIContainer.UnitId

                            -- Оборудование (Направление затрат)
                          , tmpMIContainer.AssetId

                            -- Автомобиль (Направление затрат, место учета)
                          , tmpMIContainer.CarId

                            -- Сотрудник (Направление затрат, место учета)
                          , tmpMIContainer.MemberId

                            -- Статья списания
                          , tmpMIContainer.ArticleLossId

                            -- От кого
                          , tmpMIContainer.FromId
                            -- Кому
                          , tmpMIContainer.ToId

                          , tmpMIContainer.GoodsId
                          , tmpMIContainer.GoodsKindId

                  -- Кол-во
                  UNION ALL
                   SELECT tmpMIContainer.ContainerId
                          --
                        , tmpMIContainer.OperDate
                        , tmpMIContainer.MovementId
                        , tmpMIContainer.MovementDescId

                        , 0 AS OperSumm
                        , -1 * SUM (MIContainer.Amount)    AS OperCount

                          -- Подраделение (ОПиУ)
                        , tmpMIContainer.UnitId_pl

                          -- Назначение (ОПиУ)
                        , tmpMIContainer.DestinationId

                          -- Направление (ОПиУ)
                        , tmpMIContainer.DirectionId

                          -- УП статья
                        , tmpMIContainer.InfoMoneyId

                          -- Подразделение учета
                        , tmpMIContainer.UnitId

                          -- Оборудование (Направление затрат)
                        , tmpMIContainer.AssetId

                          -- Автомобиль (Направление затрат, место учета)
                        , tmpMIContainer.CarId

                          -- Сотрудник (Направление затрат, место учета)
                        , tmpMIContainer.MemberId

                          -- Статья списания
                        , tmpMIContainer.ArticleLossId

                          -- От кого
                        , tmpMIContainer.FromId
                          -- Кому
                        , tmpMIContainer.ToId

                        , tmpMIContainer.GoodsId
                        , tmpMIContainer.GoodsKindId
                        , 0 AS GoodsKindId_gp

                   FROM tmpMI_count AS tmpMIContainer
                        INNER JOIN MovementItemContainer AS MIContainer
                                                         ON MIContainer.MovementId     = tmpMIContainer.MovementId
                                                        AND MIContainer.MovementItemId = tmpMIContainer.MovementItemId
                                                        AND MIContainer.DescId         = zc_MIContainer_Count()
                   GROUP BY tmpMIContainer.ContainerId
                            --
                          , tmpMIContainer.OperDate
                          , tmpMIContainer.MovementId
                          , tmpMIContainer.MovementDescId

                            -- Подраделение (ОПиУ)
                          , tmpMIContainer.UnitId_pl

                            -- Назначение (ОПиУ)
                          , tmpMIContainer.DestinationId

                            -- Направление (ОПиУ)
                          , tmpMIContainer.DirectionId

                            -- УП статья
                          , tmpMIContainer.InfoMoneyId

                            -- Подразделение учета
                          , tmpMIContainer.UnitId

                            -- Оборудование (Направление затрат)
                          , tmpMIContainer.AssetId

                            -- Автомобиль (Направление затрат, место учета)
                          , tmpMIContainer.CarId

                            -- Сотрудник (Направление затрат, место учета)
                          , tmpMIContainer.MemberId

                            -- Статья списания
                          , tmpMIContainer.ArticleLossId

                            -- От кого
                          , tmpMIContainer.FromId
                            -- Кому
                          , tmpMIContainer.ToId

                          , tmpMIContainer.GoodsId
                          , tmpMIContainer.GoodsKindId

                  ) AS Operation

                  LEFT JOIN ContainerLinkObject AS CLO_ProfitLoss
                                                ON CLO_ProfitLoss.ContainerId = Operation.ContainerId
                                               AND CLO_ProfitLoss.DescId      = zc_ContainerLinkObject_ProfitLoss()
                  LEFT JOIN ContainerLinkObject AS CLO_Branch
                                                ON CLO_Branch.ContainerId = Operation.ContainerId
                                               AND CLO_Branch.DescId      =  zc_ContainerLinkObject_Branch()
                  LEFT JOIN ContainerLinkObject AS CLO_Business
                                                ON CLO_Business.ContainerId = Operation.ContainerId
                                               AND CLO_Business.DescId      =  zc_ContainerLinkObject_Business()
                  -- св-ва
                  INNER JOIN Object_ProfitLoss_View AS View_ProfitLoss        ON View_ProfitLoss.ProfitLossId     = CLO_ProfitLoss.ObjectId
                  LEFT JOIN Object                 AS Object_Branch          ON Object_Branch.Id                  = CLO_Branch.ObjectId

                  LEFT JOIN Object                 AS Object_Direction        ON Object_Direction.Id              = Operation.DirectionId
                  LEFT JOIN Object                 AS Object_Destination      ON Object_Destination.Id            = Operation.DestinationId

                  LEFT JOIN Object                 AS Object_Unit_pl         ON Object_Unit_pl.Id                 = Operation.UnitId_pl
                  LEFT JOIN Object_InfoMoney_View  AS Object_InfoMoney_View  ON Object_InfoMoney_View.InfoMoneyId = Operation.InfoMoneyId

                  LEFT JOIN Object                 AS Object_Goods           ON Object_Goods.Id                   = Operation.GoodsId
                  LEFT JOIN Object                 AS Object_GoodsKind       ON Object_GoodsKind.Id               = Operation.GoodsKindId

                  -- Ед.изм. Товара
                  LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                       ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                      AND ObjectLink_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()
                  -- Вес Товара
                  LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                        ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                                       AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()

                  LEFT JOIN MovementString AS MS_Comment
                                           ON MS_Comment.MovementId = Operation.MovementId
                                          AND MS_Comment.DescId     = zc_MovementString_Comment()
                                          AND MS_Comment.ValueData  <> ''

            -- WHERE (Operation.StartAmount <> 0 OR Operation.EndAmount <> 0
               --  OR Operation.DebetSumm <> 0 OR Operation.KreditSumm <> 0)
           ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.09.25                                        *
*/

-- тест
-- SELECT sum (OperCount) as OperCount, sum (OperSumm) as OperSumm, ProfitLossGroupName || ' ' || ProfitLossName FROM lpReport_bi_ProfitLoss (inStartDate:= '01.09.2025', inEndDate:= '01.09.2025', inUserId:= zfCalc_UserAdmin() :: Integer) group by ProfitLossGroupName, ProfitLossName ORDER BY ProfitLossName
