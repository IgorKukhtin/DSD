-- Function: lpInsertUpdate_Movement_Send()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Send (Integer, TVarChar, TDateTime, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Send (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Send (Integer, TVarChar, TDateTime, Integer, Integer, Integer, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Send (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Send(
 INOUT ioId                  Integer   , -- ���� ������� <�������� �����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ���� (� ���������)
    IN inDocumentKindId      Integer   , -- ��� ��������� (� ���������)
    IN inSubjectDocId        Integer   , -- ��������� ��� �����������
    IN inComment             TVarChar  , -- ����������
    IN inUserId              Integer     -- ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbOperDate_old TDateTime;
BEGIN
     -- ��������
     IF inOperDate <> DATE_TRUNC ('DAY', inOperDate)
     THEN
         RAISE EXCEPTION '������.�������� ������ ����.';
     END IF;

     -- ���������� ���� �������
     vbAccessKeyId:= lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_Send());

     -- �������� RK + ����� ��������
     IF inFromId IN (zc_Unit_RK(), 9558031) AND COALESCE (inSubjectDocId, 0) = 0
     AND inToId IN (8458, 8451 )
     THEN
         RAISE EXCEPTION '������.%��� ���� ����������� �������� <�����������>.%�� ��������� <��������� ��� �����������>.', CHR (13), CHR (13);
     END IF;

     -- ����������
     vbOperDate_old:= (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = ioId);

     -- ����������� ������ ��� ��
     IF ioId > 0 AND inToId = zc_Unit_RK()
    AND inOperDate <> vbOperDate_old
    AND EXISTS (SELECT 1
                FROM MovementItem
                     INNER JOIN MovementItemLinkObject AS MILinkObject_PartionCell
                                                       ON MILinkObject_PartionCell.MovementItemId = MovementItem.Id
                                                      AND MILinkObject_PartionCell.DescId IN (zc_MILinkObject_PartionCell_1()
                                                                                            , zc_MILinkObject_PartionCell_2()
                                                                                            , zc_MILinkObject_PartionCell_3()
                                                                                            , zc_MILinkObject_PartionCell_4()
                                                                                            , zc_MILinkObject_PartionCell_5()
                                                                                            , zc_MILinkObject_PartionCell_6()
                                                                                            , zc_MILinkObject_PartionCell_7()
                                                                                            , zc_MILinkObject_PartionCell_8()
                                                                                            , zc_MILinkObject_PartionCell_9()
                                                                                            , zc_MILinkObject_PartionCell_10()
                                                                                            , zc_MILinkObject_PartionCell_11()
                                                                                            , zc_MILinkObject_PartionCell_12()
                                                                                            , zc_MILinkObject_PartionCell_13()
                                                                                            , zc_MILinkObject_PartionCell_14()
                                                                                            , zc_MILinkObject_PartionCell_15()
                                                                                            , zc_MILinkObject_PartionCell_16()
                                                                                            , zc_MILinkObject_PartionCell_17()
                                                                                            , zc_MILinkObject_PartionCell_18()
                                                                                            , zc_MILinkObject_PartionCell_19()
                                                                                            , zc_MILinkObject_PartionCell_20()
                                                                                            , zc_MILinkObject_PartionCell_21()
                                                                                            , zc_MILinkObject_PartionCell_22()
                                                                                             )

                WHERE MovementItem.MovementId = ioId
                  AND MovementItem.DescId     = zc_MI_Master()
                  AND MovementItem.isErased   = FALSE
               )
    THEN
        PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods(), MovementItem.Id, vbOperDate_old)
        FROM MovementItem
             LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                        ON MIDate_PartionGoods.MovementItemId = MovementItem.Id
                                       AND MIDate_PartionGoods.DescId         = zc_MIDate_PartionGoods()
        WHERE MovementItem.MovementId = ioId
          AND MovementItem.DescId     = zc_MI_Master()
          AND MovementItem.isErased = FALSE
          AND MIDate_PartionGoods.ValueData IS NULL
         ;

    END IF;



     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Send(), inInvNumber, inOperDate, NULL, vbAccessKeyId, inUserId);

     -- ��������� ����� � <�� ���� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId);
     -- ��������� ����� � <���� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inToId);

     -- ��������� ����� � <��� ��������� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_DocumentKind(), ioId, inDocumentKindId);

     -- ��������� ����� � <��������� ��� �����������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_SubjectDoc(), ioId, inSubjectDocId);

     -- �����������
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);


     IF vbIsInsert = TRUE
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
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 06.02.20         * add inSubjectDocId
 27.02.19         *
 03.10.17         *
 17.06.16         *
 29.05.15                                        *
 12.07.13         *
*/

-- ����
-- SELECT min (OperDate), max (OperDate) FROM Movement where Desc = zc_Movement_Send() and AccessKeyId is null
-- SELECT * FROM lpInsertUpdate_Movement_Send (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inFromId:= 1, inToId:= 2, inDocumentKindId:= 0, inComment:= '', inSession:= '2')
