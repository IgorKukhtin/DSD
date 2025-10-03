-- ��� ����� �� ���� �� ����� + ���������� + ������� + �������������
-- Function: lpGet_Movement_Promo_Data_all()

-- DROP FUNCTION IF EXISTS lpGet_Movement_Promo_Data_test (TDateTime, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpGet_Movement_Promo_Data_all (TDateTime, Integer, Integer, Integer, Integer, Integer, Boolean);

CREATE OR REPLACE FUNCTION lpGet_Movement_Promo_Data_all(
    IN inOperDate     TDateTime , --
    IN inPartnerId    Integer   , --
    IN inContractId   Integer   , --
    IN inUnitId       Integer   , --
    IN inGoodsId      Integer   , --
    IN inGoodsKindId  Integer   , --
    IN inIsReturn     Boolean     --
)
RETURNS TABLE (MovementId            Integer -- ��������

             , TaxPromo              TFloat  -- % ��� ����� ������
             , PromoDiscountKindId   Integer -- ��� ������ - % ��� �����

             , PriceWithOutVAT       TFloat  -- ���� �������� ��� ���, � ������ ������, ���
             , PriceWithVAT          TFloat  -- ���� �������� � ���, � ������ ������, ���
             , CountForPrice         TFloat
             , PriceWithOutVAT_orig  TFloat  -- ���� �������� ��� ����� ���, � ������ ������, ���
             , PriceWithVAT_orig     TFloat  -- ���� �������� � ������ ���, � ������ ������, ���

             , isChangePercent       Boolean -- ��������� % ������ �� ��������

               -- �����-��������
             , PromoSchemaKindId     Integer
               -- ����� (���� ��������), ���� �� ���� - ����� �����-��������
             , GoodsId_out           Integer
             , GoodsKindId_out       Integer
               -- �������� m
             , Value_m               TFloat
               -- �������� n
             , Value_n               TFloat
              )
AS
$BODY$
   DECLARE vbDescId_EndDate Integer;
BEGIN

     -- ����������
     vbDescId_EndDate:= CASE WHEN inIsReturn = TRUE THEN zc_MovementDate_EndReturn() ELSE zc_MovementDate_EndSale() END;


     -- ���������
     RETURN QUERY
        WITH tmpDate_all AS
                      (SELECT MovementDate_End_calc.MovementId
                            , MovementDate_StartSale.ValueData AS StartDate
                       FROM MovementDate AS MovementDate_End_calc
                            LEFT JOIN MovementDate AS MovementDate_StartSale
                                                   ON MovementDate_StartSale.MovementId = MovementDate_End_calc.MovementId
                                                  AND MovementDate_StartSale.DescId     = zc_MovementDate_StartSale()
                       WHERE MovementDate_End_calc.ValueData >= inOperDate
                         AND MovementDate_End_calc.DescId     = vbDescId_EndDate
                      )
           , tmpDate AS
                      (SELECT tmpDate_all.MovementId
                       FROM tmpDate_all
                       WHERE tmpDate_all.StartDate <= inOperDate
                      )
           , tmpMovement_all AS
                      (SELECT Movement.Id AS MovementId
                            , Movement.StatusId
                       FROM Movement
                       WHERE Movement.Id     IN (SELECT DISTINCT tmpDate.MovementId FROM tmpDate)
                         AND Movement.DescId = zc_Movement_Promo()
                      )
           , tmpMI_all AS
                      (SELECT MovementItem.Id          AS MovementItemId
                            , MovementItem.MovementId  AS MovementId
                            , MovementItem.Amount      AS TaxPromo
                            , MovementItem.ObjectId    AS GoodsId
                            , MovementItem.isErased    AS isErased
                       FROM MovementItem
                       WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpDate.MovementId FROM tmpDate)
                         AND MovementItem.DescId     = zc_MI_Master()
                      )
           , tmpMovement AS
                      (SELECT tmpMovement_all.MovementId  AS MovementId
                            , tmpMI_all.MovementItemId    AS MovementItemId
                            , tmpMI_all.TaxPromo          AS TaxPromo
                       FROM tmpMovement_all
                            INNER JOIN tmpMI_all ON tmpMI_all.MovementId = tmpMovement_all.MovementId
                                                AND tmpMI_all.GoodsId    = inGoodsId
                                                AND tmpMI_all.isErased   = FALSE
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                             ON MILinkObject_GoodsKind.MovementItemId = tmpMI_all.MovementItemId
                                                            AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                                                          --AND 1 = 0 -- !!!

                       WHERE tmpMovement_all.StatusId = zc_Enum_Status_Complete()
                         AND (MILinkObject_GoodsKind.ObjectId = inGoodsKindId OR COALESCE (MILinkObject_GoodsKind.ObjectId, 0) = 0)
                      )
           , tmpMovement_PromoPartner AS
                      (SELECT Movement.ParentId AS MovementId_parent
                            , Movement.Id       AS MovementId
                            , Movement.StatusId
                            , Movement.DescId
                       FROM Movement
                       WHERE Movement.ParentId IN (SELECT DISTINCT tmpMovement.MovementId FROM tmpMovement)
                         AND Movement.StatusId <> zc_Enum_Status_Erased()
                         -- AND Movement.DescId = zc_Movement_PromoPartner()
                      )
           , tmpMLO AS
                      (SELECT MovementLinkObject.MovementId
                            , MovementLinkObject.DescId
                            , MovementLinkObject.ObjectId
                       FROM MovementLinkObject
                       WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovement_PromoPartner.MovementId FROM tmpMovement_PromoPartner)
                      )
       , tmpPartner_all AS
                      (SELECT tmpMovement.MovementId
                            , tmpMovement.MovementItemId
                            , tmpMovement.TaxPromo
                            , COALESCE (MLO_Partner.ObjectId, 0) AS ObjectId
                            , Object_by.DescId                   AS ObjectDescId
                       FROM tmpMovement
                            INNER JOIN tmpMovement_PromoPartner ON tmpMovement_PromoPartner.MovementId_parent = tmpMovement.MovementId
                            LEFT JOIN tmpMLO AS MLO_Partner
                                             ON MLO_Partner.MovementId = tmpMovement_PromoPartner.MovementId
                                            AND MLO_Partner.DescId     = zc_MovementLinkObject_Partner()
                            LEFT JOIN Object AS Object_by ON Object_by.Id = MLO_Partner.ObjectId
                            LEFT JOIN tmpMLO AS MLO_Contract
                                             ON MLO_Contract.MovementId = tmpMovement_PromoPartner.MovementId
                                            AND MLO_Contract.DescId     = zc_MovementLinkObject_Contract()
                            LEFT JOIN tmpMLO AS MLO_Unit
                                             ON MLO_Unit.MovementId = tmpMovement.MovementId
                                            AND MLO_Unit.DescId     = zc_MovementLinkObject_Unit()
                       WHERE (MLO_Contract.ObjectId = inContractId OR COALESCE (MLO_Contract.ObjectId, 0) = 0)
                         AND (MLO_Unit.ObjectId     = inUnitId     OR COALESCE (MLO_Unit.ObjectId, 0) = 0)
                         AND (MLO_Partner.ObjectId  = inPartnerId  OR Object_by.DescId <> zc_Object_Partner())
                      )
       , tmpResult AS (-- �����������
                       SELECT tmpPartner_all.MovementId
                            , tmpPartner_all.MovementItemId
                            , tmpPartner_all.TaxPromo
                       FROM tmpPartner_all
                       WHERE tmpPartner_all.ObjectDescId = zc_Object_Partner()
                      UNION
                       -- �� ��. ���
                       SELECT tmpPartner_all.MovementId
                            , tmpPartner_all.MovementItemId
                            , tmpPartner_all.TaxPromo
                       FROM tmpPartner_all
                            INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                  ON ObjectLink_Partner_Juridical.ChildObjectId = tmpPartner_all.ObjectId
                                                 AND ObjectLink_Partner_Juridical.DescId        = zc_ObjectLink_Partner_Juridical()
                                                 AND ObjectLink_Partner_Juridical.ObjectId      = inPartnerId
                       WHERE tmpPartner_all.ObjectDescId = zc_Object_Juridical()
                      UNION
                       -- �� �������� ����
                       SELECT tmpPartner_all.MovementId
                            , tmpPartner_all.MovementItemId
                            , tmpPartner_all.TaxPromo
                       FROM tmpPartner_all
                            INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                  ON ObjectLink_Juridical_Retail.ChildObjectId = tmpPartner_all.ObjectId
                                                 AND ObjectLink_Juridical_Retail.DescId        = zc_ObjectLink_Juridical_Retail()
                            INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                  ON ObjectLink_Partner_Juridical.ChildObjectId = ObjectLink_Juridical_Retail.ObjectId
                                                 AND ObjectLink_Partner_Juridical.DescId        = zc_ObjectLink_Partner_Juridical()
                                                 AND ObjectLink_Partner_Juridical.ObjectId      = inPartnerId
                       WHERE tmpPartner_all.ObjectDescId = zc_Object_Retail()
                      )
       , tmpChangePercent AS
                      (SELECT DISTINCT
                              tmpResult.MovementId
                       FROM tmpResult
                            INNER JOIN MovementItem AS MI_Child
                                                    ON MI_Child.MovementId = tmpResult.MovementId
                                                   AND MI_Child.ObjectId = zc_Enum_ConditionPromo_ContractChangePercentOff() -- ��� ����� % ������ �� ��������
                                                   AND MI_Child.isErased   = FALSE
                      )
        SELECT DISTINCT
               tmpResult.MovementId

               -- % ��� ����� ������
             , tmpResult.TaxPromo
               -- ��� ������ - % ��� �����
             , COALESCE (MILinkObject_PromoDiscountKind.ObjectId, 0) :: Integer AS PromoDiscountKindId

               -- ���� �������� ��� ���, � ������ ������
             , (COALESCE (MIFloat_PriceWithOutVAT.ValueData, 0) / CASE WHEN MIFloat_CountForPrice.ValueData > 1 THEN MIFloat_CountForPrice.ValueData ELSE 1 END) :: TFloat AS PriceWithOutVAT
               -- ���� �������� � ���, � ������ ������
             , (COALESCE (MIFloat_PriceWithVAT.ValueData, 0)    / CASE WHEN MIFloat_CountForPrice.ValueData > 1 THEN MIFloat_CountForPrice.ValueData ELSE 1 END) :: TFloat AS PriceWithVAT
               --
             , CASE WHEN MIFloat_CountForPrice.ValueData > 1 THEN MIFloat_CountForPrice.ValueData ELSE 1 END :: TFloat AS CountForPrice
               -- ***���� ��� ���, � ������ ������
             , COALESCE (MIFloat_PriceWithOutVAT.ValueData, 0) :: TFloat AS PriceWithOutVAT_orig
               -- ***���� � ���, � ������ ������
             , COALESCE (MIFloat_PriceWithVAT.ValueData, 0)    :: TFloat AS PriceWithVAT_orig

               -- ��� ����� % ������ �� ��������
             , CASE WHEN tmpChangePercent.MovementId > 0 THEN FALSE ELSE TRUE END :: Boolean AS isChangePercent

               -- �����-��������
             , COALESCE (MLO_PromoSchemaKind.ObjectId, 0)        :: Integer AS PromoSchemaKindId
               -- ����� (���� ��������), ���� �� ���� - ����� �����-��������
             , COALESCE (MILinkObject_Goods_out.ObjectId, 0)     :: Integer AS GoodsId_out
             , COALESCE (MILinkObject_GoodsKind_out.ObjectId, 0) :: Integer AS GoodsKindId_out
               -- �������� m
             , COALESCE (MIFloat_Value_m.ValueData, 0)           :: TFloat  AS Value_m
               -- �������� n
             , COALESCE (MIFloat_Value_n.ValueData, 0)           :: TFloat  AS Value_n

        FROM tmpResult
             LEFT JOIN MovementItemFloat AS MIFloat_PriceWithOutVAT
                                         ON MIFloat_PriceWithOutVAT.MovementItemId = tmpResult.MovementItemId
                                        AND MIFloat_PriceWithOutVAT.DescId         = zc_MIFloat_PriceWithOutVAT()
             LEFT JOIN MovementItemFloat AS MIFloat_PriceWithVAT
                                         ON MIFloat_PriceWithVAT.MovementItemId = tmpResult.MovementItemId
                                        AND MIFloat_PriceWithVAT.DescId         = zc_MIFloat_PriceWithVAT()
             LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                         ON MIFloat_CountForPrice.MovementItemId = tmpResult.MovementItemId
                                        AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
             LEFT JOIN tmpChangePercent ON tmpChangePercent.MovementId = tmpResult.MovementId

             -- �����-��������
             LEFT JOIN MovementLinkObject AS MLO_PromoSchemaKind
                                          ON MLO_PromoSchemaKind.MovementId = tmpResult.MovementId
                                         AND MLO_PromoSchemaKind.DescId     = zc_MovementLinkObject_PromoSchemaKind()

             -- ��� ������ - % ��� �����
             LEFT JOIN MovementItemLinkObject AS MILinkObject_PromoDiscountKind
                                              ON MILinkObject_PromoDiscountKind.MovementItemId = tmpResult.MovementItemId
                                             AND MILinkObject_PromoDiscountKind.DescId         = zc_MILinkObject_PromoDiscountKind()
             -- ����� (���� ��������), ���� �� ���� - ����� �����-��������
             LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods_out
                                              ON MILinkObject_Goods_out.MovementItemId = tmpResult.MovementItemId
                                             AND MILinkObject_Goods_out.DescId         = zc_MILinkObject_Goods_out()
             -- ���� ������� (���� ��������), ���� �� ���� - ����� �����-��������
             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind_out
                                              ON MILinkObject_GoodsKind_out.MovementItemId = tmpResult.MovementItemId
                                             AND MILinkObject_GoodsKind_out.DescId         = zc_MILinkObject_GoodsKind_out()
             -- �������� m
             LEFT JOIN MovementItemFloat AS MIFloat_Value_m
                                         ON MIFloat_Value_m.MovementItemId = tmpResult.MovementItemId
                                        AND MIFloat_Value_m.DescId         = zc_MIFloat_Value_m()
             -- �������� n
             LEFT JOIN MovementItemFloat AS MIFloat_Value_n
                                         ON MIFloat_Value_n.MovementItemId = tmpResult.MovementItemId
                                        AND MIFloat_Value_n.DescId         = zc_MIFloat_Value_n()

       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ��������� �.�.
 21.08.16                                        *
 29.11.15                                        *
*/

-- ����
-- SELECT * FROM lpGet_Movement_Promo_Data_all (inOperDate:= CURRENT_DATE, inPartnerId:= 324124, inContractId:= NULL, inUnitId:= 0, inGoodsId:= 2524, inGoodsKindId:= NULL, inIsReturn:= FALSE) AS tmp LEFT JOIN Movement ON Movement.Id = MovementId
