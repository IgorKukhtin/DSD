-- Function: gpInsertUpdate_MI_EDI()

-- DROP FUNCTION IF EXISTS gpInsert_Movement_EDIEvents(Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsert_Movement_EDIEvents (Integer, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_EDIEvents(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inDocumentId          TVarChar  , --
    IN inVchasnoId           TVarChar  , --
    IN inEDIEvent            TVarChar  , -- �������� �������
    IN inSession             TVarChar    -- ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCount  Integer;
   DECLARE vbCount_in Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_EDI());
   vbUserId := lpGetUserBySession(inSession);


    IF COALESCE (inMovementId, 0) = 0
    THEN
        RAISE EXCEPTION '������.inMovementId = 0.';
    END IF;


   IF TRIM (COALESCE (inDocumentId, '')) <> ''
   THEN
       PERFORM lpInsertUpdate_MovementString (zc_MovementString_DocumentId_vch(), inMovementId, inDocumentId);
   END IF;


   IF TRIM (COALESCE (inVchasnoId, '')) <> ''
   THEN
       PERFORM lpInsertUpdate_MovementString (zc_MovementString_VchasnoId(), inMovementId, inVchasnoId);
   END IF;


   IF SUBSTRING (inEDIEvent FROM 1 FOR 1) = '{'
   THEN
        --
        vbCount:= (SELECT COUNT(*)
                   FROM MovementItem
                   WHERE MovementItem.MovementId = inMovementId
                     AND MovementItem.DescId     = zc_MI_Master()
                     AND MovementItem.isErased   = FALSE);
        --
        vbCount_in:= zfConvert_StringToFloat (SUBSTRING (inEDIEvent FROM 2 FOR POSITION ('}' IN inEDIEvent) - 2)) :: Integer;
        --
        PERFORM lpInsert_Movement_EDIEvents (inMovementId
                                           , CASE WHEN vbCount <> vbCount_in
                                                       THEN '������.��������� {' || (vbCount :: TVarChar) || '} ����� �� {' || (vbCount_in :: TVarChar) || '}.'
                                                  ELSE ''
                                             END
                                          || SUBSTRING (inEDIEvent
                                                        FROM POSITION ('}' IN inEDIEvent) + 1
                                                        FOR  LENGTH (inEDIEvent) - POSITION ('}' IN inEDIEvent)
                                                       )
                                           , vbUserId);
   ELSE
        PERFORM lpInsert_Movement_EDIEvents (inMovementId, inEDIEvent, vbUserId);
   END IF;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 02.06.14                         *

*/

-- ����
-- SELECT * FROM gpInsert_Movement_EDIEvents (inMovementId:= 16086413, inEDIEvent:= '{8}�������� ORDER �� EDI ��������� _order_20200311114504000_Zpp00048733.xml_', inSession:= '2')
