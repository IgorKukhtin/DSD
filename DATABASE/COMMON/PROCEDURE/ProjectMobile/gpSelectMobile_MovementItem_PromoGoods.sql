-- Function: gpSelectMobile_MovementItem_PromoGoods()

DROP FUNCTION IF EXISTS gpSelectMobile_MovementItem_PromoGoods (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelectMobile_MovementItem_PromoGoods(
    IN inSyncDateIn TDateTime, -- ����/����� ��������� ������������� - ����� "�������" ����������� �������� ���������� - ���������� �����������, ����, �����, �����, ������� � �.�
    IN inSession    TVarChar   -- ������ ������������
)
RETURNS TABLE (Id              Integer -- ���������� �������������, ����������� � ������� ��, � ������������ ��� �������������
             , MovementId      Integer -- ���������� ������������� ���������
             , GoodsId         Integer -- �����
             , GoodsKindId     Integer -- ��� ������
             , PriceWithOutVAT TFloat  -- ��������� ���� ��� ����� ���
             , PriceWithVAT    TFloat  -- ��������� ���� � ������ ���
             , TaxPromo        TFloat  -- % ������ �� �����, ������������ - ����� ������ ����������� ��� ������� ��������� ����, *����� - ������������ ������ ��� ���������*
             , isSync          Boolean   
              )

AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPersonalId Integer;
BEGIN
      -- �������� ���� ������������ �� ����� ���������
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      vbPersonalId:= (SELECT PersonalId FROM gpGetMobile_Object_Const (inSession));

      -- ���������
      IF vbPersonalId IS NOT NULL 
      THEN
           RETURN QUERY
             WITH tmpPromoPartner AS (SELECT Movement_Promo.Id AS PromoId
                                           , ROW_NUMBER() OVER (PARTITION BY MI_PromoPartner.ObjectId ORDER BY Movement_Promo.Operdate DESC, Movement_PromoPartner.ParentId DESC) AS RowNum
                                      FROM Movement AS Movement_PromoPartner
                                           JOIN MovementItem AS MI_PromoPartner
                                                             ON MI_PromoPartner.MovementId = Movement_PromoPartner.Id
                                                            AND MI_PromoPartner.DescId = zc_MI_Master()
                                                            AND MI_PromoPartner.IsErased = FALSE
                                           JOIN lfSelectMobile_Object_Partner (inIsErased:= FALSE, inSession:= inSession) AS OP ON OP.Id = MI_PromoPartner.ObjectId
                                           JOIN Movement AS Movement_Promo 
                                                         ON Movement_Promo.Id = Movement_PromoPartner.ParentId
                                                        AND Movement_Promo.StatusId = zc_Enum_Status_Complete()
                                           JOIN MovementDate AS MovementDate_StartSale
                                                             ON MovementDate_StartSale.MovementId = Movement_Promo.Id
                                                            AND MovementDate_StartSale.DescId = zc_MovementDate_StartSale()
                                                            AND MovementDate_StartSale.ValueData <= CURRENT_DATE
                                           JOIN MovementDate AS MovementDate_EndSale
                                                             ON MovementDate_EndSale.MovementId = Movement_Promo.Id
                                                            AND MovementDate_EndSale.DescId = zc_MovementDate_EndSale()
                                                            AND MovementDate_EndSale.ValueData >= CURRENT_DATE
                                      WHERE Movement_PromoPartner.DescId = zc_Movement_PromoPartner()
                                        AND Movement_PromoPartner.StatusId <> zc_Enum_Status_Erased()
                                     )
                , tmpPromo AS (SELECT DISTINCT tmpPromoPartner.PromoId AS Id 
                               FROM tmpPromoPartner 
                               WHERE tmpPromoPartner.RowNum = 1
                              )
             SELECT MovementItem_PromoGoods.Id
                  , MovementItem_PromoGoods.MovementId
                  , MovementItem_PromoGoods.ObjectId                          AS GoodsId
                  , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)::Integer    AS GoodsKindId
                  , COALESCE (MIFloat_PriceWithOutVAT.ValueData, 0.0)::TFloat AS PriceWithOutVAT
                  , COALESCE (MIFloat_PriceWithVAT.ValueData, 0.0)::TFloat    AS PriceWithVAT
                  , COALESCE (MovementItem_PromoGoods.Amount, 0.0)::TFloat    AS TaxPromo
                  , (NOT MovementItem_PromoGoods.isErased)                    AS isSync
             FROM tmpPromo
                  JOIN MovementItem AS MovementItem_PromoGoods 
                                    ON MovementItem_PromoGoods.MovementId = tmpPromo.Id
                                   AND MovementItem_PromoGoods.DescId = zc_MI_Master()
                                   AND MovementItem_PromoGoods.IsErased = FALSE
                  LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                   ON MILinkObject_GoodsKind.MovementItemId = MovementItem_PromoGoods.Id
                                                  AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind() 
                  LEFT JOIN MovementItemFloat AS MIFloat_PriceWithOutVAT
                                              ON MIFloat_PriceWithOutVAT.MovementItemId = MovementItem_PromoGoods.Id
                                             AND MIFloat_PriceWithOutVAT.DescId = zc_MIFloat_PriceWithOutVAT() 
                  LEFT JOIN MovementItemFloat AS MIFloat_PriceWithVAT
                                              ON MIFloat_PriceWithVAT.MovementItemId = MovementItem_PromoGoods.Id
                                             AND MIFloat_PriceWithVAT.DescId = zc_MIFloat_PriceWithVAT() 
             ;
            
      END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.   �������� �.�.
 29.05.17                                                                          *
 17.03.17                                                                          *
*/

-- SELECT * FROM gpSelectMobile_MovementItem_PromoGoods (inSyncDateIn:= zc_DateStart(), inSession:= zfCalc_UserAdmin())
