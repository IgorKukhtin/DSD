-- Function: gpSelect_Object_Retail()

DROP FUNCTION IF EXISTS gpSelect_Object_Retail( TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Retail(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , OperDateOrder Boolean
             , isOrderMin Boolean
             , isWMS Boolean      
             , RoundWeight TFloat
             , GLNCode TVarChar, GLNCodeCorporate TVarChar
             , OKPO TVarChar
             , GoodsPropertyId Integer, GoodsPropertyName TVarChar
             , PersonalMarketingId Integer, PersonalMarketingName TVarChar
             , PersonalTradeId Integer, PersonalTradeName TVarChar
             , ClientKindId Integer, ClientKindName TVarChar
             , isErased boolean) AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

       RETURN QUERY 
       SELECT 
             Object_Retail.Id         AS Id
           , Object_Retail.ObjectCode AS Code
           , Object_Retail.ValueData  AS NAME

           , COALESCE (ObjectBoolean_OperDateOrder.ValueData, CAST (False AS Boolean)) AS OperDateOrder
           , COALESCE (ObjectBoolean_isOrderMin.ValueData, False::Boolean)             AS isOrderMin
           , COALESCE (ObjectBoolean_isWMS.ValueData, FALSE) :: Boolean                AS isWMS
           
           , ObjectFloat_RoundWeight.ValueData ::TFloat AS RoundWeight
 
           , GLNCode.ValueData               AS GLNCode
           , GLNCodeCorporate.ValueData      AS GLNCodeCorporate
           , ObjectString_OKPO.ValueData     AS OKPO
           , Object_GoodsProperty.Id         AS GoodsPropertyId
           , Object_GoodsProperty.ValueData  AS GoodsPropertyName     
           , Object_PersonalMarketing.Id         AS PersonalMarketingId
           , Object_PersonalMarketing.ValueData  AS PersonalMarketingName       
           , Object_PersonalTrade.Id             AS PersonalTradeId
           , Object_PersonalTrade.ValueData      AS PersonalTradeName   
           , Object_ClientKind.Id                AS ClientKindId
           , Object_ClientKind.ValueData         AS ClientKindName
           , Object_Retail.isErased   AS isErased
       FROM OBJECT AS Object_Retail
        LEFT JOIN ObjectString AS GLNCode
                               ON GLNCode.ObjectId = Object_Retail.Id 
                              AND GLNCode.DescId = zc_ObjectString_Retail_GLNCode()
        LEFT JOIN ObjectString AS GLNCodeCorporate
                               ON GLNCodeCorporate.ObjectId = Object_Retail.Id 
                              AND GLNCodeCorporate.DescId = zc_ObjectString_Retail_GLNCodeCorporate()

        LEFT JOIN ObjectString AS ObjectString_OKPO
                               ON ObjectString_OKPO.ObjectId = Object_Retail.Id 
                              AND ObjectString_OKPO.DescId = zc_ObjectString_Retail_OKPO()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_OperDateOrder
                                ON ObjectBoolean_OperDateOrder.ObjectId = Object_Retail.Id 
                               AND ObjectBoolean_OperDateOrder.DescId = zc_ObjectBoolean_Retail_OperDateOrder() 

        LEFT JOIN ObjectBoolean AS ObjectBoolean_isOrderMin
                                ON ObjectBoolean_isOrderMin.ObjectId = Object_Retail.Id 
                               AND ObjectBoolean_isOrderMin.DescId = zc_ObjectBoolean_Retail_isOrderMin()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_isWMS
                                ON ObjectBoolean_isWMS.ObjectId = Object_Retail.Id 
                               AND ObjectBoolean_isWMS.DescId = zc_ObjectBoolean_Retail_isWMS()

        LEFT JOIN ObjectFloat AS ObjectFloat_RoundWeight
                              ON ObjectFloat_RoundWeight.ObjectId = Object_Retail.Id
                             AND ObjectFloat_RoundWeight.DescId = zc_ObjectFloat_Retail_RoundWeight()

        LEFT JOIN ObjectLink AS ObjectLink_Retail_GoodsProperty
                             ON ObjectLink_Retail_GoodsProperty.ObjectId = Object_Retail.Id 
                            AND ObjectLink_Retail_GoodsProperty.DescId = zc_ObjectLink_Retail_GoodsProperty()
        LEFT JOIN Object AS Object_GoodsProperty ON Object_GoodsProperty.Id = ObjectLink_Retail_GoodsProperty.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Retail_PersonalMarketing
                             ON ObjectLink_Retail_PersonalMarketing.ObjectId = Object_Retail.Id 
                            AND ObjectLink_Retail_PersonalMarketing.DescId = zc_ObjectLink_Retail_PersonalMarketing()
        LEFT JOIN Object AS Object_PersonalMarketing ON Object_PersonalMarketing.Id = ObjectLink_Retail_PersonalMarketing.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Retail_PersonalTrade
                             ON ObjectLink_Retail_PersonalTrade.ObjectId = Object_Retail.Id 
                            AND ObjectLink_Retail_PersonalTrade.DescId = zc_ObjectLink_Retail_PersonalTrade()
        LEFT JOIN Object AS Object_PersonalTrade ON Object_PersonalTrade.Id = ObjectLink_Retail_PersonalTrade.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Retail_ClientKind
                             ON ObjectLink_Retail_ClientKind.ObjectId = Object_Retail.Id 
                            AND ObjectLink_Retail_ClientKind.DescId = zc_ObjectLink_Retail_ClientKind()
        LEFT JOIN Object AS Object_ClientKind ON Object_ClientKind.Id = ObjectLink_Retail_ClientKind.ChildObjectId                              
       WHERE Object_Retail.DescId = zc_Object_Retail();
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.04.22         * RoundWeight
 21.05.20         * isWMS
 14.05.19         * ClientKind
 29.01.19         * add OKPO
 24.11.15         * add PersonalMarketing
 20.05.15         *
 02.04.15         * add OperDateOrder
 19.02.15         * add GoodsProperty               
 10.11.14         * add GLNCode
 23.05.14         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Retail ( zfCalc_UserAdmin())
