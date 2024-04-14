
-- Function: gpUpdate_MI_Invoice_SummCalc()

DROP FUNCTION IF EXISTS gpUpdate_MI_Invoice_SummCalc (Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_Invoice_SummCalc(
    IN inId                      Integer   , -- Ключ объекта <Документ>  
    IN inMovementId              Integer   , -- Ключ объекта <>
    IN inAmount                  TFloat    , --
 INOUT ioOperPrice               TFloat    , -- 
 INOUT ioSummMVAT                TFloat    , -- 
 INOUT ioSummPVAT                TFloat    , -- 
   OUT outSummVAT                TFloat    , -- 
    IN inSession                 TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId         Integer;
   DECLARE vbOperPrice_calc TFloat;
           vbSummMVAT_calc  TFloat;
           vbSummPVAT_calc  TFloat;
           vbVATPercent     TFloat;
           vbAmount_calc    TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderClient());
     vbUserId := lpGetUserBySession (inSession);
     
     vbVATPercent := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inMovementId AND MF.DescId = zc_MovementFloat_VATPercent());
     
         -- Получаем сохраненные параметры - для расчета в эдит форме
     /*    IF inIsEdit = FALSE
         THEN
          vbDiscountTax    := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_DiscountTax());
          vbDiscountNextTax:= (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_DiscountNextTax());
          vbSummTax        := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_SummTax());
          
          vbTotalSumm      := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_TotalSumm());
          vbTransportSumm_load      := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_TransportSumm_load());
          vbVATPercent     := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_VATPercent()); 
          vbisVat          := FALSE;
          --vbBasis_summ_transport    := (COALESCE (vbTotalSumm,0) - COALESCE (vbSummTax,0) + COALESCE (vbTransportSumm_load,0));
          --vbBasisWVAT_summ_transport:= zfCalc_SummWVAT (vbBasis_summ_transport, vbVATPercent);
          --vbSummReal       := (COALESCE (vbTotalSumm,0) - COALESCE (vbSummTax,0));    
          vbBasis_summ_transport    := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_Basis_summ_transport_calc());
          vbBasisWVAT_summ_transport:= (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_BasisWVAT_summ_transport_calc());
          vbSummReal       := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_SummReal_calc());
          vbisVat          := (SELECT MB.ValueData FROM MovementBoolean AS MB WHERE MB.MovementId = inId AND MB.DescId = zc_MovementBoolean_isVat_calc());
         END IF;
      */


          vbAmount_calc    := (SELECT MF.ValueData FROM MovementItemFloat AS MF WHERE MF.MovementItemId = inId AND MF.DescId = zc_MIFloat_Amount_calc()); --(SELECT MI.Amount FROM MovementItem AS MI WHERE MI.Id = inId );
          vbOperPrice_calc := (SELECT MF.ValueData FROM MovementItemFloat AS MF WHERE MF.MovementItemId = inId AND MF.DescId = zc_MIFloat_OperPrice_calc());
          vbSummMVAT_calc  := (SELECT MF.ValueData FROM MovementItemFloat AS MF WHERE MF.MovementItemId = inId AND MF.DescId = zc_MIFloat_SummMVAT_calc());
          vbSummPVAT_calc  := (SELECT MF.ValueData FROM MovementItemFloat AS MF WHERE MF.MovementItemId = inId AND MF.DescId = zc_MIFloat_SummPVAT_calc());
        
          outSummVAT := (ioSummPVAT - ioSummMVAT);
         -- ioMVAT
  
          --vbisVat          := (SELECT MB.ValueData FROM MovementBoolean AS MB WHERE MB.MovementId = inId AND MB.DescId = zc_MovementBoolean_isVat_calc()); --какое значение вносилось последним с НДС  Да - нет
    
    
          --RAISE EXCEPTION '2 Ошибка. Basis_summ_transport %    .', outSummDiscount_total;   

          -- если ничего не поменялось
         IF vbOperPrice_calc = ioOperPrice AND vbSummMVAT_calc = ioSummMVAT AND vbSummPVAT_calc = ioSummPVAT  
         AND (vbAmount_calc = inAmount)
         THEN
             -- !!!выход!!!
             RETURN;
         END IF;

         --vbisVat:= COALESCE (vbisVat,FALSE);

/*

     vbVATPercent := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inMovementId AND MF.DescId = zc_MovementFloat_VATPercent());
     vbSummMVAT := (COALESCE (inAmount,0) * COALESCE (inOperPrice, 0));
     vbSummPVAT := zfCalc_SummWVAT_4 ((COALESCE (inAmount,0) * COALESCE (inOperPrice, 0)) ::TFloat, vbVATPercent);

*/
--RAISE EXCEPTION 'Ошибка. %  %    ', vbOperPrice_calc  , ioOperPrice;      
   --  
         IF (COALESCE (vbOperPrice_calc,0) <> COALESCE (ioOperPrice,0)) OR (vbAmount_calc <> inAmount)
         THEN  
         --RAISE EXCEPTION '1 Ошибка.  '; 
             ioSummMVAT := (COALESCE (inAmount,0) * COALESCE (ioOperPrice, 0)); 
             ioSummPVAT := zfCalc_SummWVAT_4 ((COALESCE (inAmount,0) * COALESCE (ioOperPrice, 0)) ::TFloat, vbVATPercent);
             outSummVAT := (ioSummPVAT - ioSummMVAT);
         --
         ELSEIF COALESCE (vbSummMVAT_calc,0) <> COALESCE (ioSummMVAT,0)
         THEN 
            -- RAISE EXCEPTION '2 Ошибка. ';    
             --

             ioOperPrice := CASE WHEN COALESCE (inAmount,0) <> 0 THEN ioSummMVAT / inAmount ELSE 0 END;
 
             ioSummPVAT  := zfCalc_SummWVAT_4 (COALESCE (ioSummMVAT,0) ::TFloat, vbVATPercent); 
             outSummVAT := (ioSummPVAT - ioSummMVAT);
             --
             --PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isVat_calc(), inId, FALSE);
         --
         ELSEIF COALESCE (vbSummPVAT_calc,0) <> COALESCE (ioSummPVAT,0)
         THEN 
             --RAISE EXCEPTION '3 Ошибка. ';    
             --
             ioSummMVAT  := zfCalc_Summ_NoVAT (COALESCE (ioSummPVAT,0) ::TFloat, vbVATPercent);   
             ioOperPrice := CASE WHEN COALESCE (inAmount,0) <> 0 THEN ioSummMVAT / inAmount ELSE 0 END;
             outSummVAT := (ioSummPVAT - ioSummMVAT);
              
         END IF;      
         
         --
           
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Amount_calc(), inId, inAmount);
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPrice_calc(), inId, ioOperPrice);
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummMVAT_calc(), inId, ioSummMVAT);
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummPVAT_calc(), inId, ioSummPVAT);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.04.24         *
*/

-- тест
--
/*
*/


--select * from gpUpdate_MI_Invoice_SummCalc(inId := 556400 , inMovementId := 919 , inAmount := 1 , ioOperPrice := 550 , ioSummMVAT := 550 , ioSummPVAT := 654 ,  inSession := '5');

--select * from gpGet_MovementItem_Invoice(inId := 556400 ,  inSession := '5');