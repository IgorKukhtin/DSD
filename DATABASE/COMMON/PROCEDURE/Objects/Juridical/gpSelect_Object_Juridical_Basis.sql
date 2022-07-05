-- Function: gpSelect_Object_Juridical_Basis()

-- DROP FUNCTION IF EXISTS gpSelect_Object_Juridical_Basis (TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_Juridical_Basis (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Juridical_Basis(
    IN inShowAll        Boolean,   
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,
          
               GLNCode TVarChar, isCorporate Boolean,
               JuridicalGroupName TVarChar,
               GoodsPropertyName TVarChar,
            
               InfoMoneyGroupCode Integer, InfoMoneyGroupName TVarChar, 
               InfoMoneyDestinationCode Integer, InfoMoneyDestinationName TVarChar, 
               InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar,
               OKPO TVarChar,
               isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsIrna   Boolean;

   DECLARE vbIsConstraint Boolean;
   DECLARE vbObjectId_Constraint Integer;
   DECLARE vbObjectId_Branch_Constraint Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   IF inSession <> '80373'
   THEN
       vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_Juridical_Basis());
   ELSE
       vbUserId:= lpGetUserBySession (inSession);
   END IF;

   -- !!!Ирна!!!
   vbIsIrna:= zfCalc_User_isIrna (vbUserId);

   -- определяется уровень доступа
   vbObjectId_Constraint:= (SELECT Object_RoleAccessKeyGuide_View.JuridicalGroupId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.JuridicalGroupId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.JuridicalGroupId);
   vbObjectId_Branch_Constraint:= (SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.BranchId);
   vbIsConstraint:= zfCalc_AccessKey_GuideAll (vbUserId) = FALSE AND (COALESCE (vbObjectId_Constraint, 0) > 0 OR COALESCE (vbObjectId_Branch_Constraint, 0) > 0);


   -- Результат
   RETURN QUERY
   WITH tmpIsErased AS (SELECT FALSE AS isErased UNION ALL SELECT inShowAll AS isErased WHERE inShowAll = TRUE)

   SELECT 
         Object_Juridical.Id             AS Id 
       , Object_Juridical.ObjectCode     AS Code
       , Object_Juridical.ValueData      AS Name
        
       , ObjectString_GLNCode.ValueData      AS GLNCode
       , ObjectBoolean_isCorporate.ValueData AS isCorporate

       , Object_JuridicalGroup.ValueData  AS JuridicalGroupName

       , Object_GoodsProperty.ValueData  AS GoodsPropertyName

       , Object_InfoMoney_View.InfoMoneyGroupCode
       , Object_InfoMoney_View.InfoMoneyGroupName
       , Object_InfoMoney_View.InfoMoneyDestinationCode
       , Object_InfoMoney_View.InfoMoneyDestinationName
       , Object_InfoMoney_View.InfoMoneyId
       , Object_InfoMoney_View.InfoMoneyCode
       , Object_InfoMoney_View.InfoMoneyName
       , Object_InfoMoney_View.InfoMoneyName_all

       , ObjectHistory_JuridicalDetails_View.OKPO 
       
       , Object_Juridical.isErased AS isErased
       
   FROM tmpIsErased

        INNER JOIN Object AS Object_Juridical 
                          ON Object_Juridical.isErased = tmpIsErased.isErased
                         AND Object_Juridical.DescId = zc_Object_Juridical()
                         
        LEFT JOIN ObjectBoolean AS ObjectBoolean_isCorporate
                                ON ObjectBoolean_isCorporate.ObjectId = Object_Juridical.Id 
                               AND ObjectBoolean_isCorporate.DescId = zc_ObjectBoolean_Juridical_isCorporate()

        LEFT JOIN ObjectString AS ObjectString_GLNCode 
                               ON ObjectString_GLNCode.ObjectId = Object_Juridical.Id 
                              AND ObjectString_GLNCode.DescId = zc_ObjectString_Juridical_GLNCode()
        
        LEFT JOIN ObjectLink AS ObjectLink_Juridical_JuridicalGroup
                             ON ObjectLink_Juridical_JuridicalGroup.ObjectId = Object_Juridical.Id 
                            AND ObjectLink_Juridical_JuridicalGroup.DescId = zc_ObjectLink_Juridical_JuridicalGroup()
        LEFT JOIN Object AS Object_JuridicalGroup ON Object_JuridicalGroup.Id = ObjectLink_Juridical_JuridicalGroup.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Juridical_GoodsProperty
                             ON ObjectLink_Juridical_GoodsProperty.ObjectId = Object_Juridical.Id 
                            AND ObjectLink_Juridical_GoodsProperty.DescId = zc_ObjectLink_Juridical_GoodsProperty()
        LEFT JOIN Object AS Object_GoodsProperty ON Object_GoodsProperty.Id = ObjectLink_Juridical_GoodsProperty.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Juridical_InfoMoney
                             ON ObjectLink_Juridical_InfoMoney.ObjectId = Object_Juridical.Id
                            AND ObjectLink_Juridical_InfoMoney.DescId = zc_ObjectLink_Juridical_InfoMoney()
        LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Juridical_InfoMoney.ChildObjectId

        LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_Juridical.Id 

   WHERE (ObjectLink_Juridical_JuridicalGroup.ChildObjectId = vbObjectId_Constraint
          OR vbIsConstraint = FALSE
         )
     AND (((ObjectBoolean_isCorporate.ValueData = TRUE
         OR Object_Juridical.Id = 15505 -- ДУКО ТОВ 
           )
            AND COALESCE (vbIsIrna, FALSE)  = FALSE
          )
       OR (Object_Juridical.Id = 15512 -- Ірна-1 Фірма ТОВ
           AND COALESCE (vbIsIrna, TRUE)  = TRUE
          )
         )
   ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 04.10.16         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Juridical_Basis (FALSE, zfCalc_UserAdmin())
