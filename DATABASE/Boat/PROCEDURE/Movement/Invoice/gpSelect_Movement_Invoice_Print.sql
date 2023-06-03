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
  DECLARE Cursor1 refcursor;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Cash());
     vbUserId := lpGetUserBySession (inSession);

OPEN Cursor1 FOR

        WITH -- Все документы заказа, в которых указан этот Счет, возьмем первый
             tmpInvoice AS (SELECT tmp.*
                                 , Object_Insert.ValueData AS InsertName
                                 , Object.ObjectCode
                            FROM gpGet_Movement_Invoice (inMovementId, CURRENT_DATE, inSession) AS tmp
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
           
                          /*(SELECT tmpInvoice.ProductId
                                  , Object_Product.ObjectCode        AS ProductCode
                                  , Object_Brand.Id                  AS BrandId
                                  , Object_Brand.ValueData           AS BrandName
                                  , Object_Model.Id                  AS ModelId
                                  , Object_Model.ValueData           AS ModelName
                                  , (Object_Brand.ValueData || '-' || Object_Model.ValueData) ::TVarChar AS ModelName_full
                                  , Object_Engine.Id                 AS EngineId
                                  , Object_Engine.ValueData          AS EngineName
                                  , ObjectString_CIN.ValueData       AS CIN
                                  , ObjectString_EngineNum.ValueData AS EngineNum 
                                  , EXTRACT (YEAR FROM ObjectDate_DateBegin.ValueData)  ::TVarChar AS YearBegin
                                  , '' ::TVarChar AS ModelGroupName
                                  , ObjectFloat_Power.ValueData               ::TFloat   AS EnginePower
                                  , ObjectFloat_Volume.ValueData              ::TFloat   AS EngineVolume
                            FROM tmpInvoice
                                 LEFT JOIN ObjectString AS ObjectString_CIN
                                                        ON ObjectString_CIN.ObjectId = tmpInvoice.ProductId
                                                       AND ObjectString_CIN.DescId = zc_ObjectString_Product_CIN()
                                 LEFT JOIN ObjectString AS ObjectString_EngineNum
                                                        ON ObjectString_EngineNum.ObjectId = tmpInvoice.ProductId
                                                       AND ObjectString_EngineNum.DescId = zc_ObjectString_Product_EngineNum()
 
                                  LEFT JOIN ObjectDate AS ObjectDate_DateBegin
                                                       ON ObjectDate_DateBegin.ObjectId = tmpInvoice.ProductId
                                                      AND ObjectDate_DateBegin.DescId = zc_ObjectDate_Product_DateBegin()

                                 LEFT JOIN ObjectLink AS ObjectLink_Model
                                                      ON ObjectLink_Model.ObjectId = tmpInvoice.ProductId
                                                     AND ObjectLink_Model.DescId = zc_ObjectLink_Product_Model() 
                                 LEFT JOIN Object AS Object_Model ON Object_Model.Id = ObjectLink_Model.ObjectId

                                 LEFT JOIN ObjectLink AS ObjectLink_Brand
                                                      ON ObjectLink_Brand.ObjectId = tmpInvoice.ProductId
                                                     AND ObjectLink_Brand.DescId = zc_ObjectLink_Product_Brand()
                                 LEFT JOIN Object AS Object_Brand ON Object_Brand.Id = ObjectLink_Brand.ChildObjectId

                                 LEFT JOIN ObjectLink AS ObjectLink_Engine
                                                      ON ObjectLink_Engine.ObjectId = tmpInvoice.ProductId
                                                     AND ObjectLink_Engine.DescId = zc_ObjectLink_Product_Engine()
                                 LEFT JOIN Object AS Object_Engine ON Object_Engine.Id = ObjectLink_Engine.ChildObjectId

                                 LEFT JOIN ObjectFloat AS ObjectFloat_Power
                                                       ON ObjectFloat_Power.ObjectId = Object_Engine.Id
                                                      AND ObjectFloat_Power.DescId = zc_ObjectFloat_ProdEngine_Power()
                                 LEFT JOIN ObjectFloat AS ObjectFloat_Volume
                                                       ON ObjectFloat_Volume.ObjectId = Object_Engine.Id
                                                      AND ObjectFloat_Volume.DescId = zc_ObjectFloat_ProdEngine_Volume() 
                                 LEFT JOIN Object AS Object_Product AS Object_Product.Id = tmpInvoice.ProductId
                            )*/

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
            -- сумма педоплаты
            , tmpBankAccount.AmountIn ::TFloat AS Prepayment_summ
            --
            , tmpInfo.Mail           ::TVarChar AS Mail
            , tmpInfo.WWW            ::TVarChar AS WWW
            , tmpInfo.Name_main      ::TVarChar AS Name_main
            , tmpInfo.Street_main    ::TVarChar AS Street_main
            , tmpInfo.City_main      ::TVarChar AS City_main
            , tmpInfo.Name_Firma2    ::TVarChar AS Name_Firma
            , tmpInfo.Street_Firma2  ::TVarChar AS Street_Firma
            , tmpInfo.City_Firma2    ::TVarChar AS City_Firma
            , tmpInfo.Country_Firma2 ::TVarChar AS Country_Firma
            , tmpInfo.Text_tax2      ::TVarChar AS Text1   --**
            , tmpInfo.Text_Freight   ::TVarChar AS Text2
            , (' '||tmpInfo.Text_sign ||' '|| tmpInvoice.InsertName ::TVarChar)  ::TVarChar AS Text3
            
            , COALESCE (ObjectString_TaxNumber.ValueData,'') ::TVarChar AS TaxNumber
            , '' ::TVarChar AS Angebot
            , '' ::TVarChar AS Seite   
            
            , tmpInfo.Footer1        ::TVarChar AS Footer1              --*
            , tmpInfo.Footer2        ::TVarChar AS Footer2
            , tmpInfo.Footer3        ::TVarChar AS Footer3   --***
            , tmpInfo.Footer4        ::TVarChar AS Footer4


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
          
          ;

    RETURN NEXT Cursor1;

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
