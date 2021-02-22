-- Function: zfCalc_MarginPercent_PromoBonuszfCalc_MarginPercent_PromoBonus

DROP FUNCTION IF EXISTS zfCalc_MarginPercent_PromoBonus (TFloat, TFloat, TFloat, TFloat, TFloat);

CREATE OR REPLACE FUNCTION zfCalc_MarginPercent_PromoBonus (
       IN inMarginPercent TFloat    
     , IN inPromoBonus TFloat        
     , IN inUpperLimitPromoBonus TFloat
     , IN inLowerLimitPromoBonus TFloat
     , IN inMinPercentPromoBonus TFloat)
RETURNS TFloat
AS
$BODY$
   DECLARE vbRet TFloat;
BEGIN
     
     --
     vbRet := inMarginPercent;
     
     IF COALESCE(inPromoBonus, 0) = 0
     THEN
       RETURN vbRet;
     END IF;
     
     if inPromoBonus >= inUpperLimitPromoBonus
     THEN
       vbRet := inMinPercentPromoBonus;
     ELSEIF inMarginPercent + inPromoBonus >= inUpperLimitPromoBonus
     THEN
       vbRet := vbRet - (inMarginPercent + inPromoBonus - inUpperLimitPromoBonus);
     ELSEIF inMarginPercent + inPromoBonus > inLowerLimitPromoBonus
     THEN
       vbRet := vbRet - (inMarginPercent + inPromoBonus - inLowerLimitPromoBonus);
     END IF;
     
     IF vbRet < inMinPercentPromoBonus
     THEN
       vbRet := inMinPercentPromoBonus;       
     END IF;

     -- Ðåçóëüòàò
     RETURN vbRet;

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

/*-------------------------------------------------------------------------------*/
/*
 ÈÑÒÎÐÈß ÐÀÇÐÀÁÎÒÊÈ: ÄÀÒÀ, ÀÂÒÎÐ
               Ôåëîíþê È.Â.   Êóõòèí È.Â.   Êëèìåíòüåâ Ê.È.   Øàáëèé Î.Â.
 19.02.19                                                       *
*/

-- òåñò
-- 
SELECT zfCalc_MarginPercent_PromoBonus (1, 7, 10, 7, 1)