-- Function: gpSelect_Object_Member_ContainerByDebt (Integer, Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Member_ContainerByDebt (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Member_ContainerByDebt(
    IN inMemberId    Integer,       --
    IN inIsShowAll   Boolean,       --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, DescName TVarChar
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , BranchId Integer, BranchCode Integer, BranchName TVarChar
             , JuridicalBasisId Integer, JuridicalBasisName TVarChar
             , AccountId Integer, AccountName TVarChar
             , CarId Integer, CarName TVarChar
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
            (SELECT CLO_Member.ObjectId AS MemberId
                 -- COALESCE (ObjectLink_Member.ChildObjectId, CLO_Member.ObjectId) AS MemberId
                  , CLO_InfoMoney.ObjectId AS InfoMoneyId
                  , CLO_Branch.ObjectId    AS BranchId
                  , CLO_Car.ObjectId       AS CarId
                  , CLO_JuridicalBasis.ObjectId AS JuridicalBasisId
                  , Object_Account.Id      AS AccountId
                  , Container.Amount
                  , Container.Id
                  , ObjectLink_Member.ChildObjectId AS MemberId_jur
             FROM Container                                        
                  INNER JOIN ContainerLinkObject AS CLO_Member
                                                 ON CLO_Member.ContainerId = Container.Id
                                                AND CLO_Member.DescId = zc_ContainerLinkObject_Member()
                                                AND CLO_Member.ObjectId > 0
                  LEFT JOIN ContainerLinkObject AS CLO_Goods
                                                ON CLO_Goods.ContainerId = Container.Id
                                               AND CLO_Goods.DescId = zc_ContainerLinkObject_Goods()
                                               AND CLO_Goods.ObjectId > 0
                  LEFT JOIN ObjectLink AS ObjectLink_Member
                                       ON ObjectLink_Member.ObjectId = CLO_Member.ObjectId
                                      AND ObjectLink_Member.DescId      = zc_ObjectLink_Personal_Member()
                  LEFT JOIN ContainerLinkObject AS CLO_InfoMoney
                                                ON CLO_InfoMoney.ContainerId = Container.Id
                                               AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                  LEFT JOIN ContainerLinkObject AS CLO_Car
                                                ON CLO_Car.ContainerId = Container.Id
                                               AND CLO_Car.DescId = zc_ContainerLinkObject_Car()
                  LEFT JOIN ContainerLinkObject AS CLO_Branch
                                                ON CLO_Branch.ContainerId = Container.Id
                                               AND CLO_Branch.DescId = zc_ContainerLinkObject_Branch() 
                  LEFT JOIN ContainerLinkObject AS CLO_JuridicalBasis
                                                ON CLO_JuridicalBasis.ContainerId = Container.Id
                                               AND CLO_JuridicalBasis.DescId = zc_ContainerLinkObject_JuridicalBasis()
                  LEFT JOIN Object AS Object_Account ON Object_Account.Id = Container.ObjectId
             WHERE Container.DescId = zc_Container_Summ()
               AND Container.Amount <> 0
               AND (CLO_Member.ObjectId = inMemberId OR ObjectLink_Member.ObjectId = inMemberId OR COALESCE (inMemberId, 0) = 0)
               AND CLO_Goods.ContainerId IS NULL
            )
     , tmpMember AS (SELECT *
                     FROM Object
                     WHERE Object.DescId = zc_Object_Member()
                       AND Object.isErased = FALSE 
                    )


       -- Результат
       SELECT Object_Member.Id
            , Object_Member.ObjectCode         AS Code
            , Object_Member.ValueData          AS Name
            , ObjectDesc.ItemName              AS DescName
            , View_InfoMoney.InfoMoneyId
            , View_InfoMoney.InfoMoneyCode
            , View_InfoMoney.InfoMoneyName
            , (View_InfoMoney.InfoMoneyName_all
              || ' ('
              || CASE WHEN tmpContainer.MemberId_jur > 0 THEN '*' ELSE '' END
              || tmpContainer.Id :: TVarChar
              || ')'
              ) :: TVarChar AS InfoMoneyName_all
            , Object_Branch.Id                    AS BranchId
            , Object_Branch.ObjectCode            AS BranchCode
            , Object_Branch.ValueData             AS BranchName
            , Object_JuridicalBasis.Id            AS JuridicalBasisId
            , Object_JuridicalBasis.ValueData     AS JuridicalBasisName              
            , Object_Account_View.AccountId       AS AccountId
            , Object_Account_View.AccountName_All AS AccountName
            , Object_Car.Id                       AS CarId
            , (COALESCE (Object_CarModel.ValueData, '')|| COALESCE (' ' || Object_CarType.ValueData, '') || ' ' || COALESCE (Object_Car.ValueData, '')) :: TVarChar AS CarName 
            , CASE WHEN tmpContainer.Amount > 0 THEN tmpContainer.Amount ELSE 0 END                    ::TFloat AS AmountDebet
            , CASE WHEN tmpContainer.Amount < 0 THEN -1 * tmpContainer.Amount ELSE 0 END               ::TFloat AS AmountKredit
            , tmpContainer.Amount                                                                      ::TFloat AS Amount
            , CASE WHEN tmpContainer.Amount <> 0 THEN FALSE ELSE TRUE END :: Boolean AS isErased
       FROM tmpContainer
            LEFT JOIN Object AS Object_Member ON Object_Member.Id = tmpContainer.MemberId
            LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Member.DescId
            LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = tmpContainer.BranchId
            LEFT JOIN Object AS Object_JuridicalBasis ON Object_JuridicalBasis.Id = tmpContainer.JuridicalBasisId
            LEFT JOIN Object_Account_View             ON Object_Account_View.AccountId = tmpContainer.AccountId
            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = tmpContainer.InfoMoneyId
            LEFT JOIN Object AS Object_Car ON Object_Car.Id = tmpContainer.CarId
            
            LEFT JOIN ObjectLink AS Car_CarModel 
                                 ON Car_CarModel.ObjectId = Object_Car.Id
                                AND Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
            LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = Car_CarModel.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Car_CarType
                                 ON ObjectLink_Car_CarType.ObjectId = Object_Car.Id
                                AND ObjectLink_Car_CarType.DescId = zc_ObjectLink_Car_CarType()
            LEFT JOIN Object AS Object_CarType ON Object_CarType.Id = ObjectLink_Car_CarType.ChildObjectId

      UNION
       SELECT Object_Member.Id
            , Object_Member.ObjectCode         AS Code
            , Object_Member.ValueData          AS Name
            , ObjectDesc.ItemName              AS DescName
            , 0              AS InfoMoneyId
            , 0              AS InfoMoneyCode
            , '' :: TVarChar AS InfoMoneyName
            , '' :: TVarChar AS InfoMoneyName_all
            , 0              AS BranchId
            , 0              AS BranchCode
            , '' :: TVarChar AS BranchName
            , 0              AS JuridicalBasisId
            , '' :: TVarChar AS JuridicalBasisName              
            , 0              AS AccountId
            , '' :: TVarChar AS AccountName
            , 0              AS CarId
            , '' :: TVarChar AS CarName
            , 0  ::TFloat    AS AmountDebet
            , 0  ::TFloat    AS AmountKredit
            , 0  ::TFloat    AS Amount
            , TRUE:: Boolean AS isErased
       FROM tmpMember AS Object_Member
           LEFT JOIN tmpContainer ON tmpContainer.MemberId = Object_Member.Id
           LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Member.DescId
       WHERE tmpContainer.MemberId IS NULL    
         AND inIsShowAll = TRUE
      ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.10.22         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Member_ContainerByDebt (0, FALSE, zfCalc_UserAdmin())
