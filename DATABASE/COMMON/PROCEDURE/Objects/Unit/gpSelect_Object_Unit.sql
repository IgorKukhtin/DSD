-- Function: gpSelect_Object_Unit()

DROP FUNCTION IF EXISTS gpSelect_Object_Unit (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Unit(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, 
               ParentId Integer, ParentName TVarChar,
               BusinessId Integer, BusinessName TVarChar, 
               BranchId Integer, BranchName TVarChar,
               JuridicalId Integer, JuridicalName TVarChar,
               AccountGroupCode Integer, AccountGroupName TVarChar,
               AccountDirectionCode Integer, AccountDirectionName TVarChar,
               ProfitLossGroupCode Integer, ProfitLossGroupName TVarChar,
               ProfitLossDirectionCode Integer, ProfitLossDirectionName TVarChar,
               isErased boolean, isLeaf boolean) AS
$BODY$
   DECLARE vbUserId Integer;
   -- DECLARE vbAccessKeyAll Boolean;

   DECLARE vbIsConstraint Boolean;
   DECLARE vbObjectId_Constraint Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_Unit());
   vbUserId:= lpGetUserBySession (inSession);

   -- определяется - может ли пользовать видеть весь справочник
   -- vbAccessKeyAll:= zfCalc_AccessKey_GuideAll (vbUserId);

   -- определяется уровень доступа
   vbObjectId_Constraint:= (SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0);
   vbIsConstraint:= COALESCE (vbObjectId_Constraint, 0) > 0;


   -- Результат
   RETURN QUERY 
     WITH Object_AccountDirection AS (SELECT * FROM Object_AccountDirection_View)
       SELECT 
             Object_Unit_View.Id     
           , Object_Unit_View.Code   
           , Object_Unit_View.Name
         
           , COALESCE (Object_Unit_View.ParentId, 0) AS ParentId
           , Object_Unit_View.ParentName 

           , Object_Unit_View.BusinessId
           , Object_Unit_View.BusinessName 
         
           , Object_Unit_View.BranchId
           , Object_Unit_View.BranchName
         
           , Object_Unit_View.JuridicalId
           , Object_Unit_View.JuridicalName
         
           , View_AccountDirection.AccountGroupCode
           , View_AccountDirection.AccountGroupName
           , View_AccountDirection.AccountDirectionCode
           , View_AccountDirection.AccountDirectionName
         
           , lfObject_Unit_byProfitLossDirection.ProfitLossGroupCode
           , lfObject_Unit_byProfitLossDirection.ProfitLossGroupName
           , lfObject_Unit_byProfitLossDirection.ProfitLossDirectionCode
           , lfObject_Unit_byProfitLossDirection.ProfitLossDirectionName
         
           , Object_Unit_View.isErased
           , Object_Unit_View.isLeaf
       FROM Object_Unit_View
            LEFT JOIN lfSelect_Object_Unit_byProfitLossDirection() AS lfObject_Unit_byProfitLossDirection ON lfObject_Unit_byProfitLossDirection.UnitId = Object_Unit_View.Id
            LEFT JOIN Object_AccountDirection AS View_AccountDirection ON View_AccountDirection.AccountDirectionId = Object_Unit_View.AccountDirectionId
       -- WHERE vbAccessKeyAll = TRUE
       WHERE (Object_Unit_View.BranchId = vbObjectId_Constraint
              OR vbIsConstraint = FALSE
              OR Object_Unit_View.Id IN (8459 -- Склад Реализации
                                       , 8462 -- Склад Брак
                                       , 8461 -- Склад Возвратов
                                       , 256716 -- Склад УТИЛЬ
                                        )
             )
      UNION ALL
       SELECT 
             Object_Partner.Id     
           , Object_Partner.ObjectCode   
           , Object_Partner.ValueData
         
           , 0 :: Integer AS ParentId
           , '' :: TVarChar AS ParentName 

           , 0 :: Integer AS BusinessId
           , '' :: TVarChar AS BusinessName 
         
           , Object_Branch.Id :: Integer AS BranchId
           , Object_Branch.ValueData :: TVarChar AS BranchName
         
           , 0 :: Integer AS JuridicalId
           , '' :: TVarChar AS JuridicalName
         
           , 0 :: Integer AS AccountGroupCode
           , '' :: TVarChar AS AccountGroupName
           , 0 :: Integer AS AccountDirectionCode
           , '' :: TVarChar AS AccountDirectionName
         
           , 0 :: Integer AS ProfitLossGroupCode
           , '' :: TVarChar AS ProfitLossGroupName
           , 0 :: Integer AS ProfitLossDirectionCode
           , '' :: TVarChar AS ProfitLossDirectionName
         
           , FALSE AS isErased
           , TRUE AS isLeaf
       FROM Object as Object_Partner
            LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                 ON ObjectLink_Unit_Branch.ObjectId = Object_Partner.Id
                                AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
            LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_Unit_Branch.ChildObjectId
       WHERE Object_Partner.Id IN (298605 -- Одесса - "ОГОРЕНКО новый дистрибьютор"
                                   , 256624 -- Никополь - "Мержиєвський О.В. ФОП м. Нікополь вул. Альпова 6"
                                    )
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Unit (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.09.14                                        * add Object_RoleAccessKeyGuide_View
 21.12.13                                        * ParentId
 21.11.13                       * добавил WITH из-за неправильной оптимизации DISTINCT и GROUP BY в 9.3
 03.11.13                                        * add lfSelect_Object_Unit_byProfitLossDirection and Object_AccountDirection_View
 28.10.13                         * переход на View              
 04.07.13          * дополнение всеми реквизитами              
 03.06.13          
*/

-- тест
-- SELECT * FROM gpSelect_Object_Unit (zfCalc_UserAdmin())