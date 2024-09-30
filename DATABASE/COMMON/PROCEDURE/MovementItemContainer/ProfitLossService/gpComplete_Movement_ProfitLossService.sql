-- Function: gpComplete_Movement_ProfitLossService()

DROP FUNCTION IF EXISTS gpCompletePeriod_Movement_ProfitLossService (TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpComplete_Movement_ProfitLossService (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_ProfitLossService(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
 RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbMovementId_Doc Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Service());

     -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
     PERFORM lpComplete_Movement_Finance_CreateTemp();

/*
     -- !!!�������� - ���������!!!
     UPDATE MovementItem SET Amount = CAST (MovementItem.Amount AS NUMERIC (16, 2))
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId = zc_MI_Master()
       AND MovementItem.Amount <> CAST (MovementItem.Amount AS NUMERIC (16, 2))
    ;
*/


     -- �����
     vbMovementId_Doc:= (SELECT MLM.MovementChildId FROM MovementLinkMovement AS MLM WHERE MLM.MovementId = inMovementId AND MLM.DescId = zc_MovementLinkMovement_Doc());

     -- ���������  - 
     IF vbMovementId_Doc > 0
     THEN
         -- 1. ����� - �����������,��� 
         IF EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = vbMovementId_Doc AND Movement.DescId = zc_Movement_Promo())
         THEN
             IF (SELECT SUM (COALESCE (MIFloat_SummInMarket.ValueData, 0) - COALESCE (MIFloat_SummOutMarket.ValueData, 0))
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
                ) 
             <> (SELECT SUM (MovementItem.Amount)
                 FROM MovementItem 
                 WHERE MovementItem.MovementId = inMovementId
                   AND MovementItem.DescId     = zc_MI_Master()
                   AND MovementItem.isErased   = FALSE
                )
             THEN
                 RAISE EXCEPTION '������.�� ������������� ����� %� ��������� ����� <�����������,���> = <%> %� � ��������� ���������� = <%>.'
                               , CHR (13)
                               , (SELECT CASE WHEN SUM (COALESCE (MIFloat_SummInMarket.ValueData, 0) - COALESCE (MIFloat_SummOutMarket.ValueData, 0)) <= 0
                                                   THEN '������: ' || zfConvert_FloatToString (-1 * SUM (COALESCE (MIFloat_SummInMarket.ValueData, 0) - COALESCE (MIFloat_SummOutMarket.ValueData, 0)))
                                              ELSE '�����: ' || zfConvert_FloatToString (1 * SUM (COALESCE (MIFloat_SummInMarket.ValueData, 0) - COALESCE (MIFloat_SummOutMarket.ValueData, 0)))
                                         END
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


     -- �������� ��������
     PERFORM lpComplete_Movement_Service (inMovementId := inMovementId
                                        , inUserId     := vbUserId);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 12.11.14                                        * add lpComplete_Movement_Finance_CreateTemp
 12.09.14                                        * add PositionId and ServiceDateId and BusinessId_... and BranchId_...
 17.08.14                                        * add MovementDescId
 05.04.14                                        * add !!!��� �����������!!! : _tmp1___ and _tmp2___
 25.03.14                                        * ������� - !!!��� �����������!!!
 06.03.14                                        * add lpComplete_Movement_Service
 17.02.14                                                       *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 122175 , inSession:= '2')
-- SELECT * FROM gpComplete_Movement_ProfitLossService (inMovementId:= 122175, inIsLastComplete:= FALSE, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 122175 , inSession:= '2')
