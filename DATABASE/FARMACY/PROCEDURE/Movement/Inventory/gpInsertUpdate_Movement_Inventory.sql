-- Function: gpInsertUpdate_Movement_Inventory()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Inventory (Integer, TVarChar, TDateTime, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Inventory (Integer, TVarChar, TDateTime, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Inventory (Integer, TVarChar, TDateTime, Integer, Boolean, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Inventory(
 INOUT ioId                  Integer   , -- ���� ������� <�������� ������� ����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inUnitId              Integer   , -- �������������
    IN inFullInvent          Boolean   , -- ������ ��������������
    IN inComment             TVarChar  , -- ����������
    IN inSession             TVarChar    -- ������ ������������
)                               
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUserUnitId Integer;
   DECLARE vbOldUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbObjectId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := inSession; -- lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Inventory());
       -- ������������ <�������� ����>
     vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', vbUserId);
     
     IF COALESCE (ioId, 0) = 0 AND ABS(inOperDate::Date - CURRENT_DATE) > 3
     THEN
       inOperDate := CURRENT_DATE;
     END IF;
     
     IF EXISTS(SELECT * FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
               WHERE Object_RoleUser.ID = vbUserId AND Object_RoleUser.RoleId = 308121) -- ��� ���� "������ ������"
        AND vbUserId <> 8037524
     THEN
     
        vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
        IF vbUnitKey = '' THEN
          vbUnitKey := '0';
        END IF;
        vbUserUnitId := vbUnitKey::Integer;
        
        IF COALESCE (vbUserUnitId, 0) = 0
        THEN 
          RAISE EXCEPTION '������. �� ������� ������������� ����������.';     
        END IF;     
        
        IF COALESCE (ioId, 0) <> 0
        THEN

          SELECT 
            MLO_Unit.ObjectId 
          INTO
            vbOldUnitId
          FROM Movement
               INNER JOIN MovementLinkObject AS MLO_Unit
                                             ON MLO_Unit.MovementId = Movement.Id
                                            AND MLO_Unit.DescId = zc_MovementLinkObject_Unit()
          WHERE Movement.Id = ioId;

          IF COALESCE (vbOldUnitId, 0) <> COALESCE (inUnitId, 0)
          THEN
            RAISE EXCEPTION '������. ��������� ������������� ���������..';                       
          END IF;
        ELSEIF vbObjectId = 4 
        THEN 
          RAISE EXCEPTION '������. ��������� �������������� ��� ���������..';                       
        END IF;
        
        IF COALESCE (inUnitId, 0) = 0
        THEN 
          RAISE EXCEPTION '������. �� ��������� �������������..';             
        END IF;     

        IF COALESCE (inUnitId, 0) <> COALESCE (vbUserUnitId, 0) 
        THEN 
          RAISE EXCEPTION '������. ��� ��������� �������� ������ � �������������� <%>.', (SELECT ValueData FROM Object WHERE ID = vbUserUnitId);     
        END IF;     
        
     END IF;     

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement_Inventory (ioId               := ioId
                                              , inInvNumber        := inInvNumber
                                              , inOperDate         := inOperDate
                                              , inUnitId           := inUnitId
                                              , inFullInvent       := inFullInvent
                                              , inComment          := inComment
                                              , inUserId           := vbUserId
                                               );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
ALTER FUNCTION gpInsertUpdate_Movement_Inventory (Integer, TVarChar, TDateTime, Integer, Boolean, TVarChar, TVarChar) OWNER TO postgres;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ��������� �.�.   ������ �.�.
 19.12.19                                                                         * + Comment
 17.12.18                                                                         *
 16.09.15                                                          * + FullInvent
 11.07.15                                                          *
*/