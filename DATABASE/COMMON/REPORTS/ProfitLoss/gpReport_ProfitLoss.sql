-- Function: gpReport_ProfitLoss()

DROP FUNCTION IF EXISTS gpReport_ProfitLoss (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_ProfitLoss(
    IN inStartDate   TDateTime , --
    IN inEndDate     TDateTime , --
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE (ProfitLossGroupName TVarChar, ProfitLossDirectionName TVarChar, ProfitLossName  TVarChar
             , PL_GroupName_original TVarChar, PL_DirectionName_original TVarChar, PL_Name_original  TVarChar
             , OnComplete Boolean
             , BusinessName TVarChar, JuridicalName_Basis TVarChar, BranchName_ProfitLoss TVarChar
             , UnitId_ProfitLoss Integer, UnitName_ProfitLoss TVarChar
             , UnitDescId Integer, UnitDescName TVarChar
             , InfoMoneyGroupCode Integer, InfoMoneyDestinationCode Integer, InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar
             , InfoMoneyGroupCode_Detail Integer, InfoMoneyDestinationCode_Detail Integer, InfoMoneyCode_Detail Integer, InfoMoneyGroupName_Detail TVarChar, InfoMoneyDestinationName_Detail TVarChar, InfoMoneyName_Detail TVarChar
             , DirectionObjectCode Integer, DirectionObjectName TVarChar, DirectionDescName TVarChar
             , DestinationObjectId Integer, DestinationObjectCode Integer, DestinationObjectName TVarChar
             , DestinationDescId Integer, DestinationDescName TVarChar
             , MovementDescId Integer, MovementDescName TVarChar
             , Amount TFloat

             , Amount_Dn  TFloat    -- Днепр
             , Amount_Kh  TFloat    -- Харьков
             , Amount_Od  TFloat    -- Одесса
             , Amount_Zp  TFloat    -- Запорожье
             , Amount_Kv  TFloat    -- Киев
             , Amount_Kr  TFloat    -- Кр.Рог
             , Amount_Nik TFloat    -- Николаев
             , Amount_Ch  TFloat    -- Черкассы
             , Amount_Lv  TFloat    -- Львов
             , Amount_0   TFloat    -- без филиала

             , ProfitLossGroup_dop Integer   -- дополнительная группировка
             
             , LocationName TVarChar -- место учета
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsUserRole_8813637 Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_ProfitLoss());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

     -- !!!Проверка прав роль - Ограничение - нет вообще доступа к просмотру данных ЗП!!!
     vbIsUserRole_8813637:= EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE ObjectLink_UserRole_View.UserId = vbUserId AND ObjectLink_UserRole_View.RoleId = 8813637)
                         -- или если Ограничение - нет доступа к просмотру ведомость Админ ЗП
                         OR EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE ObjectLink_UserRole_View.UserId = vbUserId AND ObjectLink_UserRole_View.RoleId = 11026035)
                           ;


     -- Ограниченние - нет доступа к ОПиУ
     IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE ObjectLink_UserRole_View.UserId = vbUserId AND ObjectLink_UserRole_View.RoleId = 10657330)
     THEN
         RAISE EXCEPTION 'Ошибка.Нет прав к отчету ОПиУ.';
     END IF;

     -- Блокируем ему просмотр
     IF vbUserId = 9457 -- Климентьев К.И.
     THEN
         vbUserId:= NULL;
         RETURN;
     END IF;


     --
   /*CREATE TEMP TABLE tmpMIContainer_Transport ON COMMIT DROP
                                 AS (SELECT DISTINCT MIContainer.ContainerIntId_analyzer AS MovementItemId
                                     FROM MovementItemContainer AS MIContainer
                                     WHERE MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                       AND MIContainer.AccountId = zc_Enum_Account_100301()
                                       AND MIContainer.isActive = FALSE
                                       AND MIContainer.MovementDescId IN (zc_Movement_Transport(), zc_Movement_TransportService())
                                    );
     RAISE EXCEPTION 'Ошибка.<%>', (select count(*) from tmpMIContainer_Transport);

     CREATE TEMP TABLE tmpMI_Transport ON COMMIT DROP
                         AS (SELECT MovementItem.*
                             FROM MovementItem
                             WHERE MovementItem.Id IN (SELECT DISTINCT tmpMIContainer_Transport.MovementItemId FROM tmpMIContainer_Transport)
                            );

     RAISE EXCEPTION 'Ошибка.<%>', (select count(*) from tmpMI_Transport);*/

     -- Результат
     RETURN QUERY
      -- ??? как сделать что б не попали операции переброски накопленной прибыль прошлого месяца в долг по прибыли???
      WITH /*tmpContainer AS (SELECT ReportContainerLink.ReportContainerId
                                 -- , ReportContainerLink.ChildContainerId   AS ContainerId_inf
                                 , CLO_Branch.ObjectId                    AS BranchId_ProfitLoss
                                 , CLO_ProfitLoss.ObjectId                AS ProfitLossId
                                 , CLO_Business.ObjectId                  AS BusinessId
                                 , CLO_JuridicalBasis.ObjectId            AS JuridicalId_Basis
                                 , ContainerLinkObject_InfoMoney.ObjectId AS InfoMoneyId_inf
                            FROM Container
                                 INNER JOIN ReportContainerLink ON ReportContainerLink.ContainerId = Container.Id
                                 LEFT JOIN ContainerLinkObject AS CLO_Branch
                                                               ON CLO_Branch.ContainerId = Container.Id
                                                              AND CLO_Branch.DescId = zc_ContainerLinkObject_Branch()
                                 LEFT JOIN ContainerLinkObject AS CLO_ProfitLoss
                                                               ON CLO_ProfitLoss.ContainerId = Container.Id
                                                              AND CLO_ProfitLoss.DescId = zc_ContainerLinkObject_ProfitLoss()
                                 LEFT JOIN ContainerLinkObject AS CLO_Business
                                                               ON CLO_Business.ContainerId = Container.Id
                                                              AND CLO_Business.DescId = zc_ContainerLinkObject_Business()
                                 LEFT JOIN ContainerLinkObject AS CLO_JuridicalBasis
                                                               ON CLO_JuridicalBasis.ContainerId = Container.Id
                                                              AND CLO_JuridicalBasis.DescId = zc_ContainerLinkObject_JuridicalBasis()

                                 LEFT JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoney
                                                               ON ContainerLinkObject_InfoMoney.ContainerId = ReportContainerLink.ChildContainerId
                                                              AND ContainerLinkObject_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                            WHERE Container.ObjectId = zc_Enum_Account_100301() -- 100301; "прибыль текущего периода"
                              AND Container.DescId = zc_Container_Summ()
                           )*/
      /*tmpMIContainer_Transport AS (SELECT DISTINCT MIContainer.ContainerIntId_analyzer AS MovementItemId
                                     FROM MovementItemContainer AS MIContainer
                                     WHERE MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                       AND MIContainer.AccountId = zc_Enum_Account_100301()
                                       AND MIContainer.isActive = FALSE
                                       AND MIContainer.MovementDescId IN (zc_Movement_Transport(), zc_Movement_TransportService())
                                    )
       , tmpMI_Transport AS (SELECT MovementItem.*
                             FROM MovementItem
                             WHERE MovementItem.Id IN (SELECT DISTINCT tmpMIContainer_Transport.MovementItemId FROM tmpMIContainer_Transport)
                            )
       , tmpMLO_To_Transport AS (SELECT MLO_To.*
                                 FROM MovementLinkObject AS MLO_To
                                 WHERE MLO_To.MovementId IN (SELECT DISTINCT tmpMI_Transport.MovementId FROM tmpMI_Transport)
                                   AND MLO_To.DescId = zc_MovementLinkObject_To()
                                )
       , tmpMILO_GoodsKind_Transport AS (SELECT MILO_GoodsKind.*
                                         FROM MovementItemLinkObject AS MILO_GoodsKind
                                         WHERE MILO_GoodsKind.MovementItemId IN (SELECT DISTINCT tmpMI_Transport.Id FROM tmpMI_Transport)
                                           AND MILO_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                        )
       ,*/ tmpMIContainer AS (SELECT MIContainer.ContainerId
                                 , -1 * SUM (MIContainer.Amount)      AS Amount

                                   -- Подраделение (ОПиУ)
                                 , CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Transport(), zc_Movement_TransportService())
                                             THEN MIContainer.ObjectIntId_Analyzer
                                        WHEN MIContainer.MovementDescId IN (zc_Movement_Loss())
                                             THEN MIContainer.ObjectExtId_Analyzer
                                        ELSE MIContainer.WhereObjectId_Analyzer
                                   END AS UnitId_ProfitLoss
                                   -- Назначение (ОПиУ)
                                 , CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Transport(),  zc_Movement_PersonalService())
                                             THEN CASE WHEN MIContainer.ContainerIntId_analyzer > 0 AND MIContainer.MovementDescId = zc_Movement_Transport()
                                                       THEN MovementItem_2.ObjectId
                                                       ELSE MIContainer.ObjectIntId_Analyzer
                                                  END
                                        WHEN MIContainer.MovementDescId IN (zc_Movement_TransportService())
                                             THEN CASE WHEN MIContainer.ContainerIntId_analyzer > 0
                                                       THEN MovementItem_2.ObjectId
                                                       ELSE MovementItem_1.ObjectId
                                                  END
                                        WHEN MIContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_ReturnOut(), zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_SendOnPrice(), zc_Movement_Loss(), zc_Movement_Send(), zc_Movement_Inventory())
                                             THEN MIContainer.ObjectId_Analyzer
                                        WHEN MIContainer.MovementDescId IN (zc_Movement_Cash(), zc_Movement_BankAccount(), zc_Movement_Service(), zc_Movement_ProfitLossService(), zc_Movement_MobileBills())
                                             THEN MovementItem_1.ObjectId -- MIContainer.ObjectId_Analyzer
                                        ELSE 0
                                   END AS ObjectId_inf

                                   -- Направление (ОПиУ)
                                 , CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Transport(),  zc_Movement_TransportService())
                                         AND MIContainer.ContainerIntId_analyzer > 0
                                             THEN MLO_To.ObjectId
                                        ELSE MIContainer.ObjectExtId_Analyzer
                                   END AS DirectionId
                               --, MIContainer.WhereObjectId_Analyzer AS DirectionId
                                   --
                                 , MIContainer.MovementDescId
                                   -- УП статья
                                 , MILinkObject_InfoMoney.ObjectId AS InfoMoney_inf

                                   -- Вид Товара
                                 , MILO_GoodsKind.ObjectId AS GoodsKindId_inf
                                 
                                 --место учето для статьи , док списания
                                 , MovementLinkObject_From.ObjectId AS FromId

                            FROM MovementItemContainer AS MIContainer
                                 LEFT JOIN MovementItem AS MovementItem_1
                                                                  ON MovementItem_1.Id = MIContainer.MovementItemId
                                                                 AND MovementItem_1.DescId = zc_MI_Master()
                                                                 AND MIContainer.MovementDescId IN (zc_Movement_Cash(), zc_Movement_BankAccount(), zc_Movement_Service(), zc_Movement_PersonalService(), zc_Movement_ProfitLossService(), zc_Movement_MobileBills(), zc_Movement_TransportService(), zc_Movement_PersonalReport(), zc_Movement_LossPersonal(), zc_Movement_LossDebt())
                                 LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                                  ON MILinkObject_InfoMoney.MovementItemId = MovementItem_1.Id
                                                                 AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                                 /*LEFT JOIN MovementItemLinkObject AS MILinkObject_Route
                                                                  ON MILinkObject_Route.MovementItemId = MIContainer .MovementItemId
                                                                 AND MILinkObject_Route.DescId = zc_MILinkObject_Route()
                                                                 AND MIContainer.MovementDescId = zc_Movement_Transport()*/
                                 LEFT JOIN MovementItem AS MovementItem_2
                                                        ON MovementItem_2.Id = MIContainer.ContainerIntId_analyzer
                                                       AND MovementItem_2.DescId = zc_MI_Master()
                                                       AND MIContainer.MovementDescId IN (zc_Movement_Transport(), zc_Movement_TransportService())
                                 LEFT JOIN MovementLinkObject AS MLO_To
                                                              ON MLO_To.MovementId = MovementItem_2.MovementId
                                                             AND MLO_To.DescId     = zc_MovementLinkObject_To()
                                 LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                                                  ON MILO_GoodsKind.MovementItemId = MovementItem_2.Id
                                                                 AND MILO_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                                                                 AND 1=0

                                 /*LEFT JOIN MovementItemLinkObject AS MILinkObject_Route
                                                                  ON MILinkObject_Route.MovementItemId = MIContainer .MovementItemId
                                                                 AND MILinkObject_Route.DescId = zc_MILinkObject_Route()
                                                                 AND MIContainer.MovementDescId = zc_Movement_Transport()*/
                               /*LEFT JOIN tmpMI_Transport AS MovementItem_2
                                                           ON MovementItem_2.Id = MIContainer.ContainerIntId_analyzer
                                                          AND MovementItem_2.DescId = zc_MI_Master()
                                                          AND MIContainer.MovementDescId IN (zc_Movement_Transport(), zc_Movement_TransportService())
                                 LEFT JOIN tmpMLO_To_Transport AS MLO_To
                                                               ON MLO_To.MovementId          = MovementItem_2.MovementId
                                                              AND MLO_To.DescId              = zc_MovementLinkObject_To()
                                 LEFT JOIN tmpMILO_GoodsKind_Transport AS MILO_GoodsKind
                                                                       ON MILO_GoodsKind.MovementItemId = MovementItem_2.Id
                                                                      AND MILO_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                                                                      AND 1=0*/
                                 --для статьи определяем место учета по документу (от кого)
                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                              ON MovementLinkObject_From.MovementId = MIContainer.MovementId
                                                             AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

                            WHERE MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                              AND MIContainer.AccountId = zc_Enum_Account_100301()
                              AND MIContainer.isActive = FALSE
                            --AND (MIContainer.MovementId = 20615866 OR vbUserId <> 5)
                            --AND (MIContainer.MovementDescId = zc_Movement_Transport() OR vbUserId <> 5)
                            --AND (MIContainer.ObjectIntId_Analyzer = 8429 or vbUserId <> 5)
                            --AND (MIContainer.MovementId in (25881365, 25834263)  or vbUserId <> 5)

                            GROUP BY MIContainer.ContainerId
                                     -- Подраделение (ОПиУ)
                                   , CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Transport(), zc_Movement_TransportService())
                                               THEN MIContainer.ObjectIntId_Analyzer
                                          WHEN MIContainer.MovementDescId IN (zc_Movement_Loss())
                                               THEN MIContainer.ObjectExtId_Analyzer
                                          ELSE MIContainer.WhereObjectId_Analyzer
                                     END
                                     -- Назначение (ОПиУ)
                                   , CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Transport(),  zc_Movement_PersonalService())
                                               THEN CASE WHEN MIContainer.ContainerIntId_analyzer > 0 AND MIContainer.MovementDescId = zc_Movement_Transport()
                                                         THEN MovementItem_2.ObjectId
                                                         ELSE MIContainer.ObjectIntId_Analyzer
                                                    END
                                          WHEN MIContainer.MovementDescId IN (zc_Movement_TransportService())
                                               THEN CASE WHEN MIContainer.ContainerIntId_analyzer > 0
                                                         THEN MovementItem_2.ObjectId
                                                         ELSE MovementItem_1.ObjectId
                                                    END
                                          WHEN MIContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_ReturnOut(), zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_SendOnPrice(), zc_Movement_Loss(), zc_Movement_Send(), zc_Movement_Inventory())
                                               THEN MIContainer.ObjectId_Analyzer
                                          WHEN MIContainer.MovementDescId IN (zc_Movement_Cash(), zc_Movement_BankAccount(), zc_Movement_Service(), zc_Movement_ProfitLossService(), zc_Movement_MobileBills())
                                               THEN MovementItem_1.ObjectId -- MIContainer.ObjectId_Analyzer
                                          ELSE 0
                                     END

                                     -- Направление (ОПиУ)
                                   , CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Transport(),  zc_Movement_TransportService())
                                           AND MIContainer.ContainerIntId_analyzer > 0
                                               THEN MLO_To.ObjectId
                                          ELSE MIContainer.ObjectExtId_Analyzer
                                     END
                                 --, MIContainer.WhereObjectId_Analyzer
                                     --
                                   , MIContainer.MovementDescId
                                     -- УП статья
                                   , MILinkObject_InfoMoney.ObjectId

                                     -- Вид Товара
                                   , MILO_GoodsKind.ObjectId
                                   -- от кого
                                   , MovementLinkObject_From.ObjectId
                           )
        , tmpProfitLoss AS (SELECT CLO_Branch.ObjectId                    AS BranchId_ProfitLoss
                                 , CLO_ProfitLoss.ObjectId                AS ProfitLossId
                                 , CLO_Business.ObjectId                  AS BusinessId
                                 , CLO_JuridicalBasis.ObjectId            AS JuridicalId_Basis
                                 , CASE WHEN tmpMIContainer.InfoMoney_inf > 0 THEN tmpMIContainer.InfoMoney_inf ELSE COALESCE (OL_Goods_InfoMoney.ChildObjectId, 0) END AS InfoMoneyId_inf
                                 , tmpMIContainer.MovementDescId
                                 , tmpMIContainer.DirectionId
                                 , tmpMIContainer.UnitId_ProfitLoss
                                 , tmpMIContainer.ObjectId_inf
                                 , tmpMIContainer.GoodsKindId_inf
                                 , tmpMIContainer.FromId
                                 , SUM (tmpMIContainer.Amount) AS Amount
                            FROM tmpMIContainer
                                 LEFT JOIN ObjectLink AS OL_Goods_InfoMoney
                                                      ON OL_Goods_InfoMoney.ObjectId = tmpMIContainer.ObjectId_inf
                                                     AND OL_Goods_InfoMoney.DescId   = zc_ObjectLink_Goods_InfoMoney()
                                 LEFT JOIN ContainerLinkObject AS CLO_Branch
                                                               ON CLO_Branch.ContainerId = tmpMIContainer.ContainerId
                                                              AND CLO_Branch.DescId = zc_ContainerLinkObject_Branch()
                                 LEFT JOIN ContainerLinkObject AS CLO_ProfitLoss
                                                               ON CLO_ProfitLoss.ContainerId = tmpMIContainer.ContainerId
                                                              AND CLO_ProfitLoss.DescId = zc_ContainerLinkObject_ProfitLoss()
                                 LEFT JOIN ContainerLinkObject AS CLO_Business
                                                               ON CLO_Business.ContainerId = tmpMIContainer.ContainerId
                                                              AND CLO_Business.DescId = zc_ContainerLinkObject_Business()
                                 LEFT JOIN ContainerLinkObject AS CLO_JuridicalBasis
                                                               ON CLO_JuridicalBasis.ContainerId = tmpMIContainer.ContainerId
                                                              AND CLO_JuridicalBasis.DescId = zc_ContainerLinkObject_JuridicalBasis()
                                 /*LEFT JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoney
                                                               ON ContainerLinkObject_InfoMoney.ContainerId = ReportContainerLink.ChildContainerId
                                                              AND ContainerLinkObject_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()*/
                            GROUP BY CLO_Branch.ObjectId
                                   , CLO_ProfitLoss.ObjectId
                                   , CLO_Business.ObjectId
                                   , CLO_JuridicalBasis.ObjectId
                                   , CASE WHEN tmpMIContainer.InfoMoney_inf > 0 THEN tmpMIContainer.InfoMoney_inf ELSE COALESCE (OL_Goods_InfoMoney.ChildObjectId, 0) END
                                   , tmpMIContainer.MovementDescId
                                   , tmpMIContainer.DirectionId
                                   , tmpMIContainer.UnitId_ProfitLoss
                                   , tmpMIContainer.ObjectId_inf
                                   , tmpMIContainer.GoodsKindId_inf
                                   , tmpMIContainer.FromId
                           )

      , tmpReport AS (SELECT tmpProfitLoss.ProfitLossId
                           , tmpProfitLoss.BusinessId
                           , tmpProfitLoss.JuridicalId_Basis
                           , tmpProfitLoss.UnitId_ProfitLoss
                           , tmpProfitLoss.BranchId_ProfitLoss
                           , /*CASE WHEN tmpProfitLoss.RouteId_inf <> 0 THEN tmpProfitLoss.RouteId_inf
                                  WHEN ContainerLinkObject_Juridical.ObjectId <> 0 THEN ContainerLinkObject_Juridical.ObjectId
                                  WHEN ContainerLinkObject_Personal.ObjectId <> 0 THEN ContainerLinkObject_Personal.ObjectId
                                  WHEN ContainerLinkObject_Unit.ObjectId <> 0 THEN ContainerLinkObject_Unit.ObjectId
                                  ELSE ContainerLinkObject_Car.ObjectId
                             END*/
                             tmpProfitLoss.DirectionId
                           , tmpProfitLoss.MovementDescId
                           , SUM (tmpProfitLoss.Amount) AS Amount
                           , tmpProfitLoss.InfoMoneyId_inf        AS InfoMoneyId
                           -- , ContainerLinkObject_InfoMoney.ObjectId       AS InfoMoneyId
                           , 0 AS InfoMoneyId_Detail
                           , tmpProfitLoss.ObjectId_inf AS ObjectId_inf
                           , tmpProfitLoss.GoodsKindId_inf
                           , tmpProfitLoss.FromId
                           /*, ContainerLinkObject_InfoMoneyDetail.ObjectId AS InfoMoneyId_Detail
                           , ContainerLinkObject_Juridical.ObjectId       AS JuridicalId_inf
                           , ContainerLinkObject_Personal.ObjectId        AS PersonalId_inf
                           , ContainerLinkObject_Unit.ObjectId            AS UnitId_inf
                           , ContainerLinkObject_Car.ObjectId             AS CarId_inf
                           , ContainerLinkObject_Goods.ObjectId           AS GoodsId_inf*/
                      FROM tmpProfitLoss
                           /*LEFT JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoney
                                                         ON ContainerLinkObject_InfoMoney.ContainerId = tmpProfitLoss.ContainerId_inf
                                                        AND ContainerLinkObject_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()*/
                           /*LEFT JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoneyDetail
                                                         ON ContainerLinkObject_InfoMoneyDetail.ContainerId = tmpProfitLoss.ContainerId_inf
                                                        AND ContainerLinkObject_InfoMoneyDetail.DescId = tmpProfitLoss.ContainerId_inf
                           LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Juridical
                                                         ON ContainerLinkObject_Juridical.ContainerId = tmpProfitLoss.ContainerId_inf
                                                        AND ContainerLinkObject_Juridical.DescId = tmpProfitLoss.ContainerId_inf
                                                        -- AND ContainerLinkObject_Juridical.ObjectId >0
                           LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Personal
                                                         ON ContainerLinkObject_Personal.ContainerId = tmpProfitLoss.ContainerId_inf
                                                        AND ContainerLinkObject_Personal.DescId = tmpProfitLoss.ContainerId_inf
                                                        -- AND ContainerLinkObject_Personal.ObjectId >0
                           LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Unit
                                                         ON ContainerLinkObject_Unit.ContainerId = tmpProfitLoss.ContainerId_inf
                                                        AND ContainerLinkObject_Unit.DescId = zc_ContainerLinkObject_Unit()
                                                        -- AND ContainerLinkObject_Unit.ObjectId >0
                           LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Car
                                                         ON ContainerLinkObject_Car.ContainerId = tmpProfitLoss.ContainerId_inf
                                                        AND ContainerLinkObject_Car.DescId = zc_ContainerLinkObject_Car()
                                                        -- AND ContainerLinkObject_Car.ObjectId >0
                           LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Goods
                                                         ON ContainerLinkObject_Goods.ContainerId = tmpProfitLoss.ContainerId_inf
                                                        AND ContainerLinkObject_Goods.DescId = zc_ContainerLinkObject_Goods()
                                                        -- AND ContainerLinkObject_Goods.ObjectId >0*/
                      GROUP BY tmpProfitLoss.ProfitLossId
                             , tmpProfitLoss.BusinessId
                             , tmpProfitLoss.JuridicalId_Basis
                             , tmpProfitLoss.UnitId_ProfitLoss
                             , tmpProfitLoss.BranchId_ProfitLoss
                             -- , ContainerLinkObject_InfoMoney.ObjectId
                             , tmpProfitLoss.InfoMoneyId_inf
                             , tmpProfitLoss.DirectionId
                             , tmpProfitLoss.MovementDescId
                             , tmpProfitLoss.ObjectId_inf
                             , tmpProfitLoss.GoodsKindId_inf
                             , tmpProfitLoss.FromId
                             /*, ContainerLinkObject_InfoMoneyDetail.ObjectId
                             , ContainerLinkObject_Juridical.ObjectId
                             , ContainerLinkObject_Personal.ObjectId
                             , ContainerLinkObject_Unit.ObjectId
                             , ContainerLinkObject_Car.ObjectId
                             , ContainerLinkObject_Goods.ObjectId*/
                     )

    , tmpPersonal AS (SELECT lfSelect.MemberId
                           , lfSelect.UnitId
                      FROM lfSelect_Object_Member_findPersonal (inSession) AS lfSelect
                      WHERE lfSelect.Ord = 1
                     )
      --
      SELECT
             View_ProfitLoss.ProfitLossGroupName
           , View_ProfitLoss.ProfitLossDirectionName
           , View_ProfitLoss.ProfitLossName
           --для печатной формы без кода
           , View_ProfitLoss.ProfitLossGroupName_original
           , View_ProfitLoss.ProfitLossDirectionName_original
           , View_ProfitLoss.ProfitLossName_original

           , View_ProfitLoss.onComplete

           , Object_Business.ValueData          AS BusinessName
           , Object_JuridicalBasis.ValueData    AS JuridicalName_Basis
           , Object_Branch_ProfitLoss.ValueData AS BranchName_ProfitLoss
           , Object_Unit_ProfitLoss.Id          AS UnitId_ProfitLoss
           , Object_Unit_ProfitLoss.ValueData   AS UnitName_ProfitLoss
           , ObjectDesc_Unit.Id                 AS UnitDescId
           , ObjectDesc_Unit.ItemName           AS UnitDescName

           , View_InfoMoney.InfoMoneyGroupCode
           , View_InfoMoney.InfoMoneyDestinationCode
           , View_InfoMoney.InfoMoneyCode
           , View_InfoMoney.InfoMoneyGroupName
           , View_InfoMoney.InfoMoneyDestinationName
           , View_InfoMoney.InfoMoneyName

           , View_InfoMoney_Detail.InfoMoneyGroupCode       AS InfoMoneyGroupCode_Detail
           , View_InfoMoney_Detail.InfoMoneyDestinationCode AS InfoMoneyDestinationCode_Detail
           , View_InfoMoney_Detail.InfoMoneyCode            AS InfoMoneyCode_Detail
           , View_InfoMoney_Detail.InfoMoneyGroupName       AS InfoMoneyGroupName_Detail
           , View_InfoMoney_Detail.InfoMoneyDestinationName AS InfoMoneyDestinationName_Detail
           , View_InfoMoney_Detail.InfoMoneyName            AS InfoMoneyName_Detail

           , Object_Direction.ObjectCode     AS DirectionObjectCode
           , Object_Direction.ValueData      AS DirectionObjectName
           , ObjectDesc_Direction.ItemName   AS DirectionDescName
           , Object_Destination.Id           AS DestinationObjectId
           , Object_Destination.ObjectCode   AS DestinationObjectCode
           , Object_Destination.ValueData    AS DestinationObjectName
           , ObjectDesc_Destination.Id       AS DestinationDescId
           , ObjectDesc_Destination.ItemName AS DestinationDescName

           , MovementDesc.Id               AS MovementDescId
           , MovementDesc.ItemName         AS MovementDescName

           , tmpReport.Amount :: TFloat AS Amount

           , CASE WHEN Object_Branch_ProfitLoss.ValueData ILIKE '%Днепр%'     THEN tmpReport.Amount ELSE 0 END :: TFloat AS Amount_Dn
           , CASE WHEN Object_Branch_ProfitLoss.ValueData ILIKE '%Харьков%'   THEN tmpReport.Amount ELSE 0 END :: TFloat AS Amount_Kh
           , CASE WHEN Object_Branch_ProfitLoss.ValueData ILIKE '%Одесса%'    THEN tmpReport.Amount ELSE 0 END :: TFloat AS Amount_Od
           , CASE WHEN Object_Branch_ProfitLoss.ValueData ILIKE '%Запорожье%' THEN tmpReport.Amount ELSE 0 END :: TFloat AS Amount_Zp
           , CASE WHEN Object_Branch_ProfitLoss.ValueData ILIKE '%Киев%'      THEN tmpReport.Amount ELSE 0 END :: TFloat AS Amount_Kv
           , CASE WHEN Object_Branch_ProfitLoss.ValueData ILIKE '%Кр.Рог%'    THEN tmpReport.Amount ELSE 0 END :: TFloat AS Amount_Kr
           , CASE WHEN Object_Branch_ProfitLoss.ValueData ILIKE '%Николаев%'  THEN tmpReport.Amount ELSE 0 END :: TFloat AS Amount_Nik
           , CASE WHEN Object_Branch_ProfitLoss.ValueData ILIKE '%Черкассы%'  THEN tmpReport.Amount ELSE 0 END :: TFloat AS Amount_Ch
           , CASE WHEN Object_Branch_ProfitLoss.ValueData ILIKE '%Львов%'     THEN tmpReport.Amount ELSE 0 END :: TFloat AS Amount_Lv
           , CASE WHEN COALESCE (Object_Branch_ProfitLoss.ValueData,'') =''  THEN tmpReport.Amount ELSE 0 END :: TFloat AS Amount_0

           -- доп.группа для промежуточного итога   "итого сумма у покупателя"
           ,  CASE WHEN ProfitLossDirectionId IN (9221, 9222, 565318, 9223) THEN 1 ELSE 2 END ProfitLossGroup_dop
           --место учета
           , CASE WHEN Object_Unit_ProfitLoss.DescId = zc_Object_Member() THEN Object_Unit_member.ValueData
                  WHEN Object_Unit_ProfitLoss.DescId = zc_Object_InfoMoney() THEN Object_From.ValueData              ---- если "Элемент Подразделения" = "Статьи списания", тогда тянем "От кого" из документа "Списание"
                  WHEN Object_Unit_ProfitLoss.DescId = zc_Object_Founder() THEN 'Административный'
                  WHEN Object_Unit_ProfitLoss.DescId = zc_Object_Partner() THEN 'Павильоны'
                  WHEN Object_Unit_ProfitLoss.DescId = zc_Object_Unit() THEN Object_Unit_ProfitLoss.ValueData
                  ELSE ''
             END ::TVarChar AS LocationName
      FROM Object_ProfitLoss_View AS View_ProfitLoss

           LEFT JOIN tmpReport ON tmpReport.ProfitLossId = View_ProfitLoss.ProfitLossId

           LEFT JOIN Object AS Object_Business          ON Object_Business.Id = tmpReport.BusinessId
           LEFT JOIN Object AS Object_JuridicalBasis    ON Object_JuridicalBasis.Id = tmpReport.JuridicalId_Basis
           LEFT JOIN Object AS Object_Unit_ProfitLoss   ON Object_Unit_ProfitLoss.Id = tmpReport.UnitId_ProfitLoss
           LEFT JOIN Object AS Object_Branch_ProfitLoss ON Object_Branch_ProfitLoss.Id = tmpReport.BranchId_ProfitLoss

           LEFT JOIN Object_InfoMoney_View AS View_InfoMoney        ON View_InfoMoney.InfoMoneyId = tmpReport.InfoMoneyId
           LEFT JOIN Object_InfoMoney_View AS View_InfoMoney_Detail ON View_InfoMoney_Detail.InfoMoneyId = tmpReport.InfoMoneyId_Detail
                                                                   -- AND zc_isHistoryCost_byInfoMoneyDetail() = TRUE
           LEFT JOIN Object AS Object_Direction   ON Object_Direction.Id = tmpReport.DirectionId
           LEFT JOIN Object AS Object_Destination_calc ON Object_Destination_calc.Id = tmpReport.ObjectId_inf
           LEFT JOIN Object AS Object_Destination ON Object_Destination.Id = CASE WHEN vbIsUserRole_8813637 = TRUE AND Object_Destination_calc.DescId IN (zc_Object_Personal(), zc_Object_Member()) THEN NULL ELSE tmpReport.ObjectId_inf END

           LEFT JOIN MovementDesc ON MovementDesc.Id = tmpReport.MovementDescId

           --desc
           LEFT JOIN ObjectDesc AS ObjectDesc_Direction   ON ObjectDesc_Direction.Id   = Object_Direction.DescId
           LEFT JOIN ObjectDesc AS ObjectDesc_Destination ON ObjectDesc_Destination.Id = Object_Destination.DescId
           LEFT JOIN ObjectDesc AS ObjectDesc_Unit        ON ObjectDesc_Unit.Id        = Object_Unit_ProfitLoss.DescId
           --
           LEFT JOIN Object AS Object_From ON Object_From.Id = tmpReport.FromId
           LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = tmpReport.UnitId_ProfitLoss
           LEFT JOIN Object AS Object_Unit_member ON Object_Unit_member.Id = tmpPersonal.UnitId
      WHERE View_ProfitLoss.ProfitLossCode <> 90101 --

     UNION ALL
      SELECT
             COALESCE ('Расходы финансовые-Дивиденды', View_ProfitLoss.ProfitLossGroupName, Object_ProfitLoss.ValueData)     :: TVarChar AS ProfitLossGroupName
           , COALESCE ('Расходы финансовые-Дивиденды', View_ProfitLoss.ProfitLossDirectionName, Object_ProfitLoss.ValueData) :: TVarChar AS ProfitLossDirectionName
           , COALESCE ('Расходы финансовые-Дивиденды', View_ProfitLoss.ProfitLossName, Object_ProfitLoss.ValueData)          :: TVarChar AS ProfitLossName
             --для печатной формы без кода
           , COALESCE ('Расходы финансовые-Дивиденды', View_ProfitLoss.ProfitLossGroupName_original, Object_ProfitLoss.ValueData)     :: TVarChar AS ProfitLossGroupName_original
           , COALESCE ('Расходы финансовые-Дивиденды', View_ProfitLoss.ProfitLossDirectionName_original, Object_ProfitLoss.ValueData) :: TVarChar AS ProfitLossDirectionName_original
           , COALESCE ('Расходы финансовые-Дивиденды', View_ProfitLoss.ProfitLossName_original, Object_ProfitLoss.ValueData)          :: TVarChar AS ProfitLossName_original

           , View_ProfitLoss.onComplete

           , Object_Business.ValueData          AS BusinessName
           , Object_JuridicalBasis.ValueData    AS JuridicalName_Basis
           , Object_Branch_ProfitLoss.ValueData AS BranchName_ProfitLoss
           , Object_Unit_ProfitLoss.Id          AS UnitId_ProfitLoss
           , Object_Unit_ProfitLoss.ValueData   AS UnitName_ProfitLoss
           , ObjectDesc_Unit.Id                 AS UnitDescId
           , ObjectDesc_Unit.ItemName           AS UnitDescName

           , View_InfoMoney.InfoMoneyGroupCode
           , View_InfoMoney.InfoMoneyDestinationCode
           , View_InfoMoney.InfoMoneyCode
           , View_InfoMoney.InfoMoneyGroupName
           , View_InfoMoney.InfoMoneyDestinationName
           , View_InfoMoney.InfoMoneyName

           , View_InfoMoney_Detail.InfoMoneyGroupCode       AS InfoMoneyGroupCode_Detail
           , View_InfoMoney_Detail.InfoMoneyDestinationCode AS InfoMoneyDestinationCode_Detail
           , View_InfoMoney_Detail.InfoMoneyCode            AS InfoMoneyCode_Detail
           , View_InfoMoney_Detail.InfoMoneyGroupName       AS InfoMoneyGroupName_Detail
           , View_InfoMoney_Detail.InfoMoneyDestinationName AS InfoMoneyDestinationName_Detail
           , View_InfoMoney_Detail.InfoMoneyName            AS InfoMoneyName_Detail

           , Object_Direction.ObjectCode     AS DirectionObjectCode
           , Object_Direction.ValueData      AS DirectionObjectName
           , ObjectDesc_Direction.ItemName   AS DirectionDescName
           , Object_Destination.Id           AS DestinationObjectId
           , Object_Destination.ObjectCode   AS DestinationObjectCode
           , Object_Destination.ValueData    AS DestinationObjectName
           , ObjectDesc_Destination.Id       AS DestinationDescId
           , ObjectDesc_Destination.ItemName AS DestinationDescName

           , MovementDesc.Id               AS MovementDescId
           , MovementDesc.ItemName         AS MovementDescName

           , tmpReport.Amount :: TFloat AS Amount

           , CASE WHEN Object_Branch_ProfitLoss.ValueData ILIKE '%Днепр%'     THEN tmpReport.Amount ELSE 0 END :: TFloat AS Amount_Dn
           , CASE WHEN Object_Branch_ProfitLoss.ValueData ILIKE '%Харьков%'   THEN tmpReport.Amount ELSE 0 END :: TFloat AS Amount_Kh
           , CASE WHEN Object_Branch_ProfitLoss.ValueData ILIKE '%Одесса%'    THEN tmpReport.Amount ELSE 0 END :: TFloat AS Amount_Od
           , CASE WHEN Object_Branch_ProfitLoss.ValueData ILIKE '%Запорожье%' THEN tmpReport.Amount ELSE 0 END :: TFloat AS Amount_Zp
           , CASE WHEN Object_Branch_ProfitLoss.ValueData ILIKE '%Киев%'      THEN tmpReport.Amount ELSE 0 END :: TFloat AS Amount_Kv
           , CASE WHEN Object_Branch_ProfitLoss.ValueData ILIKE '%Кр.Рог%'    THEN tmpReport.Amount ELSE 0 END :: TFloat AS Amount_Kr
           , CASE WHEN Object_Branch_ProfitLoss.ValueData ILIKE '%Николаев%'  THEN tmpReport.Amount ELSE 0 END :: TFloat AS Amount_Nik
           , CASE WHEN Object_Branch_ProfitLoss.ValueData ILIKE '%Черкассы%'  THEN tmpReport.Amount ELSE 0 END :: TFloat AS Amount_Ch
           , CASE WHEN Object_Branch_ProfitLoss.ValueData ILIKE '%Львов%'     THEN tmpReport.Amount ELSE 0 END :: TFloat AS Amount_Lv
           , CASE WHEN COALESCE (Object_Branch_ProfitLoss.ValueData,'') =''   THEN tmpReport.Amount ELSE 0 END :: TFloat AS Amount_0

           -- доп.группа для промежуточного итога   "итого сумма у покупателя"
           ,  CASE WHEN ProfitLossDirectionId IN (9221, 9222, 565318, 9223) THEN 1 ELSE 2 END ProfitLossGroup_dop
           --место учета
           , CASE WHEN Object_Unit_ProfitLoss.DescId = zc_Object_Member() THEN Object_Unit_member.ValueData
                  WHEN Object_Unit_ProfitLoss.DescId = zc_Object_InfoMoney() THEN Object_From.ValueData              ---- если "Элемент Подразделения" = "Статьи списания", тогда тянем "От кого" из документа "Списание"
                  WHEN Object_Unit_ProfitLoss.DescId = zc_Object_Founder() THEN 'Административный'
                  WHEN Object_Unit_ProfitLoss.DescId = zc_Object_Partner() THEN 'Павильоны'
                  WHEN Object_Unit_ProfitLoss.DescId = zc_Object_Unit() THEN Object_Unit_ProfitLoss.ValueData
                  ELSE ''
             END ::TVarChar AS LocationName
      FROM tmpReport

           LEFT JOIN Object_ProfitLoss_View AS View_ProfitLoss ON View_ProfitLoss.ProfitLossId = tmpReport.ProfitLossId
           LEFT JOIN Object AS Object_ProfitLoss ON Object_ProfitLoss.Id = tmpReport.ProfitLossId

           LEFT JOIN Object AS Object_Business          ON Object_Business.Id = tmpReport.BusinessId
           LEFT JOIN Object AS Object_JuridicalBasis    ON Object_JuridicalBasis.Id = tmpReport.JuridicalId_Basis
           LEFT JOIN Object AS Object_Unit_ProfitLoss   ON Object_Unit_ProfitLoss.Id = tmpReport.UnitId_ProfitLoss
           LEFT JOIN Object AS Object_Branch_ProfitLoss ON Object_Branch_ProfitLoss.Id = tmpReport.BranchId_ProfitLoss

           LEFT JOIN Object_InfoMoney_View AS View_InfoMoney        ON View_InfoMoney.InfoMoneyId = tmpReport.InfoMoneyId
           LEFT JOIN Object_InfoMoney_View AS View_InfoMoney_Detail ON View_InfoMoney_Detail.InfoMoneyId = tmpReport.InfoMoneyId_Detail
                                                                   -- AND zc_isHistoryCost_byInfoMoneyDetail() = TRUE
           LEFT JOIN Object AS Object_Direction   ON Object_Direction.Id = tmpReport.DirectionId
           LEFT JOIN Object AS Object_Destination_calc ON Object_Destination_calc.Id = tmpReport.ObjectId_inf
           LEFT JOIN Object AS Object_Destination ON Object_Destination.Id = CASE WHEN vbIsUserRole_8813637 = TRUE AND Object_Destination_calc.DescId IN (zc_Object_Personal(), zc_Object_Member()) THEN NULL ELSE tmpReport.ObjectId_inf END

           LEFT JOIN MovementDesc ON MovementDesc.Id = tmpReport.MovementDescId

           --desc
           LEFT JOIN ObjectDesc AS ObjectDesc_Direction   ON ObjectDesc_Direction.Id   = Object_Direction.DescId
           LEFT JOIN ObjectDesc AS ObjectDesc_Destination ON ObjectDesc_Destination.Id = Object_Destination.DescId
           LEFT JOIN ObjectDesc AS ObjectDesc_Unit        ON ObjectDesc_Unit.Id        = Object_Unit_ProfitLoss.DescId

           --
           LEFT JOIN Object AS Object_From ON Object_From.Id = tmpReport.FromId
           LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = tmpReport.UnitId_ProfitLoss
           LEFT JOIN Object AS Object_Unit_member ON Object_Unit_member.Id = tmpPersonal.UnitId
      WHERE View_ProfitLoss.ProfitLossId IS NULL
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_ProfitLoss (TDateTime, TDateTime, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 12.01.17         *
 03.11.13                                        * all
 21.10.13                         *
 01.09.13                                        *
 27.08.13                                        *
*/

-- тест
-- SELECT * FROM gpReport_ProfitLoss (inStartDate:= '04.05.2024', inEndDate:= '04.05.2024', inSession:= '5') WHERE Amount <> 0 ORDER BY 5
