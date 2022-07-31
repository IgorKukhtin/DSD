-- Function: gpSelect_Object_Goods_Site()

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
     WITH tmpFormDispensing AS (SELECT 1 AS IDSite, 18067778 AS ID
                                UNION ALL 
                                SELECT 2, 18067781
                                UNION ALL 
                                SELECT 3, 18067782
                                UNION ALL 
                                SELECT 4, 18067783
                                UNION ALL 
                                SELECT 5, 18067780
                                UNION ALL 
                                SELECT 6, 18067779)
   
      SELECT Object_Goods_Main.Id
           , Object_Goods_Retail.Id
           , Object_Goods_Main.ObjectCode
           , Object_Goods_Main.isPublished
           , Object_Goods_Main.Name
           , Object_Goods_Main.NameUkr
           , Object_Goods_Main.MakerName
           , Object_Goods_Main.MakerNameUkr
           , tmpFormDispensing.IDSite                            AS FormDispensingId
           , Object_FormDispensing.ValueData                     AS FormDispensingName
           , ObjectString_FormDispensing_NameUkr.ValueData       AS NameUkr
           , Object_Goods_Main.NumberPlates
           , Object_Goods_Main.QtyPackage
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
                                 
           LEFT JOIN tmpFormDispensing ON tmpFormDispensing.ID = Object_Goods_Main.FormDispensingId
           
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