-- Function: gpInsertUpdate_MI_OrderReturnTare_byTransport()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_OrderReturnTare_byTransport (Integer, Integer, TVarChar, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_OrderReturnTare_byTransport(
 INOUT ioMovementId             Integer   , --
    IN inMovementId_Transport   Integer   , --
    IN inInvNumber              TVarChar  , -- ����� ���������
    IN inOperDate               TDateTime ,
    IN inSession                TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId_Transport Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderReturnTare());
     vbUserId:= lpGetUserBySession (inSession);

     --����������� �������
     vbMovementId_Transport := (SELECT MovementLinkMovement_Transport.MovementChildId
                                FROM MovementLinkMovement AS MovementLinkMovement_Transport
                                WHERE MovementLinkMovement_Transport.MovementId = ioMovementId
                                  AND MovementLinkMovement_Transport.DescId = zc_MovementLinkMovement_Transport()
                                );
     -- �������� ���� ������� �� ��������� ������ �� ������
     IF vbMovementId_Transport = inMovementId_Transport
     THEN 
         RETURN;
     END IF;

     --���� ���. �� �������� ���. - ��������� ��� ������������� � ���� ������
     ioMovementId := lpInsertUpdate_Movement_OrderReturnTare (ioId        := COALESCE (ioMovementId,0)
                                                            , inInvNumber := CASE WHEN COALESCE (inInvNumber, '') = '' 
                                                                                  THEN CAST (NEXTVAL ('movement_OrderReturnTare_seq') AS TVarChar)
                                                                                  ELSE inInvNumber
                                                                             END ::TVarChar
                                                            , inOperDate  := inOperDate
                                                            , inMovementId_Transport := inMovementId_Transport
                                                            , inComment   := ''::TVarChar
                                                            , inUserId    := vbUserId
                                                           ) AS tmp;

     --���� ��������� ������� ����������� ������ � ���������� �����
     UPDATE MovementItem SET isErased = TRUE
     WHERE MovementItem.isErased = FALSE
       AND MovementItem.MovementId = ioMovementId;
     
     --�������� ����� ������
     PERFORM lpInsertUpdate_MovementItem_OrderReturnTare (ioId           := 0
                                                        , inMovementId   := ioMovementId
                                                        , inGoodsId      := tmp.GoodsId
                                                        , inPartnerId    := tmp.PartnerId
                                                        , inAmount       := tmp.Amount
                                                        , inUserId       := vbUserId
                                                         )
     FROM (WITH
           --��������� ������ �� ������� �� ��������
           tmpReport AS (SELECT tmp.*
                         FROM lpReport_OrderReturnTare_SaleByTransport (inMovementId_Transport := inMovementId_Transport, inUserId := vbUserId) AS tmp
                         )
           SELECT tmpReport.GoodsId
                , tmpReport.PartnerId
                , SUM (tmpReport.Amount) ::TFloat AS Amount
           FROM tmpReport
           GROUP BY tmpReport.GoodsId
                  , tmpReport.PartnerId
           ) AS tmp;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.01.22         *
*/

-- ����
--