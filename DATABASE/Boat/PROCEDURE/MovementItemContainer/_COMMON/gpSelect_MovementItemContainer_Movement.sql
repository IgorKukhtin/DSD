-- Запрос возвращает все проводки по документу
-- Function: gpSelect_MovementItemContainer_Movement()

DROP FUNCTION IF EXISTS gpSelect_MovementItemContainer_Movement (Integer, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItemContainer_Movement(
    IN inMovementId         Integer      , -- ключ Документа
    IN inIsDestination      Boolean      , --
    IN inIsParentDetail     Boolean      , --
    IN inIsInfoMoneyDetail  Boolean      , --
    IN inSession            TVarChar       -- сессия пользователя
)
RETURNS TABLE (InvNumber Integer, OperDate TDateTime
             , AccountCode Integer
             , DebetAmount TFloat, DebetAccountGroupName TVarChar, DebetAccountDirectionName TVarChar, DebetAccountName TVarChar
             , KreditAmount TFloat, KreditAccountGroupName TVarChar, KreditAccountDirectionName TVarChar, KreditAccountName  TVarChar
             , Amount_Currency TFloat
             , DirectionObjectCode Integer, DirectionObjectName TVarChar
             , DestinationObjectCode Integer, DestinationObjectName TVarChar
             , JuridicalBasisCode Integer, JuridicalBasisName TVarChar
             , InfoMoneyCode Integer, InfoMoneyName TVarChar
             , CurrencyName TVarChar
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_MIContainer_Movement());
     vbUserId:= lpGetUserBySession (inSession);

     -- Менется признак
     inIsDestination:= inIsDestination OR inIsParentDetail OR inIsInfoMoneyDetail;
     -- Менется признак
     inIsParentDetail:= inIsParentDetail OR inIsInfoMoneyDetail;

     -- !!!проводки только у Админа!!!
     IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId IN (zc_Enum_Role_Admin()))
     THEN

     RETURN QUERY
       WITH tmpMovement AS (SELECT Movement.Id AS MovementId, Movement.DescId AS MovementDescId, Movement.InvNumber, inIsDestination AS isDestination FROM Movement WHERE Movement.Id = inMovementId
                           )
                    -- все проводки: количественные + суммовые
                  , tmpMIContainer_all AS (SELECT MIContainer.DescId AS MIContainerDescId
                                                , CASE WHEN MIContainer.DescId = zc_MIContainer_Count() THEN 0 ELSE MIContainer.Id END AS Id
                                                , COALESCE (MIContainer.MovementItemId, 0) AS MovementItemId -- !!!может быть NULL!!!
                                                , MIContainer.ContainerId
                                                , MIContainer.AccountId
                                                , 0 AS ObjectId_Analyzer
                                                -- , MIContainer.ObjectId_Analyzer
                                                , MIContainer.OperDate
                                                , MIContainer.isActive
                                                , SUM (CASE WHEN MIContainer.isActive = TRUE OR MIContainer.DescId = zc_MIContainer_Summ() OR MIContainer.DescId = zc_MIContainer_SummCurrency() THEN 1 ELSE -1 END * MIContainer.Amount) AS Amount
                                                , tmpMovement.MovementId
                                                , tmpMovement.MovementDescId
                                                , tmpMovement.InvNumber
                                                , tmpMovement.isDestination
                                           FROM tmpMovement
                                                LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.MovementId = tmpMovement.MovementId
                                           GROUP BY MIContainer.DescId
                                                , CASE WHEN MIContainer.DescId = zc_MIContainer_Count() THEN 0 ELSE MIContainer.Id END
                                                , COALESCE (MIContainer.MovementItemId, 0)
                                                , MIContainer.ContainerId
                                                , MIContainer.AccountId
                                                -- , MIContainer.ObjectId_Analyzer
                                                , MIContainer.OperDate
                                                , MIContainer.isActive
                                                , tmpMovement.MovementId
                                                , tmpMovement.MovementDescId
                                                , tmpMovement.InvNumber
                                                , tmpMovement.isDestination
                                          )
                   -- проводки: только суммовые + определяется Счет
                 , tmpMIContainer_Summ AS (SELECT tmpMIContainer_all.MIContainerDescId
                                                , tmpMIContainer_all.MovementItemId -- !!!может быть NULL!!!
                                                , tmpMIContainer_all.ContainerId
                                                , tmpMIContainer_all.ObjectId_Analyzer
                                                , tmpMIContainer_all.OperDate
                                                , tmpMIContainer_all.isActive
                                                , tmpMIContainer_all.Amount
                                                , tmpMIContainer_all.MovementId
                                                , tmpMIContainer_all.MovementDescId
                                                , tmpMIContainer_all.InvNumber
                                                , tmpMIContainer_all.isDestination
                                                , tmpMIContainer_all.AccountId
                                                , 0 AS Amount_Currency
                                           FROM tmpMIContainer_all
                                           WHERE tmpMIContainer_all.MIContainerDescId = zc_MIContainer_Summ()
                                          UNION ALL
                                           SELECT tmpMIContainer_all.MIContainerDescId
                                                , tmpMIContainer_all.MovementItemId -- !!!может быть NULL!!!
                                                , tmpMIContainer_all.ContainerId
                                                -- , Container.ParentId AS ContainerId
                                                , tmpMIContainer_all.ObjectId_Analyzer
                                                , tmpMIContainer_all.OperDate
                                                , tmpMIContainer_all.isActive
                                                , 0 AS Amount
                                                , tmpMIContainer_all.MovementId
                                                , tmpMIContainer_all.MovementDescId
                                                , tmpMIContainer_all.InvNumber
                                                , tmpMIContainer_all.isDestination
                                                , tmpMIContainer_all.AccountId
                                                , COALESCE (tmpMIContainer_all.Amount, 0)      AS Amount_Currency
                                           FROM tmpMIContainer_all
                                                -- LEFT JOIN Container ON Container.Id = tmpMIContainer_all.ContainerId
                                           WHERE tmpMIContainer_all.MIContainerDescId = zc_MIContainer_SummCurrency()
                                          )
       -- Результат
       SELECT
             zfConvert_StringToNumber (tmpMovementItemContainer.InvNumber) AS InvNumber
           , tmpMovementItemContainer.OperDate
           , CAST (Object_Account_View.AccountCode AS Integer) AS AccountCode

           , CAST (CASE WHEN tmpMovementItemContainer.Amount >= 0 AND tmpMovementItemContainer.AccountId <> zc_Enum_Account_100301() THEN tmpMovementItemContainer.Amount ELSE 0 END AS TFloat) AS DebetAmount
           , CAST (CASE WHEN tmpMovementItemContainer.Amount >= 0 AND tmpMovementItemContainer.AccountId <> zc_Enum_Account_100301() /*COALESCE (ObjectLink_AccountKind.ChildObjectId, 0) = zc_Enum_AccountKind_Active()*/ THEN Object_Account_View.AccountGroupName ELSE NULL END  AS TVarChar) AS DebetAccountGroupName
           , CAST (CASE WHEN tmpMovementItemContainer.Amount >= 0 AND tmpMovementItemContainer.AccountId <> zc_Enum_Account_100301() /*COALESCE (ObjectLink_AccountKind.ChildObjectId, 0) = zc_Enum_AccountKind_Active()*/ THEN Object_Account_View.AccountDirectionName ELSE NULL END  AS TVarChar) AS DebetAccountDirectionName
           , CAST (CASE WHEN tmpMovementItemContainer.Amount >= 0 AND tmpMovementItemContainer.AccountId <> zc_Enum_Account_100301() /*COALESCE (ObjectLink_AccountKind.ChildObjectId, 0) = zc_Enum_AccountKind_Active()*/ THEN Object_Account_View.AccountName_all ELSE NULL END  AS TVarChar) AS DebetAccountName

           , CAST (CASE WHEN tmpMovementItemContainer.Amount < 0 OR tmpMovementItemContainer.AccountId = zc_Enum_Account_100301() THEN -1 * tmpMovementItemContainer.Amount ELSE 0 END AS TFloat) AS KreditAmount
           , CAST (CASE WHEN tmpMovementItemContainer.Amount < 0 OR tmpMovementItemContainer.AccountId = zc_Enum_Account_100301() /*COALESCE (ObjectLink_AccountKind.ChildObjectId, 0) <> zc_Enum_AccountKind_Active()*/ THEN Object_Account_View.AccountGroupName ELSE NULL END  AS TVarChar) AS KreditAccountGroupName
           , CAST (CASE WHEN tmpMovementItemContainer.Amount < 0 OR tmpMovementItemContainer.AccountId = zc_Enum_Account_100301() /*COALESCE (ObjectLink_AccountKind.ChildObjectId, 0) <> zc_Enum_AccountKind_Active()*/ THEN Object_Account_View.AccountDirectionName ELSE NULL END  AS TVarChar) AS KreditAccountDirectionName
           , CAST (CASE WHEN tmpMovementItemContainer.Amount < 0 OR tmpMovementItemContainer.AccountId = zc_Enum_Account_100301() /*COALESCE (ObjectLink_AccountKind.ChildObjectId, 0) <> zc_Enum_AccountKind_Active()*/ THEN Object_Account_View.AccountName_all ELSE NULL END  AS TVarChar) AS KreditAccountName

           , CAST (tmpMovementItemContainer.Amount_Currency AS TFloat) AS Amount_Currency

           , tmpMovementItemContainer.DirectionObjectCode
           , tmpMovementItemContainer.DirectionObjectName :: TVarChar AS DirectionObjectName
           , tmpMovementItemContainer.DestinationObjectCode
           , tmpMovementItemContainer.DestinationObjectName

           , tmpMovementItemContainer.JuridicalBasisCode
           , tmpMovementItemContainer.JuridicalBasisName
           , tmpMovementItemContainer.InfoMoneyCode
           , tmpMovementItemContainer.InfoMoneyName
           , Object_Currency.ValueData AS CurrencyName

       FROM
           (SELECT
                  tmpMIContainer_Summ.InvNumber
                , tmpMIContainer_Summ.OperDate
                , tmpMIContainer_Summ.MovementDescId
                , tmpMIContainer_Summ.AccountId
                , SUM (tmpMIContainer_Summ.Amount)  AS Amount
                , SUM (tmpMIContainer_Summ.Amount_Currency) AS Amount_Currency
                , tmpMIContainer_Summ.isActive

                , Object_JuridicalBasis.ObjectCode AS JuridicalBasisCode
                , Object_JuridicalBasis.ValueData  AS JuridicalBasisName

                , CASE WHEN Object_ProfitLoss_View.ProfitLossName_all IS NOT NULL
                            THEN Object_ProfitLoss_View.ProfitLossCode
                       ELSE Object_Direction.ObjectCode
                  END AS DirectionObjectCode
                , CASE WHEN Object_ProfitLoss_View.ProfitLossName_all IS NOT NULL
                            THEN Object_ProfitLoss_View.ProfitLossName_all
                       ELSE Object_Direction.ValueData || COALESCE (' *** ' || Object_Partner.ValueData, '')
                  END AS DirectionObjectName


                , COALESCE (Object_Destination.Id, 0) AS DestinationId
                , Object_Destination.ObjectCode       AS DestinationObjectCode
                , Object_Destination.ValueData        AS DestinationObjectName

                , tmpMIContainer_Summ.CurrencyId

                , View_InfoMoney.InfoMoneyCode
                , View_InfoMoney.InfoMoneyName

                , tmpMIContainer_Summ.isDestination

            FROM
           (SELECT
                  tmpMIContainer_Summ.InvNumber
                , tmpMIContainer_Summ.OperDate
                , tmpMIContainer_Summ.MovementDescId
                , tmpMIContainer_Summ.AccountId
                , tmpMIContainer_Summ.Amount
                , tmpMIContainer_Summ.Amount_Currency

                , tmpMIContainer_Summ.ContainerId

                , tmpMIContainer_Summ.isActive

                , CASE WHEN ContainerLinkObject_ProfitLoss.ObjectId <> 0
                            THEN ContainerLinkObject_ProfitLoss.ObjectId

                       WHEN ContainerLinkObject_Client.ObjectId <> 0
                            THEN ContainerLinkObject_Client.ObjectId

                       WHEN ContainerLinkObject_Cash.ObjectId <> 0
                            THEN ContainerLinkObject_Cash.ObjectId
                       WHEN ContainerLinkObject_BankAccount.ObjectId <> 0
                            THEN ContainerLinkObject_BankAccount.ObjectId

                       WHEN ContainerLinkObject_Unit.ObjectId <> 0
                            THEN ContainerLinkObject_Unit.ObjectId
                  END AS DirectionId
                , ContainerLinkObject_Partner.ObjectId AS PartnerId

                , ContainerLO_JuridicalBasis.ObjectId     AS JuridicalBasisId
                , ContainerLinkObject_ProfitLoss.ObjectId AS ProfitLossId


                , ContainerLinkObject_Currency.ObjectId  AS CurrencyId
                , ContainerLinkObject_InfoMoney.ObjectId AS InfoMoneyId

                , tmpMIContainer_Summ.isDestination

            FROM tmpMIContainer_Summ
                 LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Cash
                                               ON ContainerLinkObject_Cash.ContainerId = tmpMIContainer_Summ.ContainerId
                                              AND ContainerLinkObject_Cash.DescId = zc_ContainerLinkObject_Cash()
                 LEFT JOIN ContainerLinkObject AS ContainerLinkObject_BankAccount
                                               ON ContainerLinkObject_BankAccount.ContainerId = tmpMIContainer_Summ.ContainerId
                                              AND ContainerLinkObject_BankAccount.DescId = zc_ContainerLinkObject_BankAccount()

                 LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Partner
                                               ON ContainerLinkObject_Partner.ContainerId = tmpMIContainer_Summ.ContainerId
                                              AND ContainerLinkObject_Partner.DescId = zc_ContainerLinkObject_Partner()
                 LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Client
                                               ON ContainerLinkObject_Client.ContainerId = tmpMIContainer_Summ.ContainerId
                                              AND ContainerLinkObject_Client.DescId = zc_ContainerLinkObject_Client()
                 LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Unit
                                               ON ContainerLinkObject_Unit.ContainerId = tmpMIContainer_Summ.ContainerId
                                              AND ContainerLinkObject_Unit.DescId = zc_ContainerLinkObject_Unit()

                 LEFT JOIN ContainerLinkObject AS ContainerLO_JuridicalBasis
                                               ON ContainerLO_JuridicalBasis.ContainerId = tmpMIContainer_Summ.ContainerId
                                              AND ContainerLO_JuridicalBasis.DescId = zc_ContainerLinkObject_JuridicalBasis()
                 LEFT JOIN ContainerLinkObject AS ContainerLinkObject_ProfitLoss
                                               ON ContainerLinkObject_ProfitLoss.ContainerId = tmpMIContainer_Summ.ContainerId
                                              AND ContainerLinkObject_ProfitLoss.DescId = zc_ContainerLinkObject_ProfitLoss()

                 LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Currency
                                               ON ContainerLinkObject_Currency.ContainerId = tmpMIContainer_Summ.ContainerId
                                              AND ContainerLinkObject_Currency.DescId = zc_ContainerLinkObject_Currency()

                 LEFT JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoney
                                               ON ContainerLinkObject_InfoMoney.ContainerId = tmpMIContainer_Summ.ContainerId
                                              AND ContainerLinkObject_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                                              -- AND 1=0
           ) AS tmpMIContainer_Summ

                 LEFT JOIN Object_ProfitLoss_View ON Object_ProfitLoss_View.ProfitLossId = tmpMIContainer_Summ.ProfitLossId
                 LEFT JOIN Object AS Object_Direction ON Object_Direction.Id = tmpMIContainer_Summ.DirectionId
                 LEFT JOIN Object AS Object_Destination ON Object_Destination.Id = NULL -- tmpMIContainer_Summ.DestinationId
                 LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpMIContainer_Summ.PartnerId

                 LEFT JOIN Object AS Object_JuridicalBasis ON Object_JuridicalBasis.Id = tmpMIContainer_Summ.JuridicalBasisId

                 LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = tmpMIContainer_Summ.InfoMoneyId

            GROUP BY tmpMIContainer_Summ.InvNumber
                   , tmpMIContainer_Summ.OperDate
                   , tmpMIContainer_Summ.isActive
                   , tmpMIContainer_Summ.AccountId
                   , tmpMIContainer_Summ.ContainerId
                   , tmpMIContainer_Summ.MovementDescId

                   , tmpMIContainer_Summ.CurrencyId

                   , Object_Direction.ObjectCode
                   , Object_Direction.ValueData
                   , Object_Partner.ObjectCode
                   , Object_Partner.ValueData
                   , Object_ProfitLoss_View.ProfitLossCode
                   , Object_ProfitLoss_View.ProfitLossName_all
                   , Object_Destination.Id
                   , Object_Destination.ObjectCode
                   , Object_Destination.ValueData
                   , Object_JuridicalBasis.ObjectCode
                   , Object_JuridicalBasis.ValueData
                   , View_InfoMoney.InfoMoneyCode
                   , View_InfoMoney.InfoMoneyName

                   , tmpMIContainer_Summ.isDestination

           ) AS tmpMovementItemContainer

           LEFT JOIN Object_Account_View ON Object_Account_View.AccountId = tmpMovementItemContainer.AccountId
           LEFT JOIN ObjectLink AS ObjectLink_AccountKind
                                ON ObjectLink_AccountKind.ObjectId = tmpMovementItemContainer.AccountId
                               AND ObjectLink_AccountKind.DescId = zc_ObjectLink_Account_AccountKind()
           LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = tmpMovementItemContainer.CurrencyId
     ;
     END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItemContainer_Movement (Integer, Boolean, Boolean, Boolean, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 23.08.14                                        * add !!!проводки только у Админа!!!
 10.08.14                                        * add вот так "просто" выбираем филиал
 27.01.14                                        * add zc_ContainerLinkObject_JuridicalBasis
 13.01.14                                        * add Branch : вот так "не просто" выбираем филиал
 21.12.13                                        * Personal -> Member
 01.11.13                                        * change DebetAccountName and KreditAccountName
 31.10.13                                        * add InvNumber and OperDate
 21.10.13                                        * add zc_ContainerLinkObject_Business
 12.10.13                                        * rename to DirectionObject and DestinationObject
 06.10.13                                        * add ParentId = inMovementId
 02.10.13                                        * calc DebetAccountName and KreditAccountName
 08.09.13                                        * add zc_ContainerLinkObject_ProfitLoss
 02.09.13                        * убрал коды счетов
 25.08.13                                        * add zc_Enum_AccountKind_Active
 10.08.13                                        * add isActive
 06.08.13                                        * add MIId_Parent
 05.08.13                                        * add Goods_Parent and InfoMoney
 11.07.13                                        * add zc_ObjectLink_Account_AccountKind
 08.07.13                                        * add AccountOnComplete
 04.07.13                                        * rename AccountId to ObjectId
 03.07.13                                        *
*/

/*
Код об.напр.
DirectionObjectCode

Объект направление
DirectionObjectName

Код об.назн.
DestinationObjectCode

Объект назначение
DestinationObjectName
*/
-- тест
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 386405, inIsDestination:= FALSE, inIsParentDetail:= FALSE, inIsInfoMoneyDetail:= FALSE, inSession:= zfCalc_UserAdmin())
