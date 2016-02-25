-- Function: gpSelect_Object_Goods()
 
DROP FUNCTION IF EXISTS gpSelect_Object_GoodsAll_Juridical(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsAll_Juridical(
     IN inSession     TVarChar       -- ñåññèÿ ïîëüçîâàòåëÿ
)
RETURNS TABLE (Id Integer
             , GoodsMainId Integer--, GoodsMainCode Integer, GoodsMainName TVarChar
             , GoodsId Integer, GoodsCodeInt Integer, GoodsName TVarChar
             , GoodsGroupId Integer, GoodsGroupName TVarChar
             , MeasureId Integer, MeasureName TVarChar
             , NDSKindId Integer, NDSKindName TVarChar, NDS TFloat

             , MinimumLot TFloat, isClose boolean, isTOP boolean
             , PercentMarkup TFloat, Price TFloat
             --, IsUpload Boolean, IsPromo Boolean, isSpecCondition Boolean
             , ObjectDescName TVarChar, ObjectName TVarChar
             , MakerName TVarChar
             , isErased boolean
            
) AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbObjectId Integer;
BEGIN

--   PERFORM lpCheckRight(inSession, zc_Enum_Process_User());
   vbUserId := lpGetUserBySession (inSession);
   vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

      RETURN QUERY 
           SELECT 
             Object_Goods_View.ObjectId         AS Id 
           , LinkGoods_Main.GoodsMainId  
           , Object_Goods_View.Id               AS GoodsId 
           , Object_Goods_View.GoodsCodeInt     AS GoodsCodeInt
           , Object_Goods_View.GoodsName        AS GoodsName
           , Object_Goods_View.GoodsGroupId
           , Object_Goods_View.GoodsGroupName
           , Object_Goods_View.MeasureId
           , Object_Goods_View.MeasureName
           , Object_Goods_View.NDSKindId
           , Object_Goods_View.NDSKindName
           , Object_Goods_View.NDS
           , Object_Goods_View.MinimumLot
           , Object_Goods_View.isClose
           , Object_Goods_View.isTOP          
           , Object_Goods_View.PercentMarkup  
           , Object_Goods_View.Price
           , ObjectDesc_GoodsObject.itemname   AS  ObjectDescName
           , Object_GoodsObject.ValueData       AS  ObjectName
           , Object_Goods_View.MakerName
           , Object_Goods_View.isErased

    FROM Object_Goods_View 
       LEFT JOIN  Object_LinkGoods_View AS LinkGoods_Main ON LinkGoods_Main.GoodsId = Object_Goods_View.Id

       LEFT JOIN Object AS Object_GoodsObject ON Object_GoodsObject.Id = Object_Goods_View.ObjectId
       LEFT JOIN ObjectDesc AS ObjectDesc_GoodsObject ON ObjectDesc_GoodsObject.Id = Object_GoodsObject.DescId
          
   WHERE Object_Goods_View.ObjectId <> vbObjectId;

    /*  SELECT 
           ObjectLink_LinkGoods_GoodsMain.ObjectId AS Id
         , MainGoods.Id                            AS GoodsMainId
         , MainGoods.ObjectCode                    AS GoodsMainCode
         , MainGoods.ValueData                     AS GoodsMainName
         , Object_Goods.Id                         AS GoodsId 
         , Object_Goods.ObjectCode                 AS GoodsCodeInt
         , ObjectString.ValueData                  AS GoodsCode
         , Object_Goods.ValueData                  AS GoodsName
         , ObjectLink_Goods_GoodsGroup.ChildObjectId        AS GoodsGroupId
         , Object_GoodsGroup.ValueData                      AS GoodsGroupName
         , ObjectString_Goods_Maker.ValueData      AS MakerName
         , ObjectFloat_Goods_MinimumLot.ValueData  AS MinimumLot
         , ObjectFloat_Goods_Price.ValueData       AS Price
         , COALESCE(ObjectBoolean_Goods_IsUpload.ValueData,FALSE) AS IsUpload
         , COALESCE(ObjectBoolean_Goods_IsPromo.ValueData,FALSE)  AS IsPromo
         , COALESCE(ObjectBoolean_Goods_SpecCondition.ValueData,FALSE)  AS IsSpecCondition

         , COALESCE(Object_Update.ValueData, '')                ::TVarChar  AS UpdateName
         , COALESCE(ObjectDate_Protocol_Update.ValueData, Null) ::TDateTime AS UpdateDate
         , ObjectDesc_GoodsObject.itemname         AS ObjectDescName
         , Object_GoodsObject.ValueData            AS ObjectName
         
         , ObjectLink_Goods_Measure.ChildObjectId           AS MeasureId
         , Object_Measure.ValueData                         AS MeasureName
         , ObjectLink_Goods_NDSKind.ChildObjectId           AS NDSKindId
         , Object_NDSKind.ValueData                         AS NDSKindName


      FROM  ObjectLink AS ObjectLink_Goods_Object

          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods_Object.ObjectId 

          LEFT JOIN Object AS Object_GoodsObject ON Object_GoodsObject.Id = ObjectLink_Goods_Object.ChildObjectId 
          LEFT JOIN ObjectDesc AS ObjectDesc_GoodsObject ON ObjectDesc_GoodsObject.Id = Object_GoodsObject.DescId
          
          LEFT JOIN ObjectString ON ObjectString.ObjectId = ObjectLink_Goods_Object.ObjectId
                                AND ObjectString.DescId = zc_ObjectString_Goods_Code()
          LEFT JOIN ObjectString AS ObjectString_Goods_Maker
                                 ON ObjectString_Goods_Maker.ObjectId = ObjectLink_Goods_Object.ObjectId
                                AND ObjectString_Goods_Maker.DescId = zc_ObjectString_Goods_Maker()

          LEFT JOIN ObjectFloat AS ObjectFloat_Goods_MinimumLot
                                ON ObjectFloat_Goods_MinimumLot.ObjectId = ObjectLink_Goods_Object.ObjectId
                               AND ObjectFloat_Goods_MinimumLot.DescId = zc_ObjectFloat_Goods_MinimumLot()   

          LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_IsUpload
                                  ON ObjectBoolean_Goods_IsUpload.ObjectId = ObjectLink_Goods_Object.ObjectId
                                 AND ObjectBoolean_Goods_IsUpload.DescId = zc_ObjectBoolean_Goods_IsUpload()
          LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_IsPromo
                                  ON ObjectBoolean_Goods_IsPromo.ObjectId = ObjectLink_Goods_Object.ObjectId
                                 AND ObjectBoolean_Goods_IsPromo.DescId = zc_ObjectBoolean_Goods_Promo()
          LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_SpecCondition
                                  ON ObjectBoolean_Goods_SpecCondition.ObjectId = ObjectLink_Goods_Object.ObjectId
                                 AND ObjectBoolean_Goods_SpecCondition.DescId = zc_ObjectBoolean_Goods_SpecCondition()

          LEFT JOIN ObjectLink AS ObjectLink_LinkGoods_Goods
                               ON ObjectLink_LinkGoods_Goods.DescId = zc_ObjectLink_LinkGoods_Goods()
                              AND ObjectLink_LinkGoods_Goods.ChildObjectId = Object_Goods.Id

          LEFT JOIN ObjectLink AS ObjectLink_LinkGoods_GoodsMain 
                               ON ObjectLink_LinkGoods_GoodsMain.ObjectId = ObjectLink_LinkGoods_Goods.ObjectId 
                              AND ObjectLink_LinkGoods_GoodsMain.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
     
          LEFT JOIN OBJECT AS MainGoods ON MainGoods.Id = ObjectLink_LinkGoods_GoodsMain.ChildObjectId

          LEFT JOIN ObjectDate AS ObjectDate_Protocol_Update
                               ON ObjectDate_Protocol_Update.ObjectId = Object_Goods.Id
                              AND ObjectDate_Protocol_Update.DescId = zc_ObjectDate_Protocol_Update()
          LEFT JOIN ObjectLink AS ObjectLink_Update
                             ON ObjectLink_Update.ObjectId = Object_Goods.Id
                            AND ObjectLink_Update.DescId = zc_ObjectLink_Protocol_Update()
          LEFT JOIN Object AS Object_Update ON Object_Update.Id = ObjectLink_Update.ChildObjectId 

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                               ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
          LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                               ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                               ON ObjectLink_Goods_NDSKind.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()
          LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = ObjectLink_Goods_NDSKind.ChildObjectId
       
          LEFT JOIN ObjectFloat AS ObjectFloat_Goods_Price
                                ON ObjectFloat_Goods_Price.ObjectId = Object_Goods.Id
                               AND ObjectFloat_Goods_Price.DescId = zc_ObjectFloat_Goods_Price()   
                         
      WHERE ObjectLink_Goods_Object.ChildObjectId <> vbObjectId--inObjectId
     AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object();*/
                         
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ÈÑÒÎÐÈß ÐÀÇÐÀÁÎÒÊÈ: ÄÀÒÀ, ÀÂÒÎÐ
               Ôåëîíþê È.Â.   Êóõòèí È.Â.   Êëèìåíòüåâ Ê.È.
 25.02.16         *
 
*/

-- òåñò
 --SELECT * FROM gpSelect_Object_GoodsAll_Juridical('3')