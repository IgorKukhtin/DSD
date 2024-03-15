-- Function: gpSelect_Object_GoodsQuality()

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsQuality (TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_GoodsQuality (Integer, Boolean,TVarChar);


CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsQuality(
    IN inQualityId     Integer  , 
    IN inShowAll       Boolean  , 
    IN inSession       TVarChar        -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean, 
               Value1 TVarChar, Value2 TVarChar, 
               Value3 TVarChar, Value4 TVarChar,
               Value5 TVarChar, Value6 TVarChar, 
               Value7 TVarChar, Value8 TVarChar,
               Value9 TVarChar, Value10 TVarChar,
               GoodsId Integer, GoodsCode Integer, GoodsName TVarChar,
               GoodsGroupName TVarChar,
               QualityId Integer, QualityCode Integer, QualityName TVarChar,
               isKlipsa Boolean
               )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_GoodsQuality());
   vbUserId:= lpGetUserBySession (inSession);


 IF inShowAll = FALSE
 THEN
   
    RETURN QUERY 
       SELECT 
             Object_GoodsQuality.Id          AS Id
           , Object_GoodsQuality.ObjectCode  AS Code
           , Object_GoodsQuality.ValueData   AS Name
           , Object_GoodsQuality.isErased    AS isErased

           , ObjectString_Value1.ValueData AS Value1
           , ObjectString_Value2.ValueData AS Value2 
           , ObjectString_Value3.ValueData AS Value3
           , ObjectString_Value4.ValueData AS Value4
           , ObjectString_Value5.ValueData AS Value5
           , ObjectString_Value6.ValueData AS Value6
           , ObjectString_Value7.ValueData AS Value7
           , ObjectString_Value8.ValueData AS Value8
           , ObjectString_Value9.ValueData AS Value9           
           , ObjectString_Value10.ValueData AS Value10
                                                      
           , Object_Goods.Id              AS GoodsId
           , Object_Goods.ObjectCode      AS GoodsCode
           , Object_Goods.ValueData       AS GoodsName 
           , Object_GoodsGroup.ValueData  AS GoodsGroupName 
                     
           , Object_Quality.Id           AS QualityId
           , Object_Quality.ObjectCode   AS QualityCode
           , Object_Quality.ValueData    AS QualityName
           
           , COALESCE (ObjectBoolean_Klipsa.ValueData, FALSE) ::Boolean AS isKlipsa
                                
       FROM Object AS Object_GoodsQuality
           LEFT JOIN ObjectLink AS GoodsQuality_Quality
                                ON GoodsQuality_Quality.ObjectId = Object_GoodsQuality.Id
                               AND GoodsQuality_Quality.DescId = zc_ObjectLink_GoodsQuality_Quality()
           LEFT JOIN Object AS Object_Quality ON Object_Quality.Id = GoodsQuality_Quality.ChildObjectId      
       
           LEFT JOIN ObjectString AS ObjectString_Value1
                               ON ObjectString_Value1.ObjectId = Object_GoodsQuality.Id 
                              AND ObjectString_Value1.DescId = zc_ObjectString_GoodsQuality_Value1()
           LEFT JOIN ObjectString AS ObjectString_Value2
                               ON ObjectString_Value2.ObjectId = Object_GoodsQuality.Id 
                              AND ObjectString_Value2.DescId = zc_ObjectString_GoodsQuality_Value2()
           LEFT JOIN ObjectString AS ObjectString_Value3
                               ON ObjectString_Value3.ObjectId = Object_GoodsQuality.Id 
                              AND ObjectString_Value3.DescId = zc_ObjectString_GoodsQuality_Value3()                             
           LEFT JOIN ObjectString AS ObjectString_Value4
                               ON ObjectString_Value4.ObjectId = Object_GoodsQuality.Id 
                              AND ObjectString_Value4.DescId = zc_ObjectString_GoodsQuality_Value4()
           LEFT JOIN ObjectString AS ObjectString_Value5
                               ON ObjectString_Value5.ObjectId = Object_GoodsQuality.Id 
                              AND ObjectString_Value5.DescId = zc_ObjectString_GoodsQuality_Value5()                             
           LEFT JOIN ObjectString AS ObjectString_Value6
                               ON ObjectString_Value6.ObjectId = Object_GoodsQuality.Id 
                              AND ObjectString_Value6.DescId = zc_ObjectString_GoodsQuality_Value6()
           LEFT JOIN ObjectString AS ObjectString_Value7
                               ON ObjectString_Value7.ObjectId = Object_GoodsQuality.Id 
                              AND ObjectString_Value7.DescId = zc_ObjectString_GoodsQuality_Value7()
           LEFT JOIN ObjectString AS ObjectString_Value8
                               ON ObjectString_Value8.ObjectId = Object_GoodsQuality.Id 
                              AND ObjectString_Value8.DescId = zc_ObjectString_GoodsQuality_Value8()                             
           LEFT JOIN ObjectString AS ObjectString_Value9
                               ON ObjectString_Value9.ObjectId = Object_GoodsQuality.Id 
                              AND ObjectString_Value9.DescId = zc_ObjectString_GoodsQuality_Value9()  
           LEFT JOIN ObjectString AS ObjectString_Value10
                               ON ObjectString_Value10.ObjectId = Object_GoodsQuality.Id 
                              AND ObjectString_Value10.DescId = zc_ObjectString_GoodsQuality_Value10()

           LEFT JOIN ObjectBoolean AS ObjectBoolean_Klipsa
                                   ON ObjectBoolean_Klipsa.ObjectId = Object_GoodsQuality.Id 
                                  AND ObjectBoolean_Klipsa.DescId = zc_ObjectBoolean_GoodsQuality_Klipsa()

           LEFT JOIN ObjectLink AS GoodsQuality_Goods
                                ON GoodsQuality_Goods.ObjectId = Object_GoodsQuality.Id
                               AND GoodsQuality_Goods.DescId = zc_ObjectLink_GoodsQuality_Goods()
           LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = GoodsQuality_Goods.ChildObjectId
           LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                               AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
           LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId    

       WHERE Object_GoodsQuality.DescId = zc_Object_GoodsQuality()
         AND (GoodsQuality_Quality.ChildObjectId = inQualityId OR inQualityId = 0);

   ELSE 

    RETURN QUERY
    WITH tmpGoods AS(SELECT Object_Goods.Id            AS GoodsId
                          , Object_Goods.ObjectCode    AS GoodsCode 
                          , Object_Goods.ValueData     AS GoodsName

                          , Object_GoodsGroup.Id        AS GoodsGroupId
                          , Object_GoodsGroup.ValueData AS GoodsGroupName 
                     FROM Object_InfoMoney_View
                          INNER JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                ON ObjectLink_Goods_InfoMoney.ChildObjectId = Object_InfoMoney_View.InfoMoneyId
                                               AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                          INNER JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods_InfoMoney.ObjectId
                                                           AND Object_Goods.isErased = FALSE
                          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                               ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                              AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                          LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId    
                     WHERE Object_InfoMoney_View.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900(), zc_Enum_InfoMoneyDestination_21000(), zc_Enum_InfoMoneyDestination_21100()
                                                                          , zc_Enum_InfoMoneyDestination_30100(), zc_Enum_InfoMoneyDestination_30200(), zc_Enum_InfoMoneyDestination_30300()
                                                                          , zc_Enum_InfoMoneyDestination_10100()
                                                                           )
                    )

         SELECT
             COALESCE (Object_GoodsQuality.Id, 0)::Integer           AS Id
           , COALESCE (Object_GoodsQuality.ObjectCode, 0)::Integer   AS Code
           , COALESCE (Object_GoodsQuality.ValueData, '')::TVarChar  AS Name
           , COALESCE (Object_GoodsQuality.isErased, false)::Boolean AS isErased

           , COALESCE (ObjectString_Value1.ValueData, '')::TVarChar  AS Value1
           , COALESCE (ObjectString_Value2.ValueData, '')::TVarChar  AS Value2 
           , COALESCE (ObjectString_Value3.ValueData, '')::TVarChar  AS Value3
           , COALESCE (ObjectString_Value4.ValueData, '')::TVarChar  AS Value4
           , COALESCE (ObjectString_Value5.ValueData, '')::TVarChar  AS Value5
           , COALESCE (ObjectString_Value6.ValueData, '')::TVarChar  AS Value6
           , COALESCE (ObjectString_Value7.ValueData, '')::TVarChar  AS Value7
           , COALESCE (ObjectString_Value8.ValueData, '')::TVarChar  AS Value8
           , COALESCE (ObjectString_Value9.ValueData, '')::TVarChar  AS Value9           
           , COALESCE (ObjectString_Value10.ValueData,'')::TVarChar  AS Value10
                                                      
           , Object_Goods.GoodsId        AS GoodsId
           , Object_Goods.GoodsCode      AS GoodsCode
           , Object_Goods.GoodsName      AS GoodsName 
           , Object_Goods.GoodsGroupName AS GoodsGroupName 

           , Object_Quality.Id           AS QualityId
           , Object_Quality.ObjectCode   AS QualityCode
           , Object_Quality.ValueData    AS QualityName 

           , COALESCE (ObjectBoolean_Klipsa.ValueData, FALSE) ::Boolean AS isKlipsa
         FROM tmpGoods AS Object_Goods

           LEFT JOIN ObjectLink AS GoodsQuality_Goods
                                ON GoodsQuality_Goods.ChildObjectId = Object_Goods.GoodsId
                               AND GoodsQuality_Goods.DescId = zc_ObjectLink_GoodsQuality_Goods()
           LEFT JOIN Object AS Object_GoodsQuality ON Object_GoodsQuality.Id = GoodsQuality_Goods.ObjectId 
                                                  AND Object_GoodsQuality.DescId = zc_Object_GoodsQuality()

           LEFT JOIN ObjectString AS ObjectString_Value1
                               ON ObjectString_Value1.ObjectId = Object_GoodsQuality.Id 
                              AND ObjectString_Value1.DescId = zc_ObjectString_GoodsQuality_Value1()
           LEFT JOIN ObjectString AS ObjectString_Value2
                               ON ObjectString_Value2.ObjectId = Object_GoodsQuality.Id 
                              AND ObjectString_Value2.DescId = zc_ObjectString_GoodsQuality_Value2()
           LEFT JOIN ObjectString AS ObjectString_Value3
                               ON ObjectString_Value3.ObjectId = Object_GoodsQuality.Id 
                              AND ObjectString_Value3.DescId = zc_ObjectString_GoodsQuality_Value3()                             
           LEFT JOIN ObjectString AS ObjectString_Value4
                               ON ObjectString_Value4.ObjectId = Object_GoodsQuality.Id 
                              AND ObjectString_Value4.DescId = zc_ObjectString_GoodsQuality_Value4()
           LEFT JOIN ObjectString AS ObjectString_Value5
                               ON ObjectString_Value5.ObjectId = Object_GoodsQuality.Id 
                              AND ObjectString_Value5.DescId = zc_ObjectString_GoodsQuality_Value5()                             
           LEFT JOIN ObjectString AS ObjectString_Value6
                               ON ObjectString_Value6.ObjectId = Object_GoodsQuality.Id 
                              AND ObjectString_Value6.DescId = zc_ObjectString_GoodsQuality_Value6()
           LEFT JOIN ObjectString AS ObjectString_Value7
                               ON ObjectString_Value7.ObjectId = Object_GoodsQuality.Id 
                              AND ObjectString_Value7.DescId = zc_ObjectString_GoodsQuality_Value7()
           LEFT JOIN ObjectString AS ObjectString_Value8
                               ON ObjectString_Value8.ObjectId = Object_GoodsQuality.Id 
                              AND ObjectString_Value8.DescId = zc_ObjectString_GoodsQuality_Value8()                             
           LEFT JOIN ObjectString AS ObjectString_Value9
                               ON ObjectString_Value9.ObjectId = Object_GoodsQuality.Id 
                              AND ObjectString_Value9.DescId = zc_ObjectString_GoodsQuality_Value9()  
           LEFT JOIN ObjectString AS ObjectString_Value10
                               ON ObjectString_Value10.ObjectId = Object_GoodsQuality.Id 
                              AND ObjectString_Value10.DescId = zc_ObjectString_GoodsQuality_Value10()

           LEFT JOIN ObjectBoolean AS ObjectBoolean_Klipsa
                                   ON ObjectBoolean_Klipsa.ObjectId = Object_GoodsQuality.Id 
                                  AND ObjectBoolean_Klipsa.DescId = zc_ObjectBoolean_GoodsQuality_Klipsa()

           LEFT  JOIN ObjectLink AS GoodsQuality_Quality
                                ON GoodsQuality_Quality.ObjectId = Object_GoodsQuality.Id
                               AND GoodsQuality_Quality.DescId = zc_ObjectLink_GoodsQuality_Quality()
           LEFT JOIN Object AS Object_Quality ON Object_Quality.Id = COALESCE (GoodsQuality_Quality.ChildObjectId, inQualityId)
                       
      WHERE (GoodsQuality_Quality.ChildObjectId = inQualityId OR inQualityId = 0 OR GoodsQuality_Goods.ObjectId IS NULL)
     ;
     END IF;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_GoodsQuality (Integer, Boolean, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.09.20         * isKlipsa
 12.02.15         * change inInfomoney на inQualityId
 09.02.15         * add Object_Quality               
 08.12.14         *            

*/

-- тест
--SELECT * FROM gpSelect_Object_GoodsQuality (0,True,zfCalc_UserAdmin())
--  SELECT * FROM gpSelect_Object_GoodsQuality (0,False,zfCalc_UserAdmin())
