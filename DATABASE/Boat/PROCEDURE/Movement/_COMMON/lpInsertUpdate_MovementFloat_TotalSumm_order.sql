-- Function: lpInsertUpdate_MovementFloat_TotalSumm_order (Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementFloat_TotalSumm_order (Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementFloat_TotalSumm_order(
    IN inMovementId Integer -- ���� ������� <��������>
)
  RETURNS VOID AS
$BODY$
  DECLARE vbMovementDescId Integer;
  DECLARE vbPriceWithVAT Boolean;
  DECLARE vbVATPercent TFloat;
/*  DECLARE vbDiscountTax TFloat;
  DECLARE vbDiscountNextTax TFloat;
  DECLARE vbPaidKindId Integer;
*/

  DECLARE vbTotalCount TFloat;
  DECLARE vbOperSumm_MVAT TFloat;
  DECLARE vbOperSumm_PVAT TFloat;
  DECLARE vbOperSumm_PVAT_original TFloat;    
              
BEGIN

     IF COALESCE (inMovementId, 0) = 0
     THEN
         RAISE EXCEPTION '������.������� ��������� �� ��������.';
     END IF;

     -- ��� ��������� ����� ��� ������� �������� ���� �� ����������� 
     SELECT Movement.DescId
          , COALESCE (MovementBoolean_PriceWithVAT.ValueData, TRUE)
          , COALESCE (MovementFloat_VATPercent.ValueData, 0)   AS VATPercent
          --, COALESCE (MovementFloat_DiscountTax.ValueData, 0)  AS DiscountTax
          --, COALESCE (MovementFloat_DiscountNextTax.ValueData) AS DiscountNextTax
          --, COALESCE (MovementLinkObject_PaidKind.ObjectId, 0) AS PaidKindId

     INTO vbMovementDescId, vbPriceWithVAT, vbVATPercent--, vbDiscountTax, vbDiscountNextTax, vbPaidKindId

     FROM Movement
          LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                    ON MovementBoolean_PriceWithVAT.MovementId = Movement.Id
                                   AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
          LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                  ON MovementFloat_VATPercent.MovementId = Movement.Id
                                 AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
         /* LEFT JOIN MovementFloat AS MovementFloat_DiscountTax
                                  ON MovementFloat_DiscountTax.MovementId = Movement.Id
                                 AND MovementFloat_DiscountTax.DescId = zc_MovementFloat_DiscountTax()
          LEFT JOIN MovementFloat AS MovementFloat_DiscountNextTax
                                  ON MovementFloat_DiscountNextTax.MovementId = Movement_OrderClient.Id
                                 AND MovementFloat_DiscountNextTax.DescId = zc_MovementFloat_DiscountNextTax()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                       ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                      AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
          */
     WHERE Movement.Id = inMovementId;


     --
     SELECT SUM (COALESCE(tmpMI.OperCount, 0))          AS TotalCount
         
           -- ����� ��� ��� ��� ������
          , SUM (CASE -- ���� ���� c ���
                      WHEN vbPriceWithVAT
                           
                           THEN zfCalc_Summ_NoVAT (COALESCE (tmpMI.OperSumm_original, 0), vbVATPercent)
                      -- ���� ���� ��� ���
                      ELSE
                          COALESCE (tmpMI.OperSumm_original, 0)
                 END) AS OperSumm_MVAT

            -- ����� � ���
          , SUM (CASE -- ���� ���� � ���
                      WHEN vbPriceWithVAT
                           THEN COALESCE (tmpMI.OperSumm_original, 0)
                      -- ���� ���� ��� ���
                      ELSE zfCalc_SummWVAT (COALESCE (tmpMI.OperSumm_original, 0), vbVATPercent)
                 END) AS OperSumm_PVAT_original

            -- �����  (� ������ ��� � ������)
          , SUM (zfCalc_SummWVAT (COALESCE (tmpMI.OperSumm, 0), vbVATPercent)) AS OperSumm_PVAT
                               
      INTO vbTotalCount
         , vbOperSumm_MVAT, vbOperSumm_PVAT_original, vbOperSumm_PVAT
       
       FROM (SELECT MovementItem.Id
                  , MovementItem.ObjectId            AS GoodsId
                  , MovementItem.Amount              AS OperCount
                  , MIFloat_OperPrice.ValueData      AS OperPrice                      --���� � ������ ���� ������ ��� ���
                  , MIFloat_OperPriceList.ValueData  AS OperPrice_original             --���� ��� ������
                  , COALESCE (MIFloat_CountForPrice.ValueData, 0) AS CountForPrice
                  , zfCalc_SummIn (MovementItem.Amount, MIFloat_OperPrice.ValueData, COALESCE (MIFloat_CountForPrice.ValueData, 0) )     AS OperSumm
                  , zfCalc_SummIn (MovementItem.Amount, MIFloat_OperPriceList.ValueData, COALESCE (MIFloat_CountForPrice.ValueData, 0) ) AS OperSumm_original
             FROM MovementItem
                      LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                                  ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                                 AND MIFloat_OperPrice.DescId = zc_MIFloat_OperPrice()
 
                      LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                  ON MIFloat_OperPriceList.MovementItemId = MovementItem.Id
                                                 AND MIFloat_OperPriceList.DescId = zc_MIFloat_OperPriceList()

                      LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                  ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                 AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
            WHERE MovementItem.MovementId = inMovementId
              AND MovementItem.DescId     = zc_MI_Master()
              AND MovementItem.isErased   = False
             ) AS tmpMI;


  /*
zc_MovementFloat_TotalCount 	����� ���������� 	+ 	
zc_MovementFloat_TotalSummMVAT 	����� ����� �� ��������� (��� ���) 	+ 	��� ����� ������ ---------
zc_MovementFloat_TotalSummPVAT 	����� ����� �� ��������� (� ���) 	+ 	��� ����� ������
zc_MovementFloat_TotalSumm 	����� ����� �� ��������� (� ������ ��� � ������)
*/

         -- ��������� �������� <����� ����������("������� ��������")>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCount(), inMovementId, vbTotalCount);
         -- ��������� �������� <����� �����>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSumm(), inMovementId, vbOperSumm_PVAT);
         -- ��������� �������� <����� ����� �� ��������� (��� ���)>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummMVAT(), inMovementId, vbOperSumm_MVAT);
         -- ��������� �������� <����� ����� �� ��������� (� ���)>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummPVAT(), inMovementId, vbOperSumm_PVAT_original);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.02.21         *
*/
-- 