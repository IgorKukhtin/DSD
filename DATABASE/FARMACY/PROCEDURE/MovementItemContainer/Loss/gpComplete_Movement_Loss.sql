-- Function: gpComplete_Movement_Loss()

DROP FUNCTION IF EXISTS gpComplete_Movement_Loss  (Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpComplete_Movement_Loss  (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Loss(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId    Integer;
  DECLARE vbGoodsName TVarChar;
  DECLARE vbAmount    TFloat;
  DECLARE vbSaldo     TFloat;
  DECLARE vbOperDate  TDateTime;
  DECLARE vbUnitId    Integer;
BEGIN
    vbUserId:= inSession;
    vbGoodsName := '';
    SELECT
        Movement.OperDate,
        MovementLinkObject.ObjectId
    INTO
        vbOperDate,
        vbUnitId
    FROM
        Movement
        INNER JOIN MovementLinkObject ON MovementLinkObject.MovementId = Movement.Id
                                     AND MovementLinkObject.DescId = zc_MovementLinkObject_Unit()
    WHERE
        MovementId = inMovementId;
  --�������� �� �� ��� �� �� ������� ������ ��� ���� �� �������
    WITH REMAINS AS ( --������� �� ���� ���������
                                SELECT 
                                    T0.ObjectId
                                   ,SUM(T0.Amount)::TFloat as Amount
                                FROM(
                                        SELECT 
                                            Container.Id 
                                           ,Container.ObjectId --�����
                                           ,(Container.Amount - COALESCE(SUM(MovementItemContainer.amount),0.0))::TFloat as Amount  --���. ������� - �������� ����� ���� ���������
                                        FROM Container
                                            LEFT OUTER JOIN MovementItemContainer ON Container.Id = MovementItemContainer.ContainerId
                                                                                 AND 
                                                                                 (
                                                                                    date_trunc('day', MovementItemContainer.Operdate) > vbOperDate
                                                                                 )
                                            JOIN ContainerLinkObject AS CLI_Unit 
                                                                     ON CLI_Unit.containerid = Container.Id
                                                                    AND CLI_Unit.descid = zc_ContainerLinkObject_Unit()
                                                                    AND CLI_Unit.ObjectId = vbUnitId                                   
                                        WHERE 
                                            Container.DescID = zc_Container_Count()
                                        GROUP BY 
                                            Container.Id 
                                           ,Container.ObjectId
                                    ) as T0
                                GROUP By ObjectId
                                HAVING SUM(T0.Amount) <> 0
                            )
    
    SELECT Object_Goods.ValueData, COALESCE(MovementItem_Loss.Amount,0), COALESCE(REMAINS.Amount,0) INTO vbGoodsName, vbAmount, vbSaldo 
    FROM
        Movement AS Movement_Loss
        INNER JOIN MovementLinkObject AS MLO_UNIT
                                      ON MLO_Unit.MovementId = Movement_Loss.Id
                                     AND MLO_Unit.DescId = zc_MovementLinkObject_Unit() 
        INNER JOIN MovementItem AS MovementItem_Loss
                                ON MovementItem_Loss.MovementId = Movement_Loss.Id
                               AND MovementItem_Loss.DescId = zc_MI_Master()
                               AND MovementItem_Loss.isErased = FALSE
        INNER JOIN Object AS Object_Goods
                          ON Object_Goods.Id = MovementItem_Loss.ObjectId  
        LEFT OUTER JOIN REMAINS ON MovementItem_Loss.ObjectId = REMAINS.ObjectId
    WHERE
        Movement_Loss.Id = inMovementId
        AND
        COALESCE(MovementItem_Loss.Amount,0) > COALESCE(REMAINS.Amount,0)
    LIMIT 1;
    
  IF (COALESCE(vbGoodsName,'') <> '') 
  THEN
    RAISE EXCEPTION '������. �� ������ <%> ��� ����� ������� ���-�� �������� <%> ������, ��� ���� �� ������� <%>.', vbGoodsName, vbAmount, vbSaldo;
  END IF;
  -- ����������� �������� �����
  PERFORM lpInsertUpdate_MovementFloat_TotalSummLoss (inMovementId);
  -- ���������� ��������
  PERFORM lpComplete_Movement_Loss(inMovementId, -- ���� ���������
                                        vbUserId);    -- ������������                          
  UPDATE Movement SET StatusId = zc_Enum_Status_Complete() 
  WHERE Id = inMovementId AND StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
 21.07.15                                                         *
 */

-- ����
-- SELECT * FROM gpComplete_Movement_Loss (inMovementId:= 29207, inSession:= '2')
