-- Function: gpGet_Object_Retail()

DROP FUNCTION IF EXISTS gpGet_Object_Retail(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Retail(
    IN inId          Integer,       -- ключ объекта <Торговая сеть>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , OperDateOrder Boolean
             , isOrderMin Boolean    
             , RoundWeight TFloat
             , GLNCode TVarChar, GLNCodeCorporate TVarChar
             , OKPO TVarChar
             , GoodsPropertyId Integer, GoodsPropertyName TVarChar
             , PersonalMarketingId Integer, PersonalMarketingName TVarChar
             , PersonalTradeId Integer, PersonalTradeName TVarChar
             , ClientKindId Integer, ClientKindName TVarChar
             , StickerHeaderId Integer, StickerHeaderName TVarChar
             , isErased boolean) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)     AS Id
           , lfGet_ObjectCode(0, zc_Object_Retail()) AS Code
           , CAST ('' as TVarChar)   AS NAME
           , CAST (FALSE AS Boolean) AS OperDateOrder
           , CAST (FALSE as Boolean) AS isOrderMin    
           , CAST (0 as TFloat)      AS RoundWeight
           , CAST ('' as TVarChar)   AS GLNCode
           , CAST ('' as TVarChar)   AS GLNCodeCorporate
           , CAST ('' as TVarChar)   AS OKPO
           , CAST (0 as Integer)     AS GoodsPropertyId 
           , CAST ('' as TVarChar)   AS GoodsPropertyName      

           , CAST (0 as Integer)     AS PersonalMarketingId 
           , CAST ('' as TVarChar)   AS PersonalMarketingName    
           , CAST (0 as Integer)     AS PersonalTradeId 
           , CAST ('' as TVarChar)   AS PersonalTradeName 

           , CAST (0 as Integer)     AS ClientKindId 
           , CAST ('' as TVarChar)   AS ClientKindName 

           , 0   :: Integer          AS StickerHeaderId
           , ''  :: TVarChar         AS StickerHeaderName
           
           , CAST (NULL AS Boolean)  AS isErased;
   ELSE
       RETURN QUERY 
       SELECT 
             Object_Retail.Id         AS Id
           , Object_Retail.ObjectCode AS Code
           , Object_Retail.ValueData  AS NAME

           , COALESCE (ObjectBoolean_OperDateOrder.ValueData, CAST (False AS Boolean)) AS OperDateOrder
           , COALESCE (ObjectBoolean_isOrderMin.ValueData, False::Boolean)             AS isOrderMin

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
           , Object_StickerHeader.Id             AS StickerHeaderId
           , Object_StickerHeader.ValueData      AS StickerHeaderName
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

        LEFT JOIN ObjectLink AS ObjectLink_Retail_StickerHeader
                             ON ObjectLink_Retail_StickerHeader.ObjectId = Object_Retail.Id
                            AND ObjectLink_Retail_StickerHeader.DescId = zc_ObjectLink_Retail_ClientKind()
        LEFT JOIN Object AS Object_StickerHeader ON Object_StickerHeader.Id = ObjectLink_Retail_StickerHeader.ChildObjectId
       WHERE Object_Retail.Id = inId;
   END IF; 
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Retail(integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.10.19         *
 14.05.19         * ClientKind
 02.04.15         * add OperDateOrder
 19.02.15         * add GoodsProperty               
 10.11.14         * add GLNCode
 23.05.14         *

*/

-- тест
-- SELECT * FROM gpGet_Object_Retail (0, '2')
