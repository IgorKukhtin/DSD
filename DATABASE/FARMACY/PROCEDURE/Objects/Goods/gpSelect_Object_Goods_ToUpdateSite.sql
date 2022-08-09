-- Function: gpSelect_Object_Goods_ToUpdateSite()

DROP FUNCTION IF EXISTS gpSelect_Object_Goods_ToUpdateSite(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Goods_ToUpdateSite(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (IdMain Integer
             , Id Integer
             , Code Integer
             , isPublished Boolean
             , Name TVarChar
             , NameUkr TVarChar
             , MakerName TVarChar
             , MakerNameUkr TVarChar
             , FormDispensingId Integer
             , FormDispensingName TVarChar
             , FormDispensingNameUkr TVarChar
             , NumberPlates Integer
             , QtyPackage Integer
             
             , Multiplicity TFloat
             , isDoesNotShare Boolean
             , isSP Boolean
             , isDiscountExternal Boolean
             , isRecipe boolean
             , isNameUkrSite boolean
             , isMakerNameSite boolean
             , isMakerNameUkrSite boolean
             , isErased Boolean
              ) AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_User());
   vbUserId:= lpGetUserBySession (inSession);


   RETURN QUERY
     WITH tmpGoodsSP AS (SELECT DISTINCT tmp.GoodsId, TRUE AS isSP
                         FROM lpSelect_MovementItem_GoodsSP_onDate (inStartDate:= CURRENT_DATE, inEndDate:= CURRENT_DATE) AS tmp
                         )
           -- Товары дисконтной программы
        , tmpGoodsDiscount AS (SELECT ObjectLink_BarCode_Goods.ChildObjectId                AS GoodsId
                               FROM Object AS Object_BarCode

                                    LEFT JOIN ObjectLink AS ObjectLink_BarCode_Goods
                                                         ON ObjectLink_BarCode_Goods.ObjectId = Object_BarCode.Id
                                                        AND ObjectLink_BarCode_Goods.DescId = zc_ObjectLink_BarCode_Goods()
                                           
                                     LEFT JOIN ObjectLink AS ObjectLink_BarCode_Object
                                                          ON ObjectLink_BarCode_Object.ObjectId = Object_BarCode.Id
                                                         AND ObjectLink_BarCode_Object.DescId = zc_ObjectLink_BarCode_Object()
                                     LEFT JOIN Object AS Object_Object ON Object_Object.Id = ObjectLink_BarCode_Object.ChildObjectId           

                               WHERE Object_BarCode.DescId = zc_Object_BarCode()
                                 AND Object_BarCode.isErased = False
                                 AND Object_Object.isErased = False
                               GROUP BY ObjectLink_BarCode_Goods.ChildObjectId 
                        )
   
      SELECT Object_Goods_Main.Id
           , Object_Goods_Retail.Id
           , Object_Goods_Main.ObjectCode
           , Object_Goods_Main.isPublished
           , Object_Goods_Main.Name
           , Object_Goods_Main.NameUkr
           , Object_Goods_Main.MakerName
           , Object_Goods_Main.MakerNameUkr
           , Object_Goods_Main.FormDispensingId                  AS FormDispensingId
           , Object_FormDispensing.ValueData                     AS FormDispensingName
           , ObjectString_FormDispensing_NameUkr.ValueData       AS NameUkr
           , Object_Goods_Main.NumberPlates
           , Object_Goods_Main.QtyPackage
           
           , Object_Goods_Main.Multiplicity
           , Object_Goods_Main.isDoesNotShare OR Object_Goods_Main.isAllowDivision    AS isDoesNotShare
          -- , COALESCE (tmpGoodsSP.isSP, False)::Boolean                               AS isSP
           , False                                                                    AS isSP
           , (COALESCE (tmpGoodsDiscount.GoodsId, 0) <> 0 )::Boolean                  AS isDiscountExternal

           , Object_Goods_Main.isRecipe
           , Object_Goods_Main.isNameUkrSite
           , Object_Goods_Main.isMakerNameSite
           , Object_Goods_Main.isMakerNameUkrSite

           , Object_Goods_Retail.isErased

      FROM Object_Goods_Retail

           LEFT JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId

           LEFT JOIN Object AS Object_FormDispensing ON Object_FormDispensing.Id = Object_Goods_Main.FormDispensingId
           LEFT JOIN ObjectString AS ObjectString_FormDispensing_NameUkr
                                  ON ObjectString_FormDispensing_NameUkr.ObjectId = Object_FormDispensing.Id
                                 AND ObjectString_FormDispensing_NameUkr.DescId = zc_ObjectString_FormDispensing_NameUkr()   
                                 
           LEFT JOIN tmpGoodsSP ON tmpGoodsSP.GoodsId = Object_Goods_Retail.GoodsMainId
           LEFT JOIN tmpGoodsDiscount ON tmpGoodsDiscount.GoodsId = Object_Goods_Retail.Id
           
      WHERE Object_Goods_Retail.RetailId = 4
        AND Object_Goods_Main.isPublished = True
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpSelect_Object_Goods_Retail(TVarChar) OWNER TO postgres;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 19.07.22                                                      *
*/

-- тест

select * from gpSelect_Object_Goods_ToUpdateSite(inSession := '3');