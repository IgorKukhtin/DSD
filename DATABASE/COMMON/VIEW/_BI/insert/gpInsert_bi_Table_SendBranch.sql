-- Function: gpInsert_bi_Table_SendBranch

DROP FUNCTION IF EXISTS gpInsert_bi_Table_SendBranch (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_bi_Table_SendBranch(
    IN inStartDate    TDateTime ,
    IN inEndDate      TDateTime ,
    IN inSession      TVarChar       -- ������ ������������
)
RETURNS VOID
AS
$BODY$
BEGIN
      -- inStartDate:='01.01.2025';
      --

      IF EXTRACT (HOUR FROM CURRENT_TIMESTAMP) NOT IN (11) OR 1=1
      THEN
          DELETE FROM _bi_Table_SendBranch WHERE OperDate BETWEEN inStartDate AND inEndDate;
      END IF;


      -- ���������
      INSERT INTO _bi_Table_SendBranch (-- Id ���������
                                         MovementId
                                         -- ���� ����������
                                       , OperDate
                                         -- ���� �����������
                                       , OperDate_sklad
                                         -- � ���������
                                       , InvNumber

                                         -- ������������� - ������ �� ����
                                       , UnitId_from
                                         -- ������������� - ������ ���� - �����
                                       , UnitId_to

                                         -- �����
                                       , GoodsId
                                         -- ��� ������
                                       , GoodsKindId

                                         -- �������� ������ ����������
                                       , MovementId_order

                                         -- �������� �����
                                       , MovementId_promo

                                         -- ��� �����������
                                       , Amount
                                         -- ��.
                                       , Amount_sh

                                         -- ��� ����������
                                       , AmountPartner
                                         -- ��.
                                       , AmountPartner_sh

                                         -- ����� - ����������
                                       , AmountPartner_promo
                                         -- ��.
                                       , AmountPartner_promo_sh

                                         -- ����� � ��� ����������
                                       , SummPartner
                                         -- ����� - ����� � ��� ����������
                                       , SummPartner_promo
                                        )
              -- ���������
              SELECT -- Id ���������
                     Movement.Id                            AS MovementId
                     -- ���� ����������
                   , MovementDate_OperDatePartner.ValueData AS OperDate
                     -- ���� �����������
                   , Movement.OperDate                      AS OperDate_sklad
                     -- � ���������
                   , zfConvert_StringToNumber (Movement.InvNumber) AS InvNumber

                     -- ������������� - ������ �� ����
                   , Object_From.Id                              AS UnitId_from
                   --, Object_From.ValueData                       AS UnitName_from

                     -- ������������� - ������ ���� - �����
                   , Object_To.Id                                AS UnitId_to
                   --, Object_To.ValueData                         AS UnitName_to

                     -- �����
                   , MovementItem.ObjectId                       AS GoodsId
                   --, Object_Goods.ObjectCode                     AS GoodsCode
                   --, Object_Goods.ValueData                      AS GoodsName
                     -- ��� ������
                   , MILinkObject_GoodsKind.ObjectId             AS GoodsKindId
                   --, Object_GoodsKind.ObjectCode                 AS GoodsKindCode
                   --, Object_GoodsKind.ValueData                  AS GoodsKindName
                     -- ��.���. ������
                   --, Object_Measure.ObjectCode                   AS MeasureCode
                   --, Object_Measure.ValueData                    AS MeasureName

                     -- �������� ������ ����������
                   , MLM_Order.MovementChildId                   AS MovementId_order
                     -- �������� �����
                   , MIFloat_PromoMovement.ValueData  :: Integer AS MovementId_promo
                     -- ������� ����� ��/���
                   --, CASE WHEN MIFloat_PromoMovement.ValueData > 0 THEN TRUE ELSE FALSE END :: Boolean AS isPromo

                     -- ��� �����������
                   ,  (MovementItem.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END
                      ) :: TFloat AS Amount
                     -- ��.
                   ,  (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                                 THEN MovementItem.Amount
                            ELSE 0
                       END) :: TFloat AS Amount_sh

                     -- ��� ����������
                   ,  (COALESCE (MIFloat_AmountPartner.ValueData, 0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END
                      ) :: TFloat AS AmountPartner
                     -- ��.
                   ,  (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                                 THEN COALESCE (MIFloat_AmountPartner.ValueData, 0)
                            ELSE 0
                       END) :: TFloat AS AmountPartner_sh

                     -- ����� - ����������
                   ,  (CASE WHEN MIFloat_PromoMovement.ValueData > 0 THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END
                     * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END
                      ) :: TFloat AS AmountPartner_promo
                     -- ��.
                   ,  (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() AND MIFloat_PromoMovement.ValueData > 0
                                 THEN COALESCE (MIFloat_AmountPartner.ValueData, 0)
                            ELSE 0
                      END) :: TFloat AS AmountPartner_promo_sh

                     -- ����� � ��� ����������
                   ,  (1.2 * COALESCE (MIFloat_AmountPartner.ValueData, 0) * COALESCE (MIFloat_Price.ValueData, 0)
                     / CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END
                      ) :: TFloat AS Summ

                     -- ����� - ����� � ��� ����������
                   ,  (CASE WHEN MIFloat_PromoMovement.ValueData > 0
                                    THEN 1.2 * COALESCE (MIFloat_AmountPartner.ValueData, 0) * COALESCE (MIFloat_Price.ValueData, 0)
                                       / CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END
                               ELSE 0
                          END) :: TFloat AS Summ_promo


              FROM Movement
                   -- ������������� - ������ �� ����
                   LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                ON MovementLinkObject_From.MovementId = Movement.Id
                                               AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                   LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
                   -- ������������� - ������ ���� - �����
                   LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                ON MovementLinkObject_To.MovementId = Movement.Id
                                               AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                   LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

                   -- ���� �������� �����������
                   LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                          ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                         AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                   -- �����������
                   LEFT JOIN MovementString AS MovementString_Comment
                                            ON MovementString_Comment.MovementId = Movement.Id
                                           AND MovementString_Comment.DescId     = zc_MovementString_Comment()
                   -- �������� ������ ����������
                   LEFT JOIN MovementLinkMovement AS MLM_Order
                                                  ON MLM_Order.MovementId = Movement.Id
                                                 AND MLM_Order.DescId     = zc_MovementLinkMovement_Order()

                   -- ������ ���������
                   LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                         AND MovementItem.DescId     = zc_MI_Master()
                                         AND MovementItem.isErased   = FALSE
                   -- �����
                   LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

                   -- ��� �������
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                    ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                   LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

                   -- ���������� �������
                   LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                               ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                              AND MIFloat_AmountPartner.DescId         = zc_MIFloat_AmountPartner()
                   -- ����
                   LEFT JOIN MovementItemFloat AS MIFloat_Price
                                               ON MIFloat_Price.MovementItemId = MovementItem.Id
                                              AND MIFloat_Price.DescId = zc_MIFloat_Price()
                   -- ���� �� ����������
                   LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                               ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                              AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

                   -- �������� �����
                   LEFT JOIN MovementItemFloat AS MIFloat_PromoMovement
                                               ON MIFloat_PromoMovement.MovementItemId = MovementItem.Id
                                              AND MIFloat_PromoMovement.DescId         = zc_MIFloat_PromoMovementId()

                   -- ��.���. ������
                   LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                        ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                       AND ObjectLink_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()
                   LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

                   -- ��� ������
                   LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                         ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                                        AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()

              WHERE Movement.DescId   = zc_Movement_SendOnPrice()
                AND Movement.StatusId = zc_Enum_Status_Complete()
                AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                -- !!! ������ ĳ������ ����� � ��������� �`���� �������� + ��
                AND Object_From.Id IN (zc_Unit_RK()) -- 133049,
             ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 11.07.25                                        * all
*/

-- ����
-- DELETE FROM  _bi_Table_SendBranch WHERE OperDate between '20.07.2025 9:00' and '20.07.2025 9:10'
-- SELECT DATE_TRUNC ('MONTH', OperDate), sum(Amount), sum(SummPartner), COUNT(*) FROM _bi_Table_SendBranch where  OperDate between '01.01.2025' and '28.09.2025' GROUP BY DATE_TRUNC ('MONTH', OperDate) ORDER BY 1 DESC
-- SELECT * FROM gpInsert_bi_Table_SendBranch (inStartDate:= '01.01.2025', inEndDate:= '28.09.2025', inSession:= zfCalc_UserAdmin())
