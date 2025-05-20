-- Function: gpUpdate_Movement_Sale_PrintForm_TotalPage()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Sale_PrintForm_TotalPage  (Integer, Integer, Integer, Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Movement_Sale_PrintForm_TotalPage(
    IN inMovementId       Integer,    --
    IN inMovementId_sale  Integer,    --
    IN inMovementDescId   Integer,    --
    IN inPrintKindId      Integer,    --
    IN inTotalPageCount   Integer,    --
    IN inSession          TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);

/*
1;"���������";"zc_Enum_PrintKind_Movement"
2;"����";"zc_Enum_PrintKind_Account"
3;"���";"zc_Enum_PrintKind_Transport"
4;"������������";"zc_Enum_PrintKind_Quality"
7;"���������";"zc_Enum_PrintKind_Tax"
8;"������������";"zc_Enum_PrintKind_TransportBill"
5;"����������� (�������)";"zc_Enum_PrintKind_Pack"
6;"������������ (�������)";"zc_Enum_PrintKind_Spec"
9;"����������� (������)";"zc_Enum_PrintKind_PackGross"
*/

/*
zc_MovementFloat_TotalPage_1 - ������� � ������ - ��������� - zc_Enum_PrintKind_Movement
zc_MovementFloat_TotalPage_2 - ������� � ������ - ������������ - zc_Enum_PrintKind_Quality
zc_MovementFloat_TotalPage_3 - ������� � ������ - ��� - zc_Enum_PrintKind_Transport
zc_MovementFloat_TotalPage_4 - ������� � ������ - ������������ - zc_Enum_PrintKind_TransportBill - ������ �����?
zc_MovementFloat_TotalPage_5 - ������� � ������ - ����������� ������ - zc_Enum_PrintKind_PackGross
zc_MovementFloat_TotalPage_6 - ������� � ������ - ����������� ������� - zc_Enum_PrintKind_Pack
zc_MovementFloat_TotalPage_7 - ������� � ������ - ������������ - zc_Enum_PrintKind_Spec
zc_MovementFloat_TotalPage_8 - ������� � ������ - ���� - zc_Enum_PrintKind_Account
*/

     -- 1
     IF inPrintKindId = zc_Enum_PrintKind_Movement()
     THEN
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalPage_1(), inMovementId, inTotalPageCount::TFloat);
         -- ��������� �������� <������ ���������>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalLines()
                                             , inMovementId
                                             , (SELECT COUNT (MovementItem.Id)
                                                FROM MovementItem
                                                WHERE MovementItem.MovementId = inMovementId
                                                  AND MovementItem.DescId     = zc_MI_Master()
                                                  AND MovementItem.isErased   = FALSE
                                               ) ::TFloat
                                              );


     -- 2
     ELSEIF inMovementDescId = zc_Movement_QualityDoc()
     THEN
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalPage_2(), inMovementId_sale, inTotalPageCount::TFloat);

     -- 3
     ELSEIF inMovementDescId = zc_Movement_TransportGoods()
     THEN
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalPage_3(), inMovementId_sale, inTotalPageCount::TFloat);

     -- 5
     ELSEIF inPrintKindId = zc_Enum_PrintKind_PackGross()
     THEN
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalPage_5(), inMovementId, inTotalPageCount::TFloat);

     -- 6
     ELSEIF inPrintKindId = zc_Enum_PrintKind_Pack()
     THEN
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalPage_6(), inMovementId, inTotalPageCount::TFloat);

     -- 7
     ELSEIF inPrintKindId = zc_Enum_PrintKind_Spec()
     THEN
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalPage_7(), inMovementId, inTotalPageCount::TFloat);

     -- 8
     ELSEIF inPrintKindId = zc_Enum_PrintKind_Account()
     THEN
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalPage_8(), inMovementId, inTotalPageCount::TFloat);

     ELSE
         RAISE EXCEPTION '������.inMovementId = <%> %inMovementId_sale = <%> %inMovementDescId = <%> (%) %inPrintKindId = <%> (%) %inTotalPageCount = <%>'
                       , inMovementId
                       , CHR (13)
                       , inMovementId_sale
                       , CHR (13)
                       , inMovementDescId, (SELECT ItemName FROM MovementDesc WHERE Id = inMovementDescId)
                       , CHR (13)
                       , inPrintKindId, lfGet_Object_ValueData_sh (inPrintKindId)
                       , CHR (13)
                       , inTotalPageCount
                        ;
     END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 01.05.25                                        *
*/

-- ����
-- SELCET * FROM gpUpdate_Movement_Sale_PrintForm_TotalPage (inMovementId:= 3, inMovementId_sale:=0, inMovementDescId:= 1, inPrintKindId:= 1, inTotalPageCount:= 1, inSession := '5');
