-- Function: gpSelect_Movement_Invoice_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_Invoice_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Invoice_Print(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbMovementId_order Integer;
  DECLARE Cursor1 refcursor;
  DECLARE Cursor2 refcursor; 
  DECLARE Cursor3 refcursor;
  DECLARE Cursor4 refcursor;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Cash());
     vbUserId := lpGetUserBySession (inSession);

     -- документ заказа, из него получим опции для печати счета
     vbMovementId_order := (SELECT Movement.ParentId
                            FROM Movement
                                INNER JOIN Movement AS Movement_order 
                                                    ON Movement_order.Id = Movement.ParentId
                                                   AND Movement_order.DescId = zc_Movement_OrderClient()
                                                   AND Movement_order.StatusId <> zc_Enum_Status_Erased()
                            WHERE Movement.Id = inMovementId
                            );

     OPEN Cursor1 FOR

        WITH -- Все документы заказа, в которых указан этот Счет, возьмем первый
             tmpInvoice AS (SELECT tmp.*
                                 , Object_Insert.ValueData AS InsertName
                                 , Object.ObjectCode
                            FROM gpGet_Movement_Invoice (inMovementId, 0 , 0 , 0 ,  CURRENT_DATE, '', inSession) AS tmp
                                 LEFT JOIN MovementLinkObject AS MLO_Insert
                                                              ON MLO_Insert.MovementId = tmp.Id
                                                             AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
                                 LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId 
                                 LEFT JOIN Object ON Object.Id = tmp.ObjectId
                           )    
                           
                           
           , tmpProduct AS (SELECT tmp.*
                            FROM tmpInvoice
                                 LEFT JOIN gpSelect_Object_Product (inMovementId_OrderClient:= tmpInvoice.MovementId_parent, inIsShowAll:= TRUE, inIsSale:= FALSE, inSession:= inSession) AS tmp  
                                                                   ON tmp.MovementId_OrderClient = tmpInvoice.MovementId_parent
                            WHERE tmp.Id = tmpInvoice.ProductId
                            )
           
     -- данные по оплате счета
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
                          WHERE MovementLinkMovement.MovementChildId = inMovementId--IN (SELECT DISTINCT tmpInvoice.MovementId_Invoice FROM tmpInvoice)
                            AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Invoice()
                          GROUP BY MovementLinkMovement.MovementChildId
                          )
      -- Все документы предоплаты, в которых указан этот док заказ (нужна итого сумма для счета показать сумму счетов предоплаты)
      , tmpMov_PrePay AS (SELECT Movement.Id
                               , (CASE WHEN MovementFloat_Amount.ValueData > 0 THEN  1 * MovementFloat_Amount.ValueData ELSE 0 END) ::TFloat AS Total_PrePay
                               , ROW_NUMBER() OVER (ORDER BY Movement.OperDate, Movement.InvNumber) AS Ord
                         FROM Movement
                            INNER JOIN MovementLinkObject AS MovementLinkObject_InvoiceKind
                                                          ON MovementLinkObject_InvoiceKind.MovementId = Movement.Id
                                                         AND MovementLinkObject_InvoiceKind.DescId = zc_MovementLinkObject_InvoiceKind()
                                                         AND MovementLinkObject_InvoiceKind.ObjectId = zc_Enum_InvoiceKind_PrePay()
                            LEFT JOIN MovementFloat AS MovementFloat_Amount
                                                    ON MovementFloat_Amount.MovementId = Movement.Id
                                                   AND MovementFloat_Amount.DescId = zc_MovementFloat_Amount() 
                         WHERE Movement.DescId = zc_Movement_Invoice()
                           AND Movement.ParentId = vbMovementId_order
                           AND Movement.StatusId = zc_Enum_Status_Complete()
                         )

       -- Результат
       SELECT tmpProduct.*
            , LEFT (tmpProduct.CIN, 8) ::TVarChar AS PatternCIN
            , EXTRACT (YEAR FROM tmpProduct.DateBegin)  ::TVarChar AS YearBegin 
            , ''                                        ::TVarChar AS ModelGroupName
            , ObjectFloat_Power.ValueData               ::TFloat   AS EnginePower
            , ObjectFloat_Volume.ValueData              ::TFloat   AS EngineVolume
            --
            , tmpInvoice.* 
            -- сумма счета
            , tmpInvoice.AmountIn     ::TFloat AS Invoice_summ
            , tmpInvoice.AmountOut    ::TFloat AS Invoice_summOut
            -- сумма педоплаты
            , tmpBankAccount.AmountIn ::TFloat AS Prepayment_summ  
            --% счета от общей суммы лодки
            , CASE WHEN COALESCE(tmpProduct.BasisWVAT_summ_transport,0) <> 0 THEN tmpInvoice.AmountIn*100 / tmpProduct.BasisWVAT_summ_transport ELSE 0 END :: TFloat AS Persent_invoice
            --% НДС из заказа Клиента    есть в   tmpProduct
            --, COALESCE (MovementFloat_VATPercent.ValueData, 0)         :: TFloat AS VATPercent
            --сумма счетов предоплаты
            , tmpMov_PrePay.Total_PrePay ::TFloat
            --
            , tmpInfo.Mail           ::TVarChar AS Mail
            , tmpInfo.WWW            ::TVarChar AS WWW
            , tmpInfo.Name_main      ::TVarChar AS Name_main
            , tmpInfo.Street_main    ::TVarChar AS Street_main
            , tmpInfo.City_main      ::TVarChar AS City_main
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
            , (' '||tmpInfo.Text_sign ||' '|| tmpInvoice.InsertName ::TVarChar)  ::TVarChar AS Text3
            
            , COALESCE (ObjectString_TaxNumber.ValueData,'') ::TVarChar AS TaxNumber
            , '' ::TVarChar AS Angebot
            , '' ::TVarChar AS Seite   
            
            , tmpInfo.Footer1        ::TVarChar AS Footer1              --*
            , tmpInfo.Footer2        ::TVarChar AS Footer2
            , tmpInfo.Footer3        ::TVarChar AS Footer3   --***
            , tmpInfo.Footer4        ::TVarChar AS Footer4 
            , tmpInfo.Footer_bank    ::TVarChar AS Footer_bank
            , tmpInfo.Footer_user    ::TVarChar AS Footer_user    
            
            --строка для предоплаты берем из комментария, если комментарий пусто то формируем сами
            , CASE WHEN COALESCE (MovementString_Comment.ValueData,'') <> '' THEN MovementString_Comment.ValueData
                   ELSE CASE WHEN tmpPrePay.Ord = 1 THEN 'Reservation Fee ' 
                               || ROUND (CASE WHEN COALESCE(tmpProduct.BasisWVAT_summ_transport,0) <> 0 THEN tmpInvoice.AmountIn*100 / tmpProduct.BasisWVAT_summ_transport ELSE 0 END, 0)
                               || '% for '||tmpProduct.modelname_full || ' Order: '|| tmpProduct.invnumber_orderclient
                             WHEN tmpPrePay.Ord = 2 THEN 'First Advance-payment '
                               || ROUND (CASE WHEN COALESCE(tmpProduct.BasisWVAT_summ_transport,0) <> 0 THEN tmpInvoice.AmountIn*100 / tmpProduct.BasisWVAT_summ_transport ELSE 0 END, 0)
                               || '% for '||tmpProduct.modelname_full || ' Order: '|| tmpProduct.invnumber_orderclient
                             WHEN tmpPrePay.Ord = 3 THEN 'First and Second Advance-payment '
                               || ROUND (CASE WHEN COALESCE(tmpProduct.BasisWVAT_summ_transport,0) <> 0 THEN tmpInvoice.AmountIn*100 / tmpProduct.BasisWVAT_summ_transport ELSE 0 END, 0)
                               || '% for '||tmpProduct.modelname_full || ' Order: '|| tmpProduct.invnumber_orderclient 
                             ELSE /*WHEN tmpPrePay.Ord = 4 THEN*/ 'First, Second and Third Advance-payment '
                               || ROUND (CASE WHEN COALESCE(tmpProduct.BasisWVAT_summ_transport,0) <> 0 THEN tmpInvoice.AmountIn*100 / tmpProduct.BasisWVAT_summ_transport ELSE 0 END, 0)
                               || '% for '||tmpProduct.modelname_full || ' Order: '|| tmpProduct.invnumber_orderclient
                          END
                     
              END  :: TVarChar AS Comment_PrePay
          
             --Reservation Fee  [FormatFloat( ',0.0', <frxDBDHeader."Persent_invoice">)]%  for [frxDBDHeader."modelname_full"] Order: [frxDBDHeader."invnumber_orderclient"]

             --First, Second and Third Advance-payment [FormatFloat( ',0.0', <frxDBDHeader."Persent_invoice">)]%  for [frxDBDHeader."modelname_full"] Order: [frxDBDHeader."invnumber_orderclient"]


       FROM tmpInvoice
           LEFT JOIN tmpProduct ON tmpProduct.Id = tmpInvoice.ProductId
           LEFT JOIN Object_Product_PrintInfo_View AS tmpInfo ON 1=1 
           LEFT JOIN tmpBankAccount ON 1 = 1

           LEFT JOIN ObjectString AS ObjectString_TaxNumber
                                  ON ObjectString_TaxNumber.ObjectId = tmpInvoice.ObjectId
                                 AND ObjectString_TaxNumber.DescId = zc_ObjectString_Client_TaxNumber() 
          LEFT JOIN ObjectFloat AS ObjectFloat_Power
                                ON ObjectFloat_Power.ObjectId = tmpProduct.EngineId
                               AND ObjectFloat_Power.DescId = zc_ObjectFloat_ProdEngine_Power()
          LEFT JOIN ObjectFloat AS ObjectFloat_Volume
                                ON ObjectFloat_Volume.ObjectId = tmpProduct.EngineId
                               AND ObjectFloat_Volume.DescId = zc_ObjectFloat_ProdEngine_Volume() 
          --
          LEFT JOIN Object AS Object_Client ON Object_Client.Id = tmpInvoice.ObjectId
          LEFT JOIN ObjectString AS ObjectString_Street
                                 ON ObjectString_Street.ObjectId = Object_Client.Id
                                AND ObjectString_Street.DescId = zc_ObjectString_Client_Street()

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
          --итого сумма предоплат
          LEFT JOIN (SELECT SUM (tmpMov_PrePay.Total_PrePay) AS Total_PrePay FROM  tmpMov_PrePay) AS tmpMov_PrePay ON 1 = 1  
          --номер предоплаты
          LEFT JOIN tmpMov_PrePay AS tmpPrePay ON tmpPrePay.Id = tmpInvoice.Id

          LEFT JOIN MovementString AS MovementString_Comment
                                   ON MovementString_Comment.MovementId = tmpInvoice.Id
                                  AND MovementString_Comment.DescId = zc_MovementString_Comment()
 
          ;

     RETURN NEXT Cursor1; 
    
     OPEN Cursor2 FOR     
         SELECT Movement.Id                     AS MovementId
              , MovementItem.Id                 AS Id
              , MovementItem.ObjectId           AS GoodsId
              , Object_Goods.ObjectCode         AS GoodsCode
              , Object_Goods.ValueData          AS GoodsName  
              , ObjectString_Article.ValueData  AS Article
              , MovementItem.Amount         ::TFloat AS Amount  
              , MIFloat_OperPrice.ValueData ::TFloat AS OperPrice
              , (COALESCE (MovementItem.Amount,0) * COALESCE (MIFloat_OperPrice.ValueData, 0)) ::TFloat AS Summа
              , MIString_Comment.ValueData      AS Comment
              , MovementItem.isErased           AS isErased
         FROM Movement
              INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id 
                                     AND MovementItem.DescId = zc_MI_Master()
                                     AND (MovementItem.isErased = FALSE)
              LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                          ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                         AND MIFloat_OperPrice.DescId         = zc_MIFloat_OperPrice()  
              LEFT JOIN MovementItemString AS MIString_Comment
                                           ON MIString_Comment.MovementItemId = MovementItem.Id
                                          AND MIString_Comment.DescId = zc_MIString_Comment()
  
              LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
  
              LEFT JOIN ObjectString AS ObjectString_Article
                                     ON ObjectString_Article.ObjectId = MovementItem.ObjectId
                                    AND ObjectString_Article.DescId   = zc_ObjectString_Article() 
         WHERE Movement.Id = inMovementId;
     RETURN NEXT Cursor2; 

     OPEN Cursor3 FOR    --для печати возврата
        WITH
        -- Все документы предоплаты, в которых указан этот док заказ
       tmpMov_Parent AS (SELECT Movement.Id
                              , Movement.InvNumber
                              , ROW_NUMBER() OVER (ORDER BY Movement.OperDate, Movement.InvNumber) AS ord
                         FROM Movement
                            INNER JOIN MovementLinkObject AS MovementLinkObject_InvoiceKind
                                                          ON MovementLinkObject_InvoiceKind.MovementId = Movement.Id
                                                         AND MovementLinkObject_InvoiceKind.DescId = zc_MovementLinkObject_InvoiceKind()
                                                         AND MovementLinkObject_InvoiceKind.ObjectId = zc_Enum_InvoiceKind_PrePay() 
                         WHERE Movement.DescId = zc_Movement_Invoice()
                           AND Movement.ParentId = vbMovementId_order
                           AND Movement.Id <> inMovementId
                           AND Movement.StatusId = zc_Enum_Status_Complete()
                         )
       SELECT tmpMov_Parent.InvNumber
            , MovementString_ReceiptNumber.ValueData     AS ReceiptNumber            
            , CASE WHEN MovementFloat_Amount.ValueData > 0 THEN  1 * MovementFloat_Amount.ValueData ELSE 0 END::TFloat AS AmountIn
            , CASE WHEN tmpMov_Parent.Ord = 1 THEN 'Reservation fee' ELSE 'First, Second and Third Advance-payment'  END AS Text_ret
            , tmpMov_Parent.Ord ::TFloat
       FROM tmpMov_Parent
            LEFT JOIN MovementFloat AS MovementFloat_Amount
                                    ON MovementFloat_Amount.MovementId = tmpMov_Parent.Id
                                   AND MovementFloat_Amount.DescId = zc_MovementFloat_Amount()
            LEFT JOIN MovementString AS MovementString_ReceiptNumber
                                     ON MovementString_ReceiptNumber.MovementId = tmpMov_Parent.Id
                                    AND MovementString_ReceiptNumber.DescId = zc_MovementString_ReceiptNumber()       
       ORDER BY tmpMov_Parent.Ord
       ;
       
     RETURN NEXT Cursor3;

     OPEN Cursor4 FOR    --для печати счета - опции
        SELECT MovementItem.ObjectId                    AS ObjectId
             , Object_Object.ObjectCode                 AS ObjectCode
             , Object_Object.ValueData                  AS ObjectName
        FROM MovementItem 
             INNER JOIN Object AS Object_Object
                               ON Object_Object.Id = MovementItem.ObjectId
                              AND Object_Object.DescId = zc_Object_ProdOptions() 

        WHERE MovementItem.MovementId = vbMovementId_order
          AND MovementItem.DescId = zc_MI_Child()
          AND MovementItem.isErased   = FALSE 
          AND COALESCE (MovementItem.ParentId, 0) = 0
        ;

    RETURN NEXT Cursor4;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.06.23         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Invoice_Print (inMovementId:= 1, inSession:= zfCalc_UserAdmin());
-- [IIf (<frxDBDReturn."ord"> = 1, '', '%') ] [IIf (<frxDBDReturn."ord"> = 1, '', <frxDBDHeader."modelname_full") ] [IIf (<frxDBDReturn."ord"> = 1, '', 'Order:' <frxDBDHeader."invnumber_orderclient">) ] 

