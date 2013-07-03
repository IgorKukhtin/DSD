-- Function: gpSelect_Object_Juridical()

--DROP FUNCTION gpSelect_Object_Juridical(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Juridical(
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,
               GLNCode TVarChar, isCorporate Boolean,
               JuridicalGroupId Integer, JuridicalGroupCode Integer, JuridicalGroupName TVarChar,
               GoodsPropertyId Integer, GoodsPropertyCode Integer, GoodsPropertyName TVarChar, 
               InfoMoneyGroupId Integer, InfoMoneyGroupCode Integer, InfoMoneyGroupName TVarChar, 
               InfoMoneyDestinationId Integer, InfoMoneyDestinationCode Integer, InfoMoneyDestinationName TVarChar, 
               InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar, 
               isErased BOOLEAN) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_Juridical());

   RETURN QUERY 
   SELECT 
         Object_JuridicalGroup.Id         AS Id 
       , Object_JuridicalGroup.ObjectCode AS Code
       , CAST ('' AS TVarChar)            AS Name
       
       , CAST ('' AS TVarChar)     AS GLNCode
       , CAST (NULL AS Boolean)    AS isCorporate

       , ObjectLink_JuridicalGroup_Parent.ChildObjectId AS JuridicalGroupId
       , Object_JuridicalGroup.ObjectCode               AS JuridicalGroupCode
       , Object_JuridicalGroup.ValueData                AS JuridicalGroupName
       
       , CAST (0 as Integer)    AS GoodsPropertyId 
       , CAST (0 as Integer)    AS GoodsPropertyCode 
       , CAST ('' as TVarChar)  AS GoodsPropertyName 
       
       , CAST (0 as Integer)    AS InfoMoneyGroupId
       , CAST (0 as Integer)    AS InfoMoneyGroupCode
       , CAST ('' as TVarChar)  AS InfoMoneyGroupName

       , CAST (0 as Integer)    AS InfoMoneyDestinationId
       , CAST (0 as Integer)    AS InfoMoneyDestinationCode
       , CAST ('' as TVarChar)  AS InfoMoneyDestinationName

       , CAST (0 as Integer)    AS InfoMoneyId
       , CAST (0 as Integer)    AS InfoMoneyCode
       , CAST ('' as TVarChar)  AS InfoMoneyName
       
       , Object_JuridicalGroup.isErased   AS isErased
   FROM Object AS Object_JuridicalGroup
        LEFT JOIN ObjectLink AS ObjectLink_JuridicalGroup_Parent
                             ON ObjectLink_JuridicalGroup_Parent.ObjectId = Object_JuridicalGroup.Id
                            AND ObjectLink_JuridicalGroup_Parent.DescId = zc_ObjectLink_JuridicalGroup_Parent()
   WHERE Object_JuridicalGroup.DescId = zc_Object_JuridicalGroup()
  UNION
   SELECT 
         Object_Juridical.Id             AS Id 
       , Object_Juridical.ObjectCode     AS Code
       , Object_Juridical.ValueData      AS NAME

       , ObjectString_GLNCode.ValueData      AS GLNCode
       , ObjectBoolean_isCorporate.ValueData AS isCorporate


       , ObjectLink_Juridical_JuridicalGroup.ChildObjectId AS JuridicalGroupId
       , CAST (0 as Integer)             AS JuridicalGroupCode
       , CAST ('' AS TVarChar)           AS JuridicalGroupName
    
       , Object_GoodsProperty.Id         AS GoodsPropertyId
       , Object_GoodsProperty.ObjectCode AS GoodsPropertyCode
       , Object_GoodsProperty.ValueData  AS GoodsPropertyName
       
       , lfObject_InfoMoney.InfoMoneyGroupId   AS InfoMoneyGroupId
       , lfObject_InfoMoney.InfoMoneyGroupCode AS InfoMoneyGroupCode
       , lfObject_InfoMoney.InfoMoneyGroupName AS InfoMoneyGroupName

       , lfObject_InfoMoney.InfoMoneyDestinationId   AS InfoMoneyDestinationId
       , lfObject_InfoMoney.InfoMoneyDestinationCode AS InfoMoneyDestinationCode
       , lfObject_InfoMoney.InfoMoneyDestinationName AS InfoMoneyDestinationName

       , lfObject_InfoMoney.InfoMoneyId   AS InfoMoneyId
       , lfObject_InfoMoney.InfoMoneyCode AS InfoMoneyCode
       , lfObject_InfoMoney.InfoMoneyName AS InfoMoneyName
       
       , Object_Juridical.isErased        AS isErased
   FROM Object AS Object_Juridical
        LEFT JOIN ObjectString AS ObjectString_GLNCode 
                               ON ObjectString_GLNCode.ObjectId = Object_Juridical.Id 
                              AND ObjectString_GLNCode.DescId = zc_ObjectString_Juridical_GLNCode()
        LEFT JOIN ObjectBoolean AS ObjectBoolean_isCorporate
                                ON ObjectBoolean_isCorporate.ObjectId = Object_Juridical.Id 
                               AND ObjectBoolean_isCorporate.DescId = zc_ObjectBoolean_Juridical_isCorporate()

        LEFT JOIN ObjectLink AS ObjectLink_Juridical_JuridicalGroup
                 ON ObjectLink_Juridical_JuridicalGroup.ObjectId = Object_Juridical.Id 
                AND ObjectLink_Juridical_JuridicalGroup.DescId = zc_ObjectLink_Juridical_JuridicalGroup()
        
        LEFT JOIN ObjectLink AS ObjectLink_Juridical_GoodsProperty
                             ON ObjectLink_Juridical_GoodsProperty.ObjectId = Object_Juridical.Id 
                            AND ObjectLink_Juridical_GoodsProperty.DescId = zc_ObjectLink_Juridical_GoodsProperty()
        LEFT JOIN Object AS Object_GoodsProperty ON Object_GoodsProperty.Id = ObjectLink_Juridical_GoodsProperty.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Juridical_InfoMoney
                             ON ObjectLink_Juridical_InfoMoney.ObjectId = Object_Juridical.Id
                            AND ObjectLink_Juridical_InfoMoney.DescId = zc_ObjectLink_Juridical_InfoMoney()
        LEFT JOIN lfSelect_Object_InfoMoney() AS lfObject_InfoMoney ON lfObject_InfoMoney.InfoMoneyId = ObjectLink_Juridical_InfoMoney.ChildObjectId

   WHERE Object_Juridical.DescId = zc_Object_Juridical();
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Juridical (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.07.13         * +GoodsProperty, InfoMoney               
 14.05.13                                        *

*/

-- тест
-- SELECT * FROM gpSelect_Object_Juridical('2')
