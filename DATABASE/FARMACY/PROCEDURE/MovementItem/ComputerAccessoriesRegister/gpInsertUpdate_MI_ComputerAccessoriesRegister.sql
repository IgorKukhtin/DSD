-- Function: gpInsertUpdate_MI_ComputerAccessoriesRegister()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ComputerAccessoriesRegister (Integer, Integer, Integer, TFloat, TDateTime, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_ComputerAccessoriesRegister(
 INOUT ioId                    Integer   , -- ���� ������� <������� ���������>
    IN inMovementId            Integer   , -- ���� ������� <��������>
    IN inComputerAccessoriesId Integer   , -- ������������ ���������
    IN inAmount                TFloat    , -- ����������
    IN inReplacementDate       TDateTime , -- ���� ������ 
    IN inComment               TVarChar  , -- �����������
    IN inSession               TVarChar    -- ������ ������������
)
AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbUnitId     Integer;
   DECLARE vbInvNumber  TVarChar;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
   vbUserId := inSession;

   IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
   THEN
     RAISE EXCEPTION '��������� ������ ���������� ��������������';
   END IF;

    --���������� ������ ���������
    SELECT MovementLinkObject_Unit.ObjectId                             AS UnitId, Movement.InvNumber
    INTO vbUnitId, vbInvNumber 
    FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                       ON MovementLinkObject_Unit.MovementId = Movement.Id
                                      AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
    WHERE Movement.Id = inMovementId;

/*    IF COALESCE (inAmount, 0) <> 1
    THEN
        RAISE EXCEPTION '������.���������� ������ ���� 1.';    
    END IF;
*/
     -- ���������
    ioId := lpInsertUpdate_MI_ComputerAccessoriesRegister (ioId                    := ioId
                                                      , inMovementId               := inMovementId
                                                      , inComputerAccessoriesId    := inComputerAccessoriesId
                                                      , inAmount                   := inAmount
                                                      , inReplacementDate          := inReplacementDate
                                                      , inComment                  := inComment
                                                      , inUserId                   := vbUserId
                                                       );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpInsertUpdate_MI_ComputerAccessoriesRegister (Integer, Integer, Integer, TFloat, TFloat, TVarChar) OWNER TO postgres;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ������ �.�.
 14.07.20                                                                      *
*/

-- ����
-- select * from gpInsertUpdate_MI_ComputerAccessoriesRegister(ioId := 0 , inMovementId := 19386934 , inGoodsId := 427 , inAmount := 10 , inNewExpirationDate := ('22.07.2020')::TDateTime , inContainerId := 20253754 ,  inSession := '3');
