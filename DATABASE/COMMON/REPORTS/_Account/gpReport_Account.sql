-- Function: lfReport_Account ()

-- DROP FUNCTION lfReport_Account ();

CREATE OR REPLACE FUNCTION lfReport_Account (
    IN inStartDate    TDateTime ,  
    IN inEndDate      TDateTime ,
    IN inAccount      integer 
)
RETURNS TABLE  (PersonalId integer, PersonalCode integer, PersonalName TVarChar
              , InfoManeyId integer, InfoManeyCode integer, InfoManeyName TVarChar
              , CarId integer, CarCode integer, CarName TVarChar
              , StartSum TFloat, InSumm TFloat, OutSumm TFloat, EndSumm TFloat
              )  
AS
$BODY$
BEGIN

    RETURN QUERY        
    SELECT  Container.Id -- счет количественный
          , Object_Personal.ValueData  AS PersonalName
          , Object_InfoManey.ValueData  AS InfoManeyName
          , Object_Car.ValueData  AS CarName
                             
          , CAST (Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS TFloat) AS StartSumm
  
          , CAST (CASE WHEN  COALESCE(MIContainer.Amount, 0) >=0  THEN COALESCE(MIContainer.Amount, 0) ELSE 0 END)  AS TFloat)   AS InSumm
          , CAST (CASE WHEN  COALESCE(MIContainer.Amount, 0) < 0  THEN COALESCE(MIContainer.Amount, 0) ELSE 0 END)  AS TFloat)   AS OutSumm
 
          , CAST (Container.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN  MIContainer.Amount ELSE 0 END), 0) AS TFloat) AS EndSumm
          
    FROM (select Id as AccountId from Object where descId = zc_Object_Account() ) as tmpAccount  -- (SELECT inAcountId AS AccountId) AS tmpAccount -- счет 
        
        LEFT JOIN Container ON Container.ObjectId = tmpAccount.AccountId
                           AND Container.DescId = zc_Container_Summ()
                                             
        LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.Containerid = Container.Id 
                                                      AND MIContainer.OperDate between inStartDate AND inEndDate
                                                      
        LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Personal ON ContainerLinkObject_Personal.ObjectId = Container.Id 
                                                                AND ContainerLinkObject_Personal.DescId = zc_ContainerLinkObject_Personal()
        LEFT JOIN Object AS Object_Personal ON Object_Personal.Id=ContainerLinkObject_Personal.ObjectId
        
        LEFT JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoney ON ContainerLinkObject_InfoMoney.ObjectId = Container.Id 
                                                                AND ContainerLinkObject_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
        LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id=ContainerLinkObject_InfoMoney.ObjectId

        LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Car ON ContainerLinkObject_Car.ObjectId = Container.Id 
                                                                AND ContainerLinkObject_Car.DescId = zc_ContainerLinkObject_Car()
        LEFT JOIN Object AS Object_Car ON Object_Car.Id=ContainerLinkObject_Car.ObjectId
        
        HAVING (Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0)
            OR (COALESCE (SUM (CASE WHEN MIContainer.Amount > 0 AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN  MIContainer.Amount ELSE 0 END), 0) <> 0)
            OR (COALESCE (SUM (CASE WHEN MIContainer.Amount < 0 AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN -MIContainer.Amount ELSE 0 END), 0) <> 0);
            
END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;

ALTER FUNCTION lfReport_Account (TDateTime, TDateTime) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.09.13         *  
*/

-- тест
/*

CREATE TEMP TABLE _tmpGoods (GoodsId Integer) ON COMMIT DROP;
CREATE TEMP TABLE _tmpLocation (LocationId Integer) ON COMMIT DROP;

INSERT INTO _tmpGoods (GoodsId) SELECT  Id FROM Object WHERE DescId = zc_Object_Goods(); 
INSERT INTO _tmpLocation (LocationId) SELECT  Id FROM Object WHERE DescId = zc_Object_Unit() UNION ALL SELECT Id FROM Object WHERE DescId = zc_Object_Personal();

SELECT * FROM lfReport_Account (inStartDate:= '01.01.2013', inEndDate:= '01.01.2013') as lfMotionContainer_SummList
left join object as object_Goods on object_Goods.Id = lfMotionContainer_SummList.GoodsId 
left join object as object_Location on object_Location.Id = lfMotionContainer_SummList.LocationId ;



*/