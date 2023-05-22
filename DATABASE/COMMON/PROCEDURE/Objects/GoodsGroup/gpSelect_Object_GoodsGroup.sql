-- Function: gpSelect_Object_GoodsGroup()

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsGroup(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsGroup(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, CodeUKTZED TVarChar
             , CodeUKTZED_new TVarChar, DateUKTZED_new TDateTime
             , Name TVarChar
             , TaxImport TVarChar, DKPP TVarChar, TaxAction TVarChar
             , isErased boolean
             , ParentId Integer, ParentName TVarChar
             , GroupStatId Integer, GroupStatName TVarChar
             , TradeMarkId Integer, TradeMarkName TVarChar
             , GoodsTagId Integer, GoodsTagName TVarChar
             , GoodsGroupAnalystId Integer, GoodsGroupAnalystName TVarChar
             , GoodsPlatformId Integer, GoodsPlatformName TVarChar
             , InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar, InfoMoneyId Integer 
             , isAsset Boolean
             )
AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

     RETURN QUERY 
     SELECT 
           Object_GoodsGroup.Id                AS Id 
         , Object_GoodsGroup.ObjectCode        AS Code
         , lfGet_Object_GoodsGroup_CodeUKTZED (Object_GoodsGroup.Id) AS CodeUKTZED
         -- , COALESCE (ObjectString_GoodsGroup_UKTZED.ValueData,'') :: TVarChar AS CodeUKTZED 

         , Get_CodeUKTZED_new.CodeUKTZED_new ::TVarChar
         , Get_CodeUKTZED_new.DateUKTZED_new ::TDateTime
         
         , Object_GoodsGroup.ValueData         AS Name
         , lfGet_Object_GoodsGroup_TaxImport (Object_GoodsGroup.Id) AS TaxImport
         , lfGet_Object_GoodsGroup_DKPP (Object_GoodsGroup.Id)      AS DKPP
         , lfGet_Object_GoodsGroup_TaxAction (Object_GoodsGroup.Id) AS TaxAction

         , Object_GoodsGroup.isErased          AS isErased
         
         , GoodsGroup.Id            AS ParentId
         , GoodsGroup.ValueData     AS ParentName
         , GoodsGroupStat.Id        AS GroupStatId
         , GoodsGroupStat.ValueData AS GroupStatName

         , Object_TradeMark.Id            AS TradeMarkId
         , Object_TradeMark.ValueData     AS TradeMarkName

         , Object_GoodsTag.Id            AS GoodsTagId
         , Object_GoodsTag.ValueData     AS GoodsTagName      
         
         , Object_GoodsGroupAnalyst.Id             AS GoodsGroupAnalystId
         , Object_GoodsGroupAnalyst.ValueData     AS GoodsGroupAnalystName   

         , Object_GoodsPlatform.Id            AS GoodsPlatformId
         , Object_GoodsPlatform.ValueData     AS GoodsPlatformName       

         , Object_InfoMoney_View.InfoMoneyCode
         , Object_InfoMoney_View.InfoMoneyGroupName
         , Object_InfoMoney_View.InfoMoneyDestinationName
         , Object_InfoMoney_View.InfoMoneyName
         , Object_InfoMoney_View.InfoMoneyId
         
         , COALESCE(ObjectBoolean_GoodsGroup_Asset.ValueData, FALSE) ::Boolean AS isAsset
         
     FROM Object AS Object_GoodsGroup
           LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup
                                ON ObjectLink_GoodsGroup.ObjectId = Object_GoodsGroup.Id
                               AND ObjectLink_GoodsGroup.DescId = zc_ObjectLink_GoodsGroup_Parent()
           LEFT JOIN Object AS GoodsGroup ON GoodsGroup.Id = ObjectLink_GoodsGroup.ChildObjectId
           
           LEFT JOIN ObjectLink AS ObjectLink_GoodsGroupStat
                                ON ObjectLink_GoodsGroupStat.ObjectId = Object_GoodsGroup.Id
                               AND ObjectLink_GoodsGroupStat.DescId = zc_ObjectLink_GoodsGroup_GoodsGroupStat()
           LEFT JOIN Object AS GoodsGroupStat ON GoodsGroupStat.Id = ObjectLink_GoodsGroupStat.ChildObjectId   

           LEFT JOIN ObjectLink AS ObjectLink_TradeMark
                                ON ObjectLink_TradeMark.ObjectId = Object_GoodsGroup.Id
                               AND ObjectLink_TradeMark.DescId = zc_ObjectLink_GoodsGroup_TradeMark()
           LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_TradeMark.ChildObjectId          
           
           LEFT JOIN ObjectLink AS ObjectLink_GoodsTag
                                ON ObjectLink_GoodsTag.ObjectId = Object_GoodsGroup.Id
                               AND ObjectLink_GoodsTag.DescId = zc_ObjectLink_GoodsGroup_GoodsTag()
           LEFT JOIN Object AS Object_GoodsTag ON Object_GoodsTag.Id = ObjectLink_GoodsTag.ChildObjectId
           
           LEFT JOIN ObjectLink AS ObjectLink_GoodsGroupAnalyst
                                ON ObjectLink_GoodsGroupAnalyst.ObjectId = Object_GoodsGroup.Id
                               AND ObjectLink_GoodsGroupAnalyst.DescId = zc_ObjectLink_GoodsGroup_GoodsGroupAnalyst()
           LEFT JOIN Object AS Object_GoodsGroupAnalyst ON Object_GoodsGroupAnalyst.Id = ObjectLink_GoodsGroupAnalyst.ChildObjectId             
           
           LEFT JOIN ObjectLink AS ObjectLink_GoodsPlatform
                                ON ObjectLink_GoodsPlatform.ObjectId = Object_GoodsGroup.Id
                               AND ObjectLink_GoodsPlatform.DescId = zc_ObjectLink_GoodsGroup_GoodsPlatform()
           LEFT JOIN Object AS Object_GoodsPlatform ON Object_GoodsPlatform.Id = ObjectLink_GoodsPlatform.ChildObjectId  

           LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_InfoMoney
                                ON ObjectLink_GoodsGroup_InfoMoney.ObjectId = Object_GoodsGroup.Id 
                               AND ObjectLink_GoodsGroup_InfoMoney.DescId = zc_ObjectLink_GoodsGroup_InfoMoney()
           LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_GoodsGroup_InfoMoney.ChildObjectId

           /*LEFT JOIN ObjectString AS ObjectString_GoodsGroup_UKTZED
                                  ON ObjectString_GoodsGroup_UKTZED.ObjectId = Object_GoodsGroup.Id 
                                 AND ObjectString_GoodsGroup_UKTZED.DescId = zc_ObjectString_GoodsGroup_UKTZED()*/  
           
           LEFT JOIN ObjectBoolean AS ObjectBoolean_GoodsGroup_Asset
                                   ON ObjectBoolean_GoodsGroup_Asset.ObjectId = Object_GoodsGroup.Id 
                                  AND ObjectBoolean_GoodsGroup_Asset.DescId = zc_ObjectBoolean_GoodsGroup_Asset()

           LEFT JOIN lfGet_Object_GoodsGroup_CodeUKTZED_new (Object_GoodsGroup.Id) AS Get_CodeUKTZED_new ON 1 = 1

    WHERE Object_GoodsGroup.DescId = zc_Object_GoodsGroup()
     ;
         
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.05.23         * isAsset
 14.04.15         * add GoodsPlatform
 24.11.14         * add GoodsGroupAnalyst             
 15.09.14         * add GoodsTag
 11.09.14         * add TradeMark
 04.09.14         *              
 12.06.13         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_GoodsGroup ('2')
