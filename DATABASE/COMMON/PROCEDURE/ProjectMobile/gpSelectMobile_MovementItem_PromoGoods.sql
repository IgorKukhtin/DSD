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
             WITH tmpPromoPartner AS (SELECT DISTINCT Movement_PromoPartner.ParentId AS ParentId
                                      FROM Movement AS Movement_PromoPartner
                                           JOIN MovementLinkObject AS MovementLinkObject_Partner
                                                                   ON MovementLinkObject_Partner.MovementId = Movement_PromoPartner.Id
                                                                  AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner() 
                                           JOIN ObjectLink AS ObjectLink_Partner_PersonalTrade
                                                           ON ObjectLink_Partner_PersonalTrade.ObjectId = MovementLinkObject_Partner.ObjectId 
                                                          AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
                                                          AND ObjectLink_Partner_PersonalTrade.ChildObjectId = vbPersonalId
                                      WHERE Movement_PromoPartner.DescId = zc_Movement_PromoPartner()
                                        AND Movement_PromoPartner.ParentId IS NOT NULL 
                                     )
             SELECT MovementItem_PromoGoods.Id
                  , MovementItem_PromoGoods.MovementId
                  , MovementItem_PromoGoods.ObjectId                          AS GoodsId
                  , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)::Integer    AS GoodsKindId
                  , COALESCE (MIFloat_PriceWithOutVAT.ValueData, 0.0)::TFloat AS PriceWithOutVAT
                  , COALESCE (MIFloat_PriceWithVAT.ValueData, 0.0)::TFloat    AS PriceWithVAT
                  , COALESCE (MovementItem_PromoGoods.Amount, 0.0)::TFloat    AS TaxPromo
                  , (NOT MovementItem_PromoGoods.isErased)                    AS isSync
             FROM MovementItem AS MovementItem_PromoGoods
                  JOIN tmpPromoPartner ON tmpPromoPartner.ParentId = MovementItem_PromoGoods.MovementId
                  LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                   ON MILinkObject_GoodsKind.MovementItemId = MovementItem_PromoGoods.Id
                                                  AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind() 
                  LEFT JOIN MovementItemFloat AS MIFloat_PriceWithOutVAT
                                              ON MIFloat_PriceWithOutVAT.MovementItemId = MovementItem_PromoGoods.Id
                                             AND MIFloat_PriceWithOutVAT.DescId = zc_MIFloat_PriceWithOutVAT() 
                  LEFT JOIN MovementItemFloat AS MIFloat_PriceWithVAT
                                              ON MIFloat_PriceWithVAT.MovementItemId = MovementItem_PromoGoods.Id
                                             AND MIFloat_PriceWithVAT.DescId = zc_MIFloat_PriceWithVAT() 
             WHERE MovementItem_PromoGoods.DescId = zc_MI_Master();
      END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.   �������� �.�.
 17.03.17                                                                          *
*/

-- SELECT * FROM gpSelectMobile_MovementItem_PromoGoods (inSyncDateIn:= zc_DateStart(), inSession:= zfCalc_UserAdmin())
