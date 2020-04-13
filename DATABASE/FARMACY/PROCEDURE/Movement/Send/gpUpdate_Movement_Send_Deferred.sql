-- Function: gpUpdate_Movement_Send_Deferred()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Send_Deferred(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Send_Deferred(
    IN inMovementId          Integer   ,    -- ���� ���������
    IN inisDeferred          Boolean   ,    -- �������
   OUT outisDeferred         Boolean   ,
    IN inSession             TVarChar       -- ������� ������������
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbisDeferred Boolean;
   DECLARE vbisSUN Boolean;
   DECLARE vbisDefSUN Boolean;
   DECLARE vbSumma TFloat;
   DECLARE vbLimitSUN TFloat;
   DECLARE vbGoodsName TVarChar;
   DECLARE vbAmount TFloat;
   DECLARE vbAmountStorage  TFloat;
   DECLARE vbSaldo TFloat;
   DECLARE vbUnit_From Integer;
BEGIN

   IF COALESCE(inMovementId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);

    -- ��������� ���������
    SELECT
        Movement.StatusId,
        COALESCE (MovementBoolean_Deferred.ValueData, FALSE),
        COALESCE (MovementBoolean_SUN.ValueData, FALSE),
        COALESCE (MovementBoolean_DefSUN.ValueData, FALSE),
        COALESCE (MovementFloat_TotalSummFrom.ValueData, 0),
        COALESCE (ObjectFloat_LimitSUN.ValueData, 0),
        MovementLinkObject_From.ObjectId
    INTO
        vbStatusId,
        vbisDeferred,
        vbisSUN,
        vbisDefSUN,
        vbSumma,
        vbLimitSUN,
        vbUnit_From
    FROM Movement
        LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                  ON MovementBoolean_Deferred.MovementId = Movement.Id
                                 AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
        LEFT JOIN MovementBoolean AS MovementBoolean_SUN
                                  ON MovementBoolean_SUN.MovementId = Movement.Id
                                 AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()
        LEFT JOIN MovementBoolean AS MovementBoolean_DefSUN
                                  ON MovementBoolean_DefSUN.MovementId = Movement.Id
                                 AND MovementBoolean_DefSUN.DescId = zc_MovementBoolean_DefSUN()
        LEFT JOIN MovementFloat AS MovementFloat_TotalSummFrom
                                ON MovementFloat_TotalSummFrom.MovementId =  Movement.Id
                               AND MovementFloat_TotalSummFrom.DescId = zc_MovementFloat_TotalSummFrom()
        LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                     ON MovementLinkObject_From.MovementId = Movement.ID
                                    AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

        LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                             ON ObjectLink_Unit_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                            AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
        
        LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                             ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                            AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()

        LEFT JOIN ObjectFloat AS ObjectFloat_LimitSUN
                              ON ObjectFloat_LimitSUN.ObjectId = ObjectLink_Juridical_Retail.ChildObjectId
                             AND ObjectFloat_LimitSUN.DescId = zc_ObjectFloat_Retail_LimitSUN()
    WHERE Movement.Id = inMovementId;
   
    IF vbisDefSUN = TRUE AND inisDeferred = TRUE
    THEN
      RAISE EXCEPTION '������. �������, ���������� ����������� �� ��� ��������� ������.';
    END IF;
    
    IF vbisSUN = TRUE AND COALESCE(vbLimitSUN, 0) > 0 AND vbSumma < COALESCE(vbLimitSUN, 0) AND inisDeferred = TRUE 
       AND NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
    THEN
      RAISE EXCEPTION '������. �������, ����������� �� ��� � ������ ����� % ���. ���������� ������.', COALESCE(vbLimitSUN, 0);
    END IF;

   -- �������� �� ������ � ����������� ����������
   IF COALESCE (vbStatusId, 0) = zc_Enum_Status_UnComplete()
   THEN
       -- ���������� �������
       outisDeferred:=  inisDeferred;
       -- ��������� �������
       PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Deferred(), inMovementId, outisDeferred);
    
       IF inisDeferred = TRUE
       THEN
       
           IF vbisDeferred = TRUE
           THEN
             RAISE EXCEPTION '������.�������� ��� �������!';
           END IF;

           -- �������� �� �� ��� �� �� ������� ������ ��� ���� �� �������
           SELECT Object_Goods.ValueData, tmp.Amount, tmp.AmountRemains
                  INTO vbGoodsName, vbAmount, vbSaldo
           FROM (WITH tmpMI AS (SELECT MovementItem.ObjectId     AS GoodsId
                                     , SUM (MovementItem.Amount) AS Amount
                                FROM MovementItem
                                WHERE MovementItem.MovementId = inMovementId
                                  AND MovementItem.DescId = zc_MI_Master()
                                  AND MovementItem.isErased = FALSE
                                  AND MovementItem.Amount <> 0
                                GROUP BY MovementItem.ObjectId
                               )
             , tmpContainer AS (SELECT Container.ObjectId     AS GoodsId
                                     , SUM (Container.Amount) AS Amount
                                FROM tmpMI
                                     INNER JOIN Container ON Container.ObjectId = tmpMI.GoodsId
                                                         AND Container.DescId = zc_Container_Count()
                                                         AND Container.Amount <> 0
                                     INNER JOIN ContainerLinkObject AS CLO_From
                                                                    ON CLO_From.ContainerId = Container.Id
                                                                   AND CLO_From.ObjectId    = vbUnit_From
                                                                   AND CLO_From.DescId      = zc_ContainerLinkObject_Unit()
                                GROUP BY Container.ObjectId
                               )
                 SELECT tmpMI.GoodsId, tmpMI.Amount
                      , COALESCE (tmpContainer.Amount, 0) AS AmountRemains
                 FROM tmpMI
                      LEFT JOIN tmpContainer ON tmpContainer.GoodsId = tmpMI.GoodsId
                 WHERE tmpMI.Amount > COALESCE (tmpContainer.Amount, 0)
                ) AS tmp
                LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmp.GoodsId
           LIMIT 1;
           
           IF (COALESCE(vbGoodsName,'') <> '') 
           THEN
               RAISE EXCEPTION '������. �� ������ <%> ��� ����� ������� ���-�� ����������� <%> ������, ��� ���� �� ������� <%>.', vbGoodsName, vbAmount, vbSaldo;
           END IF;

           -- ��������: �� ��������� ��������� ����������� - � ������� ������� - "���-�� ����������" ���������� �� ���-�� "���� ���-��". 
           vbGoodsName := '';
           SELECT Object_Goods.ValueData, tmp.Amount, tmp.AmountStorage
           INTO vbGoodsName, vbAmount, vbAmountStorage
           FROM (SELECT MovementItem.ObjectId                             AS GoodsId
                      , SUM (MovementItem.Amount)                         AS Amount
                      , SUM (COALESCE(MIFloat_AmountStorage.ValueData,0))  AS AmountStorage
                 FROM MovementItem
                      LEFT JOIN MovementItemFloat AS MIFloat_AmountStorage
                                                  ON MIFloat_AmountStorage.MovementItemId = MovementItem.Id
                                                 AND MIFloat_AmountStorage.DescId = zc_MIFloat_AmountStorage()
                 WHERE MovementItem.MovementId = inMovementId
                   AND MovementItem.DescId = zc_MI_Master()
                   AND MovementItem.isErased = FALSE
                 GROUP BY MovementItem.ObjectId
                ) AS tmp
                LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmp.GoodsId
           WHERE tmp.Amount <> tmp.AmountStorage
             AND zfCalc_AccessKey_SendAll (vbUserId) = FALSE -- !!!���� ������������� - ���������!!!
           LIMIT 1
           ;

           IF vbGoodsName <> '' AND 
              vbUserId NOT IN (375661, 2301972, 183242) -- ����� ���� �����������              
           THEN
               RAISE EXCEPTION '������. �� ������ <%> ��� ����� ������� ���-�� ���������� <%> ���������� �� ���� ���-�� �����-����������� <%>.', vbGoodsName, vbAmount, vbAmountStorage;
           END IF;


           -- �����	����� ��������
           PERFORM lpComplete_Movement_Send(inMovementId  -- ���� ���������
                                          , vbUserId);    -- ������������  
       ELSE
           -- ������� ��������
           PERFORM lpUnComplete_Movement (inMovementId
                                        , vbUserId);
       END IF;
   ELSE
       RAISE EXCEPTION '������. ���������� �������� � ������� <%> �� ��������.', lfGet_Object_ValueData (vbStatusId);   
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
 06.02.20                                                                      *
 08.11.17         *
*/
