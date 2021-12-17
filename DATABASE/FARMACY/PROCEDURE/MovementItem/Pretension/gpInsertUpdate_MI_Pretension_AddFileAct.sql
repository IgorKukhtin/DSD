-- Function: gpInsertUpdate_MI_Pretension_AddFileAct()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Pretension_AddFileAct(Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_Pretension_AddFileAct(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inFileName            TVarChar  , -- ��� �����
   OUT outFileNameFTP        TVarChar  , -- ��� ����� ��� FTP
    IN inSession             TVarChar    -- ������ ������������
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     --vbUserId := inSession;
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Pretension());
     
     IF EXISTS(SELECT MI_PretensionFile.Id
               FROM Movement AS Movement_Pretension
                    INNER JOIN MovementItem AS MI_PretensionFile
                                            ON MI_PretensionFile.MovementId = Movement_Pretension.Id
                                           AND MI_PretensionFile.DescId     = zc_MI_Child()

                    INNER JOIN MovementItemBoolean AS MIBoolean_Checked
                                                  ON MIBoolean_Checked.MovementItemId = MI_PretensionFile.Id
                                                 AND MIBoolean_Checked.DescId = zc_MIBoolean_Checked()
                                                 AND MIBoolean_Checked.ValueData = TRUE

               WHERE Movement_Pretension.Id = inMovementId)
     THEN
       SELECT MI_PretensionFile.Id
       INTO vbId
       FROM Movement AS Movement_Pretension
            INNER JOIN MovementItem AS MI_PretensionFile
                                    ON MI_PretensionFile.MovementId = Movement_Pretension.Id
                                   AND MI_PretensionFile.DescId     = zc_MI_Child()

            INNER JOIN MovementItemBoolean AS MIBoolean_Checked
                                          ON MIBoolean_Checked.MovementItemId = MI_PretensionFile.Id
                                         AND MIBoolean_Checked.DescId = zc_MIBoolean_Checked()
                                         AND MIBoolean_Checked.ValueData = TRUE

       WHERE Movement_Pretension.Id = inMovementId;
     ELSE 
       vbId := 0;
     END IF;
                 
     IF EXISTS(SELECT MI_PretensionFile.Id
               FROM Movement AS Movement_Pretension
                    INNER JOIN MovementItem AS MI_PretensionFile
                                            ON MI_PretensionFile.MovementId = Movement_Pretension.Id
                                           AND MI_PretensionFile.DescId     = zc_MI_Child()
                                           AND MI_PretensionFile.Id <> COALESCE (vbId, 0)

                    INNER JOIN MovementItemString AS MIString_FileName
                                                  ON MIString_FileName.MovementItemId = MI_PretensionFile.Id
                                                 AND MIString_FileName.DescId = zc_MIString_FileName()
                                                 AND zfExtract_FileName(MIString_FileName.ValueData) = zfExtract_FileName(inFileName)

               WHERE Movement_Pretension.Id = inMovementId)
     THEN
        RAISE EXCEPTION '������. ���� � ����� <%> ��� ���� � ���������.', zfExtract_FileName(inFileName);         
     END IF;
     
     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (vbId, 0) = 0;

     -- ��������� <������� ���������>
     vbId := lpInsertUpdate_MovementItem (vbId, zc_MI_Child(), 0, inMovementId, 0, NULL);

     -- ��������� �������� <���������>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_FileName(), vbId, zfExtract_FileName(inFileName));
     -- ��������� �������� <���������>
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Checked(), vbId, TRUE);

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (vbId, vbUserId, vbIsInsert);     
     
     outFileNameFTP = vbId::TVarChar;
     
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 11.12.21                                                       *
*/

-- ����
-- select * from gpInsertUpdate_MI_Pretension_AddFileAct(inMovementId := 26008007 , inFileName := 'D:\2\IMG_20200901_105225.jpg' ,  inSession := '3');