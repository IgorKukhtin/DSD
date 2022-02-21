-- Function: lpInsertUpdate_MovementFloat_TotalSumm (Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementFloat_TotalSumm (Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementFloat_TotalSumm(
    IN inMovementId Integer -- ���� ������� <��������>
)
  RETURNS VOID AS
$BODY$
  DECLARE vbMovementDescId Integer;
  DECLARE vbOperDatePartner TDateTime;
  DECLARE vbPriceWithVAT Boolean;
  DECLARE vbVATPercent TFloat;
  DECLARE vbDiscountTax TFloat;
  DECLARE vbDiscountNextTax TFloat;
  DECLARE vbPaidKindId Integer;

  DECLARE vbTotalCount_Master TFloat;
  DECLARE vbTotalCount_Child TFloat;
  DECLARE vbTotalCountRemains TFloat;

  DECLARE vbTotalSumm TFloat;              -- ����� ����� �� ��������� (��� ��� � � ������ ���� �������� � ������)
  DECLARE vbOperSumm_PVAT TFloat;          -- ����� ����� �� ��������� (� ���)  - � ������ ���� ������ � ��������
  DECLARE vbOperSumm_MVAT TFloat;          -- ����� ����� �� ��������� (��� ���) - � ������ ������ ������ �� ���������
  DECLARE vbOperSumm_PVAT_original TFloat;

BEGIN

     IF COALESCE (inMovementId, 0) = 0
     THEN
         RAISE EXCEPTION '������.������� ��������� �� ��������.';
     END IF;

     -- ��� ��������� ����� ��� ������� �������� ���� �� �����������
     SELECT Movement.DescId
          , CASE WHEN Movement.DescId IN (zc_Movement_Income(), zc_Movement_ReturnOut(), zc_Movement_Sale(), zc_Movement_ReturnIn())
                      THEN COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate)
                 ELSE Movement.OperDate
            END AS OperDatePartner
          , COALESCE (MovementBoolean_PriceWithVAT.ValueData, TRUE)
          , COALESCE (MovementFloat_VATPercent.ValueData, 0)      AS VATPercent
          , COALESCE (MovementFloat_DiscountTax.ValueData, 0)     AS DiscountTax
          , COALESCE (MovementFloat_DiscountNextTax.ValueData, 0) AS DiscountNextTax

          , COALESCE (MovementLinkObject_PaidKind.ObjectId, 0)    AS PaidKindId

            INTO vbMovementDescId, vbOperDatePartner, vbPriceWithVAT, vbVATPercent
               , vbDiscountTax, vbDiscountNextTax
               , vbPaidKindId

      FROM Movement
           LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                  ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                 AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

           LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                     ON MovementBoolean_PriceWithVAT.MovementId = Movement.Id
                                    AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
           LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                   ON MovementFloat_VATPercent.MovementId = Movement.Id
                                  AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()

           LEFT JOIN MovementFloat AS MovementFloat_DiscountTax
                                   ON MovementFloat_DiscountTax.MovementId = Movement.Id
                                  AND MovementFloat_DiscountTax.DescId     = zc_MovementFloat_DiscountTax()
           LEFT JOIN MovementFloat AS MovementFloat_DiscountNextTax
                                   ON MovementFloat_DiscountNextTax.MovementId = Movement.Id
                                  AND MovementFloat_DiscountNextTax.DescId     = zc_MovementFloat_DiscountTax()

           LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                        ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                       AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()

      WHERE Movement.Id = inMovementId;

      --
      SELECT SUM (COALESCE(tmpMI.OperCount_Master, 0))  AS TotalCount_Master
         , SUM (COALESCE(tmpMI.OperCount_Child, 0))     AS TotalCount_Child
           -- ����� ����� �� ��������� (��� ���) - � ������ ������ ������ �� ���������
         , SUM (tmpMI.SummIn) AS OperSumm_MVAT

           INTO vbTotalCount_Master, vbTotalCount_Child, vbOperSumm_MVAT

      FROM (SELECT MovementItem.DescId
                 , MovementItem.ObjectId            AS GoodsId
                 , CASE WHEN MovementItem.DescId = zc_MI_Master() THEN MovementItem.Amount ELSE 0 END AS OperCount_Master
                 , CASE WHEN MovementItem.DescId = zc_MI_Child()  THEN MovementItem.Amount ELSE 0 END AS OperCount_Child
                 , MIFloat_OperPrice.ValueData      AS OperPrice_original
                   -- ����� "��� ��� ?" - � ������ ������ � ��������
                 , CASE WHEN vbMovementDescId = zc_Movement_Income()
                        THEN COALESCE (MIFloat_SummIn.ValueData, 0)
                        ELSE zfCalc_SummIn (MovementItem.Amount, MIFloat_OperPrice.ValueData, MIFloat_CountForPrice.ValueData)
                   END AS SummIn
            FROM MovementItem

                 LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                             ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                            AND MIFloat_CountForPrice.DescId         = zc_MIFloat_CountForPrice()

                 LEFT JOIN MovementItemFloat AS MIFloat_SummIn
                                             ON MIFloat_SummIn.MovementItemId = MovementItem.Id
                                            AND MIFloat_SummIn.DescId         = zc_MIFloat_SummIn()

                 LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                             ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                            AND MIFloat_OperPrice.DescId = zc_MIFloat_OperPrice()

           WHERE MovementItem.MovementId = inMovementId
           --AND MovementItem.DescId     = zc_MI_Master()
             AND MovementItem.isErased   = FALSE
            ) AS tmpMI;

         -- ����� ����� �� ��������� (��� ��� � � ������ ���� �������� � ������)
         vbTotalSumm:= CASE WHEN vbMovementDescId = zc_Movement_Income()
                                 THEN vbOperSumm_MVAT
                                      -- ����� ������ ��� ���
                                    - COALESCE((SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inMovementId AND MF.DescId = zc_MovementFloat_SummTaxMVAT()))
                                      -- �������� �������, ��� ���
                                    + COALESCE((SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inMovementId AND MF.DescId = zc_MovementFloat_SummPost()))
                                      -- �������� �������, ��� ���
                                    + COALESCE((SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inMovementId AND MF.DescId = zc_MovementFloat_SummPack()))
                                      -- ��������� ������� , ��� ���
                                    + COALESCE((SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inMovementId AND MF.DescId = zc_MovementFloat_SummInsur()))
                                      -- ����� ������ ��� ��� �����
                                    - COALESCE((SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inMovementId AND MF.DescId = zc_MovementFloat_TotalSummTaxMVAT()))

                            ELSE zfCalc_SummDiscountTax (zfCalc_SummDiscountTax (vbOperSumm_MVAT, vbDiscountTax), vbDiscountNextTax)
                       END;

         -- ����� ����� �� ��������� (� ���) - � ������ ���� ������ � ��������
         vbOperSumm_PVAT:= zfCalc_SummWVAT (vbTotalSumm, vbVATPercent);


         -- ��������� �������� <����� ����������("������� ��������")>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCount(), inMovementId, vbTotalCount_Master);

         -- ��������� �������� <����� ����������("����������� ��������")>
         -- PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCountChild(), inMovementId, vbTotalCount_Child);

         -- ��������� �������� <����� ����� �� ��������� (��� ��� � � ������ ���� �������� � ������)>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSumm(), inMovementId, vbTotalSumm);

         -- ��������� �������� <����� ����� �� ��������� (��� ���) - � ������ ������ ������ �� ���������>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummMVAT(), inMovementId, vbOperSumm_MVAT);

         -- ��������� �������� <����� ����� �� ��������� (� ���)  - � ������ ���� ������ � ��������>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummPVAT(), inMovementId, vbOperSumm_PVAT);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.02.21         *
*/
-- select lpInsertUpdate_MovementFloat_TotalSumm (inMovementId:= id) from gpSelect_Movement_WeighingPartner (inStartDate := ('01.06.2014')::TDateTime , inEndDate := ('30.06.2014')::TDateTime ,  inSession := '5') as a
-- ����
-- SELECT lpInsertUpdate_MovementFloat_TotalSumm(inMovementId:= 76)