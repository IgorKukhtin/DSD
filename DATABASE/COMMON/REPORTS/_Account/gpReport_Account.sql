-- Function: gpReport_Account ()

DROP FUNCTION IF EXISTS gpReport_Account (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Account (
    IN inStartDate    TDateTime ,  
    IN inEndDate      TDateTime ,
    IN inAccountId    Integer   ,
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE  (PersonalCode Integer, PersonalName TVarChar
              , InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar
              , CarModelName TVarChar, CarCode Integer, CarName TVarChar
              , StartSumm TFloat, InSumm TFloat, OutSumm TFloat, EndSumm TFloat
              )  
AS
$BODY$
BEGIN

    RETURN QUERY        
    SELECT View_Personal.PersonalCode
         , View_Personal.PersonalName
         
         , Object_InfoMoney_View.InfoMoneyCode
         , Object_InfoMoney_View.InfoMoneyGroupName
         , Object_InfoMoney_View.InfoMoneyDestinationName
         , Object_InfoMoney_View.InfoMoneyName
         
         , Object_CarModel.ValueData AS CarModelName
         , Object_Car.ObjectCode     AS CarCode       
         , Object_Car.ValueData      AS CarName

        , tmpContainerLink.StartSumm :: TFloat AS StartSumm
        , tmpContainerLink.InSumm    :: TFloat AS InSumm
        , tmpContainerLink.OutSumm   :: TFloat AS OutSumm
        , tmpContainerLink.EndSumm   :: TFloat AS EndSumm
   FROM      
       (SELECT ContainerLinkObject_Personal.ObjectId  AS PersonalId
             , ContainerLinkObject_InfoMoney.ObjectId AS InfoMoneyId
             , ContainerLinkObject_Car.ObjectId AS CarId
             , SUM (tmpContainer.StartSumm) AS StartSumm
             , SUM (tmpContainer.InSumm)    AS InSumm
             , SUM (tmpContainer.OutSumm)   AS OutSumm
             , SUM (tmpContainer.EndSumm)   AS EndSumm
        FROM
            (SELECT Container.Id AS ContainerId 
                  , CAST (Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS TFloat) AS StartSumm
                  , CAST (COALESCE (SUM (CASE WHEN MIContainer.Amount > 0 THEN MIContainer.Amount ELSE 0 END), 0) AS TFloat) AS InSumm
                  , CAST (COALESCE (SUM (CASE WHEN MIContainer.Amount < 0 THEN -1 * MIContainer.Amount ELSE 0 END), 0) AS TFloat) AS OutSumm
                  , CAST (Container.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN  MIContainer.Amount ELSE 0 END), 0) AS TFloat) AS EndSumm
             FROM
                 (SELECT inAccountId AS AccountId) AS tmpAccount -- счет --(select Id AS AccountId from Object where descId = zc_Object_Account() and objectcode in (30505,30508) ) AS tmpAccount  -- счет 
                 JOIN Container ON Container.ObjectId = tmpAccount.AccountId
                               AND Container.DescId = zc_Container_Summ()
                 LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.Containerid = Container.Id 
                                                               AND MIContainer.OperDate between inStartDate AND inEndDate
             GROUP BY Container.Id 
             HAVING (Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0)
                 OR (COALESCE (SUM (CASE WHEN MIContainer.Amount > 0 THEN  MIContainer.Amount ELSE 0 END), 0) <> 0)
                 OR (COALESCE (SUM (CASE WHEN MIContainer.Amount < 0 THEN -MIContainer.Amount ELSE 0 END), 0) <> 0)
        
           ) AS tmpContainer
            LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Personal ON ContainerLinkObject_Personal.ContainerId = tmpContainer.ContainerId
                                                                         AND ContainerLinkObject_Personal.DescId = zc_ContainerLinkObject_Personal()
            LEFT JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoney ON ContainerLinkObject_InfoMoney.ContainerId = tmpContainer.ContainerId
                                                                          AND ContainerLinkObject_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
            LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Car ON ContainerLinkObject_Car.ContainerId = tmpContainer.ContainerId
                                                                    AND ContainerLinkObject_Car.DescId = zc_ContainerLinkObject_Car()
        GROUP BY ContainerLinkObject_Personal.ObjectId      
               , ContainerLinkObject_InfoMoney.ObjectId
               , ContainerLinkObject_Car.ObjectId
       ) AS tmpContainerLink 
       LEFT JOIN Object_Personal_View AS View_Personal ON View_Personal.PersonalId = tmpContainerLink.PersonalId
       LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = tmpContainerLink.InfoMoneyId
       LEFT JOIN Object AS Object_Car ON Object_Car.Id = tmpContainerLink.CarId
       LEFT JOIN ObjectLink AS ObjectLink_Car_CarModel ON ObjectLink_Car_CarModel.ObjectId = Object_Car.Id
                                                      AND ObjectLink_Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
       LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = ObjectLink_Car_CarModel.ChildObjectId
    ;
    
        
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpReport_Account (TDateTime, TDateTime, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.10.13                                        * err InfoManey
 07.10.13         *  
*/

-- тест
-- SELECT * FROM gpReport_Account (inStartDate:= '01.10.2013', inEndDate:= '31.10.2013', inAccountId:= null, inSession:= zfCalc_UserAdmin());
