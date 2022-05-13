-- Function: gpSelect_Object_Product_StructurePrint ()

DROP FUNCTION IF EXISTS gpSelect_Object_Product_StructurePrint (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Product_StructurePrint(
    IN inMovementId_OrderClient       Integer   ,   -- 
    IN inSession                      TVarChar      -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;

    DECLARE vbProductId    Integer;
    DECLARE vbOperDate_OrderClient   TDateTime;
    DECLARE vbInvNumber_OrderClient  TVarChar;
    DECLARE vbInsertName TVarChar;
    DECLARE vbPriceWithVAT Boolean;
    DECLARE vbVATPercent   TFloat;
    DECLARE vbDiscountTax  TFloat;  
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     SELECT MovementBoolean_PriceWithVAT.ValueData  AS PriceWithVAT
          , MovementFloat_VATPercent.ValueData      AS VATPercent
          , MovementFloat_DiscountTax.ValueData     AS DiscountTax
          , Movement_OrderClient.OperDate
          , Movement_OrderClient.InvNumber
          , Object_Member.ValueData  AS InsertName
     INTO
         vbPriceWithVAT
       , vbVATPercent
       , vbDiscountTax
       , vbOperDate_OrderClient
       , vbInvNumber_OrderClient
       , vbInsertName
     FROM Movement AS Movement_OrderClient
         LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                   ON MovementBoolean_PriceWithVAT.MovementId = Movement_OrderClient.Id
                                  AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
         LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                 ON MovementFloat_VATPercent.MovementId = Movement_OrderClient.Id
                                AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
         LEFT JOIN MovementFloat AS MovementFloat_DiscountTax
                                 ON MovementFloat_DiscountTax.MovementId = Movement_OrderClient.Id
                                AND MovementFloat_DiscountTax.DescId = zc_MovementFloat_DiscountTax()
         LEFT JOIN MovementLinkObject AS MLO_Insert
                                      ON MLO_Insert.MovementId = Movement_OrderClient.Id
                                     AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
         --LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId

         LEFT JOIN ObjectLink AS ObjectLink_User_Member
                              ON ObjectLink_User_Member.ObjectId = MLO_Insert.ObjectId
                             AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
         LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_User_Member.ChildObjectId 
     WHERE Movement_OrderClient.Id = inMovementId_OrderClient  -- по идее должен быть один док. заказа, но малоли
       AND Movement_OrderClient.DescId = zc_Movement_OrderClient();

     -- данные из документа заказа
     CREATE TEMP TABLE tmpOrderClient ON COMMIT DROP AS (SELECT MovementItem.ObjectId       AS GoodsId
                                                              , Object_Goods.DescId         AS GoodsDesc
                                                              , Object_Goods.ValueData      AS GoodsName
                                                              , MovementItem.Amount         AS Amount
                                                              , MIFloat_OperPrice.ValueData AS OperPrice
                                                              , CASE WHEN vbPriceWithVAT THEN MIFloat_OperPrice.ValueData
                                                                                         ELSE (MIFloat_OperPrice.ValueData * (1 + vbVATPercent/100))::TFloat
                                                                END AS OperPriceWithVAT
                                                         FROM MovementItem
                                                              LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
                                                              LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                                                                          ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                                                                         AND MIFloat_OperPrice.DescId = zc_MIFloat_OperPrice()
                                                         WHERE MovementItem.MovementId = inMovementId_OrderClient
                                                           AND MovementItem.DescId     = zc_MI_Master()
                                                           AND MovementItem.isErased   = FALSE
                                                         );

     --ищем лодку в строчной части документа, если присутствует, значит продаем лодку, соотв. нужно показать все опции по ней
     SELECT tmpOrderClient.GoodsId
    INTO vbProductId
     FROM tmpOrderClient
     WHERE tmpOrderClient.GoodsDesc = zc_Object_Product()
     LIMIT 1;
     
 
     CREATE TEMP TABLE tmpProduct ON COMMIT DROP AS (SELECT tmp.*
                                                     FROM gpSelect_Object_Product (inIsShowAll:= TRUE, inIsSale:= FALSE, inSession:= inSession) AS tmp
                                                     WHERE tmp.Id = vbProductId
                                                       AND tmp.MovementId_OrderClient = inMovementId_OrderClient
                                                     );
     CREATE TEMP TABLE tmpProdColorItems ON COMMIT DROP AS (SELECT tmp.*
                                                            FROM gpSelect_Object_ProdColorItems (inMovementId_OrderClient:= inMovementId_OrderClient, inIsShowAll:= TRUE, inIsErased:= FALSE, inIsSale:= FALSE, inSession:= inSession) AS tmp
                                                            WHERE tmp.ProductId = vbProductId
                                                              AND tmp.MovementId_OrderClient = inMovementId_OrderClient
                                                            );

     -- выбор Примечаний
     CREATE TEMP TABLE tmp_OrderInfo ON COMMIT DROP AS (SELECT CASE WHEN TRIM (COALESCE (MovementBlob_Info1.ValueData,'')) = '' THEN CHR (13) || CHR (13) || CHR (13) ELSE MovementBlob_Info1.ValueData END :: TBlob AS Text_Info1
                                                          , CASE WHEN TRIM (COALESCE (MovementBlob_Info2.ValueData,'')) = '' THEN CHR (13) || CHR (13) || CHR (13) ELSE MovementBlob_Info2.ValueData END :: TBlob AS Text_Info2
                                                          , CASE WHEN TRIM (COALESCE (MovementBlob_Info3.ValueData,'')) = '' THEN CHR (13) || CHR (13) || CHR (13) ELSE MovementBlob_Info3.ValueData END :: TBlob AS Text_Info3
                                                        FROM Movement AS Movement_OrderClient 
                                                            LEFT JOIN MovementBlob AS MovementBlob_Info1
                                                                                   ON MovementBlob_Info1.MovementId = Movement_OrderClient.Id
                                                                                  AND MovementBlob_Info1.DescId = zc_MovementBlob_Info1()
                                                            LEFT JOIN MovementBlob AS MovementBlob_Info2
                                                                                   ON MovementBlob_Info2.MovementId = Movement_OrderClient.Id
                                                                                  AND MovementBlob_Info2.DescId = zc_MovementBlob_Info2()
                                                            LEFT JOIN MovementBlob AS MovementBlob_Info3
                                                                                   ON MovementBlob_Info3.MovementId = Movement_OrderClient.Id
                                                                                  AND MovementBlob_Info3.DescId = zc_MovementBlob_Info3()
                                                        WHERE Movement_OrderClient.Id = inMovementId_OrderClient
                                                          AND Movement_OrderClient.DescId = zc_Movement_OrderClient()
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
            , tmpInfo.Mail           ::TVarChar AS Mail
            , tmpInfo.WWW            ::TVarChar AS WWW
            , tmpInfo.Name_main      ::TVarChar AS Name_main
            , tmpInfo.Street_main    ::TVarChar AS Street_main
            , tmpInfo.City_main      ::TVarChar AS City_main                                   --*
                                  --*
            , tmpInfo.Name_Firma2    ::TVarChar AS Name_Firma
            , tmpInfo.Street_Firma2  ::TVarChar AS Street_Firma
            , tmpInfo.City_Firma2    ::TVarChar AS City_Firma
            , tmpInfo.Country_Firma2 ::TVarChar AS Country_Firma
            , tmpInfo.Text_tax       ::TVarChar AS Text1   --**
            , tmpInfo.Text_discount  ::TVarChar AS Text2
            , (tmpInfo.Text_sign||' '||vbInsertName) ::TVarChar AS Text3

            , COALESCE (ObjectString_TaxNumber.ValueData,'') ::TVarChar AS TaxNumber
            
            , tmpInfo.Footer1        ::TVarChar AS Footer1              --*
            , tmpInfo.Footer2        ::TVarChar AS Footer2
            , tmpInfo.Footer3        ::TVarChar AS Footer3              --***
            , tmpInfo.Footer4        ::TVarChar AS Footer4

            , tmp_OrderInfo.Text_Info1 :: TBlob AS Text_Info1
            , tmp_OrderInfo.Text_Info2 :: TBlob AS Text_Info2
            , tmp_OrderInfo.Text_Info3 :: TBlob AS Text_Info3

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
          LEFT JOIN Object_Product_PrintInfo_View AS tmpInfo ON 1=1
          LEFT JOIN tmp_OrderInfo ON 1=1
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
                                          AND ObjectLink_GoodsPhoto_Goods.ChildObjectId IN (SELECT DISTINCT tmpProdColorItems.GoodsId FROM tmpProdColorItems
                                                                                        --UNION SELECT DISTINCT tmpOrderClient.GoodsId FROM tmpOrderClient
                                                                                            )
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