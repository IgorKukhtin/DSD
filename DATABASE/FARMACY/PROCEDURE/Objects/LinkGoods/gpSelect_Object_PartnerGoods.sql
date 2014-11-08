-- Function: gpSelect_Object_PartnerGoods(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_PartnerGoods(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PartnerGoods(
    IN inPartnerId    Integer,       -- Торговая сеть
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , GoodsMainId Integer             
             , GoodsId Integer, GoodsName TVarChar, GoodsCode TVarChar
             , JuridicalName TVarChar, MakerName TVarChar
             ) AS
$BODY$
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_AdditionalGoods());

   RETURN QUERY 
     SELECT 
           Object_LinkGoods_View.Id               
         , Object_LinkGoods_View.GoodsMainId
         , Object_LinkGoods_View.GoodsId
         , Object_LinkGoods_View.GoodsName
         , COALESCE(Object_LinkGoods_View.GoodsCode, Object_LinkGoods_View.GoodsCodeInt::TVarChar)
         , Juridical.ValueData AS JuridicalName
         , Object_LinkGoods_View.MakerName
         
     FROM Object_LinkGoods_View
     JOIN Object AS Juridical ON Juridical.Id = Object_LinkGoods_View.ObjectId
           

     WHERE ((Object_LinkGoods_View.ObjectId in 
                (SELECT Object.Id FROM Object WHERE DescId = zc_Object_Juridical()
                 UNION SELECT zc_Enum_GlobalConst_BarCode()
                 UNION SELECT zc_Enum_GlobalConst_Marion()  ) AND inPartnerId = 0) OR 
           (Object_LinkGoods_View.ObjectId = inPartnerId));  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_PartnerGoods (Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 29.08.14                        *
 07.08.14                        *
 02.07.14         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_AdditionalGoods ('2')
