-- Function: public.gpupdate_movement_sale_summ(integer, tfloat, tfloat, tfloat, tfloat, tfloat, tfloat, tfloat, tfloat, tfloat, tfloat, boolean, boolean, tvarchar)

-- DROP FUNCTION public.gpupdate_movement_sale_summ(integer, tfloat, tfloat, tfloat, tfloat, tfloat, tfloat, tfloat, tfloat, tfloat, tfloat, boolean, boolean, tvarchar);

CREATE OR REPLACE FUNCTION public.gpupdate_movement_sale_summ(
    IN inid integer,
    IN inbasis_summ1_orig tfloat,
    IN inbasis_summ2_orig tfloat,
    OUT outbasis_summ_orig tfloat,
    IN indiscounttax tfloat,
    IN indiscountnexttax tfloat,
    OUT outsummdiscount1 tfloat,
    OUT outsummdiscount2 tfloat,
    OUT outsummdiscount3 tfloat,
    OUT outsummdiscount_total tfloat,
    OUT outbasis_summ tfloat,
    INOUT iosummtax tfloat,
    INOUT iosummreal tfloat,
    IN intransportsumm_load tfloat,
    IN invatpercent tfloat,
    INOUT iobasis_summ_transport tfloat,
    INOUT iobasiswvat_summ_transport tfloat,
    OUT outtotalsummvat tfloat,
    IN inisbefore boolean,
    IN inisedit boolean,
    IN insession tvarchar)
  RETURNS record AS
$BODY$
   DECLARE vbUserId  Integer;
   DECLARE vbNPP_old TFloat;
   DECLARE vbDiscountTax TFloat;
   DECLARE vbDiscountNextTax TFloat;
   DECLARE vbBasisWVAT_summ_transport TFloat;
   DECLARE vbBasis_summ_transport TFloat;
   DECLARE vbSummReal TFloat;
   DECLARE vbSummTax TFloat;
   DECLARE vbTransportsumm_load TFloat;  
   DECLARE vbVATPercent TFloat;
   DECLARE vbTotalSumm TFloat;
   DECLARE vbisVat Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderClient());
     vbUserId := lpGetUserBySession (inSession);
     
     --RETURN;

     vbisVat          := FALSE;
     -- если надо только сохранить
     IF inIsBefore = FALSE AND inIsEdit = TRUE
     THEN
     
     -- сохранили значение <НДС>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), inId, inVATPercent);
     -- сохранили значение <% скидки>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_DiscountTax(), inId, inDiscountTax);
     -- сохранили значение <% скидки доп>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_DiscountNextTax(), inId, inDiscountNextTax);
     -- сохранили значение <% скидки доп>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TransportSumm_load(), inId, inTransportSumm_load);

     -- пересчитали Итоговые суммы
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm_order (inId);

     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_SummTax(), inId, ioSummTax); 
     -- сохранили значение <ИТОГО откорректированная сумма, с учетом всех скидок, без Транспорта, Сумма продажи без НДС>
     --PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_SummReal(), inId, ioSummReal);
     
     ELSE
 
         -- Получаем сохраненные параметры - для расчета в эдит форме
         IF inIsEdit = FALSE
         THEN
          vbDiscountTax    := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_DiscountTax());
          vbDiscountNextTax:= (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_DiscountNextTax());
          vbSummTax        := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_SummTax());
          vbTotalSumm      := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_TotalSumm());
          vbTransportSumm_load      := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_TransportSumm_load());
          vbVATPercent     := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_VATPercent()); 
        --  vbisVat          := FALSE;     

          vbBasis_summ_transport    := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_Basis_summ_transport_calc());
          vbBasisWVAT_summ_transport:= (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_BasisWVAT_summ_transport_calc());
          vbSummReal       := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_SummReal_calc());
          --vbSummReal       := (COALESCE (vbTotalSumm,0) - COALESCE (vbSummTax,0));
          vbisVat          := (SELECT MB.ValueData FROM MovementBoolean AS MB WHERE MB.MovementId = inId AND MB.DescId = zc_MovementBoolean_isVat_calc()); --какое значение вносилось последним с НДС  Да - нет
         END IF;
   
         IF inIsEdit = TRUE
         THEN
          vbDiscountTax    := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_DiscountTax_calc());
          vbDiscountNextTax:= (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_DiscountNextTax_calc());
          vbSummTax        := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_SummTax_calc());
          vbSummReal       := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_SummReal_calc());
          vbBasis_summ_transport    := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_Basis_summ_transport_calc());
          vbBasisWVAT_summ_transport:= (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_BasisWVAT_summ_transport_calc());
          vbTransportSumm_load      := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_TransportSumm_load_calc());
          vbVATPercent     := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_VATPercent_calc()); 
          vbisVat          := (SELECT MB.ValueData FROM MovementBoolean AS MB WHERE MB.MovementId = inId AND MB.DescId = zc_MovementBoolean_isVat_calc()); --какое значение вносилось последним с НДС  Да - нет
     END IF;

         outBasis_summ_orig := (COALESCE (inBasis_summ1_orig,0) + COALESCE (inBasis_summ2_orig,0));
         
         outSummDiscount1 :=  zfCalc_SummDiscount(COALESCE (inBasis_summ1_orig, 0), inDiscountTax);
         outSummDiscount2 :=  zfCalc_SummDiscount(COALESCE (inBasis_summ1_orig, 0) - zfCalc_SummDiscount(COALESCE (inBasis_summ1_orig, 0), inDiscountTax), inDiscountNextTax);
         outSummDiscount3 := (zfCalc_SummDiscount(COALESCE (inBasis_summ2_orig, 0), inDiscountTax) +  zfCalc_SummDiscount(COALESCE (inBasis_summ2_orig, 0) - zfCalc_SummDiscount(COALESCE (inBasis_summ2_orig, 0), inDiscountTax), inDiscountNextTax));

         outSummDiscount_total := (COALESCE (outSummDiscount1,0) + COALESCE (outSummDiscount2,0) + COALESCE (outSummDiscount3,0));
         outBasis_summ := (COALESCE (inBasis_summ1_orig, 0) + COALESCE (inBasis_summ2_orig, 0) - COALESCE (outSummDiscount_total,0)); 

         -- если ничего не поменялось
         IF vbDiscountTax = inDiscountTax AND vbDiscountNextTax = inDiscountNextTax
            AND vbSummTax = ioSummTax AND vbSummReal = ioSummReal
            AND vbBasis_summ_transport = ioBasis_summ_transport AND vbBasisWVAT_summ_transport = ioBasisWVAT_summ_transport
            AND vbTransportSumm_load = inTransportSumm_load
            AND vbVATPercent = inVATPercent
         THEN
             -- !!!выход!!!
             RETURN;
         END IF;

         vbisVat:= COALESCE (vbisVat,FALSE);

         --процент НДС  
         IF COALESCE (vbVATPercent,0) <> COALESCE (inVATPercent,0)
         THEN  
  
             IF COALESCE (vbisVat, False) = FALSE
             THEN
                 ioBasisWVAT_summ_transport := zfCalc_SummWVAT (vbBasis_summ_transport, inVATPercent);
                 ioSummTax :=  (outBasis_summ - (COALESCE (ioBasis_summ_transport,0) - COALESCE (inTransportSumm_load,0)));
             ELSE
                 ioBasis_summ_transport := zfCalc_Summ_NoVAT (vbBasisWVAT_summ_transport, inVATPercent); 
                 ioBasisWVAT_summ_transport := zfCalc_SummWVAT (ioBasis_summ_transport, inVATPercent);
                 ioSummTax := (outBasis_summ - (zfCalc_Summ_NoVAT (ioBasisWVAT_summ_transport, inVATPercent) - COALESCE (inTransportSumm_load,0)));
                 
             END IF; 
         --сумма со скидкой и транспортом без НДС
         ELSEIF COALESCE (vbBasis_summ_transport,0) <> COALESCE (ioBasis_summ_transport,0)
         THEN 
             --RAISE EXCEPTION '2 Ошибка. Basis_summ_transport %    -  %.', vbBasis_summ_transport, ioBasis_summ_transport;    
             --
             ioSummTax := (outBasis_summ - (COALESCE (ioBasis_summ_transport,0) - COALESCE (inTransportSumm_load,0)));
             --
             PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isVat_calc(), inId, FALSE);
         -- сумма с НДС
         ELSEIF COALESCE (vbBasisWVAT_summ_transport,0) <> COALESCE (ioBasisWVAT_summ_transport,0)
         THEN  
            -- RAISE EXCEPTION '3 Ошибка. BasisWVAT_summ_transport %    -  %.', vbBasisWVAT_summ_transport, ioBasisWVAT_summ_transport;  
             --   
             ioSummTax := (outBasis_summ - (zfCalc_Summ_NoVAT (ioBasisWVAT_summ_transport, inVATPercent) - COALESCE (inTransportSumm_load,0)) );
             --
             PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isVat_calc(), inId, True);
        --- изменилась ручн. скидка
         ELSEIF COALESCE (vbSummTax,0) <> COALESCE (ioSummTax,0)
         THEN  

             ioSummReal := outBasis_summ - COALESCE (ioSummTax,0); 
         --
         ELSEIF COALESCE (vbSummReal,0) <> COALESCE (ioSummReal,0)
         THEN
          --  RAISE EXCEPTION '5 Ошибка. SummReal %    -  %.', vbSummReal, ioSummReal;  
             ---
             ioSummTax:= COALESCE (outBasis_summ, 0) - ioSummReal; 
         END IF;      
         
         ioSummReal := COALESCE (outBasis_summ,0) - COALESCE (ioSummTax,0); 
         ioBasis_summ_transport := (COALESCE (outBasis_summ,0) - COALESCE (ioSummTax) + COALESCE (inTransportSumm_load,0)); 
         ioBasisWVAT_summ_transport := zfCalc_SummWVAT (ioBasis_summ_transport, inVATPercent);       

         outTotalSummVAT := ioBasisWVAT_summ_transport - ioBasis_summ_transport;
         
         --
         PERFORM lpInsertUpdate_MovementFloat (CASE WHEN inIsEdit = FALSE
                                                   THEN zc_MovementFloat_SummTax()--zc_MovementFloat_SummTax()
                                                   ELSE zc_MovementFloat_SummTax_calc()
                                              END, inId, ioSummTax);
       
         PERFORM lpInsertUpdate_MovementFloat (CASE WHEN inIsEdit = FALSE
                                                   THEN zc_MovementFloat_TransportSumm_load() --zc_MovementFloat_TransportSumm_load()
                                                   ELSE zc_MovementFloat_TransportSumm_load_calc()
                                              END, inId, inTransportSumm_load);

         PERFORM lpInsertUpdate_MovementFloat (CASE WHEN inIsEdit = FALSE
                                                   THEN zc_MovementFloat_VATPercent()--zc_MovementFloat_VATPercent()
                                                   ELSE zc_MovementFloat_VATPercent_calc()
                                              END, inId, inVATPercent);

 
        -- IF inIsEdit = TRUE
        -- THEN
              --
              PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_Basis_summ_transport_calc(), inId, ioBasis_summ_transport);
              --
              PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_BasisWVAT_summ_transport_calc(), inId, ioBasisWVAT_summ_transport); 
              --
              PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_SummReal_calc(), inId, ioSummReal);

         --END IF;        


     -- сохранили значение <% скидки>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_DiscountTax(), inId, inDiscountTax);
     -- сохранили значение <% скидки доп>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_DiscountNextTax(), inId, inDiscountNextTax);


     END IF;
 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.01.24         *
*/

-- тест

/*
select * from gpUpdate_Movement_Sale_Summ
(inId := 3175 , inBasis_summ1_orig := 20784.19 , inBasis_summ2_orig := 0 , inDiscountTax := 10 , inDiscountNextTax := 0 ,
 ioSummTax := 0 , ioSummReal := 20784.19 , inTransportSumm_load := 0 , inVATPercent := 0 , ioBasis_summ_transport := 20784.19
  , ioBasisWVAT_summ_transport := 20784.19 , inIsBefore := 'True' , inIsEdit := 'True' ,  inSession := '5');        

*/

--SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = 3175 AND MF.DescId = zc_MovementFloat_TotalSummPVAT()