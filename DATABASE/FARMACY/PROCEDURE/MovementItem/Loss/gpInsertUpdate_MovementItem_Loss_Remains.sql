DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Loss_Remains  (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Loss_Remains(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbOperDate  TDateTime;
  DECLARE vbUnitId    Integer;
BEGIN

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
        
    PERFORM  gpInsertUpdate_MovementItem_Loss(  ioId  := COALESCE(MovementItem.Id,0), -- ���� ������� <������� ���������>
                                                inMovementId  := inMovementId, -- ���� ������� <��������>
                                                inGoodsId  := REMAINS.ObjectId, -- ������
                                                inAmount   := REMAINS.Amount, -- ����������
                                                inSession  := inSession)
    FROM ( --������� �� ���� ���������
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
        ) AS REMAINS
        LEFT OUTER JOIN MovementItem ON MovementItem.MovementId = inMovementId  
                                    AND REMAINS.ObjectId = MovementItem.ObjectId 
                                    AND MovementItem.DescId = zc_MI_Master();
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_MovementItem_Loss_Remains (Integer,  TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ��������� �.�.
10.09.2015                                                                       *
*/