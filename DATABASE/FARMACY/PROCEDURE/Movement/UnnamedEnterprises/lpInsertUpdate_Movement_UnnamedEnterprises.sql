-- Function: lpInsertUpdate_Movement_UnnamedEnterprises()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_UnnamedEnterprises (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar, TFloat, TVarChar, TFloat, TDateTime, Integer);


CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_UnnamedEnterprises(
 INOUT ioId                    Integer    , -- ���� ������� <�������� �������>
    IN inInvNumber             TVarChar   , -- ����� ���������
    IN inOperDate              TDateTime  , -- ���� ���������
    IN inUnitId                Integer    , -- �� ���� (�������������)
    IN inClientsByBankId       Integer    , -- ���� (����������)
    IN inComment               TVarChar   , -- ����������
    IN inAmountAccount         TFloat     , -- ����� � �����
    IN inAccountNumber         TVarChar   , -- ����� �����
    IN inAmountPayment         TFloat     , -- ����� ������
    IN inDatePayment           TDateTime  , -- ���� ������
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
    ioId := lpInsertUpdate_Movement (ioId, zc_Movement_UnnamedEnterprises(), inInvNumber, inOperDate, NULL, 0);
    
    -- ��������� ����� � <�� ���� (�������������)>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), ioId, inUnitId);
    
    
    IF COALESCE(inClientsByBankId,0) = 0
    THEN
        --������� ����� � �����������
        IF EXISTS(SELECT 1 FROM MovementLinkObject
                  WHERE MovementId = ioId
                    AND DescId = zc_MovementLinkObject_ClientsByBank())
        THEN
            DELETE FROM MovementLinkObject
            WHERE MovementId = ioId
              AND DescId = zc_MovementLinkObject_ClientsByBank();
        END IF;
    ELSE
        -- ��������� ����� � <���� (����������)>
        PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ClientsByBank(), ioId, inClientsByBankId);
    END IF;
    
    IF vbIsInsert = TRUE AND COALESCE(inComment, '') = '' AND COALESCE (inClientsByBankId, 0) <> 0 AND
      EXISTS( SELECT MovementString_Comment.ValueData
              FROM Movement

                   INNER JOIN MovementLinkObject AS MovementLinkObject_ClientsByBank
                                                 ON MovementLinkObject_ClientsByBank.MovementId = Movement.Id
                                                AND MovementLinkObject_ClientsByBank.DescId = zc_MovementLinkObject_ClientsByBank()
                                                AND MovementLinkObject_ClientsByBank.ObjectId = inClientsByBankId

                   INNER JOIN MovementString AS MovementString_Comment
                                            ON MovementString_Comment.MovementId = Movement.Id
                                           AND MovementString_Comment.DescId = zc_MovementString_Comment()
                                           AND COALESCE(MovementString_Comment.ValueData, '') <> ''

              WHERE Movement.DescId = zc_Movement_UnnamedEnterprises()
                AND Movement.StatusId = zc_Enum_Status_Complete())
    THEN
      SELECT MovementString_Comment.ValueData
      INTO inComment
      FROM Movement

           INNER JOIN MovementLinkObject AS MovementLinkObject_ClientsByBank
                                         ON MovementLinkObject_ClientsByBank.MovementId = Movement.Id
                                        AND MovementLinkObject_ClientsByBank.DescId = zc_MovementLinkObject_ClientsByBank()
                                        AND MovementLinkObject_ClientsByBank.ObjectId = inClientsByBankId

           INNER JOIN MovementString AS MovementString_Comment
                                    ON MovementString_Comment.MovementId = Movement.Id
                                   AND MovementString_Comment.DescId = zc_MovementString_Comment()
                                   AND COALESCE(MovementString_Comment.ValueData, '') <> ''

      WHERE Movement.DescId = zc_Movement_UnnamedEnterprises()
        AND Movement.StatusId = zc_Enum_Status_Complete()   
      ORDER BY Movement.OperDate DESC
      LIMIT 1;
    END IF;
    
    -- ��������� <����������>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

    -- ��������� <����� � �����>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_AmountAccount(), ioId, inAmountAccount);

    -- ��������� <����� �����>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_AccountNumber(), ioId, inAccountNumber);

    -- ��������� <����� ������>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_AmountPayment(), ioId, inAmountPayment);

    -- ��������� <���� ������>
    IF COALESCE(inAmountPayment, 0) = 0
    THEN
        --������� ����� � <���� ������>
        IF EXISTS(SELECT 1 FROM MovementDate
                  WHERE MovementId = ioId
                    AND DescId = zc_MovementDate_DatePayment())
        THEN
            DELETE FROM MovementDate
            WHERE MovementId = ioId
              AND DescId = zc_MovementDate_DatePayment();
        END IF;
    ELSE
        -- ��������� ����� � <���� ������>
        PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_DatePayment(), ioId, inDatePayment);
    END IF;
    

    -- !!!�������� ����� �������� ����������� �������!!!
     IF vbIsInsert = FALSE
     THEN
         -- ��������� �������� <���� �������������>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Update(), ioId, CURRENT_TIMESTAMP);
         -- ��������� �������� <������������ (�������������)>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Update(), ioId, inUserId);
     ELSE
         IF vbIsInsert = TRUE
         THEN
             -- ��������� �������� <���� ��������>
             PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
             -- ��������� �������� <������������ (��������)>
             PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, inUserId);
         END IF;
     END IF;
     
    -- ��������� ��������
    PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������ �.�.
 09.04.19         *
 30.09.18         *
*/
--
