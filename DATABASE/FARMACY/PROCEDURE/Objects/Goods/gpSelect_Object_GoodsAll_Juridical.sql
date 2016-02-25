-- Function: gpSelect_Object_Goods()
 
DROP FUNCTION IF EXISTS gpSelect_Object_GoodsAll_Juridical(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsAll_Juridical(
     IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer
             , GoodsMainId Integer, GoodsMainCode Integer, GoodsMainName TVarChar
             , GoodsId Integer, GoodsCodeInt Integer, GoodsCode TVarChar, GoodsName TVarChar
             , MakerName TVarChar, MinimumLot TFloat
             , IsUpload Boolean, IsPromo Boolean, isSpecCondition Boolean
             , UpdateName TVarChar
             , UpdateDate TDateTime
             , JuridicalName TVarChar


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
           ObjectLink_LinkGoods_GoodsMain.ObjectId AS Id
         , MainGoods.Id                            AS GoodsMainId
         , MainGoods.ObjectCode                    AS GoodsMainCode
         , MainGoods.ValueData                     AS GoodsMainName
         , Object_Goods.Id                         AS GoodsId 
         , Object_Goods.ObjectCode                 AS GoodsCodeInt
         , ObjectString.ValueData                  AS GoodsCode
         , Object_Goods.ValueData                  AS GoodsName
         , ObjectString_Goods_Maker.ValueData      AS MakerName
         , ObjectFloat_Goods_MinimumLot.ValueData  AS MinimumLot
         , COALESCE(ObjectBoolean_Goods_IsUpload.ValueData,FALSE) AS IsUpload
         , COALESCE(ObjectBoolean_Goods_IsPromo.ValueData,FALSE)  AS IsPromo
         , COALESCE(ObjectBoolean_Goods_SpecCondition.ValueData,FALSE)  AS IsSpecCondition

         , COALESCE(Object_Update.ValueData, '')                ::TVarChar  AS UpdateName
         , COALESCE(ObjectDate_Protocol_Update.ValueData, Null) ::TDateTime AS UpdateDate
         , Object_Juridical.ValueData               AS JuridicalName

      FROM  ObjectLink AS ObjectLink_Goods_Object

          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods_Object.ObjectId 

          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Goods_Object.ChildObjectId 

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
                         
      WHERE ObjectLink_Goods_Object.ChildObjectId <> vbObjectId--inObjectId
     AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object();
                         
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 25.02.16         *
 
*/

-- ����
 --SELECT * FROM gpSelect_Object_GoodsAll_Juridical('3')