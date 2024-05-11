-- Function: lpDelete_Movement_OrderClientAll(integer, tvarchar)

DROP FUNCTION IF EXISTS lpDelete_Movement_OrderClient(integer, tvarchar);

CREATE OR REPLACE FUNCTION lpDelete_Movement_OrderClient(
 IN inMovementId Integer,
 IN inSession    tvarchar
)
RETURNS void AS
$BODY$
BEGIN

  /*
  CREATE TEMP TABLE _tmpMovement (Id Integer,  Ord Integer, ProductId Integer) ON COMMIT DROP;
    INSERT INTO _tmpMovement (Id, Ord, ProductId)
     (SELECT *
      FROM (
          SELECT Movement.Id
               , ROW_NUMBER() OVER (Order by CASE WHEN Movement.StatusId = 3 THEN 1 ELSE 9 END ASC, Movement.Id DESC) AS Ord 
               , MovementLinkObject_Product.ObjectId          AS ProductId
          FROM Movement
               LEFT JOIN MovementLinkObject AS MovementLinkObject_Product
                                            ON MovementLinkObject_Product.MovementId = Movement.Id
                                           AND MovementLinkObject_Product.DescId = zc_MovementLinkObject_Product()
          WHERE Movement.DescId = zc_Movement_OrderClient()
           ) AS tmp
      WHERE tmp.Ord >=3
         and tmp.Id = 5488 
      );
         */
         
         
  --zc_Movement_ProductionUnion, Invoice
  CREATE TEMP TABLE _tmpParentId (Id Integer)ON COMMIT DROP;
    INSERT INTO _tmpParentId (Id)
          SELECT Movement.Id
          FROM Movement 
          WHERE Movement.ParentId = inMovementId
          ;  
          
 --  BankAccount
  CREATE TEMP TABLE _tmpMLM (Id Integer)ON COMMIT DROP;
    INSERT INTO _tmpMLM (Id)
          SELECT MLM.MovementId  AS Id
          FROM _tmpParentId
               INNER JOIN MovementLinkMovement AS MLM ON MLM.MovementChildId = _tmpParentId.Id     -- zc_MovementLinkMovement_Invoice 
          WHERE MLM.MovementId <> inMovementId    
          ;
             
     
    --óäàëÿåì ëîäêó 
    PERFORM lpDelete_ObjectForTest (MovementLinkObject_Product.ObjectId, inSession)
    FROM  MovementLinkObject AS MovementLinkObject_Product
    WHERE MovementLinkObject_Product.MovementId = inMovementId
     AND MovementLinkObject_Product.DescId = zc_MovementLinkObject_Product();
     
    --BankAccount
    PERFORM lpDelete_Movement (_tmpMLM.Id, inSession)
    FROM  _tmpMLM;
    
    --zc_Movement_ProductionUnion, Invoice
    PERFORM lpDelete_Movement (_tmpParentId.Id, inSession)
    FROM  _tmpParentId;
    
    -- ñàì çàêàç
    PERFORM lpDelete_Movement (inMovementId, inSession); 
   

DROP table _tmpParentId;
DROP table _tmpMLM;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ÈÑÒÎÐÈß ÐÀÇÐÀÁÎÒÊÈ: ÄÀÒÀ, ÀÂÒÎÐ
               Ôåëîíþê È.Â.   Êóõòèí È.Â.   Êëèìåíòüåâ Ê.È.
 08.05.24         *
*/

--select * from lpDelete_Movement_OrderClient (5488,'5')

/*

SELECT lpDelete_Movement_OrderClient (tmpMovement.Id, '5')
     FROM (SELECT *
                      , ROW_NUMBER() OVER (Order by CASE WHEN Movement.StatusId = 3 THEN 1 ELSE 9 END ASC, Movement.Id DESC) AS Ord
                     FROM Movement
                     WHERE DescId = zc_Movement_OrderClient() --and Movement.Id = 5600
                     ) AS tmpMovement
     WHERE  tmpMovement.Ord >=3 ;
     
     
*/