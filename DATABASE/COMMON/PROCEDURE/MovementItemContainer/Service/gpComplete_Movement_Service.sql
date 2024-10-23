-- Function: gpComplete_Movement_Service()

DROP FUNCTION IF EXISTS gpCompletePeriod_Movement_Service (TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpComplete_Movement_Service (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Service(
    IN inMovementId        Integer              , -- ���� ���������
    IN inSession           TVarChar               -- ������ ������������
)                              
RETURNS void
AS
$BODY$
  DECLARE vbUserId Integer;

  DECLARE vbMovementId_Doc         Integer;
  DECLARE vbInfoMoneyId            Integer;
  DECLARE vbInfoMoneyId_CostPromo  Integer;
  DECLARE vbInfoMoneyId_Market     Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Service());

     -- �����
     vbInfoMoneyId:= (SELECT MILinkObject_InfoMoney.ObjectId
                      FROM MovementItem
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                            ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                      WHERE MovementItem.MovementId = inMovementId
                        AND MovementItem.DescId     = zc_MI_Master()
                        AND MovementItem.isErased   = FALSE
                     );


     -- �����
     vbMovementId_Doc:= (SELECT MLM.MovementChildId FROM MovementLinkMovement AS MLM WHERE MLM.MovementId = inMovementId AND MLM.DescId = zc_MovementLinkMovement_Doc());

     -- ���������  - 
     IF vbMovementId_Doc > 0
     THEN
         -- 1. ����� - �����������,���
         IF EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = vbMovementId_Doc AND Movement.DescId = zc_Movement_Promo())
         THEN
             -- ������ ��� ��������� �������
             vbInfoMoneyId_CostPromo:= (SELECT MLO_InfoMoney_CostPromo.ObjectId
                                        FROM Movement
                                             JOIN MovementLinkObject AS MLO_InfoMoney_CostPromo
                                                                     ON MLO_InfoMoney_CostPromo.MovementId = Movement.Id
                                                                    AND MLO_InfoMoney_CostPromo.DescId     = zc_MovementLinkObject_InfoMoney_CostPromo()
                                                                    AND MLO_InfoMoney_CostPromo.ObjectId   > 0
                                        WHERE Movement.ParentId = vbMovementId_Doc
                                          AND Movement.DescId   = zc_Movement_InfoMoney()
                                       );

             -- ������ ��� ����� �����������
             vbInfoMoneyId_Market:= (SELECT MLO_InfoMoney_Market.ObjectId
                                     FROM Movement
                                          JOIN MovementLinkObject AS MLO_InfoMoney_Market
                                                                  ON MLO_InfoMoney_Market.MovementId = Movement.Id
                                                                 AND MLO_InfoMoney_Market.DescId     = zc_MovementLinkObject_InfoMoney_Market()
                                                                 AND MLO_InfoMoney_Market.ObjectId   > 0
                                     WHERE Movement.ParentId = vbMovementId_Doc
                                       AND Movement.DescId   = zc_Movement_InfoMoney()
                                    );

             -- ��������
             IF   COALESCE (vbInfoMoneyId_CostPromo, 0) = 0
              AND COALESCE (vbInfoMoneyId_Market, 0)    = 0
             THEN
                 RAISE EXCEPTION '������.� ��������� ����� �������� <�� ������> �� �����������.';
             END IF;

             -- ��������
             IF vbInfoMoneyId NOT IN (vbInfoMoneyId_CostPromo, vbInfoMoneyId_Market)
             THEN
                 RAISE EXCEPTION '������.���������� ������� �������� <�� ������> ��� � ��������� ����� % <%> % % % %.'
                               , CHR (13)
                               , lfGet_Object_ValueData (CASE WHEN vbInfoMoneyId_Market > 0 THEN vbInfoMoneyId_Market ELSE vbInfoMoneyId_CostPromo END)
                               , CHR (13)
                               , CASE WHEN vbInfoMoneyId_CostPromo > 0 THEN '���' ELSE '' END
                               , CHR (13)
                               , CASE WHEN vbInfoMoneyId_CostPromo > 0 THEN '<' || lfGet_Object_ValueData (vbInfoMoneyId_CostPromo) || '>' ELSE '' END
                                ;
             END IF;

             -- ��������
             IF COALESCE ((-- ����� �����
                           SELECT SUM (tmpSumm.Summ_promo)
                           FROM (-- ����� �����������
                                 SELECT SUM (COALESCE (MIFloat_SummInMarket.ValueData, 0) - COALESCE (MIFloat_SummOutMarket.ValueData, 0)) AS Summ_promo
                                 FROM MovementItem
                                      LEFT JOIN MovementItemFloat AS MIFloat_SummOutMarket
                                                                  ON MIFloat_SummOutMarket.MovementItemId = MovementItem.Id
                                                                 AND MIFloat_SummOutMarket.DescId         = zc_MIFloat_SummOutMarket()
                                      LEFT JOIN MovementItemFloat AS MIFloat_SummInMarket
                                                                  ON MIFloat_SummInMarket.MovementItemId = MovementItem.Id
                                                                 AND MIFloat_SummInMarket.DescId         = zc_MIFloat_SummInMarket()
                                 WHERE MovementItem.MovementId = vbMovementId_Doc
                                   AND MovementItem.DescId     = zc_MI_Master()
                                   AND MovementItem.isErased   = FALSE
                                   -- ���� ����� �����������
                                   AND vbInfoMoneyId_Market = vbInfoMoneyId

                                UNION
                                 -- ��������� �������
                                 SELECT -1 * COALESCE (MF.ValueData, 0) AS Summ_promo
                                 FROM MovementFloat AS MF
                                 WHERE MF.MovementId = vbMovementId_Doc AND MF.DescId = zc_MovementFloat_CostPromo()
                                   -- ���� ��������� �������
                                   AND vbInfoMoneyId_CostPromo = vbInfoMoneyId
                                ) AS tmpSumm
                          ), 0)
             <> (SELECT SUM (MovementItem.Amount)
                 FROM MovementItem
                 WHERE MovementItem.MovementId = inMovementId
                   AND MovementItem.DescId     = zc_MI_Master()
                   AND MovementItem.isErased   = FALSE
                )
            AND vbUserId <> 5
             THEN
                 RAISE EXCEPTION '������.�� ������������� ����� %� ��������� ����� <%,���> = <%> %� � ��������� ���������� = <%>.'
                               , CHR (13)
                               , CASE WHEN vbInfoMoneyId = vbInfoMoneyId_Market AND vbInfoMoneyId = vbInfoMoneyId_CostPromo
                                           THEN '����������� + ��������� �������'
                                      WHEN vbInfoMoneyId = vbInfoMoneyId_Market
                                           THEN '�����������'
                                      WHEN vbInfoMoneyId = vbInfoMoneyId_CostPromo
                                           THEN '��������� �������'
                                      ELSE '��������� �������'
                                 END
                               , (SELECT CASE WHEN COALESCE (SUM (tmpSumm.Summ_promo), 0) <= 0
                                                   THEN '������: ' || zfConvert_FloatToString (-1 * COALESCE (SUM (tmpSumm.Summ_promo), 0))
                                              ELSE '�����: ' || zfConvert_FloatToString (1 * COALESCE (SUM (tmpSumm.Summ_promo), 0))
                                         END
                                  FROM (-- ����� �����������
                                        SELECT SUM (COALESCE (MIFloat_SummInMarket.ValueData, 0) - COALESCE (MIFloat_SummOutMarket.ValueData, 0)) AS Summ_promo
                                        FROM MovementItem
                                             LEFT JOIN MovementItemFloat AS MIFloat_SummOutMarket
                                                                         ON MIFloat_SummOutMarket.MovementItemId = MovementItem.Id
                                                                        AND MIFloat_SummOutMarket.DescId         = zc_MIFloat_SummOutMarket()
                                             LEFT JOIN MovementItemFloat AS MIFloat_SummInMarket
                                                                         ON MIFloat_SummInMarket.MovementItemId = MovementItem.Id
                                                                        AND MIFloat_SummInMarket.DescId         = zc_MIFloat_SummInMarket()
                                        WHERE MovementItem.MovementId = vbMovementId_Doc
                                          AND MovementItem.DescId     = zc_MI_Master()
                                          AND MovementItem.isErased   = FALSE
                                          -- ���� ����� �����������
                                          AND vbInfoMoneyId_Market = vbInfoMoneyId

                                       UNION
                                        -- ��������� �������
                                        SELECT -1 * COALESCE (MF.ValueData, 0) AS Summ_promo
                                        FROM MovementFloat AS MF
                                        WHERE MF.MovementId = vbMovementId_Doc AND MF.DescId = zc_MovementFloat_CostPromo()
                                          -- ���� ����� �����������
                                          AND vbInfoMoneyId_CostPromo = vbInfoMoneyId
                                       ) AS tmpSumm
                                 )
                               , CHR (13)
                               , (SELECT CASE WHEN SUM (MovementItem.Amount) <= 0
                                                   THEN '������: ' || zfConvert_FloatToString (-1 * SUM (MovementItem.Amount))
                                              ELSE '�����: ' || zfConvert_FloatToString (1 * SUM (MovementItem.Amount))
                                         END
                                  FROM MovementItem
                                  WHERE MovementItem.MovementId = inMovementId
                                    AND MovementItem.DescId     = zc_MI_Master()
                                    AND MovementItem.isErased   = FALSE
                                 )
                                ;
             END IF;
         END IF;

         -- 2. �����-��������� - �����, ���
         IF EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = vbMovementId_Doc AND Movement.DescId = zc_Movement_PromoTrade())
            AND vbUserId <> 5
         THEN
             IF (SELECT 1 * SUM (COALESCE (MIFloat_Summ.ValueData, 0))
                 FROM MovementItem
                      LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                                  ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                                 AND MIFloat_Summ.DescId         = zc_MIFloat_Summ()
                 WHERE MovementItem.MovementId = vbMovementId_Doc
                   AND MovementItem.DescId     = zc_MI_Master()
                   AND MovementItem.isErased   = FALSE
                )
             <> (SELECT -1 * SUM (MovementItem.Amount)
                 FROM MovementItem
                 WHERE MovementItem.MovementId = inMovementId
                   AND MovementItem.DescId     = zc_MI_Master()
                   AND MovementItem.isErased   = FALSE
                )
             THEN
                 RAISE EXCEPTION '������.�� ������������� ����� %� ��������� �����-��������� <�����, ���> = <%> %� � ��������� ���������� = <%>.'
                               , CHR (13)
                               , (SELECT zfConvert_FloatToString (1 * SUM (COALESCE (MIFloat_Summ.ValueData, 0)))
                                  FROM MovementItem
                                       LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                                                   ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                                                  AND MIFloat_Summ.DescId         = zc_MIFloat_Summ()
                                  WHERE MovementItem.MovementId = vbMovementId_Doc
                                    AND MovementItem.DescId     = zc_MI_Master()
                                    AND MovementItem.isErased   = FALSE
                                 )
                               , CHR (13)
                               , (SELECT CASE WHEN SUM (MovementItem.Amount) < 0
                                                   THEN zfConvert_FloatToString (-1 * SUM (MovementItem.Amount))
                                              ELSE '�����: ' || zfConvert_FloatToString (1 * SUM (MovementItem.Amount))
                                         END
                                  FROM MovementItem
                                  WHERE MovementItem.MovementId = inMovementId
                                    AND MovementItem.DescId     = zc_MI_Master()
                                    AND MovementItem.isErased   = FALSE
                                 )
                                ;
             END IF;
         END IF;

     END IF;


     -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
     PERFORM lpComplete_Movement_Finance_CreateTemp();

     -- �������� ��������
     PERFORM lpComplete_Movement_Service (inMovementId := inMovementId
                                        , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.11.14                                        * add lpComplete_Movement_Finance_CreateTemp
 12.09.14                                        * add PositionId and ServiceDateId and BusinessId_... and BranchId_...
 17.08.14                                        * add MovementDescId
 05.04.14                                        * add !!!��� �����������!!! : _tmp1___ and _tmp2___
 25.03.14                                        * ������� - !!!��� �����������!!!
 22.01.14                                        * add IsMaster
 28.12.13                                        *
*/

-- ����
-- SELECT * FROM lpUnComplete_Movement (inMovementId:= 3581, inUserId:= zfCalc_UserAdmin() :: Integer)
-- SELECT * FROM gpComplete_Movement_Service (inMovementId:= 3581, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 3581, inSession:= zfCalc_UserAdmin())
