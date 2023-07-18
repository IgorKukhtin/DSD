-- Function: gpSelect_Object_Member_Container (Integer, Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Member_Container (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Member_Container(
    IN inMemberId    Integer,       --
    IN inIsShowAll   Boolean,       --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , BranchCode Integer, BranchName TVarChar
             , CarName TVarChar
             , AmountDebet TFloat
             , AmountKredit TFloat
             , Amount TFloat
             , isErased Boolean) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId_Constraint Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_Member());
   vbUserId:= lpGetUserBySession (inSession);

   -- определяется уровень доступа
   vbObjectId_Constraint:= (SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.BranchId);

   -- Результат
   RETURN QUERY 
       WITH tmpContainer AS
            (SELECT CLO_Member.ContainerId AS ContainerId
                  , CLO_Member.ObjectId    AS MemberId
                  , CLO_InfoMoney.ObjectId AS InfoMoneyId
                  , CLO_Branch.ObjectId    AS BranchId
                  , CLO_Car.ObjectId       AS CarId
                  , Container.Amount
             FROM ContainerLinkObject AS CLO_Member
                  INNER JOIN Container ON Container.Id = CLO_Member.ContainerId
                                      AND Container.DescId = zc_Container_Summ()
                  LEFT JOIN ContainerLinkObject AS CLO_Goods
                                                ON CLO_Goods.ContainerId = CLO_Member.ContainerId
                                               AND CLO_Goods.DescId = zc_ContainerLinkObject_Goods()
                  LEFT JOIN ContainerLinkObject AS CLO_InfoMoney
                                                ON CLO_InfoMoney.ContainerId = CLO_Member.ContainerId
                                               AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                  LEFT JOIN ContainerLinkObject AS CLO_Car
                                                ON CLO_Car.ContainerId = CLO_Member.ContainerId
                                               AND CLO_Car.DescId = zc_ContainerLinkObject_Car()
                  LEFT JOIN ContainerLinkObject AS CLO_Branch
                                                ON CLO_Branch.ContainerId = CLO_Member.ContainerId
                                               AND CLO_Branch.DescId = zc_ContainerLinkObject_Branch()
             WHERE CLO_Member.DescId = zc_ContainerLinkObject_Member()
               AND (CLO_Member.ObjectId = inMemberId OR COALESCE (inMemberId, 0) = 0)
               AND CLO_Goods.ContainerId IS NULL
               AND (Container.Amount <> 0 OR inIsShowAll = TRUE)
               AND (CLO_Branch.ObjectId = vbObjectId_Constraint OR COALESCE (vbObjectId_Constraint, 0) = 0)
            )

       -- Результат
       SELECT Object_Member.Id
            , Object_Member.ObjectCode AS Code
            , Object_Member.ValueData  AS Name
            , View_InfoMoney.InfoMoneyId
            , View_InfoMoney.InfoMoneyCode
            , View_InfoMoney.InfoMoneyName
            , View_InfoMoney.InfoMoneyName_all
            , Object_Branch.ObjectCode AS BranchCode
            , Object_Branch.ValueData  AS BranchName
            , (COALESCE (Object_CarModel.ValueData, '')|| COALESCE (' ' || Object_CarType.ValueData, '') || ' ' || COALESCE (Object_Car.ValueData, '')) :: TVarChar AS CarName
            , CASE WHEN tmpContainer.Amount > 0 THEN tmpContainer.Amount ELSE 0 END ::TFloat AS AmountDebet
            , CASE WHEN tmpContainer.Amount < 0 THEN -1 * tmpContainer.Amount ELSE 0 END ::TFloat AS AmountKredit
            , tmpContainer.Amount ::TFloat AS Amount
            , CASE WHEN tmpContainer.Amount <> 0 THEN FALSE ELSE TRUE END :: Boolean AS isErased
       FROM tmpContainer
            LEFT JOIN Object AS Object_Member ON Object_Member.Id = tmpContainer.MemberId
            LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = tmpContainer.BranchId
            FULL JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = tmpContainer.InfoMoneyId
            LEFT JOIN Object AS Object_Car ON Object_Car.Id = tmpContainer.CarId

            LEFT JOIN ObjectLink AS Car_CarModel ON Car_CarModel.ObjectId = Object_Car.Id
                                                AND Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
            LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = Car_CarModel.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Car_CarType
                                 ON ObjectLink_Car_CarType.ObjectId = Object_Car.Id
                                AND ObjectLink_Car_CarType.DescId = zc_ObjectLink_Car_CarType()
            LEFT JOIN Object AS Object_CarType ON Object_CarType.Id = ObjectLink_Car_CarType.ChildObjectId
      ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Member_Container (Integer, Boolean, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.04.15                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Member_Container (0, FALSE, zfCalc_UserAdmin())
