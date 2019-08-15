-- Function: gpUpdate_Movement_Sale_Deferred()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Sale_Deferred(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Sale_Deferred(
    IN inMovementId          Integer   ,    -- ���� ���������
    IN inisDeferred          Boolean   ,    -- �������
   OUT outisDeferred         Boolean   ,
    IN inSession             TVarChar       -- ������� ������������
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbStatusId   Integer;
   DECLARE vbGoodsName  TVarChar;
   DECLARE vbAmount     TFloat;
   DECLARE vbSaldo      TFloat;
   DECLARE vbUnitId     Integer;
   DECLARE vbisDeferred Boolean;
BEGIN

   IF COALESCE(inMovementId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);

    SELECT Movement_Sale.StatusId,
           Movement_Sale.UnitId,
           COALESCE (MovementBoolean_Deferred.ValueData, FALSE) ::Boolean
    INTO vbStatusId, 
         vbUnitId,
         vbIsDeferred
    FROM Movement_Sale_View AS Movement_Sale
         LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                   ON MovementBoolean_Deferred.MovementId = Movement_Sale.Id
                                  AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
    WHERE Movement_Sale.Id = inMovementId;


   -- �������� �� ������ � ����������� ����������
   IF COALESCE (vbStatusId, 0) <> zc_Enum_Status_Complete()
   THEN
       -- ���������� �������
       outisDeferred:=  inisDeferred;
       -- ��������� �������
       PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Deferred(), inMovementId, outisDeferred);
    
       IF inisDeferred = TRUE
       THEN

/*           --�������� �� �� ��� �� �� ������� ������ ��� ���� �� �������
           SELECT MI_Sale.GoodsName
                , COALESCE(MI_Sale.Amount,0)
                , COALESCE(SUM(Container.Amount),0) 
           INTO 
               vbGoodsName
             , vbAmount
             , vbSaldo 
           FROM MovementItem_Sale_View AS MI_Sale
               LEFT OUTER JOIN Container ON MI_Sale.GoodsId = Container.ObjectId
                                        AND Container.WhereObjectId = vbUnitId
                                        AND Container.DescId = zc_Container_Count()
                                        AND Container.Amount > 0
           WHERE MI_Sale.MovementId = inMovementId
             AND MI_Sale.isErased = FALSE
           GROUP BY MI_Sale.GoodsId
                  , MI_Sale.GoodsName
                  , MI_Sale.Amount
           HAVING COALESCE (MI_Sale.Amount, 0) > COALESCE (SUM (Container.Amount) ,0);
          
           IF (COALESCE(vbGoodsName,'') <> '') 
           THEN
              RAISE EXCEPTION '������. �� ������ <%> ��� ����� ������� ���-�� ������� <%> ������, ��� ���� �� ������� <%>.', vbGoodsName, vbAmount, vbSaldo;
           END IF;
*/
           -- ���������� ��������
           PERFORM lpComplete_Movement_Sale(inMovementId  -- ���� ���������
                                          , 0             -- ���� ������ ���������
                                          , vbUserId);    -- ������������  
       ELSE
           -- ������� ��������
           PERFORM lpUnComplete_Movement (inMovementId
                                        , vbUserId);
       END IF;
   END IF;
   
   outisDeferred := COALESCE (outisDeferred, COALESCE (vbisDeferred, FALSE));
   
   -- ���������� ������ ���������
   -- UPDATE Movement SET StatusId = vbStatusId WHERE Id = inMovementId;
   
   -- ��������� ��������
   PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.  ������ �.�.
 01.08.19                                                                      *
