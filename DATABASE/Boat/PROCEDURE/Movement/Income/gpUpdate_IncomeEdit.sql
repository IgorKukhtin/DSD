 -- Function: gpUpdate_Movement_Income_summ()

DROP FUNCTION IF EXISTS gpUpdate_IncomeEdit (Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Movement_Income_summ (Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Movement_Income_summ (Integer, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Income_summ(
    IN inId                    Integer   , -- ���� ������� <��������>
    IN inIsBefore              Boolean   , -- ��������� ������ �� �����, ����� ������������ ��������� � ..._calc
    IN inTotalSummMVAT         TFloat    , -- ����� �� ��������� (��� ���, �� � ������ ������ � ���������, ���� ����)
 INOUT ioDiscountTax           TFloat    , -- 1.1. % ������
 INOUT ioSummTaxPVAT           TFloat    , -- 1.2. ����� ������ � ���
 INOUT ioSummTaxMVAT           TFloat    , -- 1.2. ����� ������ ��� ���
    IN inSummPost              TFloat    , -- 2.1. �������� �������, ��� ���
    IN inSummPack              TFloat    , -- 2.2. �������� �������, ��� ���
    IN inSummInsur             TFloat    , -- 2.3. ��������� �������, ��� ���
 INOUT ioTotalDiscountTax      TFloat    , -- 3.1. % ������ �����
 INOUT ioTotalSummTaxPVAT      TFloat    , -- 3.3. ����� ������ � ��� �����
 INOUT ioTotalSummTaxMVAT      TFloat    , -- 3.2. ����� ������ ��� ��� �����
   OUT outSumm2                TFloat    , -- ����� ��� ���, ����� �.1.
   OUT outSumm3                TFloat    , -- ����� ��� ���, ����� �.2.
   OUT outSumm4                TFloat    , -- ����� ��� ���, ����� �.3. -
    IN inSession               TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbVATPercent TFloat;
   DECLARE vbDiscountTax TFloat;
   DECLARE vbSummTaxMVAT TFloat;
   DECLARE vbSummTaxPVAT TFloat;
   DECLARE vbSummPost TFloat;
   DECLARE vbSummPack TFloat;
   DECLARE vbSummInsur TFloat;
   DECLARE vbTotalDiscountTax TFloat;
   DECLARE vbTotalSummTaxMVAT TFloat;
   DECLARE vbTotalSummTaxPVAT TFloat;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     --vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_MI_Income_Price());
     vbUserId := lpGetUserBySession (inSession);


     -- �������� - �������� ������ ���� ��������
     IF COALESCE (inId, 0) = 0 THEN

        RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := '������.�������� �� ��������.' :: TVarChar
                                              , inProcedureName := 'gpUpdate_Movement_Income_summ'   :: TVarChar
                                              , inUserId        := vbUserId);
     END IF;

    -- % ��� �� ����� ���������
    vbVATPercent := (SELECT MovementFloat_VATPercent.ValueData
                     FROM Movement AS Movement_Income
                         LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                                 ON MovementFloat_VATPercent.MovementId = Movement_Income.Id
                                                AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
                     WHERE Movement_Income.Id = inId
                       AND Movement_Income.DescId = zc_Movement_Income());

     -- ���� ���� ������ ���������
     IF inIsBefore = FALSE
     THEN
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_DiscountTax(), inId, ioDiscountTax);
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_SummTaxPVAT(), inId, ioSummTaxPVAT);
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_SummTaxMVAT(), inId, ioSummTaxMVAT);
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_SummPost(), inId, inSummPost);
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_SummPack(), inId, inSummPack);
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_SummInsur(), inId, inSummInsur);
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalDiscountTax(), inId, ioTotalDiscountTax);
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummTaxMVAT(), inId, ioTotalSummTaxMVAT);
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummTaxPVAT(), inId, ioTotalSummTaxPVAT);
     ELSE

         -- �������� ����������� ��������� - ��� ������� � ���� �����
         vbDiscountTax      := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_DiscountTax_calc());
         vbSummTaxPVAT      := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_SummTaxPVAT_calc());
         vbSummTaxMVAT      := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_SummTaxMVAT_calc());
         --
         vbSummPost         := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_SummPost_calc());
         vbSummPack         := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_SummPack_calc());
         vbSummInsur        := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_SummInsur_calc());
         --
         vbTotalDiscountTax := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_TotalDiscountTax_calc());
         vbTotalSummTaxMVAT := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_TotalSummTaxMVAT_calc());
         vbTotalSummTaxPVAT := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_TotalSummTaxPVAT_calc());


         -- ���� ������ �� ����������
         IF vbDiscountTax = ioDiscountTax AND vbSummTaxMVAT = ioSummTaxMVAT AND vbSummTaxPVAT = ioSummTaxPVAT
            AND vbSummPost = inSummPost AND vbSummPack = inSummPack AND vbSummInsur = inSummInsur
            AND vbTotalDiscountTax = ioTotalDiscountTax AND vbTotalSummTaxMVAT = ioTotalSummTaxMVAT AND vbTotalSummTaxPVAT = ioTotalSummTaxPVAT
         THEN
             -- !!!�����!!!
             RETURN;
         END IF;

         -- ��������� % ������
         IF COALESCE (vbDiscountTax,0) <> COALESCE (ioDiscountTax,0)
         THEN
             -- ������ ����� ��� ���
            ioSummTaxMVAT := (inTotalSummMVAT / 100 * ioDiscountTax);
             -- ������ ����� � ���
            ioSummTaxPVAT := zfCalc_SummWVAT (ioSummTaxMVAT, vbVATPercent);
         END IF;

         -- ���������� ����� ������ � ���
         IF COALESCE (vbSummTaxPVAT,0) <> COALESCE (ioSummTaxPVAT,0)
         THEN
             -- ������ ����� ��� ���
             ioSummTaxMVAT := zfCalc_Summ_NoVAT (ioSummTaxPVAT, vbVATPercent);
             -- ������ % ������
             ioDiscountTax := CAST ((CASE WHEN inTotalSummMVAT <> 0 THEN ioSummTaxMVAT*100 / inTotalSummMVAT ELSE 0 END) AS NUMERIC (16,1));
         END IF;

         -- ���������� ����� ������ � ���
         IF COALESCE (vbSummTaxPVAT,0) <> COALESCE (ioSummTaxPVAT,0)
         THEN
             ioDiscountTax := CAST ((CASE WHEN inTotalSummMVAT <> 0 THEN ioSummTaxPVAT*100 / inTotalSummMVAT ELSE 0 END) AS NUMERIC (16,1));
             ioSummTaxMVAT := zfCalc_SummWVAT (ioSummTaxPVAT, vbVATPercent);
         END IF;


         outSumm2 := COALESCE (inTotalSummMVAT,0) - COALESCE (ioSummTaxPVAT,0);
         outSumm3 := COALESCE (outSumm2,0) + COALESCE (inSummPack,0) + COALESCE (inSummPost,0) + COALESCE (inSummInsur,0);

         IF COALESCE (vbTotalDiscountTax,0) <> COALESCE (ioTotalDiscountTax,0)
         THEN
             ioTotalSummTaxPVAT := (outSumm3 / 100 * ioTotalDiscountTax);
             ioTotalSummTaxMVAT := zfCalc_SummWVAT (ioTotalSummTaxPVAT, vbVATPercent);
         END IF;

         IF COALESCE (vbTotalSummTaxPVAT,0) <> COALESCE (ioTotalSummTaxPVAT,0)
         THEN
             ioTotalDiscountTax := CAST ((CASE WHEN outSumm3 <> 0 THEN ioTotalSummTaxPVAT * 100 / outSumm3 ELSE 0 END) AS NUMERIC (16,1));
             ioTotalSummTaxMVAT := zfCalc_SummWVAT (ioTotalSummTaxPVAT, vbVATPercent);
         END IF;

         IF COALESCE (vbTotalSummTaxMVAT,0) <> COALESCE (ioTotalSummTaxMVAT,0)
         THEN
             ioTotalSummTaxPVAT := zfCalc_Summ_NoVAT (ioTotalSummTaxMVAT, vbVATPercent);
             ioTotalDiscountTax := CAST ((CASE WHEN outSumm3 <> 0 THEN ioTotalSummTaxPVAT*100 / outSumm3 ELSE 0 END) AS NUMERIC (16,1));
         END IF;

         outSumm4 := COALESCE (outSumm3,0) - COALESCE (ioTotalSummTaxPVAT,0);

         -- ��������� �������� <>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_DiscountTax(), inId, ioDiscountTax);
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_SummTaxPVAT(), inId, ioSummTaxPVAT);
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_SummTaxMVAT(), inId, ioSummTaxMVAT);
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_SummPost(), inId, inSummPost);
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_SummPack(), inId, inSummPack);
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_SummInsur(), inId, inSummInsur);
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalDiscountTax(), inId, ioTotalDiscountTax);
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummTaxMVAT(), inId, ioTotalSummTaxMVAT);
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummTaxPVAT(), inId, ioTotalSummTaxPVAT);

     END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.10.21         *
*/

-- ����
--
