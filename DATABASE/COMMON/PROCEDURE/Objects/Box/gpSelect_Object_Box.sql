-- Function: gpSelect_Object_Box()

DROP FUNCTION IF EXISTS gpSelect_Object_Box (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Box(
    IN inSession     TVarChar            -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , BoxVolume TFloat, BoxWeight TFloat
             , BoxHeight TFloat, BoxLength TFloat, BoxWidth TFloat
             , NPP TFloat
             , isErased boolean
              )
AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Box());

      RETURN QUERY
       SELECT
                 Object.Id         AS Id
               , Object.ObjectCode AS Code
               , Object.ValueData  AS Name
               
               , Object_Goods.Id          AS GoodsId
               , Object_Goods.ObjectCode  AS GoodsCode
               , Object_Goods.ValueData   AS GoodsName

               , OF_Box_Volume.ValueData  AS BoxVolume
               , OF_Box_Weight.ValueData  AS BoxWeight

               , COALESCE (ObjectFloat_Height.ValueData,0) ::TFloat  AS BoxHeight
               , COALESCE (ObjectFloat_Length.ValueData,0) ::TFloat  AS BoxLength
               , COALESCE (ObjectFloat_Width.ValueData,0)  ::TFloat  AS BoxWidth 
               , COALESCE (ObjectFloat_NPP.ValueData,0)    ::TFloat  AS NPP

               , Object.isErased   AS isErased

       FROM Object
            LEFT JOIN ObjectFloat AS OF_Box_Volume
                                  ON OF_Box_Volume.ObjectId = Object.Id
                                 AND OF_Box_Volume.DescId = zc_ObjectFloat_Box_Volume()
            LEFT JOIN ObjectFloat AS OF_Box_Weight
                                  ON OF_Box_Weight.ObjectId = Object.Id
                                 AND OF_Box_Weight.DescId = zc_ObjectFloat_Box_Weight()

            LEFT JOIN ObjectFloat AS ObjectFloat_Height
                                  ON ObjectFloat_Height.ObjectId = Object.Id
                                 AND ObjectFloat_Height.DescId = zc_ObjectFloat_Box_Height()

            LEFT JOIN ObjectFloat AS ObjectFloat_Length
                                  ON ObjectFloat_Length.ObjectId = Object.Id
                                 AND ObjectFloat_Length.DescId = zc_ObjectFloat_Box_Length()

            LEFT JOIN ObjectFloat AS ObjectFloat_Width
                                  ON ObjectFloat_Width.ObjectId = Object.Id
                                 AND ObjectFloat_Width.DescId = zc_ObjectFloat_Box_Width()

            LEFT JOIN ObjectFloat AS ObjectFloat_NPP
                                  ON ObjectFloat_NPP.ObjectId = Object.Id
                                 AND ObjectFloat_NPP.DescId = zc_ObjectFloat_Box_NPP()

           LEFT JOIN ObjectLink AS ObjectLink_Goods
                                ON ObjectLink_Goods.ObjectId = Object.Id
                               AND ObjectLink_Goods.DescId = zc_ObjectLink_Box_Goods()
           LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods.ChildObjectId
       WHERE Object.DescId = zc_Object_Box()
      UNION ALL
       SELECT 0 AS Id
            , 0 AS Code
            , 'УДАЛИТЬ' :: TVarChar AS Name

            , 0           AS GoodId
            , 0           AS GoodsCode
            , '' :: TVarChar AS GoodsName
            , 0 :: TFloat AS BoxVolume
            , 0 :: TFloat AS BoxWeight

            , 0 :: TFloat AS BoxHeight
            , 0 :: TFloat AS BoxLength
            , 0 :: TFloat AS BoxWidth
            , 0 :: TFloat AS NPP
            , FALSE       AS isErased
      ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 21.03.25         *
 18.02.25         *
 24.06.18         *
 09.10.14                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Box (zfCalc_UserAdmin())
