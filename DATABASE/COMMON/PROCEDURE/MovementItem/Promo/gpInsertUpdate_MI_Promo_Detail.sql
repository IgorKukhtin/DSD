-- Function: gpInsertUpdate_MI_Promo_Detail()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Promo_Detail (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_Promo_Detail(
    IN inMovementId            Integer   , -- ���� ������� <��������>
    IN inSession               TVarChar     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_Promo_Data());


     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME ILIKE '_tmpReport')
     THEN
         DELETE FROM _tmpReport;
     ELSE
         -- ������ �� ���������� ������ Sale / Order / ReturnIn ��� ���������� ������� "�����"
         CREATE TEMP TABLE _tmpReport (GoodsId Integer, OperDate TDateTime, Amount TFloat, AmountIn TFloat, AmountReal TFloat, AmountRetIn TFloat) ON COMMIT DROP;
     END IF;


     -- ������ Sale / ReturnIn
     INSERT INTO _tmpReport (GoodsId, OperDate, Amount, AmountIn, AmountReal, AmountRetIn)
        SELECT spReport.GoodsId
             , spReport.Month_Partner    AS OperDate
             , spReport.AmountOut        AS Amount
             , spReport.AmountIn         AS AmountIn
             , spReport.AmountReal_calc  AS AmountReal
             , spReport.AmountRetIn_calc AS AmountRetIn
        FROM gpSelect_Report_Promo_Result_Month (inStartDate   := CURRENT_DATE ::TDateTime
                                               , inEndDate     := CURRENT_DATE ::TDateTime
                                               , inIsPromo     := False
                                               , inIsTender    := False
                                               , inisGoodsKind := False
                                               , inisReal      := True
                                               , inUnitId      := 0
                                               , inRetailId    := 0
                                               , inMovementId  := inMovementId
                                               , inJuridicalId := 0
                                               , inSession     := inSession) AS spReport
        ;

     -- ��������� -
     PERFORM lpInsertUpdate_MI_PromoGoods_Detail (ioId          := COALESCE (tmp.Id,0)          ::Integer
                                                , inParentId    := COALESCE (tmp.ParentId,0)    ::Integer
                                                , inMovementId  := inMovementId                 ::Integer
                                                , inGoodsId     := tmp.GoodsId                  ::Integer
                                                , inAmount      := COALESCE (tmp.Amount,0)      ::TFloat
                                                , inAmountIn    := COALESCE (tmp.AmountIn,0)    ::TFloat
                                                , inAmountReal  := COALESCE (tmp.AmountReal,0)  ::TFloat
                                                , inAmountRetIn := COALESCE (tmp.AmountRetIn,0) ::TFloat
                                                , inOperDate    := tmp.OperDate                 ::TDateTime
                                                , inUserId      := vbUserId                     ::Integer
                                                 )
     FROM (WITH tmpMI_Master AS (SELECT MovementItem.*
                                 FROM MovementItem
                                 WHERE MovementItem.MovementId = inMovementId
                                   AND MovementItem.DescId = zc_MI_Master()
                                   AND MovementItem.isErased = FALSE
                                 )
              , tmpMI_Detail AS (SELECT MovementItem.*
                                      , MIDate_OperDate.ValueData    ::TDateTime  AS OperDate
                                 FROM MovementItem
                                   LEFT JOIN MovementItemDate AS MIDate_OperDate
                                                              ON MIDate_OperDate.MovementItemId = MovementItem.Id
                                                             AND MIDate_OperDate.DescId = zc_MIDate_OperDate()
                                 WHERE MovementItem.MovementId = inMovementId
                                   AND MovementItem.DescId = zc_MI_Detail()
                                   AND MovementItem.isErased = FALSE
                                 )

           -- ���������
           SELECT COALESCE (tmpMI_Detail.Id,0)         AS Id
                , tmpMI_Master.Id                      AS ParentId
                , _tmpReport.GoodsId                   AS GoodsId
                , COALESCE (_tmpReport.Amount, 0)      AS Amount
                , COALESCE (_tmpReport.AmountIn, 0)    AS AmountIn
                , COALESCE (_tmpReport.AmountReal, 0)  AS AmountReal
                , COALESCE (_tmpReport.AmountRetIn, 0) AS AmountRetIn
                , _tmpReport.OperDate ::TDateTime      AS OperDate
           FROM tmpMI_Master
                LEFT JOIN _tmpReport ON _tmpReport.GoodsId = tmpMI_Master.ObjectId
                LEFT JOIN tmpMI_Detail ON tmpMI_Detail.ParentId = tmpMI_Master.Id
                                      AND tmpMI_Detail.OperDate = _tmpReport.OperDate

          ) AS tmp
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 27.12.24         *
*/

-- ����
-- 26423 �� 01,10,2024