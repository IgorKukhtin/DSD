-- Function: gpSelect_Object_Product_StructurePrint ()

DROP FUNCTION IF EXISTS gpSelect_Object_Product_StructurePrint (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Product_StructurePrint(
    IN inProductId       Integer   ,   -- 
    IN inSession         TVarChar      -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     CREATE TEMP TABLE tmpProduct ON COMMIT DROP AS (SELECT tmp.*
                                                     FROM gpSelect_Object_Product (inIsShowAll:= FALSE, inIsSale:= FALSE, inSession:= inSession) AS tmp
                                                     WHERE tmp.Id = inProductId
                                                     );
     CREATE TEMP TABLE tmpProdColorItems ON COMMIT DROP AS (SELECT tmp.*
                                                            FROM gpSelect_Object_ProdColorItems (inIsShowAll:= FALSE, inIsErased:= FALSE, inIsSale:= FALSE, inSession:= inSession) AS tmp
                                                            WHERE tmp.ProductId = inProductId
                                                            );
     -- Результат
     OPEN Cursor1 FOR

       -- Результат
       SELECT tmpProduct.*
            , LEFT (tmpProduct.CIN, 8) ::TVarChar AS PatternCIN
            , EXTRACT (YEAR FROM tmpProduct.DateBegin)  ::TVarChar AS YearBegin
            , '' ::TVarChar AS ModelGroupName
            , ObjectFloat_Power.ValueData               ::TFloat   AS EnginePower
            , ObjectFloat_Volume.ValueData              ::TFloat   AS EngineVolume
            --
            , 'info@agilis-jettenders.com' ::TVarChar AS Mail
            , 'www.agilis-jettenders.com'  ::TVarChar AS WWW
            , 'Agilis Jettenders GmbH'     ::TVarChar AS Name_main
            , 'Lohfeld Str. 2'             ::TVarChar AS Street_main
            , '52428 Julich'               ::TVarChar AS City_main                                   --*
            , 'Adriatic Wave d.o.o'        ::TVarChar AS Name_Firma
            , 'Via Niccoloa Tommasea 11'   ::TVarChar AS Street_Firma
            , '52210 ROVINJ'               ::TVarChar AS City_Firma
            , 'KROATIEN'                   ::TVarChar AS Country_Firma
            , 'steuerfreie innergem. Lieferung gemab §4 Nr.1b i.V.m. §6a UStG' ::TVarChar AS Text1   --**
            , 'special discount'                    ::TVarChar AS Text2
            , 'Sie wurden beraten von M.Starchenko' ::TVarChar AS Text3
            
            , COALESCE (ObjectString_TaxNumber.ValueData,'') ::TVarChar AS TaxNumber
            , '' ::TVarChar AS Angebot
            , '' ::TVarChar AS Seite   
            
            , 'Agilis Jettenders GmbH'||Chr(13)||Chr(10)||'Lohfeld Str.2'||Chr(13)||Chr(10)||'52428 Julich' ::TVarChar AS Footer1              --*
            , 'Bankverbindung'||Chr(13)||Chr(10)||'Aachener Bank eG'||Chr(13)||Chr(10)||'IBAN: DE56390601800154560009'||Chr(13)||Chr(10)||'BIC: GENODED1AAC' ::TVarChar AS Footer2
            , 'Geschaftsfuhrer:Starchenko Maxym'||Chr(13)||Chr(10)||Chr(13)||Chr(10)||'Amtsgericht Duren HRB 8163'||Chr(13)||Chr(10)||'Ust.-ID: DE326730388' ::TVarChar AS Footer3   --***
            , 'Tel: +49 (0)2461 340 333-15'||Chr(13)||Chr(10)||'Fax: +49 (0)2461 340 333 13'||Chr(13)||Chr(10)||'Email: info@agilis-jettenders.com'||Chr(13)||Chr(10)||'WEB: www.agilis-jettenders.com' ::TVarChar AS Footer4

       FROM tmpProduct
          LEFT JOIN ObjectFloat AS ObjectFloat_Power
                                ON ObjectFloat_Power.ObjectId = tmpProduct.EngineId
                               AND ObjectFloat_Power.DescId = zc_ObjectFloat_ProdEngine_Power()
          LEFT JOIN ObjectFloat AS ObjectFloat_Volume
                                ON ObjectFloat_Volume.ObjectId = tmpProduct.EngineId
                               AND ObjectFloat_Volume.DescId = zc_ObjectFloat_ProdEngine_Volume()
          LEFT JOIN ObjectString AS ObjectString_TaxNumber
                                 ON ObjectString_TaxNumber.ObjectId = tmpProduct.ClientId
                                AND ObjectString_TaxNumber.DescId = zc_ObjectString_Client_TaxNumber()
       ;

     RETURN NEXT Cursor1;

     OPEN Cursor2 FOR
       WITH
       tmpPhoto AS (SELECT ObjectLink_GoodsPhoto_Goods.ChildObjectId AS GoodsId
                         , Object_GoodsPhoto.Id                      AS PhotoId
                         , Object_GoodsPhoto.ValueData               AS FileName
                         , ROW_NUMBER() OVER (PARTITION BY ObjectLink_GoodsPhoto_Goods.ChildObjectId ORDER BY Object_GoodsPhoto.Id) AS Ord
                    FROM Object AS Object_GoodsPhoto
                           JOIN ObjectLink AS ObjectLink_GoodsPhoto_Goods
                                           ON ObjectLink_GoodsPhoto_Goods.ObjectId = Object_GoodsPhoto.Id
                                          AND ObjectLink_GoodsPhoto_Goods.DescId   = zc_ObjectLink_GoodsPhoto_Goods()
                                          AND ObjectLink_GoodsPhoto_Goods.ChildObjectId IN (SELECT DISTINCT tmpProdColorItems.GoodsId FROM tmpProdColorItems)
                     WHERE Object_GoodsPhoto.DescId   = zc_Object_GoodsPhoto()
                       AND Object_GoodsPhoto.isErased = FALSE
                   )


       -- Результат
       SELECT tmpProdColorItems.*
            , ObjectBlob_GoodsPhoto_Data1.ValueData AS Photo1
            , tmpPhoto1.FileName AS FileName1
       FROM tmpProdColorItems
            LEFT JOIN tmpPhoto AS tmpPhoto1
                               ON tmpPhoto1.GoodsId = tmpProdColorItems.GoodsId
                              AND tmpPhoto1.Ord = 1
            LEFT JOIN ObjectBLOB AS ObjectBlob_GoodsPhoto_Data1
                                 ON ObjectBlob_GoodsPhoto_Data1.ObjectId = tmpPhoto1.PhotoId
    
/*            LEFT JOIN tmpPhoto AS tmpPhoto2
                               ON tmpPhoto2.GoodsId = tmpProdColorItems.GoodsId
                              AND tmpPhoto2.Ord = 2
            LEFT JOIN ObjectBLOB AS ObjectBlob_GoodsPhoto_Data2
                                 ON ObjectBlob_GoodsPhoto_Data2.ObjectId = tmpPhoto2.PhotoId
    
            LEFT JOIN tmpPhoto AS tmpPhoto3
                               ON tmpPhoto3.GoodsId = tmpProdColorItems.GoodsId
                              AND tmpPhoto3.Ord = 3
            LEFT JOIN ObjectBLOB AS ObjectBlob_GoodsPhoto_Data3
                                 ON ObjectBlob_GoodsPhoto_Data3.ObjectId = tmpPhoto3.PhotoId
                                 */
       ;

     RETURN NEXT Cursor2;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.02.21          *
*/

-- тест
--