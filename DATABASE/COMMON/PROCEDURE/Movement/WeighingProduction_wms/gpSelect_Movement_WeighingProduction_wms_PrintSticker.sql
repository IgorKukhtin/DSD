-- Function: gpSelect_Movement_WeighingProduction_wms_PrintSticker (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Movement_WeighingProduction_wms_PrintSticker (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_WeighingProduction_wms_PrintSticker (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_WeighingProduction_wms_PrintSticker(
    IN inMovementId        Integer   ,   -- ���� ���������
    IN inId                Integer   ,   -- ������
    IN inSession           TVarChar      -- ������ ������������
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE Cursor1 refcursor;
    DECLARE vbDescId Integer;
    DECLARE vbStatusId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_WeighingProduction());
     vbUserId:= lpGetUserBySession (inSession);

     -- ��������� �� ���������
     SELECT Movement.DescId, Movement.StatusId, Movement.OperDate
   INTO vbDescId, vbStatusId
     FROM Movement
     WHERE Movement.Id = inMovementId;

    -- ����� ������ ��������
    IF COALESCE (vbStatusId, 0) <> zc_Enum_Status_Complete()
    THEN
        IF vbStatusId = zc_Enum_Status_Erased()
        THEN
            RAISE EXCEPTION '������.�������� <%> � <%> �� <%> ������.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
        END IF;
        IF vbStatusId = zc_Enum_Status_UnComplete()
        THEN
            RAISE EXCEPTION '������.�������� <%> � <%> �� <%> �� ��������.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
        END IF;
    END IF;

     -- ���������
     OPEN Cursor1 FOR

       -- ��������� -- ��� 1-�� ������
       SELECT MovementItem.Id
            , MovementItem.WmsCode AS IdBarCode
       FROM MI_WeighingProduction AS MovementItem 
       WHERE MovementItem.MovementId = inMovementId
         AND MovementItem.Id         = inId
       ;

    RETURN NEXT Cursor1;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
08.07.19          *
*/

-- ����
-- SELECT * FROM gpSelect_Movement_WeighingProduction_wms_PrintSticker (inMovementId := 432692, inId:= 177, inSession:= '5');
