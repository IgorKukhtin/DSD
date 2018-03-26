-- Function: lpInsertUpdate_Movement_GoodsAccount()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_GoodsAccount (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_GoodsAccount(
 INOUT ioId                   Integer   , -- ���� ������� <��������>
    IN inInvNumber            TVarChar  , -- ����� ���������
    IN inOperDate             TDateTime , -- ���� ���������
    IN inFromId               Integer   , -- �� ���� (� ���������)
    IN inToId                 Integer   , -- ���� (� ���������)
    IN inComment              TVarChar  , -- ����������
    IN inUserId               Integer     -- ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- ��������
     IF inOperDate <> DATE_TRUNC ('DAY', inOperDate)
     THEN
         RAISE EXCEPTION '������.�������� ������ ����.';
     END IF;

     -- ��������
     IF inUserId = zc_User_Sybase() THEN
         -- ���������� ����������
         IF COALESCE (inFromId, 0) = 0 
         THEN
             RAISE EXCEPTION '������. �� ����������� �������� <����������>.';
         END IF;
         -- ����������� �������������
         IF COALESCE (inToId, 0) = 0 
         THEN
             RAISE EXCEPTION '������. �� ����������� �������� <�������������>.';
         END IF;
     END IF;


     -- ��������
     IF inUserId <> zc_User_Sybase() AND ioId > 0
        AND (COALESCE (inFromId, 0) <> COALESCE ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = ioId AND MLO.DescId = zc_MovementLinkObject_From()), 0)
          OR COALESCE (inToId, 0)   <> COALESCE ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = ioId AND MLO.DescId = zc_MovementLinkObject_To()), 0)
            )
        AND EXISTS (SELECT 1 FROM MovementItem AS MI WHERE MI.MovementId = ioId AND MI.DescId = zc_MI_Master())
     THEN
         RAISE EXCEPTION '������.�������� �� ������.������������� �� ��������.���������� ������� ������� �������� � ������������ �����.';
     END IF;


     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId        := ioId
                                    , inDescId    := zc_Movement_GoodsAccount()
                                    , inInvNumber := inInvNumber
                                    , inOperDate  := inOperDate
                                    , inParentId  := NULL
                                    , inUserId    := inUserId
                                     );

     -- �����������
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

     -- ��������� ����� � <�� ���� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId);
     -- ��������� ����� � <���� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inToId);
    
     IF vbIsInsert = TRUE AND inUserId <> zc_User_Sybase()
     THEN
         -- ��������� �������� <���� ��������>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
         -- ��������� �������� <������������ (��������)>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, inUserId);
     END IF;
    
     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (ioId);

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
 14.07.17         * add inToId
 09.06.17                                                       *  add inUserId in lpInsertUpdate_Movement
 08.06.17                                                       *  lpInsertUpdate_Movement c �����������
 18.05.17         *
*/

-- ����
-- 