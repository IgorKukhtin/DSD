-- Function: gpInsertUpdate_MovementItem_MobileSend()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_MobileSend (Integer, Integer, TFloat, TVarChar, TVarChar, TVarChar, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_MobileSend(
 INOUT ioId                                 Integer   , -- ���� ������� <������� ���������>
    IN inGoodsId                            Integer   , -- ������
    IN inAmount                             TFloat    , -- ����������
    IN inPartNumber                         TVarChar  , --
    IN inPartionCellName                    TVarChar  , -- ��� ��� ��������
    IN inFromId                             Integer   , -- �� ����
    IN inToId                               Integer   , -- ����
    IN inSession                            TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbIsInsert   Boolean;
   DECLARE vbPartionCellId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbStatusId   Integer;
   DECLARE vbInvNumber  TVarChar;
   DECLARE vbFromId     Integer;
   DECLARE vbToId       Integer;
   DECLARE vbOperDate   TDateTime;
   DECLARE vbGoodsId    Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Inventory());
     vbUserId:= lpGetUserBySession (inSession);
     
     -- �������� �������������
     IF COALESCE (inFromId, 0) = 0 OR COALESCE (inToId, 0) = 0
     THEN
       RAISE EXCEPTION '������. �� ��������� �������������.';
     END IF;
     
     
     -- ���� ����� �������� ���������
     IF COALESCE(ioId, 0) <> 0
     THEN
       -- ������ �� ���������
       SELECT Movement.Id,  Movement.StatusId,  Movement.OperDate, MovementItem.ObjectId, MLO_From.ObjectId, MLO_To.ObjectId
       INTO vbMovementId, vbStatusId, vbOperDate, vbGoodsId, vbFromId, vbToId
       FROM MovementItem 
            INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
            LEFT JOIN MovementLinkObject AS MLO_From
                                         ON MLO_From.MovementId = Movement.Id
                                        AND MLO_From.DescId     = zc_MovementLinkObject_From()
            LEFT JOIN MovementLinkObject AS MLO_To
                                         ON MLO_To.MovementId = Movement.Id
                                        AND MLO_To.DescId     = zc_MovementLinkObject_To()
       WHERE MovementItem.ID = ioId;
       
       IF COALESCE (vbMovementId, 0) = 0
       THEN
         RAISE EXCEPTION '������. �� ������ �������� ����������� �� ������.';
       END IF;

       IF COALESCE(vbStatusId, zc_Enum_Status_Erased()) <> zc_Enum_Status_UnComplete()
       THEN
         RAISE EXCEPTION '������.��������� ��������� � <%> � ������� <%> �� ��������.', vbInvNumber, lfGet_Object_ValueData (vbStatusId);
       END IF; 
       
       -- ���� ���������� ������������� �� ���������� ����� ��������� �����������
       IF COALESCE (vbFromId, 0) <> inFromId OR COALESCE (vbToId, 0) <> inToId
       THEN
         vbMovementId := 0;
       END IF;
     
     END IF;
     
     -- ���� �������� ����������� 
     IF COALESCE(vbMovementId, 0) = 0
     THEN
       SELECT Movement.Id
            , Movement.InvNumber
       INTO vbMovementId, vbInvNumber
       FROM Movement
            INNER JOIN MovementLinkObject AS MLO_From
                                          ON MLO_From.MovementId = Movement.Id
                                         AND MLO_From.DescId     = zc_MovementLinkObject_From()
                                         AND MLO_From.ObjectId   = inFromId
            INNER JOIN MovementLinkObject AS MLO_To
                                          ON MLO_To.MovementId = Movement.Id
                                         AND MLO_To.DescId     = zc_MovementLinkObject_To()
                                         AND MLO_To.ObjectId   = inToId
       WHERE Movement.DescId   = zc_Movement_Send()
         AND Movement.StatusId = zc_Enum_Status_UnComplete()
         AND Movement.OperDate = CURRENT_DATE;
     END IF;
     
     -- ������� �������� �����������
     IF COALESCE(vbMovementId, 0) = 0
     THEN
        vbMovementId := lpInsertUpdate_Movement_Send(0
                                                   , CAST (NEXTVAL ('movement_Send_seq') AS TVarChar)
                                                   , CURRENT_DATE
                                                   , inFromId
                                                   , inToId
                                                   , ''
                                                   , ''
                                                   , vbUserId);  
     END IF;
     
     -- ������ �� ���������
     SELECT Movement.OperDate, Movement.InvNumber
     INTO vbOperDate, vbInvNumber
     FROM Movement 
     WHERE Movement.ID = vbMovementId;
     
     -- ���� ����� ��� ���� ����� ����� ��������
     IF EXISTS(SELECT MI.Id 
               FROM MovementItem AS MI
                    LEFT JOIN MovementItemString AS MIString_PartNumber
                                                 ON MIString_PartNumber.MovementItemId = MI.Id
                                                AND MIString_PartNumber.DescId = zc_MIString_PartNumber()
               WHERE MI.MovementId = vbMovementId
                 AND MI.DescId     = zc_MI_Master()
                 AND MI.ObjectId   = inGoodsId
                 AND MI.isErased   = FALSE
                 AND COALESCE (MIString_PartNumber.ValueData,'') = COALESCE (inPartNumber,''))
     THEN
       RAISE EXCEPTION '������. ������������� <%> � S/N <%> ��� ��������� � �����������.', lfGet_Object_ValueData (inGoodsId), inPartNumber;
     END IF;
          
     -- ���� �������� S/N �� ����� ������ 1 �� � ���.
     IF COALESCE (inPartNumber, '') <> ''
     THEN

       IF COALESCE (inAmount, 0) <> 1
       THEN
         RAISE EXCEPTION '������. ���������� �������������� <%> � S/N <%> ������ ���� 1.', lfGet_Object_ValueData (inGoodsId), inPartNumber;
       END IF;

       IF EXISTS(SELECT MI.Id 
                 FROM MovementItem AS MI
                      INNER JOIN MovementItemString AS MIString_PartNumber
                                                    ON MIString_PartNumber.MovementItemId = MI.Id
                                                   AND MIString_PartNumber.DescId = zc_MIString_PartNumber()
                 WHERE MI.MovementId = vbMovementId
                   AND MI.DescId     = zc_MI_Detail()
                   AND MI.ObjectId   = inGoodsId
                   AND MI.isErased   = FALSE
                   AND MI.Id <> COALESCE (ioId, 0) 
                   AND COALESCE (MIString_PartNumber.ValueData,'') = COALESCE (inPartNumber,''))
       THEN
         RAISE EXCEPTION '������. ������������� <%> � S/N <%> ��� ��������� � ��������������.', lfGet_Object_ValueData (inGoodsId), inPartNumber;
       END IF;
     END IF;

     --������� ������ ��������, ���� ��� ����� �������
     IF COALESCE (inPartionCellName, '') <> '' THEN
         -- !!!����� �� !!!
         --���� ����� ��� ���� �� ����, ����� �� ��������
         IF zfConvert_StringToNumber (inPartionCellName) <> 0
         THEN
             vbPartionCellId:= (SELECT Object.Id
                                FROM Object
                                WHERE Object.ObjectCode = zfConvert_StringToNumber (inPartionCellName)
                                  AND Object.DescId     = zc_Object_PartionCell()
                               );
             --���� �� ����� ������
             IF COALESCE (vbPartionCellId,0) = 0
             THEN
                 RAISE EXCEPTION '������.�� ������� ������ � ����� <%>.', inPartionCellName;
             END IF;
         ELSE
             vbPartionCellId:= (SELECT Object.Id
                                FROM Object
                                WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inPartionCellName))
                                  AND Object.DescId     = zc_Object_PartionCell()
                               );
             --���� �� ����� �������
             IF COALESCE (vbPartionCellId,0) = 0
             THEN
                 --
                 vbPartionCellId := gpInsertUpdate_Object_PartionCell (ioId	     := 0                                            ::Integer
                                                                     , inCode    := lfGet_ObjectCode(0, zc_Object_PartionCell()) ::Integer
                                                                     , inName    := TRIM (inPartionCellName)                          ::TVarChar
                                                                     , inLevel   := 0           ::TFloat
                                                                     , inComment := ''          ::TVarChar
                                                                     , inSession := inSession   ::TVarChar
                                                                      );

             END IF;
         END IF;
         --
     END IF;
     
     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Detail(), inGoodsId, NULL, vbMovementId, inAmount, NULL, vbUserId);

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_PartNumber(), ioId, inPartNumber);

     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell(), ioId, vbPartionCellId);      

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 13.04.24                                                       *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_MobileSend(ioId := 566447, inGoodsId := 261920, inAmount := 1, inPartNumber := '', inPartionCellName := '', inFromId := 35139, inToId := 33347, inSession := zfCalc_UserAdmin())