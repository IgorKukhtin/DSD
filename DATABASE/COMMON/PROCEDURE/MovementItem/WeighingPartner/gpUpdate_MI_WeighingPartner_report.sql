-- Function: gpUpdate_MI_WeighingPartner_report()

DROP FUNCTION IF EXISTS gpUpdate_MI_WeighingPartner_report (Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_WeighingPartner_report(
    IN inId                  Integer   , -- ���� ������� <������� ���������>
    IN inCountTare1          TFloat    , -- ���������� ������-���1
    IN inCountTare2          TFloat    , -- ���������� ������-���2
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbBoxId    Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     --vbUserId:= lpGetUserBySession (inSession);
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_MI_WeighingPartner_report());

     IF COALESCE (inId, 0) = 0
     THEN
         RAISE EXCEPTION '������.������ ��������� �� ����������.';
     END IF;

     --��������
     IF COALESCE (inCountTare1,0) <> 0 AND COALESCE (inCountTare2,0) <> 0
     THEN
         RAISE EXCEPTION '������.������ ���� ������� ���� �� �������� <������-���1> ��� <������-���2>.';
     END IF;


     -- �������
     IF inCountTare1 > 0
     THEN
          -- ������� ������-1
          vbBoxId := (SELECT OF.ObjectId
                      FROM ObjectFloat AS OF
                      WHERE OF.DescId = zc_ObjectFloat_Box_NPP()
                        AND OF.ValueData = 1
                     );

         -- ��������
         IF COALESCE (vbBoxId,0) = 0
         THEN
             RAISE EXCEPTION '������.<������-���1> � � �/� = <1> �� ������.';
         END IF;

         -- ��������� �������� <���������� ������-���1>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountTare1(), inId, inCountTare1);
         -- ��������� ����� � <������-���1>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Box1(), inId, vbBoxId);


     ELSEIF inCountTare2 > 0
     THEN
          -- ������� ������-2
          vbBoxId := (SELECT OF.ObjectId
                      FROM ObjectFloat AS OF
                      WHERE OF.DescId = zc_ObjectFloat_Box_NPP()
                        AND OF.ValueData = 2
                     );
         -- ��������
         IF COALESCE (vbBoxId,0) = 0
         THEN
             RAISE EXCEPTION '������.<������-���2> � � �/� = <2> �� ������.';
         END IF;

         -- ��������� �������� <���������� ������-���2>
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountTare1(), inId, inCountTare2);
        -- ��������� ����� � <������-���2>
        PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Box1(), inId, vbBoxId);

     -- ��������
     ELSE
         -- ��������� �������� <���������� ������>
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountTare1(), inId, 0);
        -- ��������� ����� � <������>
        PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Box1(), inId, NULL);

     END IF;



     --
     IF vbUserId = 9457 THEN RAISE EXCEPTION 'OK.'; END IF;

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 27.02.25         *
*/

-- ����
-- select * from gpUpdate_MI_WeighingPartner_report(inId := 317381166 , inCountTare1 := 0 , inCountTare2 := 1 ,  inSession := '9457');