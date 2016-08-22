-- ��� ����� �� ���� �� ����� + ���������� + ������� + �������������
-- Function: lpGet_Movement_Promo_Data_all()

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
RETURNS TABLE (MovementId          Integer -- ��������
             , TaxPromo            TFloat  
             , PriceWithOutVAT     TFloat  -- ���� �������� ��� ����� ���, � ������ ������, ���
             , PriceWithVAT        TFloat  -- ���� �������� � ������ ���, � ������ ������, ���
             , isChangePercent     Boolean -- ��������� % ������ �� ��������
              )
AS
$BODY$
BEGIN
     -- ���������
     RETURN QUERY
        WITH tmpMovement AS 
                      (SELECT Movement.Id                                        AS MovementId
                            , MovementItem.Id                                    AS MovementItemId
                            , MovementItem.Amount                                AS TaxPromo
                       FROM (SELECT inOperDate AS OperDate, CASE WHEN inIsReturn = TRUE THEN zc_MovementDate_EndReturn() ELSE zc_MovementDate_EndSale() END AS DescId_calc) AS tmp
                            INNER JOIN MovementDate AS MovementDate_StartSale
                                                    ON MovementDate_StartSale.ValueData <= tmp.OperDate
                                                   AND MovementDate_StartSale.DescId    = zc_MovementDate_StartSale()
                            INNER JOIN MovementDate AS MovementDate_End_calc
                                                    ON MovementDate_End_calc.ValueData >= tmp.OperDate
                                                   AND MovementDate_End_calc.MovementId =  MovementDate_StartSale.MovementId
                                                   AND MovementDate_End_calc.DescId     = tmp.DescId_calc
                            INNER JOIN Movement ON Movement.DescId   = zc_Movement_Promo()
                                               AND Movement.Id       = MovementDate_StartSale.MovementId
                                               AND Movement.StatusId = zc_Enum_Status_Complete()
                            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                   AND MovementItem.DescId     = zc_MI_Master()
                                                   AND MovementItem.ObjectId   = inGoodsId
                                                   AND MovementItem.isErased   = FALSE
                            /*LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                                                            AND 1 = 0 -- !!!*/

                       -- WHERE (MILinkObject_GoodsKind.ObjectId = inGoodsKindId OR COALESCE (MILinkObject_GoodsKind.ObjectId, 0) = 0)
                      )
       , tmpPartner_all AS 
                      (SELECT tmpMovement.MovementId
                            , tmpMovement.MovementItemId
                            , tmpMovement.TaxPromo
                            , COALESCE (MLO_Partner.ObjectId, 0) AS ObjectId
                            , Object_by.DescId                   AS ObjectDescId
                       FROM tmpMovement
                            INNER JOIN Movement AS Movement_PromoPartner
                                                ON Movement_PromoPartner.ParentId = tmpMovement.MovementId
                                               AND Movement_PromoPartner.DescId   = zc_Movement_PromoPartner()
                                               AND Movement_PromoPartner.StatusId <> zc_Enum_Status_Erased()
                            LEFT JOIN MovementLinkObject AS MLO_Partner
                                                         ON MLO_Partner.MovementId = Movement_PromoPartner.Id
                                                        AND MLO_Partner.DescId     = zc_MovementLinkObject_Partner()
                            LEFT JOIN Object AS Object_by ON Object_by.Id = MLO_Partner.ObjectId
                            LEFT JOIN MovementLinkObject AS MLO_Contract
                                                         ON MLO_Contract.MovementId = Movement_PromoPartner.Id
                                                        AND MLO_Contract.DescId     = zc_MovementLinkObject_Contract()
                            LEFT JOIN MovementLinkObject AS MLO_Unit
                                                         ON MLO_Unit.MovementId = tmpMovement.MovementId
                                                        AND MLO_Unit.DescId = zc_MovementLinkObject_Unit()
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
             , tmpResult.TaxPromo
             , COALESCE (MIFloat_PriceWithOutVAT.ValueData, 0) :: TFloat AS PriceWithOutVAT
             , COALESCE (MIFloat_PriceWithVAT.ValueData, 0)    :: TFloat AS PriceWithVAT
             , CASE WHEN tmpChangePercent.MovementId > 0 THEN FALSE ELSE TRUE END :: Boolean AS isChangePercent
        FROM tmpResult
             LEFT JOIN MovementItemFloat AS MIFloat_PriceWithOutVAT
                                         ON MIFloat_PriceWithOutVAT.MovementItemId = tmpResult.MovementItemId
                                        AND MIFloat_PriceWithOutVAT.DescId = zc_MIFloat_PriceWithOutVAT()
             LEFT JOIN MovementItemFloat AS MIFloat_PriceWithVAT
                                         ON MIFloat_PriceWithVAT.MovementItemId = tmpResult.MovementItemId
                                        AND MIFloat_PriceWithVAT.DescId = zc_MIFloat_PriceWithVAT()
             LEFT JOIN tmpChangePercent ON tmpChangePercent.MovementId = tmpResult.MovementId
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
