-- Function: gpInsertUpdate_MI_PersonalService_From_Excel()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_PersonalService_From_Excel (Integer,  TVarChar, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_PersonalService_From_Excel(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inINN                 TVarChar  , -- 
    IN inSum1                TFloat    , -- �����1
    IN inSum2                TFloat    , -- �����2
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Void AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_PersonalService());
     vbUserId := lpGetUserBySession (inSession);

     IF COALESCE(inMovementId,0) = 0
     THEN
         RAISE EXCEPTION '������. �������� �� �������';
     END IF;

     IF COALESCE(inINN, '') = '' THEN
        RETURN;
     END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 18.01.17         *
*/

-- ����
--select * from gpInsertUpdate_MI_PersonalService_From_Excel(inMovementId :=0 , inINN := '2565555555', inSum1 := 15 ::TFloat, inSum2 := 45 ::TFloat , inSession :='3':: TVarChar)