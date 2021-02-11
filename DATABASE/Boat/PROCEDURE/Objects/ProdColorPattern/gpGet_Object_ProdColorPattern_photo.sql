-- Function: gpGet_Object_ProdColorPattern_photo()

DROP FUNCTION IF EXISTS gpGet_Object_ProdColorPattern_photo (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ProdColorPattern_photo(
    IN inProdColorPatternId          Integer,       -- Товар
    IN inSession                     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , Image1 TBlob, Image2 TBlob, Image3 TBlob
              )
AS
$BODY$
   DECLARE vbPriceListId Integer;
   DECLARE vbPriceListName TVarChar;
   DECLARE vbGoodsId     Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_ProdColorPattern());

       vbGoodsId := (SELECT ObjectLink.ChildObjectId FROM ObjectLink WHERE ObjectLink.DescId = zc_ObjectLink_ProdColorPattern_Goods() AND ObjectLink.ObjectId = inProdColorPatternId);

       RETURN QUERY
       WITH tmpPhoto AS (SELECT inProdColorPatternId               AS ProdColorPatternId
                              , Object_ProdColorPatternPhoto.Id    AS PhotoId
                              , ROW_NUMBER() OVER ( ORDER BY Object_ProdColorPatternPhoto.Id) AS Ord
                         FROM Object AS Object_ProdColorPatternPhoto
                              JOIN ObjectLink AS ObjectLink_ProdColorPatternPhoto_ProdColorPattern
                                              ON ObjectLink_ProdColorPatternPhoto_ProdColorPattern.ObjectId = Object_ProdColorPatternPhoto.Id
                                             AND ObjectLink_ProdColorPatternPhoto_ProdColorPattern.DescId  IN ( zc_ObjectLink_ProdColorPatternPhoto_ProdColorPattern(), zc_ObjectLink_GoodsPhoto_Goods())
                                             AND ObjectLink_ProdColorPatternPhoto_ProdColorPattern.ChildObjectId IN (inProdColorPatternId, vbGoodsId)
                          WHERE Object_ProdColorPatternPhoto.DescId IN (zc_Object_ProdColorPatternPhoto(),zc_Object_GoodsPhoto())
                            AND Object_ProdColorPatternPhoto.isErased = FALSE
                        )


       SELECT Object_ProdColorPattern.Id                    AS Id
            , ObjectBlob_ProdColorPatternPhoto_Data1.ValueData AS Image1
            , ObjectBlob_ProdColorPatternPhoto_Data2.ValueData AS Image2
            , ObjectBlob_ProdColorPatternPhoto_Data3.ValueData AS Image3

          /*  , ''  :: TBlob AS Image1
            , ''  :: TBlob AS Image2
            , ''  :: TBlob AS Image3
            */
       FROM Object AS Object_ProdColorPattern
            LEFT JOIN tmpPhoto AS tmpPhoto1
                               ON tmpPhoto1.ProdColorPatternId = Object_ProdColorPattern.Id
                              AND tmpPhoto1.Ord = 1
            LEFT JOIN ObjectBLOB AS ObjectBlob_ProdColorPatternPhoto_Data1
                                 ON ObjectBlob_ProdColorPatternPhoto_Data1.ObjectId = tmpPhoto1.PhotoId

            LEFT JOIN tmpPhoto AS tmpPhoto2
                               ON tmpPhoto2.ProdColorPatternId = Object_ProdColorPattern.Id
                              AND tmpPhoto2.Ord = 2
            LEFT JOIN ObjectBLOB AS ObjectBlob_ProdColorPatternPhoto_Data2
                                 ON ObjectBlob_ProdColorPatternPhoto_Data2.ObjectId = tmpPhoto2.PhotoId

            LEFT JOIN tmpPhoto AS tmpPhoto3
                               ON tmpPhoto3.ProdColorPatternId = Object_ProdColorPattern.Id
                              AND tmpPhoto3.Ord = 3
            LEFT JOIN ObjectBLOB AS ObjectBlob_ProdColorPatternPhoto_Data3
                                 ON ObjectBlob_ProdColorPatternPhoto_Data3.ObjectId = tmpPhoto3.PhotoId
       WHERE Object_ProdColorPattern.DescId = zc_Object_ProdColorPattern()
         AND Object_ProdColorPattern.Id = inProdColorPatternId

    
       ;

END;
$BODY$
LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.02.20         *
*/

-- тест
-- SELECT * FROM gpGet_Object_ProdColorPattern_photo (1, '2')
--  select * from gpGet_Object_ProdColorPattern_photo(inProdColorPatternId := 2304 ,  inSession := '5');
