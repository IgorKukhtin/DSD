-- Function: gpInsert_MI_SalePodium_Offer_byReturn()

DROP FUNCTION IF EXISTS gpInsert_MI_SalePodium_Offer_byReturn (Integer, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MI_SalePodium_Offer_byReturn(
    IN inMovementId     Integer    , -- ���� ������� <��������>
    IN inStartDate      TDateTime  , -- 
    IN inEndDate        TDateTime  , -- 
    IN inSession        TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbClientId Integer;
   DECLARE vbUnitId_user   Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Sale());
     vbUserId:= lpGetUserBySession (inSession);

     -- �������� ��� ������������ - � ������ ������������� �� ��������
     vbUnitId_user:= lpGetUnit_byUser (vbUserId);

     -- ��������� �� ���������
     SELECT COALESCE (MLO_From.ObjectId, 0) AS UnitId
          , COALESCE (MLO_To.ObjectId, 0)   AS ClientId
            INTO vbUnitId, vbClientId
     FROM Movement
            LEFT JOIN MovementLinkObject AS MLO_From
                                         ON MLO_From.MovementId = Movement.Id
                                        AND MLO_From.DescId     = zc_MovementLinkObject_From()
            LEFT JOIN MovementLinkObject AS MLO_To
                                         ON MLO_To.MovementId = Movement.Id
                                        AND MLO_To.DescId     = zc_MovementLinkObject_To()
     WHERE Movement.Id = inMovementId;

     --��������  �������� �� ��������� �� ��������� ������
     CREATE TEMP TABLE tmpMI_ReturnIn (MI_Id Integer, PartionId Integer, GoodsId Integer, AmountPartner TFloat, OperPriceListReal TFloat) ON COMMIT DROP;
     INSERT INTO tmpMI_ReturnIn (MI_Id, PartionId, GoodsId, AmountPartner, OperPriceListReal)
       WITH
       tmpMovement AS (SELECT Movement.Id
                       FROM Movement
                            INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                          ON MovementLinkObject_To.MovementId = Movement.Id
                                                         AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                         AND MovementLinkObject_To.ObjectId = vbUnitId
                            INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                          ON MovementLinkObject_From.MovementId = Movement.Id
                                                         AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                         AND MovementLinkObject_From.ObjectId = vbClientId
                       WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate 
                         AND Movement.DescId = zc_Movement_ReturnIn()
                         AND Movement.StatusId = zc_Enum_Status_Complete()
                       )
       -- ��� ��������
     , tmpOffer_all AS (SELECT MovementItem.Id                  AS MI_Id
                             , MovementItem.PartionId           AS PartionId
                             , MovementItem.ObjectId            AS GoodsId
                             , MIFloat_AmountPartner.ValueData  AS AmountPartner
                             , COALESCE (MIFloat_OperPriceListReal.ValueData, 0) AS OperPriceListReal
                        FROM tmpMovement
                             INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement.Id
                                                    AND MovementItem.DescId     = zc_MI_Master()
                                                    AND MovementItem.isErased   = FALSE
                             INNER JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                          ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                         AND MIFloat_AmountPartner.DescId         = zc_MIFloat_AmountPartner()
                                                         AND COALESCE (MIFloat_AmountPartner.ValueData,0) <> 0

                             LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionMI
                                                              ON MILinkObject_PartionMI.MovementItemId = MovementItem.Id
                                                             AND MILinkObject_PartionMI.DescId         = zc_MILinkObject_PartionMI()
                             LEFT JOIN Object AS Object_PartionMI ON Object_PartionMI.Id = MILinkObject_PartionMI.ObjectId
                             LEFT JOIN MovementItem AS MI_sale ON MI_sale.Id = Object_PartionMI.ObjectCode

                             INNER JOIN MovementBoolean AS MovementBoolean_Offer
                                                        ON MovementBoolean_Offer.MovementId = MI_sale.MovementId
                                                       AND MovementBoolean_Offer.DescId = zc_MovementBoolean_Offer()
                                                       AND MovementBoolean_Offer.ValueData = TRUE

                             LEFT JOIN MovementItemFloat AS MIFloat_OperPriceListReal
                                                         ON MIFloat_OperPriceListReal.MovementItemId = MI_sale.Id
                                                        AND MIFloat_OperPriceListReal.DescId         = zc_MIFloat_OperPriceListReal()
                        )
       -- �������� ������� ��� ������ � �������, ���� �������� �� ��������
     , tmpOffer_sale AS (SELECT tmpOffer_all.PartionId
                         FROM tmpOffer_all
                              INNER JOIN MovementItem ON MovementItem.PartionId = tmpOffer_all.PartionId
                                                     AND MovementItem.DescId     = zc_MI_Master()
                                                     AND MovementItem.isErased   = FALSE
                                                     AND MovementItem.ObjectId = tmpOffer_all.GoodsId
                              INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                                                 AND Movement.DescId = zc_Movement_Sale()
                                                 AND Movement.StatusId <> zc_Enum_Status_Erased()-- zc_Enum_Status_Complete()
                              INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                            ON MovementLinkObject_To.MovementId = Movement.Id
                                                           AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                           AND MovementLinkObject_To.ObjectId = vbClientId
                              INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                            ON MovementLinkObject_From.MovementId = Movement.Id
                                                           AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                           AND MovementLinkObject_From.ObjectId = vbUnitId
                              LEFT JOIN MovementBoolean AS MovementBoolean_Offer
                                                        ON MovementBoolean_Offer.MovementId = Movement.Id
                                                       AND MovementBoolean_Offer.DescId = zc_MovementBoolean_Offer()
                         WHERE COALESCE (MovementBoolean_Offer.ValueData, FALSE) = FALSE
                         )
         --
         SELECT tmpOffer_all.MI_Id
              , tmpOffer_all.PartionId
              , tmpOffer_all.GoodsId
              , tmpOffer_all.AmountPartner
              , tmpOffer_all.OperPriceListReal
         FROM tmpOffer_all
              LEFT JOIN tmpOffer_sale ON tmpOffer_sale.PartionId = tmpOffer_all.PartionId
         WHERE tmpOffer_sale.PartionId IS NULL
         ;

     -- ���������
     PERFORM gpInsertUpdate_MovementItem_SalePodium (ioId                    := 0
                                                   , inMovementId            := inMovementId
                                                   , ioGoodsId               := tmp.GoodsId        ::Integer    -- *** - �����
                                                   , inPartionId             := tmp.PartionId      ::Integer    -- ������
                                                   , ioDiscountSaleKindId    := 0                  ::Integer    -- *** - ��� ������ ��� �������
                                                   , inIsPay                 := FALSE              ::Boolean    -- �������� � �������
                                                   , ioAmount                := tmp.AmountPartner  ::TFloat     -- ����������
                                                   , ioChangePercent         := 0                  ::TFloat     -- *** - % ������
                                                   , ioSummChangePercent     := 0                  ::TFloat     -- *** - �������������� ������ � ������� ���
                                                   , ioSummChangePercent_curr:= 0                  ::TFloat     -- *** - �������������� ������ � ������� � ������***
                                                   , ioOperPriceList         := tmp.OperPriceListReal ::TFloat     -- *** - ���� ���� ���
                                                   , inBarCode_partner       := 0                  ::TVarChar   -- �����-��� ����������
                                                   , inBarCode_old           := 0                  ::TVarChar   -- �����-��� �� �������� ����� - old
                                                   , inComment               := ''                 ::TVarChar
                                                   , inSession               := inSession
                                                    )
     FROM tmpMI_ReturnIn AS tmp
     ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 14.05.21         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_SalePodium (ioId := 0 , inMovementId := 8 , ioGoodsId := 446 , inPartionId := 50 , inIsPay := False ,  ioAmount := 4 ,ioSummChangePercent:=0, ioOperPriceList := 1030 , inBarCode_partner := '1' ::TVarChar,  inSession := zfCalc_UserAdmin());
