-- Function: gpSelect_Movement_InventoryLocalCheck()

DROP FUNCTION IF EXISTS gpSelect_Movement_InventoryLocalCheck (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_InventoryLocalCheck(
    IN inUnitId      Integer   , -- �������������
    IN inOperDate    TDateTime , -- ���� ��������������
    IN inSession     TVarChar    -- ������ ������������
)
RETURNS TABLE (OperDate TDateTime
             , GoodsId Integer
             , UserId Integer
             , MovementId Integer
             , Amount TFloat
             )
AS
$BODY$
   DECLARE vbUserId       Integer;
   DECLARE vbMovementId   Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Inventory());

    --���������� ������������� � ���� ���������
    
    vbMovementId := ( SELECT Movement.Id
                      FROM Movement
                           INNER JOIN MovementLinkObject AS MLO_Unit
                                                         ON MLO_Unit.MovementId = Movement.Id
                                                        AND MLO_Unit.DescId = zc_MovementLinkObject_Unit()
                                                        AND MLO_Unit.ObjectId = inUnitId
                           INNER JOIN MovementBoolean AS MovementBoolean_FullInvent
                                                      ON MovementBoolean_FullInvent.MovementId = Movement.Id
                                                     AND MovementBoolean_FullInvent.DescId = zc_MovementBoolean_FullInvent()
                                                     AND MovementBoolean_FullInvent.ValueData = True
                      WHERE Movement.OperDate >= inOperDate
                        AND Movement.OperDate <= inOperDate + INTERVAL '4 DAY'
                        AND Movement.DescId = zc_Movement_Inventory()
                        AND Movement.StatusId = zc_Enum_Status_UnComplete());
      
    IF COALESCE(vbMovementId, 0) = 0
    THEN
      RAISE EXCEPTION '������ �������������� �� ������������� <%> �� �������.%���������� ������� �������� ������ ��� � Farmacy', lfGet_Object_ValueData (inUnitId), Chr(13);
    END IF;

    RETURN QUERY   
    SELECT MICheck.OperDate
         , MICheck.GoodsId
         , MICheck.UserId
         , MICheck.MovementId
         , MICheck.Amount
    FROM gpSelect_Movement_InventoryCheck(inMovementId := vbMovementId, inSession := inSession) AS MICheck;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 12.06.23                                                       *
*/

-- ����

--

select * from gpSelect_Movement_InventoryLocalCheck(inUnitId := 377610 , inOperDate := ('15.06.2023')::TDateTime ,  inSession := '3');
    