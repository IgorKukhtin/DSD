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
             , StickerHeaderId Integer, StickerHeaderName TVarChar
             , isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      vbUserId:= lpGetUserBySession (inSession);

      -- Результат
      RETURN QUERY
       SELECT
             Object_Retail.Id         AS Id
           , Object_Retail.ObjectCode AS Code
           , Object_Retail.ValueData  AS NAME

           , COALESCE (ObjectBoolean_OperDateOrder.ValueData, CAST (FALSE AS Boolean)) AS OperDateOrder
           , COALESCE (ObjectBoolean_isOrderMin.ValueData, FALSE::Boolean)             AS isOrderMin
           , COALESCE (ObjectBoolean_isWMS.ValueData, FALSE) :: Boolean                AS isWMS

           , ObjectFloat_RoundWeight.ValueData ::TFloat AS RoundWeight

           , GLNCode.ValueData                   AS GLNCode
           , GLNCodeCorporate.ValueData          AS GLNCodeCorporate
           , ObjectString_OKPO.ValueData         AS OKPO
           , Object_GoodsProperty.Id             AS GoodsPropertyId
           , Object_GoodsProperty.ValueData      AS GoodsPropertyName
           , Object_PersonalMarketing.Id         AS PersonalMarketingId
           , Object_PersonalMarketing.ValueData  AS PersonalMarketingName
           , Object_PersonalTrade.Id             AS PersonalTradeId
           , Object_PersonalTrade.ValueData      AS PersonalTradeName
           , Object_ClientKind.Id                AS ClientKindId
           , Object_ClientKind.ValueData         AS ClientKindName
           , Object_StickerHeader.Id             AS StickerHeaderId
           , Object_StickerHeader.ValueData      AS StickerHeaderName
           , Object_Retail.isErased              AS isErased

       FROM Object AS Object_Retail
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

            LEFT JOIN ObjectLink AS ObjectLink_Retail_StickerHeader
                                 ON ObjectLink_Retail_StickerHeader.ObjectId = Object_Retail.Id
                                AND ObjectLink_Retail_StickerHeader.DescId = zc_ObjectLink_Retail_StickerHeader()
            LEFT JOIN Object AS Object_StickerHeader ON Object_StickerHeader.Id = ObjectLink_Retail_StickerHeader.ChildObjectId
       WHERE Object_Retail.DescId = zc_Object_Retail()

     UNION ALL
       SELECT
             Object_Unit.Id         AS Id
           , Object_Unit.ObjectCode AS Code
           , Object_Unit.ValueData  AS Name

           , FALSE :: Boolean AS OperDateOrder
           , FALSE :: Boolean AS isOrderMin
           , FALSE :: Boolean AS isWMS

           , 0   :: TFloat AS RoundWeight

           , ''  :: TVarChar        AS GLNCode
           , ''  :: TVarChar        AS GLNCodeCorporate
           , ObjectDesc.ItemName    AS OKPO
           , 0   :: Integer         AS GoodsPropertyId
           , ''  :: TVarChar        AS GoodsPropertyName
           , 0   :: Integer         AS PersonalMarketingId
           , ''  :: TVarChar        AS PersonalMarketingName
           , 0   :: Integer         AS PersonalTradeId
           , ''  :: TVarChar        AS PersonalTradeName
           , 0   :: Integer         AS ClientKindId
           , ''  :: TVarChar        AS ClientKindName   
           , 0   :: Integer         AS StickerHeaderId
           , ''  :: TVarChar        AS StickerHeaderName
           , Object_Unit.isErased   AS isErased
       FROM Object AS Object_Unit
            LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Unit.DescId
       WHERE Object_Unit.DescId = zc_Object_Unit()
         AND vbUserId = 5
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.08.22         * StickerHeader
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
