-- Function: gpSelect_Movement_Promo_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_Promo_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Promo_Print(
    IN inMovementId        Integer  , -- ���� ���������
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS TABLE(LineNo Integer,
              GroupName TVarChar,
              LineName TVarChar,
              LineValue TEXT)
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbValue TVarChar; 
    
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Promo());
    vbUserId:= inSession;

    RETURN QUERY
        SELECT
            1 as LineNo,
            ''::TVarChar as GroupName,
            '���� (������������ ����, ������� �� ������� ���������������� �����)'::TVarChar as LineName,
            (SELECT STRING_AGG(Movement_PromoPartner.PartnerName, chr(13)||chr(10)) 
             FROM Movement_PromoPartner_View AS Movement_PromoPartner 
             WHERE Movement_PromoPartner.ParentId = inMovementId)::TEXT AS LineValue
        UNION ALL
        SELECT
            2 as LineNo,
            ''::TVarChar as GroupName,
            '������ ����� (�� �����)'::TVarChar as LineName,
            (SELECT 
                CAST(Movement_Promo.StartPromo as TVarChar)||' - '||CAST(Movement_Promo.EndPromo as TVarChar)
             FROM Movement_Promo_View AS Movement_Promo
             WHERE Movement_Promo.Id = inMovementId)::TEXT AS LineValue
        UNION ALL
        SELECT
            3 as LineNo,
            ''::TVarChar as GroupName,
            '������ �������� �� ��������� ���� � ����'::TVarChar as LineName,
            (SELECT 
                CAST(Movement_Promo.StartSale as TVarChar)||' - '||CAST(Movement_Promo.EndSale as TVarChar)
             FROM Movement_Promo_View AS Movement_Promo
             WHERE Movement_Promo.Id = inMovementId)::TEXT AS LineValue
        UNION ALL
        SELECT
            4 as LineNo,
            ''::TVarChar as GroupName,
            '��������� �������, ���'::TVarChar as LineName,
            (SELECT 
                CAST(Movement_Promo.CostPromo as TVarChar)
             FROM Movement_Promo_View AS Movement_Promo
             WHERE Movement_Promo.Id = inMovementId)::TEXT AS LineValue
        UNION ALL
        SELECT
            5 as LineNo,
            ''::TVarChar as GroupName,
            '������� ������� (� ���� �������������� ������� ��� �� ������������� �����)'::TVarChar as LineName,
            (SELECT STRING_AGG(MovementItem_PromoCondition.ConditionPromoName||chr(9)||CAST(MovementItem_PromoCondition.Amount as TVarChar), chr(13)||chr(10)) 
             FROM MovementItem_PromoCondition_View AS MovementItem_PromoCondition 
             WHERE MovementItem_PromoCondition.MovementId = inMovementId)::TEXT AS LineValue
        UNION ALL
        SELECT
            6 as LineNo,
            ''::TVarChar as GroupName,
            '�������'::TVarChar as LineName,
            (SELECT STRING_AGG(MI_PromoGoods.GoodsName, chr(13)||chr(10)) 
             FROM MovementItem_PromoGoods_View AS MI_PromoGoods
             WHERE MI_PromoGoods.MovementId = inMovementId)::TEXT AS LineValue
        UNION ALL
        SELECT
            7 as LineNo,
            ''::TVarChar as GroupName,
            '% �������������� ������'::TVarChar as LineName,
            (SELECT STRING_AGG(CAST(MI_PromoGoods.Amount AS TVarChar)||'%'||chr(9)||MI_PromoGoods.GoodsName, chr(13)||chr(10)) 
             FROM MovementItem_PromoGoods_View AS MI_PromoGoods
             WHERE MI_PromoGoods.MovementId = inMovementId)::TEXT AS LineValue
        UNION ALL
        SELECT
            8 as LineNo,
            ''::TVarChar as GroupName,
            '���� �������� ��� ����� ���, � ������ ������, ���'::TVarChar as LineName,
            (SELECT STRING_AGG(CAST(MI_PromoGoods.PriceWithOutVAT AS TVarChar)||'���.'||chr(9)||MI_PromoGoods.GoodsName, chr(13)||chr(10)) 
             FROM MovementItem_PromoGoods_View AS MI_PromoGoods
             WHERE MI_PromoGoods.MovementId = inMovementId)::TEXT AS LineValue
        UNION ALL
        SELECT
            9 as LineNo,
            ''::TVarChar as GroupName,
            '���� �������� � ������ ���, � ������ ������, ���'::TVarChar as LineName,
            (SELECT STRING_AGG(CAST(MI_PromoGoods.PriceWithVAT AS TVarChar)||'���.'||chr(9)||MI_PromoGoods.GoodsName, chr(13)||chr(10)) 
             FROM MovementItem_PromoGoods_View AS MI_PromoGoods
             WHERE MI_PromoGoods.MovementId = inMovementId)::TEXT AS LineValue
        UNION ALL
        SELECT
            10 as LineNo,
            ''::TVarChar as GroupName,
            '����� ������ � ����������� ������, ��'::TVarChar as LineName,
            (SELECT STRING_AGG(CAST(MI_PromoGoods.AmountReal AS TVarChar)||'��'||chr(9)||MI_PromoGoods.GoodsName, chr(13)||chr(10)) 
             FROM MovementItem_PromoGoods_View AS MI_PromoGoods
             WHERE MI_PromoGoods.MovementId = inMovementId)::TEXT AS LineValue
        UNION ALL
        SELECT
            11 as LineNo,
            ''::TVarChar as GroupName,
            '����������� ����� ������ �� ��������� ������ (� ��)'::TVarChar as LineName,
            (SELECT STRING_AGG(CAST(MI_PromoGoods.AmountPlanMin AS TVarChar)||' - '||CAST(MI_PromoGoods.AmountPlanMax AS TVarChar)||chr(9)||MI_PromoGoods.GoodsName, chr(13)||chr(10)) 
             FROM MovementItem_PromoGoods_View AS MI_PromoGoods
             WHERE MI_PromoGoods.MovementId = inMovementId)::TEXT AS LineValue
        UNION ALL
        SELECT
            12 as LineNo,
            ''::TVarChar as GroupName,
            '��� ��������'::TVarChar as LineName,
            (SELECT STRING_AGG(MI_PromoGoods.GoodsName||': '||MI_PromoGoods.GoodsKindName, chr(13)||chr(10)) 
             FROM MovementItem_PromoGoods_View AS MI_PromoGoods
             WHERE MI_PromoGoods.MovementId = inMovementId)::TEXT AS LineValue
        UNION ALL
        SELECT
            13 as LineNo,
            ''::TVarChar as GroupName,
            '���������� ������ ������������� � ������ ����� � ������ ���� ��������, ��'::TVarChar as LineName,
            (SELECT STRING_AGG('_______'||Chr(9)||MI_PromoGoods.GoodsName, chr(13)||chr(10)) 
             FROM MovementItem_PromoGoods_View AS MI_PromoGoods
             WHERE MI_PromoGoods.MovementId = inMovementId)::TEXT AS LineValue
        UNION ALL
        SELECT
            13 as LineNo,
            ''::TVarChar as GroupName,
            '��������� ��������� (������, ������������� �������� �������� (����-�������, ����������), ��, �����, ���������� � ������)'::TVarChar as LineName,
            (SELECT Movement_Promo.AdvertisingName 
             FROM Movement_Promo_View AS Movement_Promo
             WHERE Movement_Promo.Id = inMovementId)::TEXT AS LineValue
        UNION ALL
        SELECT
            NULL as LineNo,
            '�������������� ����������'::TVarChar as GroupName,
            '���� � �����-����� (���)'::TVarChar as LineName,
            (SELECT STRING_AGG(CAST(MI_PromoGoods.Price AS TVarChar)||'���.'||chr(9)||MI_PromoGoods.GoodsName, chr(13)||chr(10)) 
             FROM MovementItem_PromoGoods_View AS MI_PromoGoods
             WHERE MI_PromoGoods.MovementId = inMovementId)::TEXT AS LineValue
        UNION ALL
        SELECT
            NULL as LineNo,
            '�������������� ����������'::TVarChar as GroupName,
            '������������� ������������� ������������� ������'::TVarChar as LineName,
            (SELECT Movement_Promo.PersonalTradeName 
             FROM Movement_Promo_View AS Movement_Promo
             WHERE Movement_Promo.Id = inMovementId)::TEXT AS LineValue
        UNION ALL
        SELECT
            NULL as LineNo,
            '�������������� ����������'::TVarChar as GroupName,
            '������������� ������������� �������������� ������'::TVarChar as LineName,
            (SELECT Movement_Promo.PersonalName 
             FROM Movement_Promo_View AS Movement_Promo
             WHERE Movement_Promo.Id = inMovementId)::TEXT AS LineValue;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_Promo_Print (Integer,TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ��������� �.�
 31.10.15                                                                       *
*/

-- SELECT * FROM gpSelect_Movement_Promo_Print (inMovementId := 2139691, inSession:= '5');
