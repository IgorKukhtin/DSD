-- Function: gpInsertUpdate_MI_ReestrStart()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ReestrStart (Integer, TDateTime, Integer, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_ReestrStart(
 INOUT ioMovementId               Integer   , -- ���� ������� <��������>
    IN inOperDate                 TDateTime , -- ���� ���������
    IN inCarId                    Integer   , -- ����������
    IN inPersonalDriverId         Integer   , -- ��������� (��������)
    IN inMemberId                 Integer   , -- ���������� ����(����������)
 INOUT ioMovementId_TransportTop  Integer   , -- ���� ��������� ������� ����/���������� ������� ��������� - � �����
    IN inBarCode_Transport        TVarChar  , -- �/� ��������� ������� ����/���������� ������� ��������� - � �����
    IN inBarCode                  TVarChar  , -- �/� ��������� <�������>
    IN inSession                  TVarChar    -- ������ ������������
)                              
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbIsInsert Boolean;
   DECLARE vbId_mi Integer;
   DECLARE vbMovementId_sale Integer;
   DECLARE vbMemberId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Reestr());
     

     -- ������ � ���� ������ - ������ �� ������
     IF ioMovementId = 0
        AND inCarId  = 0
        AND inPersonalDriverId = 0
        AND inMemberId          = 0
        AND ioMovementId_TransportTop  = 0
        AND TRIM (inBarCode_Transport)        = ''
        AND TRIM (inBarCode)                  = ''
     THEN
         RETURN; -- !!!�����!!!
     END IF;


     -- ������ ������� ����
     IF TRIM (inBarCode_Transport) <> ''
     THEN
         IF CHAR_LENGTH (inBarCode_Transport) >= 13
         THEN -- �� ����� ����, �� ��� "��������" ����������� - 8 DAY
              ioMovementId_TransportTop:= (SELECT Movement.Id
                                           FROM (SELECT zfConvert_StringToNumber (SUBSTR (inBarCode_Transport, 4, 13-4)) AS MovementId
                                                ) AS tmp
                                                INNER JOIN Movement ON Movement.Id = tmp.MovementId
                                                                   AND Movement.DescId IN (zc_Movement_Transport(), zc_Movement_TransportService())
                                                                   AND Movement.OperDate BETWEEN CURRENT_DATE - INTERVAL '8 DAY' AND CURRENT_DATE + INTERVAL '8 DAY'
                                                                   AND Movement.StatusId <> zc_Enum_Status_Erased()
                                          );
         ELSE -- �� InvNumber, �� ��� �������� ����������� - 8 DAY
              ioMovementId_TransportTop:= (SELECT Movement.Id
                                           FROM Movement
                                           WHERE Movement.InvNumber = TRIM (inBarCode_Transport)
                                             AND Movement.DescId IN (zc_Movement_Transport(), zc_Movement_TransportService())
                                             AND Movement.OperDate BETWEEN CURRENT_DATE - INTERVAL '8 DAY' AND CURRENT_DATE + INTERVAL '8 DAY'
                                             AND Movement.StatusId <> zc_Enum_Status_Erased()
                                          );
         END IF;

         -- ��������
         IF COALESCE (ioMovementId_TransportTop, 0) = 0
         THEN
             RAISE EXCEPTION '������.�������� <������� ����> � � <%> �� ������.', inBarCode_Transport;
         END IF;

     END IF;


     -- ������ ������� ����������
     IF TRIM (inBarCode) <> ''
     THEN
         IF CHAR_LENGTH (inBarCode) >= 13
         THEN -- �� ����� ����, �� ��� "��������" ����������� - 33 DAY
              vbMovementId_sale:= (SELECT Movement.Id
                                   FROM (SELECT zfConvert_StringToNumber (SUBSTR (inBarCode, 4, 13-4)) AS MovementId
                                        ) AS tmp
                                        INNER JOIN Movement ON Movement.Id = tmp.MovementId
                                                           AND Movement.DescId = zc_Movement_Sale()
                                                           AND Movement.OperDate BETWEEN CURRENT_DATE - INTERVAL '33 DAY' AND CURRENT_DATE + INTERVAL '8 DAY'
                                                           AND Movement.StatusId <> zc_Enum_Status_Erased()
                                  );
         ELSE -- �� InvNumber, �� ��� �������� ����������� - 8 DAY
              vbMovementId_sale:= (SELECT Movement.Id
                                   FROM Movement
                                   WHERE Movement.InvNumber = TRIM (inBarCode)
                                     AND Movement.DescId = zc_Movement_Sale()
                                     AND Movement.OperDate BETWEEN CURRENT_DATE - INTERVAL '8 DAY' AND CURRENT_DATE + INTERVAL '8 DAY'
                                     AND Movement.StatusId <> zc_Enum_Status_Erased()
                                  );
         END IF;

         -- ��������
         IF COALESCE (vbMovementId_sale, 0) = 0
         THEN
             RAISE EXCEPTION '������.�������� <������� ����������> � � <%> �� ������.', inBarCode;
         END IF;

     END IF;


     -- ������ - ���������� Movement
     ioMovementId:= lpInsertUpdate_Movement_Reestr (ioId               := ioMovementId
                                                  , inInvNumber        := CASE WHEN ioMovementId <> 0 THEN (SELECT InvNumber FROM Movement WHERE Id = ioMovementId) ELSE CAST (NEXTVAL ('Movement_Reestr_seq') AS TVarChar) END
                                                  , inOperDate         := CASE WHEN ioMovementId <> 0 THEN (SELECT OperDate  FROM Movement WHERE Id = ioMovementId) ELSE CURRENT_DATE :: TDateTime END
                                                    -- ���� ���� - ���������� �� ��������, ���� ����� ��� ������� ��� ���������� ������� ���������
                                                  , inCarId            := CASE WHEN ioMovementId_TransportTop > 0 THEN (SELECT ObjectId FROM MovementLinkObject WHERE MovementId = ioMovementId_TransportTop AND DescId = zc_MovementLinkObject_Car())            ELSE inCarId            END
                                                    -- ���� ���� - ���������� �� ��������, ���� ����� ��� ������� ��� ���������� ������� ���������
                                                  , inPersonalDriverId := CASE WHEN ioMovementId_TransportTop > 0 THEN (SELECT ObjectId FROM MovementLinkObject WHERE MovementId = ioMovementId_TransportTop AND DescId = zc_MovementLinkObject_PersonalDriver()) ELSE inPersonalDriverId END
                                                    -- ����� ����� ����� �� ������
                                                  , inMemberId         := inMemberId
                                                  , inMovementId_Transport := ioMovementId_TransportTop
                                                  , inUserId           := vbUserId
                                                   );

      -- ������ ���� ���� �������
      IF vbMovementId_sale <> 0
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

          -- ����� �������� ��� ��������� <�������>
          vbId_mi:= (SELECT MF_MovementItemId.ValueData :: Integer
                     FROM MovementFloat AS MF_MovementItemId
                     WHERE MF_MovementItemId.MovementId = vbMovementId_sale
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
              -- ������ - ��������� <������� ���������> - <��� ����������� ���� "�������� �� ������">
              vbId_mi := lpInsertUpdate_MovementItem (vbId_mi, zc_MI_Master(), vbMemberId, ioMovementId, 0, NULL);

              -- !!!�.�. ����� ���������� MovementId!!!
              UPDATE MovementItem SET MovementId = ioMovementId WHERE Id = vbId_mi;

          END IF;

          -- ��������� <����� ������������ ���� "�������� �� ������">   
          PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), vbId_mi, CURRENT_TIMESTAMP);


          -- ��������� �������� � ��������� ������� <� �������� ����� � ������� ���������>
          PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_MovementItemId(), vbMovementId_sale, vbId_mi);
          -- ��������� � ��������� ������� ����� � <��������� �� �������>
          PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ReestrKind(), vbMovementId_sale, zc_Enum_ReestrKind_PartnerOut());


          -- ��������� ��������
          PERFORM lpInsert_MovementItemProtocol (vbId_mi, vbUserId, vbIsInsert);

      END IF; -- if ������ ���� ���� �������

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 22.10.16         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MI_ReestrStart (inBarCode:= '4323306', inOperDate:= '23.10.2016', inCarId:= 340655, inPersonalDriverId:= 0, inMemberId:= 0, ioMovementId_TransportTop:= 2298218, inSession:= '5');
