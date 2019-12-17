-- Function: gpReport_MovementCheck_PromoEntrances()

DROP FUNCTION IF EXISTS gpReport_MovementCheck_PromoEntrances (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_MovementCheck_PromoEntrances(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inSession            TVarChar    -- ������ ������������
)
RETURNS TABLE (MovementId Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer
             , CashRegisterName TVarChar, PaidTypeName TVarChar
             , Entrances TVarChar

             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Amount TFloat
             , Price TFloat
             , Summa TFloat
             , NDS TFloat
             , PriceSale TFloat
             , SummSale TFloat
             , ChangePercent TFloat
             , SummChangePercent TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);

     -- ���������
     RETURN QUERY
         SELECT
             Movement_Check.Id
           , Movement_Check.InvNumber
           , Movement_Check.OperDate
           , Object_Status.ObjectCode                           AS StatusCode

           , Object_CashRegister.ValueData                      AS CashRegisterName
           , Object_PaidType.ValueData                          AS PaidTypeName

           , Movement_Check.Entrances                           AS Entrances

           , MovementItem.GoodsId
           , MovementItem.GoodsCode
           , MovementItem.GoodsName
           , MovementItem.Amount
           , MovementItem.Price
           , MovementItem.AmountSumm
           , MovementItem.NDS
           , MovementItem.PriceSale
           , (MovementItem.PriceSale * MovementItem.Amount) :: TFloat AS SummSale
           , MovementItem.ChangePercent
           , MovementItem.SummChangePercent

        FROM (SELECT Movement.*
                   , MIString_Bayer.ValueData      ::TVarChar AS Entrances
              FROM Movement

                    -- ���� �� ��������� ����� ���
                   INNER JOIN MovementFloat AS MovementFloat_MovementItemId
                                            ON MovementFloat_MovementItemId.MovementId = Movement.Id
                                           AND MovementFloat_MovementItemId.DescId     = zc_MovementFloat_MovementItemId()
                   INNER JOIN MovementItem AS MI_PromoCode
                                           ON MI_PromoCode.Id       = MovementFloat_MovementItemId.ValueData :: Integer
                                          AND MI_PromoCode.isErased = FALSE
                                          AND MI_PromoCode.MovementId = 16931134
                   LEFT JOIN MovementItemString AS MIString_Bayer
                                                ON MIString_Bayer.MovementItemId = MI_PromoCode.Id
                                               AND MIString_Bayer.DescId = zc_MIString_Bayer()


              WHERE Movement.OperDate >= DATE_TRUNC ('DAY', inStartDate)
                AND Movement.OperDate < DATE_TRUNC ('DAY', inEndDate) + INTERVAL '1 DAY'
                AND Movement.DescId = zc_Movement_Check()
                AND  Movement.StatusId = zc_Enum_Status_Complete()
           ) AS Movement_Check

             LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement_Check.StatusId

             LEFT JOIN MovementLinkObject AS MovementLinkObject_CashRegister
                                          ON MovementLinkObject_CashRegister.MovementId = Movement_Check.Id
                                         AND MovementLinkObject_CashRegister.DescId = zc_MovementLinkObject_CashRegister()
             LEFT JOIN Object AS Object_CashRegister ON Object_CashRegister.Id = MovementLinkObject_CashRegister.ObjectId

   	         LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidType
                                          ON MovementLinkObject_PaidType.MovementId = Movement_Check.Id
                                         AND MovementLinkObject_PaidType.DescId = zc_MovementLinkObject_PaidType()
             LEFT JOIN Object AS Object_PaidType ON Object_PaidType.Id = MovementLinkObject_PaidType.ObjectId

             LEFT JOIN MovementItem_Check_View AS MovementItem
                                               ON MovementItem.MovementId = Movement_Check.Id

             ;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 17.12.19                                                       *
*/

-- ����
-- select * from gpReport_MovementCheck_PromoEntrances(inStartDate := ('01.12.2019')::TDateTime , inEndDate := ('31.12.2019')::TDateTime ,  inSession := '3');