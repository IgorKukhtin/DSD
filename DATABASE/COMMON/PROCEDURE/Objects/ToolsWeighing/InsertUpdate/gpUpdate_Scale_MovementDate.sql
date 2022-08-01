-- Function: gpUpdate_Scale_MovementDate()

DROP FUNCTION IF EXISTS gpUpdate_Scale_MovementDate (Integer, TVarChar, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Scale_MovementDate(
    IN inMovementId        Integer   , -- ���� ������� <������� ���������>
    IN inDescCode          TVarChar  , -- 
    IN inValueData         TDateTime  , -- 
    IN inSession           TVarChar    -- ������ ������������
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
     PERFORM lpInsertUpdate_MovementDate (MovementDateDesc.Id, inMovementId, inValueData)
     FROM (SELECT inDescCode AS DescCode WHERE TRIM (inDescCode) <> '') AS tmp
          LEFT JOIN MovementDateDesc ON MovementItemDateDesc.Code ILIKE tmp.DescCode;

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 01.08.22                                        *
*/

-- ����
-- SELECT * FROM gpUpdate_Scale_MovementDate (inMovementId:= 0, inDescCode:= 'zc_MovementDate_OperDatePartner', inValueData:= CURRENT_TIMESTAMP, inSession:= '5')
