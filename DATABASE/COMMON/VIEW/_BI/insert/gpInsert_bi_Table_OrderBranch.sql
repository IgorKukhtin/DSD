-- Function: gpInsert_bi_Table_OrderBranch

DROP FUNCTION IF EXISTS gpInsert_bi_Table_OrderBranch (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_bi_Table_OrderBranch(
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
          DELETE FROM _bi_Table_OrderBranch WHERE OperDate BETWEEN inStartDate AND inEndDate;
      END IF;


      -- ���������
      INSERT INTO _bi_Table_OrderBranch (-- Id ���������
                                         MovementId
                                         -- ���� ������
                                       , OperDate
                                         -- ���� �����
                                       , OperDate_sklad
                                         -- ���� ������
                                       , OperDate_order
                                         -- � ���������
                                       , InvNumber

                                         -- ������������� - ������ �� ����
                                       , UnitId_from
                                         -- ������������� - ������ ���� - �����
                                       , UnitId_to

                                       , Comment
                                       , Comment_car

                                         -- �����
                                       , GoodsId
                                         -- ��� ������
                                       , GoodsKindId

                                         -- �������� �����
                                       , MovementId_promo

                                         -- ��� ����� �����
                                       , Amount
                                         -- ��.
                                       , Amount_sh

                                         -- ��� �����
                                       , AmountFirst
                                         -- ��.
                                       , AmountFirst_sh

                                         -- ��� �������
                                       , AmountSecond
                                         -- ��.
                                       , AmountSecond_sh

                                         -- ����� - ����� �����
                                       , Amount_promo
                                         -- ��.
                                       , Amount_promo_sh


                                         -- ����� � ��� ����� �����
                                       , Summ
                                         -- ����� - ����� � ��� �����
                                       , Summ_promo
                                        )
              -- ���������
              SELECT -- Id ���������
                     Movement.Id                            AS MovementId
                     -- ���� ������
                   , MovementDate_OperDatePartner.ValueData AS OperDate
                     -- ���� �����
                   , MovementDate_OperDatePartner.ValueData AS OperDate_sklad
                     -- ���� ������
                   , Movement.OperDate AS OperDate_order
                     -- � ���������
                   , zfConvert_StringToNumber (Movement.InvNumber)            AS InvNumber

                     -- ������������� - ������ �� ����
                   , Object_From.Id                                AS UnitId_from
                   --, Object_From.ValueData                         AS UnitName_from

                     -- ������������� - ������ ���� - �����
                   , Object_To.Id                                AS UnitId_to
                   --, Object_To.ValueData                         AS UnitName_to

                     -- ����������
                   , MovementString_Comment.ValueData            AS Comment
                   , MovementString_CarComment.ValueData         AS Comment_car

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

                     -- �������� �����
                   , MIFloat_PromoMovement.ValueData  :: Integer AS MovementId_promo
                     -- ������� ����� ��/���
                   --, CASE WHEN MIFloat_PromoMovement.ValueData > 0 THEN TRUE ELSE FALSE END :: Boolean AS isPromo

                     -- ��� ����� �����
                   ,  ((MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0))
                        * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END
                         ) :: TFloat AS Amount
                     -- ��.
                   ,  (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                                    THEN MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0)
                               ELSE 0
                          END) :: TFloat AS Amount_sh

                     -- ��� �����
                   ,  (MovementItem.Amount
                        * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END
                         ) :: TFloat AS AmountFirst
                     -- ��.
                   ,  (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                                    THEN MovementItem.Amount
                               ELSE 0
                          END) :: TFloat AS AmountFirst_sh

                     -- ��� �������
                   ,  (COALESCE (MIFloat_AmountSecond.ValueData, 0)
                        * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END
                         ) :: TFloat AS AmountSecond
                     -- ��.
                   ,  (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                                    THEN COALESCE (MIFloat_AmountSecond.ValueData, 0)
                               ELSE 0
                          END) :: TFloat AS AmountSecond_sh

                     -- ����� - ����� �����
                   ,  (CASE WHEN MIFloat_PromoMovement.ValueData > 0 THEN MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0) ELSE 0 END
                        * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END
                         ) :: TFloat AS Amount_promo
                     -- ��.
                   ,  (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() AND MIFloat_PromoMovement.ValueData > 0
                                    THEN MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0)
                               ELSE 0
                          END) :: TFloat AS Amount_promo_sh

                     -- ����� � ��� � ������� - ����� �����
                   ,  (COALESCE (MIFloat_Summ.ValueData, 0)) :: TFloat AS Summ
                     --
                   ,  (CASE WHEN MIFloat_PromoMovement.ValueData > 0
                                    THEN COALESCE (MIFloat_Summ.ValueData, 0)
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
                   -- ���������� � ��������
                   LEFT JOIN MovementString AS MovementString_CarComment
                                            ON MovementString_CarComment.MovementId = Movement.Id
                                           AND MovementString_CarComment.DescId     = zc_MovementString_CarComment()

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
                   LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                               ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                              AND MIFloat_AmountSecond.DescId         = zc_MIFloat_AmountSecond()
                   -- ����� � ��� � �������
                   LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                               ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                              AND MIFloat_Summ.DescId = zc_MIFloat_Summ()

                   -- ����
                   /*LEFT JOIN MovementItemFloat AS MIFloat_Price
                                               ON MIFloat_Price.MovementItemId = MovementItem.Id
                                              AND MIFloat_Price.DescId = zc_MIFloat_Price()
                   -- ���� �� ����������
                   LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                               ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                              AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()*/

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

              WHERE Movement.DescId   = zc_Movement_OrderExternal()
                AND Movement.StatusId = zc_Enum_Status_Complete()
                AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                -- !!! ������ �������
                AND Object_From.DescId = zc_Object_Unit()
             ;


  -- ��������
  INSERT INTO ResourseProtocol (UserId
                                 , OperDate
                                 , Value1
                                 , Value2
                                 , Value3
                                 , Value4
                                 , Value5
                                 , Time1
                                 , Time2
                                 , Time3
                                 , Time4
                                 , Time5
                                 , ProcName
                                 , ProtocolData
                                  )
        SELECT inSession :: Integer AS UserId
               -- �� ������� ��������
             , CURRENT_TIMESTAMP
             , 0 AS Value1
             , 0 AS Value2
             , NULL AS Value3
             , NULL AS Value4
             , NULL AS Value5
               -- ������� ����� ����������� ����
             , (CLOCK_TIMESTAMP() - CURRENT_TIMESTAMP) :: INTERVAL AS Time1
               -- ������� ����� ����������� ���� �� 
             , NULL AS Time2
               -- ������� ����� ����������� ���� 
             , NULL AS Time3
               -- ������� ����� ����������� ���� ����� 
             , NULL AS Time4
               -- �� ������� �����������
             , CLOCK_TIMESTAMP() AS Time5
               -- ProcName
             , 'gpInsert_bi_Table_OrderBranch'
               -- ProtocolData
             , zfConvert_DateToString (inStartDate)
   || ' - ' || zfConvert_DateToString (inEndDate)
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
-- DELETE FROM  _bi_Table_OrderBranch WHERE OperDate between '20.07.2025 9:00' and '20.07.2025 9:10'
-- SELECT DATE_TRUNC ('MONTH', OperDate), sum(Amount), sum(Summ), COUNT(*) FROM _bi_Table_OrderBranch where  OperDate between '01.01.2025' and '28.09.2025' GROUP BY DATE_TRUNC ('MONTH', OperDate) ORDER BY 1 DESC
-- SELECT * FROM gpInsert_bi_Table_OrderBranch (inStartDate:= '01.01.2025', inEndDate:= '28.09.2025', inSession:= zfCalc_UserAdmin())
