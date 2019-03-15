-- Function: gpReport_ProfitDemo()

DROP FUNCTION IF EXISTS gpReport_ProfitDemo (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_ProfitDemo(
    IN inStartDate   TDateTime , -- 
    IN inEndDate     TDateTime , --
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE (ProfitLossGroupName TVarChar, ProfitLossDirectionName TVarChar, ProfitLossName  TVarChar
             , PL_GroupName_original TVarChar, PL_DirectionName_original TVarChar, PL_Name_original  TVarChar
             , UnitName_ProfitLoss TVarChar
             --, InfoMoneyGroupCode Integer, InfoMoneyDestinationCode Integer, InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar
             , DirectionObjectCode Integer, DirectionObjectName TVarChar
             , MovementDescName TVarChar
             , Amount         TFloat
             --, DemoPersent    TFloat
             --, Amount_10101   TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_ProfitLoss());
     vbUserId:= lpGetUserBySession (inSession);


     -- Результат
     RETURN QUERY 
                            -- ??? как сделать что б не попали операции переброски накопленной прибыль прошлого месяца в долг по прибыли???
     WITH tmpMIContainer AS (SELECT MIContainer.ContainerId
                                  , -1 * SUM (MIContainer.Amount)      AS Amount
                                  , MIContainer.ObjectExtId_Analyzer   AS UnitId_ProfitLoss
                                  , MIContainer.WhereObjectId_Analyzer AS DirectionId
                                  , MIContainer.MovementDescId
                             FROM MovementItemContainer AS MIContainer 
                             WHERE MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                               AND MIContainer.AccountId = zc_Enum_Account_100301()
                               AND MIContainer.isActive = FALSE
                             GROUP BY MIContainer.ContainerId
                                    , MIContainer.ObjectExtId_Analyzer
                                    , MIContainer.WhereObjectId_Analyzer
                                    , MIContainer.MovementDescId
                            )
        , tmpProfitLoss AS (SELECT CLO_ProfitLoss.ObjectId                AS ProfitLossId
                                 , tmpMIContainer.MovementDescId
                                 , tmpMIContainer.DirectionId
                                 , tmpMIContainer.UnitId_ProfitLoss
                                 , SUM (tmpMIContainer.Amount) AS Amount
                            FROM tmpMIContainer
                                 LEFT JOIN ContainerLinkObject AS CLO_ProfitLoss
                                                               ON CLO_ProfitLoss.ContainerId = tmpMIContainer.ContainerId
                                                              AND CLO_ProfitLoss.DescId = zc_ContainerLinkObject_ProfitLoss()
                            GROUP BY CLO_ProfitLoss.ObjectId
                                   , tmpMIContainer.MovementDescId
                                   , tmpMIContainer.DirectionId
                                   , tmpMIContainer.UnitId_ProfitLoss
                           )

      , tmpView_ProfitLoss AS (SELECT View_ProfitLoss.*
                               FROM Object_ProfitLoss_View AS View_ProfitLoss
                               WHERE View_ProfitLoss.ProfitLossCode <> 70101 -- Чистая прибыль
                               )

      , tmpProfitLossDemo AS (SELECT DISTINCT
                                     ObjectLink_ProfitLoss_ProfitLoss.ChildObjectId  AS ProfitLossId
                                   , ObjectLink_ProfitLoss_Unit.ChildObjectId        AS UnitId
                                   , ObjectFloat_Value.ValueData                     AS Value
                              FROM Object AS Object_ProfitLossDemo
                                   LEFT JOIN ObjectLink AS ObjectLink_ProfitLoss_ProfitLoss
                                                        ON ObjectLink_ProfitLoss_ProfitLoss.ObjectId = Object_ProfitLossDemo.Id
                                                       AND ObjectLink_ProfitLoss_ProfitLoss.DescId   = zc_ObjectLink_ProfitLossDemo_ProfitLoss()

                                   INNER JOIN tmpView_ProfitLoss ON tmpView_ProfitLoss.ProfitLossId = ObjectLink_ProfitLoss_ProfitLoss.ChildObjectId

                                   LEFT JOIN ObjectLink AS ObjectLink_ProfitLoss_Unit
                                                        ON ObjectLink_ProfitLoss_Unit.ObjectId = Object_ProfitLossDemo.Id
                                                       AND ObjectLink_ProfitLoss_Unit.DescId   = zc_ObjectLink_ProfitLossDemo_Unit()

                                   INNER JOIN ObjectFloat AS ObjectFloat_Value
                                                          ON ObjectFloat_Value.ObjectId = Object_ProfitLossDemo.Id 
                                                         AND ObjectFloat_Value.DescId   = zc_ObjectFloat_ProfitLossDemo_Value()
                                                         AND COALESCE (ObjectFloat_Value.ValueData, 0) <> 0                                                        
                              WHERE Object_ProfitLossDemo.DescId = zc_Object_ProfitLossDemo()
                                AND Object_ProfitLossDemo.isErased = FALSE
                              )

      , tmpReport AS (SELECT tmpProfitLoss.ProfitLossId
                         , tmpProfitLoss.UnitId_ProfitLoss
                         , tmpProfitLoss.DirectionId
                         , tmpProfitLoss.MovementDescId
                         , SUM (tmpProfitLoss.Amount)  AS Amount
                    FROM tmpProfitLoss
                    GROUP BY tmpProfitLoss.ProfitLossId
                           , tmpProfitLoss.UnitId_ProfitLoss
                           , tmpProfitLoss.DirectionId
                           , tmpProfitLoss.MovementDescId
                   )

      , tmpDemo AS (SELECT tmpProfitLossDemo.ProfitLossId
                         , tmpProfitLossDemo.UnitId
                         , (COALESCE (tmp_10101.Amount, 0) * COALESCE (tmpProfitLossDemo.Value, 0) / 100)  AS Amount
                    FROM tmpProfitLossDemo
                         LEFT JOIN (SELECT tmpReport.UnitId_ProfitLoss
                                         , SUM (tmpReport.Amount) AS Amount
                                    FROM tmpReport
                                    WHERE tmpReport.ProfitLossId = 221                      ---- 10101 Сумма по ценам прайса
                                    GROUP BY tmpReport.UnitId_ProfitLoss
                                    ) AS tmp_10101 ON tmp_10101.UnitId_ProfitLoss = tmpProfitLossDemo.UnitId
                    )

     -- результат
      SELECT
             View_ProfitLoss.ProfitLossGroupName
           , View_ProfitLoss.ProfitLossDirectionName
           , View_ProfitLoss.ProfitLossName
           --для печатной формы без кода
           , View_ProfitLoss.ProfitLossGroupName_original
           , View_ProfitLoss.ProfitLossDirectionName_original
           , View_ProfitLoss.ProfitLossName_original

           , Object_Unit_ProfitLoss.ValueData AS UnitName_ProfitLoss

           , Object_Direction.ObjectCode   AS DirectionObjectCode
           , Object_Direction.ValueData    AS DirectionObjectName

           , MovementDesc.ItemName         AS MovementDescName

           , COALESCE (tmpReport.Amount, 0) :: TFloat AS Amount

      FROM tmpView_ProfitLoss AS View_ProfitLoss
           
           LEFT JOIN tmpReport ON tmpReport.ProfitLossId = View_ProfitLoss.ProfitLossId
           
           LEFT JOIN Object AS Object_Direction   ON Object_Direction.Id   = tmpReport.DirectionId

           LEFT JOIN MovementDesc ON MovementDesc.Id = tmpReport.MovementDescId

           LEFT JOIN Object AS Object_Unit_ProfitLoss   ON Object_Unit_ProfitLoss.Id = tmpReport.UnitId_ProfitLoss
      WHERE View_ProfitLoss.ProfitLossName is not null
    UNION
      SELECT
             View_ProfitLoss.ProfitLossGroupName
           , View_ProfitLoss.ProfitLossDirectionName
           , View_ProfitLoss.ProfitLossName
           --для печатной формы без кода
           , View_ProfitLoss.ProfitLossGroupName_original
           , View_ProfitLoss.ProfitLossDirectionName_original
           , View_ProfitLoss.ProfitLossName_original

           , Object_Unit_ProfitLoss.ValueData AS UnitName_ProfitLoss

           , Object_Direction.ObjectCode   AS DirectionObjectCode
           , Object_Direction.ValueData    AS DirectionObjectName

           , MovementDesc.ItemName         AS MovementDescName

           , COALESCE (tmpDemo.Amount, 0) :: TFloat AS Amount

      FROM tmpView_ProfitLoss AS View_ProfitLoss
           
           LEFT JOIN tmpDemo ON tmpDemo.ProfitLossId = View_ProfitLoss.ProfitLossId
           LEFT JOIN Object AS Object_Direction ON Object_Direction.Id = Null

           LEFT JOIN MovementDesc ON MovementDesc.Id = Null
           
           LEFT JOIN Object AS Object_Unit_ProfitLoss   ON Object_Unit_ProfitLoss.Id = tmpDemo.UnitId
      WHERE View_ProfitLoss.ProfitLossId NOT IN (SELECT DISTINCT tmpReport.ProfitLossId FROM tmpReport WHERE COALESCE (tmpReport.Amount,0) <> 0)
      ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.03.19         *
*/

-- тест
-- SELECT * FROM gpReport_ProfitDemo (inStartDate:= '31.07.2016', inEndDate:= '31.07.2016', inSession:= '2') WHERE Amount <> 0 ORDER BY 5
