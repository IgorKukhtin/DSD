-- Function: gpGet_Object_Goods()

DROP FUNCTION IF EXISTS gpGet_Object_Goods (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Goods(
    IN inId          Integer,       -- Товар 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar , ShortName TVarChar
             , Name_BUH TVarChar, Date_BUH TDateTime
             , Weight TFloat
             , WeightTare TFloat
             , CountForWeight TFloat
             , GoodsGroupId Integer, GoodsGroupName TVarChar
             , GroupStatId Integer, GroupStatName TVarChar
             , MeasureId Integer,  MeasureName TVarChar
             , TradeMarkId Integer, TradeMarkName TVarChar
             , GoodsTagId Integer, GoodsTagName TVarChar
             , InfoMoneyId Integer, InfoMoneyName TVarChar
             , BusinessId Integer, BusinessName TVarChar
             , FuelId Integer, FuelName TVarChar
             , GoodsGroupAnalystId Integer, GoodsGroupAnalystName TVarChar 
             , GoodsGroupPropertyId Integer, GoodsGroupPropertyName TVarChar, GoodsGroupPropertyId_Parent Integer, GoodsGroupPropertyName_Parent TVarChar
             , GoodsGroupDirectionId Integer, GoodsGroupDirectionName TVarChar
             , PriceListId Integer, PriceListName TVarChar, StartDate TDateTime, ValuePrice TFloat
             , Comment TVarChar 
             , isHeadCount Boolean
             , isPartionDate Boolean
              )
AS
$BODY$
   DECLARE vbPriceListId Integer;
   DECLARE vbPriceListName TVarChar;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_Goods());
    
   --ПРАЙС по умолчанию - код 47  прайс-план калькуляции(сырье) 
   SELECT Object.Id, Object.ValueData 
          INTO vbPriceListId, vbPriceListName 
   FROM Object
   WHERE Object.DescId     = zc_Object_PriceList() 
     AND Object.ObjectCode = 47;  --код 47 прайс-план калькуляции(сырье) 

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_Goods()) AS Code
           , CAST ('' as TVarChar)  AS Name 
           , ''         :: TVarChar AS ShortName
           , CAST ('' as TVarChar)  AS Name_BUH
           , CAST (Null as TDateTime) AS Date_BUH
           , CAST (0 as TFloat)     AS Weight
           , CAST (0 as TFloat)     AS WeightTare
           , CAST (0 as TFloat)     AS CountForWeight

           , CAST (0 as Integer)   AS GoodsGroupId
           , CAST ('' as TVarChar) AS GoodsGroupName 
           
           , CAST (0 as Integer)   AS GroupStatId
           , CAST ('' as TVarChar) AS GroupStatName 
           
           , CAST (0 as Integer)   AS MeasureId
           , CAST ('' as TVarChar) AS MeasureName
           
           , CAST (0 as Integer)   AS TradeMarkId
           , CAST ('' as TVarChar) AS TradeMarkName
           
           , CAST (0 as Integer)   AS GoodsTagId
           , CAST ('' as TVarChar) AS GoodsTagName
           
           , CAST (0 as Integer)   AS InfoMoneyId
           , CAST ('' as TVarChar) AS InfoMoneyName
           
           , CAST (0 as Integer)   AS BusinessId
           , CAST ('' as TVarChar) AS BusinessName

           , CAST (0 as Integer)   AS FuelId
           , CAST ('' as TVarChar) AS FuelName
           
           , CAST (0 as Integer)   AS GoodsGroupAnalystId
           , CAST ('' as TVarChar) AS GoodsGroupAnalystName    

           , CAST (0 as Integer)   AS GoodsGroupPropertyId
           , CAST ('' as TVarChar) AS GoodsGroupPropertyName
           , CAST (0 as Integer)   AS GoodsGroupPropertyId_Parent
           , CAST ('' as TVarChar) AS GoodsGroupPropertyName_Parent

           , 0         :: Integer  AS GoodsGroupDirectionId
           , ''        :: TVarChar AS GoodsGroupDirectionName

           , vbPriceListId                 AS PriceListId 
           , vbPriceListName               AS PriceListName
           , zc_DateStart()                AS StartDate 
           , CAST (0 as TFloat)            AS ValuePrice
           , NULL              ::TVarChar  AS Comment
           , FALSE             ::Boolean   AS isHeadCount
           , FALSE             ::Boolean   AS isPartionDate
      
       ;
   ELSE
       RETURN QUERY 
       SELECT 
             Object_Goods.Id              AS Id
           , Object_Goods.ObjectCode      AS Code
           , Object_Goods.ValueData       AS Name
           , ObjectString_Goods_ShortName.ValueData :: TVarChar AS ShortName
           , COALESCE (zfCalc_Text_replace (ObjectString_Goods_BUH.ValueData, CHR (39), '`' ), '') :: TVarChar AS Name_BUH
           , COALESCE (ObjectDate_BUH.ValueData,Null)   :: TDateTime AS Date_BUH
           
           , ObjectFloat_Weight.ValueData     AS Weight
           , ObjectFloat_WeightTare.ValueData AS WeightTare
           , ObjectFloat_CountForWeight.ValueData ::TFloat AS CountForWeight
         
           , Object_GoodsGroup.Id         AS GoodsGroupId
           , Object_GoodsGroup.ValueData  AS GoodsGroupName 
          
           , Object_GoodsGroupStat.Id        AS GroupStatId
           , Object_GoodsGroupStat.ValueData AS GroupStatName 
            
           , Object_Measure.Id            AS MeasureId
           , Object_Measure.ValueData     AS MeasureName

           , Object_TradeMark.Id          AS TradeMarkId
           , Object_TradeMark.ValueData   AS TradeMarkName

           , COALESCE (Object_GoodsTag.Id, CAST (0 as Integer)) AS GoodsTagId
           , COALESCE (Object_GoodsTag.ValueData,CAST ('' as TVarChar)) AS GoodsTagName
         
           , Object_InfoMoney.Id          AS InfoMoneyId
           , Object_InfoMoney.ValueData   AS InfoMoneyName
         
           , Object_Business.Id           AS BusinessId
           , Object_Business.ValueData    AS BusinessName

           , Object_Fuel.Id           AS FuelId
           , Object_Fuel.ValueData    AS FuelName
           
           , Object_GoodsGroupAnalyst.Id           AS GoodsGroupAnalystId
           , Object_GoodsGroupAnalyst.ValueData    AS GoodsGroupAnalystName           

           , Object_GoodsGroupProperty.Id        AS GoodsGroupPropertyId
           , Object_GoodsGroupProperty.ValueData AS GoodsGroupPropertyName
           , Object_GoodsGroupPropertyParent.Id        AS GoodsGroupPropertyId_Parent
           , Object_GoodsGroupPropertyParent.ValueData AS GoodsGroupPropertyName_Parent

           , Object_GoodsGroupDirection.Id        AS GoodsGroupDirectionId
           , Object_GoodsGroupDirection.ValueData AS GoodsGroupDirectionName

           , vbPriceListId                 AS PriceListId 
           , vbPriceListName               AS PriceListName
           , COALESCE (tmp.StartDate, zc_DateStart())    AS StartDate 
           , COALESCE (tmp.ValuePrice, 0) ::  TFloat     AS ValuePrice

           , ObjectString_Goods_Comment.ValueData ::TVarChar AS Comment

           , COALESCE (ObjectBoolean_Goods_HeadCount.ValueData, FALSE)  :: Boolean AS isHeadCount
           , COALESCE (ObjectBoolean_Goods_PartionDate.ValueData, FALSE):: Boolean AS isPartionDate
       FROM Object AS Object_Goods
          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                               ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
          LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId
          
          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupStat
                              ON ObjectLink_Goods_GoodsGroupStat.ObjectId = Object_Goods.Id
                             AND ObjectLink_Goods_GoodsGroupStat.DescId = zc_ObjectLink_Goods_GoodsGroupStat()
          LEFT JOIN Object AS Object_GoodsGroupStat ON Object_GoodsGroupStat.Id = ObjectLink_Goods_GoodsGroupStat.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                               ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id 
                              AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                               ON ObjectLink_Goods_TradeMark.ObjectId = Object_Goods.Id 
                              AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
          LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_Goods_TradeMark.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsTag
                               ON ObjectLink_Goods_GoodsTag.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_GoodsTag.DescId = zc_ObjectLink_Goods_GoodsTag()
          LEFT JOIN Object AS Object_GoodsTag ON Object_GoodsTag.Id = ObjectLink_Goods_GoodsTag.ChildObjectId

          LEFT JOIN ObjectFloat AS ObjectFloat_Weight 
                                ON ObjectFloat_Weight.ObjectId = Object_Goods.Id 
                               AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()

          LEFT JOIN ObjectFloat AS ObjectFloat_WeightTare
                                ON ObjectFloat_WeightTare.ObjectId = Object_Goods.Id 
                               AND ObjectFloat_WeightTare.DescId = zc_ObjectFloat_Goods_WeightTare()

          LEFT JOIN ObjectFloat AS ObjectFloat_CountForWeight
                                ON ObjectFloat_CountForWeight.ObjectId = Object_Goods.Id 
                               AND ObjectFloat_CountForWeight.DescId = zc_ObjectFloat_Goods_CountForWeight()

          LEFT JOIN ObjectString AS ObjectString_Goods_BUH
                                 ON ObjectString_Goods_BUH.ObjectId = Object_Goods.Id
                                AND ObjectString_Goods_BUH.DescId = zc_ObjectString_Goods_BUH()
          LEFT JOIN ObjectDate AS ObjectDate_BUH
                               ON ObjectDate_BUH.ObjectId = Object_Goods.Id
                              AND ObjectDate_BUH.DescId = zc_ObjectDate_Goods_BUH()

          LEFT JOIN ObjectString AS ObjectString_Goods_ShortName
                                 ON ObjectString_Goods_ShortName.ObjectId = Object_Goods.Id
                                AND ObjectString_Goods_ShortName.DescId = zc_ObjectString_Goods_ShortName()

          LEFT JOIN ObjectString AS ObjectString_Goods_Comment
                                 ON ObjectString_Goods_Comment.ObjectId = Object_Goods.Id
                                AND ObjectString_Goods_Comment.DescId = zc_ObjectString_Goods_Comment()

          LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_HeadCount
                                  ON ObjectBoolean_Goods_HeadCount.ObjectId = Object_Goods.Id 
                                 AND ObjectBoolean_Goods_HeadCount.DescId = zc_ObjectBoolean_Goods_HeadCount()

          LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_PartionDate
                                  ON ObjectBoolean_Goods_PartionDate.ObjectId = Object_Goods.Id 
                                 AND ObjectBoolean_Goods_PartionDate.DescId = zc_ObjectBoolean_Goods_PartionDate()

          LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                               ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id 
                              AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
          LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = ObjectLink_Goods_InfoMoney.ChildObjectId
          
          LEFT JOIN ObjectLink AS ObjectLink_Goods_Business
                               ON ObjectLink_Goods_Business.ObjectId = Object_Goods.Id 
                              AND ObjectLink_Goods_Business.DescId = zc_ObjectLink_Goods_Business()
          LEFT JOIN Object AS Object_Business ON Object_Business.Id = ObjectLink_Goods_Business.ChildObjectId    
          
          LEFT JOIN ObjectLink AS ObjectLink_Goods_Fuel
                               ON ObjectLink_Goods_Fuel.ObjectId = Object_Goods.Id 
                              AND ObjectLink_Goods_Fuel.DescId = zc_ObjectLink_Goods_Fuel()
          LEFT JOIN Object AS Object_Fuel ON Object_Fuel.Id = ObjectLink_Goods_Fuel.ChildObjectId    

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupAnalyst
                               ON ObjectLink_Goods_GoodsGroupAnalyst.ObjectId = Object_Goods.Id 
                              AND ObjectLink_Goods_GoodsGroupAnalyst.DescId = zc_ObjectLink_Goods_GoodsGroupAnalyst()
          LEFT JOIN Object AS Object_GoodsGroupAnalyst ON Object_GoodsGroupAnalyst.Id = ObjectLink_Goods_GoodsGroupAnalyst.ChildObjectId  

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupProperty
                               ON ObjectLink_Goods_GoodsGroupProperty.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_GoodsGroupProperty.DescId = zc_ObjectLink_Goods_GoodsGroupProperty()
          LEFT JOIN Object AS Object_GoodsGroupProperty ON Object_GoodsGroupProperty.Id = ObjectLink_Goods_GoodsGroupProperty.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_GoodsGroupProperty_Parent
                               ON ObjectLink_GoodsGroupProperty_Parent.ObjectId = Object_GoodsGroupProperty.Id
                              AND ObjectLink_GoodsGroupProperty_Parent.DescId = zc_ObjectLink_GoodsGroupProperty_Parent()
          LEFT JOIN Object AS Object_GoodsGroupPropertyParent ON Object_GoodsGroupPropertyParent.Id = ObjectLink_GoodsGroupProperty_Parent.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupDirection
                               ON ObjectLink_Goods_GoodsGroupDirection.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_GoodsGroupDirection.DescId = zc_ObjectLink_Goods_GoodsGroupDirection()
          LEFT JOIN Object AS Object_GoodsGroupDirection ON Object_GoodsGroupDirection.Id = ObjectLink_Goods_GoodsGroupDirection.ChildObjectId

          LEFT JOIN gpSelect_ObjectHistory_PriceListGoodsItem(inPriceListId := vbPriceListId , inGoodsId :=  inId,  inGoodsKindId := 0,  inSession := inSession) as tmp ON tmp.EndDate  =  zc_DateEnd()

       WHERE Object_Goods.Id = inId;

   END IF;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Goods (Integer, TVarChar) OWNER TO postgres;



/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.08.21         * _BUH
 23.10.19         * CountForWeight
 09.10.19         * add WeightTare
 24.11.14         * add inGoodsGroupAnalystId               
 15.09.14         * add zc_ObjectLink_Goods_GoodsTag()
 04.09.14         * 
 29.09.13                                        * add zc_ObjectLink_Goods_Fuel
 06.09.13                          *              
 02.07.13         * + TradeMark             
 02.07.13                                        * 1251Cyr
 21.06.13         *              
 11.06.13         *
 11.05.13                                        

*/

-- тест
-- SELECT * FROM gpGet_Object_Goods (0, '2')