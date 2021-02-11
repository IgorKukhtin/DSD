-- Function: gpSelect_Object_Product_AgilisPrint ()

DROP FUNCTION IF EXISTS gpSelect_Object_Product_AgilisPrint (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Product_AgilisPrint(
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
     CREATE TEMP TABLE tmpProdOptItems ON COMMIT DROP AS (SELECT tmp.*
                                                     FROM gpSelect_Object_ProdOptItems (inIsShowAll:= FALSE, inIsErased:= FALSE, inIsSale:= FALSE, inSession:= inSession) AS tmp
                                                     WHERE tmp.ProductId = inProductId
                                                     );
     -- Результат
     OPEN Cursor1 FOR

       -- Результат
       SELECT tmpProduct.*
            , LEFT (tmpProduct.CIN, 8) ::TVarChar AS PatternCIN
            , EXTRACT (YEAR FROM tmpProduct.DateBegin)  ::TVarChar AS YearBegin
            , '' ::TVarChar AS ModelGroupName
            , ObjectFloat_Power.ValueData                          AS EnginePower
            , 0                                           ::TFloat AS EngineVolume
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
            , 'special discount' ::TVarChar AS Text2
            , 'Agilis Jettenders GmbH'||Chr(13)||Chr(10)||'Lohfeld Str.2'||Chr(13)||Chr(10)||' 52428 Julich' ::TVarChar AS Footer1              --*
            , 'Bankverbindung'||Chr(13)||Chr(10)||'Aachener Bank eG'||Chr(13)||Chr(10)||'IBAN: DE56390601800154560009'||Chr(13)||Chr(10)||'BIC: GENODED1AAC' ::TVarChar AS Footer2
            , 'Geschaftsfuhrer:Starchenko Maxym'||Chr(13)||Chr(10)||Chr(13)||Chr(10)||'Amtsgericht Duren HRB 8163'||Chr(13)||Chr(10)||'Ust.-ID: DE326730388' ::TVarChar AS Footer3   --***
            , 'Tel: +49 (0)2461 340 333-15'||Chr(13)||Chr(10)||'Fax: +49 (0)2461 340 333 13'||Chr(13)||Chr(10)||'Email: info@agilis-jettenders.com'||Chr(13)||Chr(10)||'WEB: www.agilis-jettenders.com' ::TVarChar AS Footer4

       FROM tmpProduct
          LEFT JOIN ObjectFloat AS ObjectFloat_Power
                                ON ObjectFloat_Power.ObjectId = tmpProduct.EngineId
                               AND ObjectFloat_Power.DescId = zc_ObjectFloat_ProdEngine_Power()
       ;

     RETURN NEXT Cursor1;

     OPEN Cursor2 FOR

       -- Результат
       SELECT *
       FROM tmpProdOptItems
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