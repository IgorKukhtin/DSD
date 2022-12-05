-- Function: gpInsertUpdate_MI_LossPersonal_Load ()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_LossPersonal_Load (Integer, TVarChar, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_LossPersonal_Load(
    IN inMovementId             Integer   , -- ���� ���������
    IN inINN                    TVarChar  , -- ��� ���������� 
    IN inAmount                 TFloat    , -- ����� �������������
    IN inSession                TVarChar    -- ������ ������������
)                              
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_LossPersonal());

    -- ��������� <������� ���������>
     PERFORM lpInsertUpdate_MovementItem_LossPersonal (ioId                    := 0
                                                     , inMovementId            := inMovementId                   ::Integer
                                                     , inPersonalId            := lfSelect.PersonalId            ::Integer
                                                     , inAmount                := inAmount                       ::TFloat
                                                     , inBranchId              := lfSelect.BranchId              ::Integer
                                                     , inInfoMoneyId           := zc_Enum_InfoMoney_60101()      ::Integer                       --60101 ���������� �����
                                                     , inPositionId            := lfSelect.PositionId            ::Integer
                                                     , inPersonalServiceListId := lfSelect.PersonalServiceListId ::Integer
                                                     , inUnitId                := lfSelect.UnitId
                                                     , inComment               := NULL ::TVarChar
                                                     , inUserId                := vbUserId
                                                      )
     FROM ObjectString AS ObjectString_INN
          INNER JOIN lfSelect_Object_Member_findPersonal (inSession) AS lfSelect ON lfSelect.MemberId = ObjectString_INN.ObjectId
     WHERE ObjectString_INN.DescId = zc_ObjectString_Member_INN() 
       AND TRIM (ObjectString_INN.ValueData) = TRIM (inINN)
     LIMIT 1;            --�� ������ ������


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 05.12.22         *
*/

-- ����
-- 