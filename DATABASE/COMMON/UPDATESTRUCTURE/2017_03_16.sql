DROP FUNCTION IF EXISTS zfCalc_OverDayCount (integer, TDateTime);

CREATE OR REPLACE FUNCTION zfCalc_OverDayCount (IN inContainerId integer, IN inDate TDateTime)
   RETURNS Integer AS
$BODY$
   DECLARE vbAmount TFloat;
   DECLARE vbSumm TFloat;
   DECLARE vbRec RECORD;
   DECLARE vbOverDate TDateTime;
BEGIN
      -- Текущий баланс
      SELECT Amount INTO vbAmount FROM Container WHERE Id = inContainerId;

      IF COALESCE (vbAmount, 0.0) <> 0.0
      THEN
           -- Оборот после заданной даты
           SELECT SUM (MovementItemContainer.Amount)::TFloat 
           INTO vbSumm
           FROM MovementItemContainer 
           WHERE ContainerId = inContainerId
             AND OperDate > inDate;

           -- Баланс на конец заданной даты
           vbAmount:= vbAmount - COALESCE (vbSumm, 0.0)::TFloat;
                
           IF vbAmount = 0.0
           THEN
                RETURN 0;
           ELSE
                FOR vbRec IN 
                    SELECT OperDate
                         , SUM (Amount)::TFloat AS Amount
                    FROM MovementItemContainer
                    WHERE ContainerId = inContainerId
                      AND OperDate <= inDate
                    GROUP BY OperDate
                    ORDER BY OperDate DESC
                LOOP
                     vbAmount:= vbAmount - vbRec.Amount;

                     IF vbAmount = 0.0 
                     THEN
                          RETURN DATE_PART ('day', inDate - vbRec.OperDate)::Integer;
                     END IF;  
                END LOOP;
           END IF;  
      ELSE
           RETURN 0;
      END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Ярошенко Р.Ф.
 16.03.17                                                        *   
*/

-- тест
-- SELECT * FROM zfCalc_OverDayCount (inContainerId:= 310, inDate:= '01.01.2017')
