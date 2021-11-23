-- Function: gpUpdate_MI_Over_Amount()

DROP FUNCTION IF EXISTS gpUpdate_MI_PersonalService_SummNalogRet  (Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_PersonalService_SummNalogRet(
    IN inId                  Integer   , -- ���� ������� <������� ���������>
    IN inSummNalog           TFloat    ,
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Over());
   vbUserId:= lpGetUserBySession (inSession);


   -- ��������
   IF COALESCE (inId, 0) = 0
   THEN
       RAISE EXCEPTION '������.�� ������� ����� ����������.';
   END IF;


   -- ��������� �������� <>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummNalogRet(), inId, inSummNalog);

   -- ��������� �������� <����� (�������)>
   PERFORM lpInsertUpdate_MovementItem (inId, MovementItem.DescId, MovementItem.ObjectId, MovementItem.MovementId
                    -- SummService
                  , COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = inId AND MIF.DescId = zc_MIFloat_SummService()), 0)
                    -- SummMinus
                  - COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = inId AND MIF.DescId = zc_MIFloat_SummMinus()), 0)
                    -- SummFine
                  - COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = inId AND MIF.DescId = zc_MIFloat_SummFine()), 0)
                    -- SummAdd
                  + COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = inId AND MIF.DescId = zc_MIFloat_SummAdd()), 0)
                    -- SummAddOth
                  + COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = inId AND MIF.DescId = zc_MIFloat_SummAddOth()), 0)
                    -- SummHoliday
                  + COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = inId AND MIF.DescId = zc_MIFloat_SummHoliday()), 0)
                    -- SummHosp
                  + COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = inId AND MIF.DescId = zc_MIFloat_SummHosp()), 0)
                    -- SummAuditAdd
                  + COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = inId AND MIF.DescId = zc_MIFloat_SummAuditAdd()), 0)
                    -- SummHouseAdd
                  + COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = inId AND MIF.DescId = zc_MIFloat_SummHouseAdd()), 0)
                    -- 
                  , MovementItem.ParentId
                  )
   FROM MovementItem
   WHERE MovementItem.Id = inId;
   -- ��������� �������� <����� � �������>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummToPay(), inId
                    -- SummService
                  , COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = inId AND MIF.DescId = zc_MIFloat_SummService()), 0)
                    -- SummMinus
                  - COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = inId AND MIF.DescId = zc_MIFloat_SummMinus()), 0)
                    -- SummFine
                  - COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = inId AND MIF.DescId = zc_MIFloat_SummFine()), 0)
                    -- SummAdd
                  + COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = inId AND MIF.DescId = zc_MIFloat_SummAdd()), 0)
                    -- SummAddOth
                  + COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = inId AND MIF.DescId = zc_MIFloat_SummAddOth()), 0)
                    -- SummHoliday
                  + COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = inId AND MIF.DescId = zc_MIFloat_SummHoliday()), 0)
                    -- SummHosp
                  + COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = inId AND MIF.DescId = zc_MIFloat_SummHosp()), 0)
                    -- SummSocialAdd
                  + COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = inId AND MIF.DescId = zc_MIFloat_SummSocialAdd()), 0)

                    -- SummTransport
                  - COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = inId AND MIF.DescId = zc_MIFloat_SummTransport()), 0)
                    -- SummTransportAdd
                  + COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = inId AND MIF.DescId = zc_MIFloat_SummTransportAdd()), 0)
                    -- SummTransportAddLong
                  + COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = inId AND MIF.DescId = zc_MIFloat_SummTransportAddLong()), 0)
                    -- SummTransportTaxi
                  + COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = inId AND MIF.DescId = zc_MIFloat_SummTransportTaxi()), 0)

                    -- SummPhone
                  - COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = inId AND MIF.DescId = zc_MIFloat_SummPhone()), 0)

                    -- SummNalog: "�����" <������ - ��������� � ��>
                  - COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = inId AND MIF.DescId = zc_MIFloat_SummNalog()), 0)
                    -- SummNalogRet :"����" <������ - ���������� � ��>
               -- + inSummNalog
                  + COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = inId AND MIF.DescId = zc_MIFloat_SummNalogRet()), 0)    --
                    -- SummChild: "�����" <�������� - ���������>
                  - COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = inId AND MIF.DescId = zc_MIFloat_SummChild()), 0)
                    -- SummMinusExt: "�����" <��������� ������. ��.�.>
                  - COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = inId AND MIF.DescId = zc_MIFloat_SummMinusExt()), 0)
                    -- SummAuditAdd
                  + COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = inId AND MIF.DescId = zc_MIFloat_SummAuditAdd()), 0)
                    -- SummHouseAdd
                  + COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = inId AND MIF.DescId = zc_MIFloat_SummHouseAdd()), 0)
                  );


   -- ��������� ��������
   PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, False);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 09.01.18         *
*/

-- ����
--