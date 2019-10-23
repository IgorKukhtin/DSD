-- Function: gpInsertUpdate_Movement_Sale()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Sale (Integer, TVarChar, TDateTime, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Sale (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, TDateTime,  TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Sale (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, Integer, TDateTime,  TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Sale(
 INOUT ioId                    Integer    , -- ���� ������� <�������� �������>
    IN inInvNumber             TVarChar   , -- ����� ���������
    IN inOperDate              TDateTime  , -- ���� ���������
    IN inUnitId                Integer    , -- �� ���� (�������������)
    IN inJuridicalId           Integer    , -- ���� (����������)
    IN inPaidKindId            Integer    , -- ���� ���� ������
    IN inPartnerMedicalId      Integer    , -- ����������� ����������(���. ������)
    IN inGroupMemberSPId       Integer    , -- ��������� ��������(���. ������)
    IN inOperDateSP            TDateTime  , -- ���� ������� (���. ������)
    IN inInvNumberSP           TVarChar   , -- ����� ������� (���. ������)
    IN inMedicSP               TVarChar   , -- ��� ����� (���. ������)
    IN inMemberSP              TVarChar   , -- ��� �������� (���. ������)
    IN inComment               TVarChar   , -- ����������
   OUT outSPKindName           TVarChar   , -- ��� ���.�������
    IN inSession               TVarChar     -- ������ ������������
)
RETURNS Record AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMedicSPId Integer;
   DECLARE vbMemberSPId Integer;
   DECLARE vbAddress TVarChar;
   DECLARE vbINN TVarChar; 
   DECLARE vbPassport TVarChar;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Sale());
    vbUserId := inSession;

   IF COALESCE (inMemberSP, '') <> ''
      THEN
          inMemberSP:= TRIM (COALESCE (inMemberSP, ''));

          vbMemberSPId:= (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_MemberSP() and UPPER(TRIM (CAST (Object.ValueData AS TVarChar))) LIKE UPPER(inMemberSP) LIMIT 1);
          
          
          IF COALESCE (vbMemberSPId,0) = 0
             THEN 
                 -- �� ����� ���������
                 vbMemberSPId := gpInsertUpdate_Object_MemberSP (ioId               := 0
                                                               , inCode             := lfGet_ObjectCode(0, zc_Object_MemberSP()) 
                                                               , inName             := inMemberSP
                                                               , inPartnerMedicalId := inPartnerMedicalId    -- ���. ������.
                                                               , inGroupMemberSPId  := inGroupMemberSPId     -- ��������� ���.
                                                               , inHappyDate        := '' ::  TVarChar       -- ��� ��������
                                                               , inAddress          := '' ::  TVarChar       -- �����
                                                               , inINN              := '' ::  TVarChar       -- ���
                                                               , inPassport         := '' ::  TVarChar       -- ����� � ����� ��������
                                                               , inSession := inSession
                                                                );
          END IF;
          
          --�������� ��� ���.������ � 5 ������ ���� ��������� �����, ���, ����� � ����� ��������   
          IF inPartnerMedicalId = 3751525               ----3751525 - "����������� ������ "������ �5""
          THEN
              SELECT COALESCE (ObjectString_Address.ValueData, '')   :: TVarChar  AS Address
                   , COALESCE (ObjectString_INN.ValueData, '')       :: TVarChar  AS INN
                   , COALESCE (ObjectString_Passport.ValueData, '')  :: TVarChar  AS Passport
            INTO vbAddress, vbINN, vbPassport
              FROM Object AS Object_MemberSP
                  INNER JOIN ObjectLink AS ObjectLink_MemberSP_PartnerMedical
                                        ON ObjectLink_MemberSP_PartnerMedical.ObjectId = Object_MemberSP.Id
                                       AND ObjectLink_MemberSP_PartnerMedical.DescId = zc_ObjectLink_MemberSP_PartnerMedical()
                                       AND ObjectLink_MemberSP_PartnerMedical.ChildObjectId = inPartnerMedicalId
                  LEFT JOIN ObjectString AS ObjectString_Address
                                         ON ObjectString_Address.ObjectId = Object_MemberSP.Id
                                        AND ObjectString_Address.DescId = zc_ObjectString_MemberSP_Address()
                  LEFT JOIN ObjectString AS ObjectString_INN
                                         ON ObjectString_INN.ObjectId = Object_MemberSP.Id
                                        AND ObjectString_INN.DescId = zc_ObjectString_MemberSP_INN()
                  LEFT JOIN ObjectString AS ObjectString_Passport
                                         ON ObjectString_Passport.ObjectId = Object_MemberSP.Id
                                        AND ObjectString_Passport.DescId = zc_ObjectString_MemberSP_Passport()
              WHERE Object_MemberSP.DescId = zc_Object_MemberSP()
                AND Object_MemberSP.Id = vbMemberSPId;
                
              IF COALESCE (vbAddress, '') = ''
              THEN
                  RAISE EXCEPTION '������.�������� <����� ��������> �� �����������.';
              END IF;
              IF COALESCE (vbINN, '') = ''
              THEN
                  RAISE EXCEPTION '������.�������� <��� ��������> �� �����������.';
              END IF;
              IF COALESCE (vbPassport, '') = ''
              THEN
                  RAISE EXCEPTION '������.�������� <����� � ����� �������� ��������> �� �����������.';
              END IF;       
          END IF;
   END IF;

   IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
      AND vbUserId <> 235009 
      AND EXISTS(SELECT 1 FROM MovementLinkMovement AS MLM_Child
                     INNER JOIN MovementLinkObject AS MovementLinkObject_SPKind
                                                   ON MovementLinkObject_SPKind.MovementId = MLM_Child.MovementId
                                                  AND MovementLinkObject_SPKind.DescId = zc_MovementLinkObject_SPKind()
                                                  AND COALESCE (MovementLinkObject_SPKind.ObjectId, 0) = zc_Enum_SPKind_1303()
                     INNER JOIN Movement AS Movement_Invoice ON Movement_Invoice.Id = MLM_Child.MovementChildId
                 WHERE MLM_Child.MovementId = ioId
                   AND MLM_Child.descId = zc_MovementLinkMovement_Child())
   THEN
     RAISE EXCEPTION '������. �� ��������� ������� <���� (����.1303)> ��������� ��������� ���������.';            
   END IF;        

   IF COALESCE (inMedicSP, '') <> ''
      THEN
          inMedicSP:= TRIM (COALESCE (inMedicSP, ''));

          vbMedicSPId:= (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_MedicSP() AND UPPER(CAST(Object.ValueData AS TVarChar)) LIKE UPPER(inMedicSP) LIMIT 1);
          IF COALESCE (vbMedicSPId,0) = 0
             THEN 
                 -- �� ����� ���������
                 vbMedicSPId := gpInsertUpdate_Object_MedicSP (ioId      := 0
                                                             , inCode    := lfGet_ObjectCode(0, zc_Object_MedicSP()) 
                                                             , inName    := inMedicSP
                                                             , inPartnerMedicalId := inPartnerMedicalId
                                                             , inSession := inSession
                                                             );
          END IF;
   END IF;
   
    -- ��������� <��������>
    ioId := lpInsertUpdate_Movement_Sale (ioId          := ioId
                                        , inInvNumber   := inInvNumber
                                        , inOperDate    := inOperDate
                                        , inUnitId      := inUnitId
                                        , inJuridicalId := inJuridicalId
                                        , inPaidKindId  := inPaidKindId
                                        , inPartnerMedicalId:= inPartnerMedicalId
                                        , inGroupMemberSPId := inGroupMemberSPId
                                        , inOperDateSP      := inOperDateSP
                                        , inInvNumberSP     := inInvNumberSP
                                        , inMedicSP         := COALESCE (vbMedicSPId,0)
                                        , inMemberSP        := COALESCE (vbMemberSPId,0)
                                        , inComment         := inComment
                                        , inUserId          := vbUserId
                                        );

   IF COALESCE (inPartnerMedicalId,0) <> 0 OR
      --COALESCE (inOperDateSP,Null) <> Null OR
      COALESCE (inInvNumberSP,'') <> '' OR
      COALESCE (inMedicSP,'') <> '' OR
      COALESCE (inMemberSP,'') <> '' THEN
      
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_SP(), MovementItem.Id, True)
     FROM MovementItem
     WHERE MovementItem.MovementId = ioId
       AND MovementItem.DescId = zc_MI_Master();

    -- ��������� ����� � <��� ���.�������>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_SPKind(), ioId, zc_Enum_SPKind_1303());
 
   END IF;


   outSPKindName := (SELECT Object.ValueData 
                     FROM MovementLinkObject AS MLO
                          LEFT JOIN Object ON Object.Id = MLO.ObjectId
                     WHERE MLO.DescId = zc_MovementLinkObject_SPKind() AND MLO.MovementId = ioId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.  ��������� �.�.
 08.02.17         *
 13.10.15                                                                    *
*/