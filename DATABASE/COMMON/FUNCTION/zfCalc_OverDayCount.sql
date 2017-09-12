DROP FUNCTION IF EXISTS zfCalc_OverDayCount (integer, TDateTime);
DROP FUNCTION IF EXISTS zfCalc_OverDayCount (integer, TFloat, TDateTime);

CREATE OR REPLACE FUNCTION zfCalc_OverDayCount (IN inContainerId integer, IN inOverSum TFloat, IN inDate TDateTime)
   RETURNS Integer AS
$BODY$
   DECLARE vbAmount TFloat;
   DECLARE vbRec RECORD;
   DECLARE vbOverDayCount Integer;
BEGIN
      vbAmount:= COALESCE (inOverSum, 0.0)::TFloat;
      vbOverDayCount:= 0;

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
                     vbOverDayCount:= DATE_PART ('day', inDate - vbRec.OperDate)::Integer;

                     IF vbOverDayCount > 0 AND vbOverDayCount <= 7 THEN
                       vbOverDayCount:= 7;
                     ELSIF vbOverDayCount > 7 AND vbOverDayCount <= 14 THEN
                       vbOverDayCount:= 14;
                     ELSIF vbOverDayCount > 14 AND vbOverDayCount <= 21 THEN
                       vbOverDayCount:= 21;  
                     ELSIF vbOverDayCount > 21 AND vbOverDayCount <= 28 THEN
                       vbOverDayCount:= 28;  
                     END IF;

                     RETURN vbOverDayCount;
                END IF;  
           END LOOP;
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
-- SELECT * FROM zfCalc_OverDayCount (inContainerId:= 310, inOverSum:= 1000.0, inDate:= '01.01.2017')
