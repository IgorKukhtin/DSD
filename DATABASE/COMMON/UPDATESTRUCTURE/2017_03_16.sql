DROP FUNCTION IF EXISTS zfCalc_OverDayCount (integer, TDateTime);
DROP FUNCTION IF EXISTS zfCalc_OverDayCount (integer, TFloat, TDateTime);

CREATE OR REPLACE FUNCTION zfCalc_OverDayCount (IN inContainerId integer, IN inOverSum TFloat, IN inDate TDateTime)
   RETURNS Integer AS
$BODY$
   DECLARE vbAmount TFloat;
   DECLARE vbRec RECORD;
BEGIN
      vbAmount:= COALESCE (inOverSum, 0.0)::TFloat;

      IF vbAmount > 0.0
      THEN
           FOR vbRec IN 
               SELECT OperDate
                    , SUM (Amount)::TFloat AS Amount
               FROM MovementItemContainer
               WHERE ContainerId = inContainerId
                 AND (MovementDescId = zc_Movement_Sale()
                  OR (MovementDescId = zc_Movement_TransferDebtOut() AND isActive))
                 AND OperDate < inDate
               GROUP BY OperDate
               ORDER BY OperDate DESC
           LOOP
                vbAmount:= vbAmount - vbRec.Amount;

                IF vbAmount <= 0.0 
                THEN
                     RETURN DATE_PART ('day', inDate - vbRec.OperDate)::Integer;
                END IF;  
           END LOOP;
      END IF;

      RETURN 0;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ÈÑÒÎÐÈß ÐÀÇÐÀÁÎÒÊÈ: ÄÀÒÀ, ÀÂÒÎÐ
               Ôåëîíþê È.Â.   Êóõòèí È.Â.   Êëèìåíòüåâ Ê.È.  ßðîøåíêî Ð.Ô.
 16.03.17                                                        *   
*/

-- òåñò
-- SELECT * FROM zfCalc_OverDayCount (inContainerId:= 310, inOverSum:= 1000.0, inDate:= '01.01.2017')
