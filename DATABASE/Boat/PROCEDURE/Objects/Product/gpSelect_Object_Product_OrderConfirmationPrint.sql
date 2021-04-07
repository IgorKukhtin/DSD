-- Function: gpSelect_Object_Product_OrderConfirmationPrint ()

DROP FUNCTION IF EXISTS gpSelect_Object_Product_TendersPrint (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_Product_OrderConfirmationPrint (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Product_OrderConfirmationPrint(
    IN inMovementId_OrderClient       Integer   ,   --        Integer   ,   -- 
    IN inSession                      TVarChar      -- сессия пользователя
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

BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- данные из документа заказа
     SELECT MovementBoolean_PriceWithVAT.ValueData  AS PriceWithVAT
          , MovementFloat_VATPercent.ValueData      AS VATPercent
          , MovementFloat_DiscountTax.ValueData     AS DiscountTax
          , Movement_OrderClient.OperDate
          , Movement_OrderClient.InvNumber
          , Object_Insert.ValueData  AS InsertNamer
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
         LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId 
     WHERE Movement_OrderClient.Id = inMovementId_OrderClient  -- по идее должен быть один док. заказа, но малоли
       AND Movement_OrderClient.DescId = zc_Movement_OrderClient();

     -- данные из документа заказа
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
                                                                END  ::TFloat AS OperPrice               -- без НДС
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
     
     -- данные по лодкe
     CREATE TEMP TABLE tmpProduct ON COMMIT DROP AS (SELECT tmp.*
                                                     FROM gpSelect_Object_Product (inIsShowAll:= FALSE, inIsSale:= FALSE, inSession:= inSession) AS tmp
                                                     WHERE tmp.Id = vbProductId
                                                       AND tmp.MovementId_OrderClient = inMovementId_OrderClient
                                                     );
     -- выбор данных по опциям
     CREATE TEMP TABLE tmpProdOptItems ON COMMIT DROP AS (SELECT tmp.*
                                                     FROM gpSelect_Object_ProdOptItems (inIsShowAll:= FALSE, inIsErased:= FALSE, inIsSale:= FALSE, inSession:= inSession) AS tmp
                                                     WHERE tmp.ProductId = vbProductId
                                                       AND tmp.MovementId_OrderClient = inMovementId_OrderClient
                                                     );
     -- выбор данных по цвету
     CREATE TEMP TABLE tmpProdColorItems ON COMMIT DROP AS (SELECT tmp.*
                                                            FROM gpSelect_Object_ProdColorItems (inIsShowAll:= FALSE, inIsErased:= FALSE, inIsSale:= FALSE, inSession:= inSession) AS tmp
                                                            WHERE tmp.ProductId = vbProductId
                                                              AND COALESCE (tmp.Amount,0) <> 0
                                                              AND tmp.MovementId_OrderClient = inMovementId_OrderClient
                                                            );
     -- Результат
     OPEN Cursor1 FOR
     WITH
   -- данные всех док счет
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

     -- данные по оплате счетов
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
            , tmpInfo.Name_Firma2    ::TVarChar AS Name_Firma
            , tmpInfo.Street_Firma2  ::TVarChar AS Street_Firma
            , tmpInfo.City_Firma2    ::TVarChar AS City_Firma
            , tmpInfo.Country_Firma2 ::TVarChar AS Country_Firma
            , tmpInfo.Text_tax2      ::TVarChar AS Text1   --**
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
            , tmpProdOptItems.Sale_summ_OptItems ::TFloat
            --сумма товара из заказа
            ,  COALESCE (tmpOrder.Sale_summ,0) :: TFloat AS Sale_summ_order
            -- сумма счета
            , tmpInvoice.AmountIn     ::TFloat AS Invoice_summ
            -- сумма педоплаты
            , tmpBankAccount.AmountIn ::TFloat AS Prepayment_summ
            
            , vbOperDate_OrderClient  AS OperDate_Order
            , vbInvNumber_OrderClient AS InvNumber_Order
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
                     FROM tmpProdOptItems
                     ) AS tmpProdOptItems ON 1=1

          LEFT JOIN (SELECT SUM(tmp.Amount * tmp.OperPrice) AS Sale_summ FROM tmpOrderClient AS tmp WHERE tmp.GoodsDesc <> zc_Object_Product()) AS tmpOrder ON 1 = 1
          
          LEFT JOIN Object_Product_PrintInfo_View AS tmpInfo ON 1=1
          LEFT JOIN (SELECT SUM (tmpInvoice.AmountIn) AS AmountIn FROM tmpInvoice) AS tmpInvoice ON 1 = 1
          LEFT JOIN tmpBankAccount ON 1 = 1
       ;

     RETURN NEXT Cursor1;

     OPEN Cursor2 FOR

       -- Результат
       SELECT tmpProdOptItems.ProdOptionsName AS GoodsName
            , tmpProdOptItems.Article
            , tmpProdOptItems.ProdColorName
            , tmpProdOptItems.Amount
            , tmpProdOptItems.SalePrice                       -- Цена продажи без НДС
            , tmpProdOptItems.DiscountTax                     -- Скидка
            , zfCalc_SummDiscountTax (tmpProdOptItems.Sale_summ, COALESCE (tmpProdOptItems.DiscountTax,0)) ::TFloat AS Sale_summ  -- Сумма продажи без НДС со скидкой
       FROM tmpProdOptItems
     UNION
       SELECT tmp.GoodsName                  AS GoodsName
            , ObjectString_Article.ValueData AS Article
            , Object_ProdColor.ValueData     AS ProdColorName
            , tmp.Amount                          ::TFloat AS Amount
            , tmp.OperPrice                ::TFloat AS SalePrice
            , vbDiscountTax                ::TFloat AS DiscountTax
            , zfCalc_SummDiscountTax (tmp.Amount * tmp.OperPrice, COALESCE (vbDiscountTax,0)) ::TFloat AS Sale_summ
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

       -- Результат
       SELECT *
       FROM tmpProdColorItems
       ;

     RETURN NEXT Cursor3;

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