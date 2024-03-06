-- Function: gpUpdate_MI_Send_byReport()

DROP FUNCTION IF EXISTS gpUpdate_MI_Send_byReport (Integer, Integer, Integer, Integer, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_Send_byReport(
    IN inUnitId                Integer  , --
    IN inStartDate             TDateTime,
    IN inEndDate               TDateTime,
    IN inMovementId            Integer,
    IN inMovementItemId        Integer,
    IN inGoodsId               Integer,
    IN inGoodsKindId           Integer,
    IN inPartionGoodsDate      TDateTime, --
 INOUT ioPartionCellId_1       Integer,
 INOUT ioPartionCellId_2       Integer,
 INOUT ioPartionCellId_3       Integer,
 INOUT ioPartionCellId_4       Integer,
 INOUT ioPartionCellId_5       Integer,
 INOUT ioPartionCellId_6       Integer,
 INOUT ioPartionCellId_7       Integer,
 INOUT ioPartionCellId_8       Integer,
 INOUT ioPartionCellId_9       Integer,
 INOUT ioPartionCellId_10      Integer,
 INOUT ioPartionCellName_1     TVarChar, -- 
 INOUT ioPartionCellName_2     TVarChar,
 INOUT ioPartionCellName_3     TVarChar,
 INOUT ioPartionCellName_4     TVarChar,
 INOUT ioPartionCellName_5     TVarChar,
 INOUT ioPartionCellName_6     TVarChar, -- 
 INOUT ioPartionCellName_7     TVarChar,
 INOUT ioPartionCellName_8     TVarChar,
 INOUT ioPartionCellName_9     TVarChar,
 INOUT ioPartionCellName_10    TVarChar,
    IN inSession               TVarChar  -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbPartionCellId_1 Integer;
   DECLARE vbPartionCellId_2 Integer;
   DECLARE vbPartionCellId_3 Integer;
   DECLARE vbPartionCellId_4 Integer;
   DECLARE vbPartionCellId_5 Integer;
   DECLARE vbPartionCellId_6 Integer;
   DECLARE vbPartionCellId_7 Integer;
   DECLARE vbPartionCellId_8 Integer;
   DECLARE vbPartionCellId_9 Integer;
   DECLARE vbPartionCellId_10 Integer;

   DECLARE vbPartionCellId_old_1 Integer;
   DECLARE vbPartionCellId_old_2 Integer;
   DECLARE vbPartionCellId_old_3 Integer;
   DECLARE vbPartionCellId_old_4 Integer;
   DECLARE vbPartionCellId_old_5 Integer;
   DECLARE vbPartionCellId_old_6 Integer;
   DECLARE vbPartionCellId_old_7 Integer;
   DECLARE vbPartionCellId_old_8 Integer;
   DECLARE vbPartionCellId_old_9 Integer;
   DECLARE vbPartionCellId_old_10 Integer;

   DECLARE vbIsClose_1  Boolean;
   DECLARE vbIsClose_2  Boolean;
   DECLARE vbIsClose_3  Boolean;
   DECLARE vbIsClose_4  Boolean;
   DECLARE vbIsClose_5  Boolean;
   DECLARE vbIsClose_6  Boolean;
   DECLARE vbIsClose_7  Boolean;
   DECLARE vbIsClose_8  Boolean;
   DECLARE vbIsClose_9  Boolean;
   DECLARE vbIsClose_10 Boolean;
   DECLARE vbMI_Id_check Integer;

BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Send());

     --  1
     IF ioPartionCellName_1 ILIKE '%�����%' OR TRIM (ioPartionCellName_1) = '0'
     THEN
         vbPartionCellId_1:= zc_PartionCell_RK();
     ELSE
         IF TRIM (COALESCE (ioPartionCellName_1, '')) <> ''
         THEN
             -- ���� ����� ���
             IF zfConvert_StringToNumber (ioPartionCellName_1) <> 0
             THEN
                 -- ����� �� ����
                 vbPartionCellId_1:= (SELECT Object.Id
                                      FROM Object
                                      WHERE Object.ObjectCode = zfConvert_StringToNumber (ioPartionCellName_1)
                                        AND Object.DescId     = zc_Object_PartionCell());
             ELSE
                 -- ����� �� ��������
                 vbPartionCellId_1:= (SELECT Object.Id
                                      FROM Object
                                      WHERE TRIM (Object.ValueData) ILIKE TRIM (ioPartionCellName_1)
                                        AND Object.DescId           = zc_Object_PartionCell());
             END IF;
             -- ���� �� ����� ������
             IF COALESCE (vbPartionCellId_1, 0) = 0
             THEN
                 RAISE EXCEPTION '������.�� ������� ������ <%>.', ioPartionCellName_1;
             END IF;

         ELSE
             -- ��������
             vbPartionCellId_1:= NULL;
         END IF;

     END IF;


     --  2
     IF ioPartionCellName_2 ILIKE '%�����%' OR TRIM (ioPartionCellName_2) = '0'
     THEN
         vbPartionCellId_2:= zc_PartionCell_RK();
     ELSE
         IF TRIM (COALESCE (ioPartionCellName_2, '')) <> ''
         THEN
             -- ���� ����� ���
             IF zfConvert_StringToNumber (ioPartionCellName_2) <> 0
             THEN
                 -- ����� �� ����
                 vbPartionCellId_2:= (SELECT Object.Id
                                      FROM Object
                                      WHERE Object.ObjectCode = zfConvert_StringToNumber (ioPartionCellName_2)
                                        AND Object.DescId     = zc_Object_PartionCell());
             ELSE
                 -- ����� �� ��������
                 vbPartionCellId_2:= (SELECT Object.Id
                                      FROM Object
                                      WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName_2))
                                        AND Object.DescId     = zc_Object_PartionCell());
             END IF;

             -- ���� �� ����� ������
             IF COALESCE (vbPartionCellId_2,0) = 0
             THEN
                 RAISE EXCEPTION '������.�� ������� ������ <%>.', ioPartionCellName_2;
             END IF;
         ELSE
             -- ��������
             vbPartionCellId_2:= NULL;
         END IF;

     END IF;


     --  3
     IF ioPartionCellName_3 ILIKE '%�����%' OR TRIM (ioPartionCellName_3) = '0'
     THEN
         vbPartionCellId_3:= zc_PartionCell_RK();
     ELSE
         IF TRIM (COALESCE (ioPartionCellName_3, '')) <> ''
         THEN
             --���� ����� ��� ���� �� ����, ����� �� ��������
             IF zfConvert_StringToNumber (ioPartionCellName_3) <> 0
             THEN
                 -- ����� �� ����
                 vbPartionCellId_3:= (SELECT Object.Id
                                      FROM Object
                                      WHERE Object.ObjectCode = zfConvert_StringToNumber (ioPartionCellName_3)
                                        AND Object.DescId     = zc_Object_PartionCell());
             ELSE
                 -- ����� �� ��������
                 vbPartionCellId_3:= (SELECT Object.Id
                                      FROM Object
                                      WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName_3))
                                        AND Object.DescId     = zc_Object_PartionCell());
             END IF;
             --���� �� ����� ������
             IF COALESCE (vbPartionCellId_3,0) = 0
             THEN
                 RAISE EXCEPTION '������.�� ������� ������ <%>.', ioPartionCellName_3;
             END IF;
         ELSE
             -- ��������
             vbPartionCellId_3:= NULL;
         END IF;

     END IF;


     --  4
     IF ioPartionCellName_4 ILIKE '%�����%' OR TRIM (ioPartionCellName_4) = '0'
     THEN
         vbPartionCellId_4:= zc_PartionCell_RK();
     ELSE
         IF TRIM (COALESCE (ioPartionCellName_4, '')) <> ''
         THEN
             --���� ����� ��� ���� �� ����, ����� �� ��������
             IF zfConvert_StringToNumber (ioPartionCellName_4) <> 0
             THEN
                 -- ����� �� ����
                 vbPartionCellId_4:= (SELECT Object.Id
                                      FROM Object
                                      WHERE Object.ObjectCode = zfConvert_StringToNumber (ioPartionCellName_4)
                                        AND Object.DescId     = zc_Object_PartionCell());
             ELSE
                 -- ����� �� ��������
                 vbPartionCellId_4:= (SELECT Object.Id
                                      FROM Object
                                      WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName_4))
                                        AND Object.DescId     = zc_Object_PartionCell());
             END IF;
             --���� �� ����� ������
             IF COALESCE (vbPartionCellId_4,0) = 0
             THEN
                 RAISE EXCEPTION '������.�� ������� ������ <%>.', ioPartionCellName_4;
             END IF;
         ELSE
             -- ��������
             vbPartionCellId_4:= NULL;
         END IF;

     END IF;


     --  5
     IF ioPartionCellName_5 ILIKE '%�����%' OR TRIM (ioPartionCellName_5) = '0'
     THEN
         vbPartionCellId_5:= zc_PartionCell_RK();
     ELSE
         IF TRIM (COALESCE (ioPartionCellName_5, '')) <> ''
         THEN
             -- ���� ����� ��� ���� �� ����, ����� �� ��������
             IF zfConvert_StringToNumber (ioPartionCellName_5) <> 0
             THEN
                 vbPartionCellId_5:= (SELECT Object.Id
                                      FROM Object
                                      WHERE Object.ObjectCode = zfConvert_StringToNumber (ioPartionCellName_5)
                                        AND Object.DescId     = zc_Object_PartionCell());
             ELSE
                 vbPartionCellId_5:= (SELECT Object.Id
                                      FROM Object
                                      WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName_5))
                                        AND Object.DescId     = zc_Object_PartionCell());
             END IF;
             --���� �� ����� ������
             IF COALESCE (vbPartionCellId_5,0) = 0
             THEN
                 RAISE EXCEPTION '������.�� ������� ������ <%>.', ioPartionCellName_5;
             END IF;
         ELSE
             -- ��������
             vbPartionCellId_5:= NULL;
         END IF;

     END IF;


     --  6
     IF ioPartionCellName_6 ILIKE '%�����%' OR TRIM (ioPartionCellName_6) = '0'
     THEN
         vbPartionCellId_6:= zc_PartionCell_RK();
     ELSE
         IF TRIM (COALESCE (ioPartionCellName_6, '')) <> ''
         THEN
             --���� ����� ��� ���� �� ����, ����� �� ��������
             IF zfConvert_StringToNumber (ioPartionCellName_6) <> 0
             THEN
                 vbPartionCellId_6:= (SELECT Object.Id
                                      FROM Object
                                      WHERE Object.ObjectCode = zfConvert_StringToNumber (ioPartionCellName_6)
                                        AND Object.DescId     = zc_Object_PartionCell());
             ELSE
                 vbPartionCellId_6:= (SELECT Object.Id
                                      FROM Object
                                      WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName_6))
                                        AND Object.DescId     = zc_Object_PartionCell());
             END IF;
             --���� �� ����� ������
             IF COALESCE (vbPartionCellId_6,0) = 0
             THEN
                 RAISE EXCEPTION '������.�� ������� ������ <%>.', ioPartionCellName_6;
             END IF;
         ELSE
             -- ��������
             vbPartionCellId_6:= NULL;
         END IF;

     END IF;


     --  7
     IF ioPartionCellName_7 ILIKE '%�����%' OR TRIM (ioPartionCellName_7) = '0'
     THEN
         vbPartionCellId_7:= zc_PartionCell_RK();
     ELSE
         IF TRIM (COALESCE (ioPartionCellName_7, '')) <> ''
         THEN
             -- ���� ����� ��� ���� �� ����, ����� �� ��������
             IF zfConvert_StringToNumber (ioPartionCellName_7) <> 0
             THEN
                 vbPartionCellId_7:= (SELECT Object.Id
                                      FROM Object
                                      WHERE Object.ObjectCode = zfConvert_StringToNumber (ioPartionCellName_7)
                                        AND Object.DescId     = zc_Object_PartionCell());
             ELSE
                 vbPartionCellId_7:= (SELECT Object.Id
                                      FROM Object
                                      WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName_7))
                                        AND Object.DescId     = zc_Object_PartionCell());
             END IF;
             -- ���� �� ����� ������
             IF COALESCE (vbPartionCellId_7,0) = 0
             THEN
                 RAISE EXCEPTION '������.�� ������� ������ <%>.', ioPartionCellName_7;
             END IF;
         ELSE
             -- ��������
             vbPartionCellId_7:= NULL;
         END IF;

     END IF;


     --  8
     IF ioPartionCellName_8 ILIKE '%�����%' OR TRIM (ioPartionCellName_8) = '0'
     THEN
         vbPartionCellId_8:= zc_PartionCell_RK();
     ELSE
         IF TRIM (COALESCE (ioPartionCellName_8, '')) <> ''
         THEN
             --���� ����� ��� ���� �� ����, ����� �� ��������
             IF zfConvert_StringToNumber (ioPartionCellName_8) <> 0
             THEN
                 vbPartionCellId_8:= (SELECT Object.Id
                                      FROM Object
                                      WHERE Object.ObjectCode = zfConvert_StringToNumber (ioPartionCellName_8)
                                        AND Object.DescId     = zc_Object_PartionCell());
             ELSE
                 vbPartionCellId_8:= (SELECT Object.Id
                                      FROM Object
                                      WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName_8))
                                        AND Object.DescId     = zc_Object_PartionCell());
             END IF;
             --���� �� ����� ������
             IF COALESCE (vbPartionCellId_8,0) = 0
             THEN
                 RAISE EXCEPTION '������.�� ������� ������ <%>.', ioPartionCellName_8;
             END IF;
         ELSE
             -- ��������
             vbPartionCellId_8:= NULL;
         END IF;

     END IF;


     --  9
     IF ioPartionCellName_9 ILIKE '%�����%' OR TRIM (ioPartionCellName_9) = '0'
     THEN
         vbPartionCellId_9:= zc_PartionCell_RK();
     ELSE
         IF TRIM (COALESCE (ioPartionCellName_9, '')) <> ''
         THEN
             --���� ����� ��� ���� �� ����, ����� �� ��������
             IF zfConvert_StringToNumber (ioPartionCellName_9) <> 0
             THEN
                 vbPartionCellId_9:= (SELECT Object.Id
                                      FROM Object
                                      WHERE Object.ObjectCode = zfConvert_StringToNumber (ioPartionCellName_9)
                                        AND Object.DescId     = zc_Object_PartionCell());
             ELSE
                 vbPartionCellId_9:= (SELECT Object.Id
                                      FROM Object
                                      WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName_9))
                                        AND Object.DescId     = zc_Object_PartionCell());
             END IF;
             --���� �� ����� ������
             IF COALESCE (vbPartionCellId_9,0) = 0
             THEN
                 RAISE EXCEPTION '������.�� ������� ������ <%>.', ioPartionCellName_9;
             END IF;
         ELSE
             -- ��������
             vbPartionCellId_9:= NULL;
         END IF;

     END IF;


     --  10
     IF ioPartionCellName_10 ILIKE '%�����%' OR TRIM (ioPartionCellName_10) = '0'
     THEN
         vbPartionCellId_10:= zc_PartionCell_RK();
     ELSE
         IF TRIM (COALESCE (ioPartionCellName_10, '')) <> ''
         THEN
             --���� ����� ��� ���� �� ����, ����� �� ��������
             IF zfConvert_StringToNumber (ioPartionCellName_10) <> 0
             THEN
                 vbPartionCellId_10:= (SELECT Object.Id
                                       FROM Object
                                       WHERE Object.ObjectCode = zfConvert_StringToNumber (ioPartionCellName_10)
                                         AND Object.DescId     = zc_Object_PartionCell());
             ELSE
                 vbPartionCellId_10:= (SELECT Object.Id
                                       FROM Object
                                       WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName_10))
                                         AND Object.DescId     = zc_Object_PartionCell());
             END IF;
             --���� �� ����� ������
             IF COALESCE (vbPartionCellId_1,0) = 0
             THEN
                 RAISE EXCEPTION '������.�� ������� ������ <%>.', ioPartionCellName_10;
             END IF;
         ELSE
             -- ��������
             vbPartionCellId_10:= NULL;
         END IF;

     END IF;


     -- ���� ����������� ������, ����������
     IF vbPartionCellId_2 <> zc_PartionCell_RK() AND vbPartionCellId_2 IN (vbPartionCellId_1)
     THEN vbPartionCellId_2:= NULL; END IF;

     IF vbPartionCellId_3 <> zc_PartionCell_RK() AND vbPartionCellId_3 IN (vbPartionCellId_1, vbPartionCellId_2)
     THEN vbPartionCellId_3:= NULL; END IF;

     IF vbPartionCellId_4 <> zc_PartionCell_RK() AND vbPartionCellId_4 IN (vbPartionCellId_1, vbPartionCellId_2, vbPartionCellId_3)
     THEN vbPartionCellId_4:= NULL; END IF;

     IF vbPartionCellId_5 <> zc_PartionCell_RK() AND vbPartionCellId_5 IN (vbPartionCellId_1, vbPartionCellId_2, vbPartionCellId_3, vbPartionCellId_4)
     THEN vbPartionCellId_5:= NULL; END IF;

     IF vbPartionCellId_6 <> zc_PartionCell_RK() AND vbPartionCellId_6 IN (vbPartionCellId_1, vbPartionCellId_2, vbPartionCellId_3, vbPartionCellId_4, vbPartionCellId_5)
     THEN vbPartionCellId_6:= NULL; END IF;

     IF vbPartionCellId_7 <> zc_PartionCell_RK() AND vbPartionCellId_7 IN (vbPartionCellId_1, vbPartionCellId_2, vbPartionCellId_3, vbPartionCellId_4, vbPartionCellId_5, vbPartionCellId_6)
     THEN vbPartionCellId_7:= NULL; END IF;

     IF vbPartionCellId_8 <> zc_PartionCell_RK() AND vbPartionCellId_8 IN (vbPartionCellId_1, vbPartionCellId_2, vbPartionCellId_3, vbPartionCellId_4, vbPartionCellId_5, vbPartionCellId_6, vbPartionCellId_7)
     THEN vbPartionCellId_8:= NULL; END IF;

     IF vbPartionCellId_9 <> zc_PartionCell_RK() AND vbPartionCellId_9 IN (vbPartionCellId_1, vbPartionCellId_2, vbPartionCellId_3, vbPartionCellId_4, vbPartionCellId_5, vbPartionCellId_6, vbPartionCellId_7, vbPartionCellId_8)
     THEN vbPartionCellId_9:= NULL; END IF;

     IF vbPartionCellId_10 <> zc_PartionCell_RK() AND vbPartionCellId_10 IN (vbPartionCellId_1, vbPartionCellId_2, vbPartionCellId_3, vbPartionCellId_4, vbPartionCellId_5, vbPartionCellId_6, vbPartionCellId_7, vbPartionCellId_8, vbPartionCellId_9)
     THEN vbPartionCellId_10:= NULL; END IF;


     -- 1. �������� - ��� ������ ����� ���� ������ ���� ������
     IF vbPartionCellId_1 > 0
     THEN
         vbMI_Id_check:= lpCheck_MI_Send_PartionCell (inPartionCellId   := vbPartionCellId_1
                                                    , inGoodsId         := inGoodsId
                                                    , inGoodsKindId     := inGoodsKindId
                                                    , inPartionGoodsDate:= inPartionGoodsDate
                                                    , inUserId          := vbUserId
                                                     );
         IF vbMI_Id_check > 0
         THEN
             RAISE EXCEPTION '������.��� ������ <%> %��� ����������� ������ <%> % <%> <%>.%(%)'
                           , lfGet_Object_ValueData (vbPartionCellId_1)
                           , CHR (13)
                           , zfConvert_DateToString ((SELECT COALESCE (MIDate.ValueData, Movement.OperDate)
                                                      FROM MovementItem
                                                           LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId
                                                           LEFT JOIN MovementItemDate AS MIDate ON MIDate.MovementItemId = vbMI_Id_check AND MIDate.DescId = zc_MIDate_PartionGoods()
                                                      WHERE MovementItem.Id = vbMI_Id_check
                                                     ))
                           , CHR (13)
                           , (SELECT lfGet_Object_ValueData (MI.ObjectId) FROM MovementItem AS MI WHERE MI.Id = vbMI_Id_check)
                           , (SELECT lfGet_Object_ValueData_sh (MILO.Objectid) FROM MovementItemLinkObject AS MILO WHERE MILO.MovementItemId = vbMI_Id_check AND MILO.DescId = zc_MILinkObject_GoodsKind())
                           , CHR (13)
                           , vbMI_Id_check
                            ;
         END IF;

     END IF;

     -- 2. �������� - � ������ ������ ���� ������
     IF vbPartionCellId_2 > 0
     THEN
         vbMI_Id_check:= lpCheck_MI_Send_PartionCell (inPartionCellId   := vbPartionCellId_2
                                                    , inGoodsId         := inGoodsId
                                                    , inGoodsKindId     := inGoodsKindId
                                                    , inPartionGoodsDate:= inPartionGoodsDate
                                                    , inUserId          := vbUserId
                                                     );
         IF vbMI_Id_check > 0
         THEN
             RAISE EXCEPTION '������.��� ������ <%> %��� ����������� ������ <%> % <%> <%>.'
                           , lfGet_Object_ValueData (vbPartionCellId_2)
                           , CHR (13)
                           , zfConvert_DateToString ((SELECT COALESCE (MIDate.ValueData, Movement.OperDate)
                                                      FROM MovementItem
                                                           LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId
                                                           LEFT JOIN MovementItemDate AS MIDate ON MIDate.MovementItemId = vbMI_Id_check AND MIDate.DescId = zc_MIDate_PartionGoods()
                                                      WHERE MovementItem.Id = vbMI_Id_check
                                                     ))
                           , CHR (13)
                           , (SELECT lfGet_Object_ValueData (MI.ObjectId) FROM MovementItem AS MI WHERE MI.Id = vbMI_Id_check)
                           , (SELECT lfGet_Object_ValueData_sh (MILO.Objectid) FROM MovementItemLinkObject AS MILO WHERE MILO.MovementItemId = vbMI_Id_check AND MILO.DescId = zc_MILinkObject_GoodsKind())
                            ;
         END IF;

     END IF;

     -- 3. �������� - � ������ ������ ���� ������
     IF vbPartionCellId_3 > 0
     THEN
         vbMI_Id_check:= lpCheck_MI_Send_PartionCell (inPartionCellId   := vbPartionCellId_3
                                                    , inGoodsId         := inGoodsId
                                                    , inGoodsKindId     := inGoodsKindId
                                                    , inPartionGoodsDate:= inPartionGoodsDate
                                                    , inUserId          := vbUserId
                                                     );
         IF vbMI_Id_check > 0
         THEN
             RAISE EXCEPTION '������.��� ������ <%> %��� ����������� ������ <%> % <%> <%>.'
                           , lfGet_Object_ValueData (vbPartionCellId_3)
                           , CHR (13)
                           , zfConvert_DateToString ((SELECT COALESCE (MIDate.ValueData, Movement.OperDate)
                                                      FROM MovementItem
                                                           LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId
                                                           LEFT JOIN MovementItemDate AS MIDate ON MIDate.MovementItemId = vbMI_Id_check AND MIDate.DescId = zc_MIDate_PartionGoods()
                                                      WHERE MovementItem.Id = vbMI_Id_check
                                                     ))
                           , CHR (13)
                           , (SELECT lfGet_Object_ValueData (MI.ObjectId) FROM MovementItem AS MI WHERE MI.Id = vbMI_Id_check)
                           , (SELECT lfGet_Object_ValueData_sh (MILO.Objectid) FROM MovementItemLinkObject AS MILO WHERE MILO.MovementItemId = vbMI_Id_check AND MILO.DescId = zc_MILinkObject_GoodsKind())
                            ;
         END IF;

     END IF;

     -- 4. �������� - � ������ ������ ���� ������
     IF vbPartionCellId_4 > 0
     THEN
         vbMI_Id_check:= lpCheck_MI_Send_PartionCell (inPartionCellId   := vbPartionCellId_4
                                                    , inGoodsId         := inGoodsId
                                                    , inGoodsKindId     := inGoodsKindId
                                                    , inPartionGoodsDate:= inPartionGoodsDate
                                                    , inUserId          := vbUserId
                                                     );
         IF vbMI_Id_check > 0
         THEN
             RAISE EXCEPTION '������.��� ������ <%> %��� ����������� ������ <%> % <%> <%>.'
                           , lfGet_Object_ValueData (vbPartionCellId_4)
                           , CHR (13)
                           , zfConvert_DateToString ((SELECT COALESCE (MIDate.ValueData, Movement.OperDate)
                                                      FROM MovementItem
                                                           LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId
                                                           LEFT JOIN MovementItemDate AS MIDate ON MIDate.MovementItemId = vbMI_Id_check AND MIDate.DescId = zc_MIDate_PartionGoods()
                                                      WHERE MovementItem.Id = vbMI_Id_check
                                                     ))
                           , CHR (13)
                           , (SELECT lfGet_Object_ValueData (MI.ObjectId) FROM MovementItem AS MI WHERE MI.Id = vbMI_Id_check)
                           , (SELECT lfGet_Object_ValueData_sh (MILO.Objectid) FROM MovementItemLinkObject AS MILO WHERE MILO.MovementItemId = vbMI_Id_check AND MILO.DescId = zc_MILinkObject_GoodsKind())
                            ;
         END IF;

     END IF;


     -- 5. �������� - � ������ ������ ���� ������
     IF vbPartionCellId_5 > 0
     THEN
         vbMI_Id_check:= lpCheck_MI_Send_PartionCell (inPartionCellId   := vbPartionCellId_5
                                                    , inGoodsId         := inGoodsId
                                                    , inGoodsKindId     := inGoodsKindId
                                                    , inPartionGoodsDate:= inPartionGoodsDate
                                                    , inUserId          := vbUserId
                                                     );
         IF vbMI_Id_check > 0
         THEN
             RAISE EXCEPTION '������.��� ������ <%> %��� ����������� ������ <%> % <%> <%>.'
                           , lfGet_Object_ValueData (vbPartionCellId_5)
                           , CHR (13)
                           , zfConvert_DateToString ((SELECT COALESCE (MIDate.ValueData, Movement.OperDate)
                                                      FROM MovementItem
                                                           LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId
                                                           LEFT JOIN MovementItemDate AS MIDate ON MIDate.MovementItemId = vbMI_Id_check AND MIDate.DescId = zc_MIDate_PartionGoods()
                                                      WHERE MovementItem.Id = vbMI_Id_check
                                                     ))
                           , CHR (13)
                           , (SELECT lfGet_Object_ValueData (MI.ObjectId) FROM MovementItem AS MI WHERE MI.Id = vbMI_Id_check)
                           , (SELECT lfGet_Object_ValueData_sh (MILO.Objectid) FROM MovementItemLinkObject AS MILO WHERE MILO.MovementItemId = vbMI_Id_check AND MILO.DescId = zc_MILinkObject_GoodsKind())
                            ;
         END IF;

     END IF;


     -- ���������
     IF inMovementItemId <> 0
     THEN
         --
         IF vbPartionCellId_6  <> 0 THEN RAISE EXCEPTION '������.������ � 6 ������ ��� ���������.'; END IF;
         IF vbPartionCellId_7  <> 0 THEN RAISE EXCEPTION '������.������ � 7 ������ ��� ���������.'; END IF;
         IF vbPartionCellId_8  <> 0 THEN RAISE EXCEPTION '������.������ � 8 ������ ��� ���������.'; END IF;
         IF vbPartionCellId_9  <> 0 THEN RAISE EXCEPTION '������.������ � 9 ������ ��� ���������.'; END IF;
         IF vbPartionCellId_10 <> 0 THEN RAISE EXCEPTION '������.������ � 10 ������ ��� ���������.'; END IF;

         -- 1. ��������
         IF COALESCE (vbPartionCellId_1, 0) = 0
         THEN
             -- �������
             -- PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_1(), inMovementItemId, FALSE);

             -- �������� ������
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_1(), inMovementItemId, NULL);
             -- �������� ������
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_real_1(), inMovementItemId, NULL);

         ELSEIF vbPartionCellId_1 = zc_PartionCell_RK()
         THEN
             -- �������� ������
             vbPartionCellId_old_1:= (SELECT MILO.ObjectId
                                      FROM MovementItemLinkObject AS MILO
                                      WHERE MILO.MovementItemId = inMovementItemId AND MILO.DescId = zc_MILinkObject_PartionCell_1() AND MILO.ObjectId <> zc_PartionCell_RK()
                                     );

             -- ���� ���� �������� ������
             IF vbPartionCellId_old_1 > 0
             THEN
                 -- ��������� ��������
                 PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_real_1(), inMovementItemId, vbPartionCellId_old_1);
             ELSE
                 -- ��������� �����
                 vbPartionCellId_old_1:= (SELECT MILO.ObjectId
                                          FROM MovementItemLinkObject AS MILO
                                          WHERE MILO.MovementItemId = inMovementItemId AND MILO.DescId = zc_MILinkObject_PartionCell_real_1() AND MILO.ObjectId <> zc_PartionCell_RK()
                                         );
             END IF;

             -- ��������� ������ - �����������
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_1(), inMovementItemId, vbPartionCellId_1);
             -- �������
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_1(), inMovementItemId, TRUE);
             --
             vbIsClose_1:= vbPartionCellId_old_1 > 0;

         ELSE
             -- ��������� ������
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_1(), inMovementItemId, vbPartionCellId_1);
             -- �������� ��������
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_real_1(), inMovementItemId, NULL);
             -- �������
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_1(), inMovementItemId, FALSE);
         END IF;


         -- 2. ��������
         IF COALESCE (vbPartionCellId_2, 0) = 0
         THEN
             -- �������
             -- PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_2(), inMovementItemId, FALSE);

             -- �������� ������
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_2(), inMovementItemId, NULL);
             -- �������� ������
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_real_2(), inMovementItemId, NULL);

         ELSEIF vbPartionCellId_2 = zc_PartionCell_RK()
         THEN
             -- �������� ������
             vbPartionCellId_old_2:= (SELECT MILO.ObjectId
                                      FROM MovementItemLinkObject AS MILO
                                      WHERE MILO.MovementItemId = inMovementItemId AND MILO.DescId = zc_MILinkObject_PartionCell_2() AND MILO.ObjectId <> zc_PartionCell_RK()
                                     );

             -- ���� ���� �������� ������
             IF vbPartionCellId_old_2 > 0
             THEN
                 -- ��������� ��������
                 PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_real_2(), inMovementItemId, vbPartionCellId_old_2);
             ELSE
                 -- ��������� �����
                 vbPartionCellId_old_2:= (SELECT MILO.ObjectId
                                          FROM MovementItemLinkObject AS MILO
                                          WHERE MILO.MovementItemId = inMovementItemId AND MILO.DescId = zc_MILinkObject_PartionCell_real_2() AND MILO.ObjectId <> zc_PartionCell_RK()
                                         );
             END IF;

             -- ��������� ������ - �����������
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_2(), inMovementItemId, vbPartionCellId_2);
             -- �������
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_2(), inMovementItemId, TRUE);
             --
             vbIsClose_2:= vbPartionCellId_old_2 > 0;

         ELSE
             -- ��������� ������
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_2(), inMovementItemId, vbPartionCellId_2);
             -- �������� ��������
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_real_2(), inMovementItemId, NULL);
             -- �������
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_2(), inMovementItemId, FALSE);
         END IF;


         -- 3. ��������
         IF COALESCE (vbPartionCellId_3, 0) = 0
         THEN
             -- �������
             -- PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_3(), inMovementItemId, FALSE);

             -- �������� ������
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_3(), inMovementItemId, NULL);
             -- �������� ������
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_real_3(), inMovementItemId, NULL);

         ELSEIF vbPartionCellId_3 = zc_PartionCell_RK()
         THEN
             -- �������� ������
             vbPartionCellId_old_3:= (SELECT MILO.ObjectId
                                      FROM MovementItemLinkObject AS MILO
                                      WHERE MILO.MovementItemId = inMovementItemId AND MILO.DescId = zc_MILinkObject_PartionCell_3() AND MILO.ObjectId <> zc_PartionCell_RK()
                                     );

             -- ���� ���� �������� ������
             IF vbPartionCellId_old_3 > 0
             THEN
                 -- ��������� ��������
                 PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_real_3(), inMovementItemId, vbPartionCellId_old_3);
             ELSE
                 -- ��������� �����
                 vbPartionCellId_old_3:= (SELECT MILO.ObjectId
                                          FROM MovementItemLinkObject AS MILO
                                          WHERE MILO.MovementItemId = inMovementItemId AND MILO.DescId = zc_MILinkObject_PartionCell_real_3() AND MILO.ObjectId <> zc_PartionCell_RK()
                                         );
             END IF;

             -- ��������� ������ - �����������
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_3(), inMovementItemId, vbPartionCellId_3);
             -- �������
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_3(), inMovementItemId, TRUE);
             --
             vbIsClose_3:= vbPartionCellId_old_3 > 0;

         ELSE
             -- ��������� ������
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_3(), inMovementItemId, vbPartionCellId_3);
             -- �������� ��������
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_real_3(), inMovementItemId, NULL);
             -- �������
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_3(), inMovementItemId, FALSE);
         END IF;


         -- 4. ��������
         IF COALESCE (vbPartionCellId_4, 0) = 0
         THEN
             -- �������
             -- PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_4(), inMovementItemId, FALSE);

             -- �������� ������
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_4(), inMovementItemId, NULL);
             -- �������� ������
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_real_4(), inMovementItemId, NULL);

         ELSEIF vbPartionCellId_4 = zc_PartionCell_RK()
         THEN
             -- �������� ������
             vbPartionCellId_old_4:= (SELECT MILO.ObjectId
                                      FROM MovementItemLinkObject AS MILO
                                      WHERE MILO.MovementItemId = inMovementItemId AND MILO.DescId = zc_MILinkObject_PartionCell_4() AND MILO.ObjectId <> zc_PartionCell_RK()
                                     );

             -- ���� ���� �������� ������
             IF vbPartionCellId_old_4 > 0
             THEN
                 -- ��������� ��������
                 PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_real_4(), inMovementItemId, vbPartionCellId_old_4);
             ELSE
                 -- ��������� �����
                 vbPartionCellId_old_4:= (SELECT MILO.ObjectId
                                          FROM MovementItemLinkObject AS MILO
                                          WHERE MILO.MovementItemId = inMovementItemId AND MILO.DescId = zc_MILinkObject_PartionCell_real_4() AND MILO.ObjectId <> zc_PartionCell_RK()
                                         );
             END IF;

             -- ��������� ������ - �����������
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_4(), inMovementItemId, vbPartionCellId_4);
             -- �������
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_4(), inMovementItemId, TRUE);
             --
             vbIsClose_4:= vbPartionCellId_old_4 > 0;

         ELSE
             -- ��������� ������
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_4(), inMovementItemId, vbPartionCellId_4);
             -- �������� ��������
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_real_4(), inMovementItemId, NULL);
             -- �������
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_4(), inMovementItemId, FALSE);
         END IF;


         -- 5. ��������
         IF COALESCE (vbPartionCellId_5, 0) = 0
         THEN
             -- 1.1.�������
             -- PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_5(), inMovementItemId, FALSE);

             -- 1.2.�������� ������
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_5(), inMovementItemId, NULL);
             -- 1.3.�������� ������
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_real_5(), inMovementItemId, NULL);

         ELSEIF vbPartionCellId_5 = zc_PartionCell_RK()
         THEN
             -- 2.1.�������� ������ - ����� ���������
             vbPartionCellId_old_5:= (SELECT MILO.ObjectId
                                      FROM MovementItemLinkObject AS MILO
                                      WHERE MILO.MovementItemId = inMovementItemId AND MILO.DescId = zc_MILinkObject_PartionCell_5() AND MILO.ObjectId <> zc_PartionCell_RK()
                                     );

             -- 2.2.���� ���� �������� ������
             IF vbPartionCellId_old_5 > 0
             THEN
                 -- ��������� ��������
                 PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_real_5(), inMovementItemId, vbPartionCellId_old_5);
             ELSE
                 -- ��������� �����
                 vbPartionCellId_old_5:= (SELECT MILO.ObjectId
                                          FROM MovementItemLinkObject AS MILO
                                          WHERE MILO.MovementItemId = inMovementItemId AND MILO.DescId = zc_MILinkObject_PartionCell_real_5() AND MILO.ObjectId <> zc_PartionCell_RK()
                                         );
             END IF;

             -- 2.3.��������� ������ - �����������
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_5(), inMovementItemId, vbPartionCellId_5);
             -- 2.4.�������
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_5(), inMovementItemId, TRUE);
             --
             vbIsClose_5:= vbPartionCellId_old_5 > 0;

         ELSE
             -- 3.1.��������� ������
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_5(), inMovementItemId, vbPartionCellId_5);
             -- 3.2.�������� ��������
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_real_5(), inMovementItemId, NULL);
             -- 3.3.�������
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_5(), inMovementItemId, FALSE);
         END IF;
         
     ELSE
     
         PERFORM lpUpdate_MI_Send_byReport_all (inUnitId                := inUnitId
                                              , inStartDate             := inStartDate
                                              , inEndDate               := inEndDate
                                              , inGoodsId               := inGoodsId
                                              , inGoodsKindId           := inGoodsKindId
                                              , inPartionGoodsDate      := inPartionGoodsDate
                                              , inPartionCellId_1       := ioPartionCellId_1
                                              , inPartionCellId_2       := ioPartionCellId_2
                                              , inPartionCellId_3       := ioPartionCellId_3
                                              , inPartionCellId_4       := ioPartionCellId_4
                                              , inPartionCellId_5       := ioPartionCellId_5
                                              , inPartionCellId_6       := ioPartionCellId_6
                                              , inPartionCellId_7       := ioPartionCellId_7
                                              , inPartionCellId_8       := ioPartionCellId_8
                                              , inPartionCellId_9       := ioPartionCellId_9
                                              , inPartionCellId_10      := ioPartionCellId_10
                                         
                                              , inPartionCellId_1_new   := vbPartionCellId_1
                                              , inPartionCellId_2_new   := vbPartionCellId_2
                                              , inPartionCellId_3_new   := vbPartionCellId_3
                                              , inPartionCellId_4_new   := vbPartionCellId_4
                                              , inPartionCellId_5_new   := vbPartionCellId_5
                                              , inPartionCellId_6_new   := vbPartionCellId_6
                                              , inPartionCellId_7_new   := vbPartionCellId_7
                                              , inPartionCellId_8_new   := vbPartionCellId_8
                                              , inPartionCellId_9_new   := vbPartionCellId_9
                                              , inPartionCellId_10_new  := vbPartionCellId_10
                                              , inUserId                := vbUserId
                                               );


     END IF;


     -- ������� Id
     ioPartionCellId_1 := vbPartionCellId_1;
     ioPartionCellId_2 := vbPartionCellId_2;
     ioPartionCellId_3 := vbPartionCellId_3;
     ioPartionCellId_4 := vbPartionCellId_4;
     ioPartionCellId_5 := vbPartionCellId_5;
     ioPartionCellId_6 := vbPartionCellId_6;
     ioPartionCellId_7 := vbPartionCellId_7;
     ioPartionCellId_8 := vbPartionCellId_8;
     ioPartionCellId_9 := vbPartionCellId_9;
     ioPartionCellId_10:= vbPartionCellId_10;

     -- ������� Name
     ioPartionCellName_1  := zfCalc_PartionCell_IsClose ((SELECT Object.ValueData FROM Object WHERE Object.Id = COALESCE (vbPartionCellId_old_1, vbPartionCellId_1)), vbIsClose_1);
     ioPartionCellName_2  := zfCalc_PartionCell_IsClose ((SELECT Object.ValueData FROM Object WHERE Object.Id = COALESCE (vbPartionCellId_old_2, vbPartionCellId_2)), vbIsClose_2);
     ioPartionCellName_3  := zfCalc_PartionCell_IsClose ((SELECT Object.ValueData FROM Object WHERE Object.Id = COALESCE (vbPartionCellId_old_3, vbPartionCellId_3)), vbIsClose_3);
     ioPartionCellName_4  := zfCalc_PartionCell_IsClose ((SELECT Object.ValueData FROM Object WHERE Object.Id = COALESCE (vbPartionCellId_old_4, vbPartionCellId_4)), vbIsClose_4);
     ioPartionCellName_5  := zfCalc_PartionCell_IsClose ((SELECT Object.ValueData FROM Object WHERE Object.Id = COALESCE (vbPartionCellId_old_5, vbPartionCellId_5)), vbIsClose_5);
     ioPartionCellName_6  := zfCalc_PartionCell_IsClose ((SELECT Object.ValueData FROM Object WHERE Object.Id = COALESCE (vbPartionCellId_old_6, vbPartionCellId_6)), vbIsClose_6);
     ioPartionCellName_7  := zfCalc_PartionCell_IsClose ((SELECT Object.ValueData FROM Object WHERE Object.Id = COALESCE (vbPartionCellId_old_7, vbPartionCellId_7)), vbIsClose_7);
     ioPartionCellName_8  := zfCalc_PartionCell_IsClose ((SELECT Object.ValueData FROM Object WHERE Object.Id = COALESCE (vbPartionCellId_old_8, vbPartionCellId_8)), vbIsClose_8);
     ioPartionCellName_9  := zfCalc_PartionCell_IsClose ((SELECT Object.ValueData FROM Object WHERE Object.Id = COALESCE (vbPartionCellId_old_9, vbPartionCellId_9)), vbIsClose_9);
     ioPartionCellName_10 := zfCalc_PartionCell_IsClose ((SELECT Object.ValueData FROM Object WHERE Object.Id = COALESCE (vbPartionCellId_old_10,vbPartionCellId_10)),vbIsClose_10);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 04.01.24         *
*/

-- ����
--