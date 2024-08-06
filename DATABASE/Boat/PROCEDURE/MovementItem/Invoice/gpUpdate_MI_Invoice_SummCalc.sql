
-- Function: gpUpdate_MI_Invoice_SummCalc()

DROP FUNCTION IF EXISTS gpUpdate_MI_Invoice_SummCalc (Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_MI_Invoice_SummCalc (Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_Invoice_SummCalc(
    IN inId                      Integer   , -- Ключ объекта <Документ>  
    IN inMovementId              Integer   , -- Ключ объекта <>
    IN inAmount                  TFloat    , --
 INOUT ioOperPrice               TFloat    , -- 
 INOUT ioSummMVAT                TFloat    , -- 
 INOUT ioSummPVAT                TFloat    , -- 
   OUT outSummVAT                TFloat    , --
 --для расчета  
 INOUT ioAmount_calc             TFloat    , --
 INOUT ioOperPrice_calc          TFloat    , -- 
 INOUT ioSummMVAT_calc           TFloat    , -- 
 INOUT ioSummPVAT_calc           TFloat    , --

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
     
     /*
     vbAmount_calc    := COALESCE ((SELECT MF.ValueData FROM MovementItemFloat AS MF WHERE MF.MovementItemId = inId AND MF.DescId = zc_MIFloat_Amount_calc()), 1)::TFloat; --(SELECT MI.Amount FROM MovementItem AS MI WHERE MI.Id = inId );
     vbOperPrice_calc := COALESCE ((SELECT MF.ValueData FROM MovementItemFloat AS MF WHERE MF.MovementItemId = inId AND MF.DescId = zc_MIFloat_OperPrice_calc()), 0)::TFloat;
     vbSummMVAT_calc  := COALESCE ((SELECT MF.ValueData FROM MovementItemFloat AS MF WHERE MF.MovementItemId = inId AND MF.DescId = zc_MIFloat_SummMVAT_calc()), 0)::TFloat;
     vbSummPVAT_calc  := COALESCE ((SELECT MF.ValueData FROM MovementItemFloat AS MF WHERE MF.MovementItemId = inId AND MF.DescId = zc_MIFloat_SummPVAT_calc()), 0)::TFloat;
     */   
          outSummVAT := (ioSummPVAT - ioSummMVAT);
         -- ioMVAT
  
          --vbisVat          := (SELECT MB.ValueData FROM MovementBoolean AS MB WHERE MB.MovementId = inId AND MB.DescId = zc_MovementBoolean_isVat_calc()); --какое значение вносилось последним с НДС  Да - нет
    
    
          --RAISE EXCEPTION '2 Ошибка. Basis_summ_transport %    .', outSummDiscount_total;   

          -- если ничего не поменялось
         IF ioOperPrice_calc = ioOperPrice AND ioSummMVAT_calc = ioSummMVAT AND ioSummPVAT_calc = ioSummPVAT  
         AND (ioAmount_calc = inAmount)
         THEN
             -- !!!выход!!!
             RETURN;
         END IF;

         --vbisVat:= COALESCE (vbisVat,FALSE);


   --RAISE EXCEPTION 'Ошибка. %  %    ', vbOperPrice_calc  , ioOperPrice;      
   --  
         IF (COALESCE (ioOperPrice_calc,0) <> COALESCE (ioOperPrice,0)) OR (ioAmount_calc <> inAmount)
         THEN  
         --RAISE EXCEPTION '1 Ошибка.  '; 
             ioSummMVAT := (COALESCE (inAmount,0) * COALESCE (ioOperPrice, 0)); 
             ioSummPVAT := zfCalc_SummWVAT_4 ((COALESCE (inAmount,0) * COALESCE (ioOperPrice, 0)) ::TFloat, vbVATPercent);
             outSummVAT := (ioSummPVAT - ioSummMVAT);
         --
         ELSEIF COALESCE (ioSummMVAT_calc,0) <> COALESCE (ioSummMVAT,0)
         THEN 
            -- RAISE EXCEPTION '2 Ошибка. ';    
             --

             ioOperPrice := CASE WHEN COALESCE (inAmount,0) <> 0 THEN ioSummMVAT / inAmount ELSE 0 END;
 
             ioSummPVAT  := zfCalc_SummWVAT_4 (COALESCE (ioSummMVAT,0) ::TFloat, vbVATPercent); 
             outSummVAT := (ioSummPVAT - ioSummMVAT);
             --
             --PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isVat_calc(), inId, FALSE);
         --
         ELSEIF COALESCE (ioSummPVAT_calc,0) <> COALESCE (ioSummPVAT,0)
         THEN 
             --RAISE EXCEPTION '3 Ошибка. ';    
             --
             ioSummMVAT  := zfCalc_Summ_NoVAT (COALESCE (ioSummPVAT,0) ::TFloat, vbVATPercent);   
             ioOperPrice := CASE WHEN COALESCE (inAmount,0) <> 0 THEN ioSummMVAT / inAmount ELSE 0 END;
             outSummVAT := (ioSummPVAT - ioSummMVAT);
              
         END IF;      
         
         -- 
         IF COALESCE (inId,0) <> 0
         THEN
            PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Amount_calc(), inId, inAmount);
            PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPrice_calc(), inId, ioOperPrice);
            PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummMVAT_calc(), inId, ioSummMVAT);
            PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummPVAT_calc(), inId, ioSummPVAT);
         END IF; 
         --
         ioAmount_calc := inAmount;
         ioOperPrice_calc := ioOperPrice;
         ioSummMVAT_calc := ioSummMVAT;
         ioSummPVAT_calc := ioSummPVAT;

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