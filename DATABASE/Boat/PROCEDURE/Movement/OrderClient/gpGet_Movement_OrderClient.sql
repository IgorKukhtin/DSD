-- Function: gpGet_Movement_OrderClient()

DROP FUNCTION IF EXISTS gpGet_Movement_OrderClient (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_OrderClient(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime ,
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, InvNumberPartner TVarChar
             , OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , PriceWithVAT Boolean
             , VATPercent TFloat
               -- % скидки осн
             , DiscountTax TFloat
               -- % скидки доп
             , DiscountNextTax TFloat
               -- Cумма откорректированной скидки, без НДС
             , SummTax TFloat
               -- ИТОГО откорректированная сумма, с учетом всех скидок, без Транспорта, Сумма продажи без НДС
             , SummReal TFloat
             , SummReal_real TFloat
               --
             , NPP TFloat
             , FromId Integer, FromName TVarChar
             , ToId Integer, ToName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , ProductId Integer, ProductName TVarChar, BrandId Integer, BrandName TVarChar, CIN TVarChar, DateBegin TDateTime
             , isReserve_Product Boolean
             , Comment TVarChar
             , isChild_Recalc Boolean
             , MovementId_Invoice Integer, InvNumber_Invoice TVarChar, Comment_Invoice TVarChar
             , InsertId Integer, InsertName TVarChar, InsertDate TDateTime

               -- ИТОГО Без скидки, Цена продажи базовой модели лодки, без НДС
             , Basis_summ1_orig        TFloat
               -- ИТОГО Без скидки, Сумма опций, без НДС
             , Basis_summ2_orig        TFloat
               -- ИТОГО Без скидки, Цена продажи базовой модели лодки + Сумма всех опций, без НДС
             , Basis_summ_orig         TFloat

               -- ИТОГО Сумма Скидки - без НДС
             , SummDiscount1           TFloat
             , SummDiscount2           TFloat
             , SummDiscount3           TFloat
             , SummDiscount_total      TFloat

               -- ИТОГО Сумма продажи без НДС - со ВСЕМИ Скидками (Basis+options)
             , Basis_summ              TFloat
               -- Сумма транспорт с сайта
             , TransportSumm_load     TFloat

              -- ИТОГО Сумма продажи без НДС - со ВСЕМИ Скидками (Basis+options) + TRANSPORT
             , Basis_summ_transport    TFloat
               -- ИТОГО Сумма продажи с НДС - со ВСЕМИ Скидками (Basis+options) + TRANSPORT
             , BasisWVAT_summ_transport TFloat
             
             , Value_TaxKind TFloat, TaxKindId Integer, TaxKindName TVarChar, TaxKindName_info TVarChar
              )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbNPP TFloat;
  DECLARE vbProductId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_OrderClient());
     vbUserId := inSession;

     vbProductId:= COALESCE ((SELECT MovementLinkObject_Product.ObjectId 
                              FROM  MovementLinkObject AS MovementLinkObject_Product
                              WHERE MovementLinkObject_Product.MovementId = inMovementId
                                AND MovementLinkObject_Product.DescId = zc_MovementLinkObject_Product()
                              )
                              ,0);

     IF COALESCE (inMovementId, 0) = 0
     THEN
         --
         vbNPP := COALESCE ((SELECT MAX(MovementFloat.ValueData)
                             FROM MovementFloat
                                 INNER JOIN Movement ON Movement.Id = MovementFloat.MovementId
                                                    AND Movement.DescId = zc_Movement_OrderClient()
                                                    AND Movement.StatusId <> zc_Enum_Status_Erased()
                             WHERE MovementFloat.DescId = zc_MovementFloat_NPP()
                               AND COALESCE (MovementFloat.ValueData,0)<>0
                             ), 0);
         -- Результат
         RETURN QUERY
             SELECT
                   0                         AS Id
                 , CAST (NEXTVAL ('movement_OrderClient_seq') AS TVarChar) AS InvNumber
                 , CAST ('' AS TVarChar)     AS InvNumberPartner
                 , CURRENT_DATE :: TDateTime AS OperDate
                 , Object_Status.Code        AS StatusCode
                 , Object_Status.Name        AS StatusName
                 , CAST (False as Boolean)   AS PriceWithVAT
                 , ObjectFloat_TaxKind_Value.ValueData :: TFloat AS VATPercent
    
                 , CAST (0 as TFloat)        AS DiscountTax
                 , CAST (0 as TFloat)        AS DiscountNextTax
                 , CAST (0 as TFloat)        AS SummTax
                 , CAST (0 as TFloat)        AS SummReal
                 , CAST (0 as TFloat)        AS SummReal_real
    
                 , (vbNPP +1)       ::TFloat AS NPP
                 , 0                         AS FromId
                 , CAST ('' AS TVarChar)     AS FromName
                 , 0                         AS ToId
                 , CAST ('' AS TVarChar)     AS ToName
                 , 0                         AS PaidKindId
                 , CAST ('' AS TVarChar)     AS PaidKindName
                 , 0                         AS ProductId
                 , CAST ('' AS TVarChar)     AS ProductName
                 , 0                         AS BrandId
                 , CAST ('' AS TVarChar)     AS BrandName
                 , CAST ('' AS TVarChar)     AS CIN
                 , (inOperDate + INTERVAL '1 MONTH') :: TDateTime AS DateBegin
                 , FALSE          :: Boolean AS isReserve_Product
                 , CAST ('' AS TVarChar)     AS Comment
                 , FALSE :: Boolean          AS isChild_Recalc
                 , 0                         AS MovementId_Invoice
                 , CAST ('' as TVarChar)     AS InvNumber_Invoice
                 , CAST ('' as TVarChar)     AS Comment_Invoice
    
                 , Object_Insert.Id                AS InsertId
                 , Object_Insert.ValueData         AS InsertName
                 , CURRENT_TIMESTAMP  ::TDateTime  AS InsertDate
    
                 , CAST (0 as TFloat)        AS Basis_summ1_orig
                 , CAST (0 as TFloat)        AS Basis_summ2_orig
                 , CAST (0 as TFloat)        AS Basis_summ_orig
    
                 , CAST (0 as TFloat)        AS SummDiscount1
                 , CAST (0 as TFloat)        AS SummDiscount2
                 , CAST (0 as TFloat)        AS SummDiscount3
                 , CAST (0 as TFloat)        AS SummDiscount_total
    
                 , CAST (0 as TFloat)        AS Basis_summ
                 , CAST (0 as TFloat)        AS TransportSumm_load
    
                 , CAST (0 as TFloat)        AS Basis_summ_transport
                 , CAST (0 as TFloat)        AS BasisWVAT_summ_transport

                 , CAST (0 as TFloat)        AS Value_TaxKind
                 , 0                         AS TaxKindId
                 , CAST ('' as TVarChar)     AS TaxKindName
                 , CAST ('' as TVarChar)     AS TaxKindName_info    
              FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status
                   LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                         ON ObjectFloat_TaxKind_Value.ObjectId = zc_Enum_TaxKind_Basis()
                                        AND ObjectFloat_TaxKind_Value.DescId = zc_ObjectFloat_TaxKind_Value()
                   LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = vbUserId
              ;

     ELSE

     RETURN QUERY
        WITH
        tmpSummProduct AS (SELECT  -- ИТОГО Без скидки, Цена продажи базовой модели лодки, без НДС
                                   gpSelect.Basis_summ1_orig
                                   -- ИТОГО Без скидки, Сумма опций, без НДС
                                 , gpSelect.Basis_summ2_orig
                                   -- ИТОГО Без скидки, Цена продажи базовой модели лодки + Сумма всех опций, без НДС
                                 , gpSelect.Basis_summ_orig

                                   -- ИТОГО Сумма Скидки - без НДС
                                 , gpSelect.SummDiscount1
                                 , gpSelect.SummDiscount2
                                 , gpSelect.SummDiscount3
                                 , gpSelect.SummDiscount AS SummDiscount_total

                                   -- ИТОГО Сумма продажи без НДС - со ВСЕМИ Скидками (Basis+options)
                                 , gpSelect.Basis_summ
                                   -- Сумма транспорт с сайта
                                 , gpSelect.TransportSumm_load

                                   -- ИТОГО Сумма продажи без НДС - со ВСЕМИ Скидками (Basis+options) + TRANSPORT
                                 , gpSelect.Basis_summ_transport
                                   -- ИТОГО Сумма продажи с НДС - со ВСЕМИ Скидками (Basis+options) + TRANSPORT
                                 , gpSelect.BasisWVAT_summ_transport

                           FROM gpSelect_Object_Product (inMovementId, FALSE, FALSE, '') AS gpSelect
                           WHERE gpSelect.MovementId_OrderClient = inMovementId
                          )
        -- Результат
        SELECT
            Movement_OrderClient.Id
          , Movement_OrderClient.InvNumber
          , MovementString_InvNumberPartner.ValueData AS InvNumberPartner
          , Movement_OrderClient.OperDate             AS OperDate
          , Object_Status.ObjectCode                  AS StatusCode
          , Object_Status.ValueData                   AS StatusName
            --
          , COALESCE (MovementBoolean_PriceWithVAT.ValueData, FALSE) :: Boolean AS PriceWithVAT
            --
          , COALESCE (MovementFloat_VATPercent.ValueData, 0)         :: TFloat AS VATPercent
          , COALESCE (MovementFloat_DiscountTax.ValueData, 0)        :: TFloat AS DiscountTax
          , COALESCE (MovementFloat_DiscountNextTax.ValueData, 0)    :: TFloat AS DiscountNextTax
            -- Cумма откорректированной скидки, без НДС
          , COALESCE (MovementFloat_SummTax.ValueData, 0)  :: TFLoat AS SummTax
            -- ИТОГО откорректированная сумма, с учетом всех скидок, без Транспорта, Сумма продажи без НДС
          , (COALESCE (tmpSummProduct.Basis_summ, 0) - COALESCE (MovementFloat_SummTax.ValueData,0)) :: TFloat AS SummReal
          , (COALESCE (tmpSummProduct.Basis_summ, 0) - COALESCE (MovementFloat_SummTax.ValueData,0)) :: TFLoat AS SummReal_real
            -- 
          , COALESCE (MovementFloat_NPP.ValueData,0) ::TFloat AS NPP

          , Object_From.Id                            AS FromId
          , Object_From.ValueData                     AS FromName
          , Object_To.Id                              AS ToId
          , Object_To.ValueData                       AS ToName
          , Object_PaidKind.Id                        AS PaidKindId
          , Object_PaidKind.ValueData                 AS PaidKindName

          , Object_Product.Id                          AS ProductId
          , zfCalc_ValueData_isErased (Object_Product.ValueData, Object_Product.isErased) AS ProductName
          , Object_Brand.Id                            AS BrandId
          , Object_Brand.ValueData                     AS BrandName
          , zfCalc_ValueData_isErased (ObjectString_CIN.ValueData, Object_Product.isErased) AS CIN
          , ObjectDate_DateBegin.ValueData             AS DateBegin
          , COALESCE (ObjectBoolean_Product_Reserve.ValueData, FALSE) :: Boolean AS isReserve_Product

          , COALESCE (MovementString_Comment.ValueData,'') :: TVarChar AS Comment
          --, EXISTS (SELECT 1 FROM MovementItem AS MI WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Child() AND MI.isErased = FALSE) :: Boolean AS isChild_Recalc
          , FALSE :: Boolean AS isChild_Recalc

          , Movement_Invoice.Id                                        AS MovementId_Invoice
          , zfCalc_InvNumber_isErased ('', Movement_Invoice.InvNumber, Movement_Invoice.OperDate, Movement_Invoice.StatusId) AS InvNumber_Invoice
          , MovementString_Comment_Invoice.ValueData                   AS Comment_Invoice

          , Object_Insert.Id                     AS InsertId
          , Object_Insert.ValueData              AS InsertName
          , MovementDate_Insert.ValueData        AS InsertDate

            -- ИТОГО Без скидки, Цена продажи базовой модели лодки, без НДС
          , 19:58 17.03.2024tmpSummProduct.Basis_summ1_orig        ::TFloat
            -- ИТОГО Без скидки, Сумма опций, без НДС
          , tmpSummProduct.Basis_summ2_orig         ::TFloat
            -- ИТОГО Без скидки, Цена продажи базовой модели лодки + Сумма всех опций, без НДС
          , tmpSummProduct.Basis_summ_orig          ::TFloat

            -- ИТОГО Сумма Скидки - без НДС
          , tmpSummProduct.SummDiscount1            ::TFloat
          , tmpSummProduct.SummDiscount2            ::TFloat
          , tmpSummProduct.SummDiscount3            ::TFloat
          , tmpSummProduct.SummDiscount_total       ::TFloat

            -- ИТОГО Сумма продажи без НДС - со ВСЕМИ Скидками (Basis+options)
          , tmpSummProduct.Basis_summ
           -- Сумма транспорт с сайта
          , tmpSummProduct.TransportSumm_load

           -- ИТОГО Сумма продажи без НДС - со ВСЕМИ Скидками (Basis+options) + TRANSPORT
          , tmpSummProduct.Basis_summ_transport
            -- ИТОГО Сумма продажи с НДС - со ВСЕМИ Скидками (Basis+options) + TRANSPORT
          , tmpSummProduct.BasisWVAT_summ_transport

          , ObjectFloat_TaxKind_Value.ValueData          AS Value_TaxKind
          , Object_TaxKind.Id                            AS TaxKindId
          , Object_TaxKind.ValueData                     AS TaxKindName
          , ObjectString_TaxKind_Info.ValueData          AS TaxKindName_info
        FROM Movement AS Movement_OrderClient
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement_OrderClient.StatusId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement_OrderClient.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement_OrderClient.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = Movement_OrderClient.Id
                                        AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Product
                                         ON MovementLinkObject_Product.MovementId = Movement_OrderClient.Id
                                        AND MovementLinkObject_Product.DescId = zc_MovementLinkObject_Product()
            LEFT JOIN Object AS Object_Product ON Object_Product.Id = MovementLinkObject_Product.ObjectId

            LEFT JOIN ObjectBoolean AS ObjectBoolean_Product_Reserve
                                    ON ObjectBoolean_Product_Reserve.ObjectId = Object_Product.Id
                                   AND ObjectBoolean_Product_Reserve.DescId   = zc_ObjectBoolean_Product_Reserve()

            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId = Movement_OrderClient.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                    ON MovementFloat_VATPercent.MovementId = Movement_OrderClient.Id
                                   AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()

            LEFT JOIN MovementFloat AS MovementFloat_DiscountTax
                                    ON MovementFloat_DiscountTax.MovementId = Movement_OrderClient.Id
                                   AND MovementFloat_DiscountTax.DescId = zc_MovementFloat_DiscountTax()

            LEFT JOIN MovementFloat AS MovementFloat_DiscountNextTax
                                    ON MovementFloat_DiscountNextTax.MovementId = Movement_OrderClient.Id
                                   AND MovementFloat_DiscountNextTax.DescId = zc_MovementFloat_DiscountNextTax()

            LEFT JOIN MovementFloat AS MovementFloat_NPP
                                    ON MovementFloat_NPP.MovementId = Movement_OrderClient.Id
                                   AND MovementFloat_NPP.DescId = zc_MovementFloat_NPP()

            LEFT JOIN MovementFloat AS MovementFloat_SummTax
                                    ON MovementFloat_SummTax.MovementId = Movement_OrderClient.Id
                                   AND MovementFloat_SummTax.DescId = zc_MovementFloat_SummTax()

            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId = Movement_OrderClient.Id
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement_OrderClient.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Invoice
                                           ON MovementLinkMovement_Invoice.MovementId = Movement_OrderClient.Id
                                          AND MovementLinkMovement_Invoice.DescId = zc_MovementLinkMovement_Invoice()
            LEFT JOIN Movement AS Movement_Invoice ON Movement_Invoice.Id = MovementLinkMovement_Invoice.MovementChildId

            LEFT JOIN MovementString AS MovementString_Comment_Invoice
                                     ON MovementString_Comment_Invoice.MovementId = Movement_Invoice.Id
                                    AND MovementString_Comment_Invoice.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement_OrderClient.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
            LEFT JOIN MovementLinkObject AS MLO_Insert
                                         ON MLO_Insert.MovementId = Movement_OrderClient.Id
                                        AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId

            --
            LEFT JOIN ObjectString AS ObjectString_CIN
                                   ON ObjectString_CIN.ObjectId = Object_Product.Id
                                  AND ObjectString_CIN.DescId = zc_ObjectString_Product_CIN()
            LEFT JOIN ObjectLink AS ObjectLink_Brand
                                 ON ObjectLink_Brand.ObjectId = Object_Product.Id
                                AND ObjectLink_Brand.DescId = zc_ObjectLink_Product_Brand()
            LEFT JOIN Object AS Object_Brand ON Object_Brand.Id = ObjectLink_Brand.ChildObjectId

            LEFT JOIN ObjectDate AS ObjectDate_DateBegin
                                 ON ObjectDate_DateBegin.ObjectId = Object_Product.Id
                                AND ObjectDate_DateBegin.DescId = zc_ObjectDate_Product_DateBegin()

            LEFT JOIN tmpSummProduct ON 1 = 1
            --
            LEFT JOIN ObjectLink AS ObjectLink_TaxKind
                                 ON ObjectLink_TaxKind.ObjectId = Object_From.Id
                                AND ObjectLink_TaxKind.DescId = zc_ObjectLink_Client_TaxKind()
            LEFT JOIN Object AS Object_TaxKind ON Object_TaxKind.Id = ObjectLink_TaxKind.ChildObjectId
                                
            LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                  ON ObjectFloat_TaxKind_Value.ObjectId = ObjectLink_TaxKind.ChildObjectId 
                                 AND ObjectFloat_TaxKind_Value.DescId = zc_ObjectFloat_TaxKind_Value()   
            LEFT JOIN ObjectString AS ObjectString_TaxKind_Info
                                   ON ObjectString_TaxKind_Info.ObjectId = ObjectLink_TaxKind.ChildObjectId
                                  AND ObjectString_TaxKind_Info.DescId = zc_ObjectString_TaxKind_Info()
        WHERE Movement_OrderClient.Id = inMovementId
          AND Movement_OrderClient.DescId = zc_Movement_OrderClient()
          ;
    END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.02.21         *
*/

-- тест
-- SELECT * FROM gpGet_Movement_OrderClient (inMovementId:= 664, inOperDate := '02.02.2021'::TDateTime, inSession:= '9818')
