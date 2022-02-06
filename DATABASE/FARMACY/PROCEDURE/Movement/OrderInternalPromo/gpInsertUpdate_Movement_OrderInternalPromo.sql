-- Function: gpInsertUpdate_Movement_OrderInternalPromo()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderInternalPromo (Integer, TVarChar, TDateTime, TDateTime, TFloat, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderInternalPromo (Integer, TVarChar, TDateTime, TDateTime, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderInternalPromo (Integer, TVarChar, TDateTime, TDateTime, TFloat, TFloat, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderInternalPromo (Integer, TVarChar, TDateTime, TDateTime, TFloat, TFloat, TFloat, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderInternalPromo (Integer, TVarChar, TDateTime, TDateTime, TFloat, TFloat, TFloat, Integer, TVarChar, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_OrderInternalPromo(
 INOUT ioId                    Integer    , -- ���� ������� <�������� �������>
    IN inInvNumber             TVarChar   , -- ����� ���������
    IN inOperDate              TDateTime  , -- ���� ���������
    IN inStartSale             TDateTime  , -- ���� ������ ������
    IN inTotalSummPrice        TFloat     , -- ����� ����� �� ����� ������
    IN inTotalSummSIP          TFloat     , -- ����� ����� �� ����� ���
    IN inTotalAmount           TFloat     , -- ���������� ��� �����.
    IN inRetailId              Integer    , -- �������� ����
    IN inComment               TVarChar   , -- ����������
    IN inDaysGrace             Integer    , -- ���� ��������
    IN inSession               TVarChar     -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAmount TFloat;
   DECLARE vbRetailId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderInternalPromo());
    vbUserId := inSession;
    
    -- ������� ����������� �������
      vbRetailId := (SELECT MovementLinkObject_Retail.ObjectId
                     FROM MovementLinkObject AS MovementLinkObject_Retail
                     WHERE MovementLinkObject_Retail.MovementId = ioId
                       AND MovementLinkObject_Retail.DescId = zc_MovementLinkObject_Retail());

     -- E��� �������� ��. ���� ��� ������ ����� �� ��������
     IF vbRetailId <> 0 AND vbRetailId <> inRetailId
     THEN
         RAISE EXCEPTION '������. ������ ���������. ��������� ���� ���������'; 
         --
         /* UPDATE MovementItem
            SET isErased = TRUE
            WHERE MovementItem.MovementId = ioId;
         */
     END IF;
     
     
    -- ������� ����� ���-��
    vbAmount := COALESCE ( (SELECT SUM(MovementItem.Amount) FROM MovementItem WHERE MovementItem.MovementId = ioId AND MovementItem.DescId = zc_MI_Master() AND MovementItem.isErased = FALSE) , 0) :: TFloat;
    
    -- ��������� <��������>
    ioId := lpInsertUpdate_Movement_OrderInternalPromo (ioId            := ioId
                                                      , inInvNumber     := inInvNumber
                                                      , inOperDate      := inOperDate
                                                      , inStartSale     := inStartSale
                                                      , inAmount        := vbAmount
                                                      , inRetailId      := inRetailId
                                                      , inTotalSummPrice:= inTotalSummPrice
                                                      , inTotalSummSIP  := inTotalSummSIP
                                                      , inTotalAmount   := inTotalAmount
                                                      , inComment       := inComment
                                                      , inDaysGrace     := inDaysGrace
                                                      , inUserId        := vbUserId
                                                      );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 15.04.19         *
*/