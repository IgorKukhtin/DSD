-- Function: zfCalc_PromoMovementName

DROP FUNCTION IF EXISTS zfCalc_PromoMovementName (Integer, TVarChar, TDateTime, TDateTime, TDateTime);

CREATE OR REPLACE FUNCTION zfCalc_PromoMovementName(
    IN inMovementId                Integer   , -- 
    IN inInvNumber                 TVarChar  , -- 
    IN inOperDate                  TDateTime , -- 
    IN inStartSale                 TDateTime , -- 
    IN inEndSale                   TDateTime   -- 
)
RETURNS TVarChar AS
$BODY$
BEGIN
     IF inMovementId <> 0
     THEN RETURN ((SELECT zfCalc_PromoMovementName (NULL, Movement_Promo_View.InvNumber :: TVarChar, Movement_Promo_View.OperDate, Movement_Promo_View.StartSale, Movement_Promo_View.EndSale)
                   FROM Movement_Promo_View
                   WHERE Movement_Promo_View.Id = inMovementId));
     ELSE
         -- возвращаем результат
         RETURN (' ' || zfConvert_DateToString (inStartSale) :: TVarChar || ' _ ' || zfConvert_DateToString (inEndSale)
              || '  № ' || inInvNumber || ' _ ' || zfConvert_DateToString (inOperDate) :: TVarChar
              :: TVarChar);
     END IF;

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.11.15                                        *
*/

-- тест
-- SELECT * FROM zfCalc_PromoMovementName (inMovementId:= 2641111, inInvNumber:= NULL, inOperDate:= NULL, inStartSale:= NULL, inEndSale:= NULL)
