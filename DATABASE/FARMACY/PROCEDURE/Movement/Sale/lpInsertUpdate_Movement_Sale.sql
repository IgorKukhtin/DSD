-- Function: lpInsertUpdate_Movement_Sale()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Sale (Integer, TVarChar, TDateTime, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Sale (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, TDateTime,  TVarChar, TVarChar, TVarChar, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Sale (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, Integer, TDateTime,  TVarChar, TVarChar, TVarChar, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Sale (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, Integer, TDateTime,  TVarChar, Integer, Integer, TVarChar, Integer);


CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Sale(
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
    IN inMedicSP               Integer    , -- ��� ����� (���. ������)
    IN inMemberSP              Integer    , -- ��� �������� (���. ������)
    IN inComment               TVarChar   , -- ����������
    IN inUserId                Integer     -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
    -- ��������
    inOperDate:= DATE_TRUNC ('DAY', inOperDate);
    IF inOperDate <> DATE_TRUNC ('DAY', inOperDate)
    THEN
        RAISE EXCEPTION '������.�������� ������ ����.';
    END IF;
    
    -- ���������� ������� ��������/�������������
    vbIsInsert:= COALESCE (ioId, 0) = 0;
    
    -- ��������� <��������>
    ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Sale(), inInvNumber, inOperDate, NULL, 0);
    
    -- ��������� ����� � <�� ���� (�������������)>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), ioId, inUnitId);
    
    
    IF COALESCE(inJuridicalId,0) = 0
    THEN
        --������� ����� � �����������
        IF EXISTS(SELECT 1 FROM MovementLinkObject
                  WHERE MovementId = ioId
                    AND DescId = zc_MovementLinkObject_Juridical())
        THEN
            DELETE FROM MovementLinkObject
            WHERE MovementId = ioId
              AND DescId = zc_MovementLinkObject_Juridical();
        END IF;
    ELSE
        -- ��������� ����� � <���� (����������)>
        PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Juridical(), ioId, inJuridicalId);
    END IF;

    -- ��������� ����� � <���� ���� ������>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKind(), ioId, inPaidKindId);
    
    -- ��������� <����������>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

    -- ��������� ����� � <>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PartnerMedical(), ioId, inPartnerMedicalId);
    -- ��������� ����� � <>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_GroupMemberSP(), ioId, inGroupMemberSPId);

    -- ��������� <>
    IF COALESCE(inInvNumberSP, '') <> '' 
       THEN
           IF EXISTS (SELECT 1 
                      FROM Movement 
                        INNER JOIN MovementString AS MovementString_InvNumberSP
                                                  ON MovementString_InvNumberSP.MovementId = Movement.Id
                                                 AND MovementString_InvNumberSP.DescId = zc_MovementString_InvNumberSP()
                                                 AND MovementString_InvNumberSP.ValueData = inInvNumberSP
                        INNER JOIN MovementLinkObject AS MovementLinkObject_PartnerMedical
                                                      ON MovementLinkObject_PartnerMedical.MovementId = Movement.Id
                                                     AND MovementLinkObject_PartnerMedical.DescId = zc_MovementLinkObject_PartnerMedical()
                                                     AND MovementLinkObject_PartnerMedical.ObjectId = inPartnerMedicalId
                        INNER JOIN MovementLinkObject AS MovementLinkObject_MedicSP
                                                      ON MovementLinkObject_MedicSP.MovementId = Movement.Id
                                                     AND MovementLinkObject_MedicSP.DescId = zc_MovementLinkObject_MedicSP()
                                                     AND MovementLinkObject_MedicSP.ObjectId = inMedicSP
                      WHERE Movement.DescId = zc_Movement_Sale()
                        AND Movement.StatusId <> zc_Enum_Status_Erased()
                        AND Movement.Id <> ioId
                      )
              THEN
                  RAISE EXCEPTION '������.�� ������� <%> ��� ���� �������.', inInvNumberSP;
              END IF;
    END IF;
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberSP(), ioId, inInvNumberSP);
    
    -- ��������� <>
    --PERFORM lpInsertUpdate_MovementString (zc_MovementString_MemberSP(), ioId, inMemberSP);
    -- ��������� <>
    --PERFORM lpInsertUpdate_MovementString (zc_MovementString_MedicSP(), ioId, inMedicSP);
   
    IF COALESCE(inPartnerMedicalId,0) <> 0 OR COALESCE(inInvNumberSP,'') <> '' THEN
          IF inOperDateSP > inOperDate
             THEN
                 RAISE EXCEPTION '��������� ���� �������.';
          END IF;
       -- ��������� <>
       PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateSP(), ioId, inOperDateSP);
    END IF;
    

    -- ��������� ����� � <>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_MedicSP(), ioId, inMedicSP);
    -- ��������� ����� � <>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_MemberSP(), ioId, inMemberSP);


    -- ��������� ��������
    PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.   ��������� �.�.
 18.01.18         *
 03.04.17         *
 14.02.17         *
 08.02.17         * add SP
 13.10.15                                                                       *
*/
