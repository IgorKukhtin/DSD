-- Function: gpSelect_Movement_Sale_PrintInvoiceIC()

DROP FUNCTION IF EXISTS gpSelect_Movement_Sale_PrintInvoiceIC (Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Sale_PrintInvoiceIC(
    IN inMovementId    Integer  , -- ключ Документа
    IN inInvoiceNDS    TFloat   , -- НДС     
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Sale());
    vbUserId:= inSession;

    OPEN Cursor1 FOR
    WITH  tmpBankAccount AS (SELECT ObjectLink_Juridical.ChildObjectId AS JuridicalId
                                  , Object_BankAccount.Id
                                  , Object_BankAccount.ValueData AS BankAccount
                                  , Object_Bank.ValueData AS BankName
                                  , ObjectString_MFO.ValueData AS MFO
                             FROM Object AS Object_BankAccount
                                LEFT JOIN ObjectLink AS ObjectLink_Juridical
                                                     ON ObjectLink_Juridical.ObjectId = Object_BankAccount.Id
                                                    AND ObjectLink_Juridical.DescId = zc_ObjectLink_BankAccount_Juridical()
                                LEFT JOIN ObjectLink AS ObjectLink_Bank
                                                     ON ObjectLink_Bank.ObjectId = Object_BankAccount.Id
                                                    AND ObjectLink_Bank.DescId = zc_ObjectLink_BankAccount_Bank()
                                LEFT JOIN Object AS Object_Bank ON Object_Bank.Id = ObjectLink_Bank.ChildObjectId
                                LEFT JOIN ObjectString AS ObjectString_MFO
                                                       ON ObjectString_MFO.ObjectId = Object_Bank.Id 
                                                      AND ObjectString_MFO.DescId = zc_ObjectString_Bank_MFO()
                             WHERE Object_BankAccount.DescId = zc_object_BankAccount()
                             )

        SELECT
            Movement_Sale.Id
          , Movement_Sale.InvNumber
          , Movement_Sale.OperDate
          , Movement_Sale.TotalCount
          , Movement_Sale.TotalSumm
          , Movement_Sale.TotalSummSale
          , Movement_Sale.UnitName
          , Object_Juridical.ValueData                                   AS JuridicalName
          , Movement_Sale.PaidKindName
          , Object_InsuranceCompanies.ValueData                          AS InsuranceCompaniesName
          , Object_MemberIC.ValueData                                    AS MemberICName
          , ObjectString_InsuranceCardNumber.ValueData                   AS InsuranceCardNumber

          , ObjectHistory_JuridicalDetails.FullName AS JuridicalFullName
          , ObjectHistory_JuridicalDetails.JuridicalAddress
          , ObjectHistory_JuridicalDetails.OKPO
          , ObjectHistory_JuridicalDetails.MainName
          , ObjectHistory_JuridicalDetails.MainName_Cut
          , ObjectHistory_JuridicalDetails.AccounterName
          , ObjectHistory_JuridicalDetails.INN
          , ObjectHistory_JuridicalDetails.NumberVAT
          , ObjectHistory_JuridicalDetails.BankAccount ::TVarChar AS BankAccount 
          , ObjectHistory_JuridicalDetails.Phone
          , tmpBankAccount.BankName  ::TVarChar AS BankName
          , tmpBankAccount.MFO ::TVarChar AS MFO
          , inInvoiceNDS                  AS NDS  
          , CASE WHEN COALESCE(Object_InsuranceCompanies.Id, 0) > 0 
                 THEN COALESCE(MovementFloat_ChangePercent.ValueData, 100)
                 ELSE NULL END :: TFloat                          AS ChangePercent
        FROM
            Movement_Sale_View AS Movement_Sale

            LEFT JOIN MovementLinkObject AS MLO_InsuranceCompanies
                                         ON MLO_InsuranceCompanies.MovementId = Movement_Sale.Id
                                        AND MLO_InsuranceCompanies.DescId = zc_MovementLinkObject_InsuranceCompanies()
            LEFT JOIN Object AS Object_InsuranceCompanies ON Object_InsuranceCompanies.Id = MLO_InsuranceCompanies.ObjectId  
            LEFT JOIN MovementLinkObject AS MLO_MemberIC
                                         ON MLO_MemberIC.MovementId = Movement_Sale.Id
                                        AND MLO_MemberIC.DescId = zc_MovementLinkObject_MemberIC()
            LEFT JOIN Object AS Object_MemberIC ON Object_MemberIC.Id = MLO_MemberIC.ObjectId  
            LEFT JOIN ObjectString AS ObjectString_InsuranceCardNumber
                                   ON ObjectString_InsuranceCardNumber.ObjectId = Object_MemberIC.Id
                                  AND ObjectString_InsuranceCardNumber.DescId = zc_ObjectString_MemberIC_InsuranceCardNumber() 
                                  
            LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                 ON ObjectLink_Unit_Juridical.ObjectId = Movement_Sale.UnitId
                                AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId
            
            LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                    ON MovementFloat_ChangePercent.MovementId = Movement_Sale.Id
                                   AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()       
                                  
            LEFT JOIN gpSelect_ObjectHistory_JuridicalDetails(injuridicalid := Object_Juridical.Id, inFullName := '', inOKPO := '', inSession := inSession) AS ObjectHistory_JuridicalDetails ON 1=1

            LEFT JOIN tmpBankAccount ON tmpBankAccount.JuridicalId = Object_Juridical.Id
                                    AND tmpBankAccount.BankAccount = ObjectHistory_JuridicalDetails.BankAccount
        WHERE 
            Movement_Sale.Id = inMovementId;
    RETURN NEXT Cursor1;


    OPEN Cursor2 FOR
        SELECT
            MI_Sale.GoodsCode
          , MI_Sale.GoodsName
          , MI_Sale.Amount
          , MI_Sale.NDS
          , MI_Sale.Price
          , MI_Sale.Summ
          , MI_Sale.PriceSale
          , ROUND(MI_Sale.PriceSale * 100.0 / (100.0 + MI_Sale.NDS), 2) AS PriceWithVAT
          , ROUND(MI_Sale.Amount * MI_Sale.PriceSale, 2)::TFloat AS SummSale

          , ROUND(MI_Sale.Amount * MI_Sale.PriceSale * 100.0 / (100.0 + MI_Sale.NDS), 2)::TFloat AS SummSaleWithVAT
          , MI_Sale.Amount * (MI_Sale.PriceSale * MI_Sale.NDS / (100.0 + MI_Sale.NDS)) AS SummNDS

          , ROUND((MI_Sale.Amount * MI_Sale.PriceSale-
                       COALESCE (MI_Sale.Summ, 0)) * 100.0 / (100.0 + MI_Sale.NDS), 2)::TFloat AS SummSaleWithVATIC
          , MI_Sale.Amount * ((MI_Sale.PriceSale - COALESCE (MI_Sale.Price, 0)) * MI_Sale.NDS / (100.0 + MI_Sale.NDS)) AS SummNDSIC
          , ROUND(MI_Sale.Amount * MI_Sale.PriceSale - COALESCE (MI_Sale.Summ, 0), 2)::TFloat AS SummSaleIC

          , ROW_NUMBER()OVER(ORDER BY MI_Sale.GoodsName)::Integer as ORD
          , Object_Measure.ValueData            AS MeasureName
        FROM
            MovementItem_Sale_View AS MI_Sale
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId =  MI_Sale.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
        WHERE
            MI_Sale.MovementId = inMovementId
            AND
            MI_Sale.isErased = FALSE 
            AND 
            MI_Sale.NDS = inInvoiceNDS
        ORDER BY
            MI_Sale.GoodsName;

    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_Sale_PrintInvoiceIC (Integer, TFloat, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Шаблий О.В.
 22.11.21                                                        *
*/

-- 

select * from gpSelect_Movement_Sale_PrintInvoiceIC(inMovementId := 30678777 , inInvoiceNDS := 0 ,  inSession := '3');
