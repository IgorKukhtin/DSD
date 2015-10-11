DROP FUNCTION IF EXISTS gpSelect_Object_AdditionalGoods(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_AdditionalGoods(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , GoodsMainId Integer             
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar    
             ) AS
$BODY$
   DECLARE vbUserId   Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_AdditionalGoods());
    vbUserId := lpGetUserBySession (inSession);

    RETURN QUERY 
        SELECT                                          	
            Object_AdditionalGoods.Id               
           ,Object_AdditionalGoods.GoodsMainId
           ,Object_AdditionalGoods.GoodsSecondId
           ,Object_AdditionalGoods.GoodsSecondCode::Integer
           ,Object_AdditionalGoods.GoodsSecondName
        FROM Object_AdditionalGoods_View AS Object_AdditionalGoods
        ORDER BY
            Object_AdditionalGoods.GoodsMainId
           ,Object_AdditionalGoods.GoodsSecondName;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_AdditionalGoods (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 11.10.15                                                                      *
*/