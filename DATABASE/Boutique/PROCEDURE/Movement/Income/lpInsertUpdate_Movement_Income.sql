-- Function: lpInsertUpdate_Movement_Income()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Income (Integer, TVarChar, TDateTime, Integer, Integer, Integer, TFloat, TFloat, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Income(
 INOUT ioId                   Integer   , -- ���� ������� <��������>
    IN inInvNumber            TVarChar  , -- ����� ���������
    IN inOperDate             TDateTime , -- ���� ���������
    IN inFromId               Integer   , -- �� ���� (� ���������)
    IN inToId                 Integer   , -- ���� (� ���������)
    IN inCurrencyDocumentId   Integer   , -- ������ (���������)
    IN inCurrencyValue        TFloat    , -- ���� ������
    IN inParValue             TFloat    , -- ������� ��� �������� � ������ �������
    IN inComment              TVarChar  , -- ����������
    IN inUserId               Integer     -- ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert     Boolean;
   DECLARE vbId_sale_part Integer;
BEGIN
     -- ��������
     IF inOperDate <> DATE_TRUNC ('DAY', inOperDate) THEN
         RAISE EXCEPTION '������.�������� ������ ����.';
     END IF;

     -- �������� - ���������
     IF COALESCE (inFromId, 0) = 0
     THEN
         RAISE EXCEPTION '������. �� ����������� �������� <���������>.';
     END IF;
     -- �������� - �������������
     IF COALESCE (inToId, 0) = 0
     THEN
         RAISE EXCEPTION '������. �� ����������� �������� <�������������>.';
     END IF;

     -- ��������
     IF COALESCE (inCurrencyDocumentId, 0) = 0 THEN
        RAISE EXCEPTION '������.�� ����������� �������� <������>.';
     END IF;

     -- ���� �� ������� ������
     IF inCurrencyDocumentId <> zc_Currency_Basis() THEN
        -- ��������
        IF COALESCE (inCurrencyValue, 0) = 0 THEN
           RAISE EXCEPTION '������.�� ���������� �������� <����>.';
        END IF;
        -- ��������
        IF COALESCE (inParValue, 0) = 0 THEN
           RAISE EXCEPTION '������.�� ���������� �������� <�������>.';
        END IF;
     END IF;


     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <��������>
     ioId:= lpInsertUpdate_Movement (ioId        := ioId
                                   , inDescId    := zc_Movement_Income()
                                   , inInvNumber := inInvNumber
                                   , inOperDate  := inOperDate
                                   , inParentId  := NULL
                                   , inUserId    := inUserId
                                    );

     -- ������ ��� Update
     IF vbIsInsert = FALSE
     THEN
         -- !!!����� Sybase!!! - !!!�� ������ - ��������� ��� ��� ��������, ����� ���� � ������ ����� ������!!!
         -- ��� ���� ������
         IF inUserId <> zc_User_Sybase()
            AND (inToId               <> (SELECT MAX (COALESCE (Object_PartionGoods.UnitId, 0))     FROM Object_PartionGoods WHERE Object_PartionGoods.MovementId = ioId AND COALESCE (Object_PartionGoods.UnitId, 0)     <> inToId)
              -- OR inFromId             <> (SELECT MAX (COALESCE (Object_PartionGoods.PartnerId, 0))  FROM Object_PartionGoods WHERE Object_PartionGoods.MovementId = ioId AND COALESCE (Object_PartionGoods.PartnerId, 0)  <> inFromId)
              OR inCurrencyDocumentId <> (SELECT MAX (COALESCE (Object_PartionGoods.CurrencyId, 0)) FROM Object_PartionGoods WHERE Object_PartionGoods.MovementId = ioId AND COALESCE (Object_PartionGoods.CurrencyId, 0) <> inCurrencyDocumentId)
                )
         THEN
            -- ���� �� ����������� ��������� - ���
            vbId_sale_part:= (SELECT MovementItem.Id
                              FROM Object_PartionGoods
                                   INNER JOIN MovementItem ON MovementItem.PartionId = Object_PartionGoods.MovementItemId
                                                          AND MovementItem.isErased  = FALSE -- !!!������ �� ���������!!!
                                                          -- AND MovementItem.DescId = ...   -- !!!����� Desc!!!
                                   INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                      AND Movement.StatusId = zc_Enum_Status_Complete() -- !!!������ �����������!!!
                                                      AND Movement.DescId   <> zc_Movement_Income()     -- !!!������ �� ������ �� ������.!!!
                              WHERE Object_PartionGoods.MovementId = ioId
                              ORDER BY Movement.OperDate DESC
                              LIMIT 1
                             );
             -- �������� - ��� ���� ������
            IF vbId_sale_part > 0
            THEN
                RAISE EXCEPTION '������.������� �������� <%> � <%> �� <%>.������ �������������� <��������>.'
                              , (SELECT MovementDesc.ItemName
                                 FROM MovementItem
                                      INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                                      INNER JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
                                 WHERE MovementItem.Id = vbId_sale_part
                                )
                              , (SELECT Movement.InvNumber
                                 FROM MovementItem
                                      INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                                 WHERE MovementItem.Id = vbId_sale_part
                                )
                              , (SELECT zfConvert_DateToString (Movement.OperDate)
                                 FROM MovementItem
                                      INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                                 WHERE MovementItem.Id = vbId_sale_part
                                )
                               ;
            END IF;
         END IF;

         -- !!!�� ������ - �������� �������� � ������!!!
         PERFORM lpUpdate_Object_PartionGoods_Movement (inMovementId := ioId
                                                      , inPartnerId  := inFromId
                                                      , inUnitId     := inToId
                                                      , inOperDate   := inOperDate
                                                      , inCurrencyId := inCurrencyDocumentId
                                                      , inUserId     := inUserId
                                                       );

         -- !!!����� Sybase!!! - !!!�� ������ - ��������� ��� ��� ��������, ����� ���� ���� � ������� ����� ������!!!
         -- PERFORM lpCheck ...
         -- !!!����� Sybase!!! - !!!�� ������ - �������� ���� ���� � �������!!!
         -- PERFORM lpUpdate_ObjectHistory ...

     END IF;


     -- ��������� �������� <���� ��� �������� � ������ �������>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_CurrencyValue(), ioId, inCurrencyValue);
     -- ��������� �������� <���� ��� �������� � ������ �������>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ParValue(), ioId, inParValue);

     -- ��������� �������� <����������>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

     -- ��������� ����� � <�� ���� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId);
     -- ��������� ����� � <���� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inToId);

     -- ��������� ����� � <������ (���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_CurrencyDocument(), ioId, inCurrencyDocumentId);

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (ioId);

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
 09.06.17                                                       *  add inUserId in lpInsertUpdate_Movement
 10.04.17         *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_Movement_Income (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
