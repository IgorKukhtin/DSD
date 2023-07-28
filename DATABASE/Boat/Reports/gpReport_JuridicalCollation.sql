-- Function: gpReport_JuridicalCollation()

DROP FUNCTION IF EXISTS gpReport_JuridicalCollation (TDateTime, TDateTime, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_JuridicalCollation (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_CollationByPartner (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_JuridicalCollation(
    IN inStartDate          TDateTime,
    IN inEndDate            TDateTime,
    IN inPartnerId          Integer,
    IN inInfoMoneyId        Integer,    -- Управленческая статья
    IN inAccountId          Integer,    -- счет         
    IN insession            TVarChar
    )
RETURNS TABLE(
              MovementSumm TFloat
            , StartRemains TFloat
            , EndRemains TFloat
            , Debet TFloat
            , Kredit TFloat
            , MovementId Integer
            , OperDate TDateTime
            , InvNumber TVarChar
            , ItemName TVarChar
            , OperationSort Integer
            , FromId Integer, FromName TVarChar
            , ToId Integer, ToName TVarChar
            , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar
            , InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
            , AccountName_all TVarChar
            )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_Fuel());
    
    vbUserId:= lpGetUserBySession (inSession);
 
    -- Один запрос, который считает остаток и движение. 
    RETURN QUERY  
     WITH
     tmpContainer AS (SELECT CLO_Partner.ContainerId          AS ContainerId
                           , Container.ObjectId               AS AccountId
                           , Container.Amount
                           , CLO_Partner.ObjectId             AS PartnerId
                           , CLO_InfoMoney.ObjectId           AS InfoMoneyId
                      FROM ContainerLinkObject AS CLO_Partner

                           LEFT JOIN Container ON Container.Id = CLO_Partner.ContainerId AND Container.DescId = zc_Container_Summ()
                           
                           LEFT JOIN ContainerLinkObject AS CLO_InfoMoney
                                                         ON CLO_InfoMoney.ContainerId = Container.Id
                                                        AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()

                      WHERE CLO_Partner.DescId IN (zc_ContainerLinkObject_Partner())    --, zc_ContainerLinkObject_Client()
                        AND CLO_Partner.ObjectId = inPartnerId
                        AND (CLO_InfoMoney.ObjectId = inInfoMoneyId OR inInfoMoneyId = 0)
                        AND (Container.ObjectId = inAccountId OR inAccountId = 0)
                      )

        SELECT 
            CASE WHEN Operation.OperationSort = 0 THEN Operation.MovementSumm ELSE 0 END :: TFloat AS MovementSumm
          , Operation.StartSumm :: TFloat                  AS StartRemains
          , Operation.EndSumm :: TFloat                    AS EndRemains    
          , CASE WHEN Operation.OperationSort = 0 AND Operation.MovementSumm > 0
                      THEN Operation.MovementSumm
                 ELSE 0
            END :: TFloat                                  AS Debet
          , CASE WHEN Operation.OperationSort = 0 AND Operation.MovementSumm < 0
                      THEN -1 * Operation.MovementSumm
                 ELSE 0
            END :: TFloat                                  AS Kredit

          , Movement.Id                                    AS MovementId
          , Operation.OperDate
          , Movement.InvNumber
            
          , CASE WHEN Operation.OperationSort = -1 THEN ' Долг:' ELSE MovementDesc.ItemName END::TVarChar  AS ItemName    
          , Operation.OperationSort
          , Object_From.Id                                 AS FromId 
          , Object_From.ValueData                          AS FromName
          , Object_To.Id                                   AS ToId
          , Object_To.ValueData                            AS ToName

          , Object_InfoMoney_View.InfoMoneyGroupName
          , Object_InfoMoney_View.InfoMoneyDestinationName
          , Object_InfoMoney_View.InfoMoneyCode
          , Object_InfoMoney_View.InfoMoneyName
          , Object_InfoMoney_View.InfoMoneyName_all
          , Object_Account_View.AccountName_all
        FROM
           (SELECT tmpContainer.MovementId
                 , tmpContainer.OperDate
                 , tmpContainer.InfoMoneyId
                 , tmpContainer.AccountId
                 , SUM (tmpContainer.MovementSumm) AS MovementSumm
                 , 0 AS Informative
                 , 0 AS StartSumm
                 , 0 AS EndSumm
                 , 0 AS OperationSort
            FROM -- движение
               (SELECT MIContainer.MovementId
                     , MIContainer.OperDate 
                     , tmpContainer.InfoMoneyId
                     , tmpContainer.AccountId
                     , SUM (MIContainer.Amount) AS MovementSumm
                FROM tmpContainer
                    INNER JOIN MovementItemContainer AS MIContainer
                                                     ON MIContainer.ContainerId = tmpContainer.ContainerId
                                                    AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                GROUP BY MIContainer.MovementId, MIContainer.OperDate
                HAVING SUM (MIContainer.Amount) <> 0
               ) AS tmpContainer
           GROUP BY tmpContainer.MovementId
                  , tmpContainer.OperDate
                  , tmpContainer.InfoMoneyId
                  , tmpContainer.AccountId
          UNION ALL
           SELECT 0 AS MovementId
                , NULL :: TDateTime AS OperDate
                , tmpRemains.InfoMoneyId
                , tmpRemains.AccountId
                , 0 AS MovementSumm
                , 0 AS Informative
                , SUM (tmpRemains.StartSumm) AS StartSumm
                , SUM (tmpRemains.EndSumm) AS EndSumm
                , -1 AS OperationSort
           FROM  -- 2.1. остаток
                (SELECT tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS StartSumm
                      , tmpContainer.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END), 0) AS EndSumm 
                      , tmpContainer.InfoMoneyId
                      , tmpContainer.AccountId
                 FROM tmpContainer
                      LEFT JOIN MovementItemContainer AS MIContainer 
                                                      ON MIContainer.ContainerId = tmpContainer.ContainerId
                                                     AND MIContainer.OperDate >= inStartDate
                 GROUP BY tmpContainer.ContainerId, tmpContainer.Amount
                        , tmpContainer.InfoMoneyId
                        , tmpContainer.AccountId
                ) AS tmpRemains
           HAVING SUM (tmpRemains.StartSumm) <> 0 OR SUM (tmpRemains.EndSumm) <> 0
          ) AS Operation

      LEFT JOIN Movement ON Movement.Id = Operation.MovementId
      LEFT JOIN MovementDesc ON Movement.DescId = MovementDesc.Id
      
      LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                   ON MovementLinkObject_From.MovementId = Movement.Id 
                                  AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
      LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

      LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                   ON MovementLinkObject_To.MovementId = Movement.Id 
                                  AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()                                        
      LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId 

      LEFT JOIN Object_Account_View ON Object_Account_View.AccountId = Operation.AccountId
      LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = Operation.InfoMoneyId
      
  ORDER BY Operation.OperationSort;
                                  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И. 
 27.07.23         *
*/

-- тест
-- select * from gpReport_JuridicalCollation(inStartDate := ('01.11.2021')::TDateTime , inEndDate := ('12.11.2023')::TDateTime , inPartnerId := 254236 , inInfoMoneyId:=0, inAccountId:=0, inSession := '3');