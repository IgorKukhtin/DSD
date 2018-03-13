-- Function: gpInsertUpdate_Movement_GoodsAccount_Sybase()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_GoodsAccount_Sybase (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_GoodsAccount_Sybase(
 INOUT ioId                   Integer   , -- ���� ������� <��������>
 INOUT ioInvNumber            TVarChar  , -- ����� ���������
    IN inOperDate             TDateTime , -- ���� ���������
    IN inFromId               Integer   , -- �� ���� (� ���������)
    IN inToId                 Integer   , -- ���� (� ���������)
    IN inComment              TVarChar  , -- ����������
    IN inUserId_insert        Integer   , -- 
    IN inOperDate_insert      TDateTime , -- 
    IN inSession              TVarChar    -- ������ ������������
)                              
RETURNS RECORD
AS
$BODY$
   DECLARE vbId_find Integer;
BEGIN
   
     -- !!!�������� ��� Sybase - �����!!!
     IF COALESCE (ioId, 0) = 0
     THEN
         vbId_find:= (SELECT Movement.Id
                      FROM Movement
                           INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                        AND MovementLinkObject_From.ObjectId = inFromId
                           INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                        AND MovementLinkObject_To.ObjectId = inToId
                           INNER JOIN MovementDate AS MovementDate_Insert
                                                   ON MovementDate_Insert.MovementId = Movement.Id
                                                  AND MovementDate_Insert.DescId     = zc_MovementDate_Insert()
                                                  AND MovementDate_Insert.ValueData BETWEEN inOperDate_insert - INTERVAL '3 MIN' AND inOperDate_insert
                      WHERE Movement.OperDate = inOperDate
                        AND Movement.DescId   = zc_Movement_GoodsAccount()
                        AND Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
                     );
         -- !!!���������!!!            
         IF vbId_find > 0 THEN ioId:= vbId_find; END IF;
     ELSE
         vbId_find:= ioId;
     END IF;


     
     -- ��������� <��������>
     ioId := (SELECT tmp.ioId
              FROM gpInsertUpdate_Movement_GoodsAccount (ioId                := ioId
                                                       , ioInvNumber         := ioInvNumber
                                                       , inOperDate          := inOperDate
                                                       , inFromId            := inFromId
                                                       , inToId              := inToId
                                                       , inComment           := inComment
                                                       , inSession           := inSession
                                                        ) AS tmp);
     -- ��������
     IF COALESCE (vbId_find, 0) = 0
     THEN
         -- ��������� �������� <���� ��������>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, inOperDate_insert);
         -- ��������� �������� <������������ (��������)>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, inUserId_insert);
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 09.01.18                                        *
 */

-- ����
-- select * from gpInsertUpdate_Movement_GoodsAccount_Sybase(ioId := 7 , ioInvNumber := '4' , inOperDate := ('01.01.2017')::TDateTime , inFromId := 230 , inComment := 'df' ,  inSession := '2');
