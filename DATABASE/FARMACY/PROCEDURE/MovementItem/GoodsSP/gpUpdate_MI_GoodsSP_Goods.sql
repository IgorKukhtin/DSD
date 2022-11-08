-- Function: gpUpdate_MI_GoodsSP_Goods()

DROP FUNCTION IF EXISTS gpUpdate_MI_GoodsSP_Goods (Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_GoodsSP_Goods(
    IN inId                  Integer   ,    -- ���� ������� <������� ���������>
    IN inMovementId          Integer   ,    -- ������������� ���������
    IN inGoodsId             Integer   ,    -- ������� �����
    IN inIdSP                TVarChar  ,    -- ID ����. ������ (AQ)
    IN inSession             TVarChar       -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbOperDateStart TDateTime;
   DECLARE vbOperDateEnd TDateTime;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := inSession;
    
    IF COALESCE (inId, 0) = 0 OR COALESCE (inMovementId, 0) = 0
    THEN
        RAISE EXCEPTION '�������� �� �������.';    
    END IF;
    
    -- ��������� ������� �� ���������
    IF EXISTS (SELECT 1 FROM MovementItem WHERE Id = inId AND COALESCE (ObjectId, 0) = inGoodsId)
    THEN
        RAISE EXCEPTION '����� ��� �����������.';
    END IF;    

    IF NOT EXISTS(SELECT * FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
                  WHERE Object_RoleUser.ID = vbUserId AND Object_RoleUser.RoleId in (59582, 393039, 1915124))
       AND vbUserId <> 3
    THEN
        RAISE EXCEPTION '������. � ��� ��� ���� ��������� ��� ��������.';     
    END IF;    

    SELECT MovementDate_OperDateStart.ValueData
         , MovementDate_OperDateEnd.ValueData
    INTO vbOperDateStart, vbOperDateEnd
    FROM Movement
         INNER JOIN MovementDate AS MovementDate_OperDateStart
                                 ON MovementDate_OperDateStart.MovementId = Movement.Id
                                AND MovementDate_OperDateStart.DescId     = zc_MovementDate_OperDateStart()

         INNER JOIN MovementDate AS MovementDate_OperDateEnd
                                 ON MovementDate_OperDateEnd.MovementId = Movement.Id
                                AND MovementDate_OperDateEnd.DescId     = zc_MovementDate_OperDateEnd()

    WHERE Movement.DescId = zc_Movement_GoodsSP()
      AND Movement.Id = inMovementId;

    PERFORM gpUpdate_Goods_IdSP(inGoodsMainId := inGoodsId , inIdSP := inIdSP,  inSession := inSession); 
        
    UPDATE MovementItem SET ObjectId = inGoodsId
    WHERE MovementItem.ID IN
       (SELECT MovementItem.ID
        FROM Movement
             INNER JOIN MovementDate AS MovementDate_OperDateStart
                                     ON MovementDate_OperDateStart.MovementId = Movement.Id
                                    AND MovementDate_OperDateStart.DescId     = zc_MovementDate_OperDateStart()
                                    AND MovementDate_OperDateStart.ValueData  >= vbOperDateStart

             INNER JOIN MovementDate AS MovementDate_OperDateEnd
                                     ON MovementDate_OperDateEnd.MovementId = Movement.Id
                                    AND MovementDate_OperDateEnd.DescId     = zc_MovementDate_OperDateEnd()
                                    AND MovementDate_OperDateEnd.ValueData  <= vbOperDateEnd

             INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                    AND MovementItem.DescId     = zc_MI_Master()
                                    AND MovementItem.isErased   = FALSE
                                    AND COALESCE (MovementItem.ObjectId, 0) <> inGoodsId

             -- ID ���������� ������
             INNER JOIN MovementItemString AS MIString_IdSP
                                           ON MIString_IdSP.MovementItemId = MovementItem.Id
                                          AND MIString_IdSP.DescId = zc_MIString_IdSP()
                                          AND MIString_IdSP.ValueData = inIdSP

        WHERE Movement.DescId = zc_Movement_GoodsSP()
          AND Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
          AND Movement.Id <> inMovementId);

    -- ��������� <������� ���������>
    PERFORM lpInsertUpdate_MovementItem (inId, zc_MI_Master(), inGoodsId, inMovementId, 0, NULL, zc_Enum_Process_Auto_PartionClose());

    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, False);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 15.07.22                                                       *
*/
-- select * from gpUpdate_MI_GoodsSP_Goods(inId := 523696543 , inMovementId := 28341113 , inGoodsID := 12006218 , inSession := '3');