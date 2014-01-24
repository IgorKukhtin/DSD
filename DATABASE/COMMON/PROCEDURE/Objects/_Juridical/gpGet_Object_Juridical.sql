-- Function: gpGet_Object_Juridical()

DROP FUNCTION IF EXISTS gpGet_Object_Juridical (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Object_Juridical (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Juridical(
    IN inId          Integer,       -- Юридические лица 
    IN inName        TVarChar,
--    IN inOKPO        TVarChar,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, 
               GLNCode TVarChar,
               isCorporate Boolean, 
               JuridicalGroupId Integer, JuridicalGroupName TVarChar,  
               GoodsPropertyId Integer, GoodsPropertyName TVarChar, 
               InfoMoneyId Integer, InfoMoneyName TVarChar, 
               PriceListId Integer, PriceListName TVarChar, 
               PriceListPromoId Integer, PriceListPromoName TVarChar,
               StartPromo TDateTime, EndPromo TDateTime
               ) AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Object_Juridical());
     
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_Juridical()) AS Code
           , inName                 AS NAME
           
           , CAST ('' as TVarChar)    AS GLNCode
           , CAST (false as Boolean)  AS isCorporate
           
           , CAST (0 as Integer)    AS JuridicalGroupId
           , CAST ('' as TVarChar)  AS JuridicalGroupName
           
           , CAST (0 as Integer)    AS GoodsPropertyId 
           , CAST ('' as TVarChar)  AS GoodsPropertyName 
           
           , CAST (0 as Integer)    AS InfoMoneyId
           , CAST ('' as TVarChar)  AS InfoMoneyName
           
           , CAST (0 as Integer)    AS PriceListId 
           , CAST ('' as TVarChar)  AS PriceListName 

           , CAST (0 as Integer)    AS PriceListPromoId 
           , CAST ('' as TVarChar)  AS PriceListPromoName 
       
           , CURRENT_DATE :: TDateTime AS StartPromo
           , CURRENT_DATE :: TDateTime AS EndPromo
           
           ;
   ELSE
       RETURN QUERY 
       SELECT 
             Object_Juridical.Id             AS Id
           , Object_Juridical.ObjectCode     AS Code
           , Object_Juridical.ValueData      AS NAME
           
           , ObjectString_GLNCode.ValueData      AS GLNCode
           , ObjectBoolean_isCorporate.ValueData AS isCorporate
           
           , Object_JuridicalGroup.Id         AS JuridicalGroupId
           , Object_JuridicalGroup.ValueData  AS JuridicalGroupName
           
           , Object_GoodsProperty.Id         AS GoodsPropertyId
           , Object_GoodsProperty.ValueData  AS GoodsPropertyName
           
           , Object_InfoMoney_View.InfoMoneyId
           , Object_InfoMoney_View.InfoMoneyName_all AS InfoMoneyName
           
           , Object_PriceList.Id         AS PriceListId 
           , Object_PriceList.ValueData  AS PriceListName 

           , Object_PriceListPromo.Id         AS PriceListPromoId 
           , Object_PriceListPromo.ValueData  AS PriceListPromoName 
       
           , COALESCE (ObjectDate_StartPromo.ValueData,CAST (CURRENT_DATE as TDateTime)) AS StartPromo
           , COALESCE (ObjectDate_EndPromo.ValueData,CAST (CURRENT_DATE as TDateTime))   AS EndPromo            

       FROM Object AS Object_Juridical
           LEFT JOIN ObjectString AS ObjectString_GLNCode 
                                  ON ObjectString_GLNCode.ObjectId = Object_Juridical.Id 
                                 AND ObjectString_GLNCode.DescId = zc_ObjectString_Juridical_GLNCode()

           LEFT JOIN ObjectBoolean AS ObjectBoolean_isCorporate
                                   ON ObjectBoolean_isCorporate.ObjectId = Object_Juridical.Id 
                                  AND ObjectBoolean_isCorporate.DescId = zc_ObjectBoolean_Juridical_isCorporate()
           
           LEFT JOIN ObjectDate AS ObjectDate_StartPromo
                                ON ObjectDate_StartPromo.ObjectId = Object_Juridical.Id
                               AND ObjectDate_StartPromo.DescId = zc_ObjectDate_Juridical_StartPromo()

           LEFT JOIN ObjectDate AS ObjectDate_EndPromo
                                ON ObjectDate_EndPromo.ObjectId = Object_Juridical.Id
                               AND ObjectDate_EndPromo.DescId = zc_ObjectDate_Juridical_EndPromo()
           
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
           
           LEFT JOIN ObjectLink AS ObjectLink_Juridical_PriceList
                                ON ObjectLink_Juridical_PriceList.ObjectId = Object_Juridical.Id 
                               AND ObjectLink_Juridical_PriceList.DescId = zc_ObjectLink_Juridical_PriceList()
           LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = ObjectLink_Juridical_PriceList.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_Juridical_PriceListPromo
                                ON ObjectLink_Juridical_PriceListPromo.ObjectId = Object_Juridical.Id 
                               AND ObjectLink_Juridical_PriceListPromo.DescId = zc_ObjectLink_Juridical_PriceListPromo()
           LEFT JOIN Object AS Object_PriceListPromo ON Object_PriceListPromo.Id = ObjectLink_Juridical_PriceListPromo.ChildObjectId
           
       WHERE Object_Juridical.Id = inId;
   END IF;      
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Juridical (Integer, TVarChar, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.01.14                        * 
 12.01.14         * add PriceList,
                        PriceListPromo,
                        StartPromo,
                        EndPromo
 12.06.13         * + InfoMoney              
 12.06.13         *
 14.05.13                                        *

*/

-- тест
-- SELECT * FROM gpGet_Object_Juridical (1, '2')