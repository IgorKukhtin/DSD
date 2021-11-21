-- Function: gpSelect_Movement_SaleExactly_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_SaleExactly_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_SaleExactly_Print(
    IN inMovementId        Integer  , -- ключ Документа
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
        SELECT
            Movement_Sale.Id
          , Movement_Sale.InvNumber
          , Movement_Sale.OperDate
          , Movement_Sale.TotalCount
          , Movement_Sale.TotalSumm
          , Movement_Sale.TotalSummSale
          , Movement_Sale.UnitName
          , Movement_Sale.JuridicalName
          , Movement_Sale.PaidKindName
          , Object_InsuranceCompanies.ValueData                          AS InsuranceCompaniesName
          , Object_MemberIC.ValueData                                    AS MemberICName
          , ObjectString_InsuranceCardNumber.ValueData                   AS InsuranceCardNumber
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
          , MI_Sale.Amount * (MI_Sale.PriceSale * MI_Sale.NDS / (100.0 + MI_Sale.NDS)) AS SummNDS
        FROM
            MovementItem_Sale_View AS MI_Sale
        WHERE
            MI_Sale.MovementId = inMovementId
            AND
            MI_Sale.isErased = FALSE 
        ORDER BY
            MI_Sale.GoodsName;

    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_SaleExactly_Print (Integer,TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А
 29.07.15                                                                       *
*/

-- 
SELECT * FROM gpSelect_Movement_Sale_Print (inMovementId := 25365702, inSession:= '5');
