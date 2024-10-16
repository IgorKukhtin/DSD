-- Function: gpSelect_Object_Product_OfferPrint ()

DROP FUNCTION IF EXISTS gpSelect_Object_Product_AgilisPrint (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_Product_OfferPrint (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Product_OfferPrint(
    IN inMovementId_OrderClient       Integer   ,   --
    IN inSession                      TVarChar      -- ������ ������������
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
            vbDiscountNextTax TFloat;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);

     -- ������ �� ��������� ������
     SELECT MovementBoolean_PriceWithVAT.ValueData  AS PriceWithVAT
          , MovementFloat_VATPercent.ValueData      AS VATPercent
          , (COALESCE (MovementFloat_DiscountTax.ValueData,0))   AS DiscountTax  -- ��������  + ������������� ������ 
          , COALESCE (MovementFloat_DiscountNextTax.ValueData,0) AS DiscountNextTax 
          , Movement_OrderClient.OperDate
          , Movement_OrderClient.InvNumber
          , Object_Member.ValueData  AS InsertName
     INTO
         vbPriceWithVAT
       , vbVATPercent
       , vbDiscountTax
       , vbDiscountNextTax
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
         LEFT JOIN MovementFloat AS MovementFloat_DiscountNextTax
                                 ON MovementFloat_DiscountNextTax.MovementId = Movement_OrderClient.Id
                                AND MovementFloat_DiscountNextTax.DescId = zc_MovementFloat_DiscountNextTax()
         LEFT JOIN MovementLinkObject AS MLO_Insert
                                      ON MLO_Insert.MovementId = Movement_OrderClient.Id
                                     AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
         --LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId

         LEFT JOIN ObjectLink AS ObjectLink_User_Member
                              ON ObjectLink_User_Member.ObjectId = MLO_Insert.ObjectId
                             AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
         LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_User_Member.ChildObjectId
     WHERE Movement_OrderClient.Id = inMovementId_OrderClient
       AND Movement_OrderClient.DescId = zc_Movement_OrderClient();

     -- ������ �� ��������� ������
     CREATE TEMP TABLE tmpOrderClient ON COMMIT DROP AS (SELECT MovementItem.ObjectId       AS GoodsId
                                                              , Object_Goods.DescId         AS GoodsDesc
                                                              , Object_Goods.ValueData      AS GoodsName
                                                              , MovementItem.Amount         AS Amount
                                                              --, MIFloat_OperPrice.ValueData AS OperPrice
                                                              , CASE WHEN vbPriceWithVAT THEN MIFloat_OperPrice.ValueData
                                                                                         ELSE zfCalc_SummWVAT (MIFloat_OperPrice.ValueData, vbVATPercent)
                                                                END  ::TFloat AS OperPriceWithVAT
                                                              , CASE WHEN vbPriceWithVAT THEN zfCalc_Summ_NoVAT (MIFloat_OperPrice.ValueData, vbVATPercent)
                                                                                         ELSE MIFloat_OperPrice.ValueData
                                                                END  ::TFloat AS OperPrice               -- ��� ���
                                                              , COALESCE (MIFloat_BasisPrice.ValueData,0) AS BasisPrice
                                                         FROM MovementItem
                                                              LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
                                                              LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                                                                          ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                                                                         AND MIFloat_OperPrice.DescId = zc_MIFloat_OperPrice()
                                                              LEFT JOIN MovementItemFloat AS MIFloat_BasisPrice
                                                                                          ON MIFloat_BasisPrice.MovementItemId = MovementItem.Id
                                                                                         AND MIFloat_BasisPrice.DescId = zc_MIFloat_BasisPrice()
                                                         WHERE MovementItem.MovementId = inMovementId_OrderClient
                                                           AND MovementItem.DescId     = zc_MI_Master()
                                                           AND MovementItem.isErased   = FALSE
                                                         );

     --���� ����� � �������� ����� ���������, ���� ������������, ������ ������� �����, �����. ����� �������� ��� ����� �� ���
     SELECT tmpOrderClient.GoodsId
    INTO vbProductId
     FROM tmpOrderClient
     WHERE tmpOrderClient.GoodsDesc = zc_Object_Product()
     LIMIT 1;

     -- ������ �� ����e
     CREATE TEMP TABLE tmpProduct ON COMMIT DROP AS (SELECT tmp.*
                                                     FROM gpSelect_Object_Product (inMovementId_OrderClient:= inMovementId_OrderClient, inIsShowAll:= FALSE, inIsSale:= FALSE, inSession:= inSession) AS tmp
                                                     WHERE tmp.Id = vbProductId
                                                       AND tmp.MovementId_OrderClient = inMovementId_OrderClient
                                                     );
     -- ����� ������ �� ������
     CREATE TEMP TABLE tmpProdOptItems ON COMMIT DROP AS (SELECT tmp.*
                                                          FROM gpSelect_Object_ProdOptItems (inMovementId_OrderClient:= inMovementId_OrderClient, inIsShowAll:= FALSE, inIsErased:= FALSE, inIsSale:= FALSE, inSession:= inSession) AS tmp
                                                          WHERE tmp.ProductId = vbProductId
                                                            AND tmp.MovementId_OrderClient = inMovementId_OrderClient
                                                         );

     -- ����� ����������
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



     -- ���������
     OPEN Cursor1 FOR
      WITH
      tmpProdOptItems_Tax AS (SELECT SUM (CASE WHEN COALESCE (tmpProdOptItems.DiscountTax,0) <> 0 THEN zfCalc_SummDiscountTax (tmpProdOptItems.Sale_summ, COALESCE (tmpProdOptItems.DiscountTax,0)) 
                                                ELSE zfCalc_SummDiscountTax (zfCalc_SummDiscountTax (tmpProdOptItems.Sale_summ, COALESCE (vbDiscountTax,0)), COALESCE (vbDiscountNextTax,0) ) 
                                          END
                                          ) AS Sale_summ_OptItems
                                   , SUM (CASE WHEN COALESCE (tmpProdOptItems.DiscountTax,0) <> 0 THEN zfCalc_SummDiscountTax (tmpProdOptItems.SaleWVAT_summ, COALESCE (tmpProdOptItems.DiscountTax,0))
                                               ELSE  zfCalc_SummDiscountTax (zfCalc_SummDiscountTax (tmpProdOptItems.SaleWVAT_summ, COALESCE (vbDiscountTax,0)), COALESCE (vbDiscountNextTax,0) )   
                                          END
                                          ) AS SaleWVAT_summ_OptItems
                              FROM tmpProdOptItems
                              )
       -- ���������
       SELECT tmpProduct.*
            , zfCalc_InvNumber_print (tmpProduct.InvNumber_OrderClient :: TVarChar) AS InvNumber_OrderClient_str
            , tmpProduct.BasisWVAT_summ_transport AS BasisWVAT_summ
            , (COALESCE (tmpProduct.BasisWVAT_summ_transport, 0)) AS Summ_total
            ,  COALESCE (tmpOrder.SaleWVAT_summ,0) :: TFloat AS SaleWVAT_summ_order
            , tmpProduct.CIN        ::TVarChar AS PatternCIN
            , EXTRACT (YEAR FROM tmpProduct.DateBegin)  ::TVarChar AS YearBegin
            , '' ::TVarChar AS ModelGroupName
            , ObjectFloat_Power.ValueData               ::TFloat   AS EnginePower
            , ObjectFloat_Volume.ValueData              ::TFloat   AS EngineVolume
            --
            , tmpInfo.Mail          ::TVarChar AS Mail
            , tmpInfo.WWW           ::TVarChar AS WWW
            , tmpInfo.Name_main     ::TVarChar AS Name_main
            , tmpInfo.Street_main   ::TVarChar AS Street_main
            , tmpInfo.City_main     ::TVarChar AS City_main                                   --*
            , tmpInfo.Name_Firma    ::TVarChar AS Name_Firma
            , tmpInfo.Street_Firma  ::TVarChar AS Street_Firma
            , tmpInfo.City_Firma    ::TVarChar AS City_Firma
            , tmpInfo.Country_Firma ::TVarChar AS Country_Firma
            , tmpInfo.Text_tax      ::TVarChar AS Text1   --**
            , tmpInfo.Text_discount ::TVarChar AS Text2
            , (' '||tmpInfo.Text_sign ||' '||vbInsertName::TVarChar)     ::TVarChar AS Text3
            --
            , tmpProduct.ClientName                       ::TVarChar AS Name_Client
            , COALESCE (ObjectString_Street.ValueData,'') ::TVarChar AS Street_Client
            , ObjectString_City.ValueData                 ::TVarChar AS City_Client
            , Object_Country.ValueData                    ::TVarChar AS Country_Client
            --

           , CASE WHEN ObjectLink_TaxKind.ChildObjectId = zc_Enum_TaxKind_Basis() THEN '<b>USt-IdNr.:</b> ' || COALESCE (ObjectString_TaxNumber.ValueData,'') ELSE '' END ::TVarChar AS TaxNumber
            , '' ::TVarChar AS Angebot
            , '' ::TVarChar AS Seite

            , tmpInfo.Footer1       ::TVarChar AS Footer1              --*
            , tmpInfo.Footer2       ::TVarChar AS Footer2
            , tmpInfo.Footer3       ::TVarChar AS Footer3   --***
            , tmpInfo.Footer4       ::TVarChar AS Footer4

            , vbOperDate_OrderClient  AS OperDate_Order
            , vbInvNumber_OrderClient AS InvNumber_Order

            , tmp_OrderInfo.Text_Info1 :: TBlob AS Text_Info1
            , tmp_OrderInfo.Text_Info2 :: TBlob AS Text_Info2
            , tmp_OrderInfo.Text_Info3 :: TBlob AS Text_Info3  
            
             --
            , tmpProdOptItems.Sale_summ_OptItems     ::TFloat
            , tmpProdOptItems.SaleWVAT_summ_OptItems ::TFloat
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

          LEFT JOIN (SELECT SUM (tmp.Amount * tmp.OperPriceWithVAT) AS SaleWVAT_summ FROM tmpOrderClient AS tmp WHERE tmp.GoodsDesc <> zc_Object_Product()) AS tmpOrder ON 1 = 1

          LEFT JOIN Object_Product_PrintInfo_View AS tmpInfo ON 1=1
          LEFT JOIN tmp_OrderInfo ON 1=1
          --
          LEFT JOIN ObjectString AS ObjectString_Street
                                 ON ObjectString_Street.ObjectId = tmpProduct.ClientId
                                AND ObjectString_Street.DescId = zc_ObjectString_Client_Street()
          LEFT JOIN ObjectLink AS ObjectLink_PLZ
                               ON ObjectLink_PLZ.ObjectId = tmpProduct.ClientId
                              AND ObjectLink_PLZ.DescId = zc_ObjectLink_Client_PLZ()
          --LEFT JOIN Object AS Object_PLZ ON Object_PLZ.Id = ObjectLink_PLZ.ChildObjectId
          LEFT JOIN ObjectString AS ObjectString_City
                                 ON ObjectString_City.ObjectId = ObjectLink_PLZ.ChildObjectId
                                AND ObjectString_City.DescId = zc_ObjectString_PLZ_City()
          LEFT JOIN ObjectLink AS ObjectLink_Country
                               ON ObjectLink_Country.ObjectId = ObjectLink_PLZ.ChildObjectId
                              AND ObjectLink_Country.DescId = zc_ObjectLink_PLZ_Country()
          LEFT JOIN Object AS Object_Country ON Object_Country.Id = ObjectLink_Country.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_TaxKind
                               ON ObjectLink_TaxKind.ObjectId = tmpProduct.ClientId
                              AND ObjectLink_TaxKind.DescId   = zc_ObjectLink_Client_TaxKind()

          LEFT JOIN tmpProdOptItems_Tax AS tmpProdOptItems ON 1=1
       ;

     RETURN NEXT Cursor1;

     OPEN Cursor2 FOR

       -- ���������
       SELECT tmpProdOptItems.ProdOptionsName AS GoodsName
            , tmpProdOptItems.Article
            , tmpProdOptItems.ProdColorName
            , COALESCE (tmpProdOptItems.Amount,1) AS Amount
            , tmpProdOptItems.SalePrice                       -- ���� ������� ��� ���
            --, tmpProdOptItems.DiscountTax                     -- ������ 
            , CASE WHEN COALESCE (tmpProdOptItems.DiscountTax,0) <> 0 THEN tmpProdOptItems.DiscountTax ELSE COALESCE (vbDiscountTax,0) END AS DiscountTax
            , CASE WHEN COALESCE (tmpProdOptItems.DiscountTax,0) <> 0 THEN 0 ELSE COALESCE (vbDiscountNextTax,0) END ::TFloat AS DiscountNextTax
            --, zfCalc_SummDiscountTax (tmpProdOptItems.Sale_summ, COALESCE (tmpProdOptItems.DiscountTax,0)) ::TFloat AS Sale_summ  -- ����� ������� ��� ��� �� ������� 
            , CASE WHEN COALESCE (tmpProdOptItems.DiscountTax,0) <> 0 THEN zfCalc_SummDiscountTax (tmpProdOptItems.Amount * tmpProdOptItems.SalePrice, COALESCE (tmpProdOptItems.DiscountTax,0)) 
                   ELSE zfCalc_SummDiscountTax (tmpProdOptItems.Amount * tmpProdOptItems.SalePrice, COALESCE (vbDiscountTax,0) )
              END  ::TFloat AS Sale_summ  -- ����� ������� ��� ��� �� �������
            , CASE WHEN COALESCE (tmpProdOptItems.DiscountTax,0) <> 0 THEN zfCalc_SummDiscountTax (tmpProdOptItems.Amount * tmpProdOptItems.SalePrice, COALESCE (tmpProdOptItems.DiscountTax,0)) 
                   ELSE zfCalc_SummDiscountTax (zfCalc_SummDiscountTax (tmpProdOptItems.Amount * tmpProdOptItems.SalePrice, COALESCE (vbDiscountTax,0) ), vbDiscountNextTax)
              END  ::TFloat AS Sale_summ_tax  -- ����� ������� ��� ��� �� ������� � � ��� �������
            , tmpProdOptItems.NPP   :: Integer  AS NPP 
       FROM tmpProdOptItems
     UNION
       SELECT tmp.GoodsName                         AS GoodsName
            , ObjectString_Article.ValueData        AS Article
            , Object_ProdColor.ValueData            AS ProdColorName
            , tmp.Amount                   ::TFloat AS Amount
            , tmp.OperPrice                ::TFloat AS SalePrice
            , vbDiscountTax                ::TFloat AS DiscountTax 
            , vbDiscountNextTax            ::TFloat AS DiscountNextTax
            , zfCalc_SummDiscountTax (zfCalc_SummDiscountTax (tmp.Amount * tmp.OperPrice, COALESCE (vbDiscountTax,0)) , vbDiscountNextTax) ::TFloat AS Sale_summ
            , zfCalc_SummDiscountTax (zfCalc_SummDiscountTax (tmp.Amount * tmp.OperPrice, COALESCE (vbDiscountTax,0)) , vbDiscountNextTax) ::TFloat AS Sale_summ_OptItems
            , ROW_NUMBER() OVER (ORDER BY tmp.GoodsName) :: Integer  AS NPP
       FROM tmpOrderClient AS tmp
            LEFT JOIN ObjectString AS ObjectString_Article
                                   ON ObjectString_Article.ObjectId = tmp.GoodsId
                                  AND ObjectString_Article.DescId = zc_ObjectString_Article()
            LEFT JOIN ObjectLink AS ObjectLink_Goods_ProdColor
                                 ON ObjectLink_Goods_ProdColor.ObjectId = tmp.GoodsId
                                AND ObjectLink_Goods_ProdColor.DescId = zc_ObjectLink_Goods_ProdColor()
            LEFT JOIN Object AS Object_ProdColor ON Object_ProdColor.Id = ObjectLink_Goods_ProdColor.ChildObjectId
       WHERE tmp.GoodsDesc <> zc_Object_Product()
        UNION
       SELECT '' :: TVarChar AS GoodsName
            , '' :: TVarChar AS Article
            , '' :: TVarChar AS ProdColorName
            , 0  :: TFloat   AS Amount
            , 0  :: TFloat   AS SalePrice
            , 0  :: TFloat   AS DiscountTax
            , 0  :: TFloat   AS DiscountNextTax
            , 0  :: TFloat   AS Sale_summ
            , 0  :: TFloat   AS Sale_summ_tax
            , 999 :: Integer AS NPP
       ;

     RETURN NEXT Cursor2;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 25.04.24          *
 10.02.21          *
*/

-- ����
-- SELECT * FROM gpSelect_Object_Product_OfferPrint (inMovementId_OrderClient:= 662, inSession:= zfCalc_UserAdmin())
