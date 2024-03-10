-- Function: gpInsertUpdate_Movement_TransportGoods (Integer, TVarChar, TDateTime, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer)

-- DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TransportGoods (Integer, TVarChar, TDateTime, Integer, TVarChar, Integer, Integer, Integer, TVarChar, Integer, Integer, TVarChar, Integer, TVarChar, Integer, TVarChar, Integer, TVarChar, Integer, TVarChar, Integer, TVarChar, Integer, TVarChar, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TransportGoods (Integer, TVarChar, TDateTime, Integer, TVarChar, Integer, Integer, Integer, TVarChar, Integer, Integer, TVarChar, Integer, TVarChar, Integer, TVarChar, Integer, TVarChar, Integer, TVarChar, Integer, TVarChar, Integer, TVarChar, TVarChar,Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TransportGoods (Integer, TVarChar, TDateTime, Integer, TVarChar, Integer, Integer, Integer, TVarChar, Integer, Integer, TVarChar, Integer, TVarChar, Integer, TVarChar, Integer, TVarChar, Integer, TVarChar, Integer, TVarChar, Integer, TVarChar, TVarChar,Integer, Integer, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_TransportGoods(
 INOUT ioId                  Integer   , -- ���� ������� <��������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inMovementId_Sale     Integer   , --
    IN inInvNumberMark       TVarChar  , --
    IN inCarId               Integer   , -- ����������
    IN inCarTrailerId        Integer   , -- ���������� (������)
    IN inPersonalDriverId    Integer   , -- ��������� (��������)
    IN inPersonalDriverName  TVarChar  , -- ��������� (��������)
    IN inRouteId             Integer   , --
    IN inMemberId1           Integer   , -- ������� ����/����������
    IN inMemberName1         TVarChar  , -- ������� ����/����������
    IN inMemberId2           Integer   , -- ��������� (����������� ����� �����������������)
    IN inMemberName2         TVarChar  , -- ��������� (����������� ����� �����������������)
    IN inMemberId3           Integer   , -- ³����� ��������
    IN inMemberName3         TVarChar  , -- ³����� ��������
    IN inMemberId4           Integer   , -- ���� (����������� ����� �����������������)
    IN inMemberName4         TVarChar  , -- ���� (����������� ����� �����������������)
    IN inMemberId5           Integer   , -- ������� ����/����������
    IN inMemberName5         TVarChar  , -- ������� ����/����������
    IN inMemberId6           Integer   , -- ���� ����/����������
    IN inMemberName6         TVarChar  , -- ���� ����/����������
    IN inMemberId7           Integer   , -- ������� (����������� ����� �����������������)
    IN inMemberName7         TVarChar  , -- ������� (����������� ����� �����������������)

    IN inCarName             TVarChar  , -- ����� ����
    IN inCarModelId          Integer   , -- ����� ����
    IN inCarJuridicalId      Integer   , -- ��.���� ����

    IN inBarCode             TVarChar  ,

    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCarId Integer;
   DECLARE vbMovementId_Transport Integer;
   DECLARE vbMovementDescId_Transport Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_TransportGoods());
     vbUserId:= lpGetUserBySession (inSession);


     -- ���� ������� �� �/� ��� ������
     inBarCode:= TRIM (inBarCode);

     -- ���� ������� �� �/� ��� ������
     vbMovementId_Transport:= (WITH tmpInvNumber AS (SELECT inBarCode AS BarCode WHERE CHAR_LENGTH (inBarCode) > 0 AND CHAR_LENGTH (inBarCode) < 13)
                                  , tmpBarCode   AS (SELECT zfConvert_StringToNumber (SUBSTR (inBarCode, 4, 13-4)) AS MovementId WHERE CHAR_LENGTH (inBarCode) >= 13)
                                  , tmpMovement  AS (SELECT * FROM Movement WHERE Movement.OperDate BETWEEN inOperDate - INTERVAL '5 DAY' AND inOperDate + INTERVAL '5 DAY'
                                                                              AND Movement.DescId IN (zc_Movement_Transport(), zc_Movement_TransportService())
                                                                              AND Movement.StatusId <> zc_Enum_Status_Erased()
                                                    )
                               SELECT Movement.Id
                               FROM tmpBarCode AS tmp
                                    INNER JOIN tmpMovement AS Movement ON Movement.Id = tmp.MovementId
                                                        --AND Movement.DescId IN (zc_Movement_Transport(), zc_Movement_TransportService())
                                                          AND Movement.OperDate BETWEEN inOperDate - INTERVAL '5 DAY' AND inOperDate + INTERVAL '5 DAY'
                                                        --AND Movement.StatusId <> zc_Enum_Status_Erased()
                              UNION
                               -- �� � ���������
                               SELECT Movement.Id
                               FROM tmpInvNumber AS tmp
                                    INNER JOIN tmpMovement AS Movement ON Movement.InvNumber = tmp.BarCode
                                                          AND Movement.DescId IN (zc_Movement_Transport(), zc_Movement_TransportService())
                                                          AND Movement.OperDate BETWEEN inOperDate - INTERVAL '5 DAY' AND inOperDate + INTERVAL '5 DAY'
                                                        --AND Movement.StatusId <> zc_Enum_Status_Erased()
                              );
     vbMovementDescId_Transport:= (SELECT Movement.DescId FROM Movement WHERE Movement.Id = vbMovementId_Transport);
                              
    -- ��������
    IF COALESCE (vbMovementId_Transport, 0) = 0 AND TRIM (inBarCode) <> ''
    THEN
        RAISE EXCEPTION '������.�������� � % <%> �� ������.'
                      , CASE WHEN CHAR_LENGTH (inBarCode) >= 13 THEN '�/�' ELSE '�' END
                      , inBarCode
                       ;
    END IF;
    -- ��������
    IF vbMovementDescId_Transport > 0 AND NOT EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = vbMovementId_Transport AND Movement.DescId IN (zc_Movement_Transport(), zc_Movement_TransportService()))
    THEN
        RAISE EXCEPTION '������.������ �������� <%> � <%> �� <%>.���������� �������������� �������� <%>.'
                      , (SELECT MovementDesc.ItemName FROM Movement JOIN MovementDesc ON MovementDesc.Id = Movement.DescId WHERE Movement.Id = vbMovementId_Transport)
                      , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = vbMovementId_Transport)
                      , (SELECT zfConvert_DateToString (Movement.OperDate) FROM Movement WHERE Movement.Id = vbMovementId_Transport)
                      , (SELECT MovementDesc.ItemName FROM MovementDesc WHERE MovementDesc.Id = zc_Movement_Transport())
                       ;
    END IF;
    -- ��������
    IF EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = vbMovementId_Transport AND Movement.StatusId = zc_Enum_Status_Erased())
    THEN
        RAISE EXCEPTION '������.�������� � <%> �� <%> ������.'
                      , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = vbMovementId_Transport)
                      , zfConvert_DateToString ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = vbMovementId_Transport))
                       ;
    END IF;

     IF vbMovementId_Transport > 0
     THEN
         -- ��� ������ �� ��������
         vbCarId           := COALESCE ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = vbMovementId_Transport AND MLO.DescId = zc_MovementLinkObject_Car() AND vbMovementDescId_Transport = zc_Movement_Transport()
                                   UNION SELECT MILO.ObjectId FROM MovementItem AS MI JOIN MovementItemLinkObject AS MILO ON MILO.MovementItemId = MI.Id AND MILO.DescId = zc_MILinkObject_Car() WHERE MI.MovementId = vbMovementId_Transport AND MI.DescId = zc_MI_Master() AND MI.isErased = FALSE AND vbMovementDescId_Transport = zc_Movement_TransportService()
                                        ), 0);
         inCarTrailerId    := COALESCE ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = vbMovementId_Transport AND MLO.DescId = zc_MovementLinkObject_CarTrailer()
                                   UNION SELECT MILO.ObjectId FROM MovementItem AS MI JOIN MovementItemLinkObject AS MILO ON MILO.MovementItemId = MI.Id AND MILO.DescId = zc_MILinkObject_CarTrailer() WHERE MI.MovementId = vbMovementId_Transport AND MI.DescId = zc_MI_Master() AND MI.isErased = FALSE AND vbMovementDescId_Transport = zc_Movement_TransportService()
                                        ), 0);

         inPersonalDriverId:= COALESCE ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = vbMovementId_Transport AND MLO.DescId = zc_MovementLinkObject_PersonalDriver() AND vbMovementDescId_Transport = zc_Movement_Transport()
                                   UNION SELECT MILO.ObjectId FROM MovementItem AS MI JOIN MovementItemLinkObject AS MILO ON MILO.MovementItemId = MI.Id AND MILO.DescId = zc_MILinkObject_MemberExternal() WHERE MI.MovementId = vbMovementId_Transport AND MI.DescId = zc_MI_Master() AND MI.isErased = FALSE AND vbMovementDescId_Transport = zc_Movement_TransportService()
                                        ), 0);
         inRouteId         := COALESCE ((SELECT MI.ObjectId  FROM MovementItem AS MI WHERE MI.MovementId = vbMovementId_Transport AND MI.DescId = zc_MI_Master() AND MI.isErased   = FALSE AND vbMovementDescId_Transport = zc_Movement_Transport()
                                   UNION SELECT MILO.ObjectId FROM MovementItem AS MI JOIN MovementItemLinkObject AS MILO ON MILO.MovementItemId = MI.Id AND MILO.DescId = zc_MILinkObject_Route() WHERE MI.MovementId = vbMovementId_Transport AND MI.DescId = zc_MI_Master() AND MI.isErased = FALSE AND vbMovementDescId_Transport = zc_Movement_TransportService()
                                         LIMIT 1
                                        ), 0);
     ELSE
         -- ���� ���� �� ������ (���� �� ������� ����������/������������� � ���. ���� ���������)
         vbCarId := COALESCE((SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Car() AND Object.ValueData = inCarName),0);
     END IF;

     IF COALESCE (vbMovementId_Transport, 0) = 0 AND COALESCE (vbCarId, 0) = 0 and TRIM (inCarName) <> ''
     THEN
         -- �������� / ��������������
         vbCarId:= lpInsertUpdate_Object_CarExternal (ioId                      := COALESCE(Object.Id,0)
                                                    , inCode                    := COALESCE(Object.ObjectCode, lfGet_ObjectCode (0, zc_Object_CarExternal()) )
                                                    , inName                    := inCarName
                                                    , inRegistrationCertificate := COALESCE(RegistrationCertificate.ValueData, '')
                                                    , inVIN                     := ''
                                                    , inComment                 := COALESCE(ObjectString_Comment.ValueData, '')
                                                    , inCarModelId              := inCarModelId
                                                    , inCarTypeId               := ObjectLink_CarType.ChildObjectId      ::Integer
                                                    , inCarPropertyId           := CarExternal_CarProperty.ChildObjectId ::Integer
                                                    , inObjectColorId           := CarExternal_ObjectColor.ChildObjectId ::Integer
                                                    , inJuridicalId             := inCarJuridicalId
                                                    , inLength                  := 0
                                                    , inWidth                   := 0
                                                    , inHeight                  := 0
                                                    , inWeight                  := 0
                                                    , inYear                    := 0
                                                    , inUserId                  := vbUserId
                                                     )
                    FROM (SELECT  0 AS CarId) as tmpCarNew
                        LEFT JOIN Object ON Object.DescId = zc_Object_CarExternal()
                                        AND Object.ValueData = inCarName
                        LEFT JOIN ObjectString AS RegistrationCertificate
                                               ON RegistrationCertificate.ObjectId = Object.Id
                                              AND RegistrationCertificate.DescId = zc_ObjectString_CarExternal_RegistrationCertificate()
                        LEFT JOIN ObjectString AS ObjectString_Comment
                                               ON ObjectString_Comment.ObjectId = Object.Id
                                              AND ObjectString_Comment.DescId = zc_ObjectString_CarExternal_Comment()

                        LEFT JOIN ObjectLink AS ObjectLink_CarType
                                             ON ObjectLink_CarType.ObjectId = Object.Id
                                            AND ObjectLink_CarType.DescId = zc_ObjectLink_Car_CarType()

                        LEFT JOIN ObjectLink AS CarExternal_CarProperty
                                             ON CarExternal_CarProperty.ObjectId = Object.Id
                                            AND CarExternal_CarProperty.DescId = zc_ObjectLink_CarExternal_CarProperty()

                        LEFT JOIN ObjectLink AS CarExternal_ObjectColor
                                             ON CarExternal_ObjectColor.ObjectId = Object.Id
                                            AND CarExternal_ObjectColor.DescId = zc_ObjectLink_CarExternal_ObjectColor()
                    ;
     END IF;


     IF COALESCE (vbMovementId_Transport, 0) = 0 AND TRIM (inPersonalDriverName) <> ''
        AND NOT EXISTS (SELECT Object.Id FROM Object WHERE Object.Id = inPersonalDriverId AND Object.DescId = zc_Object_Personal() AND Object.ValueData = inPersonalDriverName)
     THEN
         -- ����� <��������� (��������)>
         inPersonalDriverId:= (SELECT Object_MemberExternal.Id FROM Object AS Object_MemberExternal WHERE Object_MemberExternal.ValueData = TRIM (inPersonalDriverName) AND Object_MemberExternal.DescId = zc_Object_MemberExternal());
         
         IF COALESCE (inPersonalDriverId, 0) = 0 AND TRIM (inPersonalDriverName) <> ''
         THEN
             -- ��������
             inPersonalDriverId:= lpInsertUpdate_Object_MemberExternal (ioId    := inPersonalDriverId
                                                                      , inCode  := 0
                                                                      , inName  := inPersonalDriverName
                                                                      , inDriverCertificate := '' ::TVarChar
                                                                      , inINN   := '' ::TVarChar
                                                                      , inUserId:= vbUserId
                                                                       );
         END IF;
     END IF;

     IF NOT EXISTS (SELECT Object.Id FROM Object WHERE Object.Id = inMemberId1 AND Object.DescId = zc_Object_Member() AND Object.ValueData = inMemberName1)
     THEN
         -- ����� <������� ����/����������>
         inMemberId1:= (SELECT Object_MemberExternal.Id FROM Object AS Object_MemberExternal WHERE Object_MemberExternal.ValueData = TRIM (inMemberName1) AND Object_MemberExternal.DescId = zc_Object_MemberExternal());
         IF COALESCE (inMemberId1, 0) = 0 AND TRIM (inMemberName1) <> ''
         THEN
             -- ��������
             inMemberId1:= lpInsertUpdate_Object_MemberExternal (ioId    := inMemberId1
                                                               , inCode  := 0
                                                               , inName  := inMemberName1
                                                               , inDriverCertificate := '' ::TVarChar
                                                               , inINN   := '' ::TVarChar
                                                               , inUserId:= vbUserId
                                                                );
         END IF;
     END IF;

     IF NOT EXISTS (SELECT Object.Id FROM Object WHERE Object.Id = inMemberId2 AND Object.DescId = zc_Object_Member() AND Object.ValueData = inMemberName2)
     THEN
         -- ����� <��������� (����������� ����� �����������������)>
         inMemberId2:= (SELECT Object_MemberExternal.Id FROM Object AS Object_MemberExternal WHERE Object_MemberExternal.ValueData = TRIM (inMemberName2) AND Object_MemberExternal.DescId = zc_Object_MemberExternal());
         IF COALESCE (inMemberId2, 0) = 0 AND TRIM (inMemberName2) <> ''
         THEN
             -- ��������
             inMemberId2:= lpInsertUpdate_Object_MemberExternal (ioId    := inMemberId2
                                                               , inCode  := 0
                                                               , inName  := inMemberName2
                                                               , inDriverCertificate := '' ::TVarChar
                                                               , inINN   := '' ::TVarChar
                                                               , inUserId:= vbUserId
                                                                );
         END IF;
     END IF;

     IF NOT EXISTS (SELECT Object.Id FROM Object WHERE Object.Id = inMemberId3 AND Object.DescId = zc_Object_Member() AND Object.ValueData = inMemberName3)
     THEN
         -- ����� <³����� ��������>
         inMemberId3:= (SELECT Object_MemberExternal.Id FROM Object AS Object_MemberExternal WHERE Object_MemberExternal.ValueData = TRIM (inMemberName3) AND Object_MemberExternal.DescId = zc_Object_MemberExternal());
         IF COALESCE (inMemberId3, 0) = 0 AND TRIM (inMemberName3) <> ''
         THEN
             -- ��������
             inMemberId3:= lpInsertUpdate_Object_MemberExternal (ioId    := inMemberId3
                                                               , inCode  := 0
                                                               , inName  := inMemberName3
                                                               , inDriverCertificate := '' ::TVarChar
                                                               , inINN   := '' ::TVarChar
                                                               , inUserId:= vbUserId
                                                                );
         END IF;
     END IF;

     -- IF NOT EXISTS (SELECT Object.Id FROM Object WHERE Object.Id = inMemberId4 AND Object.DescId = zc_Object_Personal() AND Object.ValueData = inMemberName4)
     -- THEN
     -- ����� <���� (����������� ����� �����������������)>
     inMemberId4:= (SELECT Object_MemberExternal.Id FROM Object AS Object_MemberExternal WHERE Object_MemberExternal.ValueData = TRIM (inMemberName4) AND Object_MemberExternal.DescId = zc_Object_MemberExternal());
     IF COALESCE (inMemberId4, 0) = 0 AND TRIM (inMemberName4) <> ''
     THEN
         -- ��������
         inMemberId4:= lpInsertUpdate_Object_MemberExternal (ioId    := inMemberId4
                                                           , inCode  := 0
                                                           , inName  := inMemberName4
                                                           , inDriverCertificate := '' ::TVarChar
                                                           , inINN   := '' ::TVarChar
                                                           , inUserId:= vbUserId
                                                            );
     END IF;
     -- END IF;

     IF NOT EXISTS (SELECT Object.Id FROM Object WHERE Object.Id = inMemberId5 AND Object.DescId = zc_Object_Member() AND Object.ValueData = inMemberName5)
     THEN
         -- ����� <������� ����/����������>
         inMemberId5:= (SELECT Object_MemberExternal.Id FROM Object AS Object_MemberExternal WHERE Object_MemberExternal.ValueData = TRIM (inMemberName5) AND Object_MemberExternal.DescId = zc_Object_MemberExternal());
         IF COALESCE (inMemberId5, 0) = 0 AND TRIM (inMemberName5) <> ''
         THEN
             -- ��������
             inMemberId5:= lpInsertUpdate_Object_MemberExternal (ioId    := inMemberId5
                                                               , inCode  := 0
                                                               , inName  := inMemberName5
                                                               , inDriverCertificate := '' ::TVarChar
                                                               , inINN   := '' ::TVarChar
                                                               , inUserId:= vbUserId
                                                                );
         END IF;
     END IF;

     IF NOT EXISTS (SELECT Object.Id FROM Object WHERE Object.Id = inMemberId6 AND Object.DescId = zc_Object_Member() AND Object.ValueData = inMemberName6)
     THEN
         -- ����� <���� ����/����������>
         inMemberId6:= (SELECT Object_MemberExternal.Id FROM Object AS Object_MemberExternal WHERE Object_MemberExternal.ValueData = TRIM (inMemberName6) AND Object_MemberExternal.DescId = zc_Object_MemberExternal());
         IF COALESCE (inMemberId6, 0) = 0 AND TRIM (inMemberName6) <> ''
         THEN
             -- ��������
             inMemberId6:= lpInsertUpdate_Object_MemberExternal (ioId    := inMemberId6
                                                               , inCode  := 0
                                                               , inName  := inMemberName6
                                                               , inUserId:= vbUserId
                                                                );
         END IF;
     END IF;

     -- ����� <������� (����������� ����� �����������������)>
     inMemberId7:= (SELECT Object_MemberExternal.Id FROM Object AS Object_MemberExternal WHERE Object_MemberExternal.ValueData = TRIM (inMemberName7) AND Object_MemberExternal.DescId = zc_Object_MemberExternal());
     IF COALESCE (inMemberId7, 0) = 0 AND TRIM (inMemberName7) <> ''
     THEN
         -- ��������
         inMemberId7:= lpInsertUpdate_Object_MemberExternal (ioId    := inMemberId7
                                                           , inCode  := 0
                                                           , inName  := inMemberName7
                                                           , inDriverCertificate := '' ::TVarChar
                                                           , inINN   := '' ::TVarChar
                                                           , inUserId:= vbUserId
                                                            );
     END IF;

     -- ��������� <��������>
     ioId:= lpInsertUpdate_Movement_TransportGoods (ioId              := ioId
                                                  , inInvNumber       := inInvNumber
                                                  , inOperDate        := inOperDate
                                                  , inMovementId_Sale := inMovementId_Sale
                                                  , inInvNumberMark   := inInvNumberMark
                                                  , inCarId           := vbCarId
                                                  , inCarTrailerId    := inCarTrailerId
                                                  , inPersonalDriverId:= inPersonalDriverId ::integer
                                                  , inRouteId         := inRouteId
                                                  , inMemberId1       := inMemberId1
                                                  , inMemberId2       := inMemberId2
                                                  , inMemberId3       := inMemberId3
                                                  , inMemberId4       := inMemberId4
                                                  , inMemberId5       := inMemberId5
                                                  , inMemberId6       := inMemberId6
                                                  , inMemberId7       := inMemberId7
                                                  , inUserId          := vbUserId
                                                   );
     -- ��������� ����� � ���������� <Transport>
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Transport(), ioId, vbMovementId_Transport);

IF vbUserId = 5 AND 1=0
THEN
    RAISE EXCEPTION '������.ok';
END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 28.02.20         * zc_Object_Member - ������ zc_Object_Personal
 17.03.16         *
 30.03.15                                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_TransportGoods (ioId:= 149691, inInvNumber:= '1', inOperDate:= '01.10.2013 3:00:00',............, inSession:= '2')
