DROP FUNCTION IF EXISTS zfCalc_OverDayCount2 (Integer, TFloat, TDateTime);

CREATE OR REPLACE FUNCTION zfCalc_OverDayCount2 (IN inContainerId Integer, IN inDebtSum TFloat, IN inDate TDateTime)
   RETURNS Integer AS
$BODY$
   DECLARE vbAmount TFloat;
   DECLARE vbSumm TFloat;
   DECLARE vbRec RECORD;
   DECLARE vbOverDayCount Integer := 0;
BEGIN
      IF COALESCE (inDebtSum, 0.0) > 0.0
      THEN
           SELECT SUM (Amount)::TFloat
           INTO vbSumm
           FROM MovementItemContainer
           WHERE ContainerId = inContainerId
             AND OperDate >= inDate;

           vbAmount:= COALESCE (inDebtSum, 0.0)::TFloat - COALESCE (vbSumm, 0.0)::TFloat;
 
           IF vbAmount > 0.0
           THEN
                FOR vbRec IN 
                    SELECT OperDate
                         , SUM (Amount)::TFloat AS Amount
                    FROM MovementItemContainer
                    WHERE ContainerId = inContainerId
                      AND OperDate < inDate
                    GROUP BY OperDate
                    ORDER BY OperDate DESC
                LOOP
                     vbAmount:= vbAmount - vbRec.Amount;

                     IF vbAmount <= 0.0 
                     THEN
                          vbOverDayCount:= DATE_PART ('day', inDate - vbRec.OperDate)::Integer;

                          RETURN vbOverDayCount;
                     END IF;  
                END LOOP;
           END IF;
      END IF;

      RETURN vbOverDayCount;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ÈÑÒÎÐÈß ÐÀÇÐÀÁÎÒÊÈ: ÄÀÒÀ, ÀÂÒÎÐ
               Ôåëîíþê È.Â.   Êóõòèí È.Â.   Êëèìåíòüåâ Ê.È.  ßðîøåíêî Ð.Ô.
 16.03.17                                                        *   
*/

-- òåñò
-- SELECT * FROM zfCalc_OverDayCount2 (inContainerId:= 310, inDebtSum:= 1000.0, inDate:= '01.01.2017')
