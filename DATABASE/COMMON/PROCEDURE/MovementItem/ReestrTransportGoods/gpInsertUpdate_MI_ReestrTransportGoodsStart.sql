-- Function: gpInsertUpdate_MI_ReestrTransportGoodsStart()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ReestrTransportGoodsStart (Integer, TDateTime, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_ReestrTransportGoodsStart(
 INOUT ioMovementId               Integer   , -- ���� ������� <��������>
    IN inOperDate                 TDateTime , -- ���� ���������
    IN inBarCode                  TVarChar  , -- �/� ��������� <�������>
    IN inSession                  TVarChar    -- ������ ������������
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbIsFindOnly      Boolean;
   DECLARE vbIsInsert        Boolean;
   DECLARE vbId_mi           Integer;
   DECLARE vbMovementId_TTN Integer;
   DECLARE vbMovementDescId_TransportTop Integer;
   DECLARE vbMemberId        Integer; -- <���������� ����> - ��� ����������� ���� ""
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ReestrTransportGoods());
    -- vbUserId:= lpGetUserBySession (inSession);  
     
     -- ������������ ��� ��� ����� Find ioMovementId, � ���� �� �����, ����� ����� Insert
     vbIsFindOnly:= COALESCE (ioMovementId, 0) = 0 AND TRIM (inBarCode) = '';

     -- ���� �������� ������� ���� - ����� ����� Find !!!������!!! ioMovementId
     IF ioMovementId > 0 AND NOT EXISTS (SELECT 1 FROM MovementLinkObject AS ML� WHERE ML�.MovementId = ioMovementId AND ML�.DescId = zc_MovementLinkObject_Insert() )
     THEN
         ioMovementId:= 0;
         vbIsFindOnly:= TRUE;
     END IF;


     -- ������ �������� <������ ���������>
     IF COALESCE (ioMovementId, 0) = 0
     THEN
          ioMovementId:= COALESCE ((SELECT ML�.MovementId
                                    FROM MovementLinkObject AS ML�
                                         INNER JOIN Movement ON Movement.Id       = ML�.MovementId
                                                            AND Movement.DescId   = zc_Movement_ReestrTransportGoods()
                                                            AND Movement.StatusId = zc_Enum_Status_Erased()
                                                            AND Movement.OperDate = inOperDate
                                    WHERE ML�.ObjectId = vbUserId
                                      AND ML�.DescId = zc_MovementLinkObject_Insert()
                                   ), 0);
          -- �����, �� ���� �� ����� - ������� Insert
          IF ioMovementId = 0
          THEN
              vbIsFindOnly:= FALSE;
          END IF;
     END IF;

     -- ������ ���
     IF TRIM (inBarCode) <> ''
     THEN
         IF CHAR_LENGTH (inBarCode) >= 13
         THEN -- �� ����� ����, �� ��� "��������" ����������� - 33 DAY
              vbMovementId_TTN:= (SELECT Movement.Id
                                       FROM (SELECT zfConvert_StringToNumber (SUBSTR (inBarCode, 4, 13-4)) AS MovementId
                                             ) AS tmp
                                         INNER JOIN Movement ON Movement.Id = tmp.MovementId
                                                            AND Movement.DescId = zc_Movement_TransportGoods()
                                                            AND Movement.OperDate BETWEEN CURRENT_DATE - INTERVAL '33 DAY' AND CURRENT_DATE + INTERVAL '8 DAY'
                                                            AND Movement.StatusId <> zc_Enum_Status_Erased()
                                       );

              -- ���������� ����� - ��� 100 DAY
              IF COALESCE (vbMovementId_TTN, 0) = 0
              THEN
              vbMovementId_TTN:= (SELECT Movement.Id
                                       FROM (SELECT zfConvert_StringToNumber (SUBSTR (inBarCode, 4, 13-4)) AS MovementId
                                             ) AS tmp
                                         INNER JOIN Movement ON Movement.Id = tmp.MovementId
                                                            AND Movement.DescId = zc_Movement_TransportGoods()
                                                            AND Movement.OperDate BETWEEN CURRENT_DATE - INTERVAL '133 DAY' AND CURRENT_DATE - INTERVAL '33 DAY'
                                                            AND Movement.StatusId <> zc_Enum_Status_Erased()
                                       );
              END IF;
              
              -- ���������� ����� - ��� 100 DAY
              IF COALESCE (vbMovementId_TTN, 0) = 0
              THEN
              vbMovementId_TTN:= (SELECT Movement.Id
                                       FROM (SELECT zfConvert_StringToNumber (SUBSTR (inBarCode, 4, 13-4)) AS MovementId
                                             ) AS tmp
                                         INNER JOIN Movement ON Movement.Id = tmp.MovementId
                                                            AND Movement.DescId = zc_Movement_TransportGoods()
                                                            AND Movement.OperDate BETWEEN CURRENT_DATE - INTERVAL '233 DAY' AND CURRENT_DATE - INTERVAL '133 DAY'
                                                            AND Movement.StatusId <> zc_Enum_Status_Erased()
                                       );
              END IF;

              -- ���������� ����� - ��� 100 DAY
              IF COALESCE (vbMovementId_TTN, 0) = 0
              THEN
              vbMovementId_TTN:= (SELECT Movement.Id
                                       FROM (SELECT zfConvert_StringToNumber (SUBSTR (inBarCode, 4, 13-4)) AS MovementId
                                             ) AS tmp
                                         INNER JOIN Movement ON Movement.Id = tmp.MovementId
                                                            AND Movement.DescId = zc_Movement_TransportGoods()
                                                            AND Movement.OperDate BETWEEN CURRENT_DATE - INTERVAL '333 DAY' AND CURRENT_DATE - INTERVAL '233 DAY'
                                                            AND Movement.StatusId <> zc_Enum_Status_Erased()
                                       );
              END IF;

              -- ���������� ����� - ��� 100 DAY
              IF COALESCE (vbMovementId_TTN, 0) = 0
              THEN
              vbMovementId_TTN:= (SELECT Movement.Id
                                       FROM (SELECT zfConvert_StringToNumber (SUBSTR (inBarCode, 4, 13-4)) AS MovementId
                                             ) AS tmp
                                         INNER JOIN Movement ON Movement.Id = tmp.MovementId
                                                            AND Movement.DescId = zc_Movement_TransportGoods()
                                                            AND Movement.OperDate BETWEEN CURRENT_DATE - INTERVAL '433 DAY' AND CURRENT_DATE - INTERVAL '333 DAY'
                                                            AND Movement.StatusId <> zc_Enum_Status_Erased()
                                       );
              END IF;

         ELSE -- �� InvNumber, �� ��� �������� ����������� - 8 DAY
              vbMovementId_TTN:= (SELECT Movement.Id
                                       FROM Movement
                                       WHERE Movement.InvNumber = TRIM (inBarCode)
                                         AND Movement.DescId = zc_Movement_TransportGoods()
                                         AND Movement.OperDate BETWEEN CURRENT_DATE - INTERVAL '8 DAY' AND CURRENT_DATE + INTERVAL '8 DAY'
                                         AND Movement.StatusId <> zc_Enum_Status_Erased()
                                       );
         END IF;

         -- ��������
         IF COALESCE (vbMovementId_TTN, 0) = 0
         THEN
             RAISE EXCEPTION '������.�������� <������-������������ ���������> � � <%> �� ������.', inBarCode;
         END IF;

     END IF;


     -- ������ � ���� ������ - ������ �� ������
     IF vbIsFindOnly = TRUE
     THEN
         RETURN; -- !!!�����!!!
     END IF;

     -- ������ - ���������� Movement
     ioMovementId:= lpInsertUpdate_Movement_ReestrTransportGoods (ioId               := ioMovementId
                                                                , inInvNumber        := CASE WHEN ioMovementId <> 0 THEN (SELECT InvNumber FROM Movement WHERE Id = ioMovementId) ELSE CAST (NEXTVAL ('Movement_ReestrTransportGoods_seq') AS TVarChar) END
                                                                -- �������� ���� ��� � Scale ��� BranchCode = 1
                                                                , inOperDate         := gpGet_Scale_OperDate (inIsCeh      := FALSE
                                                                                                            , inBranchCode := 1
                                                                                                            , inSession    := inSession
                                                                                                            )
                                                                , inUserId           := vbUserId
                                                                );

      -- ������ ���� ���� ���
      IF vbMovementId_TTN <> 0
      THEN
          -- ������������ <���������� ����> - ��� ����������� ���� "�������� �� ������"
          vbMemberId:= CASE WHEN vbUserId = 5 THEN 9457 ELSE
                       (SELECT ObjectLink_User_Member.ChildObjectId
                        FROM ObjectLink AS ObjectLink_User_Member
                        WHERE ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                          AND ObjectLink_User_Member.ObjectId = vbUserId)
                       END
                      ;
          -- ��������
          IF COALESCE (vbMemberId, 0) = 0
          THEN 
              RAISE EXCEPTION '������.� ������������ <%> �� ��������� �������� <���.����>.', lfGet_Object_ValueData (vbUserId);
          END IF;

          -- ����� �������� ��� ��������� <���>
          vbId_mi:= (SELECT MF_MovementItemId.ValueData :: Integer
                     FROM MovementFloat AS MF_MovementItemId
                     WHERE MF_MovementItemId.MovementId = vbMovementId_TTN
                       AND MF_MovementItemId.DescId = zc_MovementFloat_MovementItemId()
                    );

          -- ���������� ������� ��������/�������������
          vbIsInsert:= COALESCE (vbId_mi, 0) = 0;

          -- ���� ��� ������
          IF EXISTS (SELECT 1 FROM MovementItem WHERE Id = vbId_mi AND isErased = TRUE)
          THEN
              -- ����������� + ��������� !!!�.�. ����� ���������� ObjectId + MovementId!!!
              UPDATE MovementItem SET isErased = FALSE, ObjectId = vbMemberId, MovementId = ioMovementId WHERE Id = vbId_mi;
          ELSE
              -- ������ - ��������� <������� ���������> - <��� ����������� ���� "">
              vbId_mi := lpInsertUpdate_MovementItem (vbId_mi, zc_MI_Master(), vbMemberId, ioMovementId, 0, NULL);

              -- !!!�.�. ����� ���������� MovementId!!!
              UPDATE MovementItem SET MovementId = ioMovementId WHERE Id = vbId_mi;

          END IF;

          -- ��������� <����� ������������ ���� "">   
          PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), vbId_mi, CURRENT_TIMESTAMP);


          -- ��������� �������� � ��������� ��� <� �������� ����� � ������� ���������>
          PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_MovementItemId(), vbMovementId_TTN, vbId_mi);
          -- ��������� � ��������� ������� ����� � <��������� �� �������>
          PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ReestrKind(), vbMovementId_TTN, zc_Enum_ReestrKind_PartnerOut());


          -- ��������� ��������
          PERFORM lpInsert_MovementItemProtocol (vbId_mi, vbUserId, vbIsInsert);

      END IF; -- if ������ ���� ���� �������

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 01.02.20         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MI_ReestrTransportGoodsStart (inBarCode:= '4323306', inOperDate:= '23.10.2016', inCarId:= 340655, inPersonalDriverId:= 0, inMemberId:= 0, ioMovementId_TransportTop:= 2298218, inSession:= '5');
