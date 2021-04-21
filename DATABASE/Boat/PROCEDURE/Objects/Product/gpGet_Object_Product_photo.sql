-- Function: gpGet_Object_Product_photo()

DROP FUNCTION IF EXISTS gpGet_Object_Product_photo (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Product_photo(
    IN inProductId          Integer,       -- Товар
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
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_Product());

       RETURN QUERY
       WITH tmpPhoto AS (SELECT ObjectLink_ProductPhoto_Product.ChildObjectId AS ProductId
                              , Object_ProductPhoto.Id                      AS PhotoId
                              , ROW_NUMBER() OVER (PARTITION BY ObjectLink_ProductPhoto_Product.ChildObjectId ORDER BY Object_ProductPhoto.Id) AS Ord
                         FROM Object AS Object_ProductPhoto
                              JOIN ObjectLink AS ObjectLink_ProductPhoto_Product
                                              ON ObjectLink_ProductPhoto_Product.ObjectId = Object_ProductPhoto.Id
                                             AND ObjectLink_ProductPhoto_Product.DescId   = zc_ObjectLink_ProductPhoto_Product()
                                             AND ObjectLink_ProductPhoto_Product.ChildObjectId = inProductId
                          WHERE Object_ProductPhoto.DescId   = zc_Object_ProductPhoto()
                            AND Object_ProductPhoto.isErased = FALSE
                        )

       SELECT Object_Product.Id                     AS Id
            , ObjectBlob_ProductPhoto_Data1.ValueData AS Image1
            , ObjectBlob_ProductPhoto_Data2.ValueData AS Image2
            , ObjectBlob_ProductPhoto_Data3.ValueData AS Image3

          /*  , ''  :: TBlob AS Image1
            , ''  :: TBlob AS Image2
            , ''  :: TBlob AS Image3
            */
       FROM Object AS Object_Product
            LEFT JOIN tmpPhoto AS tmpPhoto1
                               ON tmpPhoto1.ProductId = Object_Product.Id
                              AND tmpPhoto1.Ord = 1
            LEFT JOIN ObjectBLOB AS ObjectBlob_ProductPhoto_Data1
                                 ON ObjectBlob_ProductPhoto_Data1.ObjectId = tmpPhoto1.PhotoId

            LEFT JOIN tmpPhoto AS tmpPhoto2
                               ON tmpPhoto2.ProductId = Object_Product.Id
                              AND tmpPhoto2.Ord = 2
            LEFT JOIN ObjectBLOB AS ObjectBlob_ProductPhoto_Data2
                                 ON ObjectBlob_ProductPhoto_Data2.ObjectId = tmpPhoto2.PhotoId

            LEFT JOIN tmpPhoto AS tmpPhoto3
                               ON tmpPhoto3.ProductId = Object_Product.Id
                              AND tmpPhoto3.Ord = 3
            LEFT JOIN ObjectBLOB AS ObjectBlob_ProductPhoto_Data3
                                 ON ObjectBlob_ProductPhoto_Data3.ObjectId = tmpPhoto3.PhotoId
       WHERE Object_Product.DescId = zc_Object_Product()
         AND Object_Product.Id = inProductId;

END;
$BODY$
LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.12.20         *
*/

-- тест
-- SELECT * FROM gpGet_Object_Product_photo (1, '2')
