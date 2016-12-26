-- Function: gpSelect_Object_Goods()

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsSP(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsSP(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased_inf Boolean, isErased Boolean
             , IntenalSPId Integer, IntenalSPName TVarChar
             , BrandSPId Integer, BrandSPName TVarChar
             , KindOutSPId Integer, KindOutSPName TVarChar
             , PriceSP TFloat, GroupSP TFloat, CountSP TFloat
             , isSP Boolean
             , Pack TVarChar
             ) AS
$BODY$ 
  DECLARE vbUserId Integer;

  DECLARE vbObjectId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_User());
   vbUserId:= lpGetUserBySession (inSession);


   RETURN QUERY 
       SELECT 
             ObjectBoolean_Goods_SP.ObjectId              AS Id
           , Object_Goods.ObjectCode                      AS Code
           , Object_Goods.ValueData                       AS Name
           , Object_Goods.isErased                        AS isErased_inf
           , CASE WHEN ObjectBoolean_Goods_SP.ValueData = FALSE THEN TRUE ELSE FALSE END AS isErased
           , ObjectLink_Goods_IntenalSP.ChildObjectId     AS IntenalSPId
           , Object_IntenalSP.ValueData                   AS IntenalSPName
           , ObjectLink_Goods_BrandSP.ChildObjectId       AS BrandSPId
           , Object_BrandSP.ValueData                     AS BrandSPName
           , ObjectLink_Goods_KindOutSP.ChildObjectId     AS KindOutSPId
           , Object_KindOutSP.ValueData                   AS KindOutSPName

           , ObjectFloat_Goods_PriceSP.ValueData          AS PriceSP
           , ObjectFloat_Goods_GroupSP.ValueData          AS GroupSP
           , ObjectFloat_Goods_CountSP.ValueData          AS CountSP
           , ObjectBoolean_Goods_SP.ValueData             AS isSP
           , ObjectString_Goods_Pack.ValueData            AS Pack

       FROM ObjectBoolean AS ObjectBoolean_Goods_SP 

            LEFT JOIN Object AS Object_Goods 
                             ON Object_Goods.Id = ObjectBoolean_Goods_SP.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Object 
                                 ON ObjectLink_Goods_Object.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_IntenalSP
                                 ON ObjectLink_Goods_IntenalSP.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_IntenalSP.DescId = zc_ObjectLink_Goods_IntenalSP()

            LEFT JOIN Object AS Object_IntenalSP ON Object_IntenalSP.Id = ObjectLink_Goods_IntenalSP.ChildObjectId
        
            LEFT JOIN ObjectLink AS ObjectLink_Goods_BrandSP
                                 ON ObjectLink_Goods_BrandSP.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_BrandSP.DescId = zc_ObjectLink_Goods_BrandSP()
            LEFT JOIN Object AS Object_BrandSP ON Object_BrandSP.Id = ObjectLink_Goods_BrandSP.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_KindOutSP
                                 ON ObjectLink_Goods_KindOutSP.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_KindOutSP.DescId = zc_ObjectLink_Goods_KindOutSP()
            LEFT JOIN Object AS Object_KindOutSP ON Object_KindOutSP.Id = ObjectLink_Goods_KindOutSP.ChildObjectId

            LEFT JOIN ObjectFloat AS ObjectFloat_Goods_PriceSP
                                  ON ObjectFloat_Goods_PriceSP.ObjectId = Object_Goods.Id
                                 AND ObjectFloat_Goods_PriceSP.DescId = zc_ObjectFloat_Goods_PriceSP()   
            LEFT JOIN ObjectFloat AS ObjectFloat_Goods_GroupSP
                                  ON ObjectFloat_Goods_GroupSP.ObjectId = Object_Goods.Id 
                                 AND ObjectFloat_Goods_GroupSP.DescId = zc_ObjectFloat_Goods_GroupSP()
            LEFT JOIN ObjectFloat AS ObjectFloat_Goods_CountSP
                                  ON ObjectFloat_Goods_CountSP.ObjectId = Object_Goods.Id 
                                 AND ObjectFloat_Goods_CountSP.DescId = zc_ObjectFloat_Goods_CountSP()

            LEFT JOIN ObjectString AS ObjectString_Goods_Pack
                                   ON ObjectString_Goods_Pack.ObjectId = Object_Goods.Id 
                                  AND ObjectString_Goods_Pack.DescId = zc_ObjectString_Goods_Pack()
     
   WHERE ObjectBoolean_Goods_SP.DescId = zc_ObjectBoolean_Goods_SP();

  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_GoodsSP(TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.12.16         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_GoodsSP (zfCalc_UserAdmin())

