-- Function: gpSelect_Movement_PriceList()

DROP FUNCTION IF EXISTS gpReport_OrderGoodsSearch (Integer, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_OrderGoodsSearch(
    IN inGoodsId       Integer     -- ����� �������
  , IN inStartDate     TDateTime 
  , IN inEndDate       TDateTime
  , IN inSession       TVarChar    -- ������ ������������
)
RETURNS TABLE (MovementId Integer      --�� ���������
              ,ItemName TVarChar       --��������(���) ���������
              ,Amount TFloat           --���-�� ������ � ���������
              ,Code Integer            --��� ������
              ,Name TVarChar           --������������ ������
              ,OperDate TDateTime      --���� ���������
              ,InvNumber TVarChar      --� ���������
              ,UnitName TVarChar       --�������������
              ,JuridicalName TVarChar  --��. ����
              ,Price TFloat            --���� � ���������
              ,StatusName TVarChar     --��������� ���������
              ,PriceSale TFloat        --���� �������
              ,OrderKindId Integer     --�� ���� ������
              ,OrderKindName TVarChar  --�������� ���� ������
              ,Comment  TVarChar       --����������� � ���������
              ,PartionGoods TVarChar   --� ����� ���������
              ,ExpirationDate TDateTime--���� ��������
              ,PaymentDate TDateTime   --���� ������
              )


AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_PriceList());
    vbUserId:= lpGetUserBySession (inSession);
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
      vbUnitKey := '0';
    END IF;   
    vbUnitId := vbUnitKey::Integer;

    RETURN QUERY
      SELECT Movement.Id                        AS MovementId
            ,MovementDesc.ItemName              AS ItemName
            ,MovementItem.Amount                AS Amount
            ,Object.ObjectCode                  AS Code
            ,Object.ValueData                   AS Name
            ,Movement.OperDate                  AS OperDate
            ,Movement.InvNumber                 AS InvNumber
            ,Object_Unit.ValueData              AS UnitName
            ,Object_From.ValueData              AS JuridicalName
            ,MIFloat_Price.ValueData            AS Price
            ,Status.ValueData                   AS STatusNAme
            ,MIFloat_PriceSale.ValueData        AS PriceSale
            ,Object_OrderKind.Id                AS OrderKindId
            ,Object_OrderKind.ValueData         AS OrderKindName
            ,MIString_Comment.ValueData         AS Comment
            ,MIString_PartionGoods.ValueData    AS PartionGoods
            ,MIDate_ExpirationDate.ValueData    AS ExpirationDate
            ,MovementDate_Payment.ValueData     AS PaymentDate
      FROM Movement 
        JOIN Object AS Status 
                    ON Status.Id = Movement.StatusId 
                   AND Status.Id <> zc_Enum_Status_Erased()
        JOIN MovementItem ON MovementItem.MovementId = Movement.Id
        JOIN Object ON Object.Id = MovementItem.ObjectId
        JOIN MovementDesc ON MovementDesc.Id = Movement.DescId

        LEFT JOIN MovementItemFloat AS MIFloat_Price
                                    ON MIFloat_Price.MovementItemId = MovementItem.Id
                                   AND MIFloat_Price.DescId = zc_MIFloat_Price()

        LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                    ON MIFloat_PriceSale.MovementItemId = MovementItem.Id
                                   AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()

        LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                     ON MovementLinkObject_Unit.MovementId = Movement.Id
                                    AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
        LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                     ON MovementLinkObject_To.MovementId = Movement.Id
                                    AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
        LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = COALESCE(MovementLinkObject_Unit.ObjectId, MovementLinkObject_To.ObjectId)

        LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                     ON MovementLinkObject_From.MovementId = Movement.Id
                                    AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
        LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

        LEFT JOIN MovementLinkObject AS MovementLinkObject_OrderKind
                                     ON MovementLinkObject_OrderKind.MovementId = Movement.Id
                                    AND MovementLinkObject_OrderKind.DescId = zc_MovementLinkObject_OrderKind()
        LEFT JOIN Object AS Object_OrderKind ON Object_OrderKind.Id = MovementLinkObject_OrderKind.ObjectId

        LEFT JOIN MovementItemString AS MIString_Comment 
                                     ON MIString_Comment.DescId = zc_MIString_Comment()
                                    AND MIString_Comment.MovementItemId = MovementItem.id  

        LEFT JOIN MovementItemString AS MIString_PartionGoods
                                     ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                    AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
        LEFT JOIN MovementItemDate AS MIDate_ExpirationDate
                                   ON MIDate_ExpirationDate.MovementItemId = MovementItem.Id
                                  AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()

        LEFT JOIN MovementDate AS MovementDate_Payment
                               ON MovementDate_Payment.MovementId = Movement.Id
                              AND MovementDate_Payment.DescId = zc_MovementDate_Payment()
                                  
    WHERE 
        Movement.DescId in (zc_Movement_OrderInternal(), zc_Movement_OrderExternal(), zc_Movement_Income())
        AND 
        ((Object_Unit.Id = vbUnitId) OR (vbUnitId = 0)) 
        AND 
        Movement.OperDate BETWEEN inStartDate AND inEndDate 
        AND 
        Object.Id = inGoodsId;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpReport_OrderGoodsSearch (Integer, TDateTime, TDateTime, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 24.04.15                        *
 18.03.15                        *
 27.01.15                        *
 21.01.15                        *
 02.12.14                        *

*/

-- ����
-- SELECT * FROM gpSelect_Movement_PriceList (inStartDate:= '30.01.2014', inEndDate:= '01.02.2014', inIsErased := FALSE, inSession:= '2')