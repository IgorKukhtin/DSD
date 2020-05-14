-- Function: lpInsertUpdate_MovementFloat_TotalSumm (Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementFloat_TotalSumm (Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementFloat_TotalSumm(
    IN inMovementId Integer -- ���� ������� <��������>
)
  RETURNS VOID AS
$BODY$
  DECLARE vbMovementDescId Integer;

  DECLARE vbTotalCount TFloat;
  DECLARE vbTotalCountRemains TFloat;
  DECLARE vbTotalSumm TFloat;
  DECLARE vbTotalSummPriceList TFloat;
  DECLARE vbTotalSummRemainsPriceList TFloat;
  DECLARE vbTotalSummJur TFloat;

  DECLARE vbTotalCountSecond TFloat;
  DECLARE vbTotalCountSecondRemains TFloat;
  DECLARE vbTotalSummSecondPriceList TFloat;
  DECLARE vbTotalSummSecondRemainsPriceList TFloat;

  DECLARE vbTotalSummChange TFloat;
  DECLARE vbTotalSummPay TFloat;

  DECLARE vbTotalSummChangePay TFloat;
  DECLARE vbTotalSummPayOth TFloat;
  DECLARE vbTotalCountReturn TFloat;
  DECLARE vbTotalSummReturn TFloat;
  DECLARE vbTotalSummPayReturn TFloat;
  DECLARE vbTotalSummBalance TFloat;

  DECLARE vbTotalSummPriceList_curr TFloat;
  DECLARE vbTotalSummChange_curr TFloat;
  DECLARE vbTotalSummChangePay_curr TFloat;
  DECLARE vbTotalSummPay_curr TFloat;
  DECLARE vbTotalSumm_curr TFloat;
/*  DECLARE vbTotalCountSecond TFloat;
*/
BEGIN
     IF COALESCE (inMovementId, 0) = 0
     THEN
         RAISE EXCEPTION '������.������� ��������� �� ��������.';
     END IF;


     -- ��� ��������� ����� ��� ������� �������� ����
     vbMovementDescId:= (SELECT Movement.DescId FROM Movement WHERE Movement.Id = inMovementId);

     --
     SELECT SUM (COALESCE(MovementItem.Amount, 0))                                                                      AS TotalCount
            -- ����� �� ��. � ������ - � ����������� �� 2-� ������
          , SUM (zfCalc_SummIn (MovementItem.Amount, Object_PartionGoods.OperPrice, Object_PartionGoods.CountForPrice)) AS TotalSumm
          , SUM (zfCalc_SummIn (MovementItem.Amount, MIFloat_PriceJur.ValueData, Object_PartionGoods.CountForPrice))    AS TotalSummJur
            -- ����� �� ��. � zc_Currency_Basis
          , SUM (zfCalc_SummIn (MovementItem.Amount
                                -- ���� ��. � ������ - ������� ��������� � zc_Currency_Basis - � ����������� �� 2-� ������
                              , zfCalc_PriceIn_Basis (Object_PartionGoods.CurrencyId
                                                    , Object_PartionGoods.OperPrice
                                                    , COALESCE (MovementFloat_CurrencyValue.ValueData, MIFloat_CurrencyValue.ValueData)
                                                    , COALESCE (MovementFloat_ParValue.ValueData,      MIFloat_ParValue.ValueData))
                              , Object_PartionGoods.CountForPrice
                               )
                )                                                                                                   AS TotalSummBalance

            -- ����� �� ������ - � ����������� �� 0/2-� ������
          , SUM (zfCalc_SummPriceList (MovementItem.Amount, MIFloat_OperPriceList.ValueData))                       AS TotalSummPriceList

          , SUM (COALESCE (MIFloat_TotalChangePercent.ValueData, 0) + COALESCE (MIFloat_SummChangePercent.ValueData, 0)) AS TotalSummChange
          , SUM (COALESCE (MIFloat_TotalPay.ValueData,0))                                                                AS TotalSummPay

          , 0 AS TotalSummChangePay
          , 0 AS TotalSummPayOth
          , 0 AS TotalCountReturn
          , 0 AS TotalSummReturn
          , 0 AS TotalSummPayReturn

            ---
          , SUM (COALESCE(MIFloat_AmountRemains.ValueData, 0))       AS TotalCountRemains
          , SUM (COALESCE(MIFloat_AmountSecond.ValueData, 0))        AS TotalCountSecond
          , SUM (COALESCE(MIFloat_AmountSecondRemains.ValueData, 0)) AS TotalCountSecondRemains
          , SUM (zfCalc_SummPriceList (MIFloat_AmountSecond.ValueData, MIFloat_OperPriceList.ValueData))        AS TotalSummSecondPriceList
          , SUM (zfCalc_SummPriceList (MIFloat_AmountSecondRemains.ValueData, MIFloat_OperPriceList.ValueData)) AS TotalSummSecondRemainsPriceList
          , SUM (zfCalc_SummPriceList (MIFloat_AmountRemains.ValueData, MIFloat_OperPriceList.ValueData))       AS TotalSummRemainsPriceList
          
          , SUM (zfCalc_SummPriceList (MovementItem.Amount, MIFloat_OperPriceList_curr.ValueData))              AS TotalSummPriceList_curr
          , SUM (COALESCE (MIFloat_TotalChangePercent_curr.ValueData,0) )                                       AS TotalSummChange_curr     
          , SUM (COALESCE (MIFloat_TotalChangePercentPay_curr.ValueData,0))                                     AS TotalSummChangePay_curr  
          , SUM (COALESCE (MIFloat_TotalPay_curr.ValueData,0) )                                                 AS TotalSummPay_curr  
          , SUM (zfCalc_SummIn (MovementItem.Amount, MIFloat_OperPrice.ValueData, MIFloat_CountForPrice.ValueData)) AS TotalSumm_curr

            INTO vbTotalCount, vbTotalSumm, vbTotalSummJur, vbTotalSummBalance, vbTotalSummPriceList
               , vbTotalSummChange, vbTotalSummPay
               , vbTotalSummChangePay, vbTotalSummPayOth, vbTotalCountReturn, vbTotalSummReturn, vbTotalSummPayReturn
               , vbTotalCountRemains, vbTotalCountSecond, vbTotalCountSecondRemains
               , vbTotalSummSecondPriceList, vbTotalSummSecondRemainsPriceList, vbTotalSummRemainsPriceList
               
               , vbTotalSummPriceList_curr
               , vbTotalSummChange_curr
               , vbTotalSummChangePay_curr
               , vbTotalSummPay_curr
               , vbTotalSumm_curr
       
       FROM MovementItem
            LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = MovementItem.PartionId
            
            LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                        ON MIFloat_OperPriceList.MovementItemId = MovementItem.Id
                                       AND MIFloat_OperPriceList.DescId = zc_MIFloat_OperPriceList()

            LEFT JOIN MovementItemFloat AS MIFloat_PriceJur
                                        ON MIFloat_PriceJur.MovementItemId = MovementItem.Id
                                       AND MIFloat_PriceJur.DescId         = zc_MIFloat_PriceJur()

            LEFT JOIN MovementItemFloat AS MIFloat_AmountRemains
                                        ON MIFloat_AmountRemains.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountRemains.DescId = zc_MIFloat_AmountRemains()
            LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                        ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
            LEFT JOIN MovementItemFloat AS MIFloat_AmountSecondRemains
                                        ON MIFloat_AmountSecondRemains.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountSecondRemains.DescId = zc_MIFloat_AmountSecondRemains()

            LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                        ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                       AND MIFloat_CountForPrice.DescId         = zc_MIFloat_CountForPrice()

            LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent
                                        ON MIFloat_SummChangePercent.MovementItemId = MovementItem.Id
                                       AND MIFloat_SummChangePercent.DescId         = zc_MIFloat_SummChangePercent()
                                       -- ������ ��� ������� �����������
                                       AND vbMovementDescId                         = zc_Movement_GoodsAccount()

            LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercent
                                        ON MIFloat_TotalChangePercent.MovementItemId = MovementItem.Id
                                       AND MIFloat_TotalChangePercent.DescId         = zc_MIFloat_TotalChangePercent()

            LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                        ON MIFloat_TotalPay.MovementItemId = MovementItem.Id
                                       AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()

            LEFT JOIN MovementItemFloat AS MIFloat_CurrencyValue
                                        ON MIFloat_CurrencyValue.MovementItemId = MovementItem.Id
                                       AND MIFloat_CurrencyValue.DescId         = zc_MIFloat_CurrencyValue()
            LEFT JOIN MovementItemFloat AS MIFloat_ParValue
                                        ON MIFloat_ParValue.MovementItemId = MovementItem.Id
                                       AND MIFloat_ParValue.DescId         = zc_MIFloat_ParValue()

            -- LEFT JOIN MovementLinkObject AS MLO_CurrencyDocument
            --                              ON MLO_CurrencyDocument.MovementId = MovementItem.MovementId
            --                             AND MLO_CurrencyDocument.DescId     = zc_MovementLinkObject_CurrencyDocument()
                                        -- ������ ��� 
            --                             AND vbMovementDescId                IN (zc_Movement_Income(), zc_Movement_ReturnOut())
            LEFT JOIN MovementFloat AS MovementFloat_CurrencyValue
                                    ON MovementFloat_CurrencyValue.MovementId = MovementItem.MovementId
                                   AND MovementFloat_CurrencyValue.DescId     = zc_MovementFloat_CurrencyValue()
                                   -- ������ ��� 
                                   AND vbMovementDescId                       IN (zc_Movement_Income(), zc_Movement_ReturnOut())
            LEFT JOIN MovementFloat AS MovementFloat_ParValue
                                    ON MovementFloat_ParValue.MovementId = MovementItem.MovementId
                                   AND MovementFloat_ParValue.DescId     = zc_MovementFloat_ParValue()
                                   -- ������ ��� 
                                   AND vbMovementDescId                  IN (zc_Movement_Income(), zc_Movement_ReturnOut())

            LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList_curr
                                        ON MIFloat_OperPriceList_curr.MovementItemId = MovementItem.Id
                                       AND MIFloat_OperPriceList_curr.DescId = zc_MIFloat_OperPriceList_curr()
            LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercent_curr
                                        ON MIFloat_TotalChangePercent_curr.MovementItemId = MovementItem.Id
                                       AND MIFloat_TotalChangePercent_curr.DescId = zc_MIFloat_TotalChangePercent_curr()
            LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercentPay_curr
                                        ON MIFloat_TotalChangePercentPay_curr.MovementItemId = MovementItem.Id
                                       AND MIFloat_TotalChangePercentPay_curr.DescId = zc_MIFloat_TotalChangePercentPay_curr()
            LEFT JOIN MovementItemFloat AS MIFloat_TotalPay_curr
                                        ON MIFloat_TotalPay_curr.MovementItemId = MovementItem.Id
                                       AND MIFloat_TotalPay_curr.DescId = zc_MIFloat_TotalPay_curr()
            LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                        ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                       AND MIFloat_OperPrice.DescId = zc_MIFloat_OperPrice()
                                       
      WHERE MovementItem.MovementId = inMovementId
        AND MovementItem.DescId     = zc_MI_Master()
        AND MovementItem.isErased = false;


      IF vbMovementDescId IN (zc_Movement_Inventory())
         THEN
             -- ��������� �������� <����� ����������>
             PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCount(), inMovementId, vbTotalCount + vbTotalCountSecond);
             -- ��������� �������� <����� ����� �� ������>
             PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummPriceList(), inMovementId, vbTotalSummPriceList + vbTotalSummSecondPriceList);

             -- ��������� �������� <����� ���������� �������>
             PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCountRemains(), inMovementId, vbTotalCountRemains + vbTotalCountSecondRemains);
             -- ��������� �������� <����� ����� �� ������ - �������>
             PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummRemainsPriceList(), inMovementId, vbTotalSummRemainsPriceList + vbTotalSummSecondRemainsPriceList);
      ELSE

             -- ��������� �������� <����� ����������("������� ��������")>
             PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCount(), inMovementId, vbTotalCount);
             -- ��������� �������� <����� �����>
             PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSumm(), inMovementId, vbTotalSumm);
             -- ��������� �������� <����� ����� ��� ������>
             PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummJur(), inMovementId, vbTotalSummJur);
             -- ��������� �������� <����� ����� ��. � ���>
             PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummBalance(), inMovementId, vbTotalSummBalance);
             -- ��������� �������� <����� ����� �� ������>
             PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummPriceList(), inMovementId, vbTotalSummPriceList);

             -- ��������� �������� <����� ����� ������ � ���>
             PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummChange(), inMovementId, vbTotalSummChange);
             -- ��������� �������� <����� ����� ������ (� ���)>
             PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummPay(), inMovementId, vbTotalSummPay);

             -- ��������� �������� <����� ����� �� ������ � ������>
             PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummPriceList_curr(), inMovementId, vbTotalSummPriceList_curr);
             -- ��������� �������� <����� ����� ������ � ������>
             PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummChange_curr(), inMovementId, vbTotalSummChange_curr);
             -- ��������� �������� <����� ����� ������ � ������>
             PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummChangePay_curr(), inMovementId, vbTotalSummChangePay_curr);
             -- ��������� �������� <����� ����� ������ (� ������)>
             PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummPay_curr(), inMovementId, vbTotalSummPay_curr);   
             -- ��������� �������� <����� ����� ��. �� ��������� (� ������)>
             PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSumm_curr(), inMovementId, vbTotalSumm_curr);               
               
             -- ��������� �������� <����� ����� ������ � ���>
             -- PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummChangePay(), inMovementId, vbTotalSummChangePay);
             -- ��������� �������� <����� ����� ������ (� ���)>
             -- PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummPayOth(), inMovementId, vbTotalSummPayOth);
             -- ��������� �������� <����� ���������� ��������>
             -- PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCountReturn(), inMovementId, vbTotalCountReturn);
             -- ��������� �������� <����� ����� �������� �� ������� (� ���)>
             -- PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummReturn(), inMovementId, vbTotalSummReturn);
             -- ��������� �������� <����� ����� �������� ������ (� ���)>
             -- PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummPayReturn(), inMovementId, vbTotalSummPayReturn);

      END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_MovementFloat_TotalSumm (Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 13.05.20         *
 14.02.19         * add TotalSummJur
 21.07.17         *
 15.06.17         *
 28.04.15                         *
*/
-- select lpInsertUpdate_MovementFloat_TotalSumm (inMovementId:= id) from gpSelect_Movement_WeighingPartner (inStartDate := ('01.06.2014')::TDateTime , inEndDate := ('30.06.2014')::TDateTime ,  inSession := '5') as a
-- ����
-- SELECT lpInsertUpdate_MovementFloat_TotalSumm (inMovementId:= Movement.Id) from Movement where DescId = zc_Movement_Income() and OperDate between ('01.11.2014')::TDateTime and  ('31.12.2014')::TDateTime
