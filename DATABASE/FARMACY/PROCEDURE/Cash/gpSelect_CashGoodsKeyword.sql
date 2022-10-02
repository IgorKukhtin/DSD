-- Function: gpSelect_CashGoodsKeyword()

DROP FUNCTION IF EXISTS gpSelect_CashGoodsKeyword (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_CashGoodsKeyword(
    IN inKeyword        TVarChar,   -- ключевое слово 
    IN inSession        TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer,
               GoodsCode Integer,
               GoodsName TVarChar,
               Amount TFloat,
               AccommodationName TVarChar
               )

AS
$BODY$
  DECLARE vbUserId      Integer;
  DECLARE vbObjectId    Integer;
  DECLARE vbUnitId      Integer;
  DECLARE vbUnitIdStr   TVarChar;
  DECLARE vbLanguage TVarChar;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_PriceList());
     vbUserId := inSession;
     vbObjectId := COALESCE (lpGet_DefaultValue ('zc_Object_Retail', vbUserId), '0');
     vbUnitIdStr := COALESCE (lpGet_DefaultValue ('zc_Object_Unit', vbUserId), '0');
     IF vbUnitIdStr <> '' THEN
        vbUnitId := vbUnitIdStr;
     ELSE
     	vbUnitId := 0;
     END IF;

    SELECT COALESCE (ObjectString_Language.ValueData, 'RU')::TVarChar                AS Language
    INTO vbLanguage
    FROM Object AS Object_User
                 
         LEFT JOIN ObjectString AS ObjectString_Language
                ON ObjectString_Language.ObjectId = Object_User.Id
               AND ObjectString_Language.DescId = zc_ObjectString_User_Language()
              
    WHERE Object_User.Id = vbUserId;    

    RETURN QUERY
    WITH
         
         tmpContainer AS (SELECT  Container.ObjectId
                                , SUM(Container.Amount)         AS Amount
                          FROM Container                               
                          WHERE Container.DescId = zc_Container_Count()
                            AND Container.WhereObjectId = vbUnitId
                            AND Container.Amount <> 0
                          GROUP BY Container.ObjectId                              
                          )

    SELECT GoodsRemains.ObjectId                                             AS Id
         , Object_Goods_Main.ObjectCode
         , CASE WHEN vbLanguage = 'UA' AND COALESCE(Object_Goods_Main.NameUkr, '') <> ''
                THEN Object_Goods_Main.NameUkr
                ELSE Object_Goods_Main.Name END                              AS Name
         , GoodsRemains.Amount::TFloat                                       AS Amount
         , Object_Accommodation.ValueData                                    AS AccommodationName
    FROM  tmpContainer AS GoodsRemains 

        LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = GoodsRemains.ObjectId
        LEFT JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId
        
        LEFT JOIN AccommodationLincGoods AS Accommodation
                                         ON Accommodation.UnitId = vbUnitId
                                        AND Accommodation.GoodsId = GoodsRemains.ObjectId
                                        AND Accommodation.isErased = False
        LEFT JOIN Object AS Object_Accommodation  ON Object_Accommodation.ID = Accommodation.AccommodationId
        
    WHERE Object_Goods_Main.Name ILIKE '%'||inKeyword||'%'
    ;        

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 16.03.21                                                       * 
*/

-- тест 

select * from gpSelect_CashGoodsKeyword(inKeyword := 'Аналь' ,  inSession := '3');