DROP FUNCTION IF EXISTS gpSelect_Object_AdditionalGoodsAll(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_AdditionalGoodsAll(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , GoodsMainId Integer, GoodsMainCode Integer, GoodsMainName TVarChar
             , GoodsSecondId Integer, GoodsSecondCode Integer, GoodsSecondName TVarChar    
             ) AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbObjectId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_AdditionalGoods());
    vbUserId := lpGetUserBySession (inSession);
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

    RETURN QUERY 
        SELECT                                          	
            Object_AdditionalGoods_View.Id               
           ,Object_AdditionalGoods_View.GoodsMainId
           ,Object_AdditionalGoods_View.GoodsMainCode::Integer
           ,Object_AdditionalGoods_View.GoodsMainName
           ,Object_AdditionalGoods_View.GoodsSecondId
           ,Object_AdditionalGoods_View.GoodsSecondCode::Integer
           ,Object_AdditionalGoods_View.GoodsSecondName
    FROM Object_AdditionalGoods_View
    ORDER BY 
        Object_AdditionalGoods_View.GoodsMainCode
       ,Object_AdditionalGoods_View.GoodsSecondCode;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_AdditionalGoodsAll (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 07.08.14                        *
 02.07.14         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_AdditionalGoods ('2')
