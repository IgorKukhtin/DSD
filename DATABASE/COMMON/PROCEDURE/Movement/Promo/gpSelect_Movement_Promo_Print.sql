-- Function: gpSelect_Movement_Promo_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_Promo_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Promo_Print(
    IN inMovementId        Integer  , -- ���� ���������
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;
    DECLARE Cursor3 refcursor;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Promo());
    vbUserId:= inSession;

    OPEN Cursor1 FOR
        SELECT
            Movement_Promo.Id
          , Movement_Promo.InvNumber
          , Movement_Promo.OperDate
          , Movement_Promo.PromoKindName      --��� �����
          , Movement_Promo.StartPromo         --���� ������ �����
          , Movement_Promo.EndPromo           --���� ��������� �����
          , Movement_Promo.StartSale          --���� ������ �������� �� ��������� ����
          , Movement_Promo.EndSale            --���� ��������� �������� �� ��������� ����
          , Movement_Promo.OperDateStart      --���� ������ ����. ������ �� �����
          , Movement_Promo.OperDateEnd        --���� ��������� ����. ������ �� �����
          , Movement_Promo.CostPromo          --��������� ������� � �����
          , Movement_Promo.Comment            --����������
          , Movement_Promo.AdvertisingName    --��������� ���������
          , Movement_Promo.UnitName           --�������������
          , Movement_Promo.PersonalTradeName  --������������� ������������� ������������� ������
          , Movement_Promo.PersonalName       --������������� ������������� �������������� ������	
        FROM
            Movement_Promo_View AS Movement_Promo
        WHERE 
            Movement_Promo.Id = inMovementId;
    RETURN NEXT Cursor1;


    OPEN Cursor2 FOR
        SELECT
            MI_PromoGoods.Id               --�������������
          , MI_PromoGoods.GoodsCode        --��� �������  <�����>
          , MI_PromoGoods.GoodsName        --������������ ������� <�����>
          , MI_PromoGoods.Amount           --% ������ �� �����
          , MI_PromoGoods.Price            --���� � ������
          , MI_PromoGoods.PriceWithOutVAT  --���� �������� ��� ����� ���, � ������ ������, ���
          , MI_PromoGoods.PriceWithVAT     --���� �������� � ������ ���, � ������ ������, ���
          , MI_PromoGoods.AmountReal       --����� ������ � ����������� ������, ��
          , MI_PromoGoods.AmountPlanMin    --������� ������������ ������ ������ �� ��������� ������ (� ��)
          , MI_PromoGoods.AmountPlanMax    --�������� ������������ ������ ������ �� ��������� ������ (� ��)
          , MI_PromoGoods.GoodsKindName    --������������ ������� <��� ������>
        FROM
            MovementItem_PromoGoods_View AS MI_PromoGoods
        WHERE
            MI_PromoGoods.MovementId = inMovementId
            AND
            MI_PromoGoods.isErased = FALSE 
        ORDER BY
            MI_PromoGoods.GoodsKindName
          , MI_PromoGoods.GoodsName;

    RETURN NEXT Cursor2;

    OPEN Cursor3 FOR
        SELECT
            MI_PromoCondition.Id                 --�������������
          , MI_PromoCondition.ConditionPromoName --������������ ������� <������� ������� � �����>
          , MI_PromoCondition.Amount             --��������
        FROM
            MovementItem_PromoCondition_View AS MI_PromoCondition
        WHERE
            MI_PromoCondition.MovementId = inMovementId
            AND
            MI_PromoCondition.isErased = FALSE 
        ORDER BY
            MI_PromoCondition.PromoConditionName;

    RETURN NEXT Cursor3;
    
    OPEN Cursor4 FOR
        SELECT
            Movement_Promo.Id                 --�������������
          , Movement_Promo.PartnerId          --���������� ��� �����
          , Movement_Promo.PartnerName        --���������� ��� �����
          , Movement_Promo.PartnerDescName    --��� ���������� ��� �����
        FROM
            Movement_Promo_View AS Movement_Promo
        WHERE
            MI_PromoCondition.ParentId = inMovementId
        ORDER BY
            Movement_Promo.PartnerDescName
          , Movement_Promo.PartnerName;

    RETURN NEXT Cursor4;

    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_Promo_Print (Integer,TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ��������� �.�
 31.10.15                                                                       *
*/

-- SELECT * FROM gpSelect_Movement_Promo_Print (inMovementId := 570596, inSession:= '5');
