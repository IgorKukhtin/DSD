-- Function: gpSelect_Object_Product_OrderConfirmationPrint ()

DROP FUNCTION IF EXISTS gpSelect_Object_Product_TendersPrint (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_Product_OrderConfirmationPrint (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Product_OrderConfirmationPrint(
    IN inMovementId_OrderClient       Integer   ,   --        Integer   ,   -- 
    IN inSession                      TVarChar      -- ������ ������������
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;
    DECLARE Cursor3 refcursor;
    
    DECLARE vbProductId    Integer;
    DECLARE vbOperDate_OrderClient   TDateTime;
    DECLARE vbInvNumber_OrderClient  TVarChar;
    DECLARE vbInsertName TVarChar;
    DECLARE vbPriceWithVAT Boolean;
    DECLARE vbVATPercent   TFloat;
    DECLARE vbDiscountTax  TFloat; 
    DECLARE vbDiscountNextTax TFloat;   

BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);

     -- ������ �� ��������� ������
     SELECT MovementBoolean_PriceWithVAT.ValueData  AS PriceWithVAT
          , MovementFloat_VATPercent.ValueData      AS VATPercent
          , MovementFloat_DiscountTax.ValueData     AS DiscountTax 
          , MovementFloat_DiscountNextTax.ValueData AS DiscountNextTax
          , Movement_OrderClient.OperDate
          , Movement_OrderClient.InvNumber
          , Object_Member.ValueData  AS InsertNamer
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
     WHERE Movement_OrderClient.Id = inMovementId_OrderClient  -- �� ���� ������ ���� ���� ���. ������, �� ������
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
                                                         FROM MovementItem
                                                              LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
                                                              LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                                                                          ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                                                                         AND MIFloat_OperPrice.DescId = zc_MIFloat_OperPrice()
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
                                                     FROM gpSelect_Object_Product (inMovementId_OrderClient:= inMovementId_OrderClient, inIsShowAll:= TRUE, inIsSale:= FALSE, inSession:= inSession) AS tmp
                                                     WHERE tmp.Id = vbProductId
                                                       AND tmp.MovementId_OrderClient = inMovementId_OrderClient
                                                     );
     -- ����� ������ �� ������
     CREATE TEMP TABLE tmpProdOptItems ON COMMIT DROP AS (SELECT tmp.*
                                                          FROM gpSelect_Object_ProdOptItems (inMovementId_OrderClient:= inMovementId_OrderClient, inIsShowAll:= FALSE, inIsErased:= FALSE, inIsSale:= FALSE, inSession:= inSession) AS tmp
                                                          WHERE tmp.ProductId = vbProductId
                                                            AND tmp.MovementId_OrderClient = inMovementId_OrderClient
                                                          );
     -- ����� ������ �� �����
     CREATE TEMP TABLE tmpProdColorItems ON COMMIT DROP AS (SELECT tmp.*
                                                            FROM gpSelect_Object_ProdColorItems (inMovementId_OrderClient:= inMovementId_OrderClient, inIsShowAll:= FALSE, inIsErased:= FALSE, inIsSale:= FALSE, inSession:= inSession) AS tmp
                                                            WHERE tmp.ProductId = vbProductId
                                                              AND COALESCE (tmp.Amount,0) <> 0
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
   -- ������ ���� ��� ����
     tmpInvoice AS (SELECT Movement.Id                             AS MovementId_Invoice
                         , SUM (CASE WHEN MovementFloat_Amount.ValueData > 0 THEN  1 * MovementFloat_Amount.ValueData ELSE 0 END) ::TFloat AS AmountIn
                    FROM MovementLinkMovement AS MovementLinkMovement_Invoice
                         INNER JOIN Movement ON Movement.Id = MovementLinkMovement_Invoice.MovementChildId
                                            AND Movement.DescId = zc_Movement_Invoice()
                                            AND Movement.StatusId <> zc_Enum_Status_Erased()

                         INNER JOIN MovementFloat AS MovementFloat_Amount
                                                  ON MovementFloat_Amount.MovementId = Movement.Id
                                                 AND MovementFloat_Amount.DescId = zc_MovementFloat_Amount()
                                                 AND MovementFloat_Amount.ValueData > 0

                    WHERE MovementLinkMovement_Invoice.MovementId =inMovementId_OrderClient
                      AND MovementLinkMovement_Invoice.DescId = zc_MovementLinkMovement_Invoice()
                    GROUP BY Movement.Id
                    )

     -- ������ �� ������ ������
     , tmpBankAccount AS (SELECT SUM (MovementItem.Amount)   ::TFloat AS AmountIn
                          FROM MovementLinkMovement
                              INNER JOIN Movement AS Movement_BankAccount
                                                  ON Movement_BankAccount.Id = MovementLinkMovement.MovementId
                                                 AND Movement_BankAccount.StatusId = zc_Enum_Status_Complete()   ---<> zc_Enum_Status_Erased()
                                                 AND Movement_BankAccount.DescId = zc_Movement_BankAccount()
                              INNER JOIN MovementItem ON MovementItem.MovementId = Movement_BankAccount.Id
                                                     AND MovementItem.DescId = zc_MI_Master()
                                                     AND MovementItem.isErased = FALSE
                                                     AND COALESCE (MovementItem.Amount,0) > 0
                          WHERE MovementLinkMovement.MovementChildId IN (SELECT DISTINCT tmpInvoice.MovementId_Invoice FROM tmpInvoice)
                            AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Invoice()
                          GROUP BY MovementLinkMovement.MovementChildId
                          )


       -- ���������
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
/*
            , tmpInfo.Name_Firma2    ::TVarChar AS Name_Firma
            , tmpInfo.Street_Firma2  ::TVarChar AS Street_Firma
            , tmpInfo.City_Firma2    ::TVarChar AS City_Firma
            , tmpInfo.Country_Firma2 ::TVarChar AS Country_Firma
            , tmpInfo.Text_tax2      ::TVarChar AS Text1   --**
  */          
            , Object_Client.ValueData        ::TVarChar AS Name_Firma
            , ObjectString_Street.ValueData  ::TVarChar AS Street_Firma
            , ObjectString_City.ValueData    ::TVarChar AS City_Firma
            , Object_Country.ValueData       ::TVarChar AS Country_Firma
            , ''                             ::TVarChar AS Text1   --**

            , tmpInfo.Text_Freight   ::TVarChar AS Text2
            , (' '||tmpInfo.Text_sign ||' '||vbInsertName::TVarChar)     ::TVarChar AS Text3
            
            , COALESCE (ObjectString_TaxNumber.ValueData,'') ::TVarChar AS TaxNumber
            , '' ::TVarChar AS Angebot
            , '' ::TVarChar AS Seite   
            
            , tmpInfo.Footer1        ::TVarChar AS Footer1              --*
            , tmpInfo.Footer2        ::TVarChar AS Footer2
            , tmpInfo.Footer3        ::TVarChar AS Footer3   --***
            , tmpInfo.Footer4        ::TVarChar AS Footer4
            --
            , tmpProdOptItems.Sale_summ_OptItems     ::TFloat
            , tmpProdOptItems.SaleWVAT_summ_OptItems ::TFloat
            --����� ������ �� ������
            , COALESCE (tmpOrder.Sale_summ,0) :: TFloat AS Sale_summ_order
            , zfCalc_SummWVAT (COALESCE (tmpOrder.Sale_summ,0), vbVATPercent) :: TFloat AS SaleWVat_summ_order
            -- ����� �����
            , tmpInvoice.AmountIn     ::TFloat AS Invoice_summ
            -- ����� ���������
            , tmpBankAccount.AmountIn ::TFloat AS Prepayment_summ
            
            , vbOperDate_OrderClient  AS OperDate_Order
            , vbInvNumber_OrderClient AS InvNumber_Order

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

          LEFT JOIN (SELECT SUM (zfCalc_SummDiscountTax (tmpProdOptItems.Sale_summ, COALESCE (tmpProdOptItems.DiscountTax,0)) ) AS Sale_summ_OptItems
                          , SUM (zfCalc_SummDiscountTax (tmpProdOptItems.SaleWVAT_summ, COALESCE (tmpProdOptItems.DiscountTax,0)) ) AS SaleWVAT_summ_OptItems
                     FROM tmpProdOptItems
                     ) AS tmpProdOptItems ON 1=1

          LEFT JOIN (SELECT SUM(tmp.Amount * tmp.OperPrice) AS Sale_summ 
                     FROM tmpOrderClient AS tmp
                     WHERE tmp.GoodsDesc <> zc_Object_Product()
                     ) AS tmpOrder ON 1 = 1
          
          LEFT JOIN Object_Product_PrintInfo_View AS tmpInfo ON 1=1
          LEFT JOIN (SELECT SUM (tmpInvoice.AmountIn) AS AmountIn FROM tmpInvoice) AS tmpInvoice ON 1 = 1
          LEFT JOIN tmpBankAccount ON 1 = 1
          LEFT JOIN tmp_OrderInfo ON 1=1


          LEFT JOIN Object AS Object_Client ON Object_Client.Id = tmpProduct.ClientId
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_Client.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_Client_Comment()  

          LEFT JOIN ObjectString AS ObjectString_Fax
                                 ON ObjectString_Fax.ObjectId = Object_Client.Id
                                AND ObjectString_Fax.DescId = zc_ObjectString_Client_Fax()  
          LEFT JOIN ObjectString AS ObjectString_Phone
                                 ON ObjectString_Phone.ObjectId = Object_Client.Id
                                AND ObjectString_Phone.DescId = zc_ObjectString_Client_Phone()
          LEFT JOIN ObjectString AS ObjectString_Mobile
                                 ON ObjectString_Mobile.ObjectId = Object_Client.Id
                                AND ObjectString_Mobile.DescId = zc_ObjectString_Client_Mobile()
          LEFT JOIN ObjectString AS ObjectString_IBAN
                                 ON ObjectString_IBAN.ObjectId = Object_Client.Id
                                AND ObjectString_IBAN.DescId = zc_ObjectString_Client_IBAN()
          LEFT JOIN ObjectString AS ObjectString_Street
                                 ON ObjectString_Street.ObjectId = Object_Client.Id
                                AND ObjectString_Street.DescId = zc_ObjectString_Client_Street()
          LEFT JOIN ObjectString AS ObjectString_Member
                                 ON ObjectString_Member.ObjectId = Object_Client.Id
                                AND ObjectString_Member.DescId = zc_ObjectString_Client_Member()
          LEFT JOIN ObjectString AS ObjectString_WWW
                                 ON ObjectString_WWW.ObjectId = Object_Client.Id
                                AND ObjectString_WWW.DescId = zc_ObjectString_Client_WWW()
          LEFT JOIN ObjectString AS ObjectString_Email
                                 ON ObjectString_Email.ObjectId = Object_Client.Id
                                AND ObjectString_Email.DescId = zc_ObjectString_Client_Email()
          LEFT JOIN ObjectString AS ObjectString_CodeDB
                                 ON ObjectString_CodeDB.ObjectId = Object_Client.Id
                                AND ObjectString_CodeDB.DescId = zc_ObjectString_Client_CodeDB()

          LEFT JOIN ObjectLink AS ObjectLink_PLZ
                               ON ObjectLink_PLZ.ObjectId = Object_Client.Id
                              AND ObjectLink_PLZ.DescId = zc_ObjectLink_Client_PLZ()
          LEFT JOIN Object AS Object_PLZ ON Object_PLZ.Id = ObjectLink_PLZ.ChildObjectId
          LEFT JOIN ObjectString AS ObjectString_City
                                 ON ObjectString_City.ObjectId = Object_PLZ.Id
                                AND ObjectString_City.DescId = zc_ObjectString_PLZ_City()
          LEFT JOIN ObjectLink AS ObjectLink_Country
                               ON ObjectLink_Country.ObjectId = Object_PLZ.Id
                              AND ObjectLink_Country.DescId = zc_ObjectLink_PLZ_Country()
          LEFT JOIN Object AS Object_Country ON Object_Country.Id = ObjectLink_Country.ChildObjectId


       ;

     RETURN NEXT Cursor1;

     OPEN Cursor2 FOR

       -- ���������
       SELECT tmpProdOptItems.ProdOptionsName AS GoodsName
            , tmpProdOptItems.Article
            , tmpProdOptItems.ProdColorName
            , tmpProdOptItems.Amount
            , tmpProdOptItems.SalePrice                       -- ���� ������� ��� ���
            , tmpProdOptItems.DiscountTax                     -- ������
            --, vbDiscountTax                ::TFloat AS DiscountTax
            , zfCalc_SummDiscountTax (zfCalc_SummDiscountTax (zfCalc_SummDiscountTax (tmpProdOptItems.Amount * tmpProdOptItems.SalePrice
                                                                                    , COALESCE (vbDiscountTax,0))
                                                            , COALESCE (vbDiscountNextTax,0)) 
                                    , COALESCE (tmpProdOptItems.DiscountTax,0) ) ::TFloat AS Sale_summ  -- ����� ������� ��� ��� �� ������� 
            , tmpProdOptItems.CommentOpt
       FROM tmpProdOptItems
     UNION
       SELECT tmp.GoodsName                  AS GoodsName
            , ObjectString_Article.ValueData AS Article
            , Object_ProdColor.ValueData     AS ProdColorName
            , tmp.Amount                          ::TFloat AS Amount
            , tmp.OperPrice                ::TFloat AS SalePrice
            , vbDiscountTax                ::TFloat AS DiscountTax
            , zfCalc_SummDiscountTax (zfCalc_SummDiscountTax (tmp.Amount * tmp.OperPrice
                                                            , COALESCE (vbDiscountTax,0))
                                    , COALESCE (vbDiscountNextTax,0) ) ::TFloat AS Sale_summ
            , '' ::TVarChar AS CommentOpt
       FROM tmpOrderClient AS tmp
            LEFT JOIN ObjectString AS ObjectString_Article
                                   ON ObjectString_Article.ObjectId = tmp.GoodsId
                                  AND ObjectString_Article.DescId = zc_ObjectString_Article()
            LEFT JOIN ObjectLink AS ObjectLink_Goods_ProdColor
                                 ON ObjectLink_Goods_ProdColor.ObjectId = tmp.GoodsId
                                AND ObjectLink_Goods_ProdColor.DescId = zc_ObjectLink_Goods_ProdColor()
            LEFT JOIN Object AS Object_ProdColor ON Object_ProdColor.Id = ObjectLink_Goods_ProdColor.ChildObjectId
       WHERE tmp.GoodsDesc <> zc_Object_Product()
       ;
     RETURN NEXT Cursor2;


     OPEN Cursor3 FOR

       -- ���������
       SELECT *
       FROM tmpProdColorItems
       ;

     RETURN NEXT Cursor3;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 10.02.21          *
*/

-- ����
-- SELECT * FROM gpSelect_Object_Product_OrderConfirmationPrint (inMovementId_OrderClient:= 662, inSession:= zfCalc_UserAdmin())
