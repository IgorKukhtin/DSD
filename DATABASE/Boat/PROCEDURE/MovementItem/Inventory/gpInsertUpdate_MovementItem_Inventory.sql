-- Function: gpInsertUpdate_MovementItem_Inventory()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory (Integer,Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory (Integer,Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Inventory(
 INOUT ioId                                 Integer   , -- ���� ������� <������� ���������>
    IN inMovementId                         Integer   , -- ���� ������� <��������>
    IN inMovementId_OrderClient             Integer   , -- ����� �������
    IN inGoodsId                            Integer   , -- ������
    IN inPartionId                          Integer   , -- ������  
    IN inPartnerId                          Integer   , -- ���������
 INOUT ioAmount                             TFloat    , -- ���������� 
    IN inTotalCount                         TFloat    , -- ���������� �����
    IN inTotalCount_old                     TFloat    , -- ���������� �����
 INOUT ioPrice                              TFloat    , -- ����
   OUT outAmountSumm                        TFloat    , -- ����� ���������
    IN inPartNumber                         TVarChar  , --       
 INOUT ioPartionCellName                    TVarChar  , -- ��� ��� ��������
    IN inComment                            TVarChar  , -- ����������
    IN inSession                            TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbPartionCellId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Inventory());
     vbUserId:= lpGetUserBySession (inSession);


     -- ������
     -- IF ioAmount = 0 THEN ioAmount:= 1; END IF;

     --������� ������ ��������, ���� ��� ����� �������
     IF COALESCE (ioPartionCellName, '') <> '' THEN
         -- !!!����� �� !!! 
         --���� ����� ��� ���� �� ����, ����� �� ��������
         IF zfConvert_StringToNumber (ioPartionCellName) <> 0
         THEN
             vbPartionCellId:= (SELECT Object.Id
                                FROM Object
                                WHERE Object.ObjectCode = zfConvert_StringToNumber (ioPartionCellName)
                                  AND Object.DescId     = zc_Object_PartionCell()
                               );
             --���� �� ����� ������
             IF COALESCE (vbPartionCellId,0) = 0
             THEN
                 RAISE EXCEPTION '������.�� ������� ������ � ����� <%>.', ioPartionCellName;
             END IF;
         ELSE
             vbPartionCellId:= (SELECT Object.Id
                                FROM Object
                                WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName))
                                  AND Object.DescId     = zc_Object_PartionCell()
                               );
             --���� �� ����� �������
             IF COALESCE (vbPartionCellId,0) = 0
             THEN
                 --
                 vbPartionCellId := gpInsertUpdate_Object_PartionCell (ioId	     := 0                                            ::Integer
                                                                     , inCode    := lfGet_ObjectCode(0, zc_Object_PartionCell()) ::Integer
                                                                     , inName    := TRIM (ioPartionCellName)                          ::TVarChar
                                                                     , inLevel   := 0           ::TFloat
                                                                     , inComment := ''          ::TVarChar
                                                                     , inSession := inSession   ::TVarChar
                                                                      );
    
             END IF;
         END IF;
         --
         ioPartionCellName := (SELECT Object.ValueData FROM Object WHERE Object.Id = vbPartionCellId); 
     ELSE 
         vbPartionCellId := NULL ::Integer;
     END IF;


     -- ������������ ��������� �� ���������
     SELECT tmp.ioId, tmp.ioAmount, tmp.ioPrice, tmp.outAmountSumm
            INTO ioId, ioAmount, ioPrice, outAmountSumm
     FROM lpInsertUpdate_MovementItem_Inventory (ioId              := ioId
                                               , inMovementId      := inMovementId
                                               , inMovementId_OrderClient := inMovementId_OrderClient
                                               , inGoodsId         := inGoodsId
                                               , inPartnerId       := inPartnerId
                                               , inPartionCellId   := vbPartionCellId
                                               , ioAmount          := ioAmount
                                               , inTotalCount      := inTotalCount
                                               , inTotalCount_old  := inTotalCount_old
                                               , ioPrice           := ioPrice
                                               , inPartNumber      := inPartNumber
                                               , inComment         := inComment
                                               , inUserId          := vbUserId
                                                ) AS tmp;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 08.01.24         *
 17.02.22         *
*/

-- ����
-- 