-- Function: gpGet_Object_Goods_photo()

DROP FUNCTION IF EXISTS gpGet_Object_Goods_photo (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Goods_photo(
    IN inGoodsId          Integer,       -- Товар 
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , Image1 TBlob, Image2 TBlob, Image3 TBlob
              )
AS
$BODY$
   DECLARE vbPriceListId Integer;
   DECLARE vbPriceListName TVarChar;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_Goods());
    
       RETURN QUERY 
       WITH tmpPhoto AS (SELECT ObjectLink_GoodsPhoto_Goods.ChildObjectId AS GoodsId
                              , Object_GoodsPhoto.Id                      AS PhotoId
                              , ROW_NUMBER() OVER (PARTITION BY ObjectLink_GoodsPhoto_Goods.ChildObjectId ORDER BY Object_GoodsPhoto.Id) AS Ord
                         FROM Object AS Object_GoodsPhoto
                              JOIN ObjectLink AS ObjectLink_GoodsPhoto_Goods
                                              ON ObjectLink_GoodsPhoto_Goods.ObjectId = Object_GoodsPhoto.Id
                                             AND ObjectLink_GoodsPhoto_Goods.DescId   = zc_ObjectLink_GoodsPhoto_Goods()
                                             AND ObjectLink_GoodsPhoto_Goods.ChildObjectId = inGoodsId
                          WHERE Object_GoodsPhoto.DescId   = zc_Object_GoodsPhoto()
                            AND Object_GoodsPhoto.isErased = FALSE
                        )

       SELECT Object_Goods.Id                     AS Id
--            , CASE WHEN Object_Goods.ObjectCode IN (3029, 3028, 7594) THEN ObjectBlob_GoodsPhoto_Data1.ValueData ELSE '' END :: TBlob AS Image1
--            , CASE WHEN Object_Goods.ObjectCode IN (3029, 3028, 7594) THEN ObjectBlob_GoodsPhoto_Data2.ValueData ELSE '' END :: TBlob  AS Image2
--            , CASE WHEN Object_Goods.ObjectCode IN (3029, 3028, 7594) THEN ObjectBlob_GoodsPhoto_Data3.ValueData ELSE '' END :: TBlob  AS Image3
           
            , ''  :: TBlob AS Image1
            , ''  :: TBlob AS Image2
            , ''  :: TBlob AS Image3
       FROM Object AS Object_Goods
            LEFT JOIN tmpPhoto AS tmpPhoto1
                               ON tmpPhoto1.GoodsId = Object_Goods.Id
                              AND tmpPhoto1.Ord = 1
            LEFT JOIN ObjectBLOB AS ObjectBlob_GoodsPhoto_Data1
                                 ON ObjectBlob_GoodsPhoto_Data1.ObjectId = tmpPhoto1.PhotoId

            LEFT JOIN tmpPhoto AS tmpPhoto2
                               ON tmpPhoto2.GoodsId = Object_Goods.Id
                              AND tmpPhoto2.Ord = 2
            LEFT JOIN ObjectBLOB AS ObjectBlob_GoodsPhoto_Data2
                                 ON ObjectBlob_GoodsPhoto_Data2.ObjectId = tmpPhoto2.PhotoId

            LEFT JOIN tmpPhoto AS tmpPhoto3
                               ON tmpPhoto3.GoodsId = Object_Goods.Id
                              AND tmpPhoto3.Ord = 3
            LEFT JOIN ObjectBLOB AS ObjectBlob_GoodsPhoto_Data3
                                 ON ObjectBlob_GoodsPhoto_Data3.ObjectId = tmpPhoto3.PhotoId                          
       WHERE Object_Goods.DescId = zc_Object_Goods()
         AND Object_Goods.Id = inGoodsId;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.12.20         *
*/

-- тест
-- SELECT * FROM gpGet_Object_Goods_photo (1, '2')