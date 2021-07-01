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
             , BusinessName TVarChar, JuridicalName_Basis TVarChar, BranchName_ProfitLoss TVarChar, UnitName_ProfitLoss TVarChar
             , InfoMoneyGroupCode Integer, InfoMoneyDestinationCode Integer, InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar
             , InfoMoneyGroupCode_Detail Integer, InfoMoneyDestinationCode_Detail Integer, InfoMoneyCode_Detail Integer, InfoMoneyGroupName_Detail TVarChar, InfoMoneyDestinationName_Detail TVarChar, InfoMoneyName_Detail TVarChar
             , DirectionObjectCode Integer, DirectionObjectName TVarChar
             , DestinationObjectCode Integer, DestinationObjectName TVarChar
             , MovementDescName TVarChar
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
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_ProfitLoss());
     vbUserId:= lpGetUserBySession (inSession);

     -- Блокируем ему просмотр
     IF vbUserId = 9457 -- Климентьев К.И.
     THEN
         vbUserId:= NULL;
         RETURN;
     END IF;

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
                           )
     ,*/ tmpMIContainer AS (SELECT MIContainer.ContainerId
                                 , -1 * SUM (MIContainer.Amount)      AS Amount

                                 , CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Transport(), zc_Movement_TransportService())
                                             THEN MIContainer.ObjectIntId_Analyzer
                                        WHEN MIContainer.MovementDescId IN (zc_Movement_Loss())
                                             THEN MIContainer.ObjectExtId_Analyzer
                                        ELSE MIContainer.WhereObjectId_Analyzer
                                   END AS UnitId_ProfitLoss

                                 , CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Transport(), zc_Movement_PersonalService())
                                             THEN MIContainer.ObjectIntId_Analyzer
                                        WHEN MIContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_ReturnOut(), zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_SendOnPrice(), zc_Movement_Loss(), zc_Movement_Send(), zc_Movement_Inventory())
                                             THEN MIContainer.ObjectId_Analyzer
                                        WHEN MIContainer.MovementDescId IN (zc_Movement_Cash(), zc_Movement_BankAccount(), zc_Movement_Service(), zc_Movement_ProfitLossService(), zc_Movement_MobileBills())
                                             THEN MovementItem_1.ObjectId -- MIContainer.ObjectId_Analyzer
                                        ELSE 0
                                   END AS ObjectId_inf

                               --, MIContainer.WhereObjectId_Analyzer AS DirectionId
                                 , MIContainer.ObjectExtId_Analyzer AS DirectionId
                                 , MIContainer.MovementDescId
                                 , MILinkObject_InfoMoney.ObjectId AS InfoMoney_inf

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
                            WHERE MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                              AND MIContainer.AccountId = zc_Enum_Account_100301()
                              AND MIContainer.isActive = FALSE
                            GROUP BY MIContainer.ContainerId
                                   , CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Transport(), zc_Movement_TransportService())
                                               THEN MIContainer.ObjectIntId_Analyzer
                                          WHEN MIContainer.MovementDescId IN (zc_Movement_Loss())
                                               THEN MIContainer.ObjectExtId_Analyzer
                                          ELSE MIContainer.WhereObjectId_Analyzer
                                     END
                                 --, MIContainer.WhereObjectId_Analyzer
                                   , MIContainer.ObjectExtId_Analyzer
                                   , MIContainer.MovementDescId
                                   , CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Transport(), zc_Movement_PersonalService())
                                               THEN MIContainer.ObjectIntId_Analyzer
                                          WHEN MIContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_ReturnOut(), zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_SendOnPrice(), zc_Movement_Loss(), zc_Movement_Send(), zc_Movement_Inventory())
                                               THEN MIContainer.ObjectId_Analyzer
                                          WHEN MIContainer.MovementDescId IN (zc_Movement_Cash(), zc_Movement_BankAccount(), zc_Movement_Service(), zc_Movement_ProfitLossService(), zc_Movement_MobileBills())
                                               THEN MovementItem_1.ObjectId -- MIContainer.ObjectId_Analyzer
                                          ELSE 0
                                     END
                                   , MILinkObject_InfoMoney.ObjectId
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
                             /*, ContainerLinkObject_InfoMoneyDetail.ObjectId
                             , ContainerLinkObject_Juridical.ObjectId
                             , ContainerLinkObject_Personal.ObjectId
                             , ContainerLinkObject_Unit.ObjectId
                             , ContainerLinkObject_Car.ObjectId
                             , ContainerLinkObject_Goods.ObjectId*/
                     )
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
           , Object_Unit_ProfitLoss.ValueData   AS UnitName_ProfitLoss

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

           , Object_Direction.ObjectCode   AS DirectionObjectCode
           , Object_Direction.ValueData    AS DirectionObjectName
           , Object_Destination.ObjectCode AS DestinationObjectCode
           , Object_Destination.ValueData  AS DestinationObjectName

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
           LEFT JOIN Object AS Object_Destination ON Object_Destination.Id = tmpReport.ObjectId_inf

           LEFT JOIN MovementDesc ON MovementDesc.Id = tmpReport.MovementDescId

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
           , Object_Unit_ProfitLoss.ValueData   AS UnitName_ProfitLoss

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

           , Object_Direction.ObjectCode   AS DirectionObjectCode
           , Object_Direction.ValueData    AS DirectionObjectName
           , Object_Destination.ObjectCode AS DestinationObjectCode
           , Object_Destination.ValueData  AS DestinationObjectName

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
           LEFT JOIN Object AS Object_Destination ON Object_Destination.Id = tmpReport.ObjectId_inf

           LEFT JOIN MovementDesc ON MovementDesc.Id = tmpReport.MovementDescId

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
-- SELECT * FROM gpReport_ProfitLoss (inStartDate:= '31.07.2019', inEndDate:= '31.07.2019', inSession:= '2') WHERE Amount <> 0 ORDER BY 5
