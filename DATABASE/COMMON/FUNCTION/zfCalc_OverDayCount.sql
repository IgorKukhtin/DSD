DROP FUNCTION IF EXISTS zfCalc_OverDayCount (integer, TDateTime);
DROP FUNCTION IF EXISTS zfCalc_OverDayCount (integer, TFloat, TDateTime);

CREATE OR REPLACE FUNCTION zfCalc_OverDayCount (IN inContainerId integer, IN inOverSum TFloat, IN inDate TDateTime)
   RETURNS Integer AS
$BODY$
   DECLARE vbAmount TFloat;
   DECLARE vbRec RECORD;
   DECLARE vbOverDayCount Integer := 0;
BEGIN
      vbAmount:= COALESCE (inOverSum, 0.0)::TFloat;

      IF vbAmount > 0.0
      THEN
           -- Первый период
           FOR vbRec IN 
               SELECT OperDate
                    , SUM (Amount)::TFloat AS Amount
               FROM MovementItemContainer
               WHERE ContainerId = inContainerId
                 AND (MovementDescId = zc_Movement_Sale()
                  OR (MovementDescId = zc_Movement_TransferDebtOut() AND isActive))
                 AND OperDate BETWEEN inDate - INTERVAL '30 DAY' AND inDate
               GROUP BY OperDate
               ORDER BY OperDate DESC
           LOOP
                vbAmount:= vbAmount - vbRec.Amount;

                IF vbAmount <= 0.0 
                THEN
                     vbOverDayCount:= DATE_PART ('day', inDate - vbRec.OperDate)::Integer + 1;

                     RETURN vbOverDayCount;
                END IF;  
           END LOOP;
           
           -- Второй период
           IF vbAmount > 0.0
           THEN
               FOR vbRec IN 
                   SELECT OperDate
                        , SUM (Amount)::TFloat AS Amount
                   FROM MovementItemContainer
                   WHERE ContainerId = inContainerId
                     AND (MovementDescId = zc_Movement_Sale()
                      OR (MovementDescId = zc_Movement_TransferDebtOut() AND isActive))
                     AND OperDate BETWEEN inDate - INTERVAL '80 DAY' AND inDate - INTERVAL '31 DAY'
                   GROUP BY OperDate
                   ORDER BY OperDate DESC
               LOOP
                    vbAmount:= vbAmount - vbRec.Amount;
    
                    IF vbAmount <= 0.0 
                    THEN
                         vbOverDayCount:= DATE_PART ('day', inDate - vbRec.OperDate)::Integer + 1;
    
                         RETURN vbOverDayCount;
                    END IF;  
               END LOOP;
           END IF;
           
           -- Третий период
           IF vbAmount > 0.0
           THEN
               FOR vbRec IN 
                   SELECT OperDate
                        , SUM (Amount)::TFloat AS Amount
                   FROM MovementItemContainer
                   WHERE ContainerId = inContainerId
                     AND (MovementDescId = zc_Movement_Sale()
                      OR (MovementDescId = zc_Movement_TransferDebtOut() AND isActive))
                     AND OperDate BETWEEN inDate - INTERVAL '180 DAY' AND inDate - INTERVAL '81 DAY'
                   GROUP BY OperDate
                   ORDER BY OperDate DESC
               LOOP
                    vbAmount:= vbAmount - vbRec.Amount;
    
                    IF vbAmount <= 0.0 
                    THEN
                         vbOverDayCount:= DATE_PART ('day', inDate - vbRec.OperDate)::Integer + 1;
    
                         RETURN vbOverDayCount;
                    END IF;  
               END LOOP;
           END IF;


           -- Последний
           IF vbAmount > 0.0
           THEN
               -- пусть пока будет эта константа
               vbOverDayCount:= 181;

           END IF;

      END IF;

      RETURN vbOverDayCount;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Ярошенко Р.Ф.
 16.03.17                                                        *   
*/

-- тест
-- SELECT * FROM zfCalc_OverDayCount (inContainerId:= 310, inOverSum:= 1000.0, inDate:= '01.01.2017')
