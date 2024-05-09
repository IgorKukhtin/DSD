-- Function: lpDelete_Movement_IncomeAll(integer, tvarchar)


DROP FUNCTION IF EXISTS lpDelete_Movement_IncomeAll( tvarchar);
DROP FUNCTION IF EXISTS lpDelete_Movement_Income(integer, tvarchar);

CREATE OR REPLACE FUNCTION lpDelete_Movement_Income(
 IN inMovementId Integer,
 IN inSession    tvarchar
)
RETURNS void AS
$BODY$
BEGIN


  --
  CREATE TEMP TABLE _tmpParentId (Id Integer)ON COMMIT DROP;
    INSERT INTO _tmpParentId (Id)
          SELECT Movement.Id
          FROM Movement 
          WHERE Movement.ParentId = inMovementId
          ;
 
    -- "zc_Movement_IncomeCost"   "zc_Movement_Invoice"
    PERFORM lpDelete_Movement (_tmpParentId.Id, inSession)
    FROM  _tmpParentId;
    
    -- ñàì çàêàç
    PERFORM lpDelete_Movement (inMovementId, inSession);    
    
    DROP table _tmpParentId;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ÈÑÒÎÐÈß ÐÀÇÐÀÁÎÒÊÈ: ÄÀÒÀ, ÀÂÒÎÐ
               Ôåëîíþê È.Â.   Êóõòèí È.Â.   Êëèìåíòüåâ Ê.È.
 08.05.24         *
*/
--SELECT * from lpDelete_Movement_Income (5654 ,'5')

/*
perform 
  SELECT lpDelete_Movement_Income (tmpMovement.Id, '5')
     FROM (SELECT *
                               , ROW_NUMBER() OVER (Order by CASE WHEN Movement.StatusId = 3 THEN 1 ELSE 9 END ASC, Movement.Id DESC) AS Ord
                     FROM Movement
                     WHERE DescId = zc_Movement_Income()
                     ) AS tmpMovement
     WHERE tmpMovement.Ord >=3;
*/