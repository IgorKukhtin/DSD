-- Function: gpUpdate_Scale_MIFloat()

DROP FUNCTION IF EXISTS gpUpdate_Scale_MIFloat (Integer, TVarChar, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Scale_MIFloat(
    IN inMovementItemId        Integer   , -- ���� ������� <������� ���������>
    IN inDescCode              TVarChar  , -- 
    IN inValueData             TFloat    , -- 
    IN inSession               TVarChar    -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Scale_MI_Erased());
     vbUserId:= lpGetUserBySession (inSession);


     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (MovementItemFloatDesc.Id, inMovementItemId, inValueData)
     FROM (SELECT inDescCode AS DescCode WHERE TRIM (inDescCode) <> '') AS tmp
          LEFT JOIN MovementItemFloatDesc ON MovementItemFloatDesc.Code = tmp.DescCode;


     -- ��������� �������� <����/�����>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Update(), inMovementItemId, CURRENT_TIMESTAMP);

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (inMovementItemId, vbUserId, FALSE);


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 17.05.15                                        *
*/

-- ����
-- SELECT * FROM gpUpdate_Scale_MIFloat (inMovementItemId:= 0, inItemName:= 'zc_MIFloat_BoxNumber', inValueData:= 1, inSession:= '5')
