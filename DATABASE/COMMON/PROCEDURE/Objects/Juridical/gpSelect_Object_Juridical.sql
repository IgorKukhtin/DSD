-- Function: gpSelect_Object_Juridical()

DROP FUNCTION IF EXISTS gpSelect_Object_Juridical (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Juridical(
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,
               GLNCode TVarChar, isCorporate Boolean,
               JuridicalGroupId Integer, JuridicalGroupName TVarChar,
               GoodsPropertyId Integer, GoodsPropertyName TVarChar,
               RetailId Integer, RetailName TVarChar,
               InfoMoneyGroupCode Integer, InfoMoneyGroupName TVarChar, 
               InfoMoneyDestinationCode Integer, InfoMoneyDestinationName TVarChar, 
               InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar,
               OKPO TVarChar,
               PriceListId Integer, PriceListName TVarChar, 
               PriceListPromoId Integer, PriceListPromoName TVarChar,
               StartPromo TDateTime, EndPromo TDateTime,
               isErased Boolean
              )
AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_Juridical());

   RETURN QUERY 
   SELECT 
         Object_Juridical.Id             AS Id 
       , Object_Juridical.ObjectCode     AS Code
       , Object_Juridical.ValueData      AS Name

       , ObjectString_GLNCode.ValueData      AS GLNCode
       , ObjectBoolean_isCorporate.ValueData AS isCorporate

       , COALESCE (ObjectLink_Juridical_JuridicalGroup.ChildObjectId, 0)  AS JuridicalGroupId
       , Object_JuridicalGroup.ValueData  AS JuridicalGroupName

       , Object_GoodsProperty.Id         AS GoodsPropertyId
       , Object_GoodsProperty.ValueData  AS GoodsPropertyName

       , Object_Retail.Id                AS RetailId
       , Object_Retail.ValueData         AS RetailName

       , Object_InfoMoney_View.InfoMoneyGroupCode
       , Object_InfoMoney_View.InfoMoneyGroupName
       , Object_InfoMoney_View.InfoMoneyDestinationCode
       , Object_InfoMoney_View.InfoMoneyDestinationName
       , Object_InfoMoney_View.InfoMoneyId
       , Object_InfoMoney_View.InfoMoneyCode
       , Object_InfoMoney_View.InfoMoneyName
       , Object_InfoMoney_View.InfoMoneyName_all

       , ObjectHistory_JuridicalDetails_View.OKPO

       , Object_PriceList.Id         AS PriceListId 
       , Object_PriceList.ValueData  AS PriceListName 

       , Object_PriceListPromo.Id         AS PriceListPromoId 
       , Object_PriceListPromo.ValueData  AS PriceListPromoName 
       
       , ObjectDate_StartPromo.ValueData AS StartPromo
       , ObjectDate_EndPromo.ValueData   AS EndPromo       

       , Object_Juridical.isErased AS isErased
       
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

        LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                             ON ObjectLink_Juridical_Retail.ObjectId = Object_Juridical.Id 
                            AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
        LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Juridical_InfoMoney
                             ON ObjectLink_Juridical_InfoMoney.ObjectId = Object_Juridical.Id
                            AND ObjectLink_Juridical_InfoMoney.DescId = zc_ObjectLink_Juridical_InfoMoney()
        LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Juridical_InfoMoney.ChildObjectId

        LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_Juridical.Id 

        LEFT JOIN ObjectLink AS ObjectLink_Juridical_PriceList
                             ON ObjectLink_Juridical_PriceList.ObjectId = Object_Juridical.Id 
                            AND ObjectLink_Juridical_PriceList.DescId = zc_ObjectLink_Juridical_PriceList()
        LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = ObjectLink_Juridical_PriceList.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Juridical_PriceListPromo
                             ON ObjectLink_Juridical_PriceListPromo.ObjectId = Object_Juridical.Id 
                            AND ObjectLink_Juridical_PriceListPromo.DescId = zc_ObjectLink_Juridical_PriceListPromo()
        LEFT JOIN Object AS Object_PriceListPromo ON Object_PriceListPromo.Id = ObjectLink_Juridical_PriceListPromo.ChildObjectId
 
   WHERE Object_Juridical.DescId = zc_Object_Juridical();
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Juridical (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.08.14                                        * add InfoMoneyName_all
 23.05.14         * add Retail
 12.01.14         * add PriceList,
                        PriceListPromo,
                        StartPromo,
                        EndPromo               
 28.12.13                                         * add ObjectHistory_JuridicalDetails_View
 20.10.13                                         * add Object_InfoMoney_View
 03.07.13         * +GoodsProperty, InfoMoney               
 14.05.13                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Juridical ('2')
