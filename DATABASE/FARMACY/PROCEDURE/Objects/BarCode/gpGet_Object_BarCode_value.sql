-- Function: gpGet_Object_BarCode_value()

DROP FUNCTION IF EXISTS gpGet_Object_BarCode_value (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_BarCode_value(
    IN inObjectId    Integer    , --
    IN inGoodsId     Integer    , --
   OUT outBarCode    TVarChar   , --
    IN inSession     TVarChar     --
)
RETURNS TVarChar
AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_...());
   
   IF EXISTS(SELECT * FROM Object_Goods_Retail WHERE Object_Goods_Retail.ID = inGoodsId AND Object_Goods_Retail.RetailId <> 4)
   THEN
     
     SELECT Object_Goods_Retail4.Id
     INTO inGoodsId
     FROM Object_Goods_Retail 
          INNER JOIN Object_Goods_Retail AS Object_Goods_Retail4 
                                         ON Object_Goods_Retail4.GoodsMainId = Object_Goods_Retail.GoodsMainId 
                                        AND Object_Goods_Retail4.RetailId = 4
     WHERE Object_Goods_Retail.ID = inGoodsId;
   
   END IF;

      IF 1 < (SELECT COUNT(*)
              FROM ObjectLink AS ObjectLink_BarCode_Goods
                   INNER JOIN ObjectLink AS ObjectLink_BarCode_Object
                                        ON ObjectLink_BarCode_Object.ObjectId      = ObjectLink_BarCode_Goods.ObjectId
                                       AND ObjectLink_BarCode_Object.DescId        = zc_ObjectLink_BarCode_Object()
                                       AND ObjectLink_BarCode_Object.ChildObjectId = inObjectId

                   INNER JOIN Object AS Object_BarCode ON Object_BarCode.Id = ObjectLink_BarCode_Goods.ObjectId
                                                      AND Object_BarCode.isErased = FALSE

              WHERE ObjectLink_BarCode_Goods.ChildObjectId = inGoodsId
                AND ObjectLink_BarCode_Goods.DescId        = zc_ObjectLink_BarCode_Goods()
             )
      THEN
          RAISE EXCEPTION 'Ошибка. В справочник ш/к для проекта <%> дублируется товар <%>.', lfGet_Object_ValueData (inObjectId), lfGet_Object_ValueData (inGoodsId);
      END IF;

      -- Определяется ш/к
      outBarCode:= (SELECT Object_BarCode.ValueData
                    FROM ObjectLink AS ObjectLink_BarCode_Goods
                         INNER JOIN ObjectLink AS ObjectLink_BarCode_Object
                                              ON ObjectLink_BarCode_Object.ObjectId      = ObjectLink_BarCode_Goods.ObjectId
                                             AND ObjectLink_BarCode_Object.DescId        = zc_ObjectLink_BarCode_Object()
                                             AND ObjectLink_BarCode_Object.ChildObjectId = inObjectId

                         INNER JOIN Object AS Object_BarCode ON Object_BarCode.Id       = ObjectLink_BarCode_Goods.ObjectId
                                                            AND Object_BarCode.isErased = FALSE

                    WHERE ObjectLink_BarCode_Goods.ChildObjectId = inGoodsId
                      AND ObjectLink_BarCode_Goods.DescId        = zc_ObjectLink_BarCode_Goods()
                   )
                   ;
/*
      outBarCode:= '4034541002175'; -- 6124
      outBarCode:= '4820043368662'; -- 6136
      outBarCode:= '4820043368488'; -- 6139
      outBarCode:= '4820043368310'; -- 6155
      outBarCode:= '4820043368167'; -- 6161
      outBarCode:= '4820043367832'; -- 6167
      -- outCardNumber:= 4820043367665
      -- outCardNumber:= 4820043368815
      -- outCardNumber:= 4820043368662
*/

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_BarCode_value (Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.07.16                                        *
*/

-- тест
-- SELECT gpGet_Object_BarCode_value (inObjectId:= 2, inGoodsId:= 1, inSession:= zfCalc_UserAdmin())


select * from gpGet_Object_BarCode_value(inObjectId := 4521216 , inGoodsId := 10195093 ,  inSession := '3998209');