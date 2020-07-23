-- Function: gpGet_InventoryHouseholdInventoryID()

DROP FUNCTION IF EXISTS gpGet_InventoryHouseholdInventoryID (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_InventoryHouseholdInventoryID(
    IN inUnitID            Integer  , -- �������������
    IN inOperDate          TDateTime, -- ����
   OUT outMovementId       Integer  , -- ��������������
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS Integer
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbUnitKey TVarChar;
  DECLARE vbUnitId Integer;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_InventoryHouseholdInventory());
     vbUserId := inSession;

     IF EXISTS(SELECT Movement.Id
               FROM Movement
                    LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                 ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
               WHERE Movement.OperDate =  inOperDate
                 AND Movement.DescId = zc_Movement_InventoryHouseholdInventory()
                 AND Movement.StatusId <> zc_Enum_Status_Erased() 
                 AND MovementLinkObject_Unit.ObjectId = inUnitID)
     THEN
       SELECT Movement.Id
       INTO outMovementId
       FROM Movement
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
       WHERE Movement.OperDate =  inOperDate
         AND Movement.DescId = zc_Movement_InventoryHouseholdInventory()
         AND Movement.StatusId <> zc_Enum_Status_Erased() 
         AND  MovementLinkObject_Unit.ObjectId = inUnitID;
     ELSE
       -- �������� ���� ������������ �� ����� ���������
       vbUserId:= lpCheckRight (inSession, zc_Enum_Process_IU_Movement_InventoryHouseholdInventory());
       
       outMovementId := gpInsertUpdate_Movement_InventoryHouseholdInventory(ioId               := 0
                                                                          , inInvNumber        := CAST (NEXTVAL ('Movement_InventoryHouseholdInventory_seq') AS TVarChar)
                                                                          , inOperDate         := inOperDate
                                                                          , inUnitId           := inUnitId
                                                                          , inComment          := ''
                                                                          , inUserId           := vbUserId
                                                                          );
     END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 17.07.20                                                       *
 */

-- ����
-- select * from gpGet_InventoryHouseholdInventoryID(inUnitID := 183292 , inOperDate := ('10.07.2020')::TDateTime ,  inSession := '3');