-- Function: gpInsertUpdate_MovementItem_OrderInternal()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_OrderInternalMCS(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_OrderInternalMCS(
    IN inUnitId              Integer   , -- �������������
    IN inNeedCreate          Boolean   , -- ����� �� ���������
   OUT outOrderExists        Boolean   , -- ������ ����������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbOperDate TDateTime;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_OrderInternal());
    IF inNeedCreate = True  --���� � ���������� ��������� ����� �� �������������
    THEN -- �� ������������ ������ �� ������� ����� �������� � ���
        vbUserId := inSession;
        vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);
        vbOperDate := CURRENT_DATE;
        --���� ������ �� �������, ����������, �������� ���������
        SELECT Movement.Id INTO vbMovementId
        FROM Movement
            JOIN MovementLinkObject AS MovementLinkObject_Unit
                                    ON MovementLinkObject_Unit.MovementId = Movement.Id
                                   AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
            JOIN MovementBoolean AS MovementBoolean_isAuto
                                 ON MovementBoolean_isAuto.MovementId = Movement.Id 
                                AND MovementBoolean_isAuto.DescId = zc_MovementBoolean_isAuto()
                                    
        WHERE 
            Movement.StatusId = zc_Enum_Status_UnComplete() 
            AND 
            Movement.DescId = zc_Movement_OrderInternal() 
            AND 
            Movement.OperDate = vbOperDate 
            AND 
            MovementLinkObject_Unit.ObjectId = inUnitId
            AND
            MovementBoolean_isAuto.ValueData = True
        ORDER BY
            Movement.Id
        LIMIT 1;

        IF COALESCE(vbMovementId, 0) = 0 THEN --���� ����� ��� - �������
            vbMovementId := gpInsertUpdate_Movement_OrderInternal(0, '', vbOperDate, inUnitId, 0, inSession);
            PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isAuto(), vbMovementId, True);
        END IF;
        --������� ���������� ������
        PERFORM lpDelete_MovementItem(Id, inSession)
        FROM MovementItem
        WHERE MovementItem.MovementId = vbMovementId;
        --�������� �������� ������� ����� �������� � ���
        PERFORM 
          lpInsertUpdate_MovementItem_OrderInternal(0, vbMovementId, Object_Price.GoodsId, floor(Object_Price.MCSValue - SUM(COALESCE(Container.Amount,0)))::TFloat, Object_Price.Price, vbUserId)
        from Object_Price_View AS Object_Price
            LEFT OUTER JOIN ContainerLinkObject AS ContainerLinkObject_Unit
                                                ON ContainerLinkObject_Unit.DescId = zc_ContainerLinkObject_Unit()
                                               AND ContainerLinkObject_Unit.ObjectId = Object_Price.UnitId
            LEFT OUTER JOIN Container ON ContainerLinkObject_Unit.ContainerId = Container.Id
                                     AND Container.ObjectId = Object_Price.GoodsId
                                     AND Container.DescId = zc_Container_Count() 
                                     AND Container.Amount > 0
        WHERE
            Object_Price.MCSValue > 0
            AND
            Object_Price.UnitId = inUnitId
        GROUP BY
            Object_Price.UnitId,
            Object_Price.GoodsId,
            Object_Price.MCSValue,
            Object_Price.Price
        HAVING
            floor(Object_Price.MCSValue - SUM(COALESCE(Container.Amount,0)))::TFloat > 0;
        --���������� ������� ����������� � ����������
        PERFORM lpInsertUpdate_MovementItemBoolean(zc_MIBoolean_Calculated(),Id,True)
        FROM MovementItem
        WHERE MovementId = vbMovementId;
        
    END IF;
    IF EXISTS(  SELECT Movement.Id
                FROM Movement
                    JOIN MovementLinkObject AS MovementLinkObject_Unit
                                            ON MovementLinkObject_Unit.MovementId = Movement.Id
                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                    JOIN MovementBoolean AS MovementBoolean_isAuto
                                         ON MovementBoolean_isAuto.MovementId = Movement.Id 
                                        AND MovementBoolean_isAuto.DescId = zc_MovementBoolean_isAuto()
                                            
                WHERE 
                    Movement.StatusId = zc_Enum_Status_UnComplete() 
                    AND 
                    Movement.DescId = zc_Movement_OrderInternal() 
                    AND 
                    Movement.OperDate = vbOperDate 
                    AND 
                    MovementLinkObject_Unit.ObjectId = inUnitId
                    AND
                    MovementBoolean_isAuto.ValueData = True
             )
    THEN
        outOrderExists := True;
    ELSE
        outOrderExists := False;
    END IF;        
      
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ��������� �.�.
 31.07.15                                                                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_OrderInternalMCS (inUnitId := 183292, inNeedCreate:= True, inSession:= '3')
